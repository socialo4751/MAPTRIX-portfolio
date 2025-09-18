package kr.or.ddit.market.detailed.dto.response;

import java.util.List;
import lombok.Data;

/**
 * [상세분석] (군집분석 해석 관련)
 * AI가 생성한 군집 분석 격자 해석 리포트를 담는 DTO
 */
@Data
public class ClusterAnalysisResponseDto {

    private ClusterDefinition clusterDefinition;
    private GridClusterAnalysis gridClusterAnalysis;
    private String gridSpecificPotential;

    @Data
    public static class ClusterDefinition {
        private ClusterInfo cluster0;
        private ClusterInfo cluster1;
    }

    @Data
    public static class ClusterInfo {
        private String title; // 예: "상업 활력 중심지"
        private String description; // 예: "유동인구와 사업체 수가 많고..."
    }
    
    @Data
    public static class GridClusterAnalysis {
        private String title; // 예: "이 격자는 '상업 활력 중심지'에 속합니다."
        private List<String> characteristics; // 군집의 주요 특징 리스트
    }
}