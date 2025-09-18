package kr.or.ddit.admin.main.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdminDashboardMapper {

    /** 최근 N일 가입 추이 (startDate, endDate: YYYY-MM-DD) */
    List<Map<String,Object>> selectDailySignupTrend(
            @Param("startDate") String startDate,
            @Param("endDate")   String endDate
    );

    /** 최근 24h 로그 레벨 분포 (LOGGING_EVENT.LEVEL_STRING, TIMESTMP: ms) */
    List<Map<String,Object>> selectLogLevelCountsBetweenMs(
            @Param("fromMs") long fromMs,
            @Param("toMs")   long toMs
    );

    /** 최근 24h ERROR 개수 */
    Integer selectErrorCountBetweenMs(
            @Param("fromMs") long fromMs,
            @Param("toMs")   long toMs
    );

    Integer selectSignupCountBetween(
            @org.apache.ibatis.annotations.Param("startDate") String startDate,
            @org.apache.ibatis.annotations.Param("endDate")   String endDate
    );
}
