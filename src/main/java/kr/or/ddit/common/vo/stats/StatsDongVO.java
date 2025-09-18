package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 행정동 단위 상권 통계 정보를 담기 위한 VO 클래스
 */
@Data
public class StatsDongVO {
    private int statsId; // 통계 ID
    private String bizCodeId; // 업종 대분류 ID
    private int statsYear; // 통계 연도
    private int businessCount; // 사업체 수
    private int employeeCount; // 종사자 수
    private long avgSales; // 평균 매출액
    private long deliveryOrderCount; // 배달주문건수
    private String dongCode; // 법정동 코드
}
