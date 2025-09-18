package kr.or.ddit.user.signup.step;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SignUpStepInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {

        String requestURI = req.getRequestURI();
        
        // ▼▼▼▼▼ [해결책] 이 코드를 최상단에 추가하세요 ▼▼▼▼▼
        // 정적 리소스(css, js, images 등)에 대한 요청일 경우,
        // 인터셉터의 로직을 실행하지 않고 즉시 통과(true)시킵니다.
        if (requestURI.contains("/css/") || requestURI.contains("/js/") || requestURI.contains("/images/")) {
            return true;
        }
        // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
        
        
        
        HttpSession session = req.getSession();

        // 현재 요청이 회원가입 절차의 일부인지 확인
        boolean isSignUpProcess = requestURI.startsWith(req.getContextPath() + "/sign-up/");

        // 세션에 저장된 단계 정보 가져오기
        SignUpStep currentStep = (SignUpStep) session.getAttribute("SIGNUP_STEP");

        // ==========================================================
        // ▼▼▼▼▼ 핵심 로직: 경우에 따라 다른 처리 ▼▼▼▼▼
        // ==========================================================

        if (isSignUpProcess) {
            // === [역할 1] 회원가입 페이지에 머물러 있을 때: 단계 검사 (기존 로직) ===
            if (currentStep == null) currentStep = SignUpStep.NONE;

            log.info("회원가입 단계 검사 >> 요청 URI: {}, 현재 단계: {}", requestURI, currentStep);

            if (requestURI.endsWith("/form") && currentStep.ordinal() < SignUpStep.AGREE.ordinal()) {
                res.sendRedirect(req.getContextPath() + "/sign-up/agree");
                return false;
            }
            if (requestURI.endsWith("/complete") && currentStep.ordinal() < SignUpStep.FORM.ordinal()) {
                res.sendRedirect(req.getContextPath() + "/sign-up/agree");
                return false;
            }
            if (requestURI.endsWith("/biz") && currentStep.ordinal() < SignUpStep.COMPLETE.ordinal()) {
                res.sendRedirect(req.getContextPath() + "/sign-up/agree");
                return false;
            }
            // 그 외 /skipBiz, /agree 등은 통과

        } else {
            // === [역할 2] 회원가입 페이지를 벗어났을 때: 세션 정리 (새로운 로직) ===
            if (currentStep != null) {
                log.info("회원가입 절차 이탈 감지! URI: {}", requestURI);
                log.info("세션의 회원가입 데이터를 정리합니다. (SIGNUP_STEP, loginUser)");
                session.removeAttribute("SIGNUP_STEP");
                session.removeAttribute("loginUser");
            }
        }

        return true; // 모든 검사를 통과하면 요청 계속 진행
    }
}