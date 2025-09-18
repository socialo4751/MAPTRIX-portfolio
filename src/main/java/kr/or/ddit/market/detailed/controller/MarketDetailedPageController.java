package kr.or.ddit.market.detailed.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import kr.or.ddit.common.log.LogEvent;
import lombok.extern.slf4j.Slf4j;

// 사용자 입장에서 상권 / 시장 : market
// 상세분석

@Slf4j
@Controller
public class MarketDetailedPageController {
	
	/**
     * 브라우저가 /market/detailed 주소로 접속하면,
     * 데이터가 없는 순수한 JSP 페이지만을 반환합니다.
     * 데이터는 JSP 안의 스크립트가 API 컨트롤러를 통해 가져옵니다.
     * @return 뷰 이름
     */
	@LogEvent(eventType="VIEW", feature="ANALYSIS_DETAILED")
	@GetMapping("/market/detailed")
	public String MarketDetailed() {
		
		return "market/detailed/view";
	}
	

	
	
}
