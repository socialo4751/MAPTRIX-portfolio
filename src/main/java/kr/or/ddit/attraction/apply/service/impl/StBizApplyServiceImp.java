package kr.or.ddit.attraction.apply.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.attraction.apply.mapper.StBizApplyMapper;
import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class StBizApplyServiceImp implements StBizApplyService {

	
    private final StBizApplyMapper stBizApplyMapper;
    private final NotificationService notificationService;
	
	
	@Override
	public int insertStBizApply(StBizApplyVO info) {
		return stBizApplyMapper.insertStBizApply(info);
	}

	@Override
	public List<StBizApplyVO> stBizApplyList(StBizApplyVO info) {
		return stBizApplyMapper.stBizApplyList(info);
	}


	@Override
	public List<StBizApplyVO> getStBizApplyList(Map<String, Object> paramMap) {
		return stBizApplyMapper.getStBizApplyList(paramMap);
	}
	
	/**
     * [수정] 가맹점 신청 상태 업데이트 시, '승인' 상태일 경우 사용자에게 알림을 전송합니다.
     * @param info 업데이트할 가맹점 신청 정보 (applyId, status 등 관리자가 변경한 내용 포함)
     * @return 업데이트 성공 여부 (1: 성공, 0: 실패)
     */
	@Override
	@Transactional // 여러 DB 작업을 하므로 트랜잭션 처리
	public int updateStBizApply(StBizApplyVO info) {
		log.info("가맹점 신청 상태 업데이트 시작(from Controller): {}", info);

        // 1. [중요] DB에서 원본 신청 정보를 조회하여 정확한 userId와 가게이름을 확보합니다.
        StBizApplyVO originalApplyInfo = stBizApplyMapper.selectApplyById(info.getApplyId());
        if (originalApplyInfo == null) {
            log.error("존재하지 않는 신청 ID 입니다. applyId: {}", info.getApplyId());
            return 0; // 신청 정보가 없으면 중단
        }
		
		// 2. '승인' 상태일 경우에만, 가맹점 정보를 별도 테이블에 등록합니다.
		if ("승인".equals(info.getStatus())) {

            // 원본 정보에 업데이트할 내용을 덮어씌워 사용
            originalApplyInfo.setStatus(info.getStatus());
            originalApplyInfo.setMemo(info.getMemo());
            originalApplyInfo.setAddress1(info.getAddress1());
            originalApplyInfo.setAddress2(info.getAddress2());
            originalApplyInfo.setAdminBizName(info.getAdminBizName());
            originalApplyInfo.setLon(info.getLon());
            originalApplyInfo.setLat(info.getLat());
            originalApplyInfo.setJibunAddress(info.getJibunAddress());
			stBizApplyMapper.insertStore(originalApplyInfo);
            log.info("'승인' 상태이므로, 가게 정보를 등록합니다. 가게명: {}", originalApplyInfo.getApplyStoreName());
		}

		// 3. 가맹점 신청 테이블의 상태를 업데이트합니다.
		int row = stBizApplyMapper.updateStBizApply(originalApplyInfo);
		
		// --- ★★★★★ 상태 업데이트 성공 및 '승인' 상태일 경우 알림 생성 ★★★★★ ---
		if (row > 0 && "승인".equals(info.getStatus())) {
			UserNotifiedVO notification = new UserNotifiedVO();
            
            // 4. [중요] 폼에서 받은 info 대신, DB에서 직접 조회한 originalApplyInfo의 userId를 사용합니다.
			notification.setUserId(originalApplyInfo.getUserId()); 

			String message = "'" + originalApplyInfo.getApplyStoreName() + "' 가맹점 신청이 승인되었습니다.";
			notification.setMessage(message);
			
            // 알림 클릭 시 이동할 URL (예: 나의 가게 관리 페이지)
            // ※※※※※ 이 URL은 실제 프로젝트의 경로에 맞게 수정해주세요! ※※※※※
			String url = "/attraction/apply-stamp";  
			notification.setTargetUrl(url);

            // 5. 알림 서비스 호출
			notificationService.createNotification(notification);
			log.info("가맹점 승인 알림이 생성되었습니다. 수신자 ID: {}", originalApplyInfo.getUserId());
		}
		// -----------------------------------------------------------------
		
		return row;
	}

	//통계
	//@Override
	//public List<Map<String,Object>> getStBizApplyStatsList() {
	//	return stBizApplyMapper.getStBizApplyStatsList();
	//}
	//통계
	@Override
	public List<Map<String,Object>> getStBizApplyStatsList() {
		return stBizApplyMapper.getStBizApplyStatsList();
	}
	
	@Override
    public int getStBizApplyCount(Map<String, Object> paramMap) {
        return stBizApplyMapper.selectStBizApplyCount(paramMap);
    }

    @Override
    public Map<String, Object> getStatusSummary() {
        return stBizApplyMapper.selectStBizApplyStatusSummary();
    }

}
