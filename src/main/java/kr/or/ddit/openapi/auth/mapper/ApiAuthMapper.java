package kr.or.ddit.openapi.auth.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;

@Mapper
public interface ApiAuthMapper {
    /**
     * @method Name : findSubscriptionByApiKey
     * @Description : API 키를 기준으로 유효한 구독 정보를 조회한다.
     * @param apiKey : 검증할 API 키
     * @return : 유효한 구독 정보. 없으면 null.
     */
    public ApiSubscriptionsVO findSubscriptionByApiKey(String apiKey);
    
    /**
     * @method Name : selectDailyLimitByApiId
     * @Description : API ID를 기준으로 일일 호출 허용량을 조회한다.
     * @param apiId : 조회할 API의 ID
     * @return : 일일 호출 허용량
     */
    public Long selectDailyLimitByApiId(long apiId);
}