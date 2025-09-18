package kr.or.ddit.admin.stats.market.vo;

import java.util.Date;
import lombok.Data;

@Data
public class LogMarketAnalysisVO {
    // DB 테이블의 컬럼들과 1:1로 매핑되는 필드들
    private Long analysisId;
    private String userId;
    private String analysisType;
    private String ageBand;
    private String gender;
    private Long districtId;
    private String admCode;
    private String bizCodeId;
    private String channel;
    private String clientIp;
    private String geomWkt;
    private String paramJson; //사용자가 던진 입력 조건
    private String ContextJson; //실행 맥락/결과 메타(subType: GRID/CLUSTER…, UA, elapsedMs 등)
    private Long resultRows;
    private Long durationMs;
    private String status;
    private Date runAt;
    
    // [추가] JOIN을 통해 가져올 이름 필드
    private String districtName;
    private String admName;
}