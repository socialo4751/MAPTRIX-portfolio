package kr.or.ddit.bizstats.chart.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.bizstats.chart.service.BizChartService;
import lombok.extern.slf4j.Slf4j;


/* 페이지 값만 보내는 컨트롤러  */
@Slf4j
@Controller
@RequestMapping("/biz-stats/chart")
public class BizChartController {
	
	@Autowired
	private BizChartService bizChartService;
	
	//(1) dashboard.jsp로 페이징 넘겨주는 메소드
    // 이 메소드의 유일한 역할은 'dashboard.jsp'라는 껍데기 페이지를 보여주는 것.
    // DB 조회가 없으므로 0.1초 만에 응답이 갑니다.
    @GetMapping
    public String dashboardView() {
        return "bizstats/chart/dashboard"; // 5개 차트 div가 포함된 JSP
    }


}
