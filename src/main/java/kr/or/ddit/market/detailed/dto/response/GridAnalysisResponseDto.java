package kr.or.ddit.market.detailed.dto.response;

import lombok.Data;

/**
 * [상세분석] (다중회귀모형 해석 관련)
 * AI가 생성한 격자 상세 분석 리포트 결과를 담는 DTO
 */
@Data
public class GridAnalysisResponseDto {

    /**
     * 분석 대상 격자 ID
     */
    private String gid;

    /**
     * 분석 결과의 핵심을 나타내는 제목 (예: "숨은 꿀단지: 예측을 뛰어넘는 성장 지역")
     */
    private String summaryTitle;

    /**
     * 분석 결과에 대한 2~3 문장의 핵심 요약
     */
    private String summaryContent;

    /**
     * 잔차(오차)가 발생한 원인에 대한 상세 분석 내용
     */
    private String analysisDetails;

    /**
     * 이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견
     */
    private String potential;
}
