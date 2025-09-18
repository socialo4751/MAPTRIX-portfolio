package kr.or.ddit.user.signin.vo;

import lombok.Data;

/**
 * 소셜 로그인 사용자 정보를 담기 위한 VO 클래스
 */
@Data
public class UserSocialVO {
    private String providerUserId;
    private String provider;
    private String userId;
    private String accessToken;
    private String refreshToken;
}