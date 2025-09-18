package kr.or.ddit.admin.stats.user.controller;

import java.text.DecimalFormat;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.admin.stats.user.mapper.UserStatsMapper;
import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
public class UserStatsApiController {

    private final UserStatsMapper userStatsMapper;

    private static final DecimalFormat INT_FMT = new DecimalFormat("#,###");

    @GetMapping(value = "/api/admin/stats/users/all-data", produces = MediaType.APPLICATION_JSON_VALUE)
    public Map<String, Object> getAllData(
            @RequestParam String from,
            @RequestParam String to) {

        Map<String, Object> res = new LinkedHashMap<>();

        // 1) KPI 요약
        Map<String, Object> kpiRaw = userStatsMapper.selectKpiSummaryFromStatsDaily(from, to);
        List<Map<String, Object>> kpiSummary = buildKpiSummary(from, to);
        res.put("kpiSummary", kpiSummary);

        // 2) 분석 사용량 (간단/상세)
        Map<String, Object> analysisRow = userStatsMapper.selectAnalysisBreakdown(from, to);
        Map<String, Object> analysis = new HashMap<>();
        analysis.put("simple",  n(get(analysisRow, "SIMPLE_CNT")));
        analysis.put("detailed",n(get(analysisRow, "DETAILED_CNT")));
        res.put("analysis", analysis);

        // 3) OpenAPI 호출량
        List<Map<String, Object>> apiRows = userStatsMapper.selectOpenApiCallsByFeature(from, to);
        Map<String, Object> openapi = new LinkedHashMap<>();
        for (Map<String, Object> r : apiRows) {
            String feature = s(get(r, "FEATURE"));
            long cnt = n(get(r, "CNT"));
            openapi.put(feature, cnt);
        }
        res.put("openapi", openapi);

        // 4) 커뮤니티 글/댓글 CUD
        Map<String, Object> community = buildCommunityBlock(
                userStatsMapper.selectCommunityPostCounts(from, to),
                userStatsMapper.selectCommunityCommentCounts(from, to)
        );
        res.put("community", community);

        // 5) 디자인(도면)
        Map<String, Object> designRow = userStatsMapper.selectDesignCounts(from, to);
        Map<String, Object> design = new HashMap<>();
        design.put("save",   n(get(designRow, "SAVE_CNT")));
        design.put("clone",  n(get(designRow, "CLONE_CNT")));
        design.put("delete", n(get(designRow, "DELETE_CNT")));
        res.put("design", design);

        // 6) 참여(스탬프 평균, 포인트 정산 횟수)
        Map<String, Object> sp = userStatsMapper.selectStampPointKpis(from, to);
        Map<String, Object> engagement = new HashMap<>();
        engagement.put("stampAvg",   get(sp, "STAMP_AVG") == null ? 0 : sp.get("STAMP_AVG")); // double(반올림값)
        engagement.put("totalPoints", n(get(sp, "TOTAL_POINTS")));
        res.put("engagement", engagement);

        // (옵션) 더 많은 지표를 이 res에 붙여도 OK (avgSession, dau/wau/mau, retention 등)

        return res;
    }

    // ------------------------
    // 헬퍼들
    // ------------------------

