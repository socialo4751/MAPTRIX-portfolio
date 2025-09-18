package kr.or.ddit.startup.design.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.startup.design.vo.DesignLikedPostVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;

@Mapper
public interface DesignMapper {

    //2D 시뮬레이터에서 생성된 디자인 정보를 DB에 저장
    int insertDesign(SuShowDesignVO suShowDesignVO);
    
    // 디자인 정보(이름, 데이터, 파일 그룹 번호)를 업데이트합니다.
    int updateDesign(SuShowDesignVO suShowDesignVO);
    
    // 특정 사용자가 저장한 모든 디자인 목록 조회
    List<SuShowDesignVO> selectMyDesigns(String userId);

    // 특정 사용자가 좋아요한 모든 포스트 목록 조회
    List<DesignLikedPostVO> selectLikedPosts(String userId);
    
    // ID로 특정 디자인 정보 조회
    SuShowDesignVO selectDesignById(int designId);
    
    // 관리자의 디자인 목록 조회
    List<SuShowDesignVO> selectDesignsByUserId(String userId);
  
    // 메인 페이지용 최신 게시글 목록 조회
    List<SuShowPostVO> selectLatestPosts();
    
    // ID로 특정 디자인을 논리적으로 삭제
    int deleteDesign(@Param("designId") int designId, @Param("userId") String userId);
    
    // 마이페이지에서 이름 변경
    int renameDesign(@Param("designId") int designId, @Param("userId") String userId, @Param("newDesignName") String newDesignName);
    
    // ==== 페이징 처리 ====================
    
    // 특정 사용자가 저장한 디자인의 총 개수 조회
    int selectMyDesignsCount(String userId);
    
    // 페이징 없이 특정 사용자의 모든 디자인 목록 조회
    List<SuShowDesignVO> selectAllMyDesigns(String userId);

    // 특정 사용자가 저장한 디자인 목록 조회 (페이징 처리)
    List<SuShowDesignVO> selectMyDesigns(Map<String, Object> paramMap);
    
    // JSON 파일과 썸네일 함께 저장
    SuShowDesignVO selectDesignWithThumbById(int designId);
    
}