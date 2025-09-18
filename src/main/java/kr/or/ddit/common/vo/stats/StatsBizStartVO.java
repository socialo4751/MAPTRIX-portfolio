package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 상권 통계 - 구별_사업체현황_통계
 */
@Data
public class StatsBizStartVO {
	private String districtName;
	private int activeCount;
	private double shareRate;
}