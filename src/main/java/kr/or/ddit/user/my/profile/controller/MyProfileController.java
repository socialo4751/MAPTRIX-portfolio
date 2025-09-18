package kr.or.ddit.user.my.profile.controller;
import org.springframework.beans.factory.annotation.Autowired;
// Spring Security 관련 import
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.UserService;
// Lombok 라이브러리
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/profile")
public class MyProfileController {
	
	@Autowired
    private UserService userService;
	
	// 회원정보조회
	@GetMapping
    public String myPageMain(Model model, Authentication authentication) {

        // USERS 테이블의 USER_ID에 매핑되는 변수명 사용 (UsersVO의 userId와 일치)
        String userId = authentication.getName();

        // 1. UserService를 사용하여 사용자 정보를 데이터베이스에서 조회합니다.
        // UserService의 getMemberById 메서드는 userId를 인자로 받아 UsersVO 객체를 반환해야 합니다.
        UsersVO usersVO = userService.findByUserId(userId); // 메서드명은 getUserById가 더 적절할 수 있습니다.

        // 2. 조회된 사용자 정보가 없는 경우 예외 처리
        if (usersVO == null) {
            log.error("사용자 ID [{}] 에 해당하는 정보를 찾을 수 없습니다. 데이터베이스 또는 UserService 구현을 확인해주세요.", userId);
            model.addAttribute("errorMessage", "사용자 정보를 불러오는 데 실패했습니다.");
            return "error/errorPage"; // 적절한 에러 페이지 경로로 변경하세요.
        }

        // 4. 조회된 사용자 정보를 Model에 담아 JSP로 전달합니다.
        // JSP에서는 ${user.속성명} 형태로 이 데이터에 접근할 수 있습니다. (member 대신 user 사용)
        model.addAttribute("user", usersVO); // UsersVO 객체를 "user"라는 이름으로 전달

        return "my/profile/profile";
    }
	
	// 회원정보 수정
	// 회원정보 수정 페이지
	@GetMapping("/form")
	public String editProfile(Model model, Authentication authentication) {
	    // 현재 로그인된 사용자 ID 가져오기
	    String userId = authentication.getName();

	    UsersVO usersVO = userService.findByUserId(userId);

	    if (usersVO == null) {
	        log.error("사용자 ID [{}] 에 해당하는 회원 정보를 찾을 수 없습니다.", userId);
	        model.addAttribute("errorMessage", "회원 정보를 불러올 수 없습니다.");
	        return "error/errorPage";
	    }

	    model.addAttribute("user", usersVO);
	    return "my/profile/form";  // → /WEB-INF/views/my/profile/form.jsp 로 forward
	}

	
	// 회원정보 수정
	@PostMapping("/mod")
    public String updateProfile(@ModelAttribute UsersVO user, Model model, RedirectAttributes ra) {
        log.info("updateProfile() 실행 - 회원정보 업데이트 요청: {}", user.getUserId());
        try {
            // ⭐ 실제로 UserService의 updateUser 메서드를 호출하여 DB 업데이트 수행 ⭐
            int result = userService.updateUserInfo(user); // UserServiceImpl에 정의된 메서드 호출

            if (result > 0) {
                ra.addFlashAttribute("successMessage", "회원 정보가 성공적으로 업데이트되었습니다.");
            } else {
                ra.addFlashAttribute("errorMessage", "회원 정보 업데이트에 실패했습니다. (영향받은 행 없음)");
            }
            return "redirect:/my/profile";
        } catch (Exception e) {
            log.error("회원 정보 업데이트 중 오류 발생: {}", e.getMessage());
            ra.addFlashAttribute("errorMessage", "회원 정보 업데이트에 실패했습니다. 다시 시도해주세요.");
        }
        return "redirect:/my/profile";
    }
		
	
	// 회원탈퇴
	@GetMapping("/del")
	public String DeleteAcc() {
		return "my/profile/deleteAcc";
	}
	