    private List<Map<String, Object>> buildKpiSummary(String from, String to) {
        LocalDate f = LocalDate.parse(from);
        LocalDate t = LocalDate.parse(to);
        long days = ChronoUnit.DAYS.between(f, t) + 1;

        LocalDate pf = f.minusDays(days);
        LocalDate pt = f.minusDays(1);

        // 1) MAU (to 기준 최근 30일)
        int mau  = userStatsMapper.selectMAU(to);
        int mauP = userStatsMapper.selectMAU(pt.toString());

        // 2) 신규/탈퇴
        int newUsers  = userStatsMapper.selectNewUsersCount(from, to);
        int newUsersP = userStatsMapper.selectNewUsersCount(pf.toString(), pt.toString());

        int churn  = userStatsMapper.selectChurnUsers(from, to);
        int churnP = userStatsMapper.selectChurnUsers(pf.toString(), pt.toString());

        // 3) 고착도 = (최근 기간 평균 DAU / MAU) * 100
        int dauSum  = userStatsMapper.selectDAU(from, to);                   // STATS_USER_DAILY 합계
        int dauSumP = userStatsMapper.selectDAU(pf.toString(), pt.toString());

        double avgDau  = days == 0 ? 0 : (dauSum  / (double) days);
        long   daysP   = ChronoUnit.DAYS.between(pf, pt) + 1;
        double avgDauP = daysP == 0 ? 0 : (dauSumP / (double) daysP);

        double stick   = mau  == 0 ? 0 : (avgDau  / mau ) * 100.0;
        double stickP  = mauP == 0 ? 0 : (avgDauP / mauP) * 100.0;

        // 4) 리텐션 (D7/D30/D90)
        Map<String, Object> ret   = userStatsMapper.selectRetention(from, to);
        Map<String, Object> retP  = userStatsMapper.selectRetention(pf.toString(), pt.toString());
        int cohort   = asInt(ret.get("COHORT_SIZE"));
        int cohortP  = asInt(retP.get("COHORT_SIZE"));

        double d7   = pctOf(asInt(ret.get("D7_RET")),  cohort);
        double d30  = pctOf(asInt(ret.get("D30_RET")), cohort);
        double d90  = pctOf(asInt(ret.get("D90_RET")), cohort);

        double d7P  = pctOf(asInt(retP.get("D7_RET")),  cohortP);
        double d30P = pctOf(asInt(retP.get("D30_RET")), cohortP);
        double d90P = pctOf(asInt(retP.get("D90_RET")), cohortP);

        // 5) 평균 세션 유지시간 (초)
        double sessSec   = nvl(userStatsMapper.selectAvgSessionSeconds(from, to));
        double sessSecP  = nvl(userStatsMapper.selectAvgSessionSeconds(pf.toString(), pt.toString()));

        // === 화면 예시 형태로 반환 ===
        return List.of(
            kpi("월간 활성 사용자 (MAU)", comma(mau),   deltaPct(mau, mauP),                 toneUpGood(mau, mauP), false),
            kpi("신규 가입자 수",          comma(newUsers), deltaPct(newUsers, newUsersP),     toneUpGood(newUsers, newUsersP), false),
            kpi("탈퇴 사용자 수",          comma(churn),    deltaPct(churn, churnP),          toneDownGood(churn, churnP),    false),
            kpi("고착도 (DAU/MAU)",       fmtPct(stick),   deltaPct(stick, stickP),           toneUpGood(stick, stickP),      false),
            kpi("7일 리텐션 (D7)",        fmtPct(d7),      deltaPp(d7, d7P),                  toneUpGood(d7, d7P),            false),
            kpi("30일 리텐션 (D30)",      fmtPct(d30),     deltaPp(d30, d30P),                toneUpGood(d30, d30P),          false),
            kpi("90일 리텐션 (D90)",      fmtPct(d90),     deltaPp(d90, d90P),                toneUpGood(d90, d90P),          false),
            kpi("평균 세션 유지시간",      fmtDur((long)sessSec), deltaSec(sessSec, sessSecP), toneUpGood(sessSec, sessSecP),  true)
        );
    }

    private Map<String, Object> kpi(String title, String value, String change, String status, boolean small) {
        Map<String, Object> m = new HashMap<>();
        m.put("title", title);
        m.put("value", value);
        m.put("change", change);   // "+5.2%" / "-1.8%"/ "+12초" / "-08초" 등
        m.put("status", status);   // "success" or "danger"
        if (small) m.put("small", true);
        return m;
    }

    // ===== 유틸 =====
    private static int asInt(Object o){ return o==null?0:((Number)o).intValue(); }
    private static double nvl(Double d){ return d==null?0d:d; }
    private static String comma(int n){ return String.format("%,d", n); }

