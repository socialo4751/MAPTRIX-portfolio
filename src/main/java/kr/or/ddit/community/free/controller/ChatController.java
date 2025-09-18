package kr.or.ddit.community.free.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.vo.ChatMessagesVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatController {

    private final ChatMessageService chatMessageService;
    private final SimpMessagingTemplate simpMessagingTemplate; // 특정 대상에게 메시지를 보내기 위한 객체

    /**
     * 클라이언트가 "/app/chat.sendMessage"로 메시지를 보내면 이 메소드가 처리합니다.
     * @param chatMessage 클라이언트가 보낸 JSON 데이터가 자동으로 ChatMessagesVO 객체로 변환되어 들어옵니다.
     */
    @MessageMapping("/chat.sendMessage")
    public void sendMessage(ChatMessagesVO chatMessage) {
        log.info("Received chat message: {}", chatMessage);

        // (선택) 여기서 받은 메시지를 DB에 저장할 수 있습니다.
        // chatMessageService.saveMessage(chatMessage);

        // 메시지를 해당 채팅방을 구독하고 있는 모든 클라이언트에게 브로드캐스팅합니다.
        // Spring이 chatMessage 객체를 알아서 JSON 문자열로 변환하여 보내줍니다.
        simpMessagingTemplate.convertAndSend("/topic/room/" + chatMessage.getRoomId(), chatMessage);
    }
}