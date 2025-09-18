package kr.or.ddit.startup.test.vo;

import lombok.Data;

/**
 * 창업 테스트 문항의 보기 정보를 담기 위한 VO 클래스
 */
@Data
public class Test3OptionsVO {
    private int optionId; // 보기 ID
    private int questionId; // 문항ID
    private String optionText; // 보기_내용
    private Integer optionScore; // 보기_점수
}
