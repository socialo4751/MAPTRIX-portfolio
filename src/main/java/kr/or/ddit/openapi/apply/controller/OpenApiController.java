package kr.or.ddit.openapi.apply.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;
import kr.or.ddit.openapi.apply.service.OpenApiService;

/**
 * @class Name : OpenApiController
 * @Description : OPEN API 서비스 조회 및 신청 관련 이용자 요청을 처리하는 Controller
 */
@Controller
public class OpenApiController {

    @Autowired
    private OpenApiService openApiService;

    /**
     * @method Name : none
     * @Description : 전체 OPEN API 서비스 목록을 조회하여 화면에 전달한다.
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @return : API 목록을 보여줄 View의 논리적 경로
     */
    @GetMapping("/openapi")
    public String list(Model model) {
        List<ApiServiceVO> apiList = openApiService.getApiList();
        model.addAttribute("apiList", apiList);
        return "openapi/apiList";
    }
    
    @GetMapping("/openapi/intro")
    public String intro() {
        return "openapi/intro";
    }

    /**
     * @method Name : detail
     * @Description : 특정 API의 상세 정보를 조회하여 화면에 전달한다.
     * @param apiId : 상세 정보를 조회할 API의 ID
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @return : API 상세 정보를 보여줄 View의 논리적 경로
     */
    @GetMapping("/openapi/detail")
    public String apiDetail(@RequestParam("apiId") long apiId, Model model, Principal principal) {
        
        // 1. API 서비스 상세 정보 조회 (Markdown 변환 로직이 포함된 서비스 메소드 호출)
        ApiServiceVO apiService = openApiService.getApiById(apiId);
        model.addAttribute("apiService", apiService);

        // ▼▼▼▼▼ [수정] 재신청 가능 여부 확인 로직 변경 ▼▼▼▼▼
        boolean hasApplied = false;
        if (principal != null) {
            String userId = principal.getName();
            
            // 2. 서비스에 모든 로직을 위임하고, 결과(true/false)만 받음
            hasApplied = openApiService.hasActiveApplication(userId, apiId);
        }
        model.addAttribute("hasApplied", hasApplied);
        // ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲

        return "openapi/apiDetail"; // JSP 뷰 경로
    }

    /**
     * @method Name : applyForm
     * @Description : API 이용 신청서 작성 화면으로 이동한다.
     * @param apiId : 신청할 API의 ID
     * @param model : View에 신청할 API 정보를 전달하기 위한 Model 객체
     * @return : API 신청서 작성 View의 논리적 경로
     */
    @GetMapping("/openapi/apply")
    public String applyForm(@RequestParam("apiId") long apiId, Model model) {
        ApiServiceVO apiService = openApiService.getApiById(apiId);
        model.addAttribute("apiService", apiService);
        return "openapi/apiApplyForm";
    }

    /**
     * @method Name : apply
     * @Description : 사용자가 작성한 API 이용 신청 정보를 받아 처리한다.
     * @param applicationVO : 사용자가 폼을 통해 제출한 신청 정보
     * @return : 처리 완료 후 리다이렉트될 URL
     */
    @LogEvent(eventType="APPLY", feature="OPENAPI")
    @PostMapping("/openapi/apply")
    public String apply(ApiApplicationVO applicationVO, Principal principal, RedirectAttributes redirectAttributes) {
        // Spring Security 등을 사용하여 현재 로그인한 사용자의 ID를 가져와 세팅
        String currentUserId = principal.getName();
        applicationVO.setUserId(currentUserId);
        
        // 완료 페이지에 API 이름을 전달하기 위해 정보를 조회
        ApiServiceVO apiService = openApiService.getApiById(applicationVO.getApiId());
        
        openApiService.submitApplication(applicationVO);
        
        // 3. 리다이렉트 페이지에서 사용할 수 있도록 API 이름을 Flash Attribute에 추가
        redirectAttributes.addFlashAttribute("apiNameKr", apiService.getApiNameKr());
        
        // 4. 기존의 목록 대신 새로운 완료 페이지 URL로 리다이렉트
        return "redirect:/openapi/apply/complete"; 
    }
    
    /**
     * @method Name : applyComplete
     * @Description : API 신청 완료 페이지를 보여준다.
     */
    @GetMapping("/openapi/apply/complete")
    public String applyComplete() {
        // 5. 이 새로운 메소드는 완료 페이지(JSP)의 경로를 반환합니다.
        return "openapi/apiApplyComplete";
    }
    

}