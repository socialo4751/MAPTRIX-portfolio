package kr.or.ddit.admin.main.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.admin.main.service.AdminDashboardService;

@Controller
@RequestMapping("/admin")
@RequiredArgsConstructor
public class AdminMainController {

    private final AdminDashboardService dashboardService;

    @GetMapping
    public String adminMain(Model model) {
        model.addAttribute("kpis", dashboardService.getKpis());
        model.addAttribute("signupTrend", dashboardService.getSignupTrend());
        model.addAttribute("logLevel24h", dashboardService.getLogLevel24h());
        model.addAttribute("todoQna", dashboardService.getTodoQna());
        model.addAttribute("recentNotice", dashboardService.getRecentNotice());
        return "admin/adminMain";
    }
}
