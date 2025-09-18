package kr.or.ddit.admin.openapi.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.openapi.ApiServiceVO;

@Mapper
public interface AdminApiServiceMapper {

    /**
     * @method Name : selectApiServiceCount
     * @Description : 검색 조건에 맞는 API 서비스의 전체 개수를 조회한다.
     * @param map : 검색어(keyword) 정보
     * @return : API 서비스 전체 개수
     */
    public int selectApiServiceCount(Map<String, Object> map);

    /**
     * @method Name : selectApiServiceList
     * @Description : API 서비스 목록을 조회한다. (페이징/검색 포함)
     * @param map : 검색어(keyword), 페이징 정보
     * @return : API 서비스 목록
     */
    public List<ApiServiceVO> selectApiServiceList(Map<String, Object> map);

    /**
     * @method Name : selectApiServiceById
     * @Description : ID를 기준으로 특정 API 서비스의 상세 정보를 조회한다.
     * @param apiId : 조회할 API의 ID
     * @return : API 서비스 상세 정보
     */
    public ApiServiceVO selectApiServiceById(long apiId);

    /**
     * @method Name : insertApiService
     * @Description : 새로운 API 서비스 정보를 DB에 INSERT한다.
     * @param apiServiceVO : 등록할 API 서비스 정보
     * @return : 성공 시 1
     */
    public int insertApiService(ApiServiceVO apiServiceVO);

    /**
     * @method Name : updateApiService
     * @Description : 기존 API 서비스 정보를 DB에서 UPDATE한다.
     * @param apiServiceVO : 수정할 API 서비스 정보
     * @return : 성공 시 1
     */
    public int updateApiService(ApiServiceVO apiServiceVO);
}