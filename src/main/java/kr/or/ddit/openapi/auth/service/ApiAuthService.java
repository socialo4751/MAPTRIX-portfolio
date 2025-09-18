package kr.or.ddit.openapi.auth.service;

import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;

public interface ApiAuthService {
    /**
     * @method Name : findValidSubscription
     * @Description : API 키를 기준으로 유효한 구독 정보를 조회한다.
     * @param apiKey : 검증할 API 키
     * @return : 유효한 구독 정보 객체. 없으면 null.
     */
    public ApiSubscriptionsVO findValidSubscription(String apiKey);
    
    public long getDailyLimit(long apiId);
}