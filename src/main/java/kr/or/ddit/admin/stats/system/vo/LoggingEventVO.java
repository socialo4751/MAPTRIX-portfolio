package kr.or.ddit.admin.stats.system.vo;

import lombok.Data;

import java.util.Date;

/**
 * 로깅 이벤트 정보를 담기 위한 VO 클래스
 */
@Data
public class LoggingEventVO {
    private long eventId; // 이벤트_ID
    private Date timestamp; // 발생일시

    private String formattedMessage; // 로그 메시지
    private String loggerName; // 발생 클래스
    private String levelString; // 로그 레벨
    private String threadName; // 스레드 이름
    private Integer referenceFlag; // 참조 플래그
    private String arg0; // 인자_0
    private String arg1; // 인자_1
    private String arg2; // 인자_2
    private String arg3; // 인자_3
    private String callerFilename; // 호출자_파일명
    private String callerClass; // 호출자_클래스명
    private String callerMethod; // 호출자_메소드명
    private int callerLine; // 호출자_라인번호
}
