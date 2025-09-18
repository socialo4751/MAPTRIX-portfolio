package kr.or.ddit.market.detailed.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * [상세분석] (중력모델 해석 관련)
 * 클라이언트에서 AI 격자 상세 분석을 요청할 때 보내는 데이터를 담는 DTO
 */
@Data
public class GravityGridDataDto {

    @JsonProperty("gid")
    private String gid;

    @JsonProperty("Gravity_Total")
    private double gravityTotal;

    @JsonProperty("인구 수")
    private int population;

    @JsonProperty("공시지가")
    private double landPrice;
    
    // 행정동 정보 필드 추가
    @JsonProperty("rank1AdmName")
    private String rank1AdmName;

    @JsonProperty("rank1Perc")
    private Double rank1Perc;

    @JsonProperty("rank2AdmName")
    private String rank2AdmName;

    @JsonProperty("rank2Perc")
    private Double rank2Perc;
}
