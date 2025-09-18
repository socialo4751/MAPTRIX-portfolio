package kr.or.ddit.community.free.service.impl;

import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.community.free.mapper.FreeCommentMapper;
import kr.or.ddit.community.free.mapper.FreePostMapper;
import kr.or.ddit.community.free.service.FreeCommentService;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class FreeCommentServiceImpl implements FreeCommentService {

    private final FreeCommentMapper freeCommentMapper;
    private final FreePostMapper freePostMapper;
    private final NotificationService notificationService;
    
    @LogEvent(eventType="CREATE", feature="FREE_COMMENT")
    @Override
    @Transactional
    public void createComment(CommFreeCommentVO commentVO) {
        log.info("createComment() 실행 - commentVO: {}", commentVO);
        int result = freeCommentMapper.insertComment(commentVO);
        if (result == 0) {
            log.error("댓글 작성 실패: DB 반영 안됨. commentVO: {}", commentVO);
            throw new RuntimeException("댓글 작성 실패: 데이터베이스 반영 오류.");
        }
        sendNotificationForNewComment(commentVO);
    }
    
    @Override
    public List<CommFreeCommentVO> getCommentsByPostId(int postId) {
        log.info("getCommentsByPostId() 실행 - postId: {}", postId);
        return freeCommentMapper.selectFreeCommentsByPostId(postId);
    }
    
    @LogEvent(eventType = "UPDATE", feature = "FREE_COMMENT")
    @Override
    @Transactional
    public void updateComment(CommFreeCommentVO commentVO, String currentUserId) throws IllegalAccessException {
        log.info("updateComment() 실행 - commentVO: {}, currentUserId: {}", commentVO, currentUserId);

        CommFreeCommentVO existingComment = freeCommentMapper.selectCommentById(commentVO.getCommentId());
        if (existingComment == null) {
            log.warn("수정할 댓글을 찾을 수 없습니다. commentId: {}", commentVO.getCommentId());
            throw new IllegalArgumentException("수정할 댓글을 찾을 수 없습니다.");
        }

        if (!existingComment.getUserId().equals(currentUserId)) {
            log.warn("댓글 수정 권한이 없습니다. commentId: {}, 요청 userId: {}",
                      commentVO.getCommentId(), currentUserId);
            throw new IllegalAccessException("댓글 수정 권한이 없습니다.");
        }

        int result = freeCommentMapper.updateComment(commentVO);
        if (result == 0) {
            log.error("댓글 업데이트 실패: DB 반영 안됨. commentVO: {}", commentVO);
            throw new RuntimeException("댓글 수정 실패: 데이터베이스 반영 오류.");
        }
        log.info("댓글 {} 수정 성공", commentVO.getCommentId());
    }
    
    @LogEvent(eventType = "DELETE", feature = "FREE_COMMENT")
    @Override
    @Transactional
    public void deleteComment(int commentId, String currentUserId, String userRole) throws IllegalAccessException {
        log.info("deleteComment() 실행 - commentId: {}, currentUserId: {}, userRole: {}",
                 commentId, currentUserId, userRole);

        // 1) 댓글 존재 확인
        CommFreeCommentVO existingComment = freeCommentMapper.selectCommentById(commentId);
        if (existingComment == null) {
            log.warn("삭제할 댓글을 찾을 수 없습니다. commentId: {}", commentId);
            throw new IllegalArgumentException("삭제할 댓글을 찾을 수 없습니다.");
        }

        // 2) 댓글이 속한 게시글(작성자 권한 확인용)
        CommFreePostVO existingPost = freePostMapper.selectPostById(existingComment.getPostId());
        if (existingPost == null) {
            log.warn("댓글이 속한 게시글을 찾을 수 없습니다. postId: {}", existingComment.getPostId());
            throw new IllegalArgumentException("댓글이 속한 게시글을 찾을 수 없습니다.");
        }

        // 3) 권한 체크: 댓글 작성자 OR 게시글 작성자 OR 관리자
        boolean isCommentAuthor = Objects.equals(existingComment.getUserId(), currentUserId);
        boolean isPostAuthor    = Objects.equals(existingPost.getUserId(), currentUserId);
        boolean isAdmin         = userRole != null && userRole.toUpperCase().contains("ADMIN");

        if (!(isCommentAuthor || isPostAuthor || isAdmin)) {
            log.warn("댓글 삭제 권한이 없습니다. commentId: {}, 요청 userId: {}", commentId, currentUserId);
            throw new IllegalAccessException("댓글 삭제 권한이 없습니다.");
        }

        // 4) 소프트 삭제 (0건이면 예외)
        int result = freeCommentMapper.softDeleteFreeComment(commentId);
        if (result == 0) {
            log.error("댓글 논리적 삭제 실패: DB 반영 안됨. commentId: {}", commentId);
            throw new RuntimeException("댓글 삭제 실패: 데이터베이스 반영 오류.");
        }

        log.info("댓글 {} 논리적 삭제 성공", commentId);
    }
    
    @Override
    public CommFreeCommentVO getCommentById(int commentId) {
        log.info("getCommentById() 실행 - commentId: {}", commentId);
        return freeCommentMapper.selectCommentById(commentId);
    }
    
    /**
     * [최종 수정] 새로운 댓글/답글에 대한 알림을 생성하고 전송하는 private 헬퍼 메소드
     */
    private void sendNotificationForNewComment(CommFreeCommentVO newComment) {
        // ★★★★★ URL 생성을 위해 어떤 경우든 원본 게시물 정보가 필요합니다 ★★★★★
        CommFreePostVO originalPost = freePostMapper.selectPostById(newComment.getPostId());
        
        // 게시물이 없으면 알림을 생성하지 않고 종료
        if (originalPost == null) {
            log.warn("알림 생성 실패: 원본 게시물을 찾을 수 없습니다. postId: {}", newComment.getPostId());
            return;
        }

        // 대댓글인 경우
        if (newComment.getParentId() != null && newComment.getParentId() > 0) {
            CommFreeCommentVO parentComment = freeCommentMapper.selectCommentById(newComment.getParentId());

            if (parentComment != null && !parentComment.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(parentComment.getUserId());
                String commenterId = newComment.getUserId().split("@")[0];
                String message = "'" + commenterId + "'님이 회원님의 댓글에 답글을 남겼습니다.";
                notification.setMessage(message);
                
                // ★★★★★ 최종 URL: "{게시판 주소}?postId={상세보기할 글번호}" ★★★★★
                String url = "/comm/free/" + originalPost.getBizCodeId() + "?postId=" + newComment.getPostId();
                notification.setTargetUrl(url);

                notificationService.createNotification(notification);
                log.info("자유게시판 대댓글 알림이 생성되었습니다. 수신자 ID: {}", parentComment.getUserId());
            }
        }
        // 최상위 댓글인 경우
        else {
            if (!originalPost.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(originalPost.getUserId());
                String commenterId = newComment.getUserId().split("@")[0];
                String message = "'" + commenterId + "'님이 회원님의 자유게시판 글에 댓글을 남겼습니다.";
                notification.setMessage(message);
                
                // ★★★★★ 최종 URL: "{게시판 주소}?postId={상세보기할 글번호}" ★★★★★
                String url = "/comm/free/" + originalPost.getBizCodeId() + "?postId=" + newComment.getPostId();
                notification.setTargetUrl(url);

                notificationService.createNotification(notification);
                log.info("자유게시판 댓글 알림이 생성되었습니다. 수신자 ID: {}", originalPost.getUserId());
            }
        }
    }
}
