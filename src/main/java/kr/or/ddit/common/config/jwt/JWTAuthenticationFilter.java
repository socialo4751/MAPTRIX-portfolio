package kr.or.ddit.common.config.jwt;

import java.io.IOException;
import java.util.Date;
import java.util.Map;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.InternalAuthenticationServiceException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.mapper.UsersRefTokenMapper;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import kr.or.ddit.user.signin.vo.UsersRefTokenVO;

public class JWTAuthenticationFilter extends UsernamePasswordAuthenticationFilter {
    private final TokenProvider tokenProvider;
    private final UsersRefTokenMapper usersRefTokenMapper;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public JWTAuthenticationFilter(AuthenticationManager authManager,
                                   TokenProvider tokenProvider,
                                   UsersRefTokenMapper usersRefTokenMapper) {
        super(authManager); // super() 생성자 호출
        this.tokenProvider = tokenProvider;
        this.usersRefTokenMapper = usersRefTokenMapper;
        setFilterProcessesUrl("/auth/login"); // 처리할 URL 지정
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest req,
                                                HttpServletResponse res)
        throws AuthenticationException {
        // ✨ 이 부분을 JSON 읽는 로직으로 완전히 교체합니다. ✨
        try {
            // JSON 바디에서 email/password 꺼내기
            Map<String, String> creds = objectMapper
                .readValue(req.getInputStream(), Map.class);

            UsernamePasswordAuthenticationToken authToken =
                new UsernamePasswordAuthenticationToken(
                    creds.get("userId"),
                    creds.get("password"),
                    null // authorities
                );


            // ✨ this.authManager.authenticate(authToken) 대신
            // 부모 클래스의 getAuthenticationManager()를 사용합니다. ✨
            return getAuthenticationManager().authenticate(authToken);
        } catch (IOException e) {
            // JSON 파싱 실패 시 예외 처리
            throw new RuntimeException("Error reading authentication credentials from request", e);
        }
    }

    @Override
    protected void successfulAuthentication(HttpServletRequest req,
                                            HttpServletResponse res,
                                            FilterChain chain,
                                            Authentication auth) throws IOException {
        // ... (이전 코드와 동일)
        // 1. 토큰 생성
        String accessToken  = tokenProvider.createAccessToken(auth);
        String refreshToken = tokenProvider.createRefreshToken(auth);
        
        //사용자 정보 가져오기
        CustomUser customUser = (CustomUser) auth.getPrincipal();
        UsersVO user = customUser.getUsersVO();        
        
        // 2. Refresh Token을 DB에 저장 (기존 로직 유지)
        usersRefTokenMapper.deleteByUserId(auth.getName()); // 기존 토큰 삭제(선택)
        usersRefTokenMapper.insert(
            new UsersRefTokenVO(
                refreshToken,
                auth.getName(),
                new Date(System.currentTimeMillis() + tokenProvider.getRefreshExpire())
            )
        );

        // 3. Access Token을 HTTP Only 쿠키로 설정
        // ★★★★★ [수정] Access Token 쿠키 수명을 getAccessExpire()로 설정 ★★★★★
        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        accessTokenCookie.setHttpOnly(true);
        accessTokenCookie.setPath("/");
        accessTokenCookie.setMaxAge((int) (tokenProvider.getAccessExpire() / 1000)); // ★ 버그 수정
        res.addCookie(accessTokenCookie);

        // 4. Refresh Token을 HTTP Only 쿠키로 설정
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setPath("/");
        refreshTokenCookie.setMaxAge((int) (tokenProvider.getRefreshExpire() / 1000));
        res.addCookie(refreshTokenCookie);

        // 5. 클라이언트에게 응답
        res.setContentType("application/json;charset=UTF-8");
        res.getWriter().write(
            objectMapper.writeValueAsString(
                Map.of("message", "Login successful, tokens issued in cookies"
                		//CustomUser customUser = (CustomUser) auth.getPrincipal();
                		//UsersVO user = customUser.getUsersVO();        
                		//user정보중 필요한 것을 customUser에서 가져와서 전달
                		,"user", Map.of(
                            "userId", user.getUserId(),
                            "name", user.getName()
                        )
                )
           )
        );
    }

    @Override
    protected void unsuccessfulAuthentication(HttpServletRequest request,
                                              HttpServletResponse response,
                                              AuthenticationException failed) throws IOException, jakarta.servlet.ServletException {
        // 기존과 동일
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json;charset=UTF-8");

        String errorMessage;
        
        // [수정된 로직]
        // InternalAuthenticationServiceException 안에 실제 원인(DisabledException)이 담겨있습니다.
        if (failed instanceof InternalAuthenticationServiceException) {
            // 이 예외의 메시지가 바로 "탈퇴한 회원입니다." 이므로 메시지를 그대로 사용합니다.
            errorMessage = failed.getMessage();
        } else if (failed instanceof BadCredentialsException) {
            errorMessage = "아이디 또는 비밀번호가 일치하지 않습니다.";
        } else if (failed instanceof UsernameNotFoundException) {
            errorMessage = "존재하지 않는 계정입니다.";
        } else {
            // 기타 다른 모든 예외 처리
            errorMessage = "로그인에 실패했습니다. 관리자에게 문의하세요.";
        }

        response.getWriter().write(objectMapper.writeValueAsString(
            Map.of("error", "Authentication Failed", "message", errorMessage)
        ));
    }
}