<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <!-- proj4 라이브러리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.7.5/proj4.js"></script>

    <!-- 차트 관련된 라이브러리 -->
    <script src="https://code.highcharts.com/highcharts.js"></script>

    <!-- pdf 출력 관련 라이브러리 -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	
	<script>
	    const { jsPDF } = window.jspdf;
	    window.jsPDF = jsPDF;
	    
	    const isUserLoggedIn = <sec:authorize access="isAuthenticated()">true</sec:authorize><sec:authorize access="isAnonymous()">false</sec:authorize>;
	</script>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <style>
        /* =======================
     기본 스타일 초기화
     ======================= */
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Pretendard Variable', Pretendard, sans-serif;
            height: 100%;
            overflow: hidden;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul.dong-list, ul.subcategory-list {
            margin-left: -10px;
            margin-right: 10px;
        }

        .container {
            display: flex;
            height: 100vh;
        }

        /* =======================
           사이드바 전체 배경 흰색
           ======================= */
        .sidebar {
            background-color: #ffffff;
            width: 380px;
            padding: 20px;
            box-sizing: border-box;
            border-right: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            display: flex;
            flex-direction: column;
            color: #0a3d62; /* 기본 텍스트 색상 */
        }

        .sidebar-header {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid rgba(10, 61, 98, 0.2);
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #0a3d62;
        }

        /* 검색창 */
        .search-box {
            display: flex;
            margin-bottom: 20px;
        }

        .search-box input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
            font-size: 14px;
            background-color: rgba(4, 26, 47, 0.05);
            color: #0a3d62;
        }

        .search-box input::placeholder {
            color: rgba(10, 61, 98, 0.5);
        }

        .search-box button {
            background-color: #0a3d62;
            color: #fff;
            border: none;
            padding: 10px 15px;
            border-radius: 0 5px 5px 0;
            cursor: pointer;
            font-size: 16px;
            transition: background 0.2s;
        }

        .search-box button:hover {
            background-color: #084060;
        }

        .search-box button .fa-search {
            font-size: 18px;
        }

        /* 옵션 리스트 & 스크롤바 */
        .options-section {
            flex-grow: 1;
            overflow-y: auto;
            padding-right: 7px; /* 스크롤바 너비만큼 내부 여백 확보 */
            box-sizing: content-box;
        }

        .options-section::-webkit-scrollbar {
            width: 8px;
            background: transparent;
        }

        .options-section::-webkit-scrollbar-thumb {
            background-color: rgba(10, 61, 98, 0.3);
            border-radius: 4px;
        }

        .options-section::-webkit-scrollbar-thumb:hover {
            background-color: rgba(10, 61, 98, 0.5);
        }

        /* 섹션 제목 */
        .location-options h3,
        .business-type-options h3,
        .year-section h3 {
            color: #305178;
            margin-top: 0;
            margin-bottom: 12px;
            font-size: 16px;
            font-weight: bold;
        }

        /* 리스트 아이템 기본 */
        .location-options ul li a,
        .business-type-options ul li a,
        .year-section ul li a {
            display: block;
            padding: 10px 15px;
            margin-bottom: 8px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            background-color: #f1f3f5;
            font-size: 14px;
            color: #0a3d62;
            transition: all 0.2s ease-in-out;
        }

        /* 공통 hover 스타일 */
        .location-options ul li a:hover,
        .business-type-options ul li a:hover,
        .year-section ul li a:hover {
            background-color: #e0f0ff;
        }

        /* 공통 active 스타일 */
        .location-options ul li a.active,
        .business-type-options ul li a.active,
        .year-section ul li a.active {
            background-color: #0a3d62; /* 진한 네이비 배경 */
            color: #ffffff; /* 흰색 텍스트 */
            font-weight: 600; /* 텍스트 굵게 */
        }

        /* 공통 active+hover 스타일 */
        .location-options ul li a.active:hover,
        .business-type-options ul li a.active:hover,
        .year-section ul li a.active:hover {
            background-color: #0a3d62;
        }

        /* 하위 카테고리 (중분류) */
        .subcategory-list {
            margin-top: 5px;
            padding-left: 50px;
        }

        /* 메인 콘텐츠 */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .map-area, #vmap {
            flex-grow: 1;
            width: 100%;
            height: 100%;
            background-color: #e9ecef;
        }

        /* 하단 버튼 */
        .bottom-buttons {
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
        }

        .bottom-buttons button {
            border: none;
            padding: 14px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
            box-sizing: border-box;
            margin-top: 10px;
            transition: background 0.2s;
        }

        .bottom-buttons .btn-submit {
            background: #0a3d62;
            color: #fff;
        }

        .bottom-buttons .btn-submit:hover {
            background: #084060;
        }

        .bottom-buttons .btn-reset {
            background: #f0f0f0;
            color: #0a3d62;
        }

        .bottom-buttons .btn-reset:hover {
            background: #e0e0e0;
        }

        /* 리포트 사이드바 */
        .report-sidebar {
            background-color: white;
            width: 0;
            padding: 0;
            overflow: hidden;
            border-left: 1px solid #e0e0e0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            transition: all 0.4s ease-in-out;
        }

        .report-sidebar.active {
            width: 450px;
            padding: 20px;
        }

        .report-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            margin-bottom: 20px;
            border-bottom: 2px solid #333;
        }

        .report-header h3 {
            margin: 0;
            font-size: 20px;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #888;
        }

        .report-body {
            flex-grow: 1;
            overflow-y: auto;
        }

        .report-section {
            margin-bottom: 25px;
        }

        .report-section h4 {
            font-size: 16px;
            color: #305178;
            margin: 0 0 10px 0;
            border-left: 4px solid #305178;
            padding-left: 8px;
        }

        .summary-list li {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            font-size: 14px;
            border-bottom: 1px dashed #eee;
        }

        .summary-list li .label {
            color: #666;
        }

        .summary-list li .value {
            font-weight: bold;
            color: #333;
        }

        .report-footer {
            padding-top: 15px;
            border-top: 1px solid #e0e0e0;
            display: flex;
            gap: 10px;
        }

        .report-footer button {
            flex-grow: 1;
            padding: 12px;
            border-radius: 5px;
            border: none;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        /* 지도위 차트 강조 */
        .chart-highlight {
            box-shadow: 0 0 15px 5px rgba(10, 61, 98, 0.8) !important; /* #0a3d62 색상 계열 */
            border-radius: 5px;
            transition: box-shadow 0.2s ease-in-out;
        }

        /* AI 분석 */
        .ai-section {
            margin-top: 20px;
        }

        .ai-controls {
            text-align: center;
            margin-bottom: 15px;
        }

        .btn-ai-analyze {
            background-color: #4A90E2;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .btn-ai-analyze:hover {
            background-color: #357ABD;
        }

        .btn-ai-analyze:disabled {
            background-color: #cccccc;
            cursor: not-allowed;
        }

        #aiResultOutput {
            word-wrap: break-word;
            background-color: #f9f9f9;
            border: 1px solid #eee;
            padding: 15px;
            border-radius: 5px;
            font-size: 14px;
            line-height: 1.6;
            color: #333;
            min-height: 100px;
        }

        .ai-result-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 14px;
        }

        .ai-result-table th,
        .ai-result-table td {
            border: 1px solid #ddd;
            padding: 8px;
        }

        .ai-result-table th {
            background-color: #f2f2f2;
            text-align: left;
            width: 30%;
        }

        /* ===== 하위 카테고리(중분류) 링크 override ===== */
        .subcategory-list li {
            border-bottom: 1px dashed #ccc;
            margin-bottom: 10px;
            padding: 8px 0;
        }

        .subcategory-list li a.sub-link {
            background: none !important;
            border: none !important;
            padding: 0 !important;
            color: #0a3d62 !important;
            text-decoration: none !important;
            display: inline-block;
        }

        .subcategory-list li a.sub-link:hover {
            background: none !important;
        }

        .subcategory-list li a.sub-link.active {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 8px 15px !important;
            margin-bottom: 4px;
            background-color: #0a3d62 !important;
            color: #ffffff !important;
            border-radius: 5px;
        }

        .subcategory-list {
            padding-left: 20px;
        }

        /* ===== 동 리스트 (Pill 모양, 3개 배치, 마진 제거) ===== */
        .dong-list {
            margin-top: 5px; /* 필요 없으면 0으로 바꿔도 됩니다 */
            padding-left: 15px; /* 필요 없으면 제거 */
            display: grid;
            grid-template-columns: repeat(3, 1fr);
        }

        .dong-list li {
            margin: 0; /* 기존 margin-bottom:10px; 제거 */
        }

        .dong-list li a {
            text-align: center; /* 기존 margin-bottom:10px; 제거 */
        }

        .dong-list li a.dong-link {
            display: block; /* 각 칸을 꽉 채워줌 */
            width: 100%;
            box-sizing: border-box;
            padding: 8px 15px;
            background-color: #f8f9fa;
            border: 1px solid #e0e0e0;
            border-radius: 999px;
            color: #0a3d62;
            text-decoration: none;
            font-size: 14px;
            transition: background 0.2s, color 0.2s;
        }

        .dong-list li a.dong-link:hover {
            background-color: #e0f0ff;
        }

        .dong-list li a.dong-link.active {
            background-color: #0a3d62;
            color: #ffffff;
            font-weight: 600;
        }
        /* 기존 .subcategory-list override 아래에 추가 */
        .subcategory-list li {
            position: relative;      /* height 계산을 위해 */
            margin-bottom: 10px;
        }

        .subcategory-list li a.sub-link {
            display: block;
            width: 100%;
            height: 100%;
            padding: 8px 15px;       /* 원래 li padding 이었다면 여기로 이동 */
            box-sizing: border-box;
            background: none !important;
            color: #0a3d62 !important;
            border-radius: 5px;
            transition: background 0.2s, color 0.2s;
        }

        .subcategory-list li a.sub-link:hover {
            background-color: #e0f0ff !important;
        }

        .subcategory-list li a.sub-link.active {
            background-color: #0a3d62 !important;
            color: #ffffff !important;
        }
        /* map-area 는 position:relative 여야 합니다 */
        .map-area {
            position: relative;
            flex-grow: 1;
            width: 100%;
            height: 100%;
        }

        /* 로더 오버레이 */
        .map-loader {
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(255,255,255,0.8);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 999;

            opacity: 1;
            transition: opacity 0.5s ease;
        }
        .map-loader.fade-out {
            opacity: 0;
        }
        /* 스피너 원형 애니메이션 */
        .spinner {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #0a3d62;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0%   { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 로더 텍스트 */
        .loader-text {
            margin-top: 10px;
            font-size: 14px;
            color: #0a3d62;
        }
		/* =======================
		   섹션 구분선 및 여백 추가
		   ======================= */
		.business-type-options,
		.year-section {
		    margin-top: 15px; /* 섹션 바깥 위쪽 여백 */
		    padding-top: 20px; /* 섹션 안쪽 위쪽 여백 */
		    border-top: 1px solid #e0e0e0; /* 회색 구분선 */
		}
		/* 기존 CSS 코드 아래에 추가 */
		.highchart-container {
		    margin-top: 20px;
		    border-top: 1px solid #eee;
		    padding-top: 15px;
		    background-color: #f9f9f9; /* 모든 차트의 배경색을 통일 */
		}
		/* =======================
		   [신규] 사용법 안내 모달 스타일
		   ======================= */
		.usage-modal-container {
		    position: fixed;
		    z-index: 2000;
		    left: 0;
		    top: 0;
		    width: 100%;
		    height: 100%;
		    background-color: rgba(0, 0, 0, 0.6); /* 배경 어둡게 */
		    display: none; /* 평소엔 숨김 */
		    opacity: 0;
		    visibility: hidden;
		    transition: opacity 0.3s ease, visibility 0.3s ease;
		}
		
		.usage-modal-container.visible {
		    display: block;
		    opacity: 1;
		    visibility: visible;
		}
		
		.guide-step-content {
		    position: absolute;
		    background-color: #0a3d62; /* 상세분석 모달과 통일 */
		    color: #ffffff;
		    padding: 25px;
		    border: 1px solid #084060;
		    width: 320px;
		    border-radius: 8px;
		    box-shadow: 0 8px 25px rgba(0,0,0,0.4);
		    line-height: 1.6;
		    transform: scale(0.95);
		    transition: transform 0.3s ease-out, opacity 0.3s ease-out;
		    opacity: 0; /* 각 스텝도 투명하게 시작 */
		}
		
		.guide-step-content.active {
		    transform: scale(1);
		    opacity: 1; /* 활성화되면 보이도록 */
		}
		
		/* 말풍선 꼬리 */
		.guide-step-content::before {
		    content: '';
		    position: absolute;
		    top: 30px;
		    border-top: 10px solid transparent;
		    border-bottom: 10px solid transparent;
		}
		#guideStep1::before, #guideStep2::before {
		    left: -10px;
		    border-right: 10px solid #0a3d62;
		}
		#guideStep3::before, #guideStep4::before {
		    right: -10px;
		    border-left: 10px solid #0a3d62;
		}
		
		/* 모달 내부 요소 스타일 */
		.guide-step-content h5 {
		    margin: 0 0 15px 0;
		    font-size: 18px;
		    padding-bottom: 10px;
		    border-bottom: 1px solid rgba(255, 255, 255, 0.3);
		}
		
		.guide-step-content p {
		    font-size: 14px;
		    margin: 0 0 15px 0;
		    color: #e0e0e0;
		}
		
		.guide-footer {
		    text-align: right;
		    margin-top: 20px;
		}
		
		.guide-footer-final {
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		    margin-top: 20px;
		    padding-top: 15px;
		    border-top: 1px solid rgba(255, 255, 255, 0.3);
		}
		
		.guide-footer-final .checkbox-group {
		    display: flex;
		    align-items: center;
		}
		
		.guide-footer-final label {
		    margin-left: 8px;
		    font-size: 13px;
		    color: #d0d0d0;
		    cursor: pointer;
		}
		
		.guide-next-btn, .guide-start-btn {
		    padding: 8px 18px;
		    background-color: #ffffff;
		    color: #0a3d62;
		    border: none;
		    border-radius: 5px;
		    font-size: 14px;
		    font-weight: bold;
		    cursor: pointer;
		    transition: background-color 0.2s;
		}
		
		.guide-next-btn:hover, .guide-start-btn:hover {
		    background-color: #e0f0ff;
		}
		/* =======================
		   지도 위 컨트롤
		   ======================= */
		.map-overlay-controls-right { 
		    position: absolute; 
            top: 15px; 
            right: 15px; 
            z-index: 1000; 
		    display: flex;
		    gap: 8px; /* 버튼 사이 간격 */
		}
		
		.map-control-btn {
		    padding: 8px 12px; 
            font-size: 14px; 
            font-weight: bold;
		    color: #0a3d62; 
            background-color: white;
		    border: 1px solid #ccc; 
            border-radius: 5px; 
            cursor: pointer;
		    box-shadow: 0 2px 4px rgba(0,0,0,0.1); 
            transition: all 0.2s;
		}

		.map-control-btn:hover { 
            background-color: #f0f0f0; 
        }
        
