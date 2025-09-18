package kr.or.ddit.common.vo.log;

import java.util.Date;

import lombok.Data;

/**
 * API 사용 로그 정보를 담기 위한 VO 클래스
 */
@Data
public class LogApiUsageVO {
    private int logId; // 로그  ID
    private int subscriptionId; // 구독 ID
    private String requestEndpoint; // 호출 API 엔드포인트
    private int httpStatus; // 응답 상태 코드
    private int responseTimeMs; // 응답 시간 (밀리초)
    private String clientIp; // 클라이언트 IP
    private Date calledAt; // 호출 시각
}
