package kr.or.ddit.common.vo.openapi;

import java.util.Date;

import lombok.Data;

/**
 * API 구독 정보를 담기 위한 VO 클래스
 */
@Data
public class ApiSubscriptionsVO {
    private long subscriptionId; // 구독 ID
    private String userId; // 회원고유번호
    private long apiId; // API ID
    private long applicationId; // 신청 ID
    private String apiKey; // 공개 키
    private String secretKey; // 비밀 키
    private Date startedAt; // 구독 시작일
    private Date expiredAt; // 구독 만료일
}
