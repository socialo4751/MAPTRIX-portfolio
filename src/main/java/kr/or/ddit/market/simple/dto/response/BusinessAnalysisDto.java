package kr.or.ddit.market.simple.dto.response;

import java.util.List;

import lombok.Data;

/**
 * [간단분석] (사업체/종사자 통계 해석 관련)
 * AI의 사업체/종사자 통계 분석 결과를 담는 DTO
 */
@Data
public class BusinessAnalysisDto {

    private String summary;

    private String densityFeature;

    private String employeeSizeFeature;

    private List<String> opportunities;
}