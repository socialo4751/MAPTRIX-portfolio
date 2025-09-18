package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 창폐업통계
 */
@Data
public class StatsBizStartCloseVO {
    private String districtName;
    private int startupCount;
    private int closureCount;
    private int activeCount;
    private double startupRate;
    private double closureRate;
}