package kr.or.ddit.common.chatbot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.common.chatbot.dto.request.ChatbotRequestDto;
import kr.or.ddit.common.chatbot.dto.response.ChatbotResponseDto;
import kr.or.ddit.common.chatbot.service.ChatbotService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/api/chatbot")
@RestController
public class ChatbotApiController {

    @Autowired
    private ChatbotService chatbotService;

    @PostMapping("/ask")
    public ResponseEntity<ChatbotResponseDto> askToChatbot(@RequestBody ChatbotRequestDto requestDto) {
        log.info("Received chatbot question: {}", requestDto.getQuestion());
        try {
            // ServiceImpl에서 의도에 따라 다른 로직을 수행한 후 결과를 반환
            ChatbotResponseDto responseDto = chatbotService.getChatbotResponse(requestDto);
            return ResponseEntity.ok(responseDto);
        } catch (Exception e) {
            log.error("Error during chatbot processing", e);
            ChatbotResponseDto errorResponse = new ChatbotResponseDto();
            errorResponse.setAnswer("죄송합니다. 질문을 처리하는 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
}