package kr.or.ddit.admin.stats.market.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.admin.stats.market.vo.LogMarketAnalysisVO;

@Mapper
public interface LogMarketAnalysisMapper {
    
    /**
     * 상권 분석 실행 로그를 DB에 저장합니다.
     * @param log 저장할 로그 데이터
     * @return 성공 시 1
     */
    int insertMarketAnalysisLog(LogMarketAnalysisVO log);
}