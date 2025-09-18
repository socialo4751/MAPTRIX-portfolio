package kr.or.ddit.community.free.server;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext; // [수정] ApplicationContext import
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import kr.or.ddit.common.config.ApplicationContextProvider; // [수정] ApplicationContextProvider import
import kr.or.ddit.common.websocket.config.WebSocketConfigurator;
import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.vo.ChatMessagesVO;

@Component
@ServerEndpoint(value = "/ws/chat/{roomId}", configurator = WebSocketConfigurator.class)
public class ChatEndpoint {

    private static final Logger log = LoggerFactory.getLogger(ChatEndpoint.class);
    private static final Map<String, Set<Session>> ROOMS = new ConcurrentHashMap<>();
    private static final ObjectMapper objectMapper = new ObjectMapper();

    // [원인 1] @Autowired를 통한 static 필드 주입은 불안정하므로 제거합니다.
    // private static ChatMessageService chatMessageService;
    // @Autowired
    // public void setChatMessageService(ChatMessageService service) {
    //     ChatEndpoint.chatMessageService = service;
    // }

    // [해결 1] 필요할 때마다 Spring Context에서 직접 ChatMessageService를 가져오는 안정적인 메소드
    private ChatMessageService getChatMessageService() {
        ApplicationContext ctx = ApplicationContextProvider.getApplicationContext();
        if (ctx == null) {
            log.error("Spring ApplicationContext를 찾을 수 없습니다!");
            throw new IllegalStateException("ChatMessageService를 가져올 수 없습니다.");
        }
        return ctx.getBean(ChatMessageService.class);
    }

    @OnOpen
    public void onOpen(Session session, @PathParam("roomId") String roomId) {
        try {
            ROOMS.computeIfAbsent(roomId, k -> Collections.synchronizedSet(new HashSet<>())).add(session);
            String username = safeUsername(session);
            log.info("채팅방 접속 성공: roomId={}, sessionId={}, username={}", roomId, session.getId(), username);

            // [수정] 클라이언트 JS와 JSON 키/값 형식을 통일합니다.
         //   Map<String, Object> payload = Map.of(
         //       "messageType", "SystemMessage",
         //       "content", username + " 님이 입장했습니다."
         //   );
         //   broadcast(roomId, objectMapper.writeValueAsString(payload));
        } catch (Exception e) {
            log.error("onOpen 중 오류 발생: roomId={}", roomId, e);
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        String roomIdStr = session.getPathParameters().get("roomId");
        String senderId = safeUsername(session);

        if ("익명".equals(senderId)) {
            sendError(session, "메시지를 보내려면 로그인이 필요합니다.");
            return;
        }

        try {
            log.info("메시지 수신: (ID:{}, room:{}, msg:{})", senderId, roomIdStr, message);

            // [해결 1 적용] getChatMessageService()를 통해 안전하게 서비스를 가져옵니다.
            ChatMessageService chatMessageService = getChatMessageService();
            
            ChatMessagesVO messageVO = new ChatMessagesVO();
            messageVO.setRoomId(Integer.parseInt(roomIdStr));
            messageVO.setSenderId(senderId);
            String filteredMessage = chatMessageService.filterMessage(message);
            messageVO.setContent(filteredMessage);
            
            // 이제 NullPointerException 없이 DB에 저장이 정상적으로 실행됩니다.
            chatMessageService.saveMessage(messageVO);
            log.info("메시지 DB 저장 성공.");

            // [수정] 클라이언트 JS와 JSON 키/값 형식을 통일합니다.
            Map<String, Object> payload = new HashMap<>();
            payload.put("messageType", "ChatMessage");

            payload.put("senderId", senderId);
            payload.put("content", filteredMessage);
            
            String jsonPayload = objectMapper.writeValueAsString(payload);
            
            // DB 저장 후, 이 브로드캐스트 로직이 정상적으로 실행됩니다.
            broadcast(roomIdStr, jsonPayload);
            log.info("메시지 브로드캐스트 완료.");

        } catch (Exception e) {
            log.error("onMessage 처리 중 심각한 오류 발생!", e);
            sendError(session, "메시지 처리 중 서버 오류가 발생했습니다.");
        }
    }

    @OnClose
    public void onClose(Session session) {
        String roomId = session.getPathParameters().get("roomId");
        String username = safeUsername(session);
        try {
            Set<Session> users = ROOMS.get(roomId);
            if (users != null) {
                users.remove(session);
                log.info("접속 종료: roomId={}, username={}, 남은 인원={}", roomId, username, users.size());

                if (!"익명".equals(username)) {
                   // [수정] 클라이언트 JS와 JSON 키/값 형식을 통일합니다.
                   // Map<String, Object> payload = Map.of(
                   //     "messageType", "SystemMessage",
                   //     "content", username + " 님이 퇴장했습니다."
                   // );
                   // broadcast(roomId, objectMapper.writeValueAsString(payload));
                }
                
                if (users.isEmpty()) {
                    ROOMS.remove(roomId);
                }
            }
        } catch (Exception e) {
            log.error("onClose 처리 중 오류 발생: roomId={}, username={}", roomId, username, e);
        }
    }

    @OnError
    public void onError(Session session, Throwable t) {
        log.error("웹소켓 오류 감지: sessionId={}, errorMessage={}", 
                  (session != null ? session.getId() : "N/A"), t.getMessage());
    }
    
    private void broadcast(String roomId, String jsonPayload) {
        Set<Session> users = ROOMS.get(roomId);
        if (users == null) return;
        
        synchronized (users) {
            users.forEach(session -> {
                if (session.isOpen()) {
                    try {
                        session.getBasicRemote().sendText(jsonPayload);
                    } catch (IOException e) {
                        log.warn("메시지 전송 실패: sessionId={}", session.getId(), e);
                    }
                }
            });
        }
    }
    
    private void sendError(Session session, String errorMessage) {
        try {
            if (session.isOpen()) {
                // [수정] 클라이언트 JS와 JSON 키/값 형식을 통일합니다.
                 Map<String, Object> payload = Map.of(
                    "messageType", "ErrorMessage", // 에러 타입도 명확하게
                    "content", errorMessage
                );
                session.getBasicRemote().sendText(objectMapper.writeValueAsString(payload));
            }
        } catch (IOException e) {
            log.warn("에러 메시지 전송 실패: sessionId={}", session.getId(), e);
        }
    }

    private String safeUsername(Session session) {
        Object u = session.getUserProperties().get("username");
        return (u != null && !String.valueOf(u).isBlank()) ? String.valueOf(u) : "익명";
    }
}