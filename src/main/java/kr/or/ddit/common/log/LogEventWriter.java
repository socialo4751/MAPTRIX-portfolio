package kr.or.ddit.common.log;

import java.util.Date;

import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import kr.or.ddit.admin.stats.user.vo.LogUserEventVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 비동기 이벤트 로그 삽입기
 */

@Slf4j
@Component
@RequiredArgsConstructor
public class LogEventWriter {

    private final LogEventMapper logEventMapper;

    // VARCHAR2 컬럼을 쓰는 경우엔 길이 제한 필요. CLOB이면 0으로 두면 됨.
    private static final int MAX_JSON_LEN = 4000; // CLOB이면 0으로 변경

    @Async // 없으면 @Async 제거하거나 bean 이름 맞추기
    public void writeAsync(LogUserEventVO vo) {
        try {
            write(vo);
        } catch (Exception e) {
            log.warn("Async log write failed", e);
        }
    }

    /** 
     * 
   동기 쓰기 
      *	
     **/
    public int write(LogUserEventVO vo) {
        if (vo == null) return 0;

        // 필수/디폴트 보정
        if (vo.getRunAt() == null) vo.setRunAt(new Date());
        if (vo.getStatus() == null) vo.setStatus("SUCCESS");
        if (vo.getEventType() == null) vo.setEventType("ACTION");
        if (vo.getFeature() == null) vo.setFeature("OTHER");

        // JSON 길이 보호 (컬럼이 VARCHAR2일 때만)
        if (MAX_JSON_LEN > 0) {
            vo.setParamJson(truncate(vo.getParamJson(), MAX_JSON_LEN));
            vo.setContextJson(truncate(vo.getContextJson(), MAX_JSON_LEN));
        }

        // 숫자 null 방지
        if (vo.getResultRows() == null) vo.setResultRows(null); // null 허용
        if (vo.getDurationMs() == null) vo.setDurationMs(0L);

        return logEventMapper.insertLogUserEvent(vo);
    }

    private String truncate(String s, int max) {
        return (s != null && s.length() > max) ? s.substring(0, max) : s;
    }
}
