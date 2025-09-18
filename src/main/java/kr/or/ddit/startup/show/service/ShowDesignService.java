package kr.or.ddit.startup.show.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.vo.SuShowCommentVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;

public interface ShowDesignService {
		
	// 자랑게시판 리스트 목록 조회
	public List<SuShowPostVO> selectShowPostList(Map<String, Object> paramMap);
	
    // 월간 베스트 게시물 3개 조회
    List<SuShowPostVO> getBestPostsOfMonth(String yearMonth);
	
	// 자랑게시판 리스트 페이징 처리
	public int selectTotalCount(Map<String, Object> paramMap);
	
    // 게시물 등록 메서드 (선택된 해시태그 ID 문자열 및 첨부파일 받기)
    int insertShowPost(SuShowPostVO suShowPostVO);
    
    // 특정 사용자가 작성한 디자인 목록 조회
    public List<SuShowDesignVO> getDesignsByUserId(String userId);
    
    // 게시물 삭제 
    int deletePost(String postId, String userId);
    
    // 게시물 수정	
    int updatePost(SuShowPostVO suShowPostVO, List<Integer> deleteFileSns, MultipartFile[] newFiles);
       
// ======= 좋아요/조회수 관련 메서드 ============
    
	// 자랑 게시판 조회수 증가
	public int incrementViewCount(String postId);
	
	// 게시물 상세 정보를 가져오되, 조회수 증가 로직은 구현체에서 담당
	public SuShowPostVO getPostDetail(String postId); // 이름 변경 
	
	// 현재 좋아요 수 가져오기
	public int getLikeCount(String postId); // 
	
	// 사용자가 해당 게시물에 좋아요를 눌렀는지 확인
	public boolean checkIfUserLiked(String postId, String userId); 
	
	// 좋아요 상태 토글 (좋아요 누르기 / 좋아요 취소)
	public boolean toggleLikeStatus(String postId, String userId); 
    
// ======= 댓글 관련 메서드 =================
    
	// 특정 게시물의 댓글 목록 조회
	public List<SuShowCommentVO> getCommentList(String postId);
	
	// 댓글 등록
	public int insertComment(SuShowCommentVO suShowCommentVO);
	
    // 댓글 수정
    public int updateComment(SuShowCommentVO suShowCommentVO);

    // 댓글 삭제
    public int deleteComment(int commentId, String userId);
    
    // 부모 댓글의 depth를 조회하는 메서드
    public Integer getCommentDepth(int parentId);
	
}
