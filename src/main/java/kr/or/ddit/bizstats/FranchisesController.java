package kr.or.ddit.bizstats;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Slf4j
@Controller
// @RequestMapping ("/bizstats/franchises")
// franchises를 controller 하나의 주제로 하기에는
// volume이 부족함, 적절하지 않음.
// 유명 프랜차이즈 상권 지도 => 추후에 어떤 지도서비스에 합칠 것인지 고민
public class FranchisesController {

    //임시로 메소드에 URL 통째로 getMapping, 통째로 옮길 수 있다 가정
    @GetMapping("/biz-stats/franchises")
    public String BizStatsFranchises() {

        return "bizstats/franchises/franchises";
    }
    
}
