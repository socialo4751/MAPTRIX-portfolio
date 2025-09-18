package kr.or.ddit.user.signin.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j // 로깅을 사용한다면 유지
@Controller
public class UsersController {

    /**
     * 로그인 페이지를 보여주는 요청을 처리합니다.
     * 만약 사용자가 이미 인증(로그인)된 상태라면, 홈("/")으로 리다이렉트시킵니다.
     */
    @GetMapping("/login")
    public String loginPage(Authentication authentication) {
             
        
        // Spring Security가 제공하는 Authentication 객체를 확인하여 인증 여부를 판단
        if (authentication != null && authentication.isAuthenticated()) {
            log.info(">>> 이미 인증된 사용자이므로 홈으로 리다이렉트합니다.");
            return "redirect:/";
        }
        
        // 로그인되지 않은 사용자일 경우, 로그인 페이지를 보여줌
        return "login"; 
    }

    // @RestController를 사용하면 메서드의 반환값이 자동으로 JSON으로 변환.
    @RestController
    @RequestMapping("/api/user") // API 경로를 명확히 분리
    public class UserApiController {

    	
        @GetMapping("/me")
        public ResponseEntity<UsersVO> getMyInfo(@AuthenticationPrincipal CustomUser customUser) {
            // @AuthenticationPrincipal 어노테이션이 SecurityContextHolder에서
            // 현재 사용자의 Principal(CustomUser)을 직접 가져와 줍니다.
        	
            if (customUser == null) {
                // 로그인하지 않은 사용자가 이 API를 호출한 경우
                return ResponseEntity.noContent().build(); // 내용 없음(204) 응답
            }

            // CustomUser 객체에서 실제 사용자 정보가 담긴 UsersVO를 꺼냅니다.
            UsersVO userInfo = customUser.getUsersVO();

            // UsersVO 객체를 JSON으로 변환하여 응답합니다.
            // (주의: UsersVO의 password 필드는 JSON으로 변환되지 않도록 @JsonIgnore 처리하는 것이 좋습니다)
            return ResponseEntity.ok(userInfo);
        }
        
        
        
        @PostMapping("/logout")
        public ResponseEntity<Void> logout(HttpServletRequest request, HttpServletResponse response) {
            // 세션 무효화
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // 쿠키 제거 (선택)
            Cookie cookie = new Cookie("JSESSIONID", null);
            Cookie cookie2 = new Cookie("accessToken", null);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(0); // 쿠키 즉시 삭제
            cookie2.setPath("/");
            cookie2.setHttpOnly(true);
            cookie2.setMaxAge(0); // 쿠키 즉시 삭제
            response.addCookie(cookie);
            response.addCookie(cookie2);
            
            log.info("logout");
            log.info("logout");
            log.info("logout");
            log.info("logout");


            return ResponseEntity.ok().build();
        }
       
    }
}