package kr.or.ddit.admin.apply.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.util.ArticlePage;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/apply")
@PreAuthorize("hasRole('ADMIN')")
public class AdminApplyViewController {
	
	@Autowired
    private StBizApplyService stBizApplyService;
	
	@Autowired
	private CodeService codeService;
	/**
     * [GET] 회원 목록 조회 페이지 (활성화 여부 필터링 포함)
     * URL: /admin/users
     * @param model Model 객체
     * @param searchKeyword 검색어 (ID, 이름, 이메일, 전화번호)
     * @param enabledStatus 활성화 상태 필터 ('Y' 또는 'N')
     * @return 회원 목록을 보여주는 JSP 뷰 경로
     */
	@GetMapping
	public String applyList(Model model,
	                        @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
	                        @RequestParam(value = "searchType", required = false) String status,
	                        @RequestParam(value = "keyword", required = false) String keyword,
	                        @RequestParam(value = "currentPage", defaultValue = "1") int currentPage) {

	    Map<String, Object> paramMap = new HashMap<>();
	    
	    //searchKeyword가 비었으면 keyword를 넣는다.
	    String keyVal = ""; 
	    if(searchKeyword == null || searchKeyword.equals("") ) {
	    	keyVal = keyword;
	    }else {
	    	keyVal = searchKeyword;
	    }
	    
	    paramMap.put("searchKeyword", keyVal);
	    paramMap.put("keyword", keyVal);
	    paramMap.put("searchType", status);
	    paramMap.put("status", status);

	    int size = 10;
	    int total = stBizApplyService.getStBizApplyCount(paramMap);

	    paramMap.put("startRow", (currentPage - 1) * size + 1);
	    paramMap.put("endRow", currentPage * size);

	    List<StBizApplyVO> applyList = stBizApplyService.getStBizApplyList(paramMap);

	    Map<String, Object> statusSummary = stBizApplyService.getStatusSummary();
	    model.addAttribute("statusSummary", statusSummary);

	    // ▼▼▼▼▼ [수정] 6개 파라미터를 사용하는 생성자로 변경 ▼▼▼▼▼
	    ArticlePage<StBizApplyVO> page = new ArticlePage<>(total, currentPage, size, applyList, keyVal, status);
	    // ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲

	    // URL 설정 (페이지네이션 링크용)
	    page.setUrl("/admin/apply");
	    
	    model.addAttribute("articlePage", page);
	    model.addAttribute("status", status);
	    model.addAttribute("searchType", status);
	    model.addAttribute("searchKeyword", keyVal);
	    model.addAttribute("keyword", keyVal);
	    
	    return "admin/apply/applyList";
	}
	
	    @GetMapping("/stats") // applyListStats 요청 처리
    public String applyListStats(Model model) {
    	
        // 요청 목록 조회
        List<Map<String,Object>> applyStatsList = stBizApplyService.getStBizApplyStatsList();
        
        model.addAttribute("applyStatsList", applyStatsList);
        
        return "admin/apply/apply-stamp-stats"; // 뷰 경로
    }
}