	// 회원탈퇴
	@PostMapping("/delprocess")
    public String processDeleteAcc(@RequestParam("password") String password,
                                   @RequestParam(value = "reason", required = false) String reason, // 선택 사항
                                   @RequestParam(value = "reasonDetail", required = false) String reasonDetail, // 선택 사항
                                   HttpServletRequest request, HttpServletResponse response,
                                   RedirectAttributes ra) {

        // 현재 로그인된 사용자의 USER_ID 가져오기
        String userId = null;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            userId = ((UserDetails) principal).getUsername(); // UserDetails의 username은 보통 userId와 매핑됨
        } else {
            // JWT 토큰만 사용하는 경우 직접 userId를 파싱해야 할 수도 있습니다.
            // 이 부분은 실제 JWT 구현 방식에 따라 달라질 수 있습니다.
            // 예를 들어, JWTAuthFilter에서 SecurityContext에 userId를 저장했다면,
            // (String)SecurityContextHolder.getContext().getAuthentication().getDetails() 등으로 접근할 수도 있습니다.
            // 현재 UserDetails를 가정하고 진행합니다.
            log.error("로그인된 사용자 정보를 UserDetails에서 가져올 수 없습니다. principal 타입: {}", principal.getClass().getName());
            ra.addFlashAttribute("errorMessage", "로그인 정보가 유효하지 않습니다. 다시 로그인해주세요.");
            return "redirect:/login"; // 또는 메인 페이지
        }

        if (userId == null) {
            log.warn("회원 탈퇴 요청 - 로그인된 사용자 ID를 찾을 수 없음.");
            ra.addFlashAttribute("errorMessage", "로그인 정보가 유효하지 않습니다. 다시 로그인해주세요.");
            return "redirect:/login";
        }

        log.info("회원 탈퇴 시도: userId={}", userId);
        log.debug("탈퇴 사유: {}, 상세: {}", reason, reasonDetail); // 탈퇴 사유 로깅

        try {
        	boolean isDeleted = userService.withdrawUser(userId, password, reason, reasonDetail);

            if (isDeleted) {
                // 탈퇴 성공 시, 세션 무효화 및 JWT 쿠키 삭제 (필요시)
                request.getSession().invalidate(); // 세션 무효화 (JSESSIONID 제거)
                
                // JWT를 쿠키로 관리한다면, 쿠키도 삭제해야 합니다.
                deleteCookie(response, "accessToken");
                deleteCookie(response, "refreshToken"); // refreshToken도 함께 삭제

                ra.addFlashAttribute("successMessage", "회원 탈퇴가 성공적으로 처리되었습니다. 서비스를 이용해 주셔서 감사합니다.");
                return "redirect:/"; // 메인 페이지나 로그인 페이지로 리다이렉트
            } else {
                ra.addFlashAttribute("errorMessage", "비밀번호가 일치하지 않거나 탈퇴 처리 중 오류가 발생했습니다. 다시 확인해주세요.");
                return "redirect:/my/profile/del"; // 탈퇴 페이지로 돌아가기
            }
        } catch (Exception e) {
            log.error("회원 탈퇴 처리 중 예상치 못한 오류 발생: {}", e.getMessage(), e);
            ra.addFlashAttribute("errorMessage", "회원 탈퇴 처리 중 시스템 오류가 발생했습니다. 다시 시도해주세요.");
            return "redirect:/my/profile/del";
        }
    }

    // JWT 쿠키 삭제 유틸리티 메서드
    private void deleteCookie(HttpServletResponse response, String cookieName) {
        Cookie cookie = new Cookie(cookieName, null);
        cookie.setMaxAge(0); // 쿠키 즉시 만료
        cookie.setPath("/"); // 모든 경로에서 삭제
        cookie.setHttpOnly(true); // HttpOnly 설정
        // cookie.setSecure(true); // HTTPS 환경에서만 (배포 환경에서는 true 권장)
        response.addCookie(cookie);
    }
	
}


