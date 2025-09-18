package kr.or.ddit.attraction.stamp.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.attraction.stamp.vo.StCardVO;
import kr.or.ddit.attraction.stamp.vo.StStampVO;

public interface StampService {

	public Map<String,Object> checkArea(Map<String, Object> latlon);

	public Map<String, Object> checkRoad(Map<String, Object> latlon);

	public StCardVO checkStampCard(StStampVO stampInfo);
	
	public List<StStampVO> getDayStamp(Map<String, Object> map);

	public int insertStampCard(StCardVO card);
	
	public int insertStamp(StStampVO stampInfo);

	public StStampVO checkStamp(StStampVO stampInfo);

	public List<StStampVO> myStampByCode(Map<String, Object> param);

	public List<StStampVO> stampInfoByAreaAndRoad(Map<String, Object> resultMap);

	public List<Map<String, Object>> selectStore(Map<String, Object> param);

	public int storeLike(Map<String, Object> info);

	public List<Map<String, Object>> stampRankList();
	
}
