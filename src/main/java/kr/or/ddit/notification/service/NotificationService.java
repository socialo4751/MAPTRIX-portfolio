package kr.or.ddit.notification.service;

import java.util.List;

import kr.or.ddit.notification.vo.UserNotifiedVO;

public interface NotificationService {
	  /**
     * 새로운 알림을 생성합니다. (예: 새 댓글 알림)
     * 이 메소드는 댓글 서비스, Q&A 답변 서비스 등에서 호출됩니다.
     * @param notificationVO 저장할 알림 정보
     */
    void createNotification(UserNotifiedVO notificationVO);

    /**
     * 특정 사용자의 최근 알림 목록을 조회합니다.
     * @param userId 회원 ID
     * @return 알림 목록
     */
    List<UserNotifiedVO> getNotificationsByUserId(String userId);

    /**
     * 특정 사용자의 읽지 않은 알림 개수를 조회합니다.
     * @param userId 회원 ID
     * @return 안 읽은 알림 개수
     */
    int countUnreadNotifications(String userId);

    /**
     * 특정 사용자의 모든 알림을 '읽음' 상태로 변경합니다.
     * @param userId 회원 ID
     */
    void markAllAsRead(String userId);
    

    /**
     * 지정된 ID의 알림 하나를 읽음 처리합니다.
     * @param notifyId 읽음 처리할 알림 ID
     */
    void markAsRead(int notifyId, String userId); 
}

