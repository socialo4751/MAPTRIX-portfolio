package kr.or.ddit.openapi.data.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.openapi.data.vo.ApiStatsBusinessVO;
import kr.or.ddit.openapi.data.vo.ApiStatsCreditCardVO;
import kr.or.ddit.openapi.data.vo.ApiStatsEmployeeVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHouseholdVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHousingVO;
import kr.or.ddit.openapi.data.vo.ApiStatsPopulationVO;

/**
 * @interface Name : ApiDataMapper
 * @Description : OPEN API를 통해 제공할 데이터 조회를 위한 MyBatis Mapper
 */
@Mapper
public interface ApiDataMapper {

    public List<ApiStatsBusinessVO> getBusinessStats(Map<String, Object> params);
    public List<ApiStatsEmployeeVO> getEmployeeStats(Map<String, Object> params);
    public List<ApiStatsCreditCardVO> getCreditCardStats(Map<String, Object> params);
    public List<ApiStatsHouseholdVO> getHouseholdStats(Map<String, Object> params);
    public List<ApiStatsHousingVO> getHousingStats(Map<String, Object> params);
    public List<ApiStatsPopulationVO> getPopulationStats(Map<String, Object> params);
}