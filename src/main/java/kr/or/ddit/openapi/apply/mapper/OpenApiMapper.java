package kr.or.ddit.openapi.apply.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;
import kr.or.ddit.openapi.apply.vo.MySubscriptionVO;

/**
 * @interface Name : OpenApiMapper
 * @Description : API 서비스 조회 및 신청 관련 데이터베이스 접근을 위한 MyBatis Mapper
 */
@Mapper
public interface OpenApiMapper {

    /**
     * @method Name : selectApiList
     * @Description : API_SERVICE 테이블에서 전체 API 목록을 조회한다.
     * @return : API 서비스 정보(ApiServiceVO)를 담은 List
     */
    public List<ApiServiceVO> selectApiList();

    /**
     * @method Name : selectApiById
     * @Description : API_SERVICE 테이블에서 ID를 기준으로 특정 API 정보를 조회한다.
     * @param apiId : 조회할 API의 ID
     * @return : 조회된 API 서비스의 상세 정보
     */
    public ApiServiceVO selectApiById(long apiId);

    /**
     * @method Name : insertApplication
     * @Description : API_APPLICATION 테이블에 신청 정보를 삽입(INSERT)한다.
     * @param applicationVO : 저장할 신청 정보
     * @return : 등록 성공 시 1, 실패 시 0
     */
    public int insertApplication(ApiApplicationVO applicationVO);
    
    public int countActiveApplicationOrSubscription(Map<String, Object> map);
    
    public List<ApiApplicationVO> selectPendingAndRejectedApplications(String userId);

    /**
     * @method Name : countMySubscriptions
     * @Description : 특정 사용자의 전체 구독 수를 조회한다. (페이징용)
     * @param userId : 로그인한 사용자의 ID
     * @return : 구독 수
     */
    public int countMySubscriptions(String userId);

    /**
     * @method Name : selectMySubscriptionList
     * @Description : 특정 사용자가 구독중인 API 목록을 페이징하여 조회한다.
     * @param params : userId, startRow, endRow를 담은 Map
     * @return : 나의 구독 정보 목록
     */
    public List<MySubscriptionVO> selectMySubscriptionList(Map<String, Object> params);

    /**
     * @method Name : countMyApplications
     * @Description : 특정 사용자의 상태별 신청 건수를 조회한다. (페이징용)
     * @param params : userId, status를 담은 Map
     * @return : 신청 건수
     */
    public int countMyApplications(Map<String, Object> params);

    /**
     * @method Name : selectMyApplications
     * @Description : 특정 사용자의 상태별 신청 목록을 페이징하여 조회한다.
     * @param params : userId, status, startRow, endRow를 담은 Map
     * @return : 신청 정보 목록
     */
    public List<ApiApplicationVO> selectMyApplications(Map<String, Object> params);
}