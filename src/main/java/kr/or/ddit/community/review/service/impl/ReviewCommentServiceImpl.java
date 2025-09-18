package kr.or.ddit.community.review.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 트랜잭션 관리를 위해 추가

import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.community.review.mapper.ReviewCommentMapper;
import kr.or.ddit.community.review.mapper.ReviewPostMapper;
import kr.or.ddit.community.review.service.ReviewCommentService;
import kr.or.ddit.community.review.vo.CommReviewCommentVO;
import kr.or.ddit.community.review.vo.CommReviewPostVO;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * ReviewCommentService 구현체
 * 이 클래스는 ReviewCommentMapper를 사용하여 댓글 관련 비즈니스 로직을 처리합니다.
 */
@Slf4j
@Service
@RequiredArgsConstructor // [수정] @Autowired 생성자 대신 Lombok 사용
public class ReviewCommentServiceImpl implements ReviewCommentService {

    private final ReviewCommentMapper commentMapper;
    
    // --- [추가] 알림 생성을 위해 필요한 서비스와 매퍼 주입 ---
    private final ReviewPostMapper postMapper;
    private final NotificationService notificationService;
    // ----------------------------------------------------

    /* [삭제] @RequiredArgsConstructor가 생성자를 자동으로 만들어주므로 기존 생성자는 삭제합니다.
    @Autowired
    public ReviewCommentServiceImpl(ReviewCommentMapper commentMapper) {
        this.commentMapper = commentMapper;
    }
    */
    /**
     * 새로운 댓글을 작성하고 데이터베이스에 저장합니다.
     * 대댓글의 경우 depth 및 parentId 처리 로직이 포함됩니다.
     * @param commentVO 작성할 댓글 정보 VO
     * @return 댓글 작성 성공 여부 (true/false)
     */
    @LogEvent(eventType="CREATE", feature="REVIEW_COMMENT")
    @Override
    @Transactional
    public boolean createComment(CommReviewCommentVO commentVO) {
        log.info("createComment() 실행 - commentVO: {}", commentVO);

        if (commentVO.getContent() == null || commentVO.getContent().trim().isEmpty()) {
            log.warn("댓글 내용이 비어있습니다.");
            return false;
        }

        // 대댓글 깊이 설정 로직 (기존과 동일)
        if (commentVO.getParentId() != null && commentVO.getParentId() > 0) {
            CommReviewCommentVO parentComment = commentMapper.selectCommentById(commentVO.getParentId());
            if (parentComment != null) {
                commentVO.setDepth(parentComment.getDepth() + 1);
            } else {
                log.warn("유효하지 않은 부모 댓글 ID({})", commentVO.getParentId());
                return false;
            }
        } else {
            commentVO.setDepth(0);
        }

        int result = commentMapper.insertComment(commentVO);
        log.info("댓글 작성 시도 (userId: {}), 결과: {}", commentVO.getUserId(), (result > 0 ? "성공" : "실패"));

        // --- ★★★★★ 댓글 작성 성공 시, 알림 생성 로직 호출 ★★★★★ ---
        if (result > 0) {
            sendNotificationForNewComment(commentVO);
        }
        // --------------------------------------------------------

        return result > 0;
    }

   
    /**
     * 특정 게시글 ID에 속한 모든 댓글 목록을 조회합니다.
     * 대댓글 포함 계층 구조로 반환될 수 있습니다.
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 목록
     */
    @Override
    public List<CommReviewCommentVO> getCommentsByPostId(int postId) {
        log.info("게시글 ID {}의 댓글 목록 조회 요청", postId);
        return commentMapper.selectCommentsByPostId(postId);
    }

    /**
     * 특정 댓글 ID에 해당하는 단일 댓글 정보를 조회합니다.
     * 주로 댓글 수정/삭제 시 권한 검증을 위해 사용됩니다.
     * @param commentId 조회할 댓글 ID
     * @return 조회된 댓글 정보 VO (없으면 null)
     */
    @Override
    public CommReviewCommentVO getCommentById(int commentId) {
        log.info("댓글 ID {}로 단일 댓글 조회 요청", commentId);
        // ReviewCommentMapper를 사용하여 DB에서 단일 댓글을 조회합니다.
        // selectCommentById는 ReviewCommentMapper 인터페이스에 정의되어 있어야 합니다.
        return commentMapper.selectCommentById(commentId);
    }

