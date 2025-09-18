package kr.or.ddit.openapi.auth.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;
import kr.or.ddit.openapi.auth.mapper.ApiAuthMapper;
import kr.or.ddit.openapi.auth.service.ApiAuthService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApiAuthServiceImpl implements ApiAuthService {

    @Autowired
    private ApiAuthMapper apiAuthMapper;

    @Override
    public ApiSubscriptionsVO findValidSubscription(String apiKey) {

    	log.info("api key 값이 넘어오는가? :"+ apiKey);
        
    	if (apiKey == null || apiKey.trim().isEmpty()) {
            return null;
        }
        return apiAuthMapper.findSubscriptionByApiKey(apiKey);
    }
    
    @Override
    public long getDailyLimit(long apiId) {
        Long limit = apiAuthMapper.selectDailyLimitByApiId(apiId);
        
        // 만약 DB에 호출 제한값이 설정되어 있지 않은 경우(null), 
        // 무제한 또는 기본값을 반환하도록 처리 (예: 매우 큰 값)
        if (limit == null) {
            return Long.MAX_VALUE; // 사실상 무제한
        }
        
        return limit;
    }

}