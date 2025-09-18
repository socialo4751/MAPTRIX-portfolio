package kr.or.ddit.gemini.test.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.gemini.client.GeminiClient;
import kr.or.ddit.gemini.test.dto.example.GridDataVo;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto.Schema;
import kr.or.ddit.gemini.test.dto.response.AnalysisDto;
import kr.or.ddit.gemini.test.service.GeminiTestService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class GeminiTestServiceImpl implements GeminiTestService {
	
    @Autowired 
    private GeminiClient geminiClient;

	@Override
	public AnalysisDto getAnalysisForGrid(GridDataVo gridData) {
		// 1. 프롬프트 문자열 생성 (기존 로직과 동일)
		String prompt = String.format(
				"당신은 대한민국 상권 분석 전문 데이터 사이언티스트입니다. "
						+ "1제곱킬로미터 크기의 특정 상권 격자에 대한 통계 분석 결과를 해석하고, 이를 바탕으로 전문적인 리포트를 작성해야 합니다.\n\n" + "## 분석 개요 ##\n"
						+ "- 분석 모델: %s\n" + "- 종속 변수 (결과): %s\n" + "- 독립 변수 (원인): %s\n\n" + "## 분석 대상 데이터 ##\n"
						+ "- 격자 고유 ID: %s\n"
						+ "- p-value: %f (이 값은 독립 변수가 종속 변수에 미치는 영향의 통계적 유의성을 나타냅니다. 0.05 미만일 때 통계적으로 유의미하다고 해석합니다.)\n"
						+ "- 주요 행정동 1: %s (격자 면적의 %d%% 차지)\n" + "- 주요 행정동 2: %s (격자 면적의 %d%% 차지)\n\n"
						+ "## 리포트 작성 요청 ##\n" + "위 모든 정보를 종합적으로 고려하여, 이 상권의 특징, 잠재력, 위험 요소를 심층적으로 분석하고, "
						+ "비전문가도 이해할 수 있도록 아래 JSON 스키마에 맞춰 매우 구체적인 리포트를 작성해주세요.",
				gridData.getAnalysisModel(), gridData.getDependentVar(), gridData.getIndependentVar(),
				gridData.getGridId(), gridData.getPValue(), gridData.getDong1Name(), gridData.getDong1Ratio(),
				gridData.getDong2Name(), gridData.getDong2Ratio());

		// 2. AI에게 기대하는 응답의 JSON 스키마 정의 (기존 로직과 동일)
		Map<String, Schema> properties = Map.of("summary",
				new Schema("STRING", "분석 결과에 대한 핵심 요약 (2~3문장)", null, null, null), "riskLevel",
				new Schema("STRING", "종합적인 위험도 평가 (안정, 기회, 주의, 위험 중 하나)", null, null, null), "positiveSignal",
				new Schema("STRING", "p-value와 행정동 특성을 고려한 긍정적 신호 및 기회 요인", null, null, null), "negativeSignal",
				new Schema("STRING", "p-value와 행정동 특성을 고려한 부정적 신호 및 위기 요인", null, null, null), "recommendations",
				new Schema("ARRAY", "분석에 기반한 2가지 구체적인 추천 전략", null, new Schema("STRING", null, null, null, null),
						null));
		List<String> requiredFields = List.of("summary", "riskLevel", "positiveSignal", "negativeSignal",
				"recommendations");
		Schema analysisSchema = new Schema("OBJECT", null, properties, null, requiredFields);
		
		// 3. 요청 DTO 생성
		GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, analysisSchema);

		// 4. [핵심 변경] GeminiClient에 API 호출 위임
		// 복잡한 WebClient 호출 및 에러 처리 로직이 단 한 줄로 변경됩니다.
		return geminiClient.prompt(requestDto, AnalysisDto.class);
	}
}
