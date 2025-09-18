package kr.or.ddit.cs.survey.service;

import kr.or.ddit.cs.survey.vo.CsSurveyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CsSurveyService {
    List<CsSurveyVO> getAllSurveys();

    CsSurveyVO getSurveyWithQuestions(int surveyId);

    void saveSurveyResponse(Map<Integer, Integer> answers, String userId);

    List<CsSurveyVO> getAllSurveysWithParticipation(String userId);

    List<CsSurveyVO> selectSurveyList();

    CsSurveyVO selectSurvey(int surveyId);

    List<CsSurveyVO> selectAllSurveyList();  // 관리자용

    List<CsSurveyVO> selectAllSurveyListWithCount();

    List<CsSurveyVO> selectSurveyPage(Map<String, Object> paramMap);

    int countSurveys(Map<String, Object> paramMap); // 추가

    void insertSurvey(CsSurveyVO survey);

    void insertSurveyWithQuestions(CsSurveyVO survey);

    CsSurveyVO selectSurveyWithQuestions(int surveyId);

    void updateSurveyStatus(CsSurveyVO survey);

    // 설문 전체 질문별 점수 분포(%)
    List<Map<String, Object>> getSurveyScorePct(int surveyId);

    // 특정 질문의 점수 분포(%)
    List<Map<String, Object>> getQuestionScorePct(int questionId);

    // 설문 참여 추이(일별 응답 수)
    List<Map<String, Object>> getParticipationTrend(int surveyId);

    // 설문 총점 히스토그램
    List<Map<String, Object>> getTotalValueHistogram(int surveyId);

    List<Map<String, Object>> getSurveyGenderPct(int surveyId);

    List<Map<String, Object>> getSurveyAgeBuckets(int surveyId);

    Integer findLatestResponseId(int surveyId, String userId);

    Map<Integer, Integer> getSelectedOptionIdMap(int responseId);

    java.util.Date getSubmittedAt(int responseId);
}
