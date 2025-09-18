package kr.or.ddit.admin.openapi.vo;

import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import lombok.Data;

/**
 * @class Name : ApiApplicationAdminVO
 * @Description : 관리자 페이지에서 API 신청 목록 및 상세 정보를 표현하기 위한 VO.
 * 기존 ApiApplicationVO에 사용자 이름 등 추가 정보를 포함.
 */
@Data
public class ApiApplicationAdminVO extends ApiApplicationVO { // 상속을 이용한 확장 예시

    private String userName;     // 신청자 이름 (USERS 테이블 조인)
    private String apiNameKr;    // 신청한 API 이름 (API_SERVICE 테이블 조인)
    
    // [추가] 상태 'ID'를 담을 필드 (예: PENDING)
    private String statusCode; 

}