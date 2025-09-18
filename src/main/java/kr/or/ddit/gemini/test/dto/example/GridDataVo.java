package kr.or.ddit.gemini.test.dto.example;

import lombok.AllArgsConstructor;
import lombok.Getter;

/*
 * 분석할 DB 데이터 예시 => GEMINI 에게 제공
 */
@Getter
@AllArgsConstructor
public class GridDataVo {
    // 격자와 결합된 pValue 및 data
    private String gridId;
    private double pValue;
    private String dong1Name;
    private int dong1Ratio;
    private String dong2Name;
    private int dong2Ratio;

    // [신규 추가] 분석 모델 정보
    private String analysisModel;   // 분석 모델 이름 (예: "로지스틱 회귀모형")
    private String dependentVar;    // 종속 변수 (예: "매출액")
    private String independentVar;  // 독립 변수 (예: "인구수")
}