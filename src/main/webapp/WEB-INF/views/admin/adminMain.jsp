<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 대시보드</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- Bootstrap / Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- 프로젝트 공통 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">

    <!-- Chart.js -->
    <script src="${pageContext.request.contextPath}/assets/js/plugins/chartjs.min.js"></script>

    <style>
        .dashboard {
            padding: 24px 32px;
        }

        .kpi-card .label {
            font-size: 12px;
            color: #6b7280;
        }

        /* 카드 전체 클릭 표시 */
        .kpi-card.kpi-click { cursor: pointer; }
        .kpi-card.kpi-click:focus {
            outline: 2px solid #4f46e5;
            outline-offset: 2px;
        }

        .kpi-card .value {
            font-size: 28px;
            font-weight: 700;
        }

        .section-title {
            font-weight: 700;
            font-size: 18px;
            margin: 8px 0 16px;
        }

        .card {
            border-radius: 14px;
        }

        .mini-link {
            font-size: 12px;
            color: #64748b;
            text-decoration: none;
        }

        .mini-link:hover {
            text-decoration: underline;
        }

        .table thead th {
            font-size: 12px;
            color: #6b7280;
        }

        .todo-title {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 320px;
            display: inline-block;
        }

        .chart-box {
            position: relative;
            height: 280px;
        }

        .chart-box canvas {
            width: 100% !important;
            height: 100% !important;
            display: block;
        }

        .kpi-row > [class^="col-"] > .card.kpi-card {
            height: 125px;
        }

        /* QnA 표: 고정 레이아웃 + 열너비 + 말줄임 (옵션) */
        .qna-table {
            table-layout: fixed;
            width: 100%;
        }

        .qna-table th, .qna-table td {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 제목 span이 셀 너비 넘지 않도록 */
        .todo-title {
            display: block;
            max-width: 100% !important;
        }

        /* ===== KPI 리디자인 ===== */
        .kpi-card {
            border-radius: 14px;
            position: relative;
        }

        .kpi {
            display: flex;
            align-items: center;
            gap: 40px;
        }

        /* 우하단 고정 링크 */
        .kpi-quick {
            position: absolute;
            right: 16px;
            bottom: 12px;
            font-size: 15px;
            color: #64748b;
            text-decoration: none;
        }

        .kpi-quick:hover {
            text-decoration: underline;
        }

        .kpi-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: grid;
            place-items: center;
            font-size: 20px;
        }

        .kpi-body .label {
            font-size: 20px;
            color: #6b7280
        }

        .kpi-body .value {
            font-size: 30px;
            font-weight: 800;
            line-height: 1.0
        }

        .kpi-body .meta {
            margin-top: 4px;
            display: flex;
            gap: 8px;
            align-items: center
        }

        /* 색상 프리셋 */
        .kpi--users .kpi-icon {
            background: #eef2ff;
            color: #4f46e5
        }
        .kpi--qna .kpi-icon {
            background: #fff7ed;
            color: #f59e0b
        }
        .kpi--market .kpi-icon {
            background: #ecfeff;
            color: #0891b2
        }
        .kpi--error .kpi-icon {
            background: #fee2e2;
            color: #ef4444
        }

        /* 칩 스타일 */
        .chip {
            font-size: 15px;
            font-weight: 700;
            padding: 2px 8px;
            border-radius: 999px;
            display: inline-flex;
            gap: 6px;
            align-items: center;
        }

        .chip-success { background: #ecfdf5; color: #10b981 }
        .chip-warning { background: #fffbeb; color: #f59e0b }
        .chip-danger  { background: #fef2f2; color: #ef4444 }
        .chip-muted   { background: #f1f5f9; color: #475569 }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>
<!-- 전역 타임존을 KST로 설정 -->
<fmt:setTimeZone value="Asia/Seoul"/>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <main class="dashboard flex-grow-1">
        <!-- KPI (리디자인 적용) -->
        <div class="row g-3 kpi-row">
            <!-- 전체 회원 -->
            <div class="col-12 col-md-6 col-xl-3">
                <div class="card kpi-card p-4 kpi-click"
                     data-href="${pageContext.request.contextPath}/admin/users"
                     aria-label="회원 관리로 이동">
                    <div class="kpi kpi--users">
                        <div class="kpi-icon"><i class="bi bi-people"></i></div>
                        <div class="kpi-body">
                            <div class="label">전체 회원</div>
                            <div class="value"><c:out value="${kpis.totalUsers}"/>명</div>
                            <div class="meta">
                                <div class="kpi-quick">
                                    <span class="chip chip-success">
                                      <i class="bi bi-arrow-up-right"></i> 7일 +<c:out value="${kpis.newUsers7d}"/>명
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- 이 카드는 우하단 링크 없음 (카드 전체가 링크) -->
                </div>
            </div><!-- // 첫번째 KPI 컬럼 -->

            <!-- 미답변 Q&A -->
            <div class="col-12 col-md-6 col-xl-3">
                <div class="card kpi-card p-4 kpi-click"
                     data-href="${pageContext.request.contextPath}/admin/qna"
                     aria-label="Q&A 관리로 이동">
                    <div class="kpi kpi--qna">
                        <div class="kpi-icon"><i class="bi bi-question-diamond"></i></div>
                        <div class="kpi-body">
                            <div class="label">미답변 Q&amp;A</div>
                            <div class="value"><c:out value="${kpis.qnaUnanswered}"/>건</div>
                        </div>
                    </div>
                    <!-- 우하단 보조 링크 (겹쳐도 JS에서 a 클릭은 우선 처리) -->
                    <a class="kpi-quick" href="${pageContext.request.contextPath}/admin/qna">
                        바로가기 <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </div>

            <!-- 금주 상권분석 -->
            <div class="col-12 col-md-6 col-xl-3">
                <div class="card kpi-card p-4 kpi-click"
                     data-href="${pageContext.request.contextPath}/admin/stats/market"
                     aria-label="상권분석 통계로 이동">
                    <div class="kpi kpi--market">
                        <div class="kpi-icon"><i class="bi bi-activity"></i></div>
                        <div class="kpi-body">
                            <div class="label">금주 상권분석</div>
                            <div class="value"><c:out value="${kpis.marketAnalysisWeek}"/>건</div>
                        </div>
                    </div>
                    <a class="kpi-quick" href="${pageContext.request.contextPath}/admin/stats/market">
                        통계보기 <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </div>

            <!-- 24시간 ERROR -->
            <div class="col-12 col-md-6 col-xl-3">
                <div class="card kpi-card p-4 kpi-click"
                     data-href="${pageContext.request.contextPath}/admin/stats/system"
                     aria-label="시스템 로그로 이동">
                    <div class="kpi kpi--error">
                        <div class="kpi-icon"><i class="bi bi-exclamation-octagon"></i></div>
                        <div class="kpi-body">
                            <div class="label">24시간 ERROR</div>
                            <div class="value"><c:out value="${kpis.error24h}"/>건</div>
                            <c:set var="err" value="${empty kpis.error24h ? 0 : kpis.error24h}"/>
                        </div>
                    </div>
                    <a class="kpi-quick" href="${pageContext.request.contextPath}/admin/stats/system">
                        로그보기 <i class="bi bi-chevron-right"></i>
                    </a>
                </div>
            </div>
        </div><!-- ✅ KPI 행 닫기 -->

        <!-- 차트 -->
        <div class="row g-3 mt-1">
            <div class="col-12 col-xl-7">
                <div class="card p-3">
                    <div class="section-title">최근 30일 가입 추이</div>
                    <div class="chart-box">
                        <canvas id="signupTrendChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-12 col-xl-5">
                <div class="card p-3">
                    <div class="section-title">24h 로그 레벨</div>
                    <div class="chart-box">
                        <canvas id="logLevelChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- 작업 큐 & 최근 활동 -->
        <div class="row g-3 mt-1">
            <div class="col-12 col-xl-6 d-flex">
                <div class="card p-3 flex-fill h-100">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="section-title m-0">미답변 Q&amp;A</div>
                        <a class="mini-link" href="${pageContext.request.contextPath}/admin/qna">더보기</a>
                    </div>
                    <div class="table-responsive mt-2">
                        <table class="table align-middle">
                            <thead>
                            <tr>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${todoQna}" var="q">
                                <tr>
                                    <td><span class="todo-title"><c:out value="${q.title}"/></span></td>
                                    <td><c:out value="${q.writer}"/></td>
                                    <td>
                                        <fmt:formatDate value="${q.createdAt}" pattern="yyyy-MM-dd HH시 mm분"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty todoQna}">
                                <tr>
                                    <td colspan="3" class="text-muted">대기 중인 질문이 없습니다.</td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-12 col-xl-6 d-flex">
                <div class="card p-3 flex-fill h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="section-title m-0">최근 공지</div>
                        <a class="mini-link" href="${pageContext.request.contextPath}/admin/notice">더보기</a>
                    </div>

                    <ul class="list-group list-group-flush mt-2">
                        <c:forEach items="${recentNotice}" var="n">
                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                <span><c:out value="${n.title}"/></span>
                                <span class="text-muted small">
                                    <fmt:formatDate value="${n.createdAt}" pattern="yyyy-MM-dd HH시 mm분"/>
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty recentNotice}">
                            <li class="list-group-item text-muted">최근 게시물이 없습니다.</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>

        <!-- 퀵 액션 -->
        <div class="row g-3 mt-1">
            <div class="col-12">
                <div class="card p-3">
                    <div class="d-flex flex-wrap gap-2">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/notice/insert">공지 등록</a>
                        <a class="btn btn-success" href="${pageContext.request.contextPath}/admin/news/form">뉴스 등록</a>
                        <a class="btn btn-warning" href="${pageContext.request.contextPath}/admin/qna">Q&amp;A 답변</a>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/users">회원 관리</a>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/stats/market">상권분석 통계</a>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/stats/system">시스템 로그</a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    // ===== 가입 추이 (카테고리 축) =====
    const signupLabels = [
        <c:forEach items="${signupTrend}" var="d" varStatus="st">
        '${d.DT}'<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const signupValues = [
        <c:forEach items="${signupTrend}" var="d" varStatus="st">
        ${d.CNT}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];

    const signupCanvas = document.getElementById('signupTrendChart');

    if (typeof Chart === 'undefined') {
        console.error('Chart.js가 로드되지 않았습니다. assets 경로를 확인하세요.');
    } else {
        // 라인 아래 영역을 인디고 톤 그라디언트로 채움 (반투명→투명)
        new Chart(signupCanvas, {
            type: 'line',
            data: {
                labels: signupLabels,
                datasets: [{
                    label: '신규 가입',
                    data: signupValues,
                    borderWidth: 2,
                    tension: 0.2,
                    fill: true, // ✅ 채우기 활성화
                    borderColor: 'rgb(79, 70, 229)', // indigo-600
                    // chartArea가 계산된 뒤에 그라디언트를 만들어 주기 위해 함수로 지정
                    backgroundColor: (context) => {
                        const {chart} = context;
                        const {ctx, chartArea} = chart;
                        if (!chartArea) return null; // 최초 레이아웃 계산 전엔 null 반환
                        const gradient = ctx.createLinearGradient(0, chartArea.top, 0, chartArea.bottom);
                        gradient.addColorStop(0, 'rgba(79, 70, 229, 0.35)');
                        gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');
                        return gradient;
                    }
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {legend: {display: false}},
                scales: {x: {type: 'category'}, y: {beginAtZero: true, ticks: {precision: 0}}}
            }
        });
    }

    // ===== 24h 로그 레벨 (Map -> 배열로 안전하게 변환) =====
    const logLabels = [
        <c:forEach items="${logLevel24h}" var="e" varStatus="st">
        '${e.key}'<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];
    const logValues = [
        <c:forEach items="${logLevel24h}" var="e" varStatus="st">
        ${e.value}<c:if test="${!st.last}">, </c:if>
        </c:forEach>
    ];

    // 색상 매핑
    const COLOR = {
        ERROR: {bg: 'rgba(239, 68, 68, 0.6)', border: 'rgb(239, 68, 68)'},
        WARN:  {bg: 'rgba(245, 158, 11, 0.6)', border: 'rgb(245, 158, 11)'},
        INFO:  {bg: 'rgba(54, 162, 235, 0.6)', border: 'rgb(54, 162, 235)'},
    };

    const bgColors = logLabels.map(lv => (COLOR[(lv || '').toUpperCase()] || COLOR.INFO).bg);
    const borderColors = logLabels.map(lv => (COLOR[(lv || '').toUpperCase()] || COLOR.INFO).border);

    if (typeof Chart !== 'undefined') {
        new Chart(document.getElementById('logLevelChart'), {
            type: 'bar',
            data: {
                labels: logLabels,
                datasets: [{
                    label: '건수',
                    data: logValues,
                    backgroundColor: bgColors,
                    borderColor: borderColors,
                    borderWidth: 1.5
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {legend: {display: false}},
                scales: {y: {beginAtZero: true, ticks: {precision: 0}}}
            }
        });
    }

    // ===== KPI 카드 전체 클릭 / 키보드 접근성 =====
    (function () {
        const cards = document.querySelectorAll('.kpi-card.kpi-click');
        cards.forEach(card => {
            const go = () => {
                const url = card.dataset.href;
                if (url) location.href = url;
            };
            // 카드 아무 곳 클릭 시 이동 (내부 a/button 클릭은 제외)
            card.addEventListener('click', (e) => {
                if (e.target.closest('a, button, .btn')) return;
                go();
            });
            // 키보드 접근성: Enter/Space로 이동
            card.addEventListener('keydown', (e) => {
                if ((e.key === 'Enter' || e.key === ' ') && !e.target.closest('a, button, .btn')) {
                    e.preventDefault();
                    go();
                }
            });
            // 포커스 가능 + 역할 지정
            card.setAttribute('tabindex', '0');
            card.setAttribute('role', 'link');
        });
    })();
</script>

</body>
</html>
