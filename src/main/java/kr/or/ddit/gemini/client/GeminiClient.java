package kr.or.ddit.gemini.client;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.gemini.test.dto.example.GeminiResponseDto;
import kr.or.ddit.gemini.test.dto.request.GeminiJsonRequestDto;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component // 또는 @Service
public class GeminiClient {

    // [지시사항 3] 기존 GeminiServiceImpl의 핵심 로직을 그대로 이전
    private final WebClient webClient;
    private final String apiKey;
    private final ObjectMapper objectMapper;

    public GeminiClient(
            WebClient.Builder webClientBuilder,
            @Value("${gemini.api.key}") String apiKey,
            @Value("${gemini.api.url}") String apiUrl,
            ObjectMapper objectMapper) {
        this.webClient = webClientBuilder.baseUrl(apiUrl).build();
        this.apiKey = apiKey;
        this.objectMapper = objectMapper;
    }

    /**
     * Gemini API에 프롬프트와 스키마를 보내고, 지정된 DTO 타입으로 응답을 받아오는 범용 메서드
     * @param <T> 반환받을 DTO 클래스 타입
     * @param requestDto 프롬프트와 JSON 스키마가 포함된 요청 객체
     * @param responseType 변환할 DTO의 클래스
     * @return 변환된 DTO 객체
     */
    public <T> T prompt(GeminiJsonRequestDto requestDto, Class<T> responseType) {
        try {
            GeminiResponseDto responseDto = webClient.post()
                    .uri(uriBuilder -> uriBuilder.queryParam("key", apiKey).build())
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(requestDto)
                    .retrieve()
                    .bodyToMono(GeminiResponseDto.class)
                    .block();

            if (responseDto == null || responseDto.getGeneratedText().isEmpty()) {
                throw new RuntimeException("API가 비어있는 응답을 반환했습니다.");
            }

            String jsonText = responseDto.getGeneratedText();
            log.info("Received JSON from Gemini API: {}", jsonText);
            return objectMapper.readValue(jsonText, responseType);

        } catch (WebClientResponseException e) {
            log.error("Error from Gemini API: status={}, body={}", e.getStatusCode(), e.getResponseBodyAsString(), e);
            throw e; 
        } catch (Exception e) {
            log.error("An unexpected error occurred during Gemini API call", e);
            throw new RuntimeException("API 호출 또는 JSON 파싱 중 예상치 못한 오류가 발생했습니다.", e);
        }
    }
}