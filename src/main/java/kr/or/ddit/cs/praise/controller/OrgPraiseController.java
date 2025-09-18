package kr.or.ddit.cs.praise.controller;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.cs.praise.service.OrgPraiseService;
import kr.or.ddit.cs.praise.vo.OrgPraisePostVO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * @class Name : OrgPraiseController.java
 * @description : '직원을 칭찬합니다' 게시판의 CRUD를 담당하는 컨트롤러입니다. 칭찬글 목록 조회, 등록, 삭제 기능을 제공합니다.
 */
@Controller
@RequestMapping("/cs/praise")
public class OrgPraiseController {

    private final OrgPraiseService praiseService;

    public OrgPraiseController(OrgPraiseService praiseService) {
        this.praiseService = praiseService;
    }

    /**
     * @param empName     : 필터링할 직원 이름
     * @param currentPage : 현재 페이지 번호
     * @param size        : 페이지 당 게시글 수
     * @param model       : View에 데이터를 전달하기 위한 Model 객체
     * @param request     : 컨텍스트 경로를 얻기 위한 HttpServletRequest 객체
     * @param principal   : 현재 로그인한 사용자 정보를 확인하기 위한 Principal 객체
     * @return "cs/praise/praise" : 칭찬게시판 목록 페이지 뷰 이름
     * @method Name : list
     * @description : 칭찬글 목록을 조회합니다. 직원 이름으로 필터링 및 페이징을 지원합니다.
     */
    @GetMapping
    public String list(
            @RequestParam(name = "empName", required = false) String empName,
            @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "size", required = false, defaultValue = "5") int size,
            Model model,
            HttpServletRequest request,
            Principal principal
    ) {
        model.addAttribute("employeeList", praiseService.getEmployeeList());
        model.addAttribute("loggedIn", principal != null);

        int total = praiseService.getPraiseCount(empName);

        int start = (currentPage - 1) * size;
        List<OrgPraisePostVO> content = praiseService.getPraisePage(empName, start, size);

        ArticlePage<OrgPraisePostVO> page = new ArticlePage<>(total, currentPage, size, content, empName);
        String url = request.getContextPath() + "/cs/praise";
        page.setUrl(url);

        model.addAttribute("articlePage", page);

        return "cs/praise/praise";
    }

    /**
     * @param vo        : 폼에서 전송된 칭찬글 데이터 VO
     * @param principal : 현재 로그인한 사용자의 정보를 담고 있는 Principal 객체
     * @return "redirect:/cs/praise" : 처리 후 칭찬게시판 목록으로 리다이렉트
     * @method Name : save
     * @description : 새로운 칭찬글을 등록합니다. 로그인한 사용자만 작성 가능합니다.
     */
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/save")
    public String save(OrgPraisePostVO vo, Principal principal) {
        vo.setUserId(principal.getName());
        praiseService.addPraise(vo);
        return "redirect:/cs/praise";
    }

    /**
     * @param praiseId : 삭제할 칭찬글의 ID
     * @return "redirect:/cs/praise" : 처리 후 칭찬게시판 목록으로 리다이렉트
     * @method Name : deletePraise
     * @description : 특정 칭찬글을 삭제 처리(비공개)합니다.
     */
    @PostMapping("/delete")
    public String deletePraise(Long praiseId) {
        praiseService.markPraiseAsDeleted(praiseId);
        return "redirect:/cs/praise";
    }

    @GetMapping("/emp-search")
    @ResponseBody
    public Map<String, Object> searchEmpAjax(
            @RequestParam(name = "q", required = false) String q,
            @RequestParam(name = "term", required = false) String term,
            @RequestParam(name = "limit", required = false, defaultValue = "20") int limit
    ) {
        String keyword = (q != null) ? q : term; // Select2가 q 또는 term로 보낼 수 있어 둘 다 지원
        var list = praiseService.searchEmployees(keyword, limit);

        var results = list.stream()
                .map(e -> {
                    Map<String, String> m = new HashMap<>();
                    m.put("id", e.getEmpId());     // 선택 시 서버로 넘어갈 값 (empId)
                    m.put("text", e.getEmpName()); // 드롭다운에 표시될 텍스트
                    return m;
                })
                .collect(Collectors.toList());

        Map<String, Object> resp = new HashMap<>();
        resp.put("results", results);
        return resp;
    }
}