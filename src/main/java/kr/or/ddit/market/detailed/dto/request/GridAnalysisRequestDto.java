package kr.or.ddit.market.detailed.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * [상세분석] (다중회귀모형 해석 관련)
 * 클라이언트에서 AI 격자 상세 분석을 요청할 때 보내는 데이터를 담는 DTO
 */
@Data
public class GridAnalysisRequestDto {
	// --- [추가] 행정동 관련 필드 ---
    @JsonProperty("1rank_AD_1")
    private String rank1AdmName;

    @JsonProperty("1rank_perc")
    private Double rank1Perc;

    @JsonProperty("2rank_AD_1")
    private String rank2AdmName;

    @JsonProperty("2rank_perc")
    private Double rank2Perc;
    
    // --- 기존 필드 유지 ---
    @JsonProperty("gid")
    private String gid;

    @JsonProperty("총사업체수")
    private Double totalBusinesses;

    @JsonProperty("총인구")
    private Double totalPopulation;

    @JsonProperty("30~34세 남녀 인구 합")
    private Double population30to34;

    @JsonProperty("1인가구 수")
    private Double singleHouseholds;

    @JsonProperty("신축 주택 비율")
    private Double newHousingRatio;

    @JsonProperty("도소매업체수")
    private Double retailBusinesses;

    @JsonProperty("숙박음식업체수")
    private Double lodgingAndFoodBusinesses;

    @JsonProperty("정보통신업체수")
    private Double itBusinesses;

    @JsonProperty("건설업체수")
    private Double constructionBusinesses;

    @JsonProperty("교육서비스업체수")
    private Double educationBusinesses;

    @JsonProperty("predicted_total_business")
    private Double predictedTotalBusiness;

    @JsonProperty("residual_total_business")
    private Double residualTotalBusiness;
}