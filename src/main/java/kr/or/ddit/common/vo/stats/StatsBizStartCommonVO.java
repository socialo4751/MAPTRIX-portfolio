package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 구별 생활밀접업종 기본현황
 */
@Data
public class StatsBizStartCommonVO {
    private String districtName;
    private int businessCount;
    private double businessRatio;
    private int employeeCount;
    private double employeeRatio;
    private int salesAmount;
    private double salesRatio;
    private double avgSalesAmount;
    private double avgOperatingPeriod;

}