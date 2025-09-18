package kr.or.ddit.common.vo.user;

import java.util.Date;

import lombok.Data;

/**
 * 사용자의 관심 가게 정보를 담기 위한 VO 클래스
 */
@Data
public class UserMyStoreVO {
    /**
     * 회원고유번호
     */
    private String userId;
    /**
     * 상점 정보 ID
     */
    private int storeInfoId;
    /**
     * 관심등록일
     */
    private Date createdAt;
    /**
     * 관심가게 순서
     */
    private int displayOrder;
}