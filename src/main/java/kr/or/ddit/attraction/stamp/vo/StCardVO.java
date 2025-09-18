package kr.or.ddit.attraction.stamp.vo;

import java.util.Date;

import lombok.Data;

/**
 * 스탬프 카드 정보를 담기 위한 VO 클래스
 */
@Data
public class StCardVO {
    private String userId; // 회원고유번호
    private String areaId; // 기초구역 ID
    private Date createdAt; // 카드 생성일
    private int stampCount; // 카드안에 있는 스탬프 갯수
    private int stampCkCount; // 카드안에 있을 수 있는 스탬프 갯수
}
