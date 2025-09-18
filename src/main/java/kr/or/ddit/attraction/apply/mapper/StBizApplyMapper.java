package kr.or.ddit.attraction.apply.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.attraction.apply.vo.StBizApplyVO;

@Mapper
public interface StBizApplyMapper {
	int insertStBizApply(StBizApplyVO info);

	List<StBizApplyVO> stBizApplyList(StBizApplyVO info);

	int updateStBizApply(StBizApplyVO info);

	List<StBizApplyVO> getStBizApplyList(Map<String, Object> paramMap);

	int selectStoreApplyId();

	int insertStore(StBizApplyVO info);

	int selectStBizApplyCount(Map<String, Object> paramMap);

	Map<String, Object> selectStBizApplyStatusSummary();

	List<Map<String, Object>> getStBizApplyStatsList();
	
	StBizApplyVO selectApplyById(int applyId);

}
