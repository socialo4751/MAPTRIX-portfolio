package kr.or.ddit.admin.stats.system.service.impl;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.or.ddit.admin.stats.system.mapper.SystemLogMapper;
import kr.or.ddit.admin.stats.system.service.SystemLogService;
import kr.or.ddit.admin.stats.system.vo.LoggingEventVO;
import kr.or.ddit.common.util.ArticlePage;

@Service
public class SystemLogServiceImpl implements SystemLogService {

    @Autowired
    private SystemLogMapper systemLogMapper;

    @Override
    public ArticlePage<LoggingEventVO> getLogList(Map<String, Object> params) {
        int size = 15; // 한 페이지에 보여줄 로그 수를 15개로 설정
        
        // 파라미터에서 현재 페이지 번호 가져오기 (값이 없으면 1)
        int currentPage = Integer.parseInt(params.getOrDefault("currentPage", "1").toString());

        // MyBatis 페이징 쿼리를 위한 offset 계산
        params.put("size", size);
        params.put("offset", (currentPage - 1) * size);

        // 1. 조건에 맞는 전체 로그 수 구하기
        int total = systemLogMapper.countLogs(params);

        // 2. 조건에 맞는 로그 목록 가져오기 (페이징 적용)
        List<LoggingEventVO> content = systemLogMapper.findLogs(params);
        
        // ArticlePage 생성자에 전달할 검색어
        String keyword = params.getOrDefault("keyword", "").toString();

        // 3. 최종적으로 페이징 정보와 데이터가 담긴 ArticlePage 객체를 생성하여 반환
        return new ArticlePage<>(total, currentPage, size, content, keyword);
    }
    
    @Override
    public Map<String, Object> getLogLevelSummary() {
        return systemLogMapper.selectLogLevelSummary();
    }
}