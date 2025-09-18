package kr.or.ddit.community.free.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.community.free.vo.CommFreePostVO;

import java.util.List;
import java.util.Map;

@Mapper
public interface FreePostMapper {

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
    
    // 사용자가 작성한 게시글 수 조회
    int countPostsByUserId(String userId);
    
    // 사용자가 작성한 게시글 목록 조회 (페이징)
    List<CommFreePostVO> selectPostsByUserId(Map<String, Object> params);
    
    /**
     * 자유게시판의 최신 게시글 1개를 조회합니다.
     * @return 최신 FreePostVO 객체, 없으면 null
     */
    CommFreePostVO selectLatestFreePost(); // ◀◀ 이 메소드 추가

}
