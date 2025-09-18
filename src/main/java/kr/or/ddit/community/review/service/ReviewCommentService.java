package kr.or.ddit.community.review.service;

import java.util.List;

import kr.or.ddit.community.review.vo.CommReviewCommentVO;

/**
 * ReviewCommentService 인터페이스
 * 댓글 관련 비즈니스 로직을 정의합니다.
 */
public interface ReviewCommentService {
    /**
     * 새로운 댓글을 작성하고 데이터베이스에 저장합니다.
     * 대댓글의 경우 depth 및 parentId 처리 로직이 포함됩니다.
     * @param commentVO 작성할 댓글 정보 VO
     * @return 댓글 작성 성공 여부 (true/false)
     */
    boolean createComment(CommReviewCommentVO commentVO);

    /**
     * 특정 게시글 ID에 속한 모든 댓글 목록을 조회합니다.
     * 대댓글 포함 계층 구조로 반환될 수 있습니다.
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 목록
     */
    List<CommReviewCommentVO> getCommentsByPostId(int postId);

    /**
     * 댓글 정보를 업데이트합니다.
     * @param commentVO 업데이트할 댓글 정보 VO
     * @return 댓글 업데이트 성공 여부 (true/false)
     */
    boolean modifyComment(CommReviewCommentVO commentVO);
    
    /**
     * 특정 댓글 ID에 해당하는 단일 댓글 정보를 조회합니다.
     * 주로 댓글 수정/삭제 시 권한 검증을 위해 사용됩니다.
     * @param commentId 조회할 댓글 ID
     * @return 조회된 댓글 정보 VO (없으면 null)
     */
    CommReviewCommentVO getCommentById(int commentId);

    /**
     * 특정 댓글을 삭제(논리적 삭제)합니다.
     * 대댓글이 있는 경우 처리 로직이 포함될 수 있습니다.
     * @param commentId 삭제할 댓글 ID
     * @return 댓글 삭제 성공 여부 (true/false)
     */
    boolean removeComment(int commentId);
}
