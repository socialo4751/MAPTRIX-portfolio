package kr.or.ddit.startup.test.vo;

import java.util.Date;

import lombok.Data;

/**
 * 창업 테스트 기본 정보를 담기 위한 VO 클래스
 */
@Data
public class Test0StartupVO {
    private int testId; // 테스트 ID
    private String testName; // 테스트명
    private String testDescription; // 테스트_설명
    private Integer maxScore; // 테스트 총 최고점
    private Date createdAt; // 생성일시
    private Date updatedAt; // 수정일시
}
