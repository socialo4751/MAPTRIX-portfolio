package kr.or.ddit.notification.service.impl;

import java.util.List;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.notification.mapper.NotificationMapper;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationMapper notificationMapper;
    private final SimpMessagingTemplate messagingTemplate;

    @Override
    @Transactional
    public void createNotification(UserNotifiedVO notificationVO) {
        // 1) DB 저장
        notificationMapper.insertNotification(notificationVO);
        log.info("새로운 알림이 DB에 저장되었습니다. userId: {}", notificationVO.getUserId());

        // 2) 생성 직후 즉시 푸시 (중복 전송 없이 공통 헬퍼 사용)
        pushUnreadCount(notificationVO.getUserId());
    }

    @Override
    public List<UserNotifiedVO> getNotificationsByUserId(String userId) {
        return notificationMapper.selectNotificationsByUserId(userId);
    }

    @Override
    public int countUnreadNotifications(String userId) {
        return notificationMapper.countUnreadNotificationsByUserId(userId);
    }

    @Override
    @Transactional
    public void markAllAsRead(String userId) {
        int updated = notificationMapper.markAllAsReadByUserId(userId);
        log.info("모든 알림 읽음 처리: userId={}, updatedRows={}", userId, updated);

        // 전체 읽음 직후 즉시 푸시
        pushUnreadCount(userId);
    }

    @Override
    @Transactional
    public void markAsRead(int notifyId, String userId) {
        int updated = notificationMapper.markAsReadByIdAndUser(notifyId, userId); // ★ 변경
        log.info("개별 알림 읽음 처리: notifyId={}, userId={}, updatedRows={}", notifyId, userId, updated);
        pushUnreadCount(userId); // 즉시 푸시
    }


    /** 공통: 현재 미읽음 수를 해당 사용자에게 STOMP로 전송 */
    private void pushUnreadCount(String userId) {
        int unreadCount = countUnreadNotifications(userId);
        messagingTemplate.convertAndSendToUser(
            userId,
            "/queue/notifications/unread-count",
            unreadCount
        );
        log.debug("푸시 완료: userId={}, unreadCount={}", userId, unreadCount);
    }
}
