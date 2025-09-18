package kr.or.ddit.common.websocket.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.server.standard.ServerEndpointExporter;

@Configuration
public class WebSocketConfig {

    /**
     * @ServerEndpoint 어노테이션으로 정의된 WebSocket 엔드포인트(@ServerEndpoint가 붙은 클래스)를
     * 자동으로 찾아서 웹 서버(Tomcat)에 공식적으로 등록하는 역할을 합니다.
     * 이 Bean이 등록되어야 서버가 비로소 /ws/** 주소를 인식하게 됩니다.
     */
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }
}