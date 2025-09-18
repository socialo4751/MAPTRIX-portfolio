package kr.or.ddit.cs.survey.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * 설문조사 응답 정보를 담기 위한 VO 클래스
 */
@Data
public class CsSurveyRespVO {
    private int responseId; // 응답ID
    private int surveyId; // 설문ID
    private String userId; // 이용자고유번호
    private Date responsedAt; // 응답시간
    private int totalValue; // 총점수

    private List<CsSurveyAnswerVO> answers;
}
