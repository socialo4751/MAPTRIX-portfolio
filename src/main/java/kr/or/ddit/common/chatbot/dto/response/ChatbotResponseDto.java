package kr.or.ddit.common.chatbot.dto.response;

import lombok.Data;

@Data
public class ChatbotResponseDto {
    /**
     * Gemini API가 생성한 답변
     */
    private String answer;
}
