package kr.or.ddit.admin.stats.market.vo;

import lombok.Data;

@Data
public class DemographicCountVO {
    private String ageBand;       // "10S", "20S" 등
    private String gender;        // 'M','F','U' 등
    private long count;
}
