package kr.or.ddit.user.my.community.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.user.my.community.vo.MyActivityVO2;

public interface MyActivityService {

    /**
     * 특정 사용자의 모든 활동(게시글, 댓글) 수를 조회합니다.
     * @param userId 사용자 ID
     * @return 총 활동 수
     */
    int getMyActivityCount(String userId);

    /**
     * 특정 사용자의 모든 활동 목록을 페이징 처리하여 조회합니다.
     * @param map 사용자 ID, 시작 행, 끝 행이 담긴 Map
     * @return 활동 내역 리스트
     */
    List<MyActivityVO2> getMyActivityList(Map<String, Object> map);

    /**
     * 게시글 또는 댓글을 삭제합니다.
     * @param boardType 게시판 종류 ('praise', 'qna', 'review')
     * @param activityType 활동 종류 ('post', 'comment')
     * @param id 게시글 또는 댓글 ID
     * @return 삭제 성공 여부
     */
    boolean deleteActivity(String boardType, String activityType, int id);
    
    /**
     * 특정 활동의 상세 내용을 조회합니다.
     * @param boardType 게시판 종류
     * @param activityType 활동 종류
     * @param id 게시글 또는 댓글 ID
     * @return 활동 상세 내용 (HTML 형식)
     */
    String getActivityContent(String boardType, String activityType, int id);
}
