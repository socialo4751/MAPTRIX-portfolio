package kr.or.ddit.admin.stats.user.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserStatsMapper {

    // 1) KPI 요약(현재/이전 합계)
    Map<String, Object> selectKpiSummaryFromStatsDaily(
            @Param("from") String from,
            @Param("to") String to);

    // 2) 상권분석 간단/상세
    Map<String, Object> selectAnalysisBreakdown(
            @Param("from") String from,
            @Param("to") String to);

    // 3) OpenAPI 호출량 (FEATURE별)
    List<Map<String, Object>> selectOpenApiCallsByFeature(
            @Param("from") String from,
            @Param("to") String to);

    // 4) 커뮤니티 글 C/U/D
    List<Map<String, Object>> selectCommunityPostCounts(
            @Param("from") String from,
            @Param("to") String to);

    // 4) 커뮤니티 댓글 C/U/D
    List<Map<String, Object>> selectCommunityCommentCounts(
            @Param("from") String from,
            @Param("to") String to);

    // 5) 디자인(도면) SAVE/CLONE/DELETE
    Map<String, Object> selectDesignCounts(
            @Param("from") String from,
            @Param("to") String to);

    // 6) 스탬프 평균 / 포인트 정산 총횟수
    Map<String, Object> selectStampPointKpis(
            @Param("from") String from,
            @Param("to") String to);

    // (옵션) 심화 지표
    Double  selectAvgSessionMinutes(@Param("from") String from, @Param("to") String to);
    Integer selectDAU(@Param("from") String from, @Param("to") String to);
    Integer selectWAU(@Param("to") String to);
    Integer selectMAU(@Param("to") String to);
    Integer selectChurnUsers(@Param("from") String from, @Param("to") String to);
    Map<String, Object> selectRetention(@Param("from") String from, @Param("to") String to);
    
    /** 기간 내 신규 가입자 수 */
    int selectNewUsersCount(
            @Param("from") String from,
            @Param("to")   String to
    );

    /** 평균 세션 유지시간(초) */
    double selectAvgSessionSeconds(
            @Param("from") String from,
            @Param("to")   String to
    );
    
}
