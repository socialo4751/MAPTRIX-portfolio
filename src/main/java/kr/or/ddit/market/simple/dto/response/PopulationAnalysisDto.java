package kr.or.ddit.market.simple.dto.response;

import java.util.List;

import lombok.Data;

/**
 * [간단분석] (인구 통계 해석 관련)
 * 인구 통계 데이터에 대한 AI의 간단 분석 결과를 담기 위한 DTO
 */
@Data
public class PopulationAnalysisDto {

    /**
     * 분석 결과에 대한 1~2문장의 핵심 요약
     */
    private String summary;

    /**
     * 해당 지역의 가장 두드러지는 주요 연령층
     */
    private String mainAgeGroup;

    /**
     * 남녀 성비 또는 특정 성별의 집중도에 대한 특징
     */
    private String genderRatioFeature;
    
    /**
     * 분석된 인구 통계적 특성에 기반한 구체적인 사업 기회 요인 (2개)
     */
    private List<String> opportunities;
}