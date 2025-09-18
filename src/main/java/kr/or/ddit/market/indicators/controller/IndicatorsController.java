package kr.or.ddit.market.indicators.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/market/indicators")
public class IndicatorsController {

    @GetMapping
    public String dashboardView(){
        return "market/indicators/dashboard";
    }
}
