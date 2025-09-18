package kr.or.ddit.admin.stats.market.controller;

// import는 기존과 동일
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.admin.stats.market.service.MarketStatsService;
import kr.or.ddit.admin.stats.market.vo.MarketStatsDashboardVO;
import kr.or.ddit.common.code.service.CodeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/admin/stats/market")
@RequiredArgsConstructor
public class MarketStatsController {

    private final MarketStatsService marketStatsService;
    private final CodeService codeService;

    /**
     * ⚙️ 대시보드 화면을 로딩합니다.
     */
    @GetMapping
    public String showDashboard(Model model) {
        model.addAttribute("districtList", codeService.getDistrictList());
        model.addAttribute("analysisTypeList", codeService.getCodeDetailList("ANLY_TYPE"));
        model.addAttribute("genderList", codeService.getCodeDetailList("GENDER"));
        model.addAttribute("ageBandList", codeService.getCodeDetailList("AGE_BAND"));

        // [경로 수정] 제공해주신 컨트롤러 코드의 경로를 그대로 사용합니다.
        return "admin/stats/market/dashboard";
    }

    /**
     * 🖥️ 대시보드 데이터를 JSON 형태로 조회하여 반환합니다.
     */
    @GetMapping("/data")
    @ResponseBody
    public MarketStatsDashboardVO getDashboardData(
            @RequestParam(required = false) String from,
            @RequestParam(required = false) String to,
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer districtId,
            @RequestParam(required = false) String admCode,   // [추가] admCode 파라미터
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String ageBand,
            @RequestParam(defaultValue = "1") int currentPage) {

        // [수정] Map을 사용하지 않고, 각 서비스 메소드에 파라미터를 직접 전달합니다.
        return MarketStatsDashboardVO.builder()
                .kpiSummary(marketStatsService.getKpi(from, to, type, districtId, admCode, gender, ageBand))
                .top10Locations(marketStatsService.getTopLocations(from, to, type, districtId, admCode, gender, ageBand, 10))
                .hourlyCounts(marketStatsService.getHourlyCounts(from, to, type, districtId, admCode, gender, ageBand))
                .demographicCounts(marketStatsService.getDemographicCounts(from, to, type, districtId, admCode, gender, ageBand))
             // [수정] 모든 파라미터 전달
                .analysisTypeCounts(marketStatsService.getAnalysisTypeCounts(from, to, type, districtId, admCode, gender, ageBand))
                .dailyTrends(marketStatsService.getDailyTrends(from, to, type, districtId, admCode, gender, ageBand))
                .logPage(marketStatsService.getLogPage(from, to, type, districtId, admCode, gender, ageBand, currentPage)) // Map 대신 파라미터 직접 전달
                .build();
    }
}