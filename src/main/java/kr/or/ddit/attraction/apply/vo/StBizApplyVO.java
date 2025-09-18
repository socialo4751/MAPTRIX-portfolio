package kr.or.ddit.attraction.apply.vo;

import java.util.Date;

import lombok.Data;

/**
 * 상권 활성화 사업 신청 정보를 담기 위한 VO 클래스
 */
@Data
public class StBizApplyVO {
    private int applyId; // 신청 고유 번호
    private String storeId;
    private String applyStoreId;
    private String userId; // 신청자ID
    private String applyStoreName; // 신청자ID
    private String adminId; // 담당직원ID
    private String status; // 처리상태
    private String memo; // 담당자메모
    private Date applicatedAt;
    private Date acceptAt;
    private String address1; // 주소
    private String address2; // 상세주소
    private Double lon; // 위도
    private Double lat; // 경도
    private String adminContact; // 연락처
    private String adminEmail; // 연락이메일
    
 // --- 새로 추가된 컬럼 ---
    private String jibunAddress; // 지번 주소
    private String adminBizName; // 사업자 이름 (예: 식당 / 카페)
    private String postcode; // 우편번호
}