/* view.jsp 파일의 <style> 태그 안쪽에 추가 (기존 toast-notification CSS는 삭제) */

/* =======================
   [신규] 중앙 알림 모달 스타일
   ======================= */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes scaleUp {
    from { transform: scale(0.9); }
    to { transform: scale(1); }
}

.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.6); /* 배경 어둡게 */
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 9999;
    animation: fadeIn 0.3s ease;
}

.modal-content {
    background-color: #ffffff;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.25);
    width: 90%;
    max-width: 400px; /* 최대 너비 지정 */
    text-align: center;
    animation: scaleUp 0.3s ease;
}

.modal-title {
    font-size: 20px;
    font-weight: 600;
    color: #0a3d62; /* 기본 테마 색상 */
    margin-bottom: 15px;
}

.modal-body {
    font-size: 16px;
    line-height: 1.7;
    color: #333;
    margin-bottom: 25px;
    text-align: left; /* 내용은 좌측 정렬 */
    padding-left: 20px;
}

.modal-button {
    background-color: #0a3d62;
    color: #ffffff;
    border: none;
    padding: 12px 30px;
    border-radius: 5px;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.2s;
}

.modal-button:hover {
    background-color: #084060;
}        
        
        
    </style>

</head>
<body>
<div class="container">

    <aside class="sidebar">

        <div class="sidebar-header" style="justify-content: space-between">
            <h2>간단분석</h2>
        </div>
        <div class="search-box">
            <input type="text" id="addressSearchInput" placeholder="주소, 건물명 또는 위치 검색">
            <button id="addressSearchButton">
                <i class="fa fa-search"></i>
            </button>
        </div>

        <div class="options-section" id="optionsSection">
            <div class="location-options">
                <h3>지역선택</h3>
                <ul id="districtList"></ul>
            </div>

            <div class="business-type-options">
                <h3>업종선택</h3>
                <ul id="bizCodeList"></ul>
            </div>

            <div class="year-section">
                <h3>연도선택</h3>
                <ul id="yearList">
                    <li><a href="#" data-year="2023">2023</a></li>
                    <li><a href="#" data-year="2022">2022</a></li>
                    <li><a href="#" data-year="2021">2021</a></li>
                    <li><a href="#" data-year="2020">2020</a></li>
                    <li><a href="#" data-year="2019">2019</a></li>
                </ul>
            </div>
        </div>

        <div class="bottom-buttons">
            <button class="btn-submit" id="analyzeButton">분석 하기</button>
            <button class="btn-reset">초기화</button>
        </div>
    </aside>

    <main class="main-content">
    	<div class="map-overlay-controls-right">
	        <button id="homeBtn" class="map-control-btn">홈</button>
	        
	        <%-- 로그인하지 않은 사용자에게만 보임 --%>
	        <sec:authorize access="isAnonymous()">
	            <button id="loginBtn" class="map-control-btn">로그인</button>
	        </sec:authorize>
	        
	        <%-- 로그인한 사용자에게만 보임 --%>
	        <sec:authorize access="isAuthenticated()">
	            <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post" style="display: none;"></form>
	            <button id="logoutBtn" class="map-control-btn">로그아웃</button>
	        </sec:authorize>
	        
	        <button id="guideBtn" class="map-control-btn">튜토리얼</button>
	        
	        <sec:authorize access="isAuthenticated()">
	        	<button id="myBtn" class="map-control-btn">마이페이지</button>
	        </sec:authorize>
	    </div>
	    
        <div class="map-area">
            <div id="mapLoader" class="map-loader">
                <div class="spinner"></div>
                <div class="loader-text">지도를 불러오는 중입니다...</div>
            </div>
            <div id="vmap"></div>
        </div>
    </main>

    <aside id="report-sidebar" class="report-sidebar">
        <div class="report-header">
            <h3>간단분석 리포트</h3>
            <button class="close-button" id="closeReportButton">&times;</button>
        </div>
        <div class="report-body">
            <div class="report-section">
                <h4>간단분석 정보요약</h4>
                <ul class="summary-list">
                    <li>
                        <span class="label">분석 상권</span>
                        <span class="value" id="modalLocation"></span>
                    </li>
                    <li>
                        <span class="label">선택 업종</span>
                        <span class="value" id="modalBiz"></span>
                    </li>
                    <li>
                        <span class="label">분석 연도</span>
                        <span class="value" id="modalYear"></span>
                    </li>
                </ul>
            </div>

            <div id="analysisResultsContainer"></div>

            <div class="report-section ai-section">
                <h4>AI 상권 분석 리포트</h4>
                <div class="ai-controls">
                    <button id="getAiReportButton" class="btn-ai-analyze">AI 분석 실행하기</button>
                </div>
                <div id="aiResultOutput"></div>
            </div>
        </div>
        <div class="report-footer">
		    <sec:authorize access="isAuthenticated()">
		        <button class="btn-print" id="printPdfButton">PDF 출력하기(마이페이지 저장)</button>
		    </sec:authorize>
		
		    <sec:authorize access="isAnonymous()">
		        <button class="btn-print" onclick="location.href='${pageContext.request.contextPath}/login'">PDF 출력하기(마이페이지 저장)</button>
		    </sec:authorize>
		</div>
    </aside>
