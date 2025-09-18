package kr.or.ddit.admin.stats.market.vo;

import lombok.Data;

@Data
public class HourlyCountVO {
    private Integer hour;         // 0~23 (NULL 가능성 있으면 Integer)
    private long count;
}
