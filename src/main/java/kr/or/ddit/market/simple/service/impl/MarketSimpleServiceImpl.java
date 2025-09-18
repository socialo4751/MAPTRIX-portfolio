package kr.or.ddit.market.simple.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.gemini.client.GeminiClient;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto.Schema;
import kr.or.ddit.market.simple.dto.response.BusinessAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HouseholdAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HousingAnalysisDto;
import kr.or.ddit.market.simple.dto.response.MarketSimpleAnalysisDto;
import kr.or.ddit.market.simple.dto.response.PopulationAnalysisDto;
import kr.or.ddit.market.simple.mapper.MarketMapper;
import kr.or.ddit.market.simple.service.MarketSimpleService;
import kr.or.ddit.market.simple.vo.UserPreferenceVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MarketSimpleServiceImpl implements MarketSimpleService {

    @Autowired
    private MarketMapper marketMapper;

    @Autowired
    private GeminiClient geminiClient;
    
    @Autowired
    private ObjectMapper objectMapper;

    // 1. 시군구 VO를 불러온다.
    @Override
    public List<CodeDistrictVO> getDistrictList() {
        return marketMapper.getDistrictList();
    }
    
    // 2. 업종 대분류 VO를 불러온다.
    @Override
    public List<CodeBizVO> getBizCodeList() {
        return marketMapper.getBizCodeList();
    }
    
    // 3. 업종 중분류 VO를 불러온다.
    @Override
    public List<CodeBizVO> findSubCodeBizByParentId(String parentCodeId) {
        return marketMapper.findSubCodeBizByParentId(parentCodeId);
    }
    
    // 4. 행정도 VO를 불러온다.
    @Override
    public List<CodeAdmDongVO> selectAdmDongList(int districtId) {
        return this.marketMapper.selectAdmDongList(districtId);
    }
    
    // 5. 분석 결과 조회
    @Override
    public Map<String, Object> getAnalysisReport(Map<String, Object> params) {
        Map<String, Object> reportMap = new HashMap<>();
        reportMap.put("bizStats", marketMapper.getBusinessStats(params));
        reportMap.put("empStats", marketMapper.getEmployeeStats(params));
        reportMap.put("creditCardStats", marketMapper.getCreditCardStats(params));
        reportMap.put("householdStats", marketMapper.getHouseholdStats(params));
        reportMap.put("housingStats", marketMapper.getHousingStats(params));
        reportMap.put("populationStats", marketMapper.getPopulationStats(params));
        
        return reportMap;
    }
    
    // 6. 행정동 코드로 동이름과 구이름을 조회
    @Override
	public Map<String, Object> selectLocationNames(String admCode) {
		return marketMapper.selectLocationNames(admCode);
	}
    
    // 7. 분석결과 해석 관련 마스터코드 디테일 조회
    @Override
    public List<CodeDetailVO> getSgisCodeDetailList() {
        return marketMapper.getSgisCodeDetailList();
    }
    
    // 8. 분석결과 신용카드 구 단위 평균 매출 조회
    @Override
    public Map<String, Object> getAvgPaymentByDistrict(String admCode, String year) {
        Map<String, Object> params = new HashMap<>();
        params.put("admCode", admCode);
        params.put("year", year);
        
        return marketMapper.getAvgPaymentByDistrict(params);
    }
    
    // 9. [추가] 전체 신용카드 소비 평균 조회
    @Override
    public int getTotalAvgPayment() {
        return this.marketMapper.getTotalAvgPayment();
    }

    // --- AI 해석 관련 메서드 ---

    @Override
    @LogEvent(eventType="ACTION", feature="ANALYSIS_SIMPLE")
    public MarketSimpleAnalysisDto interpretMarketAnalysis(Map<String, Object> analysisResult, List<CodeDetailVO> sgisCodes) {
        String prompt = generatePromptFromData(analysisResult, sgisCodes);

        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "핵심 요약", null, null, null),
            "opportunities", new Schema("STRING", "기회 요인", null, null, null),
            "threats", new Schema("STRING", "위기 요인", null, null, null),
            "recommendations", new Schema("ARRAY", "추천 전략", null, new Schema("STRING", null, null, null, null), null)
        );
        Schema schema = new Schema("OBJECT", null, properties, null, List.of("summary", "opportunities", "threats", "recommendations"));

        GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, schema);
        return geminiClient.prompt(requestDto, MarketSimpleAnalysisDto.class);
    }

    private String generatePromptFromData(Map<String, Object> analysisResult, List<CodeDetailVO> sgisCodes) {
        try {
            return """
                    당신은 대한민국 상권 분석 전문 데이터 사이언티스트입니다.
                       다음은 대전광역시의 하나의 행정동의 상권 통계 분석 결과입니다.
                       아래 데이터를 바탕으로 이 지역의 특징, 기회, 위험 요소를 요약하고 구체적인 추천 전략을 제시해주세요.

                       ## 분석 데이터 ##
                       %s

                       ## 해석 코드 참고 ##
                       %s

                       출력은 아래 JSON 스키마에 맞춰주세요.
                       """.formatted(objectMapper.writeValueAsString(analysisResult), objectMapper.writeValueAsString(sgisCodes));
        } catch (JsonProcessingException e) {
            log.error("프롬프트 생성 중 JSON 변환 실패", e);
            throw new RuntimeException("프롬프트 생성 실패: JSON 문자열 변환 중 오류 발생", e);
        }
    }

    @Override
    public PopulationAnalysisDto interpretPopulationData(List<Map<String, Object>> populationStats, List<CodeDetailVO> sgisCodes) {
        String prompt = generatePopulationPrompt(populationStats, sgisCodes);

        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "인구 통계 데이터에 대한 1~2 문장의 핵심 요약", null, null, null),
            "mainAgeGroup", new Schema("STRING", "가장 인구수가 많은 핵심 연령대(예: '30-40대')", null, null, null),
            "genderRatioFeature", new Schema("STRING", "성비 불균형이나 특정 성별의 집중도 등 성별 관련 특징", null, null, null),
            "opportunities", new Schema("ARRAY", "분석된 인구 특성에 기반한 사업 기회 요인 2가지", null, new Schema("STRING", null, null, null, null), null)
        );
        List<String> requiredFields = List.of("summary", "mainAgeGroup", "genderRatioFeature", "opportunities");
        Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

        GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, responseSchema);
        return geminiClient.prompt(requestDto, PopulationAnalysisDto.class);
    }

    private String generatePopulationPrompt(List<Map<String, Object>> populationStats, List<CodeDetailVO> sgisCodes) {
        try {
            String statsJson = objectMapper.writeValueAsString(populationStats);
            String codesJson = objectMapper.writeValueAsString(sgisCodes);
            return """
                    당신은 대한민국 상권 분석을 전문으로 하는 데이터 분석가입니다.
                    주어진 특정 지역의 인구 통계 데이터를 보고, 상권의 관점에서 핵심적인 특징과 사업 기회를 찾아내야 합니다.

                    ## 분석 대상 데이터 ##
                    - 아래는 특정 행정동의 인구 관련 통계(SGIS) 데이터입니다. 'statsValue'는 인구수 또는 관련 지표 값입니다.
                    - 데이터: %s

                    ## 코드 참고 ##
                    - 'sgisCode' 필드는 아래 코드표를 참고하여 해석해야 합니다.
                    - 코드표: %s

                    ## 분석 요청 사항 ##
                    - 위 데이터를 종합하여, 비전문가도 쉽게 이해할 수 있도록 아래 JSON 스키마에 맞춰 인구 특성을 분석해주세요.
                    - 특히 어떤 연령층이 많고, 성비는 어떠하며, 이를 통해 어떤 종류의 사업 기회를 엿볼 수 있는지 구체적으로 설명해야 합니다.
                    """.formatted(statsJson, codesJson);
        } catch (JsonProcessingException e) {
            log.error("인구 분석 프롬프트 생성 중 JSON 변환 실패", e);
            throw new RuntimeException("프롬프트 생성에 실패했습니다.");
        }
    }

    @Override
    public HouseholdAnalysisDto interpretHouseholdData(List<Map<String, Object>> householdStats, List<CodeDetailVO> sgisCodes) {
        String prompt = generateHouseholdPrompt(householdStats, sgisCodes);

        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "가구 통계 데이터에 대한 1~2 문장의 핵심 요약", null, null, null),
            "mainHouseholdType", new Schema("STRING", "가장 비중이 높은 핵심 가구 유형(예: '1인 가구')", null, null, null),
            "householdSizeFeature", new Schema("STRING", "평균 가구원 수나 1인 가구 비율 등 가구 규모와 관련된 특징", null, null, null),
            "opportunities", new Schema("ARRAY", "분석된 가구 특성에 기반한 사업 기회 요인 2가지", null, new Schema("STRING", null, null, null, null), null)
        );
        List<String> requiredFields = List.of("summary", "mainHouseholdType", "householdSizeFeature", "opportunities");
        Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

        GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, responseSchema);
        return geminiClient.prompt(requestDto, HouseholdAnalysisDto.class);
    }

    private String generateHouseholdPrompt(List<Map<String, Object>> householdStats, List<CodeDetailVO> sgisCodes) {
        try {
            String statsJson = objectMapper.writeValueAsString(householdStats);
            String codesJson = objectMapper.writeValueAsString(sgisCodes);
            return """
                    당신은 특정 상권의 소비 패턴을 분석하는 시장 분석 전문가입니다.
                    주어진 지역의 가구 통계 데이터를 보고, 상권의 관점에서 핵심적인 특징과 사업 기회를 찾아내야 합니다.

                    ## 분석 대상 데이터 ##
                    - 아래는 특정 행정동의 가구 관련 통계(SGIS) 데이터입니다. 'statsValue'는 가구수 또는 관련 지표 값입니다.
                    - 데이터: %s

                    ## 코드 참고 ##
                    - 'sgisCode' 필드는 아래 코드표를 참고하여 해석해야 합니다. (예: 'HOU001'은 '총가구수', 'HOU006'은 '1인가구')
                    - 코드표: %s

                    ## 분석 요청 사항 ##
                    - 위 데이터를 종합하여, 비전문가도 쉽게 이해할 수 있도록 아래 JSON 스키마에 맞춰 가구 특성을 분석해주세요.
                    - 특히 어떤 유형의 가구(1인가구, 2세대가구 등)가 많고, 평균 가구원수는 어떠하며, 이를 통해 어떤 종류의 사업(예: 소포장 식료품, 가족 단위 외식) 기회를 엿볼 수 있는지 구체적으로 설명해야 합니다.
                    """.formatted(statsJson, codesJson);
        } catch (JsonProcessingException e) {
            log.error("가구 분석 프롬프트 생성 중 JSON 변환 실패", e);
            throw new RuntimeException("프롬프트 생성에 실패했습니다.");
        }
    }

    @Override
    public HousingAnalysisDto interpretHousingData(List<Map<String, Object>> housingStats, List<CodeDetailVO> sgisCodes) {
        String prompt = generateHousingPrompt(housingStats, sgisCodes);

        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "주택 통계 데이터에 대한 1~2 문장의 핵심 요약 (예: '신축 아파트 위주의 주거 지역')", null, null, null),
            "mainHousingType", new Schema("STRING", "가장 비중이 높은 핵심 주택 유형(예: '아파트', '다세대주택')", null, null, null),
            "buildingAgeFeature", new Schema("STRING", "건축 연도와 관련된 핵심 특징(예: '2010년대 준공', '노후 주택 밀집')", null, null, null),
            "opportunities", new Schema("ARRAY", "분석된 주택 특성에 기반한 사업 기회 요인 2가지", null, new Schema("STRING", null, null, null, null), null)
        );
        List<String> requiredFields = List.of("summary", "mainHousingType", "buildingAgeFeature", "opportunities");
        Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

        GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, responseSchema);
        return geminiClient.prompt(requestDto, HousingAnalysisDto.class);
    }

    private String generateHousingPrompt(List<Map<String, Object>> housingStats, List<CodeDetailVO> sgisCodes) {
        try {
            String statsJson = objectMapper.writeValueAsString(housingStats);
            String codesJson = objectMapper.writeValueAsString(sgisCodes);
            return """
                    당신은 대한민국 부동산 및 상권 분석 전문가입니다.
                    주어진 지역의 주택 통계 데이터를 보고, 해당 지역의 주거 환경 특성과 잠재적인 사업 기회를 분석해야 합니다.

                    ## 분석 대상 데이터 ##
                    - 아래는 특정 행정동의 주택 관련 통계(SGIS) 데이터입니다. 'statsValue'는 주택수 또는 관련 지표 값입니다.
                    - 데이터: %s

                    ## 코드 참고 ##
                    - 'sgisCode' 필드는 아래 코드표를 참고하여 해석해야 합니다. (예: 'HOS001'은 '총주택(거처)수', 'HOS002'는 '단독주택')
                    - 코드표: %s

                    ## 분석 요청 사항 ##
                    - 위 데이터를 종합하여, 비전문가도 쉽게 이해할 수 있도록 아래 JSON 스키마에 맞춰 주택 특성을 분석해주세요.
                    - 특히 어떤 유형의 주택(아파트, 단독주택 등)이 많고, 언제 지어졌으며, 이를 통해 어떤 종류의 사업(예: 인테리어, 가구, 학원) 기회를 엿볼 수 있는지 구체적으로 설명해야 합니다.
                    """.formatted(statsJson, codesJson);
        } catch (JsonProcessingException e) {
            log.error("주택 분석 프롬프트 생성 중 JSON 변환 실패", e);
            throw new RuntimeException("프롬프트 생성에 실패했습니다.");
        }
    }

    @Override
    public BusinessAnalysisDto interpretBusinessData(List<Map<String, Object>> bizStats, List<Map<String, Object>> empStats, List<CodeDetailVO> sgisCodes) {
        String prompt = generateBusinessPrompt(bizStats, empStats, sgisCodes);

        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "사업체/종사자 통계에 대한 1~2 문장의 핵심 요약", null, null, null),
            "densityFeature", new Schema("STRING", "선택 업종의 밀집도나 경쟁 환경에 대한 특징", null, null, null),
            "employeeSizeFeature", new Schema("STRING", "종사자 수 규모를 통해 본 상권의 특징 (예: '소규모 업체 위주', '대형 사업체 존재')", null, null, null),
            "opportunities", new Schema("ARRAY", "분석된 사업체/종사자 특성에 기반한 사업 기회 요인 2가지", null, new Schema("STRING", null, null, null, null), null)
        );
        List<String> requiredFields = List.of("summary", "densityFeature", "employeeSizeFeature", "opportunities");
        Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

        GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, responseSchema);
        return geminiClient.prompt(requestDto, BusinessAnalysisDto.class);
    }

    private String generateBusinessPrompt(List<Map<String, Object>> bizStats, List<Map<String, Object>> empStats, List<CodeDetailVO> sgisCodes) {
        try {
            String bizStatsJson = objectMapper.writeValueAsString(bizStats);
            String empStatsJson = objectMapper.writeValueAsString(empStats);
            String codesJson = objectMapper.writeValueAsString(sgisCodes);
            return """
                    당신은 대한민국 상권의 경쟁 환경을 분석하는 시장 조사 전문가입니다.
                    주어진 지역의 특정 업종에 대한 '사업체 수'와 '종사자 수' 통계 데이터를 보고, 해당 상권의 특징과 사업 기회를 분석해야 합니다.

                    ## 분석 대상 데이터 ##
                    - 사업체 수 데이터: %s
                    - 종사자 수 데이터: %s

                    ## 코드 참고 ##
                    - 'sgisCode' 필드는 아래 코드표를 참고하여 해석해야 합니다.
                    - 코드표: %s

                    ## 분석 요청 사항 ##
                    - 위 데이터를 종합하여, 비전문가도 쉽게 이해할 수 있도록 아래 JSON 스키마에 맞춰 상권의 사업 환경을 분석해주세요.
                    - 특히 선택된 업종의 밀집도, 경쟁 강도, 그리고 종사자 수 규모를 통해 파악할 수 있는 상권의 특징(예: 영세 업체 밀집, 대규모 고용 발생 등)과 사업 기회를 구체적으로 설명해야 합니다.
                    """.formatted(bizStatsJson, empStatsJson, codesJson);
        } catch (JsonProcessingException e) {
            log.error("사업체 분석 프롬프트 생성 중 JSON 변환 실패", e);
            throw new RuntimeException("프롬프트 생성에 실패했습니다.");
        }
    }
    
    @Override
    public UserPreferenceVO getUserPreferences(String userId) {
        return marketMapper.selectUserPreferences(userId);
    }
}