// src/main/java/kr/or/ddit/config/AsyncConfig.java
package kr.or.ddit.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.ThreadPoolExecutor;

@Configuration
@EnableAsync(proxyTargetClass = true) // CGLIB 프록시 사용
public class AsyncConfig {

    @Bean(name = "logEventExecutor")
    public ThreadPoolTaskExecutor logEventExecutor() {
        ThreadPoolTaskExecutor ex = new ThreadPoolTaskExecutor();
        ex.setThreadNamePrefix("log-event-");
        ex.setCorePoolSize(4);              // 머신/트래픽에 맞게 튜닝
        ex.setMaxPoolSize(8);
        ex.setQueueCapacity(10_000);        // 큐가 다 차면 아래 Rejection 핸들러 동작
        ex.setKeepAliveSeconds(60);
        // 로그 유실을 피하려면 CallerRunsPolicy(포화 시 동기 실행, 지연 가능)
        ex.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 유실을 허용(최소 지연)하려면 DiscardPolicy() 로 교체
        ex.initialize();
        return ex;
    }
}