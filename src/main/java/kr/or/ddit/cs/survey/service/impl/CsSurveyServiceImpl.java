package kr.or.ddit.cs.survey.service.impl;

import kr.or.ddit.cs.survey.mapper.CsSurveyMapper;
import kr.or.ddit.cs.survey.service.CsSurveyService;
import kr.or.ddit.cs.survey.vo.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class CsSurveyServiceImpl implements CsSurveyService {

    @Autowired
    private CsSurveyMapper mapper;

    @Override
    public List<CsSurveyVO> getAllSurveys() {
        return mapper.selectSurveyList();
    }

    @Override
    public CsSurveyVO getSurveyWithQuestions(int surveyId) {
        CsSurveyVO survey = mapper.selectSurvey(surveyId); // 설문 기본 정보
        List<CsSurveyQuestionVO> questions = mapper.selectQuestions(surveyId);

        for (CsSurveyQuestionVO q : questions) {
            List<CsSurveyOptionVO> options = mapper.selectOptions(q.getQuestionId());
            q.setOptions(options);
        }

        survey.setQuestions(questions);
        return survey;
    }

    @Transactional
    @Override
    public void saveSurveyResponse(Map<Integer, Integer> answers, String userId) {
        int surveyId = mapper.getSurveyIdByQuestionId(answers.keySet().iterator().next());

        // 1. 시퀀스로 responseId 미리 가져오기
        int responseId = mapper.getNextSurveyRespSeq();

        // 2. RESP 저장
        CsSurveyRespVO resp = new CsSurveyRespVO();
        resp.setResponseId(responseId); // 수동으로 세팅
        resp.setSurveyId(surveyId);
        resp.setUserId(userId);
        resp.setTotalValue(
                answers.values().stream().mapToInt(Integer::intValue).sum()
        );
        mapper.insertSurveyResp(resp); // 이제 자동 키 주입이 아니라 명시적 삽입

        // 3. ANSWER들 저장
        for (Map.Entry<Integer, Integer> entry : answers.entrySet()) {
            int questionId = entry.getKey();
            int optionValue = entry.getValue();
            int optionId = mapper.getOptionIdByQuestionAndValue(questionId, optionValue);

            CsSurveyAnswerVO answer = new CsSurveyAnswerVO();
            answer.setResponseId(responseId);
            answer.setQuestionId(questionId);
            answer.setOptionId(optionId);

            mapper.insertSurveyAnswer(answer);
        }
    }

    @Override
    public List<CsSurveyVO> getAllSurveysWithParticipation(String userId) {
        return mapper.selectSurveyListWithParticipation(userId);
    }

    @Override
    public List<CsSurveyVO> selectSurveyList() {
        return mapper.selectSurveyList(); // Mapper 호출
    }

    @Override
    public CsSurveyVO selectSurvey(int surveyId) {
        return mapper.selectSurvey(surveyId); // Mapper 호출
    }

    @Override
    public List<CsSurveyVO> selectAllSurveyList() {
        return mapper.selectAllSurveyList();  // 위에 새로 추가한 XML 쿼리 사용
    }

    @Override
    public List<CsSurveyVO> selectAllSurveyListWithCount() {
        return mapper.selectAllSurveyListWithCount();
    }

    @Override
    public List<CsSurveyVO> selectSurveyPage(Map<String, Object> paramMap) {
        return mapper.selectSurveyPage(paramMap);
    }

    @Override
    public int countSurveys(Map<String, Object> paramMap) {
        return mapper.countSurveys(paramMap);
    }

    @Override
    public void insertSurvey(CsSurveyVO survey) {
        mapper.insertSurvey(survey);
    }

    @Transactional
    @Override
    public void insertSurveyWithQuestions(CsSurveyVO survey) {
        // 1. 설문 insert
        mapper.insertSurvey(survey); // surveyId가 세팅됨

        // 2. 문항 및 선택지 insert
        int order = 1;
        for (CsSurveyQuestionVO question : survey.getQuestions()) {
            question.setSurveyId(survey.getSurveyId());
            question.setQuestionOrder(order++);
            mapper.insertSurveyQuestion(question);

            // 3. 선택지들 insert
            int optionOrder = 1;
            for (CsSurveyOptionVO option : question.getOptions()) {
                option.setQuestionId(question.getQuestionId());
                option.setOptionValue(option.getOptionValue());
                mapper.insertSurveyOption(option);
            }
        }
    }

    @Override
    public CsSurveyVO selectSurveyWithQuestions(int surveyId) {
        CsSurveyVO survey = mapper.selectSurvey(surveyId); // 설문 기본 정보
        List<CsSurveyQuestionVO> questions = mapper.selectQuestions(surveyId);

        for (CsSurveyQuestionVO question : questions) {
            List<CsSurveyOptionVO> options = mapper.selectOptions(question.getQuestionId());
            question.setOptions(options); // 질문에 옵션 붙이기
        }

        survey.setQuestions(questions); // 설문에 질문 리스트 붙이기
        return survey;
    }

    @Override
    public void updateSurveyStatus(CsSurveyVO survey) {
        mapper.updateSurveyStatus(survey);
    }

    @Override
    public List<Map<String, Object>> getSurveyScorePct(int surveyId) {
        return mapper.selectSurveyScorePct(surveyId);
    }

    @Override
    public List<Map<String, Object>> getQuestionScorePct(int questionId) {
        return mapper.selectQuestionScorePct(questionId);
    }

    @Override
    public List<Map<String, Object>> getParticipationTrend(int surveyId) {
        return mapper.selectParticipationTrend(surveyId);
    }

    @Override
    public List<Map<String, Object>> getTotalValueHistogram(int surveyId) {
        return mapper.selectTotalValueHistogram(surveyId);
    }

    @Override
    public List<Map<String, Object>> getSurveyGenderPct(int surveyId) {
        return mapper.selectSurveyGenderPct(surveyId);
    }

    @Override
    public List<Map<String, Object>> getSurveyAgeBuckets(int surveyId) {
        return mapper.selectSurveyAgeBuckets(surveyId);
    }

    @Override
    public Integer findLatestResponseId(int surveyId, String userId) {
        return mapper.selectLatestResponseId(surveyId, userId);
    }

    @Override
    public Map<Integer, Integer> getSelectedOptionIdMap(int responseId) {
        List<CsSurveyAnswerVO> list = mapper.selectAnswersByResponseId(responseId);
        Map<Integer, Integer> map = new java.util.HashMap<>();
        for (CsSurveyAnswerVO a : list) {
            map.put(a.getQuestionId(), a.getOptionId()); // 질문ID -> 옵션ID
        }
        return map;
    }

    @Override
    public java.util.Date getSubmittedAt(int responseId) {
        return mapper.selectSubmittedAt(responseId);
    }


}
