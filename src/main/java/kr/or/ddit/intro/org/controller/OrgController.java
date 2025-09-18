// OrgController.java
package kr.or.ddit.intro.org.controller;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.intro.org.service.OrgService;
import kr.or.ddit.intro.org.vo.OrgEmpVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/intro/org")
public class OrgController {

    @Autowired
    private OrgService orgService;

    @Autowired
    private CodeService codeService; // ★ 공통 코드


    // 조직도 화면
    @GetMapping("/chart")
    public String orgChart(Model model) {
        List<OrgEmpVO> empList = orgService.getAllEmployees();
        model.addAttribute("empList", empList);
        return "intro/org/orgchart";
    }

    // 전체 목록 + 검색(부서/키워드)
    @GetMapping
    public String listOrg(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "catCodeId", required = false) String catCodeId, // 예: DEPT101
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model) {

        // 공통코드 바인딩 (부서 셀렉트)
        model.addAttribute("codeDetails", codeService.getCodeDetailList("ORGTAG"));

        Integer deptId = parseDeptId(catCodeId);

        int size = 6;
        int total = orgService.countEmployees(deptId, keyword);

        int startRow = (currentPage - 1) * size + 1;
        int endRow = currentPage * size;

        List<OrgEmpVO> list = orgService.searchEmployeesPaged(deptId, keyword, startRow, endRow);

        // ArticlePage 구성 (searchType은 사용 안하므로 빈 문자열)
        ArticlePage<OrgEmpVO> page = new ArticlePage<>(total, currentPage, size, list, keyword, "");

        // 페이징 링크용 base URL (catCodeId만 베이스에 넣고, keyword는 ArticlePage가 붙여줌)
        String base = "/intro/org" + (catCodeId != null && !catCodeId.isEmpty() ? "?catCodeId=" + catCodeId : "");
        page.setUrl(base);

        // View 바인딩
        model.addAttribute("articlePage", page);
        model.addAttribute("selectedCatCodeId", catCodeId);
        model.addAttribute("keyword", keyword);

        return "intro/org/list";
    }


    // 부서 전용 페이지 (예쁜 URL) - 선택사항: 내부적으로 동일 검색 재사용
    @GetMapping("/dept/{deptId}/page")
    public String listByDeptPaged(
            @PathVariable int deptId,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            Model model) {

        int size = 6;
        int total = orgService.countEmployees(deptId, keyword);

        int startRow = (currentPage - 1) * size + 1;
        int endRow   = currentPage * size;

        List<OrgEmpVO> list = orgService.searchEmployeesPaged(deptId, keyword, startRow, endRow);

        ArticlePage<OrgEmpVO> page = new ArticlePage<>(total, currentPage, size, list, keyword);
        page.setUrl("/intro/org/dept/" + deptId + "/page"); // ★ 이게 있어야 pagingArea 생성됨

        model.addAttribute("articlePage", page);
        model.addAttribute("codeDetails", codeService.getCodeDetailList("ORGTAG"));
        model.addAttribute("selectedCatCodeId", "DEPT" + deptId);
        model.addAttribute("keyword", keyword);

        return "intro/org/list";
    }


    private Integer parseDeptId(String codeId) {
        if (codeId == null || !codeId.startsWith("DEPT")) return null;
        try {
            return Integer.parseInt(codeId.substring(4));
        } catch (Exception e) {
            return null;
        }
    }
}
