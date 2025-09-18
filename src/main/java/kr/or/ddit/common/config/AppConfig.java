// 예: src/main/java/kr/or/ddit/config/AppConfig.java
package kr.or.ddit.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

@Configuration
public class AppConfig {

    // RestTemplate 빈 등록
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

    // ObjectMapper 빈 등록 (필요한 경우)
    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        // ⭐ 기존 ObjectMapper 설정에 이 한 줄을 추가합니다. ⭐
        objectMapper.registerModule(new JavaTimeModule()); 

        return objectMapper;
    }
}
