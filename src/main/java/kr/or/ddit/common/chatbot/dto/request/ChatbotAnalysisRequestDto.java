package kr.or.ddit.common.chatbot.dto.request;

import lombok.Data;

// Gemini가 사용자의 질문에서 추출한 분석 파라미터를 담는 DTO

@Data
public class ChatbotAnalysisRequestDto {
    private String intent; // "단순 안내" 또는 "상권 분석"
    private String dongName; // 분석할 동 이름 (e.g., "오류동")
    private String bizName; // 분석할 업종 이름 (e.g., "서비스업")
}
