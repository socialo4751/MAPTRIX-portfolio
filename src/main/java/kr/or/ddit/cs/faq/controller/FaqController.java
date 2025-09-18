package kr.or.ddit.cs.faq.controller;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.cs.faq.service.CsFaqService;
import kr.or.ddit.cs.faq.vo.CsFaqVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cs/faq")
public class FaqController {

    private final CsFaqService csFaqService;

    @Autowired
    private CodeService codeService; // 코드 서비스 주입 (있어야 함)

    @Autowired
    public FaqController(CsFaqService csFaqService) {
        this.csFaqService = csFaqService;
    }

    /**
     * @description: FAQ 목록 조회 + 검색 + 페이징
     */
    @GetMapping
    public String list(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "catCodeId", required = false) String catCodeId,
            @RequestParam(value = "searchType", required = false, defaultValue = "SC101") String searchType,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model
    ) {
        // 드롭다운 옵션 바인딩
        model.addAttribute("codeDetails", codeService.getCodeDetailList("FAQTAG"));
        model.addAttribute("searchTags", codeService.getCodeDetailList("SEARCHTAG"));

        // 조회 파라미터
        int pageSize = 10; // 기존 값 유지
        Map<String, Object> paramMap = new HashMap<>();
        if (catCodeId != null && !catCodeId.isBlank()) paramMap.put("catCodeId", catCodeId);
        paramMap.put("searchType", searchType == null ? "SC101" : searchType.trim().toUpperCase());
        paramMap.put("keyword", keyword == null ? "" : keyword.trim());
        paramMap.put("startRow", (currentPage - 1) * pageSize + 1);
        paramMap.put("endRow", currentPage * pageSize);

        int total = csFaqService.getFaqCount(paramMap);
        List<CsFaqVO> faqList = csFaqService.getPagedFaqList(paramMap);

        // ★ 핵심: ArticlePage에 keyword와 searchType을 '둘 다' 전달
        ArticlePage<CsFaqVO> articlePage =
                new ArticlePage<>(total, currentPage, pageSize, faqList, keyword, searchType);

        // ★ base URL에는 catCodeId만(있을 때만) 넣기 — searchType/keyword는 절대 넣지 말 것!
        String baseUrl = "/cs/faq";
        if (catCodeId != null && !catCodeId.isBlank()) {
            baseUrl += "?catCodeId=" + URLEncoder.encode(catCodeId, StandardCharsets.UTF_8);
        }
        articlePage.setUrl(baseUrl);

        // 모델 바인딩
        model.addAttribute("articlePage", articlePage);
        model.addAttribute("faqList", faqList);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        return "cs/faq/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("faqId") int faqId, Model model) {
        CsFaqVO faq = csFaqService.getFaqById(faqId); // 단건 조회
        model.addAttribute("faq", faq);
        return "cs/faq/detail"; // /WEB-INF/views/cs/faq/detail.jsp
    }

}
