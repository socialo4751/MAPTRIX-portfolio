package kr.or.ddit.common.config;

import java.io.IOException;

import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.stereotype.Component;

import kr.or.ddit.common.config.jwt.TokenProvider; // ★ TokenProvider 임포트
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

    private final CacheManager cacheManager;
    private final TokenProvider tokenProvider; // ★ TokenProvider 주입

    // ★ 생성자 수정
    public CustomLogoutSuccessHandler(CacheManager cacheManager, TokenProvider tokenProvider) {
        this.cacheManager = cacheManager;
        this.tokenProvider = tokenProvider;
    }

    @Override
    public void onLogoutSuccess(HttpServletRequest request,
                                HttpServletResponse response,
                                Authentication authentication) throws IOException, ServletException {
        
        // ★★★★★★★★★★★★ [핵심 수정 로직] ★★★★★★★★★★★★
        String accessToken = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("accessToken".equals(cookie.getName())) {
                    accessToken = cookie.getValue();
                    break;
                }
            }
        }

        // 쿠키에서 가져온 토큰으로 사용자 ID를 추출하여 캐시 삭제
        if (accessToken != null) {
            try {
                // 토큰에서 직접 사용자 이름(ID)을 얻어옴
                String username = tokenProvider.getAuthentication(accessToken).getName();
                Cache userDetailsCache = cacheManager.getCache("userDetails");
                if (userDetailsCache != null) {
                    userDetailsCache.evict(username);
                    log.info("User cache cleared for '{}' on logout.", username);
                }
            } catch (Exception e) {
                log.error("Error while clearing user cache from token on logout", e);
            }
        }
        // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

        // 기존 쿠키 삭제 로직은 그대로 유지
        Cookie accessTokenCookie = new Cookie("accessToken", null);
        accessTokenCookie.setMaxAge(0);
        accessTokenCookie.setPath("/");
        response.addCookie(accessTokenCookie);

        Cookie refreshTokenCookie = new Cookie("refreshToken", null);
        refreshTokenCookie.setMaxAge(0);
        refreshTokenCookie.setPath("/");
        response.addCookie(refreshTokenCookie);

        response.sendRedirect("/login?logout");
    }
}