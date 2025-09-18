package kr.or.ddit.attraction.stamp.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.attraction.stamp.mapper.StampMapper;
import kr.or.ddit.attraction.stamp.service.StampService;
import kr.or.ddit.attraction.stamp.vo.StCardVO;
import kr.or.ddit.attraction.stamp.vo.StStampVO;
import lombok.extern.slf4j.Slf4j;

//(2025.08.10 장세진) 구조 리팩토링 => Stamp,Point,Flow,Apply 기능별 분리
//메소드로직과 url은 변경사항 없음.

@Slf4j
@Service
public class StampServiceImpl implements StampService {

	@Autowired
	private StampMapper stampMapper;

	@Override
	public List<StStampVO> getDayStamp(Map<String, Object> map) {
		return stampMapper.getDayStamp(map);
	}
	
	@Override
	public Map<String, Object> checkArea(Map<String, Object> latlon) {
		System.out.println(stampMapper.checkArea(latlon));
		return stampMapper.checkArea(latlon);
	}

	@Override
	public Map<String, Object> checkRoad(Map<String, Object> latlon) {
		return stampMapper.checkRoad(latlon);
	}

	@Override
	public int insertStamp(StStampVO body) {
		return stampMapper.insertStamp(body);
	}

	@Override
	public int insertStampCard(StCardVO card) {
		return stampMapper.insertStampCard(card);
	}

	@Override
	public StCardVO checkStampCard(StStampVO stampInfo) {
		return stampMapper.checkStampCard(stampInfo);
	}

	@Override
	public StStampVO checkStamp(StStampVO stampInfo) {
		return stampMapper.checkStamp(stampInfo);
	}

	@Override
	public List<StStampVO> myStampByCode(Map<String, Object> param) {
		return stampMapper.myStampByCode(param);
	}

	@Override
	public List<StStampVO> stampInfoByAreaAndRoad(Map<String, Object> resultMap) {
		return stampMapper.stampInfoByAreaAndRoad(resultMap);
	}

	@Override
	public List<Map<String, Object>> selectStore(Map<String, Object> param) {
		return stampMapper.selectStore(param);
	}

	@Override
	public int storeLike(Map<String, Object> info) {
		return stampMapper.storeLike(info);
	}

	@Override
	public List<Map<String, Object>> stampRankList() {
		return stampMapper.stampRankList();
	}

    // 포인트 관련 메서드(getTotalPoint, processPoint, getPointLog)는 모두 PointServiceImpl로 이동하여 삭제됨
}
