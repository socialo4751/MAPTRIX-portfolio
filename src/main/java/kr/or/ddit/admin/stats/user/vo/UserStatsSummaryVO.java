package kr.or.ddit.admin.stats.user.vo;

import lombok.Data;

@Data
public class UserStatsSummaryVO {
    private long dau;           // 특정일 DAU (to 기준)
    private long mau;           // 최근 30일 MAU (to 기준)
    private long newUsers;      // 기간 내 신규가입
    private long activeUsers;   // 기간 내 활동 사용자 수(중복제거)
    private long repeatUsers;   // 기간 내 2일 이상 활동 사용자 수
    // 파생지표
    public double getRepeatRate() {
        return activeUsers == 0 ? 0.0 : (repeatUsers * 100.0 / activeUsers);
    }
    public double getChurnRate() { // 매우 러프한 이탈률(=1-재방문율)
        return 100.0 - getRepeatRate();
    }
}
