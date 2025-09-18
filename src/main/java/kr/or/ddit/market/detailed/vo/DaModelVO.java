package kr.or.ddit.market.detailed.vo;

import lombok.Data;

/**
 * 데이터 분석 모델 정보를 담기 위한 VO 클래스
 */
@Data
public class DaModelVO {
    private int modelId; // 분석모델ID
    private String modelName; // 모델명
    private String description; // 모델설명
}
