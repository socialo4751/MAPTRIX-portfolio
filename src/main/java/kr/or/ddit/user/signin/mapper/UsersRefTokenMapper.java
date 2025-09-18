package kr.or.ddit.user.signin.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.user.signin.vo.UsersRefTokenVO;

@Mapper
public interface UsersRefTokenMapper {
    // ← 여기에 VO 파라미터를 받도록 시그니처를 바꿔주세요
    int insert(UsersRefTokenVO refreshToken);

    UsersRefTokenVO findByToken(String token);
    int deleteByToken(String token);
    int deleteByUserId(String userId);
}