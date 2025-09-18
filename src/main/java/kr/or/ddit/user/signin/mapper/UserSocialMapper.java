package kr.or.ddit.user.signin.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.user.signin.vo.UserSocialVO;

@Mapper
public interface UserSocialMapper {
    UserSocialVO selectByProviderAndProviderUserId(String provider, String providerUserId);

    void insertSocial(UserSocialVO social);

    void updateAccessToken(String provider, String providerUserId, String accessToken);
}
