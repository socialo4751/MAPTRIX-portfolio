package kr.or.ddit.admin.stats.system.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.admin.stats.system.service.SystemLogService;
import kr.or.ddit.admin.stats.system.vo.LoggingEventVO;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.util.ArticlePage;

@Controller
@RequestMapping("/admin/stats/system")
public class SystemLogController {

    @Autowired
    private SystemLogService systemLogService;

    @Autowired
    private CodeService codeService; // 공통 코드 서비스 주입

    @GetMapping
    public String logList(Model model, @RequestParam Map<String, Object> params, HttpServletRequest request) {

        // 1. 로그 카테고리 목록을 조회 (DB에 INSERT한 'LOG_SYS' 그룹 사용)
        List<CodeDetailVO> logCategories = codeService.getCodeDetailList("LOG_SYS");
        // 2. [추가] 로그 레벨 목록 ('LOG_SYS_LEVEL')
        List<CodeDetailVO> logLevels = codeService.getCodeDetailList("LOG_SYS_LV");
        
        model.addAttribute("logLevels", logLevels);
        model.addAttribute("logCategories", logCategories);
        
        // ▼▼▼▼▼ [추가] 로그 레벨별 건수 요약 정보 조회 ▼▼▼▼▼
        Map<String, Object> logLevelSummary = systemLogService.getLogLevelSummary();
        model.addAttribute("logLevelSummary", logLevelSummary);

        // 3. 로그 목록과 페이징 정보를 서비스로부터 조회
        ArticlePage<LoggingEventVO> articlePage = systemLogService.getLogList(params);
        
        // 4. ArticlePage 객체에 페이징을 위한 URL 세팅
        articlePage.setUrl(request.getRequestURI());
        
        // 5. 조회된 결과(페이징 정보 포함)와 검색 파라미터를 모델에 추가
        model.addAttribute("articlePage", articlePage);
        model.addAttribute("params", params); // JSP에서 검색 조건을 유지하기 위해 필요

        // 6. 뷰 페이지 경로 반환
        return "admin/stats/system/logList";
    }
}