package kr.or.ddit.market.detailed.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * [상세분석] (로지스틱 회귀분석 해석 관련)
 * 클라이언트에서 AI 격자 상세 분석을 요청할 때 보내는 데이터를 담는 DTO
 */
@Data
public class LogisticGridDataDto {

    @JsonProperty("gid")
    private String gid;

    @JsonProperty("cluster")
    private int cluster;

    @JsonProperty("총 인구수")
    private double totalPopulation;

    @JsonProperty("음식점 수")
    private double restaurantCount;

    @JsonProperty("서비스업 종사자 수")
    private double serviceWorkerCount;

    @JsonProperty("predicted_prob")
    private double predictedProb;

    @JsonProperty("predicted_class")
    private int predictedClass;

    @JsonProperty("정답 여부")
    private String correctness;
    
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