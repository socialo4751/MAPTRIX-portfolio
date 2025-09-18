<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>플랫폼 이용자 통계</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"/>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/adminstyle.css">
    <style>
        .card-body {
            height: 129px;
        }
        .kpi-card .card-body {
            padding: 1.25rem;
        }

        .kpi-card .kpi-value {
            font-size: 2.25rem;
            font-weight: 700;
        }

        .kpi-card .kpi-change {
            font-size: 0.9rem;
            font-weight: 600;
        }

        .chart-card .card-body {
            min-height: 320px;
        }

        .community-card .card-body {
            font-size: 0.9rem;
            height: 160px;
        }

        .community-card h6 {
            font-weight: 600;
        }

        .community-card .count {
            font-size: 1.2rem;
            font-weight: 700;
            color: #0d6efd;
        }

        /* 스탬프/포인트용 작은 카드 스타일 추가 */
        .small-kpi-card {
            height: calc(50% - 0.5rem);
        }

        .small-kpi-card .kpi-value {
            font-size: 1.8rem;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>

<body>

<div id="wrapper" style="display: flex;">
    <c:set var="activeMenu" value="userStats" scope="request"/>
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>
    <div id="content">
        <div class="main-container">
            <div class="admin-header">
                <h2 class="mb-1">
                    <i class="bi bi-bar-chart-line-fill me-2 text-primary"></i> 플랫폼
                    이용 통계
                </h2>
                <p>서비스의 핵심 지표를 통해 사용자의 활동과 서비스 건강도를 확인합니다.</p>
            </div>
            <div class="border-bottom pb-3 mb-4">
                <form id="filterForm" class="d-flex align-items-end gap-2">
                    <div>
                        <label for="searchStartDate" class="form-label mb-1"> <span
                                class="fs-5 fw-bold">조회 기간</span> <small
                                class="text-muted fw-normal ms-2">(기본: 최근 30일)</small>
                        </label>
                        <div class="input-group input-group-sm">
                            <input type="date" class="form-control" id="searchStartDate"
                                   name="searchStartDate"> <span class="input-group-text">~</span>
                            <input type="date" class="form-control" id="searchEndDate"
                                   name="searchEndDate">
                        </div>
                    </div>
                    <div>
                        <button type="button" id="searchBtn"
                                class="btn btn-primary btn-sm">조회
                        </button>
                    </div>
                </form>
            </div>
            <h4 class="mb-3">주요 지표 및 이용자 수 통계</h4>
            <div id="kpi-summary-cards" class="row g-4"></div>
            <hr class="my-5">
            <h4 class="mb-3">핵심 기능 사용량 요약</h4>
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="card chart-card h-100">
                        <div class="card-header">상권분석 사용 현황</div>
                        <div
                                class="card-body d-flex justify-content-center align-items-center">
                            <canvas id="analysisFunnelChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card chart-card h-100">
                        <div class="card-header">OpenAPI 호출량</div>
                        <div
                                class="card-body d-flex justify-content-center align-items-center">
                            <canvas id="apiUsageChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="d-flex flex-column h-100">
                        <div class="card small-kpi-card mb-3">
                            <div class="card-header">스탬프 미션</div>
                            <div id="stamp-kpis"
                                 class="card-body d-flex flex-column justify-content-center text-center"></div>
                        </div>
                        <div class="card small-kpi-card mt-auto">
                            <div class="card-header">포인트 정산</div>
                            <div id="point-kpis"
                                 class="card-body d-flex flex-column justify-content-center text-center"></div>
                        </div>
                    </div>
                </div>
            </div>
            <hr class="my-5">
            <h4 class="mb-3">커뮤니티 및 디자인 활동</h4>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div id="comm-free-card" class="card community-card">
                        <div class="card-header">자유 게시판</div>
                        <div class="card-body"></div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div id="comm-review-card" class="card community-card">
                        <div class="card-header">창업 리뷰</div>
                        <div class="card-body"></div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div id="comm-show-card" class="card community-card">
                        <div class="card-header">도면 자랑</div>
                        <div class="card-body"></div>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div id="design-sim-card" class="card community-card">
                        <div class="card-header">디자인 시뮬레이터</div>
                        <div class="card-body"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/jquery/latest/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
<script
        src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
<link rel="stylesheet" type="text/css"
      href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const charts = {};

        // ====== 날짜 기본값 ======
        const startDateInput = document.getElementById('searchStartDate');
        const endDateInput = document.getElementById('searchEndDate');
        const today = new Date();
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(today.getDate() - 29);
        const formatDate = (date) => date.toISOString().split('T')[0];
        startDateInput.value = formatDate(thirtyDaysAgo);
        endDateInput.value = formatDate(today);

        $('input[name="daterange"]').daterangepicker({
            opens: 'left',
            startDate: moment().subtract(29, 'days'),
            endDate: moment(),
            locale: {format: 'YYYY-MM-DD'}
        });

        // ====== 색상 유틸 + 값기반 단색 스케일 ======
        function hexToRgba(hex, alpha) {
            var h = hex.replace('#', '');
            if (h.length === 3) h = h.split('').map(x => x + x).join('');
            var r = parseInt(h.substring(0, 2), 16);
            var g = parseInt(h.substring(2, 4), 16);
            var b = parseInt(h.substring(4, 6), 16);
            return 'rgba(' + r + ',' + g + ',' + b + ',' + (alpha == null ? 1 : alpha) + ')';
        }

        function makeMonochromeByValue(values, baseHex, alphaMin, alphaMax) {
            const n = values.length;
            if (!n) return [];
            const nums = values.map(v => Number(v) || 0);
            const min = Math.min.apply(null, nums);
            const max = Math.max.apply(null, nums);
            const aMin = alphaMin == null ? 0.3 : alphaMin;
            const aMax = alphaMax == null ? 0.95 : alphaMax;
            if (!isFinite(min) || !isFinite(max) || max === min) {
                const mid = (aMin + aMax) / 2;
                return nums.map(() => hexToRgba(baseHex, mid));
            }
            return nums.map(v => {
                const t = (v - min) / (max - min);
                const a = aMin + t * (aMax - aMin);
                return hexToRgba(baseHex, a);
            });
        }

        // ====== 값 라벨 그리기 플러그인 (막대/도넛) ======
        const ValueLabelPlugin = {
            id: 'valueLabel',
            afterDatasetsDraw(chart, args, pluginOpts) {
                const ctx = chart.ctx;
                const color = (pluginOpts && pluginOpts.color) || '#495057';
                const fontSize = (pluginOpts && pluginOpts.fontSize) || 11;
                const minArcRatio = (pluginOpts && pluginOpts.minArcRatio) || 0.06;

                ctx.save();
                ctx.fillStyle = color;
                ctx.font = fontSize + 'px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';

                chart.data.datasets.forEach((ds, di) => {
                    const meta = chart.getDatasetMeta(di);
                    if (meta.hidden) return;

                    // 도넛/파이: 조각에 값 표시
                    if (meta.type === 'doughnut' || meta.type === 'pie') {
                        const total = ds.data.reduce((a, b) => a + (Number(b) || 0), 0) || 1;
                        meta.data.forEach((el, i) => {
                            const v = Number(ds.data[i]) || 0;
                            const ratio = v / total;
                            if (ratio < minArcRatio || v === 0) return;
                            const pos = el.tooltipPosition();
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'middle';
                            ctx.fillText(String(v), pos.x, pos.y);
                        });
                        return;
                    }

                    // 막대: 각 막대 끝에 값 표시 (세로/가로 모두 지원)
                    if (meta.type === 'bar') {
                        const isHorizontal = (chart.options.indexAxis === 'y');
                        meta.data.forEach((el, i) => {
                            const v = Number(ds.data[i]) || 0;
                            if (!v && v !== 0) return;
                            if (isHorizontal) {
                                ctx.textAlign = 'left';
                                ctx.textBaseline = 'middle';
                                ctx.fillText(String(v), el.x + 6, el.y);
                            } else {
                                ctx.textAlign = 'center';
                                ctx.textBaseline = 'bottom';
                                ctx.fillText(String(v), el.x, el.y - 4);
                            }
                        });
                    }
                });

                ctx.restore();
            }
        };

        if (window.Chart && Chart.defaults) {
            Chart.register(ValueLabelPlugin);
        }

        // ====== Ajax 로드 ======
        function loadDashboardData() {
            const from = startDateInput.value;
            const to = endDateInput.value;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/admin/stats/users/all-data',
                type: 'GET',
                data: {from: from, to: to},
                success: function (data) {
                    renderKpiSummary(data.kpiSummary);
                    renderAnalysisChart(data.analysis);   // ← 숫자 표시 추가
                    renderApiChart(data.openapi);         // ← 값기반 진하기 + 숫자 표시
                    renderCommunityAndDesign(data.community, data.design);
                    renderEngagementMetrics(data.engagement);
                },
                error: function (xhr, status, error) {
                    console.error('대시보드 데이터 로드 실패:', status, error);
                    alert('데이터를 불러오는 데 실패했습니다.');
                }
            });
        }

        // ====== 공통 렌더 헬퍼 ======
        function renderChart(canvasId, config) {
            if (charts[canvasId]) charts[canvasId].destroy();
            const ctx = document.getElementById(canvasId).getContext('2d');
            charts[canvasId] = new Chart(ctx, config);
        }

        // ====== KPI 카드 ======
        function renderKpiSummary(data) {
            const container = $('#kpi-summary-cards');
            container.empty();
            data.forEach(function (kpi) {
                const valueStyle = kpi.small ? 'style="font-size: 2rem;"' : '';
                const arrowIcon = kpi.change.startsWith('-') ? 'bi-arrow-down-short' : 'bi-arrow-up-short';
                const changeValue = kpi.change.replace(/[+-]/, '');
                const cardHtml =
                    '<div class="col-md-6 col-xl-3">' +
                    '<div class="card kpi-card">' +
                    '<div class="card-body">' +
                    '<h6 class="card-title text-muted">' + kpi.title + '</h6>' +
                    '<div class="d-flex align-items-center">' +
                    '<p class="kpi-value mb-0" ' + valueStyle + '>' + kpi.value + '</p>' +
                    '<span class="ms-auto kpi-change text-' + kpi.status + '">' +
                    '<i class="bi ' + arrowIcon + '"></i> ' + changeValue +
                    '</span>' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                container.append(cardHtml);
            });
        }

        // ====== 상권분석 사용 현황 (도넛) — 숫자 라벨 표시됨(플러그인) ======
        function renderAnalysisChart(data) {
            const labels = ['단순분석', '상세분석'];
            const values = [data.simple, data.detailed];

            renderChart('analysisFunnelChart', {
                type: 'doughnut',
                data: {
                    labels,
                    datasets: [{
                        data: values,
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.6)',
                            'rgba(75, 192, 192, 0.6)'
                        ],
                        borderColor: ['#36A2EB', '#4BC0C0'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {position: 'bottom'},
                        // 값 라벨 플러그인은 전역 등록되어 자동 표시
                        valueLabel: {minArcRatio: 0.06, fontSize: 11}
                    }
                }
            });
        }

        // ====== OpenAPI 호출량 (가로 막대) — 값이 클수록 진하게 + 숫자 라벨 ======
        function renderApiChart(data) {
            const labels = Object.keys(data);
            const values = Object.values(data);
            const base = '#ff9f40'; // 오렌지 (Chart.js 기본 팔레트의 orange)
            const bg = makeMonochromeByValue(values, base, 0.3, 0.95);
            const br = values.map(() => base);

            renderChart('apiUsageChart', {
                type: 'bar',
                data: {
                    labels,
                    datasets: [{
                        label: '호출 수',
                        data: values,
                        backgroundColor: bg,
                        borderColor: br,
                        borderWidth: 1
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {display: false},
                        // 값 라벨 플러그인은 전역 등록되어 자동 표시
                        valueLabel: {fontSize: 11}
                    },
                    scales: {
                        x: {beginAtZero: true}
                    }
                }
            });
        }

        // ====== 커뮤니티/디자인 카드 ======
        function renderCommunityAndDesign(communityData, designData) {
            const freeHtml =
                '<div class="row">' +
                '<div class="col-6 border-end"><h6>게시글</h6>' +
                '<div>등록: <span class="count">' + communityData.free.post.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.free.post.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.free.post.d + '</span></div>' +
                '</div>' +
                '<div class="col-6"><h6>댓글</h6>' +
                '<div>등록: <span class="count">' + communityData.free.comment.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.free.comment.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.free.comment.d + '</span></div>' +
                '</div>' +
                '</div>';
            $('#comm-free-card .card-body').html(freeHtml);

            const reviewHtml =
                '<div class="row">' +
                '<div class="col-6 border-end"><h6>게시글</h6>' +
                '<div>등록: <span class="count">' + communityData.review.post.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.review.post.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.review.post.d + '</span></div>' +
                '</div>' +
                '<div class="col-6"><h6>댓글</h6>' +
                '<div>등록: <span class="count">' + communityData.review.comment.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.review.comment.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.review.comment.d + '</span></div>' +
                '</div>' +
                '</div>';
            $('#comm-review-card .card-body').html(reviewHtml);

            const showHtml =
                '<div class="row">' +
                '<div class="col-6 border-end"><h6>게시글</h6>' +
                '<div>등록: <span class="count">' + communityData.show.post.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.show.post.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.show.post.d + '</span></div>' +
                '</div>' +
                '<div class="col-6"><h6>댓글</h6>' +
                '<div>등록: <span class="count">' + communityData.show.comment.c + '</span></div>' +
                '<div>수정: <span class="count">' + communityData.show.comment.u + '</span></div>' +
                '<div>삭제: <span class="count">' + communityData.show.comment.d + '</span></div>' +
                '</div>' +
                '</div>';
            $('#comm-show-card .card-body').html(showHtml);

            const designHtml =
                '<div class="row">' +
                '<div class="col-12"><h6>도면</h6>' +
                '<div>저장: <span class="count">' + designData.save + '</span></div>' +
                '<div>복제: <span class="count">' + designData.clone + '</span></div>' +
                '<div>삭제: <span class="count">' + designData.delete + '</span></div>' +
                '</div>' +
                '</div>';
            $('#design-sim-card .card-body').html(designHtml);
        }

        // ====== 참여 지표 ======
        function renderEngagementMetrics(data) {
            $('#stamp-kpis').html(
                '<h6 class="text-muted mb-2">사용자별 평균 스탬프</h6>' +
                '<p class="kpi-value mb-0">' + data.stampAvg + '개</p>'
            );
            $('#point-kpis').html(
                '<h6 class="text-muted mb-2">총 포인트 정산 횟수</h6>' +
                '<p class="kpi-value mb-0">' + data.totalPoints + '건</p>'
            );
        }

        // ====== 이벤트 ======
        $('#searchBtn').on('click', loadDashboardData);
        loadDashboardData();
    });
</script>


</body>
</html>