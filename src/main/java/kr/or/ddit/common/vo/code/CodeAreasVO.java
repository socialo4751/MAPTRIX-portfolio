package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 기초 구역 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeAreasVO {
    private String areaId; // 기초구역 ID
    private String sigCd; // 시군구 코드
    private int areaSqkm; // 면적 (제곱킬로미터)
    private String geomWkt; // 공간 데이터 (WKT 형식)
}
