package kr.or.ddit.intro.histroy;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/intro/history")
public class HistoryController {
    @GetMapping
    public String history(Model model) {
        return "intro/history/history";
    }
}
