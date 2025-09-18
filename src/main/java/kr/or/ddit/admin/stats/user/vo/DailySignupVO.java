package kr.or.ddit.admin.stats.user.vo;

import java.util.Date;
import lombok.Data;

@Data
public class DailySignupVO {
    private Date statDate;
    private long newUsers;
}
