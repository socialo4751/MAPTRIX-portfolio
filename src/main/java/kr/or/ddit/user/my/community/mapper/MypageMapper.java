package kr.or.ddit.user.my.community.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import java.util.List;
import java.util.Map;

@Mapper
public interface MypageMapper {
	
    /** 페이징/검색 목록 */
    List<CommFreePostVO> selectPostsByBizCode(Map<String, Object> params);

    /** 전체 건수 */
    int countPostsByBizCode(Map<String, Object> params);

    /** 단건 조회 */
    CommFreePostVO selectPostById(@Param("postId") int postId);

    /** 조회수 +1 */
    int incrementViewCount(@Param("postId") int postId);

    /** 등록 */
    int insertPost(CommFreePostVO postVO);

    /** 수정 */
    int updatePost(CommFreePostVO postVO);

    /** 게시글 소프트 삭제 (IS_DELETED='Y') */
    int softDeletePostById(@Param("postId") int postId);
    
    // ⭐⭐ 기존 메서드들을 Map 파라미터로 수정 ⭐⭐
    
    // 사용자가 작성한 게시글 수 조회 (검색 조건 포함)
    int countPostsByUserId(Map<String, Object> params);
    
    // 사용자가 작성한 게시글 목록 조회 (페이징 + 검색 조건)
    List<CommFreePostVO> selectPostsByUserId(Map<String, Object> params);

    // 사용자가 작성한 댓글 수 조회 (검색 조건 포함)
    int countCommentsByUserId(Map<String, Object> params);
    
    // 사용자가 작성한 댓글 목록 조회 (검색 조건 포함)
    List<CommFreeCommentVO> selectCommentsByUserId(Map<String, Object> params);
    
    // ⭐⭐ 통합 검색을 위한 새로운 메서드들 ⭐⭐
    
    // 모든 활동(게시글+댓글) 수 조회 (검색 조건 포함)
    int countAllActivitiesByUserId(Map<String, Object> params);
    
    // 모든 활동(게시글+댓글) 통합 조회 (검색 조건 포함) - UNION으로 처리
    List<Map<String, Object>> selectAllActivitiesByUserId(Map<String, Object> params);
}