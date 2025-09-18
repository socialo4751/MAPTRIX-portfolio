package kr.or.ddit.user.signin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.user.UsersAuthVO;

@Mapper
public interface UsersAuthMapper {
    // VO.email로 권한 리스트 조회
    List<UsersAuthVO> selectAuthsByUserId(UsersAuthVO userAuth);




}