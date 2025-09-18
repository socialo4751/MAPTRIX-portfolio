package kr.or.ddit.notification.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 알림 기능 관련 REST API를 제공하는 컨트롤러
 */
@Slf4j
@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {

    private final NotificationService notificationService;

    /** 현재 로그인한 사용자의 최근 알림 목록 */
    @GetMapping
    public ResponseEntity<List<UserNotifiedVO>> getNotifications(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        List<UserNotifiedVO> notifications =
                notificationService.getNotificationsByUserId(principal.getName());
        return ResponseEntity.ok(notifications);
    }

    /** 안 읽은 알림 개수 */
    @GetMapping("/unread-count")
    public ResponseEntity<Map<String, Integer>> getUnreadCount(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        int count = notificationService.countUnreadNotifications(principal.getName());
        return ResponseEntity.ok(Map.of("count", count));
    }

    /** 개별 알림 읽음 처리 (★ userId 함께 전달) */
    @PostMapping("/{notifyId}/read")
    public ResponseEntity<Void> markAsRead(@PathVariable("notifyId") int notifyId,
                                           Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        log.info("개별 알림 읽음 처리 요청 수신: {}", notifyId);
        notificationService.markAsRead(notifyId, principal.getName());
        return ResponseEntity.ok().build();
    }

    /** 모든 알림 읽음 처리 (★ userId 함께 전달) */
    @PostMapping("/read-all")
    public ResponseEntity<Void> markAllAsRead(Principal principal) {
        if (principal == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        notificationService.markAllAsRead(principal.getName());
        return ResponseEntity.ok().build();
    }
}
