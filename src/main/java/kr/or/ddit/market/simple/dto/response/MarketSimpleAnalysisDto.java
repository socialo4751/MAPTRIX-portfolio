package kr.or.ddit.market.simple.dto.response;

import java.util.List;

import lombok.Data;

/**
 * [간단분석] (통합 해석 관련)
 * 간단 상권 분석(AI 해석)의 결과를 담기 위한 전용 DTO입니다.
 */
@Data
public class MarketSimpleAnalysisDto {
    private String summary;
    private String opportunities;
    private String threats;
    private List<String> recommendations;
}

