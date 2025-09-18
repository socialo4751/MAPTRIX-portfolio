package kr.or.ddit.startup.mt.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.or.ddit.startup.mt.vo.SuMentPostVO;

public interface MentoringService {
    
	// 멘토링 게시글 전체 list 조회   
    public List<SuMentPostVO> retrieveMentoringPostList();
    
    // 멘토링 게시물 insert
    public int createMentoringPost(SuMentPostVO post);

    // 멘토링 게시물 하나의 상세정보 조회
	public SuMentPostVO retrieveMentoringPost(@Param("POST_ID") long mentoringId);
	
	// 검색 조건에 맞는 전체 게시물 수를 조회 (페이징 계산)
	public int selectTotalCount(Map<String, Object> paramMap);
	 
	// 검색 및 페이징이 적용된 게시물 목록을 조회
	public List<SuMentPostVO> selectMentoringPostList(Map<String, Object> paramMap);
	
	// detail에서 이전 / 다음 게시글 정보 조회
	public SuMentPostVO selectPrevPost(long postId);
	public SuMentPostVO selectNextPost(long postId);
	
	// 게시물의 조회수를 1 증가 시킴
	public void increaseViewCount(long postId);
	
    // 게시글 수정
    public int modifyMentoringPost(SuMentPostVO post);
    
    // 게시글 삭제
    public int removeMentoringPost(long postId);
	  
}
