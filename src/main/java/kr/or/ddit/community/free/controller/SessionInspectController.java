package kr.or.ddit.community.free.controller;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionInspectController {

    private static final Logger log = LoggerFactory.getLogger(SessionInspectController.class);

    @GetMapping("/inspect-session")
    @ResponseBody
    public String inspectSession(HttpSession session) {
        log.info("--- [세션 상태 검사 컨트롤러 실행됨] ---");
        // HttpSession에서 Spring Security의 인증 정보를 담고 있는 객체를 직접 꺼내봅니다.
        Object securityContext = session.getAttribute("SPRING_SECURITY_CONTEXT");
        
        if (securityContext != null) {
            log.info("[세션 검사 결과] SUCCESS: 세션에서 SPRING_SECURITY_CONTEXT를 찾았습니다!");
            log.info("[세션 내용] {}", securityContext.toString());
            return "SUCCESS: SPRING_SECURITY_CONTEXT found in HttpSession.";
        } else {
            log.warn("[세션 검사 결과] ERROR: 세션에 SPRING_SECURITY_CONTEXT가 없습니다! WebSocket이 사용자를 인식할 수 없는 원인입니다.");
            return "ERROR: SPRING_SECURITY_CONTEXT was NOT found in HttpSession. This is why WebSocket cannot identify the user.";
        }
    }
}
