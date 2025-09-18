package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 매출액 규모
 */
@Data
public class StatsBizStartSalesrangeVO {
    private String salesRange;
    private int totalBizCount;
    private int smallbizCount;
    private int commonBizCount;
}