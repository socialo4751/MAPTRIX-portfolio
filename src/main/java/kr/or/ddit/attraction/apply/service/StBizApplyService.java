package kr.or.ddit.attraction.apply.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.common.vo.user.UsersVO;

public interface StBizApplyService {

	int insertStBizApply(StBizApplyVO info);

	List<StBizApplyVO> stBizApplyList(StBizApplyVO info);

	int updateStBizApply(StBizApplyVO info);

	List<StBizApplyVO> getStBizApplyList(Map<String, Object> paramMap);
	
    int getStBizApplyCount(Map<String, Object> paramMap);
    Map<String, Object> getStatusSummary();

	//통계
	List<Map<String, Object>> getStBizApplyStatsList();

}
