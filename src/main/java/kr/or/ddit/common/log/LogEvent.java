package kr.or.ddit.common.log;

import java.lang.annotation.*;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface LogEvent {
	//일단 두개로 나누어 놓음.
    String eventType() default "ACTION";
    String feature()   default "OTHER";

    boolean captureParams() default true;   // 파라미터 JSON 캡처 여부
    boolean captureResultSize() default true; // 반환값이 Collection일 때 size 기록
    boolean skipIfAnon() default false;     // 비로그인(ANON)인 경우 로깅 생략
    double  sampleRate() default 1.0;       // 0.0~1.0 (CALL 같은 곳에 유용)
}