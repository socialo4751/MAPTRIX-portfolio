// AdminOpenApiController.java

package kr.or.ddit.admin.openapi.contoller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.admin.openapi.service.AdminOpenApiService;
import kr.or.ddit.admin.openapi.vo.ApiApplicationAdminVO;
import kr.or.ddit.common.util.ArticlePage;

/**
 * @class Name : AdminOpenapiController
 * @Description : OPEN API 신청 관리 관련 관리자 요청을 처리하는 Controller
 */
@Controller
@RequestMapping("/admin/openapi/applications")
public class AdminOpenApiController {

    @Autowired
    private AdminOpenApiService adminOpenApiService;

    /**
     * @method Name : applicationList
     * @Description : 전체 API 신청 목록을 조회하여 화면에 전달한다.
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @return : API 신청 목록을 보여줄 관리자 View의 논리적 경로
     */
    @GetMapping
    public String applicationList(Model model,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            // ▼▼▼▼▼ status 파라미터 추가 ▼▼▼▼▼
            @RequestParam(value = "status", required = false, defaultValue = "") String status) {

        // 1. 요청 파라미터를 Map에 저장
        Map<String, Object> map = new HashMap<>();
        map.put("currentPage", currentPage);
        map.put("keyword", keyword);
        map.put("status", status); // status 값 추가

        // 2. 전체 행의 수와 현재 페이지의 목록 데이터를 가져옴
        int total = adminOpenApiService.getApplicationCount(map); // 수정된 쿼리 사용
        List<ApiApplicationAdminVO> content = adminOpenApiService.getApplicationList(map); // 수정된 쿼리 사용

        // 3. ArticlePage 객체 생성
        int size = 10;
        ArticlePage<ApiApplicationAdminVO> articlePage = new ArticlePage<>(total, currentPage, size, content, keyword);
        
        // 4. ArticlePage 객체에 페이징 URL 설정 (status 파라미터 유지를 위해)
        String url = "/admin/openapi/applications?status=" + status;
        articlePage.setUrl(url);

        // 5. View에 전달할 데이터를 Model에 추가
        model.addAttribute("articlePage", articlePage);
        
        // ▼▼▼▼▼ [추가] 상태별 건수 요약 데이터 조회 및 전달 ▼▼▼▼▼
        Map<String, Object> statusSummary = adminOpenApiService.getApplicationStatusSummary();
        model.addAttribute("statusSummary", statusSummary);
        // ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲

        return "admin/openapi/applications/applicationList";
    }

    /**
     * @method Name : applicationDetail
     * @Description : 특정 신청 건의 상세 정보를 조회하여 심사 화면에 전달한다.
     * @param applicationId : 상세 정보를 조회할 신청 건의 ID
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @return : API 신청 상세 정보를 보여줄 관리자 View의 논리적 경로
     */
    @GetMapping("/detail")
    public String applicationDetail(@RequestParam("appId") long applicationId, Model model) {
        ApiApplicationAdminVO application = adminOpenApiService.getApplicationDetail(applicationId);
        model.addAttribute("application", application);
        return "admin/openapi/applications/applicationDetail"; // 예시 View 경로
    }

    /**
     * @method Name : processApplication
     * @Description : 특정 신청 건에 대해 '승인' 또는 '반려' 처리를 수행한다.
     * @param applicationId : 처리할 신청 건의 ID
     * @param action : 처리 종류 ('approve' 또는 'reject')
     * @return : 처리 완료 후 리다이렉트될 URL
     */
    @PostMapping("/process")
 // @RequestParam("appId") -> @RequestParam("applicationId")로 수정
 public String processApplication(@RequestParam("applicationId") long applicationId, @RequestParam("action") String action) {
     if ("approve".equals(action)) {
         adminOpenApiService.approveApplication(applicationId);
     } else if ("reject".equals(action)) {
         adminOpenApiService.rejectApplication(applicationId);
     }
     return "redirect:/admin/openapi/applications";
 }
}