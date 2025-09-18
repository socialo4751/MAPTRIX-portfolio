package kr.or.ddit.startup.show.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.startup.design.mapper.DesignMapper;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.mapper.ShowDesignMapper;
import kr.or.ddit.startup.show.service.ShowDesignService;
import kr.or.ddit.startup.show.vo.SuShowCommentVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor 
public class ShowDesignServiceImpl implements ShowDesignService {

    private final ShowDesignMapper showDesignMapper;
	private final DesignMapper designMapper;
	private final FileService fileService;
	private final NotificationService notificationService;
	            
    // 자랑게시판 리스트 목록 조회
    @Override
    public List<SuShowPostVO> selectShowPostList(Map<String, Object> paramMap) {
        return showDesignMapper.selectShowPostList(paramMap);
    }
    
    // 월간 베스트 게시물 3개 조회
    @Override
    public List<SuShowPostVO> getBestPostsOfMonth(String yearMonth) {
        Map<String, String> params = new HashMap<>();
        params.put("yearMonth", yearMonth);
        return showDesignMapper.selectBestPostsOfMonth(params);
    }
    
    // 자랑게시판 리스트 페이징 처리
    @Override
    public int selectTotalCount(Map<String, Object> paramMap) {
        return showDesignMapper.selectTotalCount(paramMap);
    }
    
    // 게시물 상세 정보 가져오기
    @Override
    public SuShowPostVO getPostDetail(String postId) {
        // 1. 기존처럼 게시물 정보를 먼저 조회합니다.
        SuShowPostVO post = showDesignMapper.selectShowPostDetail(postId);

        // 2. 게시물이 존재하고, 연결된 designId가 있을 경우에만 실행합니다.
        if (post != null && post.getDesignId() > 0) {
            // 3. 게시물의 designId를 이용해 원본 디자인 정보를 조회합니다.
            SuShowDesignVO design = designMapper.selectDesignById(post.getDesignId());
            if (design != null) {
                // 4. 조회한 디자인의 이름을 post 객체에 담아줍니다.
                post.setDesignName(design.getDesignName());
            }
        }
        
        // 5. 이제 post 객체는 designName을 포함한 상태로 반환됩니다.
        return post;
    }
    
    @LogEvent(eventType="CREATE", feature="SHOW") 
    @Transactional
    @Override
    public int insertShowPost(SuShowPostVO suShowPostVO) {
        // 1. 게시글 정보 등록
        int res = showDesignMapper.insertShowPost(suShowPostVO);

        // 2. 해시태그 정보 등록 (기존 로직 유지)
        if (res > 0 && suShowPostVO.getHashtags() != null && !suShowPostVO.getHashtags().trim().isEmpty()) {
            List<String> hashtagList = suShowPostVO.getHashtagList();
            Map<String, Object> hashtagParams = new HashMap<>();
            hashtagParams.put("postId", suShowPostVO.getPostId()); 
            hashtagParams.put("hashtagList", hashtagList);
            showDesignMapper.insertHashtags(hashtagParams);
        }
        
        return res;
    }
        
    // 게시글의 IS_DELETED 상태만 'Y'로 변경하는 논리적 삭제만 수행
    @LogEvent(eventType="DELETE", feature="SHOW") 
    @Transactional
    @Override
    public int deletePost(String postId, String userId) {

        // Mapper의 deletePost는 postId와 userId가 일치할 때만 동작하므로,
        // 권한 확인과 논리적 삭제가 이 한 줄로 처리됩니다.
        return showDesignMapper.deletePost(postId, userId);
    }
    
    // 게시글 수정
    @LogEvent(eventType="UPDATE", feature="SHOW")
    @Transactional
    @Override
    public int updatePost(SuShowPostVO suShowPostVO, List<Integer> deleteFileSns, MultipartFile[] newFiles) {
        
        // 1. 새로 첨부된 파일이 실제로 있는지 확인합니다.
        boolean hasNewFiles = false;
        if (newFiles != null) {
            for (MultipartFile file : newFiles) {
                if (file != null && !file.isEmpty()) {
                    hasNewFiles = true;
                    break;
                }
            }
        }

        // 2. 새로운 파일이 있다면, 새 파일 그룹을 생성하고 VO에 그 번호를 설정합니다.
        if (hasNewFiles) {

            // FileService의 uploadFiles 메서드를 파라미터 2개로 호출하면 항상 새 그룹이 생성됩니다.
            long newFileGroupNo = fileService.uploadFiles(newFiles, "showDesign");
            suShowPostVO.setFileGroupNo(newFileGroupNo);
        }
        // (새로운 파일이 없다면, 뷰에서 넘어온 기존 fileGroupNo가 VO에 그대로 담겨있게 됩니다.)

        // 3. 게시글 정보를 DB에 최종 업데이트합니다. (Mapper는 fileGroupNo도 업데이트하도록 수정되어야 합니다)
        int result = showDesignMapper.updatePost(suShowPostVO);

        return result;
    }

    
    // 특정 사용자가 작성한 디자인 목록 조회
    @Override
    public List<SuShowDesignVO> getDesignsByUserId(String userId) {
        return showDesignMapper.getDesignsByUserId(userId);
    }
   
// ======= 좋아요/조회수 관련 메서드 ============
   // 자랑 게시판 조회수 증가
	@Override
	public int incrementViewCount(String postId) {
	    return showDesignMapper.incrementViewCount(postId);
	}
	
