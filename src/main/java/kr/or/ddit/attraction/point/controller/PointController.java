package kr.or.ddit.attraction.point.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.attraction.flow.service.FlowService;
import kr.or.ddit.attraction.point.service.PointService; // [핵심 변경] PointService 임포트
import kr.or.ddit.attraction.point.vo.StUserPointHistoryVO;
import kr.or.ddit.attraction.stamp.service.StampService;
import kr.or.ddit.attraction.stamp.vo.StStampVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/attraction")
public class PointController {

    // [핵심 변경] StampService 대신 PointService를 주입받습니다.
    @Autowired
    private PointService pointService;

    // StampService는 '내 오늘 성과'에서 스탬프 목록을 가져오기 위해 여전히 필요합니다.
    @Autowired
    private StampService stampService;

    @Autowired
    private FlowService flowService;

    /**
     * 내 포인트 이력
     */
    @GetMapping("/point-history")
    public ResponseEntity<List<StUserPointHistoryVO>> getPointHistory(@AuthenticationPrincipal CustomUser customUser) {
        if (customUser == null) {
            return new ResponseEntity<>(new ArrayList<>(), HttpStatus.UNAUTHORIZED);
        }
        String userId = customUser.getUsersVO().getUserId();
        
        StUserPointHistoryVO pointLog = new StUserPointHistoryVO();
        pointLog.setUserId(userId);
        
        // [핵심 변경] pointService의 메서드를 호출합니다.
        List<StUserPointHistoryVO> pointLogList = pointService.getPointHistory(pointLog);
        return new ResponseEntity<>(pointLogList, HttpStatus.OK);
    }

    /**
     * 내 오늘 성과 (dayMyStamp)
     */
	@GetMapping("/dayMyStamp")
    public ResponseEntity<Map<String, Object>> dayMyStamp(@AuthenticationPrincipal CustomUser customUser) {
		Map<String, Object> resultMap = new HashMap<>();
		
		if (customUser == null) {
            resultMap.put("msg", "로그인이 필요합니다.");
            resultMap.put("status", false);
		    return new ResponseEntity<>(resultMap, HttpStatus.UNAUTHORIZED);
		}
        
        String userId = customUser.getUsersVO().getUserId();
        resultMap.put("userId", userId);
        
        String todayStr = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        resultMap.put("day", todayStr);
        
        // [핵심 변경] 포인트 조회는 pointService가 담당합니다.
        int totalPoint = pointService.getTotalPoint(resultMap);
        
        // 스탬프와 이동거리 조회는 각자의 서비스가 담당합니다.
        List<StStampVO> dayStampList = stampService.getDayStamp(resultMap);
        List<StStampVO> allStampList = stampService.myStampByCode(resultMap);
        Double dayFlowKm = flowService.dayFlowKm(resultMap);
        Double totalDistance = flowService.getTotalDistance(resultMap);
        Double claimedDistance = flowService.getClaimedDistance(resultMap);
        
        resultMap.put("totalPoint", totalPoint);
        resultMap.put("dayStampList", dayStampList);
        resultMap.put("allStampList", allStampList);
        resultMap.put("dayFlowKm", dayFlowKm);
        resultMap.put("totalDistance", totalDistance);
        resultMap.put("claimedDistance", claimedDistance);
        
        return new ResponseEntity<>(resultMap, HttpStatus.OK);
    }

    /**
     * 포인트 정산
     */
	@LogEvent(eventType = "INSERT", feature = "POINT")
	@PostMapping("/insert-point")
	public Map<String, Object> insertPoint(@RequestBody Map<String, Object> map, @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> resultMap = new HashMap<>();

        if (customUser == null) {
            resultMap.put("msg", "로그인이 필요합니다.");
            resultMap.put("status", false);
            return resultMap;
        }
        String userId = customUser.getUsersVO().getUserId();
		map.put("userId", userId);
       
		Double claimedKm = flowService.getClaimedDistance(map);
		Double flowKm = flowService.getTotalDistance(map);
		int claimKm = (int)(flowKm - (claimedKm != null ? claimedKm : 0.0));
		
        if(claimKm < 1) {
			resultMap.put("msg", "정산받을 이동거리가 충분하지 않습니다.");
            resultMap.put("status", false);
            return resultMap;
		}
        map.put("claimKm",claimKm);
		
        try {
            // [핵심 변경] 포인트 정산 로직을 pointService에 위임합니다.
            int pointsToAdd = pointService.processPointClaim(map);
            resultMap.put("msg", "포인트가 적립되었습니다.");
            resultMap.put("pointsToAdd", pointsToAdd);
            resultMap.put("status", true);
        } catch (Exception e) {
            log.error("포인트 정산 처리 중 오류 발생", e);
            resultMap.put("msg", "정산 처리 중 오류가 발생했습니다.");
            resultMap.put("status", false);
        }
        return resultMap;
    }
}
