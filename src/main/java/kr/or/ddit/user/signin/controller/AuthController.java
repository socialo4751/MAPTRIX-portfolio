package kr.or.ddit.user.signin.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.user.signin.mapper.UsersRefTokenMapper;
import kr.or.ddit.user.signin.vo.UsersRefTokenVO;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final TokenProvider tokenProvider;
    private final UsersRefTokenMapper usersRefTokenMapper;
    private final AuthenticationManager authenticationManager;

    public AuthController(TokenProvider tokenProvider,
                          UsersRefTokenMapper usersRefTokenMapper, AuthenticationManager authenticationManager) {
        this.tokenProvider = tokenProvider;
        this.usersRefTokenMapper = usersRefTokenMapper;
        this.authenticationManager = authenticationManager;
    }


    // (2) 기존 리프레시 토큰 갱신 메서드는 그대로 둡니다
    @PostMapping("/refresh")
    public ResponseEntity<Map<String, String>> refresh(@RequestBody Map<String, String> body) {
        String refreshToken = body.get("refreshToken");
        UsersRefTokenVO stored = usersRefTokenMapper.findByToken(refreshToken);
        if (stored == null || !tokenProvider.validate(refreshToken)) {
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("error", "Invalid or expired refresh token"));
        }
        Authentication auth = tokenProvider.getAuthentication(refreshToken);
        String newAccess = tokenProvider.createAccessToken(auth);
        return ResponseEntity.ok(Map.of("accessToken", newAccess));
    }
}

