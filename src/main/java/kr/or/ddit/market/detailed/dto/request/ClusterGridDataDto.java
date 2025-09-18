package kr.or.ddit.market.detailed.dto.request;

import java.util.Map;
import lombok.Data;

/**
 * [상세분석] (군집분석 해석 관련)
 * 군집 분석 격자 AI 해석을 요청할 때 사용하는 DTO
 */
@Data
public class ClusterGridDataDto {
    private String gid;
    private int clusterId;
    // 행정동 정보 필드 추가
    private String rank1AdmName;
    private Double rank1Perc;
    private String rank2AdmName;
    private Double rank2Perc;
    
    private Map<String, Object> variables;
}