package kr.or.ddit.admin.stats.system.mapper;

import kr.or.ddit.admin.stats.system.vo.LoggingEventVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface SystemLogMapper {

    /**
     * 조건에 맞는 로그 총 개수
     * params:
     *   searchStartDate, searchEndDate : "YYYY-MM-DD" (둘 다 있으면 범위, 하나만 있으면 그 날 하루)
     *   levelString, loggerName, keyword, category  : 선택
     */
    int countLogs(Map<String, Object> params);

    /**
     * 조건 + 페이징 검색
     * params:
     *   offset, size : 페이징
     *   그 외 count와 동일한 필터
     */
    List<LoggingEventVO> findLogs(Map<String, Object> params);

	Map<String, Object> selectLogLevelSummary();
}
