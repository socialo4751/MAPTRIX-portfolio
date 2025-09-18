package kr.or.ddit.admin.openapi.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.admin.openapi.vo.ApiApplicationAdminVO;

/**
 * @interface Name : AdminOpenapiService
 * @Description : OPEN API 신청 관리 관련 비즈니스 로직 처리를 위한 인터페이스
 */
public interface AdminOpenApiService {

	
    public int getApplicationCount(Map<String, Object> map);
    /**
     * @method Name : getApplicationList
     * @Description : 전체 API 신청 목록을 조회한다. (페이징 처리 고려)
     * @return : 신청 정보(ApiApplicationAdminVO)를 담은 List
     */
	public List<ApiApplicationAdminVO> getApplicationList(Map<String, Object> map);

    /**
     * @method Name : getApplicationDetail
     * @Description : ID를 기준으로 특정 신청 건의 상세 정보를 조회한다.
     * @param applicationId : 조회할 신청 건의 ID
     * @return : 조회된 신청 건의 상세 정보
     */
    public ApiApplicationAdminVO getApplicationDetail(long applicationId);

    /**
     * @method Name : approveApplication
     * @Description : API 이용 신청을 승인 처리한다.
     * 이 메소드는 하나의 트랜잭션으로 처리되어야 한다.
     * @param applicationId : 승인할 신청 건의 ID
     */
    public void approveApplication(long applicationId);

    /**
     * @method Name : rejectApplication
     * @Description : API 이용 신청을 반려 처리한다.
     * @param applicationId : 반려할 신청 건의 ID
     */
    public void rejectApplication(long applicationId);
    
    /**
     * @method Name : getApplicationStatusSummary
     * @Description : API 신청 상태별 건수를 조회한다.
     * @return : 상태별 건수(TOTAL, PENDING, APPROVED, REJECTED)를 담은 Map
     */
    public Map<String, Object> getApplicationStatusSummary();
}