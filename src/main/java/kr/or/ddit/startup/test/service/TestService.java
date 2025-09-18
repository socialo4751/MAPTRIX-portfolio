package kr.or.ddit.startup.test.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.startup.test.vo.Test2QuestionsVO;
import kr.or.ddit.startup.test.vo.Test3OptionsVO;

public interface TestService {
	
	// 테스트에 필요한 모든 질문과 각 질문에 해당하는 보기 목록을 가져옴
    public Map<Test2QuestionsVO, List<Test3OptionsVO>> getTestQuestionsWithOptions();
    
    // 사용자가 제출한 답안을 바탕으로 점수 계산 및 최종결과
    public Map<String, Object> calculateAndGetResult(Map<String, String> submittedAnswers);
}