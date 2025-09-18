package kr.or.ddit.market.detailed.dto.response;

import lombok.Data;

/**
 * [상세분석] (로지스틱 회귀분석 해석 관련)
 * AI가 생성한 격자 상세 분석 리포트 결과를 담는 DTO
 */
@Data
public class LogisticAnalysisResponseDto {

    /**
     * 분석 대상 격자 ID
     */
    private String gid;

    /**
     * 분석 결과의 핵심을 나타내는 제목 (예: "확실한 핵심 상권: AI가 정확히 예측한 번화가")
     */
    private String analysisTitle;

    /**
     * 분석 결과에 대한 2~3 문장의 핵심 요약 (정답/오답 여부, 소속 군집 등)
     */
    private String gridSummary;

    /**
     * 모델이 왜 그렇게 예측했는지에 대한 상세한 원인 분석
     */
    private String analysisReason;

    /**
     * 이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견
     */
    private String potential;
}
