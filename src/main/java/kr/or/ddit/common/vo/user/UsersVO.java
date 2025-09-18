package kr.or.ddit.common.vo.user;

import java.time.LocalDate;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.fasterxml.jackson.annotation.JsonFormat;

import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import lombok.Data;

/**
 * 사용자 정보를 담기 위한 VO 클래스
 */
@Data
public class UsersVO implements UserDetails {
    private String userId;
    private String password;
    private String name;
    
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
    private Date createdAt;
    
    private String enabled;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd") // form -> 객체 변환
    private LocalDate birthDate;
    private String phoneNumber;
    private String email;
    private String postcode;
    private String address1;
    private String address2;
    private Date withdrawnAt;
    private String gender;
    
    private int deptId; // 직원부서저장
    
    //중첩된 자바빈
    private List<UsersAuthVO> usersAuthVOList;
    
    private List<UserMyDistrictVO> userMyDistrictVOList; // 관심 구역은 그대로 유지
    private List<CodeAdmDongVO> codeAdmDongVOList; // 관심 구역은 그대로 유지
    
    private List<UserMyBizVO> userMyBizVOList;           // 선호 업종 리스트 추가
    private List<CodeBizVO> codeBizVOList;            // 선호 업종 리스트 추가
    
    private UsersBizIdVO usersBizIdVO; // 사업자번호저장
    
    public String getUserRole() {
        if (usersAuthVOList != null && !usersAuthVOList.isEmpty()) {
            return usersAuthVOList.get(0).getAuth(); // 예: "ROLE_MEMBER"
        }
        return null;
    }
    
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // usersAuthVOList가 null이거나 비어있을 경우를 대비하여 기본 권한을 주거나,
        // 빈 컬렉션을 반환하도록 처리할 수 있습니다.
        if (usersAuthVOList == null || usersAuthVOList.isEmpty()) {
            // 기본 권한을 부여하거나, 상황에 따라 빈 리스트를 반환할 수 있습니다.
            // 예시: List.of(new SimpleGrantedAuthority("ROLE_USER"));
            return List.of(new SimpleGrantedAuthority("ROLE_USER")); // 기본적으로 사용자 권한 부여
        }
        return usersAuthVOList.stream()
            .map(auth -> new SimpleGrantedAuthority(auth.getAuth())) // UsersAuthVO에서 권한 문자열을 가져옴
            .collect(Collectors.toList());
    }
    
    @Override
    public String getUsername() {
        return userId;
    }

    //사용자의 패스워드 반환
    @Override
    public String getPassword() {
        return password;
    }

    //계정 만료 여부 반환
    @Override
    public boolean isAccountNonExpired() {
        //만료되었는지 확인하는 로직
        return true; //true -> 만료되지 않았음
    }

    //계정 잠금 여부 반환
    @Override
    public boolean isAccountNonLocked() {
        //계정 잠금되었는지 확인하는 로직
        return true; //true -> 잠금되지 않았음
    }

    //패스워드의 만료 여부 반환
    @Override
    public boolean isCredentialsNonExpired() {
        //패스워드가 만료되었는지 확인하는 로직
        return true; //true -> 만료되지 않았음
    }

    // 계정 사용 가능 여부 반환
    @Override
    public boolean isEnabled() {
        // this.enabled 필드(String)의 값이 'Y'이면 true, 아니면 false 반환
        return "Y".equalsIgnoreCase(this.enabled); 
    }
}