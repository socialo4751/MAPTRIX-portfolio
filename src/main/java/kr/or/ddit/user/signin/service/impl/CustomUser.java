package kr.or.ddit.user.signin.service.impl;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.common.vo.user.UsersVO;

// principal 역할의 CustomUser
public class CustomUser extends User {

	// usersVO를 필드로 보관하는 방식으로 했기 때문에
	// 
	// jsp에서는 principal.usersVO.userId 
	//principal.userId , principal.name 이렇게 쓰면 안된다  
	
    private UsersVO usersVO;

    // (Optional) 권한만 직접 넘겨줄 필요가 있을 때
    // 대장한테 넘겨주는거니까, 파라미터 순서만 맞으면된다
    public CustomUser(String userId, String password, Collection<? extends GrantedAuthority> authorities) {
        super(userId, password, authorities);
    }

    // 주로 이 생성자만 쓰시면 됩니다
    public CustomUser(UsersVO usersVO) {
        super(
            usersVO.getUserId(), 
            usersVO.getPassword(),
            usersVO.getUsersAuthVOList().stream()
                   .map(auth -> new SimpleGrantedAuthority(auth.getAuth()))
                   .collect(Collectors.toList())
        );
        this.usersVO = usersVO;
    }

    public UsersVO getUsersVO() {
        return usersVO;
    }

    public void setUsersVO(UsersVO usersVO) {
        this.usersVO = usersVO;
    }
}
