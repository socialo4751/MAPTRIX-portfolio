package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 행정동 단위 통계 데이터_신용카드 통계를 담기 위한 VO 클래스
 */
@Data
public class StatsCreditCardVO {
	private String admCode; // 행정동 코드 ID
	private int statsYear; // 연도
	private int avgPaymentAmount; // 신용카드 평균 매출
}
