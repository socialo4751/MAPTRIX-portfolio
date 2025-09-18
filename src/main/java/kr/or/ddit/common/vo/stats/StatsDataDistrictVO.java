package kr.or.ddit.common.vo.stats;

import lombok.Data;

/**
 * 자치구 단위 통계 데이터를 담기 위한 VO 클래스
 */
@Data
public class StatsDataDistrictVO {
    private int statsId; // 통계 ID
    private String districtCode; // 행정구 코드 ID
    private String catCodeId; // 업종 대분류_ID
    private int statsYear; // 통계 연도
    private Integer statsMonth; // 통계 월
    private Integer openCount; // 해당 월 개업 수
    private Integer closeCount; // 해당 월 폐업 수
    private Integer totalStoreCount; // 해당 월말 기준 총 사업체 수
}
