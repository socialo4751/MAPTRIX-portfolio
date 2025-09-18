<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- 하이차트 라이브러리 -->
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <style>

        /* 2. PC 화면(너비 1200px 이상)에서의 고정 너비를 설정합니다. (가장 중요!) */
        @media (min-width: 1200px) {
            .container {
                /* 이 값을 조절하여 전체 좌우 여백을 변경할 수 있습니다. */
                max-width: 1440px !important;
                min-width: 1440px !important;
            }
        }

        /* 3. 사이드바와 본문의 너비를 설정합니다. */
        .container > aside {
            flex: 0 0 250px; /* 사이드바 너비를 250px로 고정 */
        }

        .container > main {
            flex: 1 1 auto; /* 본문이 나머지 공간을 모두 차지하도록 설정 */
            min-width: 0;
        }

        /* SVG 지도 및 UI 요소 스타일 */
        #map-container {
            position: relative;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 0.4s ease-in-out;
        }

        #map-container.loaded {
            opacity: 1;
        }

        #map-container svg {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        #map-container svg path {
            cursor: pointer;
            transition: opacity 0.2s ease-in-out;
        }

        /* 호버 시 다른 path들은 살짝 흐리게 처리 */
        #map-container svg:hover path {
            opacity: 0.6;
        }

        /* 호버된 path만 선명하게 */
        #map-container svg path:hover {
            opacity: 1;
        }

        /* 1. 범례 스타일 */
        #map-legend {
            position: absolute;
            top: 2px; /* 위치를 조금 아래로 조정 */
            right: 15px;
            background-color: transparent; /* 배경을 투명하게 */
            padding: 0; /* 패딩 제거 */
            border-radius: 0; /* 테두리 모서리 제거 */
            box-shadow: none; /* 그림자 제거 */
            font-size: 0.8em;
            font-weight: bold; /* 폰트 두껍게 */
        }

        #map-legend h4 {
            margin: 0 0 8px 0;
            padding-bottom: 5px;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
        }

        #map-legend ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #map-legend li {
            display: flex;
            align-items: center;
            margin-bottom: 4px;
        }

        #map-legend .color-box {
            display: inline-block;
            width: 14px;
            height: 14px;
            margin-right: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }

        /* 2. SVG 내부 텍스트 라벨 스타일 */
        .map-label {
            /* 폰트 크기를 px단위가 아닌 SVG 좌표 단위로 크게 변경 */
            font-size: 60px; /* "10배"는 과장이지만, SVG viewBox에 맞춰 아주 큰 값으로 설정 */
            font-weight: bold;
            fill: #111;
            text-anchor: middle;
            dominant-baseline: middle;
            pointer-events: none;
            -webkit-user-select: none;
            user-select: none;
        }

        .map-label .value {
            /* 값 폰트 크기도 비례하여 키움 */
            font-size: 80px;
            font-weight: normal;
            fill: #333;
        }

        .map-label text {
            text-shadow: 0px 0px 5px rgba(255, 255, 255, 0.9), 0px 0px 5px rgba(255, 255, 255, 0.9);
        }

        /* 3. 호버 효과 (반짝이는 원) 스타일 */
        #map-hover-effect {
            position: absolute;
            display: none;
            align-items: center;
            justify-content: center;
            width: 120px; /* 원 크기를 조금 더 키움 */
            height: 120px;
            pointer-events: none;
            transform: translate(-50%, -50%);
        }

        /* 반짝이는 효과를 위한 가상 요소 */
        #map-hover-effect::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            /* ▼▼▼ [수정] 색상을 흰색 계열로 변경 ▼▼▼ */
            background-color: rgba(255, 255, 255, 0.7);
            box-shadow: 0 0 20px 15px rgba(255, 255, 255, 0.7);
            animation: pulse 1.5s infinite;
        }

        /* 반짝이는 애니메이션 키프레임 */
        @keyframes pulse {
            0% {
                transform: scale(0.7);
                opacity: 0.5;
            }
            50% {
                transform: scale(1.1);
                opacity: 1;
            }
            100% {
                transform: scale(0.7);
                opacity: 0.5;
            }
        }

        #map-tooltip {
            position: absolute;
            background-color: rgba(0, 0, 0, 0.75);
            color: white;
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 0.9em;
            pointer-events: none; /* 툴팁이 마우스 이벤트를 가로채지 않도록 설정 */
            display: none; /* 기본적으로 숨김 */
            white-space: nowrap;
        }

        /* 매출액 요약 정보 스타일 */
        .map-summary {
            display: flex;
            justify-content: space-around;
            padding: 10px 0;
            margin-bottom: 15px;
            border-top: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
            text-align: center;
        }

        .summary-item {
            display: flex;
            flex-direction: column;
        }

        .summary-label {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }

        .summary-value {
            font-size: 1.9em;
            font-weight: 600;
            color: #0a3d62; /* 이전에 설정한 지도 테마 색상과 통일 */
        }

        .summary-value small {
            font-size: 0.6em;
            font-weight: 400;
            color: #333;
        }

        /* 새로운 Select Bar 스타일 */
        .map-selector-wrapper {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .map-select {
            width: 100%;
            padding: 10px 15px;
            font-size: 1em;
            font-weight: bold;
            color: #333;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 8px;
            cursor: pointer;
            -webkit-appearance: none; /* 기본 화살표 제거 (크롬, 사파리) */
            -moz-appearance: none; /* 기본 화살표 제거 (파이어폭스) */
            appearance: none; /* 기본 화살표 제거 */
            /* 커스텀 화살표 아이콘 추가 */
            background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23666666%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E');
            background-repeat: no-repeat;
            background-position: right 15px center;
            background-size: 12px;
        }

        .map-select:focus {
            outline: none;
            border-color: #0a3d62;
            box-shadow: 0 0 0 2px rgba(10, 61, 98, 0.2);
        }

        /* 요소를 숨기기 위한 클래스 */
        .hidden {
            display: none !important;
        }

        .page-header p {
            font-size: 1.1em;
            color: #7f8c8d;
        }

        @font-face {
            font-family: 'GongGothicMedium';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
            font-weight: 700;
            font-style: normal;
        }

        body {
            background-color: #f5f7fa;
            color: #343a40;
        }

        /* 1. 페이지 전체를 감싸는 컨테이너 스타일 재정의 */
        .container {
            /* 참조 CSS의 고정 너비를 적용하여 좌우 여백 확보 */
            max-width: 1390px !important; /* 👈 이 !important가 모든 수정을 무시하게 만듭니다. */
            min-width: 1390px !important;

            margin: 50px auto;

            /* 내부 여백도 SNS 분석 페이지와 유사하게 조정합니다. */
            padding: 0 60px;

            background-color: #fff;
            border-radius: 8px;

            /* 불필요한 flex 속성 제거 */
        }

        /* 2. 페이지 헤더 스타일 단순화 */
        .page-header {
            /* 불필요한 여백/너비 설정 제거하고 필요한 스타일만 남김 */
            margin-bottom: 40px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            font-family: 'GongGothicMedium', sans-serif;
        }

        .page-header h2 {
            font-size: 30px;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .page-header p {
            font-size: 1.1em;
            color: #7f8c8d;
            line-height: 1.6; /* 줄 간격 추가 */
        }

        /* ========================================
           이하 차트 및 그리드 스타일 (기존 코드 유지)
           ======================================== */

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            grid-template-rows: auto auto;
            gap: 20px;
        }

        .chart-panel {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .chart-title {
            font-size: 1.2em;
            font-weight: bold;
            color: #333;
            margin: 0 0 15px 0;
            border-bottom: 1px solid #e0e0e0;
            padding-bottom: 10px;
        }

        .chart-container {
            height: 350px;
            flex-grow: 1;
        }

        /* 비즈니스 현황 대시보드 전용 헤더 가운데 정렬 */
        .biz-dashboard-page .page-header {
            display: flex;
            flex-direction: column;
            align-items: center; /* 수평 가운데 */
            text-align: center; /* 텍스트 가운데 */
        }

        .biz-dashboard-page .page-header h2 {
            margin: 0 0 10px 0;
        }

        .biz-dashboard-page .page-header p {
            margin: 0;
        }

    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/top.jsp"/>

<div class="container">
    <div class="biz-dashboard-page">
        <div class="page-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                상권 통계
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">소상공인 통계를 기반으로 자치구별 사업체 현황과 매출 규모를 한눈에 확인할 수 있습니다.</p>
            </div>
        </div>
    </div>


    <div class="dashboard-grid">
        <div class="chart-panel">
            <h3 class="chart-title">자치구별 현황</h3>
            <div class="map-selector-wrapper">
                <select id="map-data-select" class="map-select">
                    <option value="districtBusiness" selected>자치구별 사업체 현황</option>
                    <option value="smallbizStats">자치구별 소상공인 사업체 수</option>
                    <option value="commonBusiness">생활밀접업종 기본 현황</option>
                </select>
            </div>

            <div class="map-summary hidden">
                <div class="summary-item">
                    <span class="summary-label">총 사업체 수</span>
                    <span class="summary-value" id="summary-total-biz"> <small>(개)</small></span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">총 종사자 수</span>
                    <span class="summary-value" id="summary-total-emp"> <small>(명)</small></span>
                </div>
                <div class="summary-item">
                    <span class="summary-label">총 매출액</span>
                    <span class="summary-value" id="summary-total-sales"> <small>(억원)</small></span>
                </div>
            </div>

            <div id="map-container" class="chart-container">
                <div id="map-tooltip"></div>
                <div id="map-legend"></div>
                <div id="map-hover-effect"></div>
            </div>
        </div>
        <div class="chart-panel">
            <h3 class="chart-title">3개년 현황</h3>
            <div id="chart2-container" class="chart-container"></div>
        </div>
        <div class="chart-panel">
            <h3 class="chart-title">매출액 규모</h3>
            <div id="chart3-container" class="chart-container"></div>
        </div>
        <div class="chart-panel">
            <h3 class="chart-title">자치구별 창업 및 폐업 현황</h3>
            <div id="chart4-container" class="chart-container"></div>
        </div>
    </div>
<div class="chart-panel" style="margin-top: 20px; margin-bottom: 20px; ">
    ※ 본 자료는 2022년 데이터를 기준으로 작성되었습니다.<br>
    ※ 출처: 대전광역시 2024년 소상공인통계 보고서
</div>
</div>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<script src="/js/bizstats/chart/dashboard.js"></script>
</body>
</html>