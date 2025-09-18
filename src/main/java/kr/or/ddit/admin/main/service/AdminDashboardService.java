package kr.or.ddit.admin.main.service;

import java.util.List;
import java.util.Map;

public interface AdminDashboardService {
    Map<String, Object> getKpis();                 // KPI 카드
    List<Map<String, Object>> getSignupTrend();    // 최근 30일 가입 추이
    Map<String, Integer> getLogLevel24h();         // 24h 로그 레벨 분포
    List<Map<String, Object>> getTodoQna();        // 미답변 Q&A Top5
    List<Map<String, Object>> getRecentNotice();   // 최근 공지 Top5
}