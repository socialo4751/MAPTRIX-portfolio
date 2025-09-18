package kr.or.ddit.market.simple.dto.request;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import lombok.Data;

/**
 * [간단분석] (주택 통계 해석 관련)
 * 간단분석 - 주택 통계 AI 분석을 위해 클라이언트로부터 받는 요청 데이터를 담는 DTO
 */
@Data
public class HousingAnalysisRequestDto {

    /**
     * 주택 관련 통계 데이터 리스트 (예: [{sgisCode: "HOU001", statsValue: "12345"}, ...])
     */
    private List<Map<String, Object>> housingStats;

    /**
     * SGIS 코드-이름 매핑 정보 리스트
     */
    private List<CodeDetailVO> sgisCodes;
}