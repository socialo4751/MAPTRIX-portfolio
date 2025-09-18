package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 도로명 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeRoadNameVO {
    private String roadId; // 기초구역 통합 일련번호 (도로 구간 일련번호+ 시군구코드)
    private String sigCd; // 시군구 코드
    private int roadLt; // 도로 길이 (킬로미터)
    private String geomWkt; // 공간 데이터 (WKT 형식 LINESTRING)
    private Integer rdsManNo; // 도로 구간 일련번호
    private String roadName; // 도로명 이름
    private String rnCd; // 도로명코드
}
