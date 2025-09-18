package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 3개년 현황
 */
@Data
public class StatsBizStartTrendVO {
    private int baseYear;
    private int bizCount;
    private int employeeCount;
    private long salesAmount;
}