package kr.or.ddit.user.signin.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.user.signin.mapper.UsersRefTokenMapper;
import kr.or.ddit.user.signin.service.UserService;
import kr.or.ddit.user.signin.vo.UserSocialVO;
import kr.or.ddit.user.signin.vo.UsersRefTokenVO;

@Controller
public class KakaoOauthController {

    // 본인의 카카오 REST API 키로 변경해야 합니다.
    private static final String REST_API_KEY = "efb4ae9d464b6b29c8624d3793022e6e";
    // 카카오 개발자 콘솔에 등록한 Redirect URI
    private static final String REDIRECT_URI = "http://localhost/oauth/kakao/callback";

    @Autowired private UserService userService;
    @Autowired private RestTemplate restTemplate;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private UserDetailsService userDetailsService;
    @Autowired private TokenProvider tokenProvider;
    @Autowired private UsersRefTokenMapper usersRefTokenMapper;

    /**
     * 카카오 로그인 동의 화면으로 사용자를 리다이렉트시킵니다.
     */
    @GetMapping("/oauth/kakao")
    public String redirectToKakao() throws Exception {
        String authorizeUrl = "https://kauth.kakao.com/oauth/authorize"
            + "?response_type=code"
            + "&client_id=" + REST_API_KEY
            + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8);
        return "redirect:" + authorizeUrl;
    }

    /**
     * 카카오로부터 인증 코드를 받아 최종 로그인 처리를 수행합니다.
     */
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(
        @RequestParam("code") String code,
        HttpServletResponse response
    ) throws Exception {

        // 1. 카카오 서버에 토큰 요청
        HttpHeaders tokenHeaders = new HttpHeaders();
        tokenHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String tokenBody = "grant_type=authorization_code"
            + "&client_id="    + REST_API_KEY
            + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, StandardCharsets.UTF_8)
            + "&code="         + code;
        HttpEntity<String> tokenReq = new HttpEntity<>(tokenBody, tokenHeaders);
        ResponseEntity<String> tokenRes = restTemplate.exchange(
            "https://kauth.kakao.com/oauth/token", HttpMethod.POST, tokenReq, String.class
        );
        JsonNode tokenNode = objectMapper.readTree(tokenRes.getBody());
        String kakaoAccessToken = tokenNode.get("access_token").asText();

        // 2. 발급받은 토큰으로 카카오 사용자 정보 조회 (카카오 고유 ID 가져오기)
        HttpHeaders profHeaders = new HttpHeaders();
        profHeaders.setBearerAuth(kakaoAccessToken);
        HttpEntity<Void> profReq = new HttpEntity<>(profHeaders);
        ResponseEntity<String> profRes = restTemplate.exchange(
            "https://kapi.kakao.com/v2/user/me", HttpMethod.GET, profReq, String.class
        );
        JsonNode profile = objectMapper.readTree(profRes.getBody());
        String kakaoId = profile.get("id").asText();

        // ✨ 3. (하드코딩) 소셜 정보와 미리 정해진 테스트 계정을 연결
        String testUserId = "kakao@test.com"; // DB에 미리 생성되어 있어야 하는 계정
        UserSocialVO social = userService.findSocial("KAKAO", kakaoId);

        // 만약 이 카카오 ID로 연결된 정보가 없다면, 우리 테스트 계정과 연결해줍니다.
        if (social == null) {
            social = new UserSocialVO();
            social.setUserId(testUserId);
            social.setProvider("KAKAO");
            social.setProviderUserId(kakaoId);
            social.setAccessToken(kakaoAccessToken);
            userService.insertSocial(social);
        } else {
            // 이미 연결 정보가 있다면 카카오 Access Token만 갱신
            userService.updateSocialToken("KAKAO", kakaoId, kakaoAccessToken);
        }

        // 4. 우리 시스템의 인증(Authentication) 객체 생성 (하드코딩된 ID 기준)
        UserDetails userDetails = userDetailsService.loadUserByUsername(testUserId);
        Authentication auth = new UsernamePasswordAuthenticationToken(
            userDetails, null, userDetails.getAuthorities()
        );

        // 5. JWT Access/Refresh 토큰 생성
        String accessToken  = tokenProvider.createAccessToken(auth);
        String refreshToken = tokenProvider.createRefreshToken(auth);

        // 6. Refresh Token DB 저장/업데이트
        usersRefTokenMapper.deleteByUserId(auth.getName());
        usersRefTokenMapper.insert(
            new UsersRefTokenVO(
                refreshToken,
                auth.getName(),
                new Date(System.currentTimeMillis() + tokenProvider.getRefreshExpire())
            )
        );

        // 7. HttpOnly 쿠키에 토큰 추가
        Cookie accessTokenCookie = new Cookie("accessToken", accessToken);
        accessTokenCookie.setHttpOnly(true);
        accessTokenCookie.setPath("/");
        response.addCookie(accessTokenCookie);

        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setPath("/");
        response.addCookie(refreshTokenCookie);

        // 8. 모든 처리가 끝난 후 홈으로 리다이렉트
        return "redirect:/";
    }
}