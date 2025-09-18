package kr.or.ddit.gemini.test.service;

import kr.or.ddit.gemini.test.dto.example.GridDataVo;
import kr.or.ddit.gemini.test.dto.response.AnalysisDto;

public interface GeminiTestService {

    // 테스트용 메서드
    AnalysisDto getAnalysisForGrid(GridDataVo gridData);
	
}
