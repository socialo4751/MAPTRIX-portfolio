package kr.or.ddit.market.simple.dto.response;

import java.util.List;

import lombok.Data;

/**
 * [간단분석] (주택 통계 해석 관련)
 * AI의 주택 통계 분석 결과를 담는 DTO
 */
@Data
public class HousingAnalysisDto {

    private String summary;

    private String mainHousingType;

    private String buildingAgeFeature;

    private List<String> opportunities;
    
}