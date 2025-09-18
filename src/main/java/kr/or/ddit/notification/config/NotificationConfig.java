package kr.or.ddit.notification.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * 알림 기능 관련 컴포넌트(@Controller, @Service 등)를
 * 스프링이 찾을 수 있도록 스캔 범위를 명시적으로 추가하는 설정 클래스
 */
@Configuration
@ComponentScan(basePackages = "kr.or.ddit.notification")
public class NotificationConfig {

}