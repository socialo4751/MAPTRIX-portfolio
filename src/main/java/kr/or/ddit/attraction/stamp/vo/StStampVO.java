package kr.or.ddit.attraction.stamp.vo;

import java.util.Date;

import lombok.Data;

/**
 * 스탬프 정보를 담기 위한 VO 클래스
 */
@Data
public class StStampVO {
    private int stampId;
    private String roadId; // 기초구역 통합 일련번호 (도로 구간 일련번호+ 시군구코드)
    private String userId; // 회원고유번호
    private String areaId; // 기초구역 ID
    private Date createdAt; // 스탬프등록일
}
