package kr.or.ddit.attraction.point.vo;

import java.util.Date;

import lombok.Data;

/**
 * 사용자 포인트 변경 이력 정보를 담기 위한 VO 클래스
 */
@Data
public class StUserPointHistoryVO {
    private String pointLogHistoryId;
    private String userId;
    private Integer changeAmount;
    private String changeType;
    private Integer totalAfter;
    private String description;
    private Date createdAt;
}
