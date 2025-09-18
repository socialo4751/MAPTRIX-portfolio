package kr.or.ddit.common.vo.user;

import lombok.Data;

/**
 * 사용자 권한 정보를 담기 위한 VO 클래스
 */
@Data
public class UsersAuthVO {
    private String auth;
    private String userId;
}