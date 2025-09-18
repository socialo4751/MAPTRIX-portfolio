package kr.or.ddit.admin.stats.user.vo;

import java.util.Date;
import lombok.Data;

@Data
public class LogUserEventVO {
    private Long eventId;
    private String userId;
    private String eventType;   // SIGNUP, LOGIN, ACTION...
    private String feature;     // ANALYSIS, COMMUNITY, STAMP, API, DRAWING, OTHER
    private String channel;     // WEB, MOBILE...
    private String clientIp;
    private String paramJson;   // CLOB 매핑
    private String contextJson; // CLOB 매핑
    private Long resultRows;
    private Long durationMs;
    private String status;      // SUCCESS/FAIL
    private Date runAt;
}
