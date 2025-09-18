package kr.or.ddit.common.websocket.config;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.context.ApplicationContext;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.stereotype.Component; // 혹시 모르니 추가

import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import kr.or.ddit.common.config.ApplicationContextProvider;
import kr.or.ddit.common.config.jwt.TokenProvider;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class WebSocketConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public <T> T getEndpointInstance(Class<T> endpointClass) throws InstantiationException {
        ApplicationContext ctx = ApplicationContextProvider.getApplicationContext();
        if (ctx == null) {
            throw new IllegalStateException("Spring ApplicationContext를 찾을 수 없습니다.");
        }
        return ctx.getAutowireCapableBeanFactory().createBean(endpointClass);
    }

    /**
     * [최종 수정] Handshake 단계에서 HttpSession을 사용하여 로그인 사용자 정보를
     * UserProperties에 저장합니다.
     */
    @Override
    public void modifyHandshake(ServerEndpointConfig config,
                                HandshakeRequest request,
                                HandshakeResponse response) {


        // 1. Spring Context에서 TokenProvider Bean을 가져옵니다.
        ApplicationContext ctx = ApplicationContextProvider.getApplicationContext();
        if (ctx == null) {
            return;
        }
        TokenProvider tokenProvider = ctx.getBean(TokenProvider.class);

        // 2. Handshake 요청 헤더에서 'Cookie' 정보를 가져옵니다.
        Map<String, List<String>> headers = request.getHeaders();
        List<String> cookieHeaders = headers.get("cookie");
        String accessToken = null;

        if (cookieHeaders != null && !cookieHeaders.isEmpty()) {
            // "key1=value1; key2=value2; ..." 형태의 쿠키 문자열을 파싱합니다.
            for (String cookieStr : cookieHeaders) {
                String[] cookies = cookieStr.split(";\\s*");
                for (String cookie : cookies) {
                    if (cookie.startsWith("accessToken=")) {
                        accessToken = cookie.substring("accessToken=".length());
                        break;
                    }
                }
                if (accessToken != null) break;
            }
        }

        // 3. accessToken 유효성 검증
        if (accessToken != null && tokenProvider.validate(accessToken)) {
            // 4. 토큰이 유효하면 Authentication 객체를 생성합니다.
            Authentication auth = tokenProvider.getAuthentication(accessToken);
            if (auth != null && auth.isAuthenticated()) {
                // 5. 인증 정보에서 사용자 이름을 꺼내 WebSocket 세션 속성에 저장합니다.
                config.getUserProperties().put("username", auth.getName());
            } else {
            }
        } else {
            log.error("[WS Handshake] 실패: 유효한 토큰이 발견되지 않았습니다.");
        }

        super.modifyHandshake(config, request, response);
    }
}