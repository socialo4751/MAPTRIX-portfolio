package kr.or.ddit.openapi.apply.service;

import java.util.List;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;
import kr.or.ddit.openapi.apply.vo.MySubscriptionVO;

/**
 * @interface Name : OpenApiService
 * @Description : OPEN API 서비스 조회 및 신청 관련 비즈니스 로직 처리를 위한 인터페이스
 */
public interface OpenApiService {

    /**
     * @method Name : getApiList
     * @Description : 전체 OPEN API 서비스 목록을 조회한다.
     * @return : API 서비스 정보(ApiServiceVO)를 담은 List
     */
    public List<ApiServiceVO> getApiList();

    /**
     * @method Name : getApiById
     * @Description : ID를 기준으로 특정 OPEN API 서비스의 상세 정보를 조회한다.
     * @param apiId : 조회할 API의 ID
     * @return : 조회된 API 서비스의 상세 정보
     */
    public ApiServiceVO getApiById(long apiId);

    /**
     * @method Name : submitApplication
     * @Description : API 이용 신청 정보를 받아 DB에 저장한다.
     * @param applicationVO : 저장할 신청 정보
     * @return : 등록 성공 시 1, 실패 시 0
     */
    public int submitApplication(ApiApplicationVO applicationVO);
    
    /**
     * @method Name : findMySubscriptionList
     * @Description : 특정 사용자가 구독중인 API 목록과 상세 정보를 조회한다.
     * @param userId : 로그인한 사용자의 ID
     * @return : 나의 구독 정보 목록
     */
    public List<MySubscriptionVO> findMySubscriptionList(String userId);
    
    /**
     * @method Name : hasActiveApplication
     * @Description : 사용자가 해당 API에 대해 이미 신청했거나 승인된 내역이 있는지 확인한다.
     * @param userId : 확인할 사용자의 ID
     * @param apiId : 확인할 API의 ID
     * @return : 신청/승인 내역이 있으면 true, 없으면 false
     */
    boolean hasActiveApplication(String userId, long apiId);
    
    public List<ApiApplicationVO> selectMyApplicationsExceptApproved(String userId);
    
    /**
     * @method Name : findMySubscriptionList
     * @Description : 특정 사용자가 구독중인 API 목록을 페이징하여 조회한다.
     * @param userId : 로그인한 사용자의 ID
     * @param currentPage : 현재 페이지 번호
     * @param size : 페이지 당 보여줄 항목 수
     * @return : 페이징된 구독 정보(ArticlePage)
     */
    public ArticlePage<MySubscriptionVO> findMySubscriptionList(String userId, int currentPage, int size);
    
    /**
     * @method Name : findMyApplicationsByStatus
     * @Description : 특정 사용자의 상태별(대기/반려) 신청 목록을 페이징하여 조회한다.
     * @param userId : 로그인한 사용자의 ID
     * @param status : 조회할 신청 상태 ("PENDING", "REJECTED")
     * @param currentPage : 현재 페이지 번호
     * @param size : 페이지 당 보여줄 항목 수
     * @return : 페이징된 신청 정보(ArticlePage)
     */
    public ArticlePage<ApiApplicationVO> findMyApplicationsByStatus(String userId, String status, int currentPage, int size);
}