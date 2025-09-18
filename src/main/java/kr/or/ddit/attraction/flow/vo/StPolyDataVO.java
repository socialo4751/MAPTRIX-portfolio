package kr.or.ddit.attraction.flow.vo;

import lombok.Data;

/**
 * 동선 폴리곤 데이터를 담기 위한 VO 클래스
 */
@Data
public class StPolyDataVO {
    private int polyId; // 동선폴리곤고유ID
    private String userId; // 회원고유번호
    private String polygonData; // 폴리곤데이터
    private Integer sPointLogId; // 시작점로그
    private Integer fPointLogId; // 끝점로그
    private Integer flowDis; // 이동거리
}
