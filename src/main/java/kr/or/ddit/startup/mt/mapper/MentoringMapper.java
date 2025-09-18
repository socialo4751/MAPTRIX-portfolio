package kr.or.ddit.startup.mt.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.startup.mt.vo.SuMentPostVO;

@Mapper
public interface MentoringMapper {
	
	// 멘토링 게시글 전체 목록 list 조회
	public List<SuMentPostVO> selectMentoringPostList();
	
	// 멘토링 게시글 등록하기 insert
	public int createMentoringPost(SuMentPostVO post);
	
	// 멘토링 게시글 상세보기 detail
	public SuMentPostVO retrieveMentoringPost(@Param("POST_ID") long mentoringId);

	// 검색 조건에 맞는 전체 게시물 수를 조회합니다. (페이징 계산용)
	public int selectTotalCount(Map<String, Object> paramMap);
	
	// 검색 및 페이징이 적용된 게시물 목록을 조회
	public List<SuMentPostVO> selectMentoringPostList(Map<String, Object> paramMap);

	// detail에서 이전 / 다음 게시글 정보 조회
	public SuMentPostVO selectPrevPost(long postId);
	public SuMentPostVO selectNextPost(long postId);

	// 조회수 1 증가
	public void increaseViewCount(long postId);
	
    // 게시글 수정
    public int updateMentoringPost(SuMentPostVO post);
    
    // 게시글 삭제
    public int deleteMentoringPost(long postId);

}
