package kr.or.ddit.user.my.nthistory.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.user.my.nthistory.vo.MyNtHistoryVO;

@Mapper
public interface MyNtHistoryMapper {

    /**
     * 검색 조건에 맞는 사용자의 전체 알림 개수를 조회합니다. (페이징 처리를 위함)
     * @param myNtHistoryVO 검색 조건(userId, startDate, endDate)
     * @return 조건에 맞는 전체 알림 개수
     */
    int selectTotalCount(MyNtHistoryVO myNtHistoryVO);

    /**
     * 검색 조건 및 페이징 정보에 맞는 사용자의 알림 목록을 조회합니다.
     * @param myNtHistoryVO 검색 조건 및 페이징 정보
     * @return 알림 목록
     */
    List<UserNotifiedVO> selectNotificationList(MyNtHistoryVO myNtHistoryVO);
}