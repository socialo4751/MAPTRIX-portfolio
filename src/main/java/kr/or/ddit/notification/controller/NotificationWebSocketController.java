package kr.or.ddit.notification.controller;

import java.security.Principal;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import kr.or.ddit.notification.service.NotificationService; // ◀◀ 이대로 유지

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class NotificationWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;
    private final NotificationService notificationService;

    /**
     * 알림을 구독하는 클라이언트에게 현재 읽지 않은 알림 개수를 보냅니다.
     * 클라이언트가 '/app/notifications/unread-count' 경로로 메시지를 보내면 호출됩니다.
     */
    @MessageMapping("/notifications/unread-count")
    public void getUnreadCount(Principal principal) {
        if (principal == null) {
            return;
        }

        int unreadCount = notificationService.countUnreadNotifications(principal.getName());

        // STOMP로 특정 사용자에게만 알림 개수 메시지를 보냅니다.
        
        messagingTemplate.convertAndSendToUser(
            principal.getName(),
            "/queue/notifications/unread-count",
            unreadCount
        );
    }
}