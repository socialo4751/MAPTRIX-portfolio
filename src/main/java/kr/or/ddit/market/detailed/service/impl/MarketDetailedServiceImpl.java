package kr.or.ddit.market.detailed.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.gemini.client.GeminiClient;
import kr.or.ddit.gemini.test.dto.example.GridDataVo;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto.Schema;
import kr.or.ddit.gemini.test.dto.response.AnalysisDto;
import kr.or.ddit.market.detailed.dto.request.ClusterGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GravityGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GridAnalysisRequestDto;
import kr.or.ddit.market.detailed.dto.request.LogisticGridDataDto;
import kr.or.ddit.market.detailed.dto.response.ClusterAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GravityAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GridAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.LogisticAnalysisResponseDto;
import kr.or.ddit.market.detailed.service.MarketDetailedService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MarketDetailedServiceImpl implements MarketDetailedService {

    @Autowired
    private GeminiClient geminiClient;
    
    @Autowired
    private ObjectMapper objectMapper;

    @Override
    public GridAnalysisResponseDto analyzeGridByProperties(GridAnalysisRequestDto gridData) {
        String olsResultTable = """
                =======================================================================================
                                                   coef    std err          t      P>|t|      [0.025      0.975]
                ---------------------------------------------------------------------------------------
                Intercept                        4.7553      2.631      1.807      0.071      -0.411       9.922
                총인구                             0.0022      0.002      0.949      0.343      -0.002       0.007
                Q("30~34세 남녀 인구 합")          -0.0187      0.010     -1.902      0.058      -0.038       0.001
                Q("1인가구 수")                     0.0201      0.007      2.992      0.003       0.007       0.033
                Q("신축 주택 비율")                 -0.6886      9.153     -0.075      0.940     -18.663      17.286
                도소매업체수                         1.4790      0.031     48.060      0.000       1.419       1.539
                숙박음식업체수                       1.3698      0.064     21.455      0.000       1.244       1.495
                정보통신업체수                       4.5347      0.224     20.244      0.000       4.095       4.975
                건설업체수                         1.2929      0.041     31.461      0.000       1.212       1.374
                교육서비스업체수                     1.9433      0.163     11.945      0.000       1.624       2.263
                ==============================================================================
                """;

        String prompt = "";
        try {
            String gridDataJson = objectMapper.writeValueAsString(gridData);
            
            String dong1Info = (gridData.getRank1AdmName() != null && gridData.getRank1Perc() != null)
                ? String.format("%s(%.2f%%)", gridData.getRank1AdmName(), gridData.getRank1Perc())
                : (gridData.getRank1AdmName() != null ? String.format("%s(비율 정보 없음)", gridData.getRank1AdmName()) : "정보 없음");

            String dong2Info = (gridData.getRank2AdmName() != null && gridData.getRank2Perc() != null)
                ? String.format("와 **%s(%.2f%%)**", gridData.getRank2AdmName(), gridData.getRank2Perc()) : "";

            prompt = """
                    당신은 대한민국 상권 및 입지 분석을 전문으로 하는 최고 수준의 데이터 분석가입니다.
                    주어진 다중회귀분석 모델의 통계 결과와 특정 격자(Grid)의 데이터를 바탕으로, 비전문가도 쉽게 이해할 수 있는 심층 분석 리포트를 작성해야 합니다.

                    ## 1. 분석 모델 통계 결과 (전체 지역 대상) ##
                    이 모델은 '총사업체수'를 예측하기 위해 만들어졌으며, R-squared 값이 0.991로 매우 높은 설명력을 가집니다.
                    아래는 각 변수(원인)가 총사업체수(결과)에 미치는 영향력을 나타낸 통계표입니다.
                    - coef: 변수 1 단위가 증가할 때 총사업체수가 얼마나 변하는지 나타냅니다. 양수면 긍정적, 음수면 부정적 영향입니다.
                    - P>|t|: 0.05 미만일 때 통계적으로 의미있는 변수라고 해석합니다.
                    ```
                    %s
                    ```

                    ## 2. 분석 대상 격자 데이터 ##
                    사용자가 선택한 특정 지역의 데이터는 다음과 같습니다. 이 격자는 주로 **%s**%s에 걸쳐있는 특징을 가집니다. 이 지리적 특성을 반드시 분석에 반영해주세요.
                    ```json
                    %s
                    ```

                    ## 3. 리포트 작성 요청 ##
                    위 1, 2번 정보를 종합적으로 활용하여 아래 JSON 스키마에 맞춰 상세 분석 리포트를 작성해주세요.
                    - **핵심 질문**: 이 지역은 왜 모델의 예측(predicted_total_business)과 실제(총사업체수) 사이에 차이(residual_total_business)가 발생했는가?
                    - **분석 방향**:
                        1. 잔차(residual_total_business)가 양수(+)이면 '숨은 꿀단지🍯', 음수(-)이면 '기회의 땅💎'으로 규정하고 제목을 정해주세요.
                        2. 이 지역의 변수 값들과 **주요 행정동의 일반적인 특성**을 함께 고려하여, 전체 모델의 경향성(coef, P>|t|)과 비교하며 잔차의 원인을 분석해주세요.
                        3. 최종적으로 이 지역의 상권 잠재력에 대한 종합적인 의견을 제시해주세요.
                    - **(매우 중요) 금지사항**: 분석 과정에서 '다중공선성(multicollinearity)' 또는 '상태수(Condition Number)'에 대한 언급은 절대로 하지 마세요.
                    """.formatted(olsResultTable, dong1Info, dong2Info, gridDataJson);

		} catch (JsonProcessingException e) {
			log.error("격자 데이터 JSON 변환 실패", e);
			throw new RuntimeException("AI 요청 생성 중 오류 발생");
		}

		Map<String, Schema> properties = Map.of(
            "gid", new Schema("STRING", "분석 대상 격자 ID", null, null, null),
            "summaryTitle", new Schema("STRING", "분석 결과를 대표하는 매력적인 제목", null, null, null),
            "summaryContent", new Schema("STRING", "분석 결과에 대한 2~3 문장의 핵심 요약", null, null, null),
            "analysisDetails", new Schema("STRING", "잔차가 발생한 원인에 대한 상세 분석 (HTML 줄바꿈 <br> 사용 가능)", null, null, null),
            "potential", new Schema("STRING", "이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견", null, null, null)
        );
		List<String> requiredFields = List.of("gid", "summaryTitle", "summaryContent", "analysisDetails", "potential");
		Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

		GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, responseSchema);
		return geminiClient.prompt(requestDto, GridAnalysisResponseDto.class);
    }

    @Override
    public ClusterAnalysisResponseDto analyzeClusterGrid(ClusterGridDataDto gridDataDto) {
        String prompt = createClusterAnalysisPrompt(gridDataDto);

        Map<String, Schema> clusterInfoProps = Map.of(
            "title", new Schema("STRING", "군집의 특징을 나타내는 제목", null, null, null),
            "description", new Schema("STRING", "군집의 특징을 요약한 한 문장 설명", null, null, null)
        );
        Schema clusterInfoSchema = new Schema("OBJECT", null, clusterInfoProps, null, List.of("title", "description"));

        Map<String, Schema> clusterDefProps = Map.of("cluster0", clusterInfoSchema, "cluster1", clusterInfoSchema);
        Schema clusterDefSchema = new Schema("OBJECT", null, clusterDefProps, null, List.of("cluster0", "cluster1"));

        Map<String, Schema> gridAnalysisProps = Map.of(
            "title", new Schema("STRING", "격자의 소속 군집과 의미", null, null, null),
            "characteristics", new Schema("ARRAY", "군집의 주요 특징 리스트", null, new Schema("STRING", null, null, null, null), null)
        );
        Schema gridAnalysisSchema = new Schema("OBJECT", null, gridAnalysisProps, null, List.of("title", "characteristics"));

        Map<String, Schema> finalProperties = Map.of(
            "clusterDefinition", clusterDefSchema,
            "gridClusterAnalysis", gridAnalysisSchema,
            "gridSpecificPotential", new Schema("STRING", "격자만의 최종 의견 및 잠재력 분석", null, null, null)
        );
        Schema finalSchema = new Schema("OBJECT", null, finalProperties, null, List.of("clusterDefinition", "gridClusterAnalysis", "gridSpecificPotential"));

        GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, finalSchema);
        return geminiClient.prompt(geminiRequest, ClusterAnalysisResponseDto.class);
    }

    private String createClusterAnalysisPrompt(ClusterGridDataDto gridDataDto) {
        Map<String, Double> cluster0Means = new HashMap<>();
		cluster0Means.put("20~39세 인구 비율_mean", 0.541767);
		cluster0Means.put("총 인구수_mean", 2.199878);
		cluster0Means.put("1인가구 비율_mean", 0.418613);
		cluster0Means.put("총가구수_mean", 2.239457);
		cluster0Means.put("음식점 수_mean", 2.091812);
		cluster0Means.put("도소매업체 수_mean", 2.169572);
		cluster0Means.put("전체 사업체 수_mean", 2.239976);
		cluster0Means.put("서비스업 종사자 수_mean", 1.747237);
		cluster0Means.put("도소매업 종사자 수_mean", 2.065781);
		cluster0Means.put("2000년 이후 주택 비율_mean", 0.186341);
        
        Map<String, Double> cluster1Means = new HashMap<>();
		cluster1Means.put("20~39세 인구 비율_mean", -0.078517);
		cluster1Means.put("총 인구수_mean", -0.318823);
		cluster1Means.put("1인가구 비율_mean", -0.060669);
		cluster1Means.put("총가구수_mean", -0.324559);
		cluster1Means.put("음식점 수_mean", -0.303161);
		cluster1Means.put("도소매업체 수_mean", -0.314431);
		cluster1Means.put("전체 사업체 수_mean", -0.324634);
		cluster1Means.put("서비스업 종사자 수_mean", -0.253223);
		cluster1Means.put("도소매업 종사자 수_mean", -0.299389);
		cluster1Means.put("2000년 이후 주택 비율_mean", -0.027006);

		Map<String, Map<String, Double>> summary = new HashMap<>();
		summary.put("cluster0", cluster0Means);
		summary.put("cluster1", cluster1Means);

		String gridDataJson = "";
	    String summaryJson = "";
	    String dong1Info = "";
	    String dong2Info = "";
	    try {
	        gridDataJson = objectMapper.writeValueAsString(gridDataDto);
	        summaryJson = objectMapper.writeValueAsString(summary);
	        
            dong1Info = (gridDataDto.getRank1AdmName() != null && gridDataDto.getRank1Perc() != null)
                ? String.format("%s(%.2f%%)", gridDataDto.getRank1AdmName(), gridDataDto.getRank1Perc())
                : (gridDataDto.getRank1AdmName() != null ? String.format("%s(비율 정보 없음)", gridDataDto.getRank1AdmName()) : "정보 없음");

            dong2Info = (gridDataDto.getRank2AdmName() != null && gridDataDto.getRank2Perc() != null)
                ? String.format("와 **%s(%.2f%%)**", gridDataDto.getRank2AdmName(), gridDataDto.getRank2Perc()) : "";

	    } catch (JsonProcessingException e) {
	        log.error("프롬프트 생성 중 JSON 변환 실패", e);
	        throw new RuntimeException(e);
	    }

	    return """
	            당신은 대한민국 상권 분석 전문가입니다. 당신의 역할은 군집 분석 결과를 바탕으로 선택된 격자에 대한 이해하기 쉬운 분석을 제공하는 것입니다.
	            군집 요약 통계는 Z-score(표준화 점수)이며, 양수 값은 전체 평균보다 높다는 것을, 음수 값은 낮다는 것을 의미합니다.

	            ## 1. 분석 대상 격자 데이터 ##
	            이 격자는 [군집 %d]에 속해 있으며, 지리적으로 **%s**%s에 걸쳐있는 특징을 가집니다.
	            %s

	            ## 2. 전체 군집 요약 데이터 ##
	            %s

	            ## 분석 요청 사항 ##
	            위 1번과 2번 데이터를 종합적으로 분석하여, 아래 지침에 따라 유효한 JSON 객체 하나만 반환해주세요.
	            (JSON 앞뒤로 다른 텍스트나 마크다운 서식을 절대 포함하지 마세요.)

	            1. `clusterDefinition`: 먼저, 0번과 1번 군집의 평균 Z-score를 비교하여 각 군집의 `title`과 `description`을 정의해주세요.
	               - `cluster0`의 `title`은 '상업 활력 중심지'로, `cluster1`의 `title`은 '안정된 주거 지역'으로 명명해주세요.
	               - `description`은 각 군집의 핵심 특징을 요약하여 한 문장으로 작성해주세요.

	            2. `gridClusterAnalysis`: 사용자가 클릭한 격자가 속한 [군집 %d]에 대해 집중적으로 분석해주세요.
	               - `title`에는 "이 격자는 [군집 %d] '%s'에 속합니다." 형식으로 작성해주세요. (군집 번호, 위에서 정의한 군집 title 활용)
	               - `characteristics`에는 [군집 %d]의 가장 두드러지는 특징 3~4가지를 실제 창업자에게 조언하듯이 구체적으로 설명하는 문자열 배열을 포함해주세요.

	            3. `gridSpecificPotential`: 이 격자만의 고유한 특징과 잠재력을 종합하여 하나의 문자열로 최종 의견을 제시해주세요.
	               - 소속된 [군집 %d]의 평균적인 특징과 이 격자의 실제 변수 값을 비교해야 합니다.
	               - **특히, 이 격자가 걸쳐있는 행정동(%s)의 일반적인 특성을 고려하여, 군집의 평균적 특징과 어떻게 결합되거나 다른 점을 보이는지 분석하고, 그것이 어떤 기회나 위험 요인이 되는지 분석해야 합니다.**

	            모든 답변은 반드시 한국어로 작성해주세요.
	            """.formatted(
	            gridDataDto.getClusterId(),
	            dong1Info, 
	            dong2Info, 
	            gridDataJson, 
	            summaryJson, 
	            gridDataDto.getClusterId(), 
	            gridDataDto.getClusterId(),
	            gridDataDto.getClusterId() == 0 ? "상업 활력 중심지" : "안정된 주거 지역", 
	            gridDataDto.getClusterId(), 
	            gridDataDto.getClusterId(),
	            dong1Info
	    );
    }
    
    @Override
    public LogisticAnalysisResponseDto analyzeLogisticGrid(LogisticGridDataDto requestDto) {
    	String logitResultTable = """
    			=================================================================
    			Model:                   Logit            Method:                  MLE
    			Dependent Variable:      cluster          Pseudo R-squared:        0.886
    			-----------------------------------------------------------------
    			                         Coef.   Std.Err.      z      P>|z|   [0.025   0.975]
    			-----------------------------------------------------------------
    			Intercept                7.2535   1.0845   6.6886   0.0000   5.1280   9.3789
    			Q("총 인구수")              -0.0003   0.0001  -3.5813   0.0003  -0.0005  -0.0001
    			Q("음식점 수")              -0.0461   0.0106  -4.3379   0.0000  -0.0669  -0.0252
    			Q("서비스업 종사자 수")        -0.0010   0.0003  -2.8321   0.0046  -0.0016  -0.0003
    			=================================================================
    			""";
        
		String prompt = "";
		try {
			String gridDataJson = objectMapper.writeValueAsString(requestDto);
			
			String dong1Info = (requestDto.getRank1AdmName() != null && requestDto.getRank1Perc() != null)
				? String.format("%s(%.2f%%)", requestDto.getRank1AdmName(), requestDto.getRank1Perc())
				: (requestDto.getRank1AdmName() != null ? String.format("%s(비율 정보 없음)", requestDto.getRank1AdmName()) : "정보 없음");

			String dong2Info = (requestDto.getRank2AdmName() != null && requestDto.getRank2Perc() != null)
				? String.format("와 **%s(%.2f%%)**", requestDto.getRank2AdmName(), requestDto.getRank2Perc()) : "";

			prompt = """
					당신은 대한민국 상권 및 입지 분석을 전문으로 하는 최고 수준의 데이터 분석가입니다.
					주어진 로지스틱 회귀분석 모델의 통계 결과와 특정 격자(Grid)의 데이터를 바탕으로, 비전문가도 쉽게 이해할 수 있는 심층 분석 리포트를 작성해야 합니다.

					## 1. 분석 모델 통계 결과 (전체 지역 대상) ##
					이 모델은 특정 지역이 '상권 발달 지역(cluster 0)'에 속할지 '성장 잠재 지역(cluster 1)'에 속할지 예측하며, Pseudo R-squared가 0.886으로 매우 높은 설명력을 가집니다.
					- Coef(계수)가 음수(-)이면 해당 변수 값이 클수록 '상권 발달 지역(0)'이 될 확률이 높아짐을 의미합니다.
					- P>|z| 값은 모두 0.05보다 작아 모든 변수가 통계적으로 유의미합니다.
					```
					%s
					```

					## 2. 분석 대상 격자 데이터 ##
					사용자가 선택한 특정 지역의 데이터는 다음과 같습니다. 이 격자는 주로 **%s**%s에 걸쳐있는 특징을 가집니다.
					```json
					%s
					```

					## 3. 리포트 작성 요청 ##
					위 1, 2번 정보를 종합적으로 활용하여 아래 JSON 스키마에 맞춰 상세 분석 리포트를 작성해주세요.
					- **핵심 질문**: 이 지역은 왜 모델의 예측(predicted_class)과 실제(cluster)가 일치(정답) 또는 불일치(오답)했는가?
					- **분석 방향**:
						1. 격자의 '정답 여부'에 따라 매력적인 제목(analysisTitle)을 정해주세요. (예: 정답이면 "확실한 핵심 상권", 오답이면 "AI를 혼란시킨 숨은 상권")
						2. 이 격자의 실제 값과 예측 값을 요약해주세요(gridSummary).
						3. 이 격자의 변수 값(총 인구수 등)들이 전체 모델의 경향성(Coef)과 어떻게 부합하거나 벗어나는지 설명하며 예측의 원인을 상세히 분석해주세요(analysisReason). **이때, 이 격자가 걸쳐있는 행정동(%s)의 일반적인 특성을 반드시 함께 고려해야 합니다.**
						4. 최종적으로 이 지역의 상권 잠재력에 대한 종합적인 의견을 제시해주세요(potential).
					- 모든 답변은 반드시 한국어로 작성해주세요.
					""".formatted(logitResultTable, dong1Info, dong2Info, gridDataJson, dong1Info);

		} catch (JsonProcessingException e) {
			log.error("격자 데이터 JSON 변환 실패", e);
			throw new RuntimeException("AI 요청 생성 중 오류 발생");
		}

		Map<String, Schema> properties = Map.of(
            "gid", new Schema("STRING", "분석 대상 격자 ID", null, null, null),
            "analysisTitle", new Schema("STRING", "분석 결과를 대표하는 매력적인 제목", null, null, null),
            "gridSummary", new Schema("STRING", "분석 결과에 대한 2~3 문장의 핵심 요약", null, null, null),
            "analysisReason", new Schema("STRING", "모델이 그렇게 예측한 원인에 대한 상세 분석", null, null, null),
            "potential", new Schema("STRING", "이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견", null, null, null)
        );
		List<String> requiredFields = List.of("gid", "analysisTitle", "gridSummary", "analysisReason", "potential");
		Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

		GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, responseSchema);
		return geminiClient.prompt(geminiRequest, LogisticAnalysisResponseDto.class);
    }
    
    @Override
    public GravityAnalysisResponseDto analyzeGravityGrid(GravityGridDataDto requestDto) {
        String gravityTierTable = """
				| 등급명   | Gravity_Total 범위       | 상위 비율      | 해석 설명                                           |
				|----------|--------------------------|----------------|-----------------------------------------------------|
				| `Top`    | > 12,974.21              | 상위 25%       | 주변 유동인구를 가장 강력하게 끌어들이는 핵심 상권      |
				| `High`   | 583.59 < G ≤ 12,974.21   | 상위 25% ~ 50% | 잠재력이 높고 활성화된 유망 상권                      |
				| `Medium` | 86.47 < G ≤ 583.59       | 상위 50% ~ 75% | 주변 영향을 받지만 자체 흡인력도 갖춘 보통 상권         |
				| `Low`    | ≤ 86.47                  | 하위 25%       | 인구 유출이 많거나 비활성화된 주거지 중심 지역        |
				""";
        
        String prompt = "";
	    try {
	        String gridDataJson = objectMapper.writeValueAsString(requestDto);

	        String dong1Info = (requestDto.getRank1AdmName() != null && requestDto.getRank1Perc() != null)
	            ? String.format("%s(%.2f%%)", requestDto.getRank1AdmName(), requestDto.getRank1Perc())
	            : (requestDto.getRank1AdmName() != null ? String.format("%s(비율 정보 없음)", requestDto.getRank1AdmName()) : "정보 없음");

	        String dong2Info = (requestDto.getRank2AdmName() != null && requestDto.getRank2Perc() != null)
	            ? String.format("와 **%s(%.2f%%)**", requestDto.getRank2AdmName(), requestDto.getRank2Perc()) : "";
	        
	        prompt = """
	                당신은 대한민국 상권 및 입지 분석을 전문으로 하는 최고 수준의 데이터 분석가입니다.
	                주어진 중력모델(Gravity Model)의 등급 기준과 특정 격자(Grid)의 데이터를 바탕으로, 비전문가도 쉽게 이해할 수 있는 심층 분석 리포트를 작성해야 합니다.

	                ## 1. 분석 모델 등급 기준 ##
	                중력모델은 '인구 수'(상권의 질량)와 '공시지가'(상권의 매력도)를 기반으로 특정 지역이 주변 인구를 얼마나 끌어당기는지(Gravity_Total)를 계산합니다. 등급은 다음과 같습니다.
	                ```
	                %s
	                ```

	                ## 2. 분석 대상 격자 데이터 ##
	                사용자가 선택한 특정 지역의 데이터는 다음과 같습니다. 이 격자는 주로 **%s**%s에 걸쳐있는 특징을 가집니다.
	                ```json
	                %s
	                ```

	                ## 3. 리포트 작성 요청 ##
	                위 1, 2번 정보를 종합적으로 활용하여 아래 JSON 스키마에 맞춰 상세 분석 리포트를 작성해주세요.
	                - **핵심 질문**: 이 지역은 왜 현재의 'Gravity_Total' 점수를 받았으며, 이는 상권 관점에서 어떤 의미를 가지는가?
	                - **분석 방향**:
	                    1.  격자의 'Gravity_Total' 값을 보고, 1번 기준표에 따라 어떤 등급(Top, High, Medium, Low)에 속하는지 먼저 판단해주세요.
	                    2.  판단된 등급에 어울리는 매력적인 제목(`analysisTitle`)을 만들어주세요. (예: Top 등급이면 '대전의 중심, 강력한 상권 자석')
	                    3.  격자의 등급과 핵심 해석을 2~3문장으로 요약해주세요(`gridSummary`).
	                    4.  '인구 수'와 '공시지가'가 'Gravity_Total'에 어떤 영향을 미쳤는지 상세히 분석해주세요(`analysisReason`). **이때, 이 격자가 걸쳐있는 행정동(%s)의 일반적인 특성을 반드시 함께 고려해야 합니다.** (예: '높은 인구수에도 불구하고 공시지가가 낮은 외곽 주거지역 특성상 Medium 등급에 머물렀습니다.')
	                    5.  최종적으로 이 지역의 상권 잠재력과 기회/위험 요인에 대한 종합적인 의견(`potential`)을 제시해주세요.
	                - 모든 답변은 반드시 한국어로 작성해주세요.
	                """.formatted(gravityTierTable, dong1Info, dong2Info, gridDataJson, dong1Info);

	    } catch (JsonProcessingException e) {
			log.error("격자 데이터 JSON 변환 실패", e);
			throw new RuntimeException("AI 요청 생성 중 오류 발생");
		}

		Map<String, Schema> properties = Map.of(
            "gid", new Schema("STRING", "분석 대상 격자 ID", null, null, null),
            "analysisTitle", new Schema("STRING", "분석 결과를 대표하는 매력적인 제목", null, null, null),
            "gridSummary", new Schema("STRING", "분석 결과에 대한 2~3 문장의 핵심 요약", null, null, null),
            "analysisReason", new Schema("STRING", "Gravity_Total 점수가 나온 원인에 대한 상세 분석", null, null, null),
            "potential", new Schema("STRING", "이 지역의 잠재력 및 기회/위험 요인에 대한 종합 의견", null, null, null)
        );
		List<String> requiredFields = List.of("gid", "analysisTitle", "gridSummary", "analysisReason", "potential");
		Schema responseSchema = new Schema("OBJECT", null, properties, null, requiredFields);

		GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, responseSchema);
		return geminiClient.prompt(geminiRequest, GravityAnalysisResponseDto.class);
    }

    @Override
    public AnalysisDto getAnalysisForGrid(GridDataVo gridData) {
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
            gridData.getDong2Name(), gridData.getDong2Ratio()
        );

		Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "분석 결과에 대한 핵심 요약 (2~3문장)", null, null, null),
            "riskLevel", new Schema("STRING", "종합적인 위험도 평가 (안정, 기회, 주의, 위험 중 하나)", null, null, null),
            "positiveSignal", new Schema("STRING", "p-value와 행정동 특성을 고려한 긍정적 신호 및 기회 요인", null, null, null),
            "negativeSignal", new Schema("STRING", "p-value와 행정동 특성을 고려한 부정적 신호 및 위기 요인", null, null, null),
            "recommendations", new Schema("ARRAY", "분석에 기반한 2가지 구체적인 추천 전략", null, new Schema("STRING", null, null, null, null), null)
        );
		List<String> requiredFields = List.of("summary", "riskLevel", "positiveSignal", "negativeSignal", "recommendations");
		Schema analysisSchema = new Schema("OBJECT", null, properties, null, requiredFields);
		
		GeminiJsonRequestDto requestDto = new GeminiJsonRequestDto(prompt, analysisSchema);
		return geminiClient.prompt(requestDto, AnalysisDto.class);
    }
}
