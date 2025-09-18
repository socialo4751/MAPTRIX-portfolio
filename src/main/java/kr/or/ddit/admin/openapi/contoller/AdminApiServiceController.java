package kr.or.ddit.admin.openapi.contoller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.admin.openapi.service.AdminApiService;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;

@Controller
@RequestMapping("/admin/openapi/services")
public class AdminApiServiceController {

    @Autowired
    private AdminApiService adminApiService;
    
    @Autowired
    private CodeService codeService; // 공통 코드 서비스 주입

    /**
     * @method Name : serviceList
     * @Description : API 서비스 관리 목록 페이지
     */
    @GetMapping
    public String serviceList(Model model,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            @RequestParam(value = "catCodeId", required = false) String catCodeId){

        Map<String, Object> map = new HashMap<>();
        map.put("currentPage", currentPage);
        map.put("keyword", keyword);
        map.put("catCodeId", catCodeId);

        ArticlePage<ApiServiceVO> articlePage = adminApiService.getApiServicePage(map);
        
        // [수정] 페이징 URL에 catCodeId 파라미터가 유지되도록 URL 설정
        String url = "/admin/openapi/services";
        if (catCodeId != null && !catCodeId.isEmpty()) {
            url += "?catCodeId=" + catCodeId;
        }
        articlePage.setUrl("/admin/openapi/services");

        model.addAttribute("articlePage", articlePage);
        model.addAttribute("apiCateList", codeService.getCodeDetailList("API_CATE"));
        model.addAttribute("catCodeId", catCodeId);
        
        return "admin/openapi/service/serviceList";
    }

    /**
     * @method Name : serviceForm
     * @Description : API 서비스 등록/수정 폼 페이지
     */
    @GetMapping("/form")
    public String serviceForm(Model model, @RequestParam(value = "apiId", required = false, defaultValue = "0") long apiId) {
        
        // 1. 공통 코드를 조회하여 Model에 담는다 (Select Box 옵션용)
        model.addAttribute("apiCateList", codeService.getCodeDetailList("API_CATE"));
        model.addAttribute("apiFormatList", codeService.getCodeDetailList("API_FORMAT"));
        model.addAttribute("apiTypeList", codeService.getCodeDetailList("APITYPETAG"));

        // 2. 수정 모드일 경우 (apiId가 넘어온 경우), 기존 데이터를 조회하여 Model에 담는다.
        if (apiId > 0) {
            ApiServiceVO apiServiceVO = adminApiService.getApiServiceById(apiId);
            model.addAttribute("apiServiceVO", apiServiceVO);
            model.addAttribute("formMode", "edit"); // 수정 모드임을 JSP에 알려줌
        } else {
            model.addAttribute("apiServiceVO", new ApiServiceVO()); // 빈 객체를 전달
            model.addAttribute("formMode", "create"); // 생성 모드임을 JSP에 알려줌
        }
        
        return "admin/openapi/service/serviceForm";
    }

    /**
     * @method Name : serviceProcess
     * @Description : API 서비스 등록/수정 처리
     */
    @PostMapping("/process")
    public String serviceProcess(ApiServiceVO apiServiceVO) {
        
        if (apiServiceVO.getApiId() > 0) {
            // apiId가 있으면 수정
            adminApiService.updateApiService(apiServiceVO);
        } else {
            // apiId가 없으면 생성
            adminApiService.createApiService(apiServiceVO);
        }
        
        return "redirect:/admin/openapi/services";
    }
}