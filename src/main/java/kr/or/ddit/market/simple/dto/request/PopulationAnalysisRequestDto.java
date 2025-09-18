package kr.or.ddit.market.simple.dto.request;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import lombok.Data;

/**
 * [간단분석] (인구 통계 해석 관련)
 * 간단분석 - 인구 통계 AI 분석을 위해 클라이언트로부터 받는 요청 데이터를 담는 DTO
 */
@Data
public class PopulationAnalysisRequestDto {
    private List<Map<String, Object>> populationStats;
    private List<CodeDetailVO> sgisCodes;
}