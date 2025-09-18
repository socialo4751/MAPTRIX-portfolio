package kr.or.ddit.market.detailed.vo;

import lombok.Data;

/**
 * 격자 정보를 담기 위한 VO 클래스
 */
@Data
public class DaGridVO {
    private String gridId; // 격자ID
    private Object locGeom5179; // 공간정보
}
