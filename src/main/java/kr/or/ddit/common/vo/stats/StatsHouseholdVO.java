package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 행정동 단위 통계 데이터_가구 통계를 담기 위한 VO 클래스
 */
@Data
public class StatsHouseholdVO {
	private String admCode; // 행정동 코드 ID
	private int statsYear; // 연도
	private String sgisCode; // 원본 통계 코드
	private int statsValue; // 통계값
}
