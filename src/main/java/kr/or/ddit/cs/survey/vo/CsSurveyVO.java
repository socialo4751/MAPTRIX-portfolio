package kr.or.ddit.cs.survey.vo;

import java.util.List;

import lombok.Data;

/**
 * 설문조사 정보를 담기 위한 VO 클래스
 */
@Data
public class CsSurveyVO {
    private int surveyId; // 설문ID
    private String surveyTitle; // 설문제목
    private String surveyDescription; // 설문설명
    private String useYn; // 사용여부

    // ← 여기를 추가!
    private List<CsSurveyQuestionVO> questions;
    
    private int participantCount; // 참여자 수

    private boolean participated;

    public boolean isParticipated() {
        return participated;
    }

    public void setParticipated(boolean participated) {
        this.participated = participated;
    }

}
