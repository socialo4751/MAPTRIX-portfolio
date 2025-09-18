package kr.or.ddit.market.simple.dto.response;

import java.util.List;
import lombok.Data;

/**
 * [간단분석] (가구 통계 해석 관련)
 * 가구 통계 데이터에 대한 AI의 분석 결과를 담는 DTO
 */
@Data
public class HouseholdAnalysisDto {

    /**
     * 분석 결과에 대한 1~2문장의 핵심 요약
     */
    private String summary;

    /**
     * 해당 지역의 가장 두드러지는 주요 가구 유형 (예: "1인 가구", "2세대 가구")
     */
    private String mainHouseholdType;
    
    /**
     * 평균 가구원수나 1인 가구 비율 등 가구 규모에 대한 특징
     */
    private String householdSizeFeature;

    /**
     * 분석된 가구 특성에 기반한 구체적인 사업 기회 요인 (2개)
     */
    private List<String> opportunities;
}