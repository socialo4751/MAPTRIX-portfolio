// MarketStatsService.java

package kr.or.ddit.admin.stats.market.service;

import java.util.List;
import kr.or.ddit.admin.stats.market.vo.*;
import kr.or.ddit.common.util.ArticlePage;

public interface MarketStatsService {

    /** KPI 카드 데이터 조회 */
    MarketStatsKpiVO getKpi(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand);

    /** 인기 분석 지역 TOP N 조회 */
    List<TopLocationVO> getTopLocations(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand, Integer limit);

    /** 시간대별 분석량 조회 */
    List<HourlyCountVO> getHourlyCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand);

    /** 연령대/성별 분포 조회 */
    List<DemographicCountVO> getDemographicCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand);

    /** 분석 타입 분포 조회 (변경 없음) */
    List<AnalysisTypeCountVO> getAnalysisTypeCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand);

    /** 일자별 추이 조회 */
    List<DailyTrendVO> getDailyTrends(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand);
    
    /** 로그 데이터 페이징 조회 (Map -> 개별 파라미터로 변경) */
    ArticlePage<LogMarketAnalysisVO> getLogPage(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand, int currentPage);
}