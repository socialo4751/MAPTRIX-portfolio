package kr.or.ddit.bizstats.chart.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.bizstats.chart.service.BizChartService;
import kr.or.ddit.common.vo.stats.StatsBizStartCloseVO;
import kr.or.ddit.common.vo.stats.StatsBizStartCommonVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSalesrangeVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSmallbizVO;
import kr.or.ddit.common.vo.stats.StatsBizStartTrendVO;
import kr.or.ddit.common.vo.stats.StatsBizStartVO;
import lombok.extern.slf4j.Slf4j;


/*
*
* API용 경로는 /api로 명확히 구분
* API를 염두해두고 하나로 뭉치는 것이 아니라,
* API(DATA)일지라도 기능별로 API CONTROLLER 만드는 것을 규칙으로 삼음.
*
* KeywordController와 1대1로 대응함.
*
*/
@RequestMapping("/api/biz-stats/chart")
@Slf4j
@Controller
public class BizChartApiController {
	
	@Autowired 
	private BizChartService bizChartService;
	
	// 키워드 분석 창폐업 수 - 세진님 작업
	@ResponseBody 
    @GetMapping("/open-close")
    public List<StatsBizStartCloseVO> getStartCloseStats() {
        return bizChartService.selectBizStartClose();
    }
	
	// 자치구별 사업체 현황 - 정연우 작업
	@ResponseBody
    @GetMapping("/district-business")
    public List<StatsBizStartVO> getDistrictBusinessStats() {
        return bizChartService.selectDistrictBusiness();
    }
	
	// 자치구별 생활밀접업종 기본 현황 목록을 조회 - 정연우 작업
	@ResponseBody
    @GetMapping("/biz-common-stats")
    public List<StatsBizStartCommonVO> getBizCommonStats() {
        return bizChartService.selectBizStartCommon();
    }

	// 자치구별 소상공인 사업체 수 - 정연우 작업
	@ResponseBody
	@GetMapping("/smallbiz-stats")
	public List<StatsBizStartSmallbizVO> getSmallbizStats() {
		return bizChartService.selectSmallbizStats();
	}
	
	// 매출액 규모 - 정연우 작업
	@ResponseBody
	@GetMapping("/sales-range-stats")
	public List<StatsBizStartSalesrangeVO> getSalesRangeStats() {
		return bizChartService.selectSalesRangeStats();
	}
	
	// 3개년 현황
	@ResponseBody
	@GetMapping("/biz-trend-stats")
	public List<StatsBizStartTrendVO> getBizTrendStats() {
		return bizChartService.selectBizTrendStats();
	}
}
