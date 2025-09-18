package kr.or.ddit.admin.stats.market.service;

import kr.or.ddit.admin.stats.market.vo.LogMarketAnalysisVO;

public interface LogMarketAnalysisService {

    /**
     * 상권 분석 실행 이벤트를 로그로 기록합니다.
     * @param log 기록할 로그 데이터
     */
    void logMarketAnalysis(LogMarketAnalysisVO log);
}