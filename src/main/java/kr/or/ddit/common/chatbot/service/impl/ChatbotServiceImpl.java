package kr.or.ddit.common.chatbot.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors; // Collectors import 추가

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.common.chatbot.dto.request.ChatbotAnalysisRequestDto;
import kr.or.ddit.common.chatbot.dto.request.ChatbotRequestDto;
import kr.or.ddit.common.chatbot.dto.request.CommercialAnalysisDataDto;
import kr.or.ddit.common.chatbot.dto.response.ChatbotResponseDto;
import kr.or.ddit.common.chatbot.mapper.ChatbotMapper;
import kr.or.ddit.common.chatbot.service.ChatbotService;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.gemini.client.GeminiClient;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto.Schema;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatbotServiceImpl implements ChatbotService {

    @Autowired
    private GeminiClient geminiClient;
    @Autowired
    private ObjectMapper objectMapper;
    @Autowired
    private ChatbotMapper chatbotMapper;

    @Override
    public ChatbotResponseDto getChatbotResponse(ChatbotRequestDto requestDto) {
        
        // 1. 사용자의 질문 의도 분류 및 파라미터 추출
        ChatbotAnalysisRequestDto analysisRequest = classifyIntentAndExtractParams(requestDto.getQuestion());
        
        if ("상권 분석".equals(analysisRequest.getIntent())) {
            // 2-1. 상권 분석 로직 수행
            return generateCommercialAnalysis(analysisRequest);
        } else {
            // 2-2. 기존의 단순 안내 로직 수행
            return generateSimpleLinkResponse(requestDto.getQuestion());
        }
    }

    /**
     * Gemini를 사용해 질문 의도를 '단순 안내'와 '상권 분석'으로 분류하고, 파라미터를 추출
     */
    private ChatbotAnalysisRequestDto classifyIntentAndExtractParams(String question) {
        String prompt = """
            당신은 사용자의 질문을 '단순 안내'와 '상권 분석' 두 가지 유형으로 분류하고, '상권 분석'일 경우 관련 파라미터를 추출하는 AI입니다.
            - '상권 분석' 요청은 '~동 상권', '~동 어떤가요' 와 같이 특정 행정동 이름이 포함된 질문입니다.
            - 질문에 '서비스업', '음식점업' 등 특정 업종이 포함될 수 있습니다.
            
            사용자 질문: "%s"

            위 질문을 분석하여 아래 JSON 스키마에 맞춰 답변해주세요.
            - dongName과 bizName은 질문에 해당 내용이 있을 경우에만 추출하고, 없으면 null로 반환해주세요.
            """.formatted(question);

        Map<String, Schema> properties = Map.of(
            "intent", new Schema("STRING", "'단순 안내' 또는 '상권 분석'", null, null, null),
            "dongName", new Schema("STRING", "질문에서 추출한 행정동 이름 (예: 오류동)", null, null, null),
            "bizName", new Schema("STRING", "질문에서 추출한 업종 이름 (예: 서비스업)", null, null, null)
        );
        Schema responseSchema = new Schema("OBJECT", null, properties, null, List.of("intent"));
        GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, responseSchema);
        
        return geminiClient.prompt(geminiRequest, ChatbotAnalysisRequestDto.class);
    }
    
    /**
     * '상권 분석' 요청에 대한 응답을 생성 (업종 처리 로직 수정)
     */
    private ChatbotResponseDto generateCommercialAnalysis(ChatbotAnalysisRequestDto analysisRequest) {
        String dongName = analysisRequest.getDongName();
        if (dongName == null || dongName.isBlank()) {
            return createErrorResponse("어느 동에 대해 분석할까요? 동 이름을 포함해서 질문해주세요. (예: 오류동 상권 어때?)");
        }

        String searchDongKeyword = dongName;
        if (searchDongKeyword.endsWith("동")) {
            searchDongKeyword = searchDongKeyword.substring(0, searchDongKeyword.length() - 1);
        }

        List<CodeAdmDongVO> dongList = chatbotMapper.findAdmCodesByName(searchDongKeyword);
        if (dongList == null || dongList.isEmpty()) {
            return createErrorResponse("'" + dongName + "'에 대한 정보를 찾을 수 없어요. 동 이름을 확인 후 다시 질문해주세요.");
        }

        List<String> admCodeList = dongList.stream()
                                           .map(CodeAdmDongVO::getAdmCode)
                                           .collect(Collectors.toList());

        String displayDongName = dongList.stream()
                                         .map(CodeAdmDongVO::getAdmName)
                                         .collect(Collectors.joining(", "));

        String displayBizName = "전체 업종";
        Map<String, Object> params = new HashMap<>();
        params.put("admCodeList", admCodeList);
        params.put("statsYear", 2023);

        if (analysisRequest.getBizName() != null && !analysisRequest.getBizName().isBlank()) {
            String searchBizKeyword = analysisRequest.getBizName();
            // "제조업" -> "제조" 로 키워드 가공
            if (searchBizKeyword.endsWith("업")) {
                searchBizKeyword = searchBizKeyword.substring(0, searchBizKeyword.length() - 1);
            }
            
            List<CodeBizVO> bizList = chatbotMapper.findBizCodesByName(searchBizKeyword);

            if (bizList != null && !bizList.isEmpty()) {
                // L1 코드가 있는지 확인
                List<CodeBizVO> level1Biz = bizList.stream()
                    .filter(b -> b.getBizLevel() == 1)
                    .collect(Collectors.toList());

                if (!level1Biz.isEmpty()) {
                    // L1 코드가 있으면 L1 리스트만 사용 (포괄적인 검색)
                    List<String> bizCodeIdListL1 = level1Biz.stream().map(CodeBizVO::getBizCodeId).collect(Collectors.toList());
                    params.put("bizCodeIdListL1", bizCodeIdListL1);
                    displayBizName = level1Biz.stream().map(CodeBizVO::getBizName).collect(Collectors.joining(", "));
                } else {
                    // L1 코드가 없고 L2만 있으면, L2 리스트를 모두 사용 (구체적인 검색)
                    List<String> bizCodeIdListL2 = bizList.stream().map(CodeBizVO::getBizCodeId).collect(Collectors.toList());
                    params.put("bizCodeIdListL2", bizCodeIdListL2);
                    displayBizName = bizList.stream().map(CodeBizVO::getBizName).collect(Collectors.joining(", "));
                }
            }
        }

        // 데이터 조회 실행
        Map<String, Object> dongStats = chatbotMapper.selectDongStats(params);
        Map<String, Object> overallStats = chatbotMapper.selectOverallStats(params);

        CommercialAnalysisDataDto analysisData = new CommercialAnalysisDataDto();
        analysisData.setDongName(displayDongName);
        analysisData.setBizName(displayBizName);
        analysisData.setStatsYear(2023);
        analysisData.setDongStats(dongStats);
        analysisData.setOverallStats(overallStats);

        return callGeminiForAnalysis(analysisData);
    }

    /**
     * 조회된 데이터를 바탕으로 Gemini에 분석을 요청
     */
    private ChatbotResponseDto callGeminiForAnalysis(CommercialAnalysisDataDto analysisData) {
        String prompt = "";
        try {
            String dongStatsJson = objectMapper.writeValueAsString(analysisData.getDongStats());
            String overallStatsJson = objectMapper.writeValueAsString(analysisData.getOverallStats());

            prompt = """
                당신은 대한민국 대전광역시 상권 분석 전문가입니다. 주어진 데이터를 바탕으로 비전문가도 이해하기 쉬운 상권 분석 리포트를 작성해야 합니다.
                - 모든 수치는 2023년 기준입니다.
                - 'dongStats'는 사용자가 질문한 특정 동의 데이터이며, 'overallStats'는 대전 전체 동의 평균 데이터입니다. 두 데이터를 반드시 비교하며 분석해주세요.
                - 답변은 친절하고 전문적인 어투를 사용해주세요.

                ## 1. 분석 대상 ##
                - 행정동: %s
                - 분석 업종: %s

                ## 2. 데이터 ##
                - '%s' 데이터: %s
                - '대전 전체 동 평균' 데이터: %s

                ## 3. 리포트 작성 요청 (JSON 형식) ##
                위 데이터를 종합적으로 분석하여, 아래 JSON 스키마에 맞춰 리포트를 작성해주세요.
                - summary: 분석 결과의 핵심 내용을 2~3문장으로 요약합니다.
                - strength: 대전 평균 대비 이 지역의 강점을 구체적인 수치를 근거로 설명합니다.
                - weakness: 대전 평균 대비 이 지역의 약점을 구체적인 수치를 근거로 설명합니다.
                - opportunity: 이 지역의 잠재력이나 기회 요인을 제시합니다.
                - conclusion: 예비 창업자를 위한 최종 종합 의견 및 조언을 제시합니다.
                """.formatted(
                    analysisData.getDongName(),
                    analysisData.getBizName(),
                    analysisData.getDongName(),
                    dongStatsJson,
                    overallStatsJson
                );
        } catch (JsonProcessingException e) {
            log.error("JSON 변환 실패", e);
            throw new RuntimeException("AI 요청 생성 중 오류 발생");
        }
        
        Map<String, Schema> properties = Map.of(
            "summary", new Schema("STRING", "핵심 요약", null, null, null),
            "strength", new Schema("STRING", "강점 분석", null, null, null),
            "weakness", new Schema("STRING", "약점 분석", null, null, null),
            "opportunity", new Schema("STRING", "기회 요인", null, null, null),
            "conclusion", new Schema("STRING", "최종 의견", null, null, null)
        );
        Schema responseSchema = new Schema("OBJECT", null, properties, null, List.of("summary", "strength", "weakness", "opportunity", "conclusion"));
        GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, responseSchema);
        
        try {
            Map<String, String> analysisResult = geminiClient.prompt(geminiRequest, Map.class);
            
            // --- 핵심 수정 부분: 리포트 끝에 안내 문구와 링크 추가 ---
            String formattedAnswer = """
                <p><strong>[🔍 %s %s 상권 분석 리포트]</strong></p>
                <p><strong>✅ 핵심 요약</strong><br>%s</p>
                <p><strong>💪 강점</strong><br>%s</p>
                <p><strong>🤔 약점</strong><br>%s</p>
                <p><strong>✨ 기회 요인</strong><br>%s</p>
                <p><strong>💡 최종 의견</strong><br>%s</p>
                <hr>
                <p>더 자세한 결과가 궁금하시다면, <a href='http://175.45.204.104/market/simple' target='_blank'>상권 간편분석 바로가기</a>를 클릭하세요!</p>
                """.formatted(
                    analysisData.getDongName(),
                    analysisData.getBizName(),
                    analysisResult.get("summary"),
                    analysisResult.get("strength"),
                    analysisResult.get("weakness"),
                    analysisResult.get("opportunity"),
                    analysisResult.get("conclusion")
                );

            ChatbotResponseDto finalResponse = new ChatbotResponseDto();
            finalResponse.setAnswer(formattedAnswer);
            return finalResponse;

        } catch (Exception e) {
            log.error("AI 분석 결과 처리 중 오류", e);
            return createErrorResponse("분석 리포트를 생성하는 데 실패했습니다. 다시 시도해주세요.");
        }
    }

    /**
     * 기존의 '단순 안내' 요청에 대한 응답을 생성
     */
    private ChatbotResponseDto generateSimpleLinkResponse(String question) {
        String prompt = """
            당신은 사용자의 질문 의도를 파악하고 가장 적절한 웹사이트 페이지로 안내하는 챗봇입니다.
            사용자의 질문을 분석하여 아래 '키워드-URL 매핑 규칙'에 따라 가장 적합한 답변을 생성해주세요.
            ## 중요 규칙 ##
            1. 모든 URL은 반드시 `<a href="URL" target="_blank">링크 텍스트</a>` 형식의 HTML a 태그로 감싸주세요.
            2. 'target="_blank"' 속성을 항상 포함하여 링크가 새 탭에서 열리도록 해주세요.
            3. '링크 텍스트'는 페이지의 내용을 잘 설명하는 문구로 작성해주세요. (예: '상권 분석 페이지로 이동')
            ## 키워드-URL 매핑 규칙 ##
            - '사이트 소개', '안내', '무슨 사이트' -> "우리 사이트는 말이죠? <a href='http://175.45.204.104/intro' target='_blank'>사이트 소개 페이지로 이동</a>"
            - '조직도', '직원', '누가 만들었어' -> "우리 사이트의 조직도가 궁금하신가요? <a href='http://175.45.204.104/intro/org/chart' target='_blank'>조직도 보기</a>"
            - '성과', '연혁', '실적' -> "우리 회사의 연혁이 궁금하시다구요? <a href='http://175.45.204.104/intro/history' target='_blank'>회사 연혁 보기</a>"
            - '상권', '분석', '검색' -> "간단한 상권분석을 해보시겠어요? <a href='http://175.45.204.104/market/simple' target='_blank'>상권 간편분석 바로가기</a>"
            - '통계분석 지표', '지표 설명' -> "통계분석 지표 안내를 해드릴까요? <a href='http://175.45.204.104/market/indicators' target='_blank'>통계분석 지표 안내</a>"
            - '창업 고민', '힘들다', '막막하다' -> "창업 준비 과정이 많이 힘드시죠? 저희가 도움이 되어 드릴게요. <a href='http://175.45.204.104/start-up/main' target='_blank'>창업 지원 정보</a>를 확인해보세요."
            - '창업 테스트', '적성', '후', '간단 테스트' -> "나의 창업 역량이 궁금하진 않으세요? 저희가 도움이 되어 드릴게요. <a href='http://175.45.204.104/start-up/main' target='_blank'>창업 역량 테스트 해보기</a>"
            - '창업 지원', '지원금', '보조금' -> "창업 지원 관련 소식이 궁금하시다면, 클릭해보세요! <a href='http://175.45.204.104/start-up/mt' target='_blank'>창업 지원 소식</a>"
            - '시뮬레이션', '도면', '가게 꾸미기', '인테리어' -> "나만의 가게를 직접 도면으로 그려보며 시뮬레이션 할 수 있어요! <a href='http://175.45.204.104/start-up/show' target='_blank'>내 가게 꾸미기</a>"
            - '커뮤니티', '게시판', '소통' -> "나와 같은 고민을 하고 있는지 업종별 커뮤니티가 궁금하시다구요? 저희가 소통창구가 되어드릴게요! <a href='http://175.45.204.104/comm/entry' target='_blank'>커뮤니티 바로가기</a>"
            - '상권 뉴스', '뉴스' -> "최신 상권 관련 뉴스가 궁금하시다구요? <a href='http://175.45.204.104/comm/news' target='_blank'>최신 상권 뉴스</a>"
            - '창업 후기', '후기' -> "우리 모두 할 수 있어요! 생생한 창업 후기 궁금하시죠? <a href='http://175.45.204.104/comm/review' target='_blank'>생생한 창업 후기</a>"
            - '공지사항' -> "우리 사이트의 공지사항은 이렇답니다! <a href='http://175.45.204.104/cs/notice' target='_blank'>공지사항 보기</a>"
            - '문의', '질문', 'Q&A' -> "문의사항을 남겨보시겠어요? 빠르게 답변드릴게요! <a href='http://175.45.204.104/cs/qna' target='_blank'>문의사항 남기기</a>"
            - '자주묻는 질문', 'FAQ' -> "자주 묻는 질문을 정리해서 한번에 보실 수 있습니다! <a href='http://175.45.204.104/cs/faq' target='_blank'>자주 묻는 질문</a>"
            - '직원 칭찬', '칭찬하기' -> "칭찬할 직원이 있으신가요? 자유롭게 의견 남겨주세요! <a href='http://175.45.204.104/cs/praise' target='_blank'>직원 칭찬하기</a>"
            - '설문조사' -> "설문조사를 해보시겠어요? <a href='http://175.45.204.104/cs/survey' target='_blank'>설문조사 참여하기</a>"
            - '데이터', 'API' -> "저희 사이트에서 사용한 데이터 다운로드가 가능하답니다! <a href='http://175.45.204.104/openapi/intro' target='_blank'>OpenAPI 안내</a>"
            - 위 규칙에 해당하지 않는 경우 -> "괜찮습니다. 저희가 도움이 되어 드릴게요. <a href='http://175.45.204.104/start-up/main' target='_blank'>창업 지원 정보</a>를 확인해보세요."
            ## 사용자 질문 ##
            "%s"
            ## 출력 형식 (JSON) ##
            아래 JSON 스키마에 맞춰 답변을 생성해주세요.
            """.formatted(question);

        Map<String, Schema> properties = Map.of("answer", new Schema("STRING", "사용자 질문에 대한 최종 답변 메시지 (HTML a 태그 포함 가능)", null, null, null));
        Schema responseSchema = new Schema("OBJECT", null, properties, null, List.of("answer"));
        GeminiJsonRequestDto geminiRequest = new GeminiJsonRequestDto(prompt, responseSchema);
        return geminiClient.prompt(geminiRequest, ChatbotResponseDto.class);
    }
    
    private ChatbotResponseDto createErrorResponse(String message) {
        ChatbotResponseDto errorResponse = new ChatbotResponseDto();
        errorResponse.setAnswer(message);
        return errorResponse;
    }
}