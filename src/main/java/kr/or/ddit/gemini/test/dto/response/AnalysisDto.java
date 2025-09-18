package kr.or.ddit.gemini.test.dto.response;

import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 제미나이가 상권분석 결과값 JSON
 */
@Getter
@Setter
@NoArgsConstructor
public class AnalysisDto {
    // 분석 결과 필드들
    private String summary; // 한 줄 요약
    private String riskLevel; // 종합 위험도 (예: "낮음", "주의", "위험")
    private String positiveSignal; // 긍정적 신호
    private String negativeSignal; // 부정적 신호
    private List<String> recommendations; // 추천 전략 (리스트)
}