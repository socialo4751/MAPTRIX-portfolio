package kr.or.ddit.startup.test.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.startup.test.vo.Test1SectionsVO;
import kr.or.ddit.startup.test.vo.Test2QuestionsVO;
import kr.or.ddit.startup.test.vo.Test3OptionsVO;

@Mapper
public interface TestMapper {
	
    // 1. 모든 질문 목록을 가져온다.
    List<Test2QuestionsVO> getQuestions();
    
    // 2. 특정 질문에 해당하는 보기 목록을 가져온다.
    List<Test3OptionsVO> getOptions(int questionId);
    
    // 3. 여러 ID에 해당하는 보기 목록을 한번 가져온다.
    List<Test3OptionsVO> getOptionsByIds(List<Integer> optionIds);
    
    // 4. 모든 섹션 목록 가져오기 
    List<Test1SectionsVO> getSections();
    
}