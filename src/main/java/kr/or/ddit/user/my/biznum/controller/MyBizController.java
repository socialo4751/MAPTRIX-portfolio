package kr.or.ddit.user.my.biznum.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.vo.user.UsersBizIdVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.UserService;
import org.springframework.beans.factory.annotation.Value;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/profile/biznum")
public class MyBizController {
	
	// application.properties의 값을 가져옴
    @Value("${kakao.map.api.key}")
    private String kakaoMapApiKey;
    
	@Autowired
	private UserService userService;
	
	/**
	 * 사업자 등록 정보 페이지
	 * @param session 로그인 사용자의 세션 정보
	 * @param model   뷰로 전달할 데이터
	 * @return        JSP 페이지 경로
	 */
	@GetMapping
	public String business(HttpSession session, Model model) {
	    // 1. 현재 로그인된 사용자의 ID를 가져옵니다.
	    String userId = null; 
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

	    if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getName())) {
	        userId = authentication.getName();
	        log.info("현재 로그인된 사용자 ID: {}", userId);
	    } else {
	        log.warn("로그인되지 않은 사용자가 마이페이지에 접근 시도. 로그인 페이지로 리다이렉트합니다.");
	        return "redirect:/login";
	    }
	    
	    // 2. DB에서 최신 사용자 정보를 다시 조회한다.
	    //    위에서 가져온 userId를 바로 사용합니다.
	    UsersVO loginUser = userService.findByUserId(userId);
	    
	    // 3. 최신 정보를 세션과 모델에 모두 업데이트
	    session.setAttribute("loginUser", loginUser);
	    model.addAttribute("loginUser", loginUser);
	    
	    // 4. 여기에 카카오 API 키를 모델에 추가합니다.
        model.addAttribute("kakaoMapApiKey", kakaoMapApiKey);
	    
	    return "my/profile/business";
	}
	
	/**
     * 사업자 등록 또는 수정 처리 (POST 요청)
     * JSP 폼에서 전송된 사업자 정보를 받아 DB에 저장/수정합니다.
     * @param usersBizIdVO 폼에서 전송된 사업자 정보 (사업자번호, 회사명, 개업일자)
     * @param redirectAttributes 리다이렉트 시 사용할 데이터
     * @param session 현재 세션
     * @return 사업자 등록 정보 페이지로 리다이렉트
     */
    @PostMapping("/signup") // JSP 폼의 action="/my/profile/signup/biz"와 일치하도록 @RequestMapping("/my/profile/biz") + @PostMapping("/signup")
    public String registerBizInfo(UsersBizIdVO usersBizIdVO, RedirectAttributes redirectAttributes, HttpSession session) {
        String userId = getLoggedInUserId();

        if (userId == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/login";
        }
        
        try {
            // usersBizIdVO 객체에 현재 로그인 사용자의 ID를 설정
            usersBizIdVO.setUserId(userId);
            
            // 서비스 레이어를 호출하여 DB에 사업자 정보를 저장/업데이트
            userService.insertOrUpdateBizInfo(usersBizIdVO);

            // 성공 메시지를 리다이렉트 페이지로 전달
            redirectAttributes.addFlashAttribute("successMessage", "사업자 정보가 성공적으로 등록/변경되었습니다.");
            
        } catch (Exception e) {
            log.error("사업자 정보 등록/변경 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("errorMessage", "사업자 정보 등록/변경 중 오류가 발생했습니다.");
        }

        // 처리가 끝난 후 사업자 정보 페이지로 돌아갑니다.
        return "redirect:/my/profile/biznum";
    }

    /**
     * 현재 로그인된 사용자의 ID를 가져오는 헬퍼 메서드
     * @return 로그인된 사용자 ID, 로그인되어 있지 않으면 null
     */
    private String getLoggedInUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getName())) {
            return authentication.getName();
        }
        return null;
    }
}
