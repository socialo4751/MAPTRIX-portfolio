package kr.or.ddit.common.config;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) 
        throws IOException, ServletException {
        
        // 사용자가 원래 요청했던 URI
        String originalRequestUri = request.getRequestURI();
        
        // 쿼리 스트링이 있다면 그것까지 포함
        String queryString = request.getQueryString();
        if (queryString != null) {
            originalRequestUri += "?" + queryString;
        }

        // 로그인 페이지로 리다이렉트하되, 원래 가려던 'redirect' 파라미터를 추가
        // URL 인코딩을 통해 안전하게 파라미터를 전달
        String redirectUrl = "/login?redirect=" + URLEncoder.encode(originalRequestUri, StandardCharsets.UTF_8.toString());
        
        response.sendRedirect(redirectUrl);
    }
}