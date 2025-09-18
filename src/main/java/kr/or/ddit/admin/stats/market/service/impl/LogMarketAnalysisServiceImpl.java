package kr.or.ddit.admin.stats.market.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.admin.stats.market.mapper.LogMarketAnalysisMapper;
import kr.or.ddit.admin.stats.market.service.LogMarketAnalysisService;
import kr.or.ddit.admin.stats.market.vo.LogMarketAnalysisVO;

@Service
public class LogMarketAnalysisServiceImpl implements LogMarketAnalysisService {

    @Autowired
    private LogMarketAnalysisMapper logMarketAnalysisMapper;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @Override
    public void logMarketAnalysis(LogMarketAnalysisVO log) {
        // 현재는 단순 호출이지만, 나중에 이 메소드 안에서
        // 로그 기록 전 추가적인 비즈니스 로직을 처리할 수 있습니다.
        logMarketAnalysisMapper.insertMarketAnalysisLog(log);
    }
}