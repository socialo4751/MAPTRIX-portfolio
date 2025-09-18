package kr.or.ddit.admin.main.service.impl;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import kr.or.ddit.admin.main.mapper.AdminDashboardMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import kr.or.ddit.admin.main.service.AdminDashboardService;
import kr.or.ddit.user.signin.mapper.UsersMapper;
import kr.or.ddit.cs.qna.mapper.CsQnaPostMapper;
import kr.or.ddit.cs.notice.mapper.CsNoticePostMapper;
import kr.or.ddit.admin.stats.market.mapper.MarketStatsMapper;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;

@Slf4j
@Service
@RequiredArgsConstructor
public class AdminDashboardServiceImpl implements AdminDashboardService {

    private final AdminDashboardMapper adminDashboardMapper; // ✅ 대시보드 전용
    private final UsersMapper usersMapper;                   // 전체/7일 가입수만 사용
    private final CsQnaPostMapper qnaMapper;
    private final CsNoticePostMapper noticeMapper;
    private final MarketStatsMapper marketStatsMapper;

    @Override
    public Map<String, Object> getKpis() {
        Map<String, Object> out = new LinkedHashMap<>();

        // 전체 회원수
        int totalUsers = Optional.ofNullable(usersMapper.getUsersCount(new HashMap<>()))
                .orElse(0);
        out.put("totalUsers", totalUsers);

        // ✅ 7일 신규 — 대시보드 매퍼 사용
        String start = LocalDate.now().minusDays(6).toString();
        String end   = LocalDate.now().toString();
        int newUsers7d = Optional.ofNullable(
                adminDashboardMapper.selectSignupCountBetween(start, end)
        ).orElse(0);
        out.put("newUsers7d", newUsers7d);

        // 미답변 Q&A
        int qnaUnanswered = Optional.ofNullable(qnaMapper.selectQnaCountByAnsweredYn("N"))
                .orElse(0);
        out.put("qnaUnanswered", qnaUnanswered);

        // 금주 상권분석 실행 수 (월~오늘)
        String from = LocalDate.now().with(DayOfWeek.MONDAY).toString();
        String to = LocalDate.now().toString();
        int lmaWeek = Optional.ofNullable(
                marketStatsMapper.selectLogCount(from, to, null, null, null, null, null)
        ).orElse(0);
        out.put("marketAnalysisWeek", lmaWeek);

        // 24h ERROR (LOGGING_EVENT.TIMESTMP ms)
        var now = java.time.Instant.now();
        long toMs = now.toEpochMilli();
        long fromMs = now.minus(java.time.Duration.ofHours(24)).toEpochMilli();
        int error24h = Optional.ofNullable(
                adminDashboardMapper.selectErrorCountBetweenMs(fromMs, toMs)
        ).orElse(0);
        out.put("error24h", error24h);

        return out;
    }

    @Override
    public List<Map<String, Object>> getSignupTrend() {
        String from = LocalDate.now().minusDays(29).toString();
        String to = LocalDate.now().toString();

        // ✅ 대시보드 매퍼 사용
        List<Map<String, Object>> raw = Optional.ofNullable(
                adminDashboardMapper.selectDailySignupTrend(from, to)
        ).orElseGet(ArrayList::new);

        // 빈 날짜 0 보정
        Map<String, Integer> byDate = raw.stream().collect(Collectors.toMap(
                m -> String.valueOf(m.get("DT")),
                m -> ((Number) m.get("CNT")).intValue(),
                (a, b) -> a, LinkedHashMap::new
        ));

        List<Map<String, Object>> filled = new ArrayList<>();
        LocalDate cur = LocalDate.parse(from);
        LocalDate end = LocalDate.parse(to);
        while (!cur.isAfter(end)) {
            String key = cur.toString();
            filled.add(Map.of("DT", key, "CNT", byDate.getOrDefault(key, 0)));
            cur = cur.plusDays(1);
        }
        return filled;
    }

    @Override
    public Map<String, Integer> getLogLevel24h() {
        var now = java.time.Instant.now();
        long toMs = now.toEpochMilli();
        long fromMs = now.minus(java.time.Duration.ofHours(24)).toEpochMilli();

        // ✅ 대시보드 매퍼 사용
        var rows = Optional.ofNullable(
                adminDashboardMapper.selectLogLevelCountsBetweenMs(fromMs, toMs)
        ).orElse(Collections.emptyList());

        Map<String, Integer> result = new LinkedHashMap<>();
        result.put("INFO", 0);
        result.put("WARN", 0);
        result.put("ERROR", 0);

        for (var r : rows) {
            String lv = String.valueOf(r.get("LV"));
            Number n = (Number) r.get("CNT");
            if (result.containsKey(lv) && n != null) result.put(lv, n.intValue());
        }
        return result;
    }

    @Override
    public List<Map<String, Object>> getTodoQna() {
        Map<String, Object> p = new HashMap<>();
        p.put("answeredYn", "N");
        p.put("startRow", 1);
        p.put("endRow", 5);

        List<CsQnaPostVO> list = Optional.ofNullable(
                qnaMapper.selectQnasByAnsweredYnPaged(p)
        ).orElseGet(ArrayList::new);

        List<Map<String, Object>> out = new ArrayList<>();
        for (CsQnaPostVO vo : list) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("title", vo.getTitle());
            row.put("writer", vo.getWriterName());
            row.put("createdAt", vo.getCreatedAt());
            out.add(row);
        }
        return out;
    }

    @Override
    public List<Map<String, Object>> getRecentNotice() {
        return Optional.ofNullable(noticeMapper.selectRecentNotices(5))
                .orElseGet(ArrayList::new)
                .stream()
                .map(vo -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("title", String.valueOf(((Map<?, ?>) vo).get("TITLE")));
                    m.put("createdAt", ((Map<?, ?>) vo).get("CREATED_AT"));
                    return m;
                }).toList();
    }
}
