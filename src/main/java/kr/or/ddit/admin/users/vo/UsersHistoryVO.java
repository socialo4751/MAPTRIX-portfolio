package kr.or.ddit.admin.users.vo;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

/**
 * 사용자 상태 변경 이력을 담기 위한 VO 클래스
 */
@Data
public class UsersHistoryVO {
    private int historyId; // 이력 고유 ID
    private String userId; // 사용자 ID
    private String preEnabled; // 변경 전 상태 ('Y' or 'N')
    private String newEnabled; // 변경 후 상태 ('Y' or 'N')
    private String reason; // 사유 (정지 시 필요)
    private String changedBy; // 변경한 관리자 ID

    // 상태 변경이 일어난 시점 (정지 시작일로 활용)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date changedAt;

    // 이 두 필드는 현재 로직에서 명시적으로 사용하지 않을 예정입니다.
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date suspendedAt;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date unsuspendedAt;

    // 정지 해제일 (정지 중이면 null, 해제 시 현재 시간으로 업데이트)
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date expiresAt;
}