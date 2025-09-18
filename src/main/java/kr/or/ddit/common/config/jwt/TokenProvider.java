package kr.or.ddit.common.config.jwt; // TokenProvider의 실제 패키지

import java.security.Key;
import java.time.Duration;
import java.util.Date;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import kr.or.ddit.user.signin.service.impl.UserDetailServiceImpl;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TokenProvider {
    private final Key key;
    private final JwtProperties jwtProperties;

    private final long accessExpire = Duration.ofHours(1).toMillis();      // 1시간
    private final long refreshExpire = Duration.ofDays(14).toMillis();     // 14일
    private final UserDetailServiceImpl userDetailService; // 의존성 추가

    public TokenProvider(JwtProperties jwtProperties, UserDetailServiceImpl userDetailService) {
        this.jwtProperties = jwtProperties;
        this.userDetailService = userDetailService;
        this.key = Keys.hmacShaKeyFor(jwtProperties.getSecretKey().getBytes());
    }

    public String createAccessToken(Authentication auth) {
        // 💥 기존 코드 (에러 발생 부분)
        // UsersVO usersVO = (UsersVO) auth.getPrincipal();

        // ✨ 수정 코드 ✨
        // Principal은 CustomUser 타입이므로, CustomUser로 변환합니다.
        CustomUser customUser = (CustomUser) auth.getPrincipal();

        // 디버깅용 로그도 CustomUser를 사용하도록 변경
        System.out.println("DEBUG TokenProvider: Creating Access Token for user: " + customUser.getUsername());
        System.out.println("DEBUG TokenProvider: User Authorities: " + customUser.getAuthorities());

        return Jwts.builder()
            // subject와 email은 customUser.getUsername()으로 얻을 수 있습니다. (username이 이메일이므로)
            .setSubject(customUser.getUsername())
            .claim("roles", customUser.getAuthorities())
            .claim("userId", customUser.getUsername())

            // "name" 클레임은 CustomUser가 가지고 있는 사용자 이름 정보를 사용해야 합니다.
            // CustomUser 클래스에 getName()과 같은 메서드가 있다고 가정합니다.
            // 만약 UsersVO를 감싸고 있다면 customUser.getUsersVO().getName() 형태일 수 있습니다.
            // 사용하시는 CustomUser 클래스 구조에 맞게 이 부분을 수정해주세요.

            .setIssuer(jwtProperties.getIssuer())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + accessExpire))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact();
    }

    public String createRefreshToken(Authentication auth) {
        System.out.println("DEBUG TokenProvider: Creating Refresh Token for user: " + auth.getName());
        return Jwts.builder()
            .setSubject(auth.getName())
            .setIssuer(jwtProperties.getIssuer())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + refreshExpire))
            .signWith(key, SignatureAlgorithm.HS256)
            .compact();
    }

    private Claims getClaims(String token) {
        try {
            return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();
        } catch (JwtException e) {
            System.err.println("ERROR TokenProvider: Failed to parse JWT claims: " + e.getMessage());
            throw e; // 예외를 다시 던져서 validate()에서 잡히도록 합니다.
        }
    }

    // getAuthentication 메서드 수정
    public Authentication getAuthentication(String token) {
        Claims claims = getClaims(token);
        String userId = claims.getSubject();

        // DB에서 userId로 완전한 CustomUser 정보를 다시 조회
        UserDetails userDetails = userDetailService.loadUserByUsername(userId);

        // 완전한 userDetails 객체(CustomUser)로 인증 객체 생성
        return new UsernamePasswordAuthenticationToken(userDetails, token, userDetails.getAuthorities());
    }

    public boolean validate(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (io.jsonwebtoken.ExpiredJwtException e) {
            // 만료 토큰은 클레임 접근 가능
            Claims c = e.getClaims();
            log.debug("Cookie가 담고 있는 만료된 Access token(최신기준): sub={}, exp={}", c.getSubject(), c.getExpiration());
            return false;
        } catch (io.jsonwebtoken.JwtException | IllegalArgumentException e) {
            log.debug("유효하지 않은 Access token: {}", e.toString());
            return false;
        }
    }
    
    public long getAccessExpire() {
        return accessExpire;
    }

    public long getRefreshExpire() {
        return refreshExpire;
    }
}