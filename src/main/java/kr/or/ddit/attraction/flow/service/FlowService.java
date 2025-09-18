package kr.or.ddit.attraction.flow.service;

import java.util.Map;

//(2025.08.10 장세진) 구조 리팩토링 => Stamp,Point,Flow,Apply 기능별 분리
//메소드 세부로직과 url은 변경사항 없음.

public interface FlowService {

	boolean insertLocation(String body, String body2);

	boolean insertOnlyLocation(String body, String body2);
	
	Long locationGroupInsert(String userId, String body);

	Map<String, Object> getDayMyFlow(Map<String, Object> resultMap);

	Double dayFlowKm(Map<String, Object> resultMap);

	Double getTotalDistance(Map<String, Object> resultMap);

	Double getClaimedDistance(Map<String, Object> resultMap);
	
}
