package kr.or.ddit.openapi.data.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.openapi.data.mapper.ApiDataMapper;
import kr.or.ddit.openapi.data.service.ApiDataService;
import kr.or.ddit.openapi.data.vo.ApiStatsBusinessVO;
import kr.or.ddit.openapi.data.vo.ApiStatsCreditCardVO;
import kr.or.ddit.openapi.data.vo.ApiStatsEmployeeVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHouseholdVO;
import kr.or.ddit.openapi.data.vo.ApiStatsHousingVO;
import kr.or.ddit.openapi.data.vo.ApiStatsPopulationVO;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class ApiDataServiceImpl implements ApiDataService {

    @Autowired
    private ApiDataMapper apiDataMapper;

    @Override
    public List<ApiStatsBusinessVO> getBusinessStats(Map<String, Object> params) {
        return apiDataMapper.getBusinessStats(params);
    }
    // ... 나머지 5개 개별 조회 메소드도 위와 같이 Mapper를 바로 호출하여 구현 ...

    @Override
    public List<ApiStatsEmployeeVO> getEmployeeStats(Map<String, Object> params) {
        return apiDataMapper.getEmployeeStats(params);
    }

    @Override
    public List<ApiStatsCreditCardVO> getCreditCardStats(Map<String, Object> params) {
        return apiDataMapper.getCreditCardStats(params);
    }

    @Override
    public List<ApiStatsHouseholdVO> getHouseholdStats(Map<String, Object> params) {
        return apiDataMapper.getHouseholdStats(params);
    }

    @Override
    public List<ApiStatsHousingVO> getHousingStats(Map<String, Object> params) {
        return apiDataMapper.getHousingStats(params);
    }

    @Override
    public List<ApiStatsPopulationVO> getPopulationStats(Map<String, Object> params) {
    
    	
    	log.info("인구데이터openAPI : 파라미터 잘 넘어오는가?"+params);
    	return apiDataMapper.getPopulationStats(params);
    }


}