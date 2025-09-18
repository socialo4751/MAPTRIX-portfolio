package kr.or.ddit.cs.survey.vo;

import lombok.Data;

/**
 * 설문조사 선택지 정보를 담기 위한 VO 클래스
 */
@Data
public class CsSurveyOptionVO {
    private int optionId; // 선택지ID
    private int questionId; // 문항ID
    private String optionText; // 선택지내용
    private int optionValue; // 점수

    private int optionOrder;
}
