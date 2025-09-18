package kr.or.ddit.market.detailed.vo;

import lombok.Data;

/**
 * 데이터 분석 모델의 지표 정보를 담기 위한 VO 클래스
 */
@Data
public class DaIndicatorVO {
    private int indicatorId; // 지표 ID
    private int modelId; // 분석모델ID
    private String variableType; // 변수 구분
    private String variableName; // 변수명
    private String variableDesc; // 변수 설명
}
