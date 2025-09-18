package kr.or.ddit.attraction.stamp.controller;

import java.sql.Clob;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.attraction.point.service.PointService;
import kr.or.ddit.attraction.stamp.service.StampService;
import kr.or.ddit.attraction.stamp.vo.StCardVO;
import kr.or.ddit.attraction.stamp.vo.StStampVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

//(2025.08.10 장세진) 구조 리팩토링 => Stamp,Point,Flow,Apply메소드 분리

@Slf4j
@RestController
@RequestMapping("/attraction") // 기존 경로 유지
public class StampController {

    @Value("${frontend.url}")
    private String frontendUrl;
	
    @Autowired
    private StampService stampService;
    

    @Autowired
    private PointService pointService;
    
	@GetMapping("/my-stamp")
	public String myStamp() {
		return "redirect:" + frontendUrl;
	}

    /**
     * 우편번호별 내 모든 스탬프
     */
    @GetMapping("/myStamp-by-area")
    public ResponseEntity<List<StStampVO>> myStampByArea(@RequestParam Map<String, Object> param, @AuthenticationPrincipal CustomUser customUser) {
        if (customUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        String userId = customUser.getUsersVO().getUserId();
        param.put("userId", userId);
        
        List<StStampVO> stampList = stampService.myStampByCode(param);
        return new ResponseEntity<>(stampList, HttpStatus.OK);
    }

    /**
     * 우편번호 스탬프 찍기
     */
    @LogEvent(eventType = "INSERT", feature = "STAMP")
    @PostMapping("/insert-stamp")
    public Map<String, Object> insertStamp(@RequestBody StStampVO stampInfo, @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> resultMap = new HashMap<>();
        Map<String, Object> param = new HashMap<>();
        
		if (customUser == null) {
			resultMap.put("msg", "로그인을 해주세요");
		    resultMap.put("status", false);
			return resultMap;
		}
	    
	    String userId = customUser.getUsersVO().getUserId();
	    stampInfo.setUserId(userId);
	    param.put("userId", userId);
	    
	    log.info("insertStamp => stampInfo :" + stampInfo);
	    
	    
	    StCardVO ck = stampService.checkStampCard(stampInfo);
	    log.info("ck => ck :" + ck );
	    if(ck == null) {
	    	StCardVO card = new StCardVO();
	    	card.setAreaId(stampInfo.getAreaId());
	    	card.setUserId(userId);
	    	
	    	if(stampService.insertStampCard(card) > 0) {
	    		if(stampService.insertStamp(stampInfo) > 0) {
	    			resultMap.put("status",true);
		    		resultMap.put("msg","등록이 완료 되었습니다");
	    		}
	    	}
	    } else {
	    	if(stampService.checkStamp(stampInfo) == null) {
	    		if(stampService.insertStamp(stampInfo) > 0) {
	    			//stampService.checkStampCardComplete(stampInfo);
	    			ck = stampService.checkStampCard(stampInfo);
	    			if(ck.getStampCount() == ck.getStampCkCount()) {
	    				resultMap.put("status",true);
	    				resultMap.put("complete",true);
			    		resultMap.put("msg","등록이 완전완료 되었습니다");
			    		log.info("insertStamp => 등록이 완전완료 되었습니다" );
			    		pointService.processPointStamp(param);
	    			}else {
	    				resultMap.put("status",true);
			    		resultMap.put("msg","등록이 완료 되었습니다");
	    			}
	    		}
	    		log.info("insertStamp => 스탬프 등록 :" );
	    	} else {
	    		resultMap.put("status",false);
	    		resultMap.put("msg","이미 등록된 스탬프입니다");
	    		log.info("insertStamp => 이미함 :" );
	    	}
	    }
	    return resultMap;
    }

    /**
     * 우편번호, 도로명 체크
     */
    @PostMapping("/check-area")
	public Map<String, Object> checkArea(@RequestBody Map<String, Object> latlon) {
	    Map<String, Object> resultMap = new HashMap<>();

	    System.out.println("[요청 좌표] " + latlon);

	    Map<String, Object> areaMap = stampService.checkArea(latlon);
	    Map<String, Object> roadMap = stampService.checkRoad(latlon);

	    convertClobToString(areaMap);
	    convertClobToString(roadMap);

	    System.out.println("[지역 정보] " + areaMap);
	    System.out.println("[도로 정보] " + roadMap);

	    resultMap.put("location", latlon);
	    resultMap.put("area", areaMap != null ? areaMap.get("AREA_ID") : "00000");
	    resultMap.put("road", roadMap != null ? roadMap.get("ROAD_ID") : "00000");
	    
	    System.out.println("[resultMap] " + resultMap);
	    
	    List<StStampVO> stampList = stampService.stampInfoByAreaAndRoad(resultMap);
	    
		if(stampList != null && !stampList.isEmpty()) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
	    return resultMap;
	}
	
	
	/**
     * 스탬프랭크
     */
    @GetMapping("/stamp-lank")
	public List<Map<String, Object>> stampLank() {
	    List<Map<String, Object>> stampRankList = stampService.stampRankList();
	    
	    log.info("stampRankList",stampRankList);
	    log.info("stampRankList",stampRankList.size());
	    
	    return stampRankList;
	}
	
	

	private void convertClobToString(Map<String, Object> map) {
	    if (map == null) return;
	    for (Map.Entry<String, Object> entry : map.entrySet()) {
	        if (entry.getValue() instanceof Clob) {
	            try {
	                Clob clob = (Clob) entry.getValue();
	                entry.setValue(clob.getSubString(1, (int) clob.length()));
	            } catch (SQLException e) {
	                log.error("CLOB to String conversion failed", e);
	                entry.setValue(null);
	            }
	        }
	    }
	}
	
	/**
     * 대전 내 상점
     */
	@GetMapping("/select-store")
    public ResponseEntity<List<Map<String,Object>>> selectStore(@RequestParam Map<String, Object> param, @AuthenticationPrincipal CustomUser customUser) {
        if (customUser == null) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        String userId = customUser.getUsersVO().getUserId();
        param.put("userId", userId);
        
        List<Map<String,Object>> storeList = stampService.selectStore(param);
        System.out.println(storeList);
        
        return new ResponseEntity<>(storeList, HttpStatus.OK);
    }
	
	/**
     * 상점 관심
     */
	@PostMapping("/storeLike")
	public Map<String, Object> storeLike(@RequestBody Map<String, Object> info, @AuthenticationPrincipal CustomUser customUser) {
		Map<String, Object> resultMap = new HashMap<>();
		
		if (customUser == null) {
            return resultMap;
        }
		
        String userId = customUser.getUsersVO().getUserId();
        info.put("userId", userId);
        
        int storeList = stampService.storeLike(info);
        
        if(storeList > 0) {
        	resultMap.put("msg", "정상처리되었습니다.");
        }else {
        	resultMap.put("msg", "안됨.");
        }
        
        return resultMap;
    }
}
