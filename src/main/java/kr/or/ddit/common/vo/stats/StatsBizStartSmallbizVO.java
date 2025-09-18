package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 구별 소상공인 사업체 수
 */
@Data
public class StatsBizStartSmallbizVO {
    private String districtName;
    private int bizCount;
    private double shareRate;
}