    private static String deltaPct(double cur, double prev){
        if (prev<=0 && cur>0) return "+∞%";
        if (prev==0 && cur==0) return "0%";
        double v=((cur-prev)/prev)*100.0;
        return ((v>=0)?"+":"") + String.format(Locale.KOREA, "%.1f%%", v);
    }
    private static String deltaPp(double cur, double prev){
        double v = cur - prev;
        return (v >= 0 ? "+" : "-") + String.format(Locale.KOREA, "%.1f%%p", Math.abs(v));
    }
    private static String deltaSec(double curSec, double prevSec){
        long diff = Math.round(curSec - prevSec);
        String sign = diff>=0?"+":"-";
        long s = Math.abs(diff);
        return sign + (s>=60? (s/60)+"분 "+(s%60)+"초" : s+"초");
    }
    private static String toneUpGood(double cur, double prev){
        return cur>=prev ? "success" : "danger";
    }
    private static String toneDownGood(double cur, double prev){
        return cur<=prev ? "success" : "danger";
    }
    private static String fmtPct(double v){
        return String.format(Locale.KOREA, "%.1f%%", v);
    }
    private static double pctOf(int part, int total){
        return total<=0 ? 0 : (part*100.0/total);
    }
    private static String fmtDur(long sec){
        long m = sec/60; long s = sec%60;
        return String.format("%d분 %02d초", m, s);
    }


    private Map<String, Object> kpiCard(String title, long value, String change, String status, boolean small) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("title", title);
        m.put("value", INT_FMT.format(value));
        m.put("change", change);      // "+12%" / "-5%" / "0%"
        m.put("status", status);      // "success" / "danger" / "secondary"
        m.put("small", small);        // 폰트 작게 렌더
        return m;
    }

    private Map<String, Object> buildCommunityBlock(List<Map<String, Object>> posts, List<Map<String, Object>> comments) {
        // 초기 골격
        Map<String, Object> block = new LinkedHashMap<>();
        block.put("free",   initCommNode());
        block.put("review", initCommNode());
        block.put("show",   initCommNode());

        // 글 CUD
        for (Map<String, Object> r : posts) {
            String f = s(get(r, "FEATURE"));
            String key = switch (f) {
                case "FREE"   -> "free";
                case "REVIEW" -> "review";
                case "SHOW"   -> "show";
                default       -> null;
            };
            if (key == null) continue;
            Map<String, Object> node = cast(block.get(key));
            Map<String, Object> post = cast(node.get("post"));
            post.put("c", n(get(r, "C_CNT")));
            post.put("u", n(get(r, "U_CNT")));
            post.put("d", n(get(r, "D_CNT")));
        }

        // 댓글 CUD
        for (Map<String, Object> r : comments) {
            String f = s(get(r, "FEATURE"));
            String key = switch (f) {
                case "FREE_COMMENT"   -> "free";
                case "REVIEW_COMMENT" -> "review";
                case "SHOW_COMMENT"   -> "show";
                default               -> null;
            };
            if (key == null) continue;
            Map<String, Object> node = cast(block.get(key));
            Map<String, Object> cmt  = cast(node.get("comment"));
            cmt.put("c", n(get(r, "C_CNT")));
            cmt.put("u", n(get(r, "U_CNT")));
            cmt.put("d", n(get(r, "D_CNT")));
        }

        return block;
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> cast(Object o) { return (Map<String, Object>) o; }

    private Map<String, Object> initCommNode() {
        Map<String, Object> node = new LinkedHashMap<>();
        Map<String, Object> post = new LinkedHashMap<>();
        Map<String, Object> cmt  = new LinkedHashMap<>();
        post.put("c", 0); post.put("u", 0); post.put("d", 0);
        cmt.put("c", 0);  cmt.put("u", 0);  cmt.put("d", 0);
        node.put("post", post);
        node.put("comment", cmt);
        return node;
    }

    private static Object get(Map<String, Object> m, String key) {
        return m == null ? null : m.get(key);
    }

    private static String s(Object o) { return o == null ? null : String.valueOf(o); }

    private static long n(Object o) {
        if (o == null) return 0L;
        if (o instanceof Number num) return num.longValue();
        try { return Long.parseLong(String.valueOf(o)); } catch (Exception e) { return 0L; }
    }

    private static String pct(long curr, long prev) {
        if (prev <= 0 && curr <= 0) return "0%";
        if (prev <= 0) return "+100%";
        double v = (curr - prev) * 100.0 / prev;
        String sign = v > 0.0001 ? "+" : (v < -0.0001 ? "" : "");
        return sign + String.format("%.0f%%", v);
    }

    private static String tone(long curr, long prev) {
        if (curr > prev) return "success";
        if (curr < prev) return "danger";
        return "secondary";
    }
}
