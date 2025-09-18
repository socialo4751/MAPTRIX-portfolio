package kr.or.ddit.admin.openapi.service.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.admin.openapi.mapper.AdminOpenApiMapper;
import kr.or.ddit.admin.openapi.service.AdminApiService; // 다른 서비스 주입
import kr.or.ddit.admin.openapi.service.AdminOpenApiService;
import kr.or.ddit.admin.openapi.vo.ApiApplicationAdminVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;
import kr.or.ddit.common.vo.openapi.ApiSubscriptionsVO;

@Service
public class AdminOpenApiServiceImpl implements AdminOpenApiService {

    @Autowired
    private AdminOpenApiMapper adminOpenApiMapper;

    // ▼▼▼▼▼ [추가] API 서비스 정보를 조회하기 위해 AdminApiService 주입 ▼▼▼▼▼
    @Autowired
    private AdminApiService adminApiService; 
    // ▲▲▲▲▲ 여기까지 추가 ▲▲▲▲▲

    @Override
    public List<ApiApplicationAdminVO> getApplicationList(Map<String, Object> map) {
        int size = 10;
        int currentPage = (int) map.get("currentPage");
        int firstRecord = (currentPage - 1) * size + 1;
        int lastRecord = currentPage * size;
        
        map.put("firstRecord", firstRecord);
        map.put("lastRecord", lastRecord);
        
        return adminOpenApiMapper.selectApplicationList(map);
    }

    @Override
    public int getApplicationCount(Map<String, Object> map) {
        return adminOpenApiMapper.selectApplicationCount(map);
    }

    @Override
    public ApiApplicationAdminVO getApplicationDetail(long applicationId) {
        return adminOpenApiMapper.selectApplicationDetail(applicationId);
    }

    @Transactional
    @Override
    public void approveApplication(long applicationId) {
        // 1. 신청 상세 정보 조회
        ApiApplicationAdminVO application = adminOpenApiMapper.selectApplicationDetail(applicationId);
        
        if (application == null || !"PENDING".equals(application.getStatusCode())) {
            return; // 이미 처리된 건이면 로직 중단
        }

        // ▼▼▼▼▼ [수정 및 추가] 동적으로 구독 만료일 계산 로직 ▼▼▼▼▼
        
        // 2. 신청된 API의 서비스 정보 조회 (구독 기간을 알기 위해)
        ApiServiceVO apiService = adminApiService.getApiServiceById(application.getApiId());
        
        // 3. 서비스에 설정된 구독 개월 수 가져오기 (컬럼이 없다면 기본값 12 사용)
        int subscriptionMonths = (apiService != null && apiService.getSubscriptionPeriodMonths() > 0) 
                                 ? apiService.getSubscriptionPeriodMonths() 
                                 : 12;

        // 4. 현재 날짜 기준으로 구독 만료일 계산
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, subscriptionMonths);
        Date expiredAt = cal.getTime();

        // 5. 상태를 '승인'으로 변경
        adminOpenApiMapper.updateApplicationStatus(applicationId, "APPROVED");

        // 6. 키 생성 및 구독 정보 INSERT
        ApiSubscriptionsVO subscription = new ApiSubscriptionsVO();
        subscription.setUserId(application.getUserId());
        subscription.setApiId(application.getApiId());
        subscription.setApplicationId(application.getApplicationId());
        subscription.setApiKey(UUID.randomUUID().toString());
        subscription.setSecretKey(UUID.randomUUID().toString());
        subscription.setExpiredAt(expiredAt); // 계산된 만료일 설정
        
        adminOpenApiMapper.insertSubscription(subscription);
        // ▲▲▲▲▲ 여기까지 수정 ▲▲▲▲▲
    }

    @Transactional // 반려 처리도 트랜잭션으로 관리
    @Override
    public void rejectApplication(long applicationId) {
        adminOpenApiMapper.updateApplicationStatus(applicationId, "REJECTED");
    }
    
    @Override
    public Map<String, Object> getApplicationStatusSummary() {
        return adminOpenApiMapper.selectApplicationStatusSummary();
    }
}