	// 현재 좋아요 수 가져오기
	@Override
	public int getLikeCount(String postId) {
	    return showDesignMapper.selectLikeCount(postId);
	}
	// 사용자가 해당 게시물에 좋아요를 눌렀는지 확인
	@Override
	public boolean checkIfUserLiked(String postId, String userId) {
	    return showDesignMapper.checkLikeExists(postId, userId) > 0;
	}
	// 좋아요 상태 토글
	@LogEvent(eventType="LIKE", feature="SHOW")
	@Transactional 
	@Override
	public boolean toggleLikeStatus(String postId, String userId) {
	    boolean isLikedNow;
	    if (showDesignMapper.checkLikeExists(postId, userId) > 0) {
	        showDesignMapper.deleteLike(postId, userId);
	        showDesignMapper.decrementLikeCount(postId);
	        isLikedNow = false;
	    } else {
	        showDesignMapper.insertLike(postId, userId);
	        showDesignMapper.incrementLikeCount(postId);
	        isLikedNow = true;
	    }
	    return isLikedNow;
	}
    
// ======= 댓글 관련 메서드 ============
	// 특정 게시물의 댓글 목록 조회 
	
	@Override
	public List<SuShowCommentVO> getCommentList(String postId) {
        return showDesignMapper.selectCommentList(postId);
	}
	
	// 댓글 수정
	@LogEvent(eventType="UPDATE", feature="SHOW_COMMENT")
    @Transactional
    @Override
    public int updateComment(SuShowCommentVO suShowCommentVO) {
        return showDesignMapper.updateComment(suShowCommentVO);
    }

    // 댓글 삭제
	@LogEvent(eventType="DELETE", feature="SHOW_COMMENT")
    @Transactional
    @Override
    public int deleteComment(int commentId, String userId) {
        return showDesignMapper.deleteComment(commentId, userId);
    }
    
    // 부모 댓글의 depth 조회
    @Override
    public Integer getCommentDepth(int parentId) {
        return showDesignMapper.selectCommentDepth(parentId);
    }
    
    /**
     * [수정] 댓글/대댓글 등록 시 알림을 전송하는 로직 추가
     * - 일반 댓글: 원본 게시물 작성자에게 알림
     * - 대댓글: 부모 댓글 작성자에게 알림
     * @param newComment 등록할 댓글 정보
     * @return 댓글 등록 성공 여부 (1: 성공, 0: 실패)
     */
    @LogEvent(eventType="CREATE", feature="SHOW_COMMENT")
    @Transactional
    @Override
    public int insertComment(SuShowCommentVO newComment) {
        // 1. 댓글을 DB에 먼저 등록합니다.
        int result = showDesignMapper.insertComment(newComment);
        log.info("자랑게시판 댓글 등록 시도 결과: {}", result);

        // --- ★★★★★ 댓글 등록 성공 시, 알림 생성 로직 호출 ★★★★★ ---
        if (result > 0) {
            sendNotificationForNewComment(newComment);
        }
        // --------------------------------------------------------

        return result;
    }

    /**
     * [추가] 새로운 댓글/답글에 대한 알림을 생성하고 전송하는 private 메소드
     * @param newComment 방금 생성된 댓글 VO
     */
    private void sendNotificationForNewComment(SuShowCommentVO newComment) {
        // 대댓글인 경우 (부모 댓글이 있는 경우)
        if (newComment.getParentId() != null && newComment.getParentId() > 0) {
            // 부모 댓글의 정보를 조회
            SuShowCommentVO parentComment = showDesignMapper.selectCommentById(newComment.getParentId());

            // 부모 댓글이 존재하고, 자기 자신의 댓글에 답글을 단 게 아닐 경우 알림 발송
            if (parentComment != null && !parentComment.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(parentComment.getUserId()); // 알림 받을 사람: 부모 댓글 작성자
                
                String commenterId = newComment.getUserId().split("@")[0];
                String message = "'" + commenterId + "'님이 회원님의 댓글에 답글을 남겼습니다.";
                notification.setMessage(message);
                
                // 링크는 원본 게시물로 연결
                String url = "/start-up/show/detail/" + newComment.getPostId();
                notification.setTargetUrl(url);

                notificationService.createNotification(notification);
                log.info("자랑게시판 대댓글 알림이 생성되었습니다. 수신자 ID: {}", parentComment.getUserId());
            }
        }
        // 최상위 댓글인 경우 (게시글에 바로 다는 댓글)
        else {
            // 원본 게시물의 정보를 조회
            SuShowPostVO originalPost = showDesignMapper.selectShowPostDetail(String.valueOf(newComment.getPostId()));

            // 게시물이 존재하고, 자기 자신의 게시글에 댓글을 단 게 아닐 경우 알림 발송
            if (originalPost != null && !originalPost.getUserId().equals(newComment.getUserId())) {
                UserNotifiedVO notification = new UserNotifiedVO();
                notification.setUserId(originalPost.getUserId()); // 알림 받을 사람: 원본 게시물 작성자

                String commenterId = newComment.getUserId().split("@")[0];
                String message = "'" + commenterId + "'님이 회원님의 자랑 게시글에 댓글을 남겼습니다.";
                notification.setMessage(message);
                
                String url = "/start-up/show/detail/" + newComment.getPostId();
                notification.setTargetUrl(url);

                notificationService.createNotification(notification);
                log.info("자랑게시판 댓글 알림이 생성되었습니다. 수신자 ID: {}", originalPost.getUserId());
            }
        }
    }
}