package kr.or.ddit.openapi.apply.vo;

import java.util.Date;

import lombok.Data;

@Data
public class MySubscriptionVO {

    // API_SUBSCRIPTIONS 테이블 정보
    private long subscriptionId;
    private String apiKey;
    private String secretKey;
    private Date startedAt;
    private Date expiredAt;

    // API_SERVICE 테이블 정보 (JOIN 결과)
    private long apiId;
    private String apiNameKr;
    private String apiDesc;
    private String baseUrl;
    private String requestParamsDesc; // DB에서 가져온 원본 Markdown
    private String requestParamsDescHtml; // HTML로 변환된 결과
    private String sampleCode;
    private String apiCautions;
    private long dailyCallLimit;
    private String requestEndpoint; 
    
    private String requestExample;    // 요청 예시
    private String responseExample;   // 응답 예시
    
    // [신규] JOIN을 통해 가져온 코드 이름을 담을 필드 추가
    private String apiCategoryName;
    private String serviceTypeName;
    private String supportedFormatsName;
    
    
    
}