package kr.or.ddit.market.simple.dto.request;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import lombok.Data;

/**
 * [간단분석] (가구 통계 해석 관련)
 * 간단분석 - AI 가구 통계 분석을 요청하기 위해 컨트롤러가 받는 DTO
 */
@Data
public class HouseholdAnalysisRequestDto {
    private List<Map<String, Object>> householdStats;
    private List<CodeDetailVO> sgisCodes;
}