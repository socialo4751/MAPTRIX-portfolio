// MarketStatsMapper.java
package kr.or.ddit.admin.stats.market.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.admin.stats.market.vo.*;

@Mapper
public interface MarketStatsMapper {

    MarketStatsKpiVO selectKpi(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand
    );

    List<TopLocationVO> selectTopLocations(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand,
        @Param("limit") Integer limit       // XML에서 NVL(#{limit},10) 사용 중
    );

    List<HourlyCountVO> selectHourlyCounts(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand
    );

    List<DemographicCountVO> selectDemographicCounts(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand
    );

    List<AnalysisTypeCountVO> selectAnalysisTypeCounts(
            @Param("from") String from,
            @Param("to") String to,
            @Param("type") String type,
            @Param("districtId") Integer districtId,
            @Param("admCode") String admCode,
            @Param("gender") String gender,
            @Param("ageBand") String ageBand
        );

    List<DailyTrendVO> selectDailyTrends(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand
    );

    int selectLogCount(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand
    );

    List<LogMarketAnalysisVO> selectLogList(
        @Param("from") String from,
        @Param("to") String to,
        @Param("type") String type,
        @Param("districtId") Integer districtId,
        @Param("admCode") String admCode,   // ★ 추가
        @Param("gender") String gender,
        @Param("ageBand") String ageBand,
        @Param("startRow") int startRow,
        @Param("endRow") int endRow
    );
}
