package kr.or.ddit.admin.stats.market.vo;

import java.time.LocalDate;

import lombok.Data;

@Data
public class DailyTrendVO {
    private LocalDate analysisDate; // Date → LocalDate
    private long count;
}