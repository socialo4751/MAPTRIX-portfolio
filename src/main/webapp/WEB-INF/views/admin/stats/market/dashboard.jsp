<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>상권 분석 통계 대시보드</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"/>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script
            src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"></script>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/adminstyle.css"/>

    <style>
        /* 페이지 전용 스타일 */
        .kpi-card .card-body {
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .kpi-card .kpi-icon {
            font-size: 2.5rem;
            opacity: 0.3;
        }

        .kpi-card .kpi-value {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .chart-container {
            min-height: 350px;
            position: relative;
        }

        .filter-bar .form-label {
            font-size: 0.85rem;
            font-weight: 600;
        }

        .table thead th {
            text-align: center;
            vertical-align: middle;
        }

        #logTableBody tr {
            cursor: pointer; /* 마우스 커서를 손가락 모양으로 변경 */
        }

        body.modal-open {
            padding-right: 0 !important;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>


<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">
            <%-- 페이지 전체 내용 (생략) --%>
            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header">
                    <h2 class="mb-1">
                        <i class="bi bi-bar-chart-line-fill me-2 text-primary"></i> 상권 분석
                        통계
                    </h2>
                    <p>기간, 지역, 사용자 특성별 상권 분석 서비스 이용 현황을 시각화하여 보여줍니다.</p>
                </div>
            </div>

            <div class="card card-body mb-4 filter-bar">
                <form id="filterForm" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label for="dateRange" class="form-label">기간</label>
                        <div class="input-group">
                            <input type="date" id="from" name="from"
                                   class="form-control form-control-sm"> <span
                                class="input-group-text" style="height: 31px;">~</span> <input type="date" id="to"
                                                                                               name="to"
                                                                                               class="form-control form-control-sm">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label for="type" class="form-label">분석타입</label> <select
                            id="type" name="type" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach items="${analysisTypeList}" var="code">
                            <option value="${code.codeId}">${code.codeName}</option>
                        </c:forEach>
                    </select>
                    </div>
                    <div class="col-md-2">
                        <label for="districtId" class="form-label">자치구</label> <select
                            id="districtId" name="districtId"
                            class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach items="${districtList}" var="dist">
                            <option value="${dist.districtId}">${dist.districtName}</option>
                        </c:forEach>
                    </select>
                    </div>
                    <div class="col-md-1">
                        <label for="gender" class="form-label">성별</label> <select
                            id="gender" name="gender" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach items="${genderList}" var="code">
                            <c:if test="${code.codeId != 'U'}">
                                <option value="${code.codeId}">${code.codeName}</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    </div>
                    <div class="col-md-2">
                        <label for="ageBand" class="form-label">연령대</label> <select
                            id="ageBand" name="ageBand" class="form-select form-select-sm">
                        <option value="">전체</option>
                        <c:forEach items="${ageBandList}" var="code">
                            <option value="${code.codeId}">${code.codeName}</option>
                        </c:forEach>
                    </select>
                    </div>
                    <div class="col-md-2 d-flex">
                        <button type="submit" class="btn btn-primary btn-sm w-100">
                            <i class="bi bi-search"></i> 조회
                        </button>
                    </div>
                </form>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-3">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle text-muted">총 분석 건수</h6>
                                <p id="kpiTotalCount" class="kpi-value mb-0">-</p>
                            </div>
                            <i class="bi bi-graph-up kpi-icon"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle text-muted">고유 사용자 수</h6>
                                <p id="kpiUniqueUserCount" class="kpi-value mb-0">-</p>
                            </div>
                            <i class="bi bi-people kpi-icon"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle text-muted">성공률</h6>
                                <p id="kpiSuccessRate" class="kpi-value mb-0">-</p>
                            </div>
                            <i class="bi bi-check-circle kpi-icon"></i>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card kpi-card shadow-sm">
                        <div class="card-body">
                            <div>
                                <h6 class="card-subtitle text-muted">평균 처리시간(ms)</h6>
                                <p id="kpiAvgDurationMs" class="kpi-value mb-0">-</p>
                            </div>
                            <i class="bi bi-clock-history kpi-icon"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <h5 class="card-title">인기 분석 지역 TOP 10</h5>
                            <div class="chart-container">
                                <canvas id="topLocationsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <h5 class="card-title">시간대별 분석량</h5>
                            <div class="chart-container">
                                <canvas id="hourlyCountsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <h5 class="card-title">연령대/성별 분포</h5>
                            <div class="chart-container">
                                <canvas id="demographicsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <ul class="nav nav-tabs" id="trendsTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="type-dist-tab"
                                            data-bs-toggle="tab" data-bs-target="#type-dist-pane"
                                            type="button" role="tab">분석타입 분포
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="daily-trend-tab"
                                            data-bs-toggle="tab" data-bs-target="#daily-trend-pane"
                                            type="button" role="tab">일자별 트렌드
                                    </button>
                                </li>
                            </ul>
                            <div class="tab-content mt-3">
                                <div class="tab-pane fade show active" id="type-dist-pane"
                                     role="tabpanel">
                                    <div class="chart-container" style="min-height: 310px;">
                                        <canvas id="analysisTypeChart"></canvas>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="daily-trend-pane"
                                     role="tabpanel">
                                    <div class="chart-container" style="min-height: 310px;">
                                        <canvas id="dailyTrendChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow-sm">
                <div
                        class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">분석 로그 상세</h5>
                    <button id="csvExportBtn" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-download"></i> CSV 내보내기
                    </button>
                </div>
                <div class="card-body" style="padding: 0;">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle text-center">
                            <thead class="table-light">
                            <tr>
                                <th>분석일시</th>
                                <th>사용자 ID</th>
                                <th>분석 타입</th>
                                <th>행정동</th>
                                <th>자치구</th>
                                <th>결과 행수</th>
                                <th>처리 시간(ms)</th>
                                <th>상태</th>
                            </tr>
                            </thead>
                            <tbody id="logTableBody">
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer">
                    <div id="paginationArea" class="pagination-container text-center">
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="logDetailModal" tabindex="-1"
     aria-labelledby="logDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="logDetailModalLabel">분석 로그 상세 정보</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <dl class="row">
                    <dt class="col-sm-3">분석 ID</dt>
                    <dd class="col-sm-9" id="modal-analysisId"></dd>

                    <dt class="col-sm-3">분석 일시</dt>
                    <dd class="col-sm-9" id="modal-runAt"></dd>

                    <dt class="col-sm-3">사용자 ID</dt>
                    <dd class="col-sm-9" id="modal-userId"></dd>

                    <dt class="col-sm-3">상태</dt>
                    <dd class="col-sm-9" id="modal-status"></dd>

                    <dt class="col-sm-3">분석 타입</dt>
                    <dd class="col-sm-9" id="modal-analysisType"></dd>

                    <dt class="col-sm-3">자치구</dt>
                    <dd class="col-sm-9" id="modal-district"></dd>

                    <dt class="col-sm-3">행정동</dt>
                    <dd class="col-sm-9" id="modal-adm"></dd>

                    <dt class="col-sm-3">성별/연령대</dt>
                    <dd class="col-sm-9" id="modal-demographics"></dd>

                    <hr class="my-3">

                    <dt class="col-sm-3">입력 파라미터 (JSON)</dt>
                    <dd class="col-sm-9">
							<pre>
								<code id="modal-paramJson"
                                      style="max-height: 200px; overflow-y: auto; display: block; background-color: #f8f9fa; padding: 10px; border-radius: 4px;"></code>
							</pre>
                    </dd>

                    <dt class="col-sm-3">실행 결과 (JSON)</dt>
                    <dd class="col-sm-9">
							<pre>
								<code id="modal-contextJson"
                                      style="max-height: 200px; overflow-y: auto; display: block; background-color: #f8f9fa; padding: 10px; border-radius: 4px;"></code>
							</pre>
                    </dd>
                </dl>
            </div>
        </div>
    </div>
</div>

<script>
  /* market_dashboard.js
   * - TOP10: 단색(CALM.blue) + 순위 내려갈수록 옅어짐
   * - 시간대별: 값이 클수록 진하게, 작을수록 연하게 (단색)
   * - 기타 기존 동작 동일
   */

  // =========================
  // 전역: 차트 인스턴스 & CSV 데이터
  // =========================
  const charts = {};
  let currentLogData = [];

  // =========================
  /* 팔레트 & 유틸 */
  // =========================
  const CALM = {
    blue: '#4c6ef5',
    teal: '#0ca678',
    cyan: '#15aabf',
    violet: '#7048e8',
    amber: '#f59f00',
    gray: '#495057',
    red: '#dc3545'
  };
  const DONUT_PALETTE = [CALM.blue, CALM.teal, CALM.cyan, CALM.violet, CALM.amber];
  const BG_ALPHA_DEFAULT = 0.5;
  const BG_ALPHA_STACKED = 0.45;

  function hexToRgba(hex, alpha) {
    var h = hex.replace('#', '');
    if (h.length === 3) h = h.split('').map(function (x) { return x + x; }).join('');
    var r = parseInt(h.substring(0, 2), 16);
    var g = parseInt(h.substring(2, 4), 16);
    var b = parseInt(h.substring(4, 6), 16);
    return 'rgba(' + r + ',' + g + ',' + b + ',' + (alpha == null ? 1 : alpha) + ')';
  }

  function makeColorSetFromPalette(n, palette, alpha) {
    var seq = [];
    for (var i = 0; i < n; i++) seq.push(palette[i % palette.length]);
    return {
      bg: seq.map(function (c) { return hexToRgba(c, alpha == null ? BG_ALPHA_DEFAULT : alpha); }),
      border: seq
    };
  }

  // 단색 스케일: 1등(진한) → n등(옅은)
  function makeMonochromeByRank(n, baseHex, alphaStart, alphaEnd) {
    if (n <= 0) return [];
    var start = (alphaStart == null ? 0.95 : alphaStart);
    var end   = (alphaEnd   == null ? 0.30 : alphaEnd);
    var step  = (start - end) / Math.max(n - 1, 1);
    var arr   = [];
    for (var i = 0; i < n; i++) {
      var a = start - step * i;
      arr.push(hexToRgba(baseHex, a));
    }
    return arr;
  }

  // 값 기반 단색 스케일: min→옅게, max→진하게
  function makeMonochromeByValue(values, baseHex, alphaMin, alphaMax) {
    var n = values.length;
    if (n === 0) return [];
    var min = Math.min.apply(null, values.map(Number));
    var max = Math.max.apply(null, values.map(Number));
    var aMin = (alphaMin == null ? 0.25 : alphaMin);
    var aMax = (alphaMax == null ? 0.95 : alphaMax);

    // 모든 값이 같으면 동일 진하기 적용
    if (!isFinite(min) || !isFinite(max) || max === min) {
      return values.map(function(){ return hexToRgba(baseHex, (aMin + aMax)/2); });
    }

    return values.map(function(v){
      var t = (Number(v) - min) / (max - min); // 0..1
      var a = aMin + t * (aMax - aMin);
      return hexToRgba(baseHex, a);
    });
  }

  // =========================
  /* 연령 라벨/정렬 헬퍼 */
  // =========================
  function toAgeLabel(code) {
    if (code == null) return '기타';
    var s = String(code).trim();
    if (s.includes('대')) return s;
    var m = s.match(/\d{1,2}/);
    if (m) {
      var n = parseInt(m[0], 10);
      if (/\+$/.test(s)) return n + '대 이상';
      if (n < 10) return '10대 미만';
      return n + '대';
    }
    return '기타';
  }

  function ageSortKey(code) {
    var s = String(code || '');
    var m = s.match(/\d{1,2}/);
    if (m) return parseInt(m[0], 10);
    if (/미만/.test(s)) return 0;
    if (/\+|이상/.test(s)) return 100;
    return 999;
  }

  // =========================
  /* 값 라벨 플러그인 */
  // =========================
  const ValueLabelPlugin = {
    id: 'valueLabel',
    afterDatasetsDraw(chart, args, pluginOpts) {
      const ctx = chart.ctx;
      const opts = pluginOpts || {};
      const color = opts.color || CALM.gray;
      const fontSize = opts.fontSize || 10;
      const step = opts.step || 1;
      const showOnDoughnut = (opts.showOnDoughnut !== false);
      const minArcRatio = opts.minArcRatio || 0.06;

      ctx.save();
      ctx.fillStyle = color;
      ctx.font = fontSize + 'px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';

      const indexAxis = chart.options.indexAxis || 'x';
      const isHorizontal = (indexAxis === 'y');

      chart.data.datasets.forEach((dataset, di) => {
        const meta = chart.getDatasetMeta(di);
        if (meta.hidden) return;

        // 라인
        if (meta.type === 'line') {
          meta.data.forEach((el, i) => {
            if (i % step !== 0) return;
            const raw = dataset.data[i];
            const val = (raw && typeof raw === 'object' && 'y' in raw) ? raw.y : raw;
            if (val == null) return;
            const x = el.x;
            const y = el.y - 6;
            ctx.textAlign = 'center';
            ctx.textBaseline = 'bottom';
            ctx.fillText(String(val), x, y);
          });
          return;
        }

        // 도넛/파이
        if (meta.type === 'doughnut' || meta.type === 'pie') {
            if (!showOnDoughnut) return;
            const total = dataset.data.reduce((a, b) => a + (Number(b) || 0), 0) || 1;
            meta.data.forEach((el, i) => {
              const v = Number(dataset.data[i]) || 0;
              const ratio = v / total;
              if (ratio < minArcRatio || v === 0) return;
              const pos = el.tooltipPosition();
              ctx.textAlign = 'center';
              ctx.textBaseline = 'middle';
              ctx.fillText(String(v), pos.x, pos.y);
            });
            return;
        }

        // 막대
        if (meta.type === 'bar') {
          const stacked = chart.options.scales && chart.options.scales.y && chart.options.scales.y.stacked;
          if (stacked || (chart.options.scales && chart.options.scales.x && chart.options.scales.x.stacked)) {
            const visibleIdx = chart.data.datasets.map((_, i) => i).filter(i => !chart.getDatasetMeta(i).hidden);
            const topIdx = visibleIdx[visibleIdx.length - 1];
            const topMeta = chart.getDatasetMeta(topIdx);
            const totals = chart.data.labels.map((_, li) =>
              visibleIdx.reduce((sum, i) => sum + (Number(chart.data.datasets[i].data[li]) || 0), 0)
            );
            topMeta.data.forEach((el, i) => {
              const total = totals[i];
              if (!total) return;
              let x = el.x, y = el.y;
              ctx.textAlign = 'center';
              ctx.textBaseline = 'bottom';
              if (isHorizontal) {
                x = el.x + 8;
                y = el.y;
                ctx.textAlign = 'left';
                ctx.textBaseline = 'middle';
              } else {
                y = el.y - 4;
              }
              ctx.fillText(String(total), x, y);
            });
          } else {
            meta.data.forEach((el, i) => {
              const v = Number(dataset.data[i]) || 0;
              if (!v) return;
              let x = el.x, y = el.y;
              if (isHorizontal) {
                x = el.x + 8;
                y = el.y;
                ctx.textAlign = 'left';
                ctx.textBaseline = 'middle';
              } else {
                y = el.y - 4;
                ctx.textAlign = 'center';
                ctx.textBaseline = 'bottom';
              }
              ctx.fillText(String(v), x, y);
            });
          }
        }
      });

      ctx.restore();
    }
  };

  // =========================
  /* Chart.js 전역 기본값 */
  // =========================
  if (window.Chart && Chart.defaults) {
    Chart.defaults.elements.bar.borderWidth = 1;
    Chart.defaults.elements.arc.borderWidth = 1;
    Chart.defaults.datasets.bar.borderRadius = 0;
    Chart.defaults.plugins.legend.labels.usePointStyle = true;
    Chart.defaults.plugins.legend.labels.pointStyle = 'rect';
    Chart.register(ValueLabelPlugin);
  }

  // =========================
  /* DOM 준비 */
  // =========================
  document.addEventListener('DOMContentLoaded', function () {
    setDefaultDateRange();

    var filterForm = document.getElementById('filterForm');
    filterForm.addEventListener('submit', function (e) {
      e.preventDefault();
      fetchDashboardData(1);
    });

    var csvBtn = document.getElementById('csvExportBtn');
    if (csvBtn) csvBtn.addEventListener('click', exportToCsv);

    fetchDashboardData(1);

    var logDetailModal = document.getElementById('logDetailModal');
    if (logDetailModal) {
      logDetailModal.addEventListener('show.bs.modal', function (event) {
        var row = event.relatedTarget;
        var logIndex = row && row.getAttribute('data-log-index');
        var logData = currentLogData[logIndex];
        if (!logData) return;

        var statusClass = (logData.status === 'SUCCESS' ? 'bg-success' : 'bg-danger');
        var statusBadgeHtml = '<span class="badge ' + statusClass + '">' + logData.status + '</span>';

        setText('modal-analysisId', logData.analysisId);
        setText('modal-runAt', formatDate(logData.runAt));
        setText('modal-userId', logData.userId || '-');
        setHTML('modal-status', statusBadgeHtml);
        setText('modal-analysisType', logData.analysisType || '-');
        setText('modal-district', logData.districtName || logData.districtId || '-');
        setText('modal-adm', logData.admName || logData.admCode || '-');
        setText('modal-demographics', (logData.gender || 'N/A') + ' / ' + (logData.ageBand || 'N/A'));

        try { setText('modal-paramJson', JSON.stringify(JSON.parse(logData.paramJson), null, 2)); }
        catch (e) { setText('modal-paramJson', logData.paramJson || '내용 없음'); }
        try { setText('modal-contextJson', JSON.stringify(JSON.parse(logData.contextJson), null, 2)); }
        catch (e) { setText('modal-contextJson', logData.contextJson || '내용 없음'); }
      });
    }
  });

  function setText(id, txt) {
    var el = document.getElementById(id);
    if (el) el.textContent = txt;
  }

  function setHTML(id, html) {
    var el = document.getElementById(id);
    if (el) el.innerHTML = html;
  }

  // =========================
  /* 날짜 기본값: 최근 1주 */
  // =========================
  function setDefaultDateRange() {
    var toDate = new Date();
    var fromDate = new Date();
    fromDate.setDate(toDate.getDate() - 6);
    var toEl = document.getElementById('to');
    var fromEl = document.getElementById('from');
    if (toEl) toEl.value = toDate.toISOString().split('T')[0];
    if (fromEl) fromEl.value = fromDate.toISOString().split('T')[0];
  }

  // =========================
  /* 데이터 로드 */
  // =========================
  async function fetchDashboardData(page) {
    var form = document.getElementById('filterForm');
    var params = new URLSearchParams(new FormData(form));
    params.append('currentPage', page);

    try {
      var response = await fetch('/admin/stats/market/data?' + params.toString());
      if (!response.ok) throw new Error('HTTP error! status: ' + response.status);
      var data = await response.json();
      updateDashboard(data);
    } catch (error) {
      console.error("데이터 로딩 실패:", error);
      alert("데이터를 불러오는 데 실패했습니다. 잠시 후 다시 시도해주세요.");
    }
  }

  // =========================
  /* UI 업데이트 */
  // =========================
  function updateDashboard(data) {
    updateKpiCards(data.kpiSummary);
    renderTopLocationsChart(data.top10Locations);   // 단색+순위 진하기
    renderHourlyCountsChart(data.hourlyCounts);     // 단색+값 기반 진하기
    renderDemographicsChart(data.demographicCounts);
    renderAnalysisTypeChart(data.analysisTypeCounts);
    renderDailyTrendChart(data.dailyTrends);
    updateLogTable(data.logPage);
  }

  function updateKpiCards(kpi) {
    if (!kpi) return;
    setText('kpiTotalCount', (kpi.totalCount != null ? kpi.totalCount : 0).toLocaleString());
    setText('kpiUniqueUserCount', (kpi.uniqueUserCount != null ? kpi.uniqueUserCount : 0).toLocaleString());
    setText('kpiSuccessRate', (kpi.successRate != null ? kpi.successRate : 0) + '%');
    setText('kpiAvgDurationMs', (kpi.avgDurationMs != null ? kpi.avgDurationMs : 0).toLocaleString());
  }

  function updateLogTable(logPage) {
    var tableBody = document.getElementById('logTableBody');
    var paginationArea = document.getElementById('paginationArea');
    if (!tableBody) return;

    tableBody.innerHTML = '';
    currentLogData = (logPage && logPage.content) ? logPage.content : [];

    if (currentLogData.length === 0) {
      tableBody.innerHTML = '<tr><td colspan="8" class="text-center py-5 text-muted">표시할 데이터가 없습니다.</td></tr>';
      if (paginationArea) paginationArea.innerHTML = '';
      return;
    }

    currentLogData.forEach(function (log, index) {
      var statusClass = (log.status === 'SUCCESS' ? 'bg-success' : 'bg-danger');
      var row =
        '<tr data-bs-toggle="modal" data-bs-target="#logDetailModal" data-log-index="' + index + '">' +
        '<td>' + formatDate(log.runAt) + '</td>' +
        '<td>' + (log.userId || '-') + '</td>' +
        '<td>' + (log.analysisType || '-') + '</td>' +
        '<td>' + (log.admName || log.admCode || '-') + '</td>' +
        '<td>' + (log.districtName || log.districtId || '-') + '</td>' +
        '<td>' + (log.resultRows != null ? Number(log.resultRows).toLocaleString() : '0') + '</td>' +
        '<td>' + (log.durationMs != null ? Number(log.durationMs).toLocaleString() : '0') + '</td>' +
        '<td><span class="badge ' + statusClass + '">' + (log.status || '') + '</span></td>' +
        '</tr>';
      tableBody.insertAdjacentHTML('beforeend', row);
    });

    if (paginationArea) {
      paginationArea.innerHTML = logPage.pagingArea || '';
      paginationArea.querySelectorAll('a.page-link').forEach(function (link) {
        link.addEventListener('click', function (e) {
          e.preventDefault();
          var pageNum = new URL(this.href).searchParams.get('currentPage');
          if (pageNum) {
            fetchDashboardData(parseInt(pageNum, 10));
          }
        });
      });
    }
  }

  // =========================
  /* 공통 차트 생성/파괴 */
  // =========================
  function renderChart(chartId, config) {
    if (charts[chartId]) charts[chartId].destroy();
    var el = document.getElementById(chartId);
    if (!el) return;
    var ctx = el.getContext('2d');
    charts[chartId] = new Chart(ctx, config);
  }

  // =========================
  /* 차트 렌더러 */
  // =========================

  // 인기 분석 지역 TOP 10 — 단색(CALM.blue) + 순위별 진하기
  function renderTopLocationsChart(data) {
    var labels = (data || []).map(function (d) { return d.admName; });
    var counts = (data || []).map(function (d) { return d.count; });

    var base = CALM.blue;
    var bg   = makeMonochromeByRank(counts.length, base, 0.95, 0.30);
    var br   = counts.map(function(){ return base; });

    renderChart('topLocationsChart', {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '분석 건수',
          data: counts,
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
          legend: { display: false },
          valueLabel: { color: CALM.gray, fontSize: 10 },
          tooltip: {
            callbacks: {
              title: function(items){
                if (!items || !items.length) return '';
                var i = items[0].dataIndex;
                return '순위 ' + (i+1) + '위 - ' + labels[i];
              }
            }
          }
        },
        categoryPercentage: 0.9,
        barPercentage: 0.9
      }
    });
  }

  // 시간대별 분석량 — 단색(CALM.blue) + "값 기반 진하기"
  function renderHourlyCountsChart(data) {
    var fullData = Array(24).fill(0).map(function (_, i) {
      return {hour: i, count: 0};
    });
    (data || []).forEach(function (d) {
      fullData[d.hour].count = d.count;
    });

    var labels = fullData.map(function (d) { return d.hour.toString().padStart(2, '0') + '시'; });
    var counts = fullData.map(function (d) { return d.count; });

    var base = '#f59f00'; // 오렌지 HEX (CALM.amber)
    // 값이 낮으면 α=0.25, 높으면 α=0.95 → 자동 스케일링
    var bg = makeMonochromeByValue(counts, base, 0.25, 0.95);
    var br = counts.map(function(){ return base; });

    renderChart('hourlyCountsChart', {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '분석 건수',
          data: counts,
          backgroundColor: bg,
          borderColor: br,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {display: false},
          valueLabel: {color: CALM.gray, fontSize: 10}
        }
      }
    });
  }

  // 연령대/성별 분포
  function renderDemographicsChart(data) {
    var src = data || [];
    var ageCodesSet = {};
    for (var i = 0; i < src.length; i++) ageCodesSet[src[i].ageBand] = true;
    var ageCodes = Object.keys(ageCodesSet).sort(function (a, b) { return ageSortKey(a) - ageSortKey(b); });
    var ageLabels = ageCodes.map(toAgeLabel);

    var maleData = ageCodes.map(function (code) {
      var f = src.find(function (d) { return d.ageBand === code && d.gender === 'M'; });
      return f ? f.count : 0;
    });
    var femaleData = ageCodes.map(function (code) {
      var f = src.find(function (d) { return d.ageBand === code && d.gender === 'F'; });
      return f ? f.count : 0;
    });

    var mBase = CALM.blue, fBase = CALM.red;

    renderChart('demographicsChart', {
      type: 'bar',
      data: {
        labels: ageLabels,
        datasets: [
          {
            label: '남성',
            data: maleData,
            backgroundColor: hexToRgba(mBase, BG_ALPHA_STACKED),
            borderColor: mBase,
            borderWidth: 1
          },
          {
            label: '여성',
            data: femaleData,
            backgroundColor: hexToRgba(fBase, BG_ALPHA_STACKED),
            borderColor: fBase,
            borderWidth: 1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {x: {stacked: true}, y: {stacked: true}},
        plugins: {valueLabel: {color: CALM.gray, fontSize: 10}}
      }
    });
  }

  // 분석타입 분포(도넛)
  function renderAnalysisTypeChart(data) {
    var labels = (data || []).map(function (d) { return d.analysisType; });
    var counts = (data || []).map(function (d) { return d.count; });
    var cs = makeColorSetFromPalette(counts.length, DONUT_PALETTE, BG_ALPHA_DEFAULT);

    renderChart('analysisTypeChart', {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          data: counts,
          backgroundColor: cs.bg,
          borderColor: cs.border,
          borderWidth: 1,
          hoverOffset: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          valueLabel: {color: CALM.gray, fontSize: 10, minArcRatio: 0.08}
        }
      }
    });
  }

  // 일자별 트렌드
  function renderDailyTrendChart(data) {
    var chartData = (data || []).map(function (d) { return {x: new Date(d.analysisDate), y: d.count}; });

    var base = CALM.blue;
    var topAlpha = 0.5;
    var bottomAlpha = 0.0;

    var step = 1;
    if (chartData.length > 40) step = Math.ceil(chartData.length / 30);

    renderChart('dailyTrendChart', {
      type: 'line',
      data: {
        datasets: [{
          label: '분석 건수',
          data: chartData,
          borderColor: base,
          borderWidth: 2,
          pointRadius: 2,
          pointHoverRadius: 3,
          pointBackgroundColor: hexToRgba(base, 0.7),
          pointBorderColor: base,
          backgroundColor: function (ctx) {
            var chart = ctx.chart;
            var area = chart.chartArea;
            if (!area) return null;
            var g = chart.ctx.createLinearGradient(0, area.top, 0, area.bottom);
            g.addColorStop(0, hexToRgba(base, topAlpha));
            g.addColorStop(1, hexToRgba(base, bottomAlpha));
            return g;
          },
          fill: true,
          tension: 0.25,
          spanGaps: true
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          x: {type: 'time', time: {unit: 'day', tooltipFormat: 'yyyy-MM-dd'}},
          y: {beginAtZero: true}
        },
        plugins: {legend: {display: false}, valueLabel: {color: CALM.gray, fontSize: 10, step: step}}
      }
    });
  }

  // =========================
  /* 유틸리티 */
  // =========================
  function formatDate(dateString) {
    if (!dateString) return '-';
    var date = new Date(dateString);
    var yyyy = date.getFullYear();
    var mm = (date.getMonth() + 1).toString().padStart(2, '0');
    var dd = date.getDate().toString().padStart(2, '0');
    var hh = date.getHours().toString().padStart(2, '0');
    var mi = date.getMinutes().toString().padStart(2, '0');
    return yyyy + '-' + mm + '-' + dd + ' ' + hh + ':' + mi;
  }

  function exportToCsv() {
    if (!currentLogData || currentLogData.length === 0) {
      alert("내보낼 데이터가 없습니다.");
      return;
    }
    var headers = ['분석일시', '사용자ID', '분석타입', '행정동코드', '자치구ID', '결과행수', '처리시간(ms)', '상태'];
    var rows = currentLogData.map(function (log) {
      return [
        formatDate(log.runAt),
        log.userId || '',
        log.analysisType || '',
        log.admCode || '',
        log.districtId || '',
        (log.resultRows != null ? log.resultRows : 0),
        (log.durationMs != null ? log.durationMs : 0),
        log.status || ''
      ].join(',');
    });
    var csvContent = "data:text/csv;charset=utf-8," + headers.join(',') + '\n' + rows.join('\n');
    var encodedUri = encodeURI(csvContent);
    var link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "market_analysis_log.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
</script>

</body>
</html>