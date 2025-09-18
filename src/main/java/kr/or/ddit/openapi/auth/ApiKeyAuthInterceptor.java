package kr.or.ddit.openapi.auth;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO; // ApiServiceVO 임포트
import kr.or.ddit.openapi.auth.service.ApiAuthService;
import kr.or.ddit.openapi.apply.service.OpenApiService; // OpenApiService 임포트

@Component
public class ApiKeyAuthInterceptor implements HandlerInterceptor {

    @Autowired
    private ApiAuthService apiAuthService;
    
    // ▼▼▼▼▼ [추가] API 서비스 정보를 조회하기 위해 OpenApiService 주입 ▼▼▼▼▼
    @Autowired
    private OpenApiService openApiService;
    // ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        


        // 1. API 키 추출 (헤더 우선, 없으면 파라미터)
        String apiKey = request.getHeader("X-API-KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            apiKey = request.getParameter("apiKey");
        }

        
        // 2. 키 유효성 검사
        ApiSubscriptionsVO subscription = apiAuthService.findValidSubscription(apiKey);
        
        if (subscription == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            response.getWriter().write("Invalid or missing API Key.");
            return false;
        }
        
        // ▼▼▼▼▼ [추가] API 키와 요청 URL 매칭 (인가/권한 검증) 로직 ▼▼▼▼▼
        
        // 3. 현재 요청된 URL(URI)을 가져옴 (예: /api/v1/stats/population)
        String requestedUri = request.getRequestURI();
        
        // 4. 구독 정보(API 키)에 연결된 API 서비스의 상세 정보를 조회
        ApiServiceVO apiService = openApiService.getApiById(subscription.getApiId());
        
        // 5. DB에 저장된 엔드포인트와 실제 요청된 URL이 일치하는지 확인
        if (apiService == null || !requestedUri.equals(apiService.getRequestEndpoint())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
            response.getWriter().write("This API Key is not authorized to access this endpoint.");
            return false; // 권한 없음, 요청 차단
        }
        
        // ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲

        // --- 호출량 제한 로직 (기존과 동일) ---
        String today = LocalDate.now().format(DateTimeFormatter.ISO_DATE);
        String redisKey = "rate_limit:" + subscription.getSubscriptionId() + ":" + today;

        Long currentCount = redisTemplate.opsForValue().increment(redisKey);

        if (currentCount != null && currentCount == 1) {
            redisTemplate.expire(redisKey, 24, TimeUnit.HOURS);
        }

        long dailyLimit = apiAuthService.getDailyLimit(subscription.getApiId());

        if (currentCount != null && currentCount > dailyLimit) {
            response.setStatus(429); // 429 Too Many Requests
            response.getWriter().write("Daily call limit exceeded.");
            return false;
        }
        
        // 모든 인증 및 인가 검증 통과
        return true;
    }
}
