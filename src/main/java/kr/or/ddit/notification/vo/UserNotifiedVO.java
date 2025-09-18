package kr.or.ddit.notification.vo;

import java.util.Date;

import lombok.Data;

/**
 * 사용자 알림 정보를 담기 위한 VO 클래스
 */
@Data
public class UserNotifiedVO {
    private int notifyId; // 알림 ID
    private String userId; // 회원고유번호
    private String message; // 메시지 내용
    private String isRead; // 읽음여부
    private String entityType; // 관련 테이블 명
    private String entityId; // 관련 테이블 PK ID
    private Date createdAt; // 알림발송시각
    private Date deletedAt; // 삭제시각
    private String targetUrl; //타켓Url
}
