package kr.or.ddit.common.websocket.config;

import java.security.Principal;
import java.util.Arrays;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;
import org.springframework.http.server.ServerHttpRequest;

import kr.or.ddit.common.config.jwt.TokenProvider;  // ★ 주입해서 쓰기
import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
public class StompWebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final TokenProvider tokenProvider; // ★ JWT로 Principal 생성에 사용

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws/stomp")
                // ★ STOMP 핸드셰이크에서 Principal 설정
                .setHandshakeHandler(new DefaultHandshakeHandler() {
                    @Override
                    protected Principal determineUser(ServerHttpRequest request,
                                                      org.springframework.web.socket.WebSocketHandler wsHandler,
                                                      java.util.Map<String, Object> attributes) {
                        // 쿠키에서 accessToken 추출
                        String cookieHeader = request.getHeaders().getFirst("Cookie");
                        if (cookieHeader != null) {
                            String accessToken = Arrays.stream(cookieHeader.split(";"))
                                    .map(String::trim)
                                    .filter(c -> c.startsWith("accessToken="))
                                    .map(c -> c.substring("accessToken=".length()))
                                    .findFirst().orElse(null);

                            if (accessToken != null && tokenProvider.validate(accessToken)) {
                                String userId = tokenProvider.getAuthentication(accessToken).getName();
                                return () -> userId; // ★ STOMP 세션의 Principal.name
                            }
                        }
                        return null; // 비로그인 세션이면 user-destination 라우팅 안 됨
                    }
                })
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // ★ user-destination을 위해 /queue 활성화
        registry.enableSimpleBroker("/topic", "/queue");
        registry.setApplicationDestinationPrefixes("/app");
        registry.setUserDestinationPrefix("/user"); // 명시 권장
    }
}
