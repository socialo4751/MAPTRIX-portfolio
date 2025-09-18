<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            background-color: #f8f9fa;
            overflow: hidden;
        }

        a, button {
            text-decoration: none;
            color: inherit;
            cursor: pointer;
        }

        ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        * {
            box-sizing: border-box;
        }

        .container {
            display: flex;
            position: relative;
            height: 100vh;
        }

        .sidebar {
            background-color: white;
            width: 350px;
            padding: 25px;
            border-right: 1px solid #e0e0e0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            z-index: 20;
        }

        .sidebar-header {
            padding-bottom: 15px;
            margin-bottom: 20px;
            border-bottom: 2px solid #333;
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 22px;
            color: #111;
        }

        .franchise-filter {
            flex-grow: 1;
            overflow-y: auto;
        }

        .franchise-filter h3 {
            font-size: 16px;
            color: #333;
            margin: 0 0 15px 0;
        }

        .franchise-list button {
            width: 100%;
            display: flex;
            align-items: center;
            padding: 12px 15px;
            margin-bottom: 8px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            transition: all 0.2s ease-in-out;
        }

        .franchise-list button:hover {
            border-color: #19a538;
            color: #19a538;
        }

        .franchise-list button.active {
            background-color: #19a538;
            color: white;
            border-color: #19a538;
        }

        .sub-sidebar-modal {
            position: absolute;
            top: 0;
            left: 350px;
            width: 350px;
            height: 100%;
            background-color: white;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
            z-index: 10;
            display: flex;
            flex-direction: column;
            transform: translateX(-100%);
            opacity: 0;
            visibility: hidden;
            transition: transform 0.3s ease-in-out, opacity 0.3s ease-in-out, visibility 0.3s;
        }

        .sub-sidebar-modal.visible {
            transform: translateX(0);
            opacity: 1;
            visibility: visible;
        }

        .sub-sidebar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            border-bottom: 1px solid #eee;
            flex-shrink: 0;
        }

        .sub-sidebar-header h3 {
            font-size: 18px;
            margin: 0;
        }

        .close-sub-sidebar {
            background: none;
            border: none;
            font-size: 28px;
            font-weight: bold;
            color: #aaa;
        }

        .sub-sidebar-body {
            padding: 0 20px 20px 20px;
            overflow-y: auto;
            flex-grow: 1;
        }

        .results-list li {
            padding: 15px 10px;
            border-bottom: 1px solid #f0f0f0;
        }

        .results-list .store-name {
            font-weight: bold;
            font-size: 15px;
            margin-bottom: 5px;
        }

        .results-list .store-address {
            font-size: 13px;
            color: #666;
        }

        .results-list .store-phone {
            font-size: 13px;
            color: #888;
            margin-top: 3px;
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

        .ol-popup {
            position: absolute;
            background-color: #ffffff;
            padding: 15px 18px;
            border: 1px solid #ccc;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            min-width: 220px;
            z-index: 1000;
            transition: all 0.2s ease-in-out;
            font-family: 'Malgun Gothic', sans-serif;
        }

        .popup-content-box {
            font-size: 14px;
            color: #333;
        }

        .popup-title {
            font-weight: bold;
            font-size: 18px;
            color: #198754;
            margin-bottom: 12px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 6px;
            white-space: nowrap; /* ✅ 이 줄 추가 */
        }

        .popup-row {
            display: flex;
            gap: 8px;
            margin: 8px 0;
            align-items: center;
        }

        .popup-label {
            font-weight: 600;
            color: #666;
            min-width: 60px;
        }

        .popup-value {
            color: #212529;
            flex-grow: 1;
            word-break: break-all;
        }

        /* 지도 위 버튼 스타일 */
        .map-overlay-controls-right {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 1000;
            display: flex; /* 버튼들을 가로로 나열 */
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
    </style>
</head>
<body>
<div class="container">
    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>매장찾기</h2>
        </div>
        <div class="franchise-filter">
            <h3>프랜차이즈 선택</h3>
            <ul class="franchise-list">
                <li>
                    <button class="franchise-btn" data-franchise="스타벅스">스타벅스</button>
                </li>
                <li>
                    <button class="franchise-btn" data-franchise="빽다방">빽다방</button>
                </li>
                <li>
                    <button class="franchise-btn" data-franchise="맥도날드">맥도날드</button>
                </li>
                <li>
                    <button class="franchise-btn" data-franchise="도미노피자">도미노피자</button>
                </li>
                <li>
                    <button class="franchise-btn" data-franchise="서브웨이">서브웨이</button>
                </li>
            </ul>
        </div>
    </aside>

    <div class="sub-sidebar-modal" id="subSidebar">
        <div class="sub-sidebar-header">
            <h3 id="subSidebarTitle"></h3>
            <button class="close-sub-sidebar" id="closeSubSidebar">&times;</button>
        </div>
        <div class="sub-sidebar-body">
            <ul class="results-list" id="resultsList"></ul>
        </div>
    </div>

    <main class="main-content">
        <div class="map-area">
            <!-- 지도 위에 버튼 보이기 -->
            <div class="map-overlay-controls-right">
                <button id="homeBtn" class="map-control-btn">홈</button>
                <sec:authorize access="isAuthenticated()">
                    <form id="logoutForm" action="${pageContext.request.contextPath}/logout" method="post"
                          style="display: none;"></form>
                    <button id="logoutBtn" class="map-control-btn">로그아웃</button>
                </sec:authorize>
                <button id="myBtn" class="map-control-btn">마이페이지</button>
            </div>
            <!-- 지도 위에 버튼 보이기 끝 -->
            <div id="vmap"></div>

            <div id="loadingSpinner" style="...">
                <div class="spinner-border text-success" role="status">
                    <span class="visually-hidden">로딩 중...</span>
                </div>
            </div>

            <div id="popup" class="ol-popup">
                <div id="popup-content"></div>
            </div>
        </div>
    </main>
</div>


<script type="text/javascript"
        src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=B346494D-259D-3E0B-AFE4-6862A39827F8&domain=http://192.168.45.75"></script>

<script>
    const contextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/js/bizstats/franchises/map-franchises.js"></script>
</body>
</html>
