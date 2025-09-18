package kr.or.ddit.admin.stats.system.service;

import java.util.Map;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.admin.stats.system.vo.LoggingEventVO;

public interface SystemLogService {
    /**
     * 조건에 맞는 로그 목록과 페이징 정보를 조회합니다.
     * @param params (currentPage, keyword, category, searchStartDate, searchEndDate 등)
     * @return ArticlePage 객체 (페이징 정보와 로그 목록 포함)
     */
    public ArticlePage<LoggingEventVO> getLogList(Map<String, Object> params);
    
    /**
     * @method Name : getLogLevelSummary
     * @Description : 로그 레벨별 건수를 조회한다.
     * @return : 레벨별 건수(TOTAL, ERROR, WARN 등)를 담은 Map
     */
    Map<String, Object> getLogLevelSummary();
}