</div>

<!-- vworld api 호출 스크립트 -->
<script type="text/javascript"
        src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=B346494D-259D-3E0B-AFE4-6862A39827F8&domain=http://192.168.45.75"></script>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/market/simple/map-analysis.js"></script>

<div id="usageGuideModal" class="usage-modal-container">
    <div id="guideStep1" class="guide-step-content" style="top: 150px; left: 300px;">
        <h5>Step 1. 분석 조건 선택</h5>
        <p>
            좌측 메뉴에서 분석을 원하는<br>
            지역, 업종, 연도를 순서대로 선택하세요.
        </p>
        <div class="guide-footer">
            <button class="guide-next-btn">다음</button>
        </div>
    </div>

    <div id="guideStep2" class="guide-step-content" style="top: 700px; left: 300px; display: none;">
        <h5>Step 2. 분석 실행</h5>
        <p>
            모든 조건을 선택한 후, <br>
            하단의 '분석 하기' 버튼을 클릭하여<br>
            상권 분석을 시작합니다.
        </p>
        <div class="guide-footer">
            <button class="guide-next-btn">다음</button>
        </div>
    </div>

    <div id="guideStep3" class="guide-step-content" style="top: 70px; right: 500px; display: none;">
        <h5>Step 3. 분석 결과 확인</h5>
        <p>
            분석이 완료되면 이곳에 간단분석 리포트와<br>
            다양한 통계 차트가 표시됩니다.
        </p>
        <div class="guide-footer">
            <button class="guide-next-btn">다음</button>
        </div>
    </div>

    <div id="guideStep4" class="guide-step-content" style="top: 170px; right: 500px; display: none;">
        <h5>Step 4. 지도 위 차트 생성 </h5>
        <p>
            리포트의 각 항목 제목(예: '인구 통계')을 클릭하면,<br>
            지도 위에 해당 데이터의 차트가 생성됩니다.
        </p>
        <div class="guide-footer">
            <button class="guide-next-btn">다음</button>
        </div>
    </div>

    <div id="guideStep5" class="guide-step-content" style="top: 50%; left: 50%; display: none; transform: translate(-50%, -50%);">
        <h5>이제 직접 분석해 보세요!</h5>
        <p>
            간단한 클릭만으로 상권의 특징과 AI 분석 결과를<br>
            한눈에 파악할 수 있습니다.
        </p>
        <div class="guide-footer-final">
            <div class="checkbox-group">
                <input type="checkbox" id="hideGuideCheckbox">
                <label for="hideGuideCheckbox">하루 동안 보지 않기</label>
            </div>
            <button id="startAnalysisBtn" class="guide-start-btn">시작하기!</button>
        </div>
    </div>
</div>

</body>
</html>
