package kr.or.ddit.user.signin.controller;

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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.user.signin.mapper.UsersRefTokenMapper;
import kr.or.ddit.user.signin.service.UserService;
import kr.or.ddit.user.signin.vo.UserSocialVO;
import kr.or.ddit.user.signin.vo.UsersRefTokenVO;

@Controller
public class NaverOauthController {

    private static final String NAVER_CLIENT_ID = "osgXD67hSi8oHmLUm6fq";
    private static final String NAVER_CLIENT_SECRET = "NOzw85_kbB";
    private static final String REDIRECT_URI = "http://localhost/oauth/naver/callback";

    @Autowired private UserService userService;
    @Autowired private RestTemplate restTemplate;
    @Autowired private ObjectMapper objectMapper;
    @Autowired private UserDetailsService userDetailsService;
    @Autowired private TokenProvider tokenProvider;
    @Autowired private UsersRefTokenMapper usersRefTokenMapper;

    /**
     * 네이버 로그인 동의 화면으로 사용자를 리다이렉트시킵니다.
     */
    @GetMapping("/oauth/naver")
    public String redirectToNaver() {
        String state = "xyz"; // CSRF 공격 방지를 위한 상태 토큰
        String authorizeUrl = "https://nid.naver.com/oauth2.0/authorize"
            + "?response_type=code"
            + "&client_id=" + NAVER_CLIENT_ID
            + "&redirect_uri=" + REDIRECT_URI
            + "&state=" + state;
        return "redirect:" + authorizeUrl;
    }

    /**
     * 네이버로부터 인증 코드를 받아 최종 로그인 처리를 수행합니다.
     */
    @GetMapping("/oauth/naver/callback")
    public String naverCallback(
        @RequestParam String code,
        @RequestParam String state,
        HttpServletResponse response
    ) throws Exception {

        // 1. 네이버 서버에 토큰 요청
        HttpHeaders tokenHeaders = new HttpHeaders();
        tokenHeaders.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> tokenBody = new LinkedMultiValueMap<>();
        tokenBody.add("grant_type", "authorization_code");
        tokenBody.add("client_id", NAVER_CLIENT_ID);
        tokenBody.add("client_secret", NAVER_CLIENT_SECRET);
        tokenBody.add("redirect_uri", REDIRECT_URI);
        tokenBody.add("code", code);
        tokenBody.add("state", state);

        ResponseEntity<String> tokenRes = restTemplate.postForEntity(
            "https://nid.naver.com/oauth2.0/token",
            new HttpEntity<>(tokenBody, tokenHeaders),
            String.class
        );
        String naverAccessToken = objectMapper.readTree(tokenRes.getBody()).get("access_token").asText();

        // 2. 발급받은 토큰으로 네이버 사용자 정보 조회
        HttpHeaders profHeaders = new HttpHeaders();
        profHeaders.setBearerAuth(naverAccessToken);
        HttpEntity<Void> profReq = new HttpEntity<>(profHeaders);
        ResponseEntity<String> profRes = restTemplate.exchange(
            "https://openapi.naver.com/v1/nid/me", HttpMethod.GET, profReq, String.class
        );
        String naverId = objectMapper.readTree(profRes.getBody()).get("response").get("id").asText();

        // 3. (하드코딩) 소셜 정보와 미리 정해진 테스트 계정을 연결
        String testUserId = "naver@test.com"; // DB에 미리 생성되어 있어야 하는 계정
        UserSocialVO social = userService.findSocial("NAVER", naverId);

        if (social == null) {
            social = new UserSocialVO();
            social.setUserId(testUserId);
            social.setProvider("NAVER");
            social.setProviderUserId(naverId);
            social.setAccessToken(naverAccessToken);
            userService.insertSocial(social);
        } else {
            userService.updateSocialToken("NAVER", naverId, naverAccessToken);
        }

        // 4. 우리 시스템의 인증(Authentication) 객체 생성
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
            new UsersRefTokenVO(refreshToken, auth.getName(), new Date(System.currentTimeMillis() + tokenProvider.getRefreshExpire()))
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