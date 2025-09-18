package kr.or.ddit.admin.stats.market.vo;

import java.util.List;
import kr.or.ddit.common.util.ArticlePage;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MarketStatsDashboardVO {
    private MarketStatsKpiVO kpiSummary;
    private List<TopLocationVO> top10Locations;
    private List<HourlyCountVO> hourlyCounts;
    private List<DemographicCountVO> demographicCounts;
    private List<AnalysisTypeCountVO> analysisTypeCounts;
    private List<DailyTrendVO> dailyTrends;
    private ArticlePage<LogMarketAnalysisVO> logPage;
}