package kr.or.ddit.cs.survey.vo;

import java.util.List;

import lombok.Data;

/**
 * 설문조사 문항 정보를 담기 위한 VO 클래스
 */
@Data
public class CsSurveyQuestionVO {
    private int questionId; // 문항ID
    private int surveyId; // 설문ID
    private int questionOrder; // 설문 순서
    private String questionText; // 문항내용

    private List<CsSurveyOptionVO> options;
}
