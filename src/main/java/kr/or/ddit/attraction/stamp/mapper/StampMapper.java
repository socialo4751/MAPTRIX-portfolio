package kr.or.ddit.attraction.stamp.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.attraction.stamp.vo.StCardVO;
import kr.or.ddit.attraction.stamp.vo.StStampVO;

//(2025.08.10 장세진) 구조 리팩토링 => PointMapper와 StampMapper 메소드 분리

@Mapper
public interface StampMapper  {
    //--- 위치 정보 관련 ---
	Map<String,Object> checkArea(Map<String, Object> latlon);
	Map<String,Object> checkStore(Map<String, Object> latlon);
	Map<String, Object> checkRoad(Map<String, Object> latlon);
	
    //--- 스탬프 정보 조회 ---
	List<StStampVO> getDayStamp(Map<String, Object> map);
	List<StStampVO> myStampByCode(Map<String, Object> param);
	List<StStampVO> stampInfoByAreaAndRoad(Map<String, Object> resultMap);
	StStampVO checkStamp(StStampVO stampInfo);
	
    //--- 스탬프 카드 관련 ---
	int insertStampCard(StCardVO card);
	StCardVO checkStampCard(StStampVO stampInfo);
	
    //--- 스탬프 생성 ---
	int insertStamp(StStampVO body);
	
	//--- 상점 정보 관련 ---
	List<Map<String, Object>> selectStore(Map<String, Object> param);
	
	//상점 관심
	int storeLike(Map<String, Object> info);
	
	//스탬프 랭크
	List<Map<String, Object>> stampRankList();

}
