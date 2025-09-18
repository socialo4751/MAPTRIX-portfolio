package kr.or.ddit.startup.test.vo;

import java.util.Date;

import lombok.Data;

/**
 * 창업 테스트 세션 정보를 담기 위한 VO 클래스
 */
@Data
public class Test1SessionsVO {
    private int sessionId; // 세션 ID
    private String userId; // 회원고유번호
    private int testId; // 테스트 ID
    private String guestSessionId; // 비로그인세션 ID
    private Date startTime; // 시작 시각
    private Date endTime; // 종료 시각
    private String status; // 상태
    private Integer totalScore; // 최종 획득 점수
    private String resultSummary; // 결과 요약
    private String resultDetails; // 결과 상세 내용
}
