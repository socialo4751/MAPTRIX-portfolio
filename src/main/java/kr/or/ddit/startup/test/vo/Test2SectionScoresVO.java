package kr.or.ddit.startup.test.vo;

import lombok.Data;

/**
 * 창업 테스트 영역별 점수 정보를 담기 위한 VO 클래스
 */
@Data
public class Test2SectionScoresVO {
    private int sectionScoreId; // 영역별점수ID
    private int sessionId; // 세션 ID
    private Integer sectionScore; // 영역별점수
    private String analysisComment; // 분석 코멘트
    private int sectionId; // 섹션 ID
}
