<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <script src="https://code.highcharts.com/highcharts.js"></script>

    <link rel="stylesheet" href="/css/csstyle.css">

    <link rel="preload" href="https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff"
          as="font" type="font/woff" crossorigin>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">


    <style>
        /* ========== 공통 폰트 ========== */
        @font-face {
            font-family: 'GongGothicMedium';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
            font-weight: 700;
            font-style: normal;
        }

        /* 1) 부모 래퍼의 폭 제한 해제 */
        .page-container {
            width: 100%;
            max-width: none !important; /* 외부 css에서 max-width 걸려 있으면 무시 */
        }

        /* ========== 레이아웃 톤 맞추기 ========== */
        .container {
            display: flex;
            max-width: 1500px;
            background-color: #fff;
            border-radius: 8px;
            overflow: visible;
            margin: 50px auto;
        }


        main {
            flex-grow: 1;
            padding: 1px 40px 40px 40px;
            border-radius: 3px;
            display: flow-root;
        }

        /* ========== 고객센터 스타일을 그대로: 사이드바 ========== */
        .sidebar {
            width: 250px;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex-shrink: 0;
            border-radius: 3px;
            margin-right: 15px;
        }

        .menu-header-box {
            background: linear-gradient(135deg, rgba(4, 26, 47, 0.87), #0a3d62);
            color: #fff;
            text-align: center;
            font-size: 30px;
            font-weight: bold;
            padding: 30px 0;
            border-radius: 0.5rem;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            font-family: 'GongGothicMedium', sans-serif;
        }

        .sidebar .menu-header-box {
            margin-top: 0 !important;
        }

        .sidebar-menu {
            color: #000;
            width: 100%;
        }

        .sidebar-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu .nav-item {
            width: 100%;
            border-bottom: 1px solid #eee;
        }

        /* a.nav-link 와 button.nav-link 를 동일하게 보이도록 */
        .sidebar-menu .nav-link {
            width: 100%;
            display: flex;
            align-items: center;
            padding: 12px 20px;
            font-size: 1.1em;
            color: #000;
            text-decoration: none;
            transition: background-color .3s ease, color .3s ease;
            border-radius: 8px;
            box-sizing: border-box;

            /* button 대응 리셋 */
            background: transparent;
            border: 0;
            text-align: left;
            cursor: pointer;
        }

        .sidebar-menu .nav-link:hover {
            background: linear-gradient(90deg, #ddd);
            color: #000 !important;
        }

        .sidebar-menu .nav-link.active {
            background: linear-gradient(90deg, #0a3d62);
            color: #fff !important;
        }

        /* ========== 상단 타이틀/버튼 톤 맞추기 ========== */

        .page-header h2,
        .table-header h2 {
            margin-top: 0 !important;
            padding-top: 0 !important;
            font-size: 30px;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        /* 가이드 버튼도 고객센터 톤 맞춤 */
        .btn-guide-download {
            padding: 6px 12px;
            font-size: 13px;
            font-weight: bold;
            background-color: #6c757d;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .btn-guide-download:hover {
            background-color: #5a6268;
        }

        /* ========== 테이블/지표 영역 유지 + 살짝 손질 ========== */
        .analysis-table-container {
            display: none;
        }

        .analysis-table-container.active {
            display: block;
        }

        .analysis-table-container h3 {
            margin-top: 0 !important;
            font-size: 20px;
            color: #19a538;
        }

        .indicator-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
            margin-top: 20px;
        }

        .indicator-table th, .indicator-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .indicator-table thead th {
            background-color: #f8f9fa;
            border-top: 2px solid #ddd;
            border-bottom: 2px solid #ddd;
            font-weight: bold;
        }

        .indicator-table td.variable-name {
            color: #007bff;
            text-decoration: underline;
            cursor: pointer;
            font-weight: bold;
        }

        .indicator-table .variable-name:hover {
            color: #0056b3;
        }

        .indicator-table .description {
            color: #666;
            font-size: 13px;
        }

        /* ========== 반응형 살짝 보정 ========== */
        @media (max-width: 1200px) {
            .container {
                margin: 20px auto;
            }
        }

        @media (max-width: 992px) {
            .content-wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                margin-right: 0;
            }

            .menu-header-box {
                margin-bottom: 15px;
            }
        }

        .page-header,
        .table-header {
            display: flex;
            align-items: flex-start;
            gap: 20px; /* h2와 버튼 간격 */
            margin-top: 20px !important;
            margin-bottom: 40px;
            padding-bottom: 30px;
            border-bottom: 1px solid #eee;
            font-family: 'GongGothicMedium', sans-serif;
        }

        .page-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
            gap: 20px; /* 이 부분을 추가하여 버튼 간 간격을 줍니다. */
        }

        .page-header h2,
        .table-header h2 {
            margin: 0;
            /* ✨ 이제 이 부분이 잘 동작합니다. */
            margin-top: 5px; /* 상단 여백을 5px 추가 */
        }

        .btn-guide-download {
            margin-left: auto;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: bold;
            background-color: #6c757d;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        /* 공통 헤더의 버튼 모양 */
        .page-header .btn-guide-download,
        .table-header .btn-guide-download {
            display: inline-flex;
            align-items: center; /* 버튼 텍스트 세로정렬 */
            height: 34px; /* 살짝 높이 통일 */
            padding: 0 12px;
        }

        /* 모달 창 css 추가 */
        .modal-overlay {
            display: none; /* 초기 상태는 숨김 */
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6); /* 반투명 검정 배경 */
            z-index: 1050; /* 다른 요소 위에 표시되도록 높은 z-index 설정 */
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            max-width: 900px;
            width: 90%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            position: relative;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #aaa;
        }

        .close-button:hover {
            color: #555;
        }

        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }
            100% {
                transform: rotate(360deg);
            }
        }

        /* downloadExcelBtn 버튼 스타일 */
        #downloadExcelBtn {
            padding: 6px 12px;
            font-size: 13px;
            font-weight: bold;
            background-color: #0a3d62; /* 요청하신 색상 */
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;

            /* btn-guide-download와 동일한 정렬 및 높이 */
            display: inline-flex;
            align-items: center;
            height: 34px;
        }

        #downloadExcelBtn:hover {
            background-color: #082d49; /* 호버 시 약간 어두운 색상 */
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<div class="page-container">

    <div class="container">
        <aside class="sidebar">
            <div class="menu-header-box">
                분석 지표
            </div>

            <nav class="sidebar-menu">
                <ul>
                    <li class="nav-item">
                        <button class="model-select-btn nav-link active"
                                type="button"
                                data-target="regression">
                            <i class="bi bi-graph-up-arrow me-2"></i> 다중회귀모형
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="model-select-btn nav-link"
                                type="button"
                                data-target="cluster">
                            <i class="bi bi-grid-3x3-gap-fill me-2"></i> 군집분석
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="model-select-btn nav-link"
                                type="button"
                                data-target="logistic">
                            <i class="bi bi-diagram-3-fill me-2"></i> 로지스틱
                        </button>
                    </li>
                    <li class="nav-item">
                        <button class="model-select-btn nav-link"
                                type="button"
                                data-target="gravity">
                            <i class="bi bi-magnet-fill me-2"></i> 중력모델
                        </button>
                    </li>
                </ul>
            </nav>
        </aside>


        <main>
            <div id="regression" class="analysis-table-container active">
                <div class="page-header" style="display: flex; flex-direction: column;">
                    <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">다중회귀모형 분석 지표</h2>
                </div>
                <div class="title-info"
                     style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                    <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                        <p class="mb-0">다중회귀모형 분석은 여러 요인이 결과에 미치는 영향을 동시에 살펴보는 방법으로, 상권의 성장 가능성을 더욱 정확하게 파악할 수 있습니다.<br>
                            각 변수명을 클릭하면 해당 데이터의 분포도를 시각적으로 확인할 수 있습니다.</p>
                    </div>
                </div>
                <table class="indicator-table">
                    <thead>
                    <tr>
                        <th style="width:25%;">변수명</th>
                        <th style="width:75%;">설명</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="residual_total_business">
                            다중회귀모형분석 결과
                        </td>
                        <td class="description">AI 예측과 실제 사업체 수의 차이를 분석하여 숨은 성장 잠재력을 파악</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="총사업체수">총사업체수 (종속변수)</td>
                        <td class="description">지역 내 총 사업체의 개수 (종속변수)</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="총인구">총인구</td>
                        <td class="description">지역 내 거주하는 총 인구 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="30~34세 남녀 인구 합">30~34세 인구</td>
                        <td class="description">주요 경제활동 연령층인 30~34세 남녀 인구의 합</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="1인가구 수">1인가구 수</td>
                        <td class="description">지역 내 1인 가구의 총 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="신축 주택 비율">신축 주택 비율</td>
                        <td class="description">최근 지어진 주택의 비율로, 지역의 발전 가능성을 나타냄</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="도소매업체수">도소매업체수</td>
                        <td class="description">상권의 기본 구성 요소인 도매 및 소매업체의 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="숙박음식업체수">숙박 및 음식업체수</td>
                        <td class="description">유동인구와 밀접한 관련이 있는 숙박 및 음식점업의 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="정보통신업체수">정보통신업체수</td>
                        <td class="description">IT, 미디어 등 지식 기반 산업의 밀집도를 나타냄</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="건설업체수">건설업체수</td>
                        <td class="description">지역의 개발 및 인프라 구축 활동과 관련된 업체의 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="다중회귀모형" data-variable="교육서비스업체수">교육서비스업체수</td>
                        <td class="description">학원, 교육 기관 등 교육 관련 서비스업체의 수</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div id="cluster" class="analysis-table-container">

                <div class="page-header" style="display: flex; flex-direction: column;">
                    <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">군집분석 지표</h2>
                </div>
                <div class="title-info"
                     style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                    <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                        <p class="mb-0">군집분석은 비슷한 특성을 가진 지역을 그룹으로 묶어 비교·분석하는 방법으로, 상권의 구조와 특성을 파악하는 데 활용됩니다.<br>
                            각 변수명을 클릭하면 해당 데이터의 분포도를 시각적으로 확인할 수 있습니다.</p>
                    </div>
                </div>
                <table class="indicator-table">
                    <thead>
                    <tr>
                        <th>변수명</th>
                        <th>설명</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="cluster_result">군집분석 결과</td>
                        <td class="description">유사한 특성을 가진 지역들을 그룹으로 분류한 결과</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="20~39세 인구 비율">20~39세 인구 비율</td>
                        <td class="description">지역의 젊은 층 인구 구성을 파악할 수 있는 핵심 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="총 인구수">총 인구수</td>
                        <td class="description">지역의 인구 규모를 나타내는 가장 기본적인 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="1인가구 비율">1인가구 비율</td>
                        <td class="description">전체 가구 중 1인 가구가 차지하는 비율</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="총가구수">총가구수</td>
                        <td class="description">지역 내 총 가구의 수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="음식점 수">음식점 수</td>
                        <td class="description">외식 상권의 활성화를 보여주는 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="도소매업체 수">도소매업체 수</td>
                        <td class="description">지역의 상업 활동 규모를 나타내는 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="전체 사업체 수">전체 사업체 수</td>
                        <td class="description">지역의 전반적인 경제 활동 규모를 종합적으로 보여주는 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="서비스업 종사자 수">서비스업 종사자 수</td>
                        <td class="description">지역 경제의 서비스업 의존도 및 규모 파악</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="도소매업 종사자 수">도소매업 종사자 수</td>
                        <td class="description">도소매업 분야의 고용 규모를 통해 상권의 활력을 파악</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="군집분석" data-variable="2000년 이후 주택 비율">2000년 이후 주택 비율
                        </td>
                        <td class="description">비교적 최근에 형성된 주거 환경의 비율</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div id="logistic" class="analysis-table-container">
                <div class="page-header" style="display: flex; flex-direction: column;">
                    <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">로지스틱 분석 지표</h2>
                </div>
                <div class="title-info"
                     style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                    <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                        <p class="mb-0">로지스틱 분석은 여러 요인을 바탕으로 특정 사건이 발생할 확률을 예측하고 분류하는 방법으로, 상권의 유형과 성장 가능성을 진단할 수 있습니다.<br>
                            각 변수명을 클릭하면 해당 데이터의 분포도를 시각적으로 확인할 수 있습니다.</p>
                    </div>
                </div>
                <table class="indicator-table">
                    <thead>
                    <tr>
                        <th>변수명</th>
                        <th>설명</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="variable-name" data-model="로지스틱" data-variable="predicted_class">로지스틱분석 결과</td>
                        <td class="description">모델이 예측한 상권의 유형 (핵심/잠재/숨은 상권)</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="로지스틱" data-variable="cluster">군집분석 결과 (종속변수)</td>
                        <td class="description">모델이 예측하려는 목표 변수로, 각 지역이 속한 군집(0 또는 1)을 의미 (종속변수)</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="로지스틱" data-variable="총 인구수">총 인구수</td>
                        <td class="description">상권 발달 여부를 예측하는 데 사용된 핵심 변수</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="로지스틱" data-variable="음식점 수">음식점 수</td>
                        <td class="description">상권의 활성화 정도를 예측하는 주요 요인</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="로지스틱" data-variable="서비스업 종사자 수">서비스업 종사자 수</td>
                        <td class="description">지역의 경제 활동 집중도를 예측하는 데 사용</td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <div id="gravity" class="analysis-table-container">
                <div class="page-header" style="display: flex; flex-direction: column;">
                    <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">중력모델 분석 지표</h2>
                </div>
                <div class="title-info"
                     style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                    <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                        <p class="mb-0">중력모델 분석은 위치 간의 상호작용을 통해 상권이 주변 인구와 자원을 끌어들이는 힘을 측정하는 방법으로, 상권의 흡인력과 경쟁력을 평가할 수 있습니다.<br>
                            각 변수명을 클릭하면 해당 데이터의 분포도를 시각적으로 확인할 수 있습니다.</p>
                    </div>
                </div>
                <table class="indicator-table">
                    <thead>
                    <tr>
                        <th>변수명</th>
                        <th>설명</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td class="variable-name" data-model="중력모형" data-variable="Gravity_Total">상권 흡인력(Gravity
                            Total) (종속변수)
                        </td>
                        <td class="description">주변 인구를 끌어당기는 힘의 총합 (종속변수)</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="중력모형" data-variable="인구 수">인구 수</td>
                        <td class="description">상권의 잠재 수요 크기를 나타내는 지표</td>
                    </tr>
                    <tr>
                        <td class="variable-name" data-model="중력모형" data-variable="공시지가">공시지가</td>
                        <td class="description">상권의 경제적 가치와 활력을 나타내는 지표</td>
                    </tr>
                    </tbody>
                </table>
            </div>


            <div class="page-actions">
                <button class="btn-guide-download">공통 변수 설명 다운로드</button>
                <sec:authorize access="isAuthenticated()">
                    <button id="downloadExcelBtn">선택 지표 엑셀 다운로드</button>
                </sec:authorize>
                <sec:authorize access="isAnonymous()">
                    <button id="downloadExcelBtn" onclick="location.href='${pageContext.request.contextPath}/login'">선택
                        지표 엑셀 다운로드
                    </button>
                </sec:authorize>
            </div>


            <div id="chartModal" class="modal-overlay">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3 id="modalTitle">데이터 시각화</h3>
                        <button id="closeModalBtn" class="close-button">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div id="chartContainer">
                            <div class="spinner"></div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>
<script>
    // JSP의 contextPath를 JavaScript 전역 변수로 전달합니다.
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/market/indicators/map-indicators.js"></script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>