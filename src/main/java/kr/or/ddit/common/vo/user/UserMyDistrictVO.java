package kr.or.ddit.common.vo.user;

import java.util.Date;

import lombok.Data;

/**
 * 사용자의 관심 구역 정보를 담기 위한 VO 클래스
 */
@Data
public class UserMyDistrictVO {
    /**
     * 회원고유번호
     */
    private String userId;
    
    /**
     * 행정동 코드
     */
    private String admCode;
    
    /**
     * 관심등록일
     */
    private Date createdAt;
    
    /**
     * 관심구역 순서
     */
    private int displayOrder;
    
    /**
     * 행정동 이름
     */
    private String districtName;
}
