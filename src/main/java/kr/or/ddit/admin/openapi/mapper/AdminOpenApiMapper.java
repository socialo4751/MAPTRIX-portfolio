package kr.or.ddit.admin.openapi.mapper;

import java.util.List;
import java.util.Map; // Map 임포트 추가

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.admin.openapi.vo.ApiApplicationAdminVO;
import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;

@Mapper
public interface AdminOpenApiMapper {

    /**
     * @method Name : selectApplicationList
     * @Description : API 신청 목록을 조회한다. (검색/페이징 기능 추가)
     * @param map : 검색어(keyword), 페이징(rowSize, firstRecord) 정보
     * @return : API 신청 정보 목록
     */
    // [변경] Map 파라미터 추가
    public List<ApiApplicationAdminVO> selectApplicationList(Map<String, Object> map);
    
    /**
     * @method Name : selectApplicationCount
     * @Description : 전체 API 신청 건수를 조회한다. (검색 기능 추가)
     * @param map : 검색어(keyword) 정보
     * @return : 전체 신청 건수
     */
    // [신규] 페이징 처리를 위한 메소드 추가
    public int selectApplicationCount(Map<String, Object> map);

    /**
     * @method Name : selectApplicationDetail
     * @Description : ID를 기준으로 특정 신청 건의 상세 정보를 조회한다.
     * @param applicationId : 조회할 신청 건의 ID
     * @return : 조회된 신청 건의 상세 정보
     */
    public ApiApplicationAdminVO selectApplicationDetail(long applicationId);

    /**
     * @method Name : updateApplicationStatus
     * @Description : API_APPLICATION 테이블의 상태를 변경한다.
     * @param applicationId : 상태를 변경할 신청 건의 ID
     * @param status : 변경할 상태 문자열 ('승인', '반려' 등)
     * @return : 업데이트 성공 시 1, 실패 시 0
     */
    public int updateApplicationStatus(@Param("applicationId") long applicationId, @Param("status") String status);

    /**
     * @method Name : insertSubscription
     * @Description : API_SUBSCRIPTIONS 테이블에 구독 정보를 삽입(INSERT)한다.
     * @param subscription : 저장할 구독 정보
     * @return : 등록 성공 시 1, 실패 시 0
     */
    public int insertSubscription(ApiSubscriptionsVO subscription);
    
    public Map<String,Object>  selectApplicationStatusSummary();
}