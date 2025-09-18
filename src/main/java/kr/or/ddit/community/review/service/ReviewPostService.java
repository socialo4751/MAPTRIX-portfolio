package kr.or.ddit.community.review.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.community.review.vo.CommReviewPostVO;

/**
 * ReviewPostService 인터페이스
 * 게시글 관련 비즈니스 로직을 정의합니다.
 */
public interface ReviewPostService {

    /**
     * 새로운 게시글을 작성하고 데이터베이스에 저장합니다.
     * 파일 첨부 등 추가적인 비즈니스 로직이 포함될 수 있습니다.
     * @param postVO 작성할 게시글 정보 VO
     * @return 게시글 작성 성공 여부 (true/false)
     */
    boolean createPost(CommReviewPostVO postVO);

    /**
     * 특정 게시글 ID로 게시글 상세 정보를 조회하고, 조회수를 증가시킵니다.
     * @param postId 조회할 게시글 ID
     * @return 조회된 게시글 정보 VO, 없으면 null
     */
    CommReviewPostVO getPost(int postId);

    /**
     * 모든 게시글 목록을 조회합니다.
     * (페이징, 검색 조건 등은 추후 추가될 수 있습니다.)
     * @return 게시글 목록
     */
    List<CommReviewPostVO> getAllPosts();

    /**
     * 게시글 정보를 업데이트합니다.
     * @param postVO 업데이트할 게시글 정보 VO
     * @return 게시글 업데이트 성공 여부 (true/false)
     */
    boolean modifyPost(CommReviewPostVO postVO);

    /**
     * 특정 게시글을 삭제(논리적 삭제)합니다.
     * 관련 댓글 등 다른 데이터 처리 로직이 포함될 수 있습니다.
     * @param postId 삭제할 게시글 ID
     * @return 게시글 삭제 성공 여부 (true/false)
     */
    boolean removePost(int postId);

	int getReviewPostCount(Map<String, Object> map);

	List<CommReviewPostVO> getReviewPostList(Map<String, Object> map);

	
}
