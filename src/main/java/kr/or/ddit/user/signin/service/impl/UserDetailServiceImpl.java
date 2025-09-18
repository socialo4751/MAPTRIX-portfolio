package kr.or.ddit.user.signin.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.mapper.UsersMapper;
import lombok.extern.slf4j.Slf4j;


//로그인 시도시에만 작동하는게 맞다.

//UserDetailServiceImpl를 통해서 => 정확히 loadUserByUsername가! 

// => 로그인 시도할 때 
//(메소드안에 있음) this.usersMapper.selectByUserId(userId); => DB에서 사용자 정보를 조회하고 
// "DB에 일치하는 사용자가 있습니다!" 혹은 "없습니다!!"

// 중간 생략할게요...

// 있으면 Authentication 객체 생성!

@Slf4j
@Service
public class UserDetailServiceImpl implements UserDetailsService {

    @Autowired
    UsersMapper usersMapper;

    @Cacheable(cacheNames = "userDetails", key = "#p0", unless = "#result == null")
    @Override
    public UserDetails loadUserByUsername(String userId) throws UsernameNotFoundException {

    	
    	log.info(">>> DB에서 사용자 정보를 찾습니다. (캐시 로직 실행됨) / 사용자: {}", userId);
        // 1. Mapper를 통해 사용자 정보를 조회합니다.
        UsersVO usersVO = this.usersMapper.selectByUserId(userId);

        // 2. 사용자가 아예 존재하지 않을 경우, 예외를 발생시킵니다.
        if (usersVO == null) {
            throw new UsernameNotFoundException(userId + "는 존재하지 않는 아이디입니다.");
        }

        // 3. [추가된 로직] 탈퇴한 회원인지 확인합니다.
        if (usersVO.getWithdrawnAt() != null) {
            // 탈퇴한 회원이면 DisabledException 예외를 발생시킵니다.
            throw new DisabledException("탈퇴한 회원입니다.");
        }
        
        return usersVO == null?null : new CustomUser(usersVO);
    }
}
