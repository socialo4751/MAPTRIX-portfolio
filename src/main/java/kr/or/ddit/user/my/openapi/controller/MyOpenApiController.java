package kr.or.ddit.user.my.openapi.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import kr.or.ddit.openapi.apply.service.OpenApiService;
import kr.or.ddit.openapi.apply.vo.MySubscriptionVO;

@Controller
@RequestMapping("/my/openapi/status")
public class MyOpenApiController {
	
	@Autowired 
	OpenApiService openApiService;
	
    /**
     * @method Name : myApiStatus
     * @Description : 로그인한 사용자의 API 신청/구독 현황 페이지로 이동한다. (페이징 처리)
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @param principal : 현재 로그인한 사용자 정보를 담고 있는 객체
     * @param tab : 현재 활성화된 탭 (approved, pending, rejected)
     * @param currentPage : 페이지 링크 클릭 시 ArticlePage에 의해 생성된 페이지 번호
     * @param approvedPage : '승인됨' 탭의 현재 페이지 번호
     * @param pendingPage : '승인 대기' 탭의 현재 페이지 번호
     * @param rejectedPage : '반려' 탭의 현재 페이지 번호
     * @return : 나의 API 현황을 보여줄 View의 논리적 경로
     */
    @GetMapping
    public String myApiStatus(
            Model model,
            Principal principal,
            @RequestParam(name="tab", defaultValue = "approved") String tab,
            @RequestParam(name="currentPage", required = false) Integer currentPage,
            @RequestParam(name="approvedPage", defaultValue = "1") int approvedPage,
            @RequestParam(name="pendingPage", defaultValue = "1") int pendingPage,
            @RequestParam(name="rejectedPage", defaultValue = "1") int rejectedPage) {
        
        // ArticlePage의 페이지 링크를 클릭하면 'currentPage' 파라미터가 생성됩니다.
        // 'tab' 파라미터를 통해 어떤 탭의 페이지 이동인지 구분하고, 해당 탭의 페이지 번호를 업데이트합니다.
        if (currentPage != null) {
            switch (tab) {
                case "approved": approvedPage = currentPage; break;
                case "pending":  pendingPage  = currentPage; break;
                case "rejected": rejectedPage = currentPage; break;
            }
        }
        
        String userId = principal.getName();
        int pageSize = 3; // 요청하신 대로 페이징 크기를 2로 설정합니다.

        // 1. 승인됨 (구독) 목록 조회
        ArticlePage<MySubscriptionVO> approvedData = openApiService.findMySubscriptionList(userId, approvedPage, pageSize);
        approvedData.setUrl("/my/openapi/status?tab=approved&pendingPage=" + pendingPage + "&rejectedPage=" + rejectedPage);
        model.addAttribute("approvedPage", approvedData);

        // 2. 승인 대기 목록 조회
        ArticlePage<ApiApplicationVO> pendingData = openApiService.findMyApplicationsByStatus(userId, "PENDING", pendingPage, pageSize);
        pendingData.setUrl("/my/openapi/status?tab=pending&approvedPage=" + approvedPage + "&rejectedPage=" + rejectedPage);
        model.addAttribute("pendingPage", pendingData);

        // 3. 반려 목록 조회
        ArticlePage<ApiApplicationVO> rejectedData = openApiService.findMyApplicationsByStatus(userId, "REJECTED", rejectedPage, pageSize);
        rejectedData.setUrl("/my/openapi/status?tab=rejected&approvedPage=" + approvedPage + "&pendingPage=" + pendingPage);
        model.addAttribute("rejectedPage", rejectedData);

        model.addAttribute("activeTab", tab); // 페이지 로드 시 활성화할 탭 정보를 View에 전달

        return "my/openapi/myApiStatus";
    }
}