package kr.or.ddit.cs.survey.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.cs.survey.vo.CsSurveyAnswerVO;
import kr.or.ddit.cs.survey.vo.CsSurveyOptionVO;
import kr.or.ddit.cs.survey.vo.CsSurveyQuestionVO;
import kr.or.ddit.cs.survey.vo.CsSurveyRespVO;
import kr.or.ddit.cs.survey.vo.CsSurveyVO;

@Mapper
public interface CsSurveyMapper {
    List<CsSurveyVO> selectSurveyList();

    CsSurveyVO selectSurvey(int surveyId);

    List<CsSurveyQuestionVO> selectQuestions(int surveyId);

    List<CsSurveyOptionVO> selectOptions(int questionId);

    int getSurveyIdByQuestionId(int questionId);

    int getOptionIdByQuestionAndValue(@Param("questionId") int questionId, @Param("optionValue") int value);

    void insertSurveyResp(CsSurveyRespVO resp); // useGeneratedKeys="true" 로 PK 자동 채움

    void insertSurveyAnswer(CsSurveyAnswerVO answer);

    int getNextSurveyRespSeq();

    List<CsSurveyVO> selectSurveyListWithParticipation(String userId);

    List<CsSurveyVO> selectAllSurveyList();

    List<CsSurveyVO> selectAllSurveyListWithCount();

    List<CsSurveyVO> selectSurveyPage(Map<String, Object> paramMap);

    int countSurveys(Map<String, Object> paramMap);

    void insertSurvey(CsSurveyVO survey);

    void insertSurveyQuestion(CsSurveyQuestionVO question);

    void insertSurveyOption(CsSurveyOptionVO option);

    void updateSurveyStatus(CsSurveyVO survey);

    List<Map<String, Object>> selectQuestionScorePct(int questionId);

    List<Map<String, Object>> selectSurveyScorePct(int surveyId);

    List<Map<String, Object>> selectParticipationTrend(int surveyId);

    List<Map<String, Object>> selectTotalValueHistogram(int surveyId);

    List<Map<String, Object>> selectSurveyGenderPct(@Param("surveyId") int surveyId);

    List<Map<String, Object>> selectSurveyAgeBuckets(@Param("surveyId") int surveyId);

    Integer selectLatestResponseId(@Param("surveyId") int surveyId,
                                   @Param("userId") String userId);

    List<CsSurveyAnswerVO> selectAnswersByResponseId(@Param("responseId") int responseId);

    java.util.Date selectSubmittedAt(@Param("responseId") int responseId);

}
