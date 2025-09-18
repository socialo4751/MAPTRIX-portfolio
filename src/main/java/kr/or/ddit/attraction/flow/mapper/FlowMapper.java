package kr.or.ddit.attraction.flow.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.attraction.flow.vo.StFlowLogVO;


@Mapper
public interface FlowMapper  {
	public int insertPloyId(Map<String, Object> map);

	public int insertLocation(Map<String, Object> map);

	public List<StFlowLogVO> dayFlow(Map<String, Object> resultMap);

	public Double dayFlowKm(Map<String, Object> resultMap);

	public Double getClaimedDistance(Map<String, Object> map);
}
