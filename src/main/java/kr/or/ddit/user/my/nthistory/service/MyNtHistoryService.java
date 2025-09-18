package kr.or.ddit.user.my.nthistory.service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.user.my.nthistory.vo.MyNtHistoryVO;

public interface MyNtHistoryService {

    /**
     * 사용자의 알림 내역을 검색 조건과 페이징 정보를 포함하여 조회합니다.
     * @param myNtHistoryVO 검색 조건 및 현재 페이지 정보
     * @return 페이징 처리가 완료된 알림 목록 (ArticlePage 객체)
     */
    public ArticlePage<UserNotifiedVO> getMyNotificationHistory(MyNtHistoryVO myNtHistoryVO);
}