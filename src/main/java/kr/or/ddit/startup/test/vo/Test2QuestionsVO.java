package kr.or.ddit.startup.test.vo;

import lombok.Data;

/**
 * 창업 테스트 문항 정보를 담기 위한 VO 클래스
 */
@Data
public class Test2QuestionsVO {
    private int questionId; // 문항ID
    private int sectionId; // 섹션 ID
    private String questionText; // 문항_내용
}
