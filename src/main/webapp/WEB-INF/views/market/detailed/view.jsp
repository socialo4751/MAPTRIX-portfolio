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
    <!-- vworld 관련 js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/proj4js/2.7.5/proj4.js"></script>

    <!-- 하이차트 라이브러리 -->
    <script src="https://code.highcharts.com/highcharts.js"></script>

    <!-- 지도검색 관련 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

    <%-- ▼▼▼▼▼ [추가] PDF 생성 라이브러리 ▼▼▼▼▼ --%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <%-- ▲▲▲▲▲ [추가] PDF 생성 라이브러리 ▲▲▲▲▲ --%>

    <style>
        /* =======================
           1. 기본 스타일 & 폰트
        ======================= */
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Pretendard Variable', Pretendard, sans-serif; /* 폰트 변경 */
            height: 100%;
            background-color: #f8f9fa;
            overflow: hidden;
        }

        a, button {
            text-decoration: none;
            color: inherit;
        }

        ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        * {
            box-sizing: border-box;
        }

        /* =======================
           2. 전체 레이아웃
        ======================= */
        .page-wrapper {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        .container {
            display: flex;
            flex-grow: 1;
            height: 100%;
        }

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

        /* =======================
           3. 사이드바 (공통 스타일)
        ======================= */
        .sidebar, .layer-sidebar {
            background-color: #ffffff;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            border-right: 1px solid #e0e0e0;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            color: #0a3d62; /* 기본 텍스트 색상 */
        }

        .sidebar-header, .layer-sidebar-header {
            padding-bottom: 15px;
            margin-bottom: 20px;
            border-bottom: 2px solid rgba(10, 61, 98, 0.2);
            display: flex;
            align-items: center;
            flex-shrink: 0;
        }

        .sidebar-header h2, .layer-sidebar-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
            color: #0a3d62;
        }

        .options-section, .layer-options {
            flex-grow: 1;
            overflow-y: auto;
            padding-right: 7px;
            box-sizing: content-box;
        }

        .options-section::-webkit-scrollbar, .layer-options::-webkit-scrollbar {
            width: 8px;
            background: transparent;
        }

        .options-section::-webkit-scrollbar-thumb, .layer-options::-webkit-scrollbar-thumb {
            background-color: rgba(10, 61, 98, 0.3);
            border-radius: 4px;
        }

        .options-section h3, .layer-options h3 {
            color: #305178;
            margin: 0 0 15px 0;
            font-size: 16px;
            font-weight: bold;
        }

        /* =======================
           4. 첫 번째 사이드바 (상세분석)
        ======================= */
        .sidebar {
            width: 380px;
            padding: 20px;
        }

        /* 검색창 스타일 */
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

        .analysis-btn {
            display: block;
            width: 100%;
            padding: 12px 20px;
            margin-bottom: 8px;
            border: 1px solid #e0e0e0;
            border-radius: 5px;
            background-color: #f8f9fa;
            font-size: 15px;
            font-weight: 500;
            color: #0a3d62;
            cursor: pointer;
            text-align: left;
            transition: all 0.2s ease-in-out;
        }

        .analysis-btn:hover {
            background-color: #e0f0ff;
        }

        .analysis-btn.active {
            background-color: #0a3d62;
            color: #ffffff;
            font-weight: 600;
            border-color: #0a3d62;
        }

        .sidebar-footer {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
            color: white;
            background-color: #0a3d62;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-submit:hover {
            background: #084060;
        }

        /* =======================
           5. 두 번째 사이드바 (데이터 레이어)
        ======================= */
        .layer-sidebar {
            width: 0;
            padding: 25px 0;
            overflow: hidden;
            transition: width 0.4s ease-in-out, padding 0.4s ease-in-out;
        }

        .layer-sidebar.visible {
            width: 350px;
            padding: 20px;
        }

        .layer-sidebar .content-wrapper {
            width: 310px;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .btn-back {
            background: none;
            border: none;
            font-size: 24px;
            font-weight: bold;
            cursor: pointer;
            margin-right: 15px;
            color: #0a3d62;
        }

        .layer-item {
            background-color: #f8f9fa;
            padding: 12px 15px;
            margin-bottom: 8px;
            border-radius: 5px;
            border: 1px solid #ddd;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .layer-item label {
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            color: #0a3d62;
        }

        .layer-item input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .btn-report {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            font-weight: bold; /* 높이, 폰트 크기 수정 */
            color: white;
            background-color: #687D92; /* 연한 색으로 변경 */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            transition: background 0.2s;
        }

        .btn-report:hover {
            background-color: #357ABD;
        }

        /* hover 색상 변경 */
        /* =======================
           6. 리포트 사이드바
        ======================= */
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
            margin-bottom: 10px;
            border-bottom: 2px solid rgba(10, 61, 98, 0.2);
        }

        .report-header h3 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
            color: #0a3d62;
        }

        .close-button {
            background: none;
            border: none;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            color: #888;
        }

        .report-content-wrapper {
            flex-grow: 1;
            overflow-y: auto;
            padding-right: 7px;
        }

        .report-body {
            font-size: 15px;
            line-height: 1.7;
            color: #333;
        }

        .report-section {
            margin-bottom: 25px;
        }

        .report-section h4 {
            font-size: 17px;
            color: #0a3d62;
            margin: 0 0 12px 0;
            border-left: 4px solid #0a3d62;
            padding-left: 10px;
            font-weight: 600;
        }

        #pcaChartContainer {
            width: 100%;
            height: 300px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        /* =======================
		   7. 지도 위 컨트롤 & 범례
		======================= */
        /* 좌/우 컨트롤을 위한 컨테이너 */
        .map-overlay-controls-left {
            position: absolute;
            top: 15px;
            left: 15px;
            z-index: 1000;
            display: flex;
            flex-direction: column;
            gap: 8px; /* 버튼 사이 간격 */
        }

        .map-overlay-controls-right {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 1000;
            display: flex; /* 버튼들을 가로로 나열 */
            gap: 8px; /* 버튼 사이 간격 */
        }

        /* 프랜차이즈 버튼을 감싸는 wrapper 스타일 */
        .franchise-buttons-wrapper {
            display: flex;
            flex-direction: column;
            gap: 8px; /* 버튼 사이 간격 */
        }

        /* 산업별 버튼을 감싸는 wrapper 스타일 */
        .biz-buttons-wrapper {
            display: flex;
            flex-direction: column;
            gap: 8px; /* 버튼 사이 간격 */
        }

        /* 모든 지도 위 버튼에 적용될 공통 스타일 */
        .map-control-btn {
            padding: 8px 12px;
            font-size: 14px;
            font-weight: bold;
            color: #0a3d62;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: all 0.2s;
        }

        .map-control-btn:hover {
            background-color: #f0f0f0;
        }

        .map-control-btn.active {
            background-color: #0a3d62;
            color: white;
            border-color: #0a3d62;
        }

        #toggleHjdLayerBtn:hover {
            background-color: #f0f0f0;
        }

        #toggleHjdLayerBtn.active {
            background-color: #0a3d62;
            color: white;
            border-color: #0a3d62;
        }

        .legend-container {
            margin-top: 20px;
            border-top: 1px solid #e0e0e0;
            padding-top: 15px;
        }

        .legend-container h3 {
            font-size: 16px;
            color: #305178;
            margin: 0 0 15px 0;
            font-weight: bold;
        }

        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .legend-color-box {
            width: 16px;
            height: 16px;
            border: 1px solid #ccc;
            margin-right: 10px;
            flex-shrink: 0;
        }

        /* =======================
		   8. 모달 (AI 분석, 가이드)
		======================= */
        /* 공통 모달 배경 */
        .modal-container, .usage-modal-container {
            display: none; /* 평소엔 숨김 */
            position: fixed;
            z-index: 2000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* 배경 어둡게 */
            /* 중앙 정렬을 위한 Flexbox */
            display: flex;
            align-items: center;
            justify-content: center;
            /* 부드러운 효과를 위한 Transition */
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
        }

        /* 모달이 활성화될 때의 스타일 */
        .modal-container.visible, .usage-modal-container.visible {
            opacity: 1;
            visibility: visible;
        }

        /* AI 분석 모달 콘텐츠 스타일 */
        #aiAnalysisModal .modal-content {
            background-color: #ffffff;
            padding: 0; /* 내부 영역에서 패딩을 직접 제어 */
            border-top: 5px solid #0a3d62; /* 상단에 포인트 컬러 테두리 추가 */
            width: 90%;
            max-width: 720px; /* 리포트 가독성을 위해 너비 확장 */
            border-radius: 8px;
            box-shadow: 0 7px 25px rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            max-height: 85vh; /* 화면보다 커지지 않도록 최대 높이 제한 */
            /* 등장 애니메이션 */
            transform: translateY(-20px);
            transition: transform 0.3s ease-out;
        }

        .modal-container.visible #aiAnalysisModal .modal-content {
            transform: translateY(0);
        }

        /* AI 모달 헤더 */
        #aiAnalysisModal .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #e9ecef;
            flex-shrink: 0; /* 헤더 크기 고정 */
        }

        #aiModalTitle {
            font-size: 22px;
            font-weight: 600;
            color: #0a3d62;
            margin: 0;
        }

        #aiModalTitle .modal-subtitle {
            display: inline-block; /* span을 블록처럼 다루기 위함 */
            font-size: 14px; /* 폰트 크기 줄임 */
            font-weight: 500; /* 폰트 두께 보통으로 */
            color: #555; /* 폰트 색상 약간 연하게 */
            margin-top: 6px; /* 위 제목과의 간격 */
        }

        #aiAnalysisModal .close-btn {
            background: none;
            border: none;
            font-size: 28px;
            font-weight: 400;
            line-height: 1;
            cursor: pointer;
            color: #aaa;
            transition: color 0.2s, transform 0.2s;
        }

        #aiAnalysisModal .close-btn:hover {
            color: #333;
            transform: rotate(90deg);
        }

        /* AI 모달 바디 */
        #aiAnalysisModal .modal-body {
            padding: 25px 30px;
            overflow-y: auto; /* 내용이 길어지면 자동 스크롤 */
            line-height: 1.7;
            color: #333;
            font-size: 15px;
        }

        /* 모달 바디 안의 분석 요청 버튼 */
        #aiModalBody .btn-primary {
            display: block;
            width: 100%;
            padding: 15px;
            font-size: 17px;
            font-weight: bold;
            color: white;
            background-color: #0a3d62; /* '분석하기' 버튼과 통일 */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.2s;
            margin-top: 15px;
        }

        #aiModalBody .btn-primary:hover {
            background-color: #084060;
        }

        /* 모달 바디 안의 텍스트 스타일 */
        #aiModalBody p {
            margin-top: 0;
            margin-bottom: 1rem;
        }

        #aiModalBody p small {
            font-size: 13px;
            color: #6c757d;
        }

        /* AI 분석 결과 리포트 스타일 (리포트 사이드바와 통일) */
        #aiModalBody .report-section {
            margin-bottom: 25px;
        }

        #aiModalBody .report-section h4 {
            font-size: 18px;
            color: #0a3d62;
            margin: 0 0 15px 0;
            border-left: 4px solid #0a3d62;
            padding-left: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        #aiModalBody .report-section h4 i {
            margin-right: 12px;
            color: #357ABD;
            font-size: 1.1em;
        }

        #aiModalBody hr {
            border: 0;
            height: 1px;
            background-color: #e9ecef;
            margin: 30px 0;
        }

        #aiModalBody ul {
            list-style-type: none;
            padding-left: 5px;
        }

        #aiModalBody li {
            padding-left: 15px;
            position: relative;
            margin-bottom: 8px;
        }

        #aiModalBody li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #0a3d62;
            font-weight: bold;
        }

        /* AI 분석 모달 섹션 제목 스타일 */
        .ai-modal-section-title {
            font-size: 18px;
            color: #0a3d62;
            margin: 25px 0 10px 0;
            padding-bottom: 5px;
            border-bottom: 2px solid #e0e0e0;
        }

        /* 첫 번째 제목의 상단 마진은 제거 */
        .ai-modal-section-title:first-child {
            margin-top: 0;
        }

        /* =======================
           AI 분석 결과 테이블 스타일
        ======================= */
        .ai-analysis-table {
            width: 100%;
            border-collapse: collapse; /* 테두리선을 한 줄로 만듭니다. */
            margin-top: 10px;
            font-size: 15px;
            border: 1px solid #dee2e6; /* 테이블 전체 외곽선 */
        }

        .ai-analysis-table th,
        .ai-analysis-table td {
            border: 1px solid #dee2e6; /* 셀 테두리 */
            padding: 12px 15px; /* 셀 안쪽 여백 */
            vertical-align: middle; /* 내용 수직 정렬 */
        }

        .ai-analysis-table th {
            background-color: #f8f9fa; /* 헤더 배경색 (연한 회색) */
            font-weight: 600; /* 헤더 글씨 굵게 */
            color: #495057;
            text-align: center; /* 헤더 텍스트 가운데 정렬 */
            width: 120px; /* 첫 번째 '항목' 컬럼 너비 고정 */
        }

        .ai-analysis-table td {
            color: #212529; /* 내용 글씨 색상 */
            line-height: 1.6; /* 내용 줄 간격 */
        }

        /* 내용이 없을 경우 회색으로 표시 */
        .ai-analysis-table td.no-data {
            color: #888;
            font-style: italic;
        }

        /* AI 모달 푸터 및 PDF 저장 버튼 */
        #aiAnalysisModal .modal-footer {
            padding: 15px 25px;
            border-top: 1px solid #e9ecef;
            background-color: #f8f9fa;
        }

        .btn-print {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            font-weight: bold;
            color: white;
            background-color: #28a745; /* 초록색 계열 */
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-print:hover {
            background-color: #218838;
        }

        .btn-print:disabled { /* 비활성화 상태 (로딩 중) */
            background-color: #6c757d;
            cursor: not-allowed;
        }

        /* 스피너 스타일 */
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #0a3d62;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;
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

        /* 가이드 모달 */
        .usage-modal-container .modal-content {
            position: absolute;
            background-color: #0a3d62;
            color: #ffffff;
            padding: 25px;
            border: 1px solid #084060;
            width: 340px;
            border-radius: 8px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.4);
            line-height: 1.6;
            /* 등장 애니메이션 */
            transform: scale(0.95);
            transition: transform 0.3s ease-out;
        }

        .usage-modal-container.visible .modal-content {
            transform: scale(1);
        }

        .usage-modal-container .modal-content::before {
            content: '';
            position: absolute;
            top: 30px;
            border-top: 10px solid transparent;
            border-bottom: 10px solid transparent;
        }

        #usageModalStep1 .modal-content {
            top: 50px;
            left: 400px;
        }

        #usageModalStep1 .modal-content::before {
            left: -10px;
            border-right: 10px solid #0a3d62;
        }

        #usageModalStep2 .modal-content {
            top: 120px;
            left: 750px;
        }

        #usageModalStep2 .modal-content::before {
            left: -10px;
            border-right: 10px solid #0a3d62;
        }

        #usageModalStep3 .modal-content {
            top: 120px;
            right: 470px;
        }

        #usageModalStep3 .modal-content::before {
            right: -10px;
            border-left: 10px solid #0a3d62;
        }

        #usageModalStep4 .modal-content {
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) scale(1);
        }

        /* 가이드 모달 내부 요소들 (기존과 거의 동일) */
        .usage-modal-container h5 {
            margin: 0 0 15px 0;
            font-size: 18px;
            color: #ffffff;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }

        .usage-modal-container p {
            font-size: 14px;
            margin: 0 0 15px 0;
            color: #e0e0e0;
        }

        .usage-modal-container .modal-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.3);
        }

        .usage-modal-container .checkbox-group {
            display: flex;
            align-items: center;
        }

        .usage-modal-container .modal-footer label {
            margin-left: 8px;
            font-size: 13px;
            color: #d0d0d0;
            cursor: pointer;
        }

        .usage-modal-container .btn-confirm {
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

        .usage-modal-container .btn-confirm:hover {
            background-color: #e0f0ff;
        }

        /* =======================
           9. [신규] 프랜차이즈 팝업 스타일
        ======================= */
        .map-popup {
            position: absolute;
            background-color: white;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
            padding: 15px;
            border-radius: 10px;
            border: 1px solid #cccccc;
            min-width: 280px;
            /* [핵심 수정] transform으로 팝업 위치를 조정합니다. */
            transform: translate(-50%, calc(-100% - 12px));
            transition: transform 0.2s ease-out;
        }

        .map-popup:after, .map-popup:before {
            top: 100%;
            border: solid transparent;
            content: " ";
            height: 0;
            width: 0;
            position: absolute;
            pointer-events: none;
        }

        .map-popup:after {
            border-top-color: white;
            border-width: 10px;
            left: 50%;
            margin-left: -10px;
        }

        .map-popup:before {
            border-top-color: #cccccc;
            border-width: 11px;
            left: 50%;
            margin-left: -11px;
        }

        .popup-closer {
            text-decoration: none;
            position: absolute;
            top: 2px;
            right: 8px;
            font-size: 20px;
            color: #555;
        }

        .popup-closer:hover {
            color: #000;
        }

        .popup-title {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 8px;
            color: #0a3d62;
        }

        .popup-content p {
            margin: 5px 0;
            font-size: 14px;
            color: #333;
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="container" id="mainContainer">
        <aside class="sidebar">
            <div class="sidebar-header"><h2>상세분석</h2></div>

            <div class="search-box">
                <input type="text" id="addressSearchInput" placeholder="주소, 건물명 또는 위치 검색">
                <button id="addressSearchButton">
                    <i class="fa fa-search"></i>
                </button>
            </div>

            <div class="analysis-options">
                <h3>분석 모델 선택</h3>
                <ul>
                    <li>
                        <button class="analysis-btn" data-analysis-type="다중회귀모형">다중회귀모형분석</button>
                    </li>
                    <li>
                        <button class="analysis-btn" data-analysis-type="군집분석">군집분석</button>
                    </li>
                    <li>
                        <button class="analysis-btn" data-analysis-type="로지스틱">로지스틱분석</button>
                    </li>
                    <li>
                        <button class="analysis-btn" data-analysis-type="중력모형">중력모형분석</button>
                    </li>
                </ul>
                <h4>1. 원하는 분석 모델을 선택하세요.</h4>
            </div>
            <div class="legend-container" id="analysisLegendContainer"
                 style="display: none; margin-top: 20px; border-top: 1px solid #eee; padding-top: 10px;">
                <h3 style="font-size: 16px; color: #333; margin: 0 0 15px 0;">범례</h3>
                <div id="analysisLegend"></div>
            </div>
            <div class="legend-container" id="overlayLegendContainer"
                 style="margin-top: 15px; border-top: 1px solid #eee; padding-top: 10px; display: none;">
                <h3 style="font-size: 16px; color: #333; margin: 0 0 15px 0;">레이어링 버튼 범례</h3>
                <div id="overlayLegend"></div>
            </div>
            <div class="sidebar-footer">
                <button class="btn-submit" id="analyzeBtn">분석하기</button>
                <h4>2. 분석하기 버튼을 눌러보세요.</h4>
            </div>
        </aside>

        <aside class="layer-sidebar" id="layerSidebar">
            <div class="content-wrapper">
                <div class="layer-sidebar-header">
                    <button class="btn-back" id="backBtn">‹</button>
                    <h2>분석 결과 선택</h2>
                </div>
                <div class="layer-options">
                    <button id="showReportBtn" class="btn-report">분석결과 해석 보기</button>
                    <%-- ✨ 이 부분의 정적 리스트를 삭제하고 비워둡니다. --%>
                    <h3>3. 지도에 표시할 분석 결과를 선택하세요.</h3>
                    <ul id="layerList"></ul>
                </div>
            </div>
        </aside>

        <main class="main-content">
            <div class="map-overlay-controls-left">
                <button id="toggleHjdLayerBtn" class="map-control-btn">행정동 경계</button>
                <div class="franchise-buttons-wrapper">
                    <button class="franchise-btn map-control-btn" data-franchise="스타벅스">스타벅스</button>
                    <button class="franchise-btn map-control-btn" data-franchise="빽다방">빽다방</button>
                    <button class="franchise-btn map-control-btn" data-franchise="맥도날드">맥도날드</button>
                    <button class="franchise-btn map-control-btn" data-franchise="도미노피자">도미노피자</button>
                    <button class="franchise-btn map-control-btn" data-franchise="서브웨이">서브웨이</button>
                </div>
                <div class="biz-buttons-wrapper">
                    <button class="biz-btn map-control-btn" data-biz-type="도매 및 소매업">도매 및 소매업</button>
                    <button class="biz-btn map-control-btn" data-biz-type="숙박 및 음식점업">숙박 및 음식점업</button>
                    <button class="biz-btn map-control-btn" data-biz-type="금융 및 보험업">금융 및 보험업</button>
                    <button class="biz-btn map-control-btn" data-biz-type="교육 서비스업">교육 서비스업</button>
                </div>
            </div>

            <div class="map-overlay-controls-right">
                <button id="homeBtn" class="map-control-btn">홈</button>
                <sec:authorize access="isAuthenticated()">
                    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post"
                          style="display: none;"></form>
                    <button id="logoutBtn" class="map-control-btn">로그아웃</button>
                </sec:authorize>
                <button id="guideBtn" class="map-control-btn">튜토리얼</button>
                <button id="myBtn" class="map-control-btn">마이페이지</button>
            </div>

            <div class="map-area">
                <div id="vmap"></div>
                <div id="popup" class="map-popup">
                    <a href="#" id="popup-closer" class="popup-closer">&times;</a>
                    <div id="popup-content"></div>
                </div>
            </div>
        </main>

        <%-- 리포트 사이드바 HTML 구조 추가 --%>
        <aside id="reportSidebar" class="report-sidebar">
            <div class="report-header">
                <h3>분석 결과 리포트</h3>
                <button class="close-button" id="closeReportBtn">&times;</button>
            </div>
            <div class="report-content-wrapper">
                <div class="report-body" id="reportBody">
                    <%-- JS가 이곳에 동적으로 분석 결과 해석을 채워줍니다. --%>
                </div>
                <div id="pcaChartContainer" style="display: none;"></div>
            </div>
        </aside>

    </div>
</div>

<!-- 격자별 ai 해석(모달창) -->
<div id="aiAnalysisModal" class="modal-container">
    <div class="modal-content">
        <div class="modal-header">
            <h5 id="aiModalTitle">AI 상세 분석 리포트</h5>
            <button type="button" class="close-btn" id="closeAiModal">&times;</button>
        </div>
        <div class="modal-body" id="aiModalBody">
            <%-- AI 분석 결과가 여기에 동적으로 채워집니다. --%>
        </div>
        <%-- ▼▼▼▼▼ [수정] 버튼을 감싸는 푸터 영역 추가 ▼▼▼▼▼ --%>
        <div class="modal-footer" id="aiModalFooter">
            <button class="btn-print" id="printPdfButton" disabled>PDF로 저장 (마이페이지)</button>
        </div>
        <%-- ▲▲▲▲▲ [수정] 버튼을 감싸는 푸터 영역 추가 ▲▲▲▲▲ --%>
    </div>
</div>

<div id="usageModalStep1" class="usage-modal-container">
    <div class="modal-content">
        <h5>Step 1. 분석 모델 선택</h5>
        <p>
            가장 먼저, 좌측 메뉴에서 원하는 분석 모델을 선택한 후<br>
            '분석하기' 버튼을 클릭하세요.
        </p>
        <div style="text-align: right;">
            <button id="confirmModalStep1" class="btn-confirm">다음</button>
        </div>
    </div>
</div>

<div id="usageModalStep2" class="usage-modal-container">
    <div class="modal-content">
        <h5>Step 2. 분석 레이어 선택</h5>
        <p>
            분석 실행 후, 이곳에서 지도에 표시할 세부 데이터 레이어를 선택하거나<br>
            '분석결과 해석 보기' 버튼으로 리포트를 확인할 수 있습니다.
        </p>
        <div style="text-align: right;">
            <button id="confirmModalStep2" class="btn-confirm">다음</button>
        </div>
    </div>
</div>

<div id="usageModalStep3" class="usage-modal-container">
    <div class="modal-content">
        <h5>Step 3. AI 분석 리포트 확인</h5>
        <p>
            '분석결과 해석 보기'를 누르면, 이곳에서 선택한 데이터에 대한 AI의 심층 분석 리포트와 관련 차트를 볼 수 있습니다.
        </p>
        <div style="text-align: right;">
            <button id="confirmModalStep3" class="btn-confirm">다음</button>
        </div>
    </div>
</div>

<div id="usageModalStep4" class="usage-modal-container">
    <div class="modal-content">
        <h5>Step 4. 격자별 AI 상세 분석</h5>
        <p>
            마지막으로, 지도 위의 특정 격자(칸)를 클릭하면<br>
            해당 격자에 대한 AI의 심층 분석을<br>
            별도로 요청하고 확인할 수 있습니다.
        </p>
        <div class="modal-footer">
            <div class="checkbox-group">
                <input type="checkbox" id="hideModalCheckbox">
                <label for="hideModalCheckbox">하루 동안 보지 않기</label>
            </div>
            <button id="confirmModalStep4" class="btn-confirm">시작하기!</button>
        </div>
    </div>
</div>

<script type="text/javascript"
        src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=B346494D-259D-3E0B-AFE4-6862A39827F8&domain=http://192.168.45.75"></script>

<script>
    // JSP의 contextPath를 JavaScript 전역 변수로 전달합니다.
    const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/market/detailed/map-detail-analysis.js"></script>

</body>
</html>