package kr.or.ddit.market.detailed.service;

import kr.or.ddit.gemini.test.dto.example.GridDataVo;
import kr.or.ddit.gemini.test.dto.response.AnalysisDto;
import kr.or.ddit.market.detailed.dto.request.ClusterGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GravityGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GridAnalysisRequestDto;
import kr.or.ddit.market.detailed.dto.request.LogisticGridDataDto;
import kr.or.ddit.market.detailed.dto.response.ClusterAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GravityAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GridAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.LogisticAnalysisResponseDto;

public interface MarketDetailedService {

    /**
     * [상세분석] (다중회귀분석) 격자의 모든 속성 데이터를 받아 AI를 통해 심층 분석하고, 구조화된 리포트를 반환합니다.
     * @param requestDto 클라이언트가 클릭한 격자의 모든 데이터
     * @return AI가 생성한 상세 분석 리포트 DTO
     */
    GridAnalysisResponseDto analyzeGridByProperties(GridAnalysisRequestDto requestDto);

    /**
     * [상세분석] (군집분석) 특정 격자의 군집 분석 데이터를 받아 AI를 통해 심층 분석하고, 구조화된 리포트를 반환합니다.
     * @param requestDto 클라이언트가 클릭한 격자 정보 및 전체 군집 요약 정보
     * @return AI가 생성한 상세 분석 리포트 DTO
     */
    ClusterAnalysisResponseDto analyzeClusterGrid(ClusterGridDataDto requestDto);

    /**
     * [상세분석] (로지스틱 회귀분석) 특정 격자의 로지스틱 회귀분석 결과를 받아 AI를 통해 심층 분석하고, 구조화된 리포트를 반환합니다.
     * @param requestDto 클라이언트가 클릭한 격자의 로지스틱 분석 관련 데이터
     * @return AI가 생성한 상세 분석 리포트 DTO
     */
    LogisticAnalysisResponseDto analyzeLogisticGrid(LogisticGridDataDto requestDto);
    
    /**
     * [상세분석] (중력모델 분석) 특정 격자의 중력모델 분석 데이터를 받아 AI를 통해 심층 분석하고, 구조화된 리포트를 반환합니다.
     * @param requestDto 클라이언트가 클릭한 격자의 중력모델 관련 데이터
     * @return AI가 생성한 상세 분석 리포트 DTO
     */
    GravityAnalysisResponseDto analyzeGravityGrid(GravityGridDataDto requestDto);

    /**
     * [테스트용] 격자 데이터를 받아 Gemini API에 상권 분석을 요청하고, 구조화된 분석 결과를 받습니다.
     * @param gridData 분석에 필요한 원본 데이터 (격자 ID, p-value, 행정동 정보 등)
     * @return 제미나이 모델이 생성한 상권 분석 리포트(AnalysisDto)
     */
    AnalysisDto getAnalysisForGrid(GridDataVo gridData);
}
