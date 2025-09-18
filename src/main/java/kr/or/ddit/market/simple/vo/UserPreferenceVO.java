package kr.or.ddit.market.simple.vo; // vo 패키지로 경로 변경

import lombok.Data;

@Data
public class UserPreferenceVO {
    // 지역 선택 정보
    private Integer districtId; // 부모 '구' ID (예: 서구)
    private String admCode;     // 실제 '행정동' 코드 (예: 둔산동)

    // 업종 선택 정보
    private String parentBizCodeId; // 부모 '업종 대분류' ID (예: F - 음식)
    private String bizCodeId;       // 실제 '업종 중분류' ID (예: F01 - 한식)
}