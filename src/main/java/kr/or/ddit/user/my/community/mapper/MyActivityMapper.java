package kr.or.ddit.user.my.community.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.user.my.community.vo.MyActivityVO2;

@Mapper
public interface MyActivityMapper {

    /**
     * 특정 사용자의 모든 활동(게시글, 댓글) 수를 조회합니다.
     * @param userId 사용자 ID
     * @return 총 활동 수
     */
    int selectMyActivityCount(String userId);

    /**
     * 특정 사용자의 모든 활동 목록을 페이징 처리하여 조회합니다.
     * @param map 사용자 ID, 시작 행, 끝 행이 담긴 Map
     * @return 활동 내역 리스트
     */
    List<MyActivityVO2> selectMyActivityList(Map<String, Object> map);
    
    /**
     * 특정 활동의 원본 내용을 조회합니다.
     * @param boardType 게시판 종류
     * @param activityType 활동 종류
     * @param id 게시글 또는 댓글 ID
     * @return 원본 내용
     */
    String selectActivityContent(@Param("boardType") String boardType, 
                                 @Param("activityType") String activityType, 
                                 @Param("id") int id);
}
