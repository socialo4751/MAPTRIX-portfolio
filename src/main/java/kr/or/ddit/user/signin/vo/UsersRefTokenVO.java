package kr.or.ddit.user.signin.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사용자 리프레시 토큰 정보를 담기 위한 VO 클래스
 */

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsersRefTokenVO {
    /**
     * 리프레시토큰
     */
    private String tokenId;
    /**
     * 회원고유번호
     */
    private String userId;
    /**
     * 만료시각
     */
    private Date expiresAt;
    
	@Override
	public String toString() {
		return "UsersRefTokenVO [tokenId=" + tokenId + ", userId=" + userId + ", expiresAt=" + expiresAt + "]";
	}
    
    
    
}