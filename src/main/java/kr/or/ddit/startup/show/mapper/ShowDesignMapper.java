package kr.or.ddit.startup.show.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.vo.SuShowCommentVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;

@Mapper
public interface ShowDesignMapper {

	// 자랑게시판 리스트 목록 조회
	List<SuShowPostVO> selectShowPostList(Map<String, Object> paramMap);

	// 월간 베스트 게시물 3개 조회
	List<SuShowPostVO> selectBestPostsOfMonth(Map<String, String> params);

	// 자랑게시판 리스트 페이징
	int selectTotalCount(Map<String, Object> paramMap);

	// 자랑게시판 상세보기
	SuShowPostVO selectShowPostDetail(String postId);

	// 게시글 삭제
	int deletePost(String postId, String userId);

	// 게시물 수정
	int updatePost(SuShowPostVO suShowPostVO);

	// 파일 번호 목록을 받아 여러 파일 삭제
	void deleteFilesBySn(List<Integer> fileSns);

	// 선택된 해시태그를 쉼표로 구분 후 문자열로 변환
	int insertShowPost(SuShowPostVO suShowPostVO);

	// 파일 상세 정보를 DB에 저장
	int insertFileDetail(FileDetailVO fileDetailVO);
	// 파일 그룹 번호 생성을 위한 메서드 추가
	int insertFileGroup(SuShowPostVO suShowPostVO);

	// 사용자가 입력한 해쉬태그 저장
	int insertHashtags(Map<String, Object> params);

	// 특정 사용자가 작성한 디자인 목록 조회
	List<SuShowDesignVO> getDesignsByUserId(String userId);

// ======= 좋아요/조회수 관련 메서드 ============

	// 자랑 게시판 조회수 증가
	int incrementViewCount(String postId); //

	// 게시물 좋아요 수 조회
	int selectLikeCount(String postId); //

	// 사용자가 특정 게시물에 좋아요를 눌렀는지 확인 -> 결과가 1 이상이면 좋아요 누름, 0이면 안 누름
	int checkLikeExists(@Param("postId") String postId, @Param("userId") String userId); //

	// 좋아요 기록 추가
	void insertLike(@Param("postId") String postId, @Param("userId") String userId); //

	// 좋아요 기록 삭제
	void deleteLike(@Param("postId") String postId, @Param("userId") String userId); //

	// 게시물 테이블
	void incrementLikeCount(String postId);

	// 게시물 테이블
	void decrementLikeCount(String postId);

// ======= 댓글 관련 메서드 ============

	// 특정 게시물의 댓글 목록 조회
	List<SuShowCommentVO> selectCommentList(String postId);

	// 댓글 등록
	int insertComment(SuShowCommentVO suShowCommentVO);

	// 댓글 수정
	int updateComment(SuShowCommentVO suShowCommentVO);

	// 댓글 삭제 (논리적 삭제)
	int deleteComment(@Param("commentId") int commentId, @Param("userId") String userId);

	// 부모 댓글의 depth를 조회
	Integer selectCommentDepth(int parentId);

	// [추가] 단일 댓글 조회를 위한 메서드
	SuShowCommentVO selectCommentById(int commentId);

}
