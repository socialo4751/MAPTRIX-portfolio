package kr.or.ddit.admin.stats.market.vo;

import lombok.Data;

@Data
public class MarketStatsKpiVO {
    private long totalCount;
    private long uniqueUserCount;
    private double successRate;   // 0~100(%) 권장
    private double avgDurationMs; // 평균 처리시간 ms
}
