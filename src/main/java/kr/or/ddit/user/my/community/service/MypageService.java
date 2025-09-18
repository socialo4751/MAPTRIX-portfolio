package kr.or.ddit.user.my.community.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import kr.or.ddit.user.my.community.vo.MyActivityVO;

public interface MypageService {

    /**
     * 사용자의 활동 요약 정보(총 게시글, 총 댓글)를 조회합니다.
     * @param userId 조회할 사용자 ID
     * @return Key("totalPosts", "totalComments")를 갖는 Map
     */
    Map<String, Integer> getActivitySummary(String userId);

    /**
     * 사용자의 모든 활동(게시글, 댓글) 목록을 페이징하여 조회합니다.
     * @param userId 조회할 사용자 ID
     * @param currentPage 현재 페이지 번호
     * @param size 페이지 당 항목 수
     * @return 페이징 처리된 ArticlePage 객체 (내용은 MyActivityVO 리스트)
     */
    ArticlePage<MyActivityVO> getActivityList(String userId, int currentPage, int size, String activityType);
    
    /**
     * 특정 업종의 전체 게시글 수를 검색 조건에 맞춰 조회합니다.
     */
    int getPostCountByBizCode(String bizCodeId, String keyword);
    
    /**
     * 특정 업종의 게시글 목록을 페이징 및 검색 조건에 맞춰 조회합니다.
     */
    List<CommFreePostVO> getPostsByBizCode(String bizCodeId, int currentPage, int size, String keyword);
    
    // ⭐⭐ 기존 메서드들을 Map 파라미터로 변경 + 검색 기능 추가 ⭐⭐
    
    /**
     * 사용자의 게시글 수를 조회합니다. (검색 조건 포함)
     * @param params userId, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 게시글 수
     */
    int getPostCount(Map<String, Object> params);

    /**
     * 사용자의 댓글 수를 조회합니다. (검색 조건 포함)
     * @param params userId, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 댓글 수
     */
    int getCommentCount(Map<String, Object> params);
    
    /**
     * 사용자가 작성한 게시글 목록을 페이징하여 조회합니다. (검색 조건 포함)
     * @param params userId, currentPage, size, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 페이징 처리된 게시글 목록
     */
    List<CommFreePostVO> getMyPosts(Map<String, Object> params);
    
    /**
     * 사용자가 작성한 댓글 목록을 페이징하여 조회합니다. (검색 조건 포함)
     * @param params userId, currentPage, size, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 페이징 처리된 댓글 목록
     */
    List<CommFreeCommentVO> getMyComments(Map<String, Object> params);
    
    // ⭐⭐ 통합 검색을 위한 새로운 메서드들 ⭐⭐
    /**
     * 모든 활동(게시글+댓글) 수를 조회합니다. (검색 조건 포함)
     * @param params userId, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 전체 활동 수
     */
    int getAllActivitiesCount(Map<String, Object> params);
    
    /**
     * 모든 활동(게시글+댓글)을 통합 조회합니다. (검색 조건 포함)
     * @param params userId, currentPage, size, searchType, searchKeyword 등이 포함된 파라미터 맵
     * @return 통합 활동 목록
     */
    List<Object> getAllActivitiesWithSearch(Map<String, Object> params);
}