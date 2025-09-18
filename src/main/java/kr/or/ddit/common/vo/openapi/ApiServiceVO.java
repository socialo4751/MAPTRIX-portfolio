package kr.or.ddit.common.vo.openapi;

import lombok.Data;

/**
 * 제공 API 서비스 정보를 담기 위한 VO 클래스
 */
@Data
public class ApiServiceVO {
    // --- 기존 필드 ---
    private long apiId;                 // API ID
    private String apiCategory;           // API 구분 (코드 ID 또는 JOIN된 이름)
    private String apiNameKr;             // API 국문명
    private String apiDesc;               // API 설명 (1000 BYTE)
    private String supportedFormats;      // 제공 형태 (코드 ID 또는 JOIN된 이름)
    private String dataSourceInfo;        // 데이터 소스 정보
    private String serviceType;           // 서비스 타입 (코드 ID 또는 JOIN된 이름)

    // --- 새로 추가된 필드 ---
    private long dailyCallLimit;        // 일일 호출 제한
    private String baseUrl;               // Base URL
    private String swaggerUrl;            // Swagger URL
    private String requestParamsDesc;     // 요청 파라미터 설명 (CLOB)
    private String sampleCode;            // 샘플 코드 (CLOB)
    private String apiCautions;           // API 호출 시 주의사항 (CLOB)
    private String requestEndpoint;       // 요청 엔드포인트

    private int subscriptionPeriodMonths; 

    private String requestExample;      // API 요청 예시 (CLOB)
    private String responseExample;     // API 응답 예시 (CLOB)

}
