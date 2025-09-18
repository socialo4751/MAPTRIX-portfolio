package kr.or.ddit.admin.stats.market.vo;

import lombok.Data;

@Data
public class TopLocationVO {
    private String admCode;
    private String admName;
    private long count;           // int → long
}