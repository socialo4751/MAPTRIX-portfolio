<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>설문 조사 관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- Highcharts -->
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <script src="https://code.highcharts.com/modules/accessibility.js"></script>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Project CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">

    <style>
        body {
            font-family: 'Pretendard', 'Malgun Gothic', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
        }

        .list-header {
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 15px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .list-header h3 {
            margin-bottom: 0;
            font-size: 22px;
            font-weight: 700;
        }

        .pagination-container {
            margin-top: 20px;
            padding-top: 10px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: center;
        }

        .new-post-button-container {
            text-align: right;
            margin-bottom: 20px;
        }

        .new-post-btn {
            display: inline-block;
            background-color: #0d6efd;
            color: #fff;
            padding: 10px 20px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .new-post-btn:hover {
            background-color: #0a58ca;
            box-shadow: 0 4px 10px rgba(13, 110, 253, 0.3);
        }

        .filter-form .form-label {
            font-weight: 600;
        }

        .filter-form .form-control,
        .filter-form .form-select {
            min-width: 200px;
        }

        .table thead th {
            background-color: #f8f9fa;
        }

        body.modal-open {
            padding-right: 0 !important;
        }

        /* ===== 모달 & 차트 카드 비주얼 업그레이드 ===== */
        #statsModal .modal-content {
            border: 0;
            border-radius: 16px;
            box-shadow: 0 12px 36px rgba(0, 0, 0, .12);
        }

        #statsModal .modal-header {
            border: 0;
            padding: 18px 22px 8px 22px;
        }

        #statsModal .modal-body {
            padding: 22px;
            background: #f7f8fa;
        }

        .chart-card {
            background: #fff;
            border: 1px solid #eef0f3;
            border-radius: 14px;
            padding: 14px 14px 6px 14px;
            box-shadow: 0 6px 16px rgba(17, 24, 39, 0.06);
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        .chart-title {
            font-weight: 700;
            font-size: 14px;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 2px 2px 10px 6px;
        }

        .chart-title .bi {
            opacity: .7;
        }

        .hc {
            height: 320px;
            min-height: 280px;
        }

        .chart-loading {
            position: absolute;
            inset: 0;
            display: grid;
            place-items: center;
            background: linear-gradient(180deg, rgba(255, 255, 255, .88), rgba(255, 255, 255, .92));
            z-index: 2;
            font-size: 13px;
            color: #4b5563;
        }

        .spinner {
            width: 18px;
            height: 18px;
            border: 2px solid #c7cdd5;
            border-top-color: #0d6efd;
            border-radius: 50%;
            animation: spin 0.9s linear infinite;
            margin-right: 8px;
        }

        @keyframes spin {
            to {
                transform: rotate(360deg);
            }
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>


<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="admin-header">
                    <h2><i class="bi bi-bar-chart-line me-2 text-primary"></i> 설문 조사 등록 및 통계</h2>
                    <p>진행 중인 조사와 완료된 조사를 관리할 수 있습니다.</p>
                </div>
            </div>

            <!-- 🔍 필터 + 새 조사 등록 -->
            <div class="d-flex justify-content-between align-items-end flex-wrap mb-4">
                <form class="d-flex flex-wrap gap-2 align-items-end" method="get"
                      action="${pageContext.request.contextPath}/admin/survey">
                    <div>
                        <label class="form-label">조사명</label>
                        <input type="text" name="keyword" value="${param.keyword}" class="form-control form-control-sm"
                               placeholder="조사명">
                    </div>
                    <div>
                        <label class="form-label">상태</label>
                        <select name="useYn" class="form-select form-select-sm">
                            <option value="">전체</option>
                            <option value="Y" ${param.useYn eq 'Y' ? 'selected' : ''}>진행중</option>
                            <option value="N" ${param.useYn eq 'N' ? 'selected' : ''}>완료</option>
                        </select>
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>

                <div>
                    <button class="btn btn-success btn-sm fw-semibold"
                            onclick="location.href='${pageContext.request.contextPath}/admin/survey/insert';">
                        <i class="bi bi-plus-circle me-1"></i>설문 등록
                    </button>
                </div>
            </div>

            <!-- 📋 설문 리스트 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle table-bordered text-center">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th>조사명</th>
                        <th style="width: 120px;">참여자 수</th>
                        <th style="width: 100px;">상태</th>
                        <th style="width: 160px;">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="survey" items="${articlePage.content}" varStatus="loop">
                        <tr>
                            <td>${articlePage.total - ((articlePage.currentPage - 1) * articlePage.size + loop.index)}</td>
                            <td>${survey.surveyTitle}</td>
                            <td>${survey.participantCount}</td>
                            <td>
                                <span class="badge ${survey.useYn eq 'Y' ? 'bg-success' : 'bg-secondary'}">
                                        ${survey.useYn eq 'Y' ? '진행중' : '완료'}
                                </span>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <c:choose>
                                        <c:when test="${survey.useYn eq 'Y'}">
                                            <button class="btn btn-outline-danger"
                                                    onclick="changeStatus('${survey.surveyId}', 'N')">마감
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-outline-success"
                                                    onclick="changeStatus('${survey.surveyId}', 'Y')">진행
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    <button type="button" class="btn btn-outline-secondary"
                                            onclick="toggleDetail('${survey.surveyId}')">상세
                                    </button>
                                    <button type="button" class="btn btn-outline-primary"
                                            onclick="openStats(${survey.surveyId})">통계
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <tr id="detail-${survey.surveyId}" style="display:none;">
                            <td colspan="5">
                                <div class="p-3 bg-light border rounded">
                                    <div><strong>설명:</strong> ${survey.surveyDescription}</div>
                                    <div><strong>설문 ID:</strong> ${survey.surveyId}</div>
                                    <hr>
                                    <div id="question-container-${survey.surveyId}" data-loaded="false">
                                        <em class="text-muted">문항 정보를 불러오는 중입니다...</em>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination-container mt-4 text-center">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>

        </div><!-- /.main-container -->
    </div><!-- /#content -->
</div><!-- /#wrapper -->

<!-- ===== 통계 모달 ===== -->
<div class="modal fade" id="statsModal" tabindex="-1">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">설문 통계</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <!-- 카드형 차트 레이아웃 -->
                <div class="row g-3">
                    <div class="col-md-6">
                        <div class="chart-card">
                            <div class="chart-title"><i class="bi bi-graph-up-arrow"></i> 참여 추이 & 일일 참여</div>
                            <div id="trendChart" class="hc"></div>
                            <div class="chart-loading" id="loading-trend">
                                <div class="spinner"></div>
                                로딩 중…
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-card">
                            <div class="chart-title"><i class="bi bi-gender-ambiguous"></i> 성별 분포</div>
                            <div id="genderChart" class="hc"></div>
                            <div class="chart-loading" id="loading-gender">
                                <div class="spinner"></div>
                                로딩 중…
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-card" style="height: 420px;">
                            <div class="chart-title"><i class="bi bi-bar-chart-steps"></i> 질문별 응답 분포 (%)</div>
                            <div id="stackedPct" class="hc" style="height: 360px;"></div>
                            <div class="chart-loading" id="loading-pct">
                                <div class="spinner"></div>
                                로딩 중…
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="chart-card">
                            <div class="chart-title"><i class="bi bi-people"></i> 연령대 분포</div>
                            <div id="ageChart" class="hc"></div>
                            <div class="chart-loading" id="loading-age">
                                <div class="spinner"></div>
                                로딩 중…
                            </div>
                        </div>
                    </div>
                </div><!-- /.row -->
            </div><!-- /.modal-body -->
        </div>
    </div>
</div>

<!-- (선택) Bootstrap JS: top.jsp에 이미 포함되어 있다면 중복 로드 무방 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let hcTrend, hcHist, hcStacked;

    /* ===== Highcharts 테마 적용 ===== */
    function applyHCTheme() {
        Highcharts.setOptions({
            time: { useUTC: false },
            chart: {
                backgroundColor: 'transparent',
                style: { fontFamily: "'Pretendard','Malgun Gothic',sans-serif" },
                spacingTop: 8, spacingRight: 12, spacingBottom: 8, spacingLeft: 8
            },
            title: { style: { color: '#111827', fontSize: '14px', fontWeight: '700' } },
            legend: {
                itemStyle: { color: '#374151', fontWeight: '600', fontSize: '12px' },
                itemHoverStyle: { color: '#111827' },
                symbolRadius: 6
            },
            tooltip: {
                useHTML: true,
                backgroundColor: 'rgba(255,255,255,.96)',
                borderWidth: 0,
                borderRadius: 12,
                shadow: { color: 'rgba(0,0,0,.08)', width: 1, offsetX: 0, offsetY: 6, opacity: 1 },
                style: { color: '#111827', fontSize: '12px' }
            },
            xAxis: {
                lineColor: '#e5e7eb',
                tickColor: '#e5e7eb',
                labels: { style: { color: '#6b7280', fontSize: '11px' } }
            },
            yAxis: {
                gridLineColor: '#eef1f5',
                title: { text: null },
                labels: { style: { color: '#6b7280', fontSize: '11px' } }
            },
            plotOptions: {
                series: {
                    animation: { duration: 300 },
                    states: { inactive: { opacity: 1 } },
                    marker: { radius: 2, lineWidth: 0 }
                },
                column: {
                    borderWidth: 0,
                    borderRadius: 6,
                    pointPadding: 0.06,
                    groupPadding: 0.08
                },
                pie: {
                    dataLabels: { style: { textOutline: 'none', color: '#111827' } }
                },
                bar: { borderWidth: 0 }
            },
            colors: ['#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#14b8a6'],
            credits: { enabled: false },
            lang: { thousandsSep: ',', numericSymbols: null }
        });
    }

    // 날짜 입력을 ms로 안전 변환
    function toMillis(d) {
        if (d == null) return NaN;
        if (typeof d === 'number') return d > 1e12 ? d : d * 1000; // sec -> ms
        const s = String(d).trim();
        if (/^\d{13}$/.test(s)) return Number(s);             // ms epoch
        if (/^\d{10}$/.test(s)) return Number(s) * 1000;      // sec epoch
        // yyyy-MM-dd 또는 일반 Date 파싱
        const t = new Date(s.replace(/\.|\//g, '-') + 'T00:00:00+09:00').getTime();
        return isNaN(t) ? NaN : t;
    }

    function drawCenterLabel(chart, text) {
        const center = chart.series[0] && chart.series[0].center; // [x, y, width, height]
        if (!center) return;
        const cx = center[0], cy = center[1];
        const r = chart.renderer;
        if (!chart._centerLabel) {
            chart._centerLabel = r.label('', 0, 0, null, null, null, false, 'center-label')
                .attr({ zIndex: 5 })
                .css({ color:'#111827', fontSize:'12px', fontWeight:'700' })
                .add();
        }
        chart._centerLabel.attr({ text: text });
        const bbox = chart._centerLabel.getBBox();
        chart._centerLabel.attr({ x: cx - bbox.width/2, y: cy - bbox.height/2 });
    }

    async function openStats(surveyId) {
        applyHCTheme(); // 전역 테마 적용

        const CP = '${pageContext.request.contextPath}' || '';
        const statsEndpoint = CP + '/admin/survey/' + surveyId + '/stats';

        // 로딩 오버레이 ON
        ['trend','gender','pct','age'].forEach(function(k){
            const el = document.getElementById('loading-' + k);
            if (el) el.style.display = 'grid';
        });

        // 이전 차트 해제
        [hcTrend, hcHist, hcStacked].forEach(function(c){ if (c && c.destroy) c.destroy(); });

        // 1) 참여 추이 (areaspline + column)
        try {
            const r = await fetch(statsEndpoint + '/trend');
            if (!r.ok) throw new Error();
            const rows = await r.json();

            const DAY = 24 * 3600 * 1000;

            const dailyMap = new Map();
            rows.forEach(function(row){
                const t = toMillis(row.respDate ?? row.RESPDATE);
                const c = parseFloat(row.cnt ?? row.CNT) || 0;
                if (!isNaN(t)) {
                    const d = new Date(t); d.setHours(0,0,0,0);
                    const k = d.getTime();
                    dailyMap.set(k, (dailyMap.get(k) || 0) + c);
                }
            });

            const days = Array.from(dailyMap.keys()).sort(function(a,b){return a-b;});
            if (days.length) {
                for (var t = days[0]; t <= days[days.length-1]; t += DAY) {
                    if (!dailyMap.has(t)) dailyMap.set(t, 0);
                }
            }
            const allDays = Array.from(dailyMap.keys()).sort(function(a,b){return a-b;});

            var cumulativeData = [], dailyCountData = [], acc = 0;
            allDays.forEach(function(t){
                var dayCnt = dailyMap.get(t) || 0;
                acc += dayCnt;
                cumulativeData.push([t, Number(acc)]);
                dailyCountData.push([t, Number(dayCnt)]);
            });

            // areaspline 그라데이션
            const areaGradient = {
                linearGradient: { x1:0, y1:0, x2:0, y2:1 },
                stops: [
                    [0, Highcharts.color('#2563eb').setOpacity(0.24).get('rgba')],
                    [1, Highcharts.color('#2563eb').setOpacity(0.02).get('rgba')]
                ]
            };

            hcTrend = Highcharts.chart('trendChart', {
                chart: { zoomType: 'x' },
                title: { text: null },
                xAxis: {
                    type: 'datetime',
                    tickInterval: DAY,
                    dateTimeLabelFormats: { day: '%Y-%m-%d', week: '%Y-%m-%d', month: '%Y-%m' },
                    labels: { format: '{value:%m/%d}' }
                },
                yAxis: [{
                    title: { text: '누적' },
                    allowDecimals: false
                }, {
                    title: { text: '일일' },
                    allowDecimals: false,
                    opposite: true,
                    linkedTo: 0,
                    gridLineWidth: 0
                }],
                tooltip: {
                    shared: true,
                    xDateFormat: '%Y-%m-%d',
                    formatter: function () {
                        var pts = this.points || [];
                        var map = {};
                        for (var i=0;i<pts.length;i++){
                            var id = (pts[i].series && pts[i].series.options && pts[i].series.options.id) || pts[i].series.id;
                            map[id] = pts[i].y;
                        }
                        var dailyY = map['daily'];
                        var cumY = map['cum'];
                        var html = '<div style="margin-bottom:4px;"><b>' +
                            Highcharts.dateFormat('%Y-%m-%d', this.x) +
                            '</b></div>';
                        if (Number.isFinite(cumY)) html += '누적 <b>' + Highcharts.numberFormat(cumY,0) + '</b>명<br/>';
                        if (Number.isFinite(dailyY)) html += '일일 <b>' + Highcharts.numberFormat(dailyY,0) + '</b>명';
                        return html;
                    }
                },
                legend: { align: 'center', verticalAlign: 'bottom' },
                plotOptions: {
                    column: { pointRange: DAY },
                    series: { marker: { enabled: false } }
                },
                series: [
                    {
                        type: 'column',
                        id: 'daily',
                        name: '일일',
                        data: dailyCountData,
                        yAxis: 1
                    },
                    {
                        type: 'areaspline',
                        id: 'cum',
                        name: '누적',
                        data: cumulativeData,
                        yAxis: 0,
                        lineWidth: 2.6,
                        fillColor: areaGradient
                    }
                ]
            });
        } catch (e) {
            document.getElementById('trendChart').innerHTML =
                '<div class="text-muted px-2">추이 데이터를 불러오지 못했습니다.</div>';
        } finally {
            var l1 = document.getElementById('loading-trend'); if (l1) l1.style.display = 'none';
        }

        // 2) 성별 도넛
        try {
            const rg = await fetch(statsEndpoint + '/gender');
            if (!rg.ok) throw new Error('gender');
            const gRows = await rg.json();
            const gData = gRows.map(function(r){
                const code = r.gender ?? r.GENDER;
                const cnt = r.cnt ?? r.CNT;
                const name = (code === 'M' || code === 'm') ? '남'
                    : (code === 'F' || code === 'f') ? '여' : '미상';
                return { name: name, y: Number(cnt) || 0 };
            });
            const totalG = gData.reduce(function(s,p){ return s + (p.y||0); }, 0);

            Highcharts.chart('genderChart', {
                chart: { type: 'pie', events: {
                        render: function () { drawCenterLabel(this, '총 ' + Highcharts.numberFormat(totalG,0) + '명'); }
                    }},
                title: { text: null },
                tooltip: {
                    pointFormatter: function () {
                        return '<b>' + Highcharts.numberFormat(this.y,0) + '</b>명 (' +
                            Highcharts.numberFormat(this.percentage,1) + '%)';
                    }
                },
                plotOptions: {
                    pie: {
                        innerSize: '62%',
                        dataLabels: { enabled: true, format: '{point.name} {point.percentage:.1f}%' }
                    }
                },
                series: [{ name: '인원', data: gData }],
                legend: { enabled: true }
            });
        } catch (e) {
            document.getElementById('genderChart').innerHTML =
                '<div class="text-muted px-2">성별 데이터를 불러오지 못했습니다.</div>';
        } finally {
            var l2 = document.getElementById('loading-gender'); if (l2) l2.style.display = 'none';
        }

        // 3) 질문별 응답 분포 (%)
        try {
            const r2 = await fetch(statsEndpoint + '/score-pct');
            if (!r2.ok) throw new Error();
            const rows2 = await r2.json();

            const byQ = {};
            rows2.forEach(function(row){
                const qid = row.questionId ?? row.QUESTIONID;
                if (!byQ[qid]) {
                    byQ[qid] = {
                        order: Number(row.questionOrder ?? row.QUESTIONORDER) || 0,
                        text: row.questionText ?? row.QUESTIONTEXT ?? '',
                        rows: []
                    };
                }
                byQ[qid].rows.push(row);
            });

            const questions = Object.values(byQ).sort(function(a,b){ return a.order - b.order; });
            const categories = questions.map(function(q){
                const t = q.text || '';
                return q.order + '. ' + (t.length > 28 ? t.substring(0, 28) + '…' : t);
            });

            const optionValues = [5,4,3,2,1];
            const series = optionValues.map(function(v){
                return {
                    name: v + '점',
                    data: questions.map(function(q){
                        const hit = q.rows.find(function(x){ return Number(x.optionValue ?? x.OPTIONVALUE) === v; });
                        const pct = hit ? (hit.pct ?? hit.PCT) : 0;
                        const cnt = hit ? (hit.cnt ?? hit.CNT) : 0;
                        return { y: Number(pct) || 0, count: Number(cnt) || 0 };
                    })
                };
            });

            hcStacked = Highcharts.chart('stackedPct', {
                chart: { type: 'bar' },
                title: { text: null },
                xAxis: { categories: categories },
                yAxis: { min: 0, max: 100, labels: { format: '{value}%' } },
                legend: { align: 'center', verticalAlign: 'bottom' },
                tooltip: {
                    shared: true,
                    formatter: function () {
                        var cat = this.x;
                        var pts = this.points || [];
                        var out = '<b>' + cat + '</b><br/>';
                        for (var i=0;i<pts.length;i++){
                            var p = pts[i];
                            var pct = Highcharts.numberFormat(p.y,1) + '%';
                            var cnt = (p.point && Number.isFinite(p.point.count))
                                ? ' (' + Highcharts.numberFormat(p.point.count,0) + '명)' : '';
                            out += '<span style="color:' + p.color + '">●</span> ' + p.series.name +
                                ': <b>' + pct + '</b>' + cnt + '<br/>';
                        }
                        return out;
                    }
                },
                plotOptions: {
                    series: { grouping: true, pointPadding: 0.08, groupPadding: 0.12, dataLabels: { enabled: false } }
                },
                series: series
            });
        } catch (e) {
            document.getElementById('stackedPct').innerHTML =
                '<div class="text-muted px-2">질문별 분포 데이터를 불러오지 못했습니다.</div>';
        } finally {
            var l3 = document.getElementById('loading-pct'); if (l3) l3.style.display = 'none';
        }

        // 4) 연령 도넛
        try {
            const ra = await fetch(statsEndpoint + '/age-bucket');
            if (!ra.ok) throw new Error('age');
            const aRows = await ra.json();

            const order = {'10대': 10, '20대': 20, '30대': 30, '40대': 40, '50대': 50, '60대+': 60, '미상': 999};
            aRows.sort(function(a,b){
                const A = String(a.bucket ?? a.BUCKET);
                const B = String(b.bucket ?? b.BUCKET);
                return (order[A] || 999) - (order[B] || 999);
            });

            const aData = aRows.map(function(r){ return { name: String(r.bucket ?? r.BUCKET), y: Number(r.cnt ?? r.CNT) || 0 }; });
            const totalA = aData.reduce(function(s,p){ return s + (p.y||0); }, 0);

            Highcharts.chart('ageChart', {
                chart: { type: 'pie', events: {
                        render: function () { drawCenterLabel(this, '총 ' + Highcharts.numberFormat(totalA,0) + '명'); }
                    }},
                title: { text: null },
                tooltip: {
                    pointFormatter: function () {
                        return '<b>' + Highcharts.numberFormat(this.y,0) + '</b>명 (' +
                            Highcharts.numberFormat(this.percentage,1) + '%)';
                    }
                },
                plotOptions: {
                    pie: { innerSize: '62%', dataLabels: { enabled: true, format: '{point.name} {point.percentage:.1f}%' } }
                },
                series: [{ name: '인원', data: aData }],
                legend: { enabled: true }
            });
        } catch (e) {
            document.getElementById('ageChart').innerHTML =
                '<div class="text-muted px-2">연령 데이터를 불러오지 못했습니다.</div>';
        } finally {
            var l4 = document.getElementById('loading-age'); if (l4) l4.style.display = 'none';
        }

        // 모달 오픈
        new bootstrap.Modal(document.getElementById('statsModal')).show();
    }

    // ===== 원래 존재하던 유틸 =====
    function changeStatus(surveyId, nextStatus) {
        if (!confirm('정말로 상태를 변경하시겠습니까?')) return;
        const CP = '${pageContext.request.contextPath}' || '';
        location.href = CP + '/admin/survey/changeStatus?surveyId=' + surveyId + '&useYn=' + nextStatus;
    }

    function toggleDetail(surveyId) {
        const detailRow = document.getElementById('detail-' + surveyId);
        const container = document.getElementById('question-container-' + surveyId);

        if (detailRow.style.display === 'none') {
            detailRow.style.display = 'table-row';
            if (container.dataset.loaded === 'false') {
                container.innerHTML = "<em class='text-muted'>문항 정보를 불러오는 중입니다...</em>";
                const CP = '${pageContext.request.contextPath}' || '';
                fetch(CP + '/admin/survey/detailData?surveyId=' + surveyId)
                    .then(function (r) {
                        if (!r.ok) throw new Error();
                        return r.json();
                    })
                    .then(function (data) {
                        var html = '<ol>';
                        data.questions.forEach(function (q) {
                            html += '<li><strong>' + q.questionText + '</strong><ul>';
                            q.options.forEach(function (opt) {
                                html += '<li>' + opt.optionText + ' (값: ' + opt.optionValue + ')</li>';
                            });
                            html += '</ul></li>';
                        });
                        html += '</ol>';
                        container.innerHTML = html;
                        container.dataset.loaded = 'true';
                    })
                    .catch(function () {
                        container.innerHTML = "<em class='text-danger'>문항 로딩 실패</em>";
                    });
            }
        } else {
            detailRow.style.display = 'none';
        }
    }
</script>

</body>
</html>
