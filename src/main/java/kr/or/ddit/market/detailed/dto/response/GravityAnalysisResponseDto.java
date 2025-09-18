package kr.or.ddit.market.detailed.dto.response;

import lombok.Data;

/**
 * [상세분석] (중력모델 해석 관련)
 * AI가 생성한 격자 상세 분석 리포트 결과를 담는 DTO
 */
@Data
public class GravityAnalysisResponseDto {

    /**
     * 분석 대상 격자 ID
     */
    private String gid;

    /**
     * 분석 결과의 핵심을 나타내는 제목 (예: "대전의 중심, 강력한 상권 자석")
     */
    private String analysisTitle;

    /**
     * 분석 결과에 대한 2~3 문장의 핵심 요약 (어떤 등급에 속하는지 포함)
     */
    private String gridSummary;

    /**
     * 인구 수와 공시지가를 바탕으로 Gravity_Total 점수가 나온 이유에 대한 상세 분석
     */
    private String analysisReason;

    /**
     * 이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견
     */
    private String potential;
}
