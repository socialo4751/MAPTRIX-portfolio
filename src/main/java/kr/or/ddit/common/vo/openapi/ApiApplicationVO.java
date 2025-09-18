package kr.or.ddit.common.vo.openapi;

import java.util.Date;

import lombok.Data;

/**
 * API 사용 신청 정보를 담기 위한 VO 클래스
 */
@Data
public class ApiApplicationVO {
    private long applicationId; // 신청 ID
    private long apiId; // API ID
    private String userId; // 회원고유번호
    private String purposeDesc; // 활용목적설명
    private String status; // 신청 상태
    private Date applicatedAt; // 신청일
    
    // ▼ 화면 표시용(조인 결과)
    private String apiNameKr;     // API 한글명
    private String apiDesc;       // API 설명
}
