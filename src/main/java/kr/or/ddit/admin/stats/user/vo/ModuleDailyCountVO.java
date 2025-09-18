package kr.or.ddit.admin.stats.user.vo;

import java.util.Date;
import lombok.Data;

@Data
public class ModuleDailyCountVO {
    private Date statDate;          // TRUNC(RUN_AT)
    private long analysisCount;
    private long communityCount;
    private long stampCount;
    private long apiCount;
    private long drawingCount;
}
