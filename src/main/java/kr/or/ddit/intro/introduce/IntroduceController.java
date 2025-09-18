package kr.or.ddit.intro.introduce;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/intro")
public class IntroduceController {
    @GetMapping
    public String history(Model model) {
        return "intro/introduce/introduce";
    }
}
