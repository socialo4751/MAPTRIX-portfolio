package kr.or.ddit.attraction.flow.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.or.ddit.attraction.flow.mapper.FlowMapper;
import kr.or.ddit.attraction.flow.service.FlowService;
import kr.or.ddit.attraction.flow.vo.StFlowLogVO;
import lombok.extern.slf4j.Slf4j;

//(2025.08.10 장세진) 구조 리팩토링 => Stamp,Point,Flow,Apply 기능별 분리
//메소드 세부로직과 url은 변경사항 없음.

@Slf4j
@Service
public class FlowServiceImpl implements FlowService{

    private final ObjectMapper objectMapper;
	
	@Autowired
	private FlowMapper flowMapper;

    FlowServiceImpl(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
	
    @Override
	public boolean insertLocation(String userId, String body) {
		try {
			ObjectMapper mapper = new ObjectMapper();

			//위도경도
	        Map<String, Object> LocationMap = mapper.readValue(body, Map.class);
	        double lat = Double.parseDouble(LocationMap.get("lat").toString());
	        double lon = Double.parseDouble(LocationMap.get("lon").toString());
	        int idx = Integer.parseInt(LocationMap.get("idx").toString());
	        
			Map<String, Object> map = new HashMap<>();
			map.put("userId",userId);
	        
	        if(idx>0) {
	        	map.put("lat", lat);
	        	map.put("lon", lon);
	        	map.put("sessionId", idx);
	        	flowMapper.insertLocation(map);
	        	return true;
	        }else {
	        	log.info("insertOnlyLocation => 인서트된 폴리곤 아이디 없음|"+userId);
	        	return false;
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
    
	@Override
	public boolean insertOnlyLocation(String userId, String body) {
		try {
			ObjectMapper mapper = new ObjectMapper();

			//위도경도
	        Map<String, Object> LocationMap = mapper.readValue(body, Map.class);
	        double lat = Double.parseDouble(LocationMap.get("lat").toString());
	        double lon = Double.parseDouble(LocationMap.get("lon").toString());

			Map<String, Object> map = new HashMap<>();
			map.put("userId",userId);
	        
			//폴리곤집합아이디인서트
	        Long sn = locationGroupInsert(userId, body);
	        
	        if(sn>0) {
	        	map.put("lat", lat);
	        	map.put("lon", lon);
	        	map.put("sessionId", sn);
	        	flowMapper.insertLocation(map);
	        	return true;
	        }else {
	        	log.info("insertOnlyLocation => 인서트된 폴리곤 아이디 없음|"+userId);
	        	return false;
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public Long locationGroupInsert(String userId, String body) {
		try {
			Map<String, Object> map = new HashMap<>();
			map.put("userId",userId);
	        
			//폴리곤집합아이디인서트
	        int sn = flowMapper.insertPloyId(map);
	        
	        if(sn>0) {
	        	log.info("sessionId: {}", map.get("sessionId"));
	        	return (Long) map.get("sessionId");
	        }else {
	        	log.info("insertOnlyLocation => 인서트된 폴리곤 아이디 없음|"+userId);
	        	return -1L;
	        }
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	        return -1L;
	    }
	}

	@Override
	public Map<String, Object> getDayMyFlow(Map<String, Object> resultMap) {
		
		List<StFlowLogVO> flowLog = flowMapper.dayFlow(resultMap);
		
		log.info("flowLog "+flowLog);
		
		return null;
	}

	@Override
	public Double dayFlowKm(Map<String, Object> map) {
		return flowMapper.dayFlowKm(map);
	}

	@Override
	public Double getTotalDistance(Map<String, Object> map) {
		Map<String, Object> copyMap = new HashMap<>(map);
		copyMap.remove("day");//day라는 키를 제거한 맵으로 요청해서 모든 날짜의 거리값을 받음
		return flowMapper.dayFlowKm(copyMap);
	}

	@Override
	public Double getClaimedDistance(Map<String, Object> map) {
		return flowMapper.getClaimedDistance(map);
	}
	
}
