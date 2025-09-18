package kr.or.ddit.common.vo.user;

import lombok.Data;

/**
 * 사용자 사업자등록 정보를 담기 위한 VO 클래스
 */
@Data
public class UsersBizIdVO {
    /**
     * 사업자등록번호
     * DB의 BIZ_NUMBER는 NUMBER 타입이지만, 
     * '-'를 포함한 문자열로 받기 때문에 String으로 처리
     */
    private String bizNumber;
    /**
     * 회원고유번호
     */
    private String userId;
    /**
     * 상호명
     */
    private String companyName;
    /**
     * 개업일자 (추가)
     */
    private String startDate; 
    
    /**
     * 사업장 우편번호 (추가)
     * 08.13 주소 추가
     */
    private String bizPostcode;
    /**
     * 사업장 주소1 (추가)
     * 08.13 주소 추가
     */
    private String bizAddress1;
    
    /**
     * 사업장 주소2 (추가)
     * 08.13 주소 추가
     */
    private String bizAddress2;
}