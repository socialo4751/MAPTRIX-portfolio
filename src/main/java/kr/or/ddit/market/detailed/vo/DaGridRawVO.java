package kr.or.ddit.market.detailed.vo;

import lombok.Data;

/**
 * 격자 단위 원시 데이터 정보를 담기 위한 VO 클래스
 */
@Data
public class DaGridRawVO {
    private int rawDataId; // 데이터ID
    private String gridId; // 격자ID
    private Integer year; // 년도
    private Integer population; // 인구_데이터
    private Integer businessCount; // 사업체_데이터
    private Integer empCount; // 종사자_데이터
    private Long avgLandPrice; // 공시지가_데이터
    private Long totalSales; // 평균매출액_데이터
}
