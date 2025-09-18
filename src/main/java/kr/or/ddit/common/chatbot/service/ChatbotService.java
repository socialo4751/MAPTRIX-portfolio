package kr.or.ddit.common.chatbot.service;


import kr.or.ddit.common.chatbot.dto.request.ChatbotRequestDto;
import kr.or.ddit.common.chatbot.dto.response.ChatbotResponseDto;

public interface ChatbotService {

    /**
     * 사용자의 질문을 받아 Gemini API를 통해 분석하고, 적절한 답변을 생성합니다.
     * @param requestDto 사용자의 질문이 담긴 DTO
     * @return 챗봇의 답변이 담긴 DTO
     */
    ChatbotResponseDto getChatbotResponse(ChatbotRequestDto requestDto);

}
