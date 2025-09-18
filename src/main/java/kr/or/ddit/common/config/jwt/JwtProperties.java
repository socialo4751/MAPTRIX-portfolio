package kr.or.ddit.common.config.jwt;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import lombok.Data;

// makeToken과 관련된 io.jsonwebtoken.* import는 제거 가능
// import io.jsonwebtoken.Header;
// import io.jsonwebtoken.Jwts;
// import io.jsonwebtoken.SignatureAlgorithm;
// import io.jsonwebtoken.security.Keys;
// import kr.or.ddit.vo.UsersVO;
// import java.security.Key;
// import java.util.Date;


@Data
@Component
@ConfigurationProperties("jwt")
public class JwtProperties {

    private String issuer;
    private String secretKey; // String 타입 유지

    // makeToken 메서드 제거
    // signingKey 필드 제거
    // setSecretKey 오버라이딩 제거
}