package kr.or.ddit.market.detailed.vo;

import java.util.Date;

import lombok.Data;

/**
 * 데이터 분석 결과 정보를 담기 위한 VO 클래스
 */
@Data
public class DaResultVO {
    private int resultId; // 분석결과ID
    private String gridId; // 격자ID
    private int modelId; // 분석모델ID
    private String resultData; // 분석결과(JSON)
    private Date calculatedAt; // 계산일시
    private Integer resultFigure; // 결과값
}
