package kr.or.ddit.admin.stats.user.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping ("/admin/stats/user-stats")
public class UserStatsViewController {
	
    @GetMapping
    public String userStatsView() {
    	
    	return "admin/stats/user/userStats";
    }

}
