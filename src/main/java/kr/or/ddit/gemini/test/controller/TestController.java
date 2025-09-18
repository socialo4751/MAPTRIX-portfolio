package kr.or.ddit.gemini.test.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import kr.or.ddit.gemini.test.dto.example.GridDataVo;
import kr.or.ddit.gemini.test.dto.response.AnalysisDto;
import kr.or.ddit.gemini.test.service.GeminiTestService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TestController {

    private final GeminiTestService geminiTestService;
    
    public TestController(GeminiTestService geminiTestService) {
        this.geminiTestService = geminiTestService;
    }

    @GetMapping("/gemini/test")
    public String analysisHardcodedTestPage() {
        return "gemini/test";
    }

    // [핵심 개선] 반환 타입을 와일드카드(?)로 변경하고, try-catch로 에러를 처리합니다.
    @PostMapping("/analysis/run-hardcoded")
    @ResponseBody
    public ResponseEntity<?> runHardcodedAnalysis() {
        try {
            GridDataVo gridData = new GridDataVo(
                "다바1234", 
                0.045, 
                "둔산동", 
                75, 
                "갈마동", 
                25,
                "로지스틱 회귀모형", 
                "매출액", 
                "인구수"
            );
            AnalysisDto analysisResult = geminiTestService.getAnalysisForGrid(gridData);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("inputData", gridData);
            responseData.put("analysisData", analysisResult);
            
            return ResponseEntity.ok(responseData); // 성공 시, 200 OK와 함께 데이터 반환

        } catch (WebClientResponseException e) {
            // Gemini API가 4xx 또는 5xx 에러를 반환한 경우
            log.error("API error propagated to controller: {}", e.getMessage());
            String errorMessage = "Gemini API 호출에 실패했습니다. (오류: " + e.getStatusCode() + ")";
            return ResponseEntity.status(e.getStatusCode()).body(errorMessage); // API가 보낸 상태 코드와 메시지 반환

        } catch (Exception e) {
            // 그 외 모든 서버 내부 에러 (JSON 파싱 실패 등)
            log.error("Unexpected error in controller: {}", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body("서버 내부 오류가 발생했습니다: " + e.getMessage()); // 500 에러와 메시지 반환
        }
    }
}