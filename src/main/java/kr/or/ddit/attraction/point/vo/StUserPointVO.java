package kr.or.ddit.attraction.point.vo;

import lombok.Data;

/**
 * 사용자 포인트 정보를 담기 위한 VO 클래스
 */
@Data
public class StUserPointVO {
    private String userId;
    private Integer totalPoint;
}
