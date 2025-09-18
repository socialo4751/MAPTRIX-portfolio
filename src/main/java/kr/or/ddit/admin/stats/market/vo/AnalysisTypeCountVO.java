package kr.or.ddit.admin.stats.market.vo;

import lombok.Data;

@Data
public class AnalysisTypeCountVO {
    private String analysisType;  // SIMPLE/DETAIL
    private long count;
}