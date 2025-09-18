package kr.or.ddit.community.free.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.community.free.vo.CommFreeCommentVO;

@Mapper
public interface FreeCommentMapper {

    /**
     * 새로운 댓글을 삽입합니다.
     * @param commentVO 작성할 댓글 정보
     * @return 삽입된 행의 수
     */
    int insertComment(CommFreeCommentVO commentVO);

    /**
     * 특정 게시글 ID에 해당하는 모든 댓글 목록을 조회합니다.
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 목록
     */
    List<CommFreeCommentVO> selectFreeCommentsByPostId(@Param("postId")int postId); // long -> int로 수정

    /**
     * 특정 댓글 ID에 해당하는 단일 댓글을 조회합니다.
     * @param commentId 조회할 댓글 ID
     * @return 조회된 댓글 정보
     */
    CommFreeCommentVO selectCommentById(@Param("commentId")int commentId);

    /**
     * 댓글 내용을 업데이트합니다.
     * @param commentVO 업데이트할 댓글 정보
     * @return 업데이트된 행의 수
     */
    int updateComment(CommFreeCommentVO commentVO);

    /**
     * 댓글을 논리적으로 삭제합니다 (isDeleted를 'Y'로 변경).
     * @param commentId 삭제할 댓글 ID
     * @return 업데이트된 행의 수
     */
    int softDeleteFreeComment(@Param("commentId")int commentId);
    
    /**
     * 특정 게시글 ID에 해당하는 모든 댓글을 물리적으로 삭제합니다.
     * 이 메서드는 게시글 삭제 시 관련 댓글을 모두 지우기 위해 사용됩니다.
     * @param postId 게시글 ID
     * @return 삭제된 댓글의 수
     */
    int deleteCommentsByPostId(@Param("postId")int postId);
    
    
    // 사용자가 작성한 댓글 수 조회
    int countCommentsByUserId(String userId);
    
    // 사용자가 작성한 댓글 목록 조회
    List<CommFreeCommentVO> selectCommentsByUserId(String userId);
    
   
}
