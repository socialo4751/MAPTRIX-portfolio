package kr.or.ddit.market.simple.dto.request;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import lombok.Data;

// [간단분석] (통합 해석 관련)
// 간단분석 - ai 통합 해석
@Data
public class AiRequestDto {
    private Map<String, Object> analysisResult;
    private List<CodeDetailVO> sgisCodes;
}