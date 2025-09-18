package kr.or.ddit.attraction.flow.vo;

import java.util.Date;

import lombok.Data;

/**
 * 동선 로그 정보를 담기 위한 VO 클래스
 */
@Data
public class StFlowLogVO {
    private int logId; // 동선로그고유ID
    private String userId; // 회원고유번호
    private int polyId; // 동선폴리곤고유ID
    private Double logLon; // 위도로그
    private Double logLat; // 경도로그
    private Date createdAt; // 로그등록일
}
