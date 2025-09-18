package kr.or.ddit.community.review.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.community.review.vo.CommReviewCommentVO;

/**
 * ReviewCommentMapper 인터페이스
 * 댓글 데이터베이스 접근을 위한 매퍼 메서드를 정의합니다.
 */
@Mapper
public interface ReviewCommentMapper {

    /**
     * 새로운 댓글을 데이터베이스에 삽입합니다.
     * @param commentVO 삽입할 댓글 정보 VO
     * @return 삽입된 레코드 수
     */
    int insertComment(CommReviewCommentVO commentVO);

    /**
     * 특정 게시글 ID에 속한 모든 댓글 목록을 조회합니다.
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 목록
     */
    List<CommReviewCommentVO> selectCommentsByPostId(int postId);

    /**
     * 특정 댓글 ID로 댓글 정보를 조회합니다. (depth 계산을 위해 필요)
     * @param commentId 조회할 댓글 ID
     * @return 조회된 댓글 정보 VO, 없으면 null
     */
    CommReviewCommentVO selectCommentById(int commentId);

    /**
     * 댓글 정보를 업데이트합니다.
     * @param commentVO 업데이트할 댓글 정보 VO
     * @return 업데이트된 레코드 수
     */
    int updateComment(CommReviewCommentVO commentVO);

    /**
     * 특정 댓글을 삭제(논리적 삭제)합니다.
     * @param commentId 삭제할 댓글 ID
     * @return 삭제된 레코드 수
     */
    int deleteCommentsByPostId(int commentId); // IS_DELETED 컬럼을 'Y'로 업데이트하는 방식

    // 추가적으로, 대댓글이 있는 부모 댓글을 삭제할 때 자식 댓글이 있는지 확인하는 메서드가 필요할 수 있습니다.
    // List<CommReviewCommentVO> selectChildComments(int parentId);
    // boolean hasChildComments(int parentId);
    
    // 사용자가 작성한 댓글 수 조회
    int countCommentsByUserId(String userId);
    // 사용자가 작성한 댓글 목록 조회
    List<CommReviewCommentVO> selectCommentsByUserId(String userId);
}