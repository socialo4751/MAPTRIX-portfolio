package kr.or.ddit.common.config.jwt;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.filter.OncePerRequestFilter;

import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JWTAuthorizationFilter extends OncePerRequestFilter {
    private final TokenProvider tokenProvider;
    
    // SecurityContext를 세션에 저장하기 위한 Repository 객체 추가
    private final SecurityContextRepository securityContextRepository = 
        new HttpSessionSecurityContextRepository();

    public JWTAuthorizationFilter(TokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req,
                                    HttpServletResponse res,
                                    FilterChain chain)
        throws IOException, ServletException {

        String path = req.getRequestURI();
        if (path.startsWith("/ws/")) { // 웹소켓 경로만 건너뛰도록 남겨둡니다.
            log.debug("JWT filter skipped for path: {}", path);
            chain.doFilter(req, res);
            return;
        }

        String accessToken = null;
        Cookie[] cookies = req.getCookies();

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("accessToken".equals(cookie.getName())) {
                    accessToken = cookie.getValue();
                }
            }
        }

        if (accessToken != null) {
            try {
                // 1. 토큰 검증 및 인증 객체 생성을 한 번에 시도
                Authentication auth = tokenProvider.getAuthentication(accessToken);

                // 2. 성공 시: SecurityContext에 인증 정보 저장 (기존 로직)
                log.debug("Access Token is VALID. Setting authentication for user '{}'.", auth.getName());
                SecurityContext context = SecurityContextHolder.createEmptyContext();
                context.setAuthentication(auth);
                SecurityContextHolder.setContext(context);
                securityContextRepository.saveContext(context, req, res);

            } catch (ExpiredJwtException e) {
                // 3. 만료된 경우: 쿠키 삭제 후 익명으로 통과
                log.debug("토큰이 만료되었습니다. 쿠키 삭제 후 익명으로 진행 합니다.");
                Cookie cookie = new Cookie("accessToken", null);
                cookie.setMaxAge(0);
                cookie.setPath("/");
                res.addCookie(cookie);
                
            } catch (JwtException | IllegalArgumentException e) {
                // 4. 그 외 유효하지 않은 토큰(서명오류, 형식오류 등): 에러 로그만 남기고 익명으로 통과
                log.error("Invalid JWT received: {}", e.getMessage());
            }
        } else {
            log.debug("No accessToken cookie found.");
        }

        chain.doFilter(req, res);
    }
}