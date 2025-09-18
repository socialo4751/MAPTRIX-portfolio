// MarketStatsServiceImpl.java

package kr.or.ddit.admin.stats.market.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import kr.or.ddit.admin.stats.market.mapper.MarketStatsMapper;
import kr.or.ddit.admin.stats.market.service.MarketStatsService;
import kr.or.ddit.admin.stats.market.vo.*;
import kr.or.ddit.common.util.ArticlePage;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MarketStatsServiceImpl implements MarketStatsService {

    private final MarketStatsMapper mapper;

    @Override
    public MarketStatsKpiVO getKpi(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand) {
        return mapper.selectKpi(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));
    }

    @Override
    public List<TopLocationVO> getTopLocations(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand, Integer limit) {
        int safeLimit = (limit == null ? 10 : Math.max(1, Math.min(limit, 100)));
        return mapper.selectTopLocations(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand), safeLimit);
    }

    @Override
    public List<HourlyCountVO> getHourlyCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand) {
        return mapper.selectHourlyCounts(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));
    }

    @Override
    public List<DemographicCountVO> getDemographicCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand) {
        return mapper.selectDemographicCounts(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));
    }

    @Override
    public List<AnalysisTypeCountVO> getAnalysisTypeCounts(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand) {
        return mapper.selectAnalysisTypeCounts(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));
    }

    @Override
    public List<DailyTrendVO> getDailyTrends(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand) {
        return mapper.selectDailyTrends(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));
    }
    
    @Override
    public ArticlePage<LogMarketAnalysisVO> getLogPage(String from, String to, String type, Integer districtId, String admCode, String gender, String ageBand, int currentPage) {
        int size = 10; // 페이지당 10개로 고정

        // 1. 전체 레코드 수 조회
        int total = mapper.selectLogCount(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand));

        // 2. 페이징 계산
        int startRow = currentPage * size - (size - 1);
        int endRow = currentPage * size;
        
        // 3. 페이징 데이터 조회
        List<LogMarketAnalysisVO> content = mapper.selectLogList(trim(from), trim(to), trim(type), districtId, trim(admCode), trim(gender), trim(ageBand), startRow, endRow);

        // 4. ArticlePage 객체 생성 및 반환
        return new ArticlePage<>(total, currentPage, size, content, "");
    }

    /** 문자열 앞뒤 공백을 제거하고, 빈 문자열이면 null로 변환합니다. */
    private String trim(String s) {
        if (s == null) return null;
        String t = s.trim();
        return t.isEmpty() ? null : t;
    }
}