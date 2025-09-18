package kr.or.ddit.startup.design.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.startup.design.vo.DesignLikedPostVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;

public interface DesignService {
	
	// 2D 시뮬레이터에서 생성된 디자인 정보를 DB에 저장
    int insertDesign(SuShowDesignVO suShowDesignVO);
    
    // 페이징 없는 전체 '내 디자인' 목록 조회
    List<SuShowDesignVO> getAllMyDesigns(String userId);
    
    // 관리자의 디자인 목록 조회
    List<SuShowDesignVO> getDesignsByUserId(String userId);
    
    // ID로 디자인 정보 조회
    SuShowDesignVO getDesignById(int designId);
    
    // 메인 페이지용 최신 게시글 목록 조회
    List<SuShowPostVO> getLatestPosts();
    
    // 다른 사용자의 파일을 저장 (기존 디자인을 복제하여 새로운 사용자의 디자인으로 저장)
    int cloneDesign(int originalDesignId, String newUserId, String newDesignName);
    
    // 좋아요한 포스트 목록만 조회하는 메소드
    List<DesignLikedPostVO> getLikedPosts(String userId);
     
    // 마이페이지에서의 이름변경
    int renameDesign(int designId, String userId, String newDesignName);
    
    // 마이페이지에 필요한 데이터(내 디자인, 좋아요한 포스트)를 가져오는 메소드
    ArticlePage<SuShowDesignVO> getMyPageData(String userId, int currentPage);
    
    // ID로 디자인 삭제
    int deleteDesign(int designId, String userId);
    
    // json 파일 및 도면 캡쳐 함께 저장
    long saveDesignWithThumbnail(SuShowDesignVO vo, MultipartFile thumb) throws IOException;
    
    // 디자인 정보와 썸네일을 수정하는 메서드   
    int updateDesignWithThumbnail(SuShowDesignVO vo, MultipartFile newThumb) throws IOException;
}