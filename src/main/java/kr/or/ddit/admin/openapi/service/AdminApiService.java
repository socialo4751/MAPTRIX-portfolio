package kr.or.ddit.admin.openapi.service;

import java.util.Map;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;

public interface AdminApiService {

    /**
     * @method Name : getApiServicePage
     * @Description : API 서비스 목록을 페이징 처리하여 조회한다.
     * @param map : 검색어(keyword), 현재 페이지(currentPage) 정보
     * @return : 페이징 정보와 목록 데이터가 담긴 ArticlePage 객체
     */
    public ArticlePage<ApiServiceVO> getApiServicePage(Map<String, Object> map);

    /**
     * @method Name : getApiServiceById
     * @Description : ID를 기준으로 특정 API 서비스의 상세 정보를 조회한다.
     * @param apiId : 조회할 API의 ID
     * @return : API 서비스 상세 정보
     */
    public ApiServiceVO getApiServiceById(long apiId);

    /**
     * @method Name : createApiService
     * @Description : 새로운 API 서비스 정보를 생성한다.
     * @param apiServiceVO : 등록할 API 서비스 정보
     * @return : 성공 시 1
     */
    public int createApiService(ApiServiceVO apiServiceVO);

    /**
     * @method Name : updateApiService
     * @Description : 기존 API 서비스 정보를 수정한다.
     * @param apiServiceVO : 수정할 API 서비스 정보
     * @return : 성공 시 1
     */
    public int updateApiService(ApiServiceVO apiServiceVO);
}