    /**
     * 댓글 정보를 업데이트합니다.
     * @param commentVO 업데이트할 댓글 정보 VO
     * @return 댓글 업데이트 성공 여부 (true/false)
     */
    @LogEvent(eventType="UPDATE", feature="REVIEW_COMMENT")
    @Override
    @Transactional // 댓글 수정 작업은 하나의 트랜잭션으로 묶습니다.
    public boolean modifyComment(CommReviewCommentVO commentVO) {
        log.info("modifyComment() 실행 - commentVO: {}", commentVO);

        // 1. 댓글 내용 유효성 검사 (수정 시에도 필요)
        if (commentVO.getContent() == null || commentVO.getContent().trim().isEmpty()) {
            log.warn("수정할 댓글 내용이 비어있습니다. 댓글 수정을 실패합니다. commentId: {}", commentVO.getCommentId());
            return false;
        }

        // 2. 매퍼를 통해 댓글 업데이트
        // updateComment 메서드는 성공 시 1을 반환한다고 가정
        int result = commentMapper.updateComment(commentVO);
        log.info("댓글 수정 시도 (commentId: {}), 결과: {}", commentVO.getCommentId(), (result > 0 ? "성공" : "실패"));
        return result > 0; // DB 업데이트 성공 여부를 boolean으로 반환
    }

    /**
     * 특정 댓글을 삭제(논리적 삭제)합니다.
     * 대댓글이 있는 경우 처리 로직이 포함될 수 있습니다.
     * @param commentId 삭제할 댓글 ID
     * @return 댓글 삭제 성공 여부 (true/false)
     */
    @LogEvent(eventType="DELETE", feature="REVIEW_COMMENT")
    @Override
    @Transactional // 댓글 삭제 작업은 하나의 트랜잭션으로 묶습니다.
    public boolean removeComment(int commentId) {
        log.info("removeComment() 실행 - commentId: {}", commentId);

        // 1. 매퍼를 통해 댓글 논리적 삭제
        // deleteComment 메서드는 성공 시 1을 반환한다고 가정 (논리적 삭제 UPDATE 쿼리)
        int result = commentMapper.deleteCommentsByPostId(commentId);
        log.info("댓글 논리적 삭제 시도 (commentId: {}), 결과: {}", commentId, (result > 0 ? "성공" : "실패"));
        return result > 0; // DB 삭제 성공 여부를 boolean으로 반환
    }
    
  
    /**===알림 로직===
     * 새로운 댓글/답글에 대한 알림을 생성하고 전송하는 private 메소드
     * @param newComment 방금 생성된 댓글 VO
     */
    private void sendNotificationForNewComment(CommReviewCommentVO newComment) {
        // 답글인 경우 (대댓글)
        if (newComment.getParentId() != null && newComment.getParentId() > 0) {
            CommReviewCommentVO parentComment = commentMapper.selectCommentById(newComment.getParentId());
            // 부모 댓글이 있고, 자기 자신의 댓글에 답글을 단 게 아닐 경우
            if (parentComment != null && !parentComment.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(parentComment.getUserId()); // 알림 받을 사람: 부모 댓글 작성자
                
                String message = "'" + newComment.getUserId().split("@")[0] + "'님이 회원님의 댓글에 답글을 남겼습니다.";
                notification.setMessage(message);
                
                // ★★★★★ [수정] 답글의 경우에도 targetUrl을 생성합니다. 링크는 원본 게시물로. ★★★★★
                String url = "/comm/review/detail?postId=" + newComment.getPostId();
                
     notification.setTargetUrl(url);
     notificationService.createNotification(notification);
            }
        } 
        // 최상위 댓글인 경우
        else {
            CommReviewPostVO post = postMapper.selectPostById(newComment.getPostId());
            // 게시글이 있고, 자기 자신의 게시글에 댓글을 단 게 아닐 경우
            if (post != null && !post.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(post.getUserId()); // 알림 받을 사람: 게시글 작성자
                
                String url = "/comm/review/detail?postId=" + newComment.getPostId();
                notification.setTargetUrl(url);

                String message = "'" + newComment.getUserId().split("@")[0] + "'님이 회원님의 후기 글에 댓글을 남겼습니다.";
                notification.setMessage(message);
                
                notificationService.createNotification(notification);
            }
        }
    }

}