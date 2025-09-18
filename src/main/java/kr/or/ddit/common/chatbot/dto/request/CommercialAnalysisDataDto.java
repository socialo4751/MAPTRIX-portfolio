package kr.or.ddit.common.chatbot.dto.request;

import java.util.Map;
import lombok.Data;

// DB에서 조회한 모든 통계 데이터를 Gemini 프롬프트에 전달하기 위해 하나로 묶는 DTO

@Data
public class CommercialAnalysisDataDto {
    // 분석 기본 정보
    private String dongName;
    private String bizName;
    private Integer statsYear;

    // 특정 동(Dong)의 데이터
    private Map<String, Object> dongStats;
    
    // 대전 전체(Overall)의 평균 데이터
    private Map<String, Object> overallStats;
}
