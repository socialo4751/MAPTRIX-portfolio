package kr.or.ddit.cs.survey.vo;

import lombok.Data;

/**
 * 설문조사 개별 응답 정보를 담기 위한 VO 클래스
 */
@Data
public class CsSurveyAnswerVO {
    private int answerId; // 개별응답ID
    private int responseId; // 응답ID
    private int questionId; // 문항ID
    private int optionId; // 선택지ID
}
