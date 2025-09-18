package kr.or.ddit.community.review.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.community.review.vo.CommReviewPostVO;

@Mapper
public interface ReviewPostMapper {

	int insertPost(CommReviewPostVO postVO);

	CommReviewPostVO selectPostById(int postId);

	void incrementViewCount(int postId);

	List<CommReviewPostVO> selectAllPosts();

	int updatePost(CommReviewPostVO postVO);

	int deletePost(int postId);

	int selectPostCount(Map<String, Object> map);

	List<CommReviewPostVO> selectPostsByPage(Map<String, Object> map);
	
	// 사용자가 작성한 게시글 수 조회
	int countPostsByUserId(String userId);
	
	// 사용자가 작성한 게시글 목록 조회
	List<CommReviewPostVO> selectPostsByUserId(String userId);



}
