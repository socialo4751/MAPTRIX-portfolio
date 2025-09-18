<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/highcharts-more.js"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!-- ✅ Font Awesome 5.15.4 CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <link rel="stylesheet" href="/css/keywordstyle.css">
    <style>
        .keyword-container {
            max-width: 1400px;
            margin: 50px auto;
            padding: 0 20px;
        }

        /* 헤더 라인 정렬 */
        .result-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .result-header .left,
        .result-header .center,
        .result-header .right {
            display: flex;
            flex-direction: column;
        }

        .result-header .left {
            flex: 1;
            max-width: 33%;
        }

        .result-header .center {
            flex: 1;
            text-align: center;
        }

        .result-header .right {
            flex: 1;
            max-width: 33%;
            align-items: flex-end;
            text-align: right;
        }

        .keyword-label {
            font-weight: bold;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .search-form-inline {
            display: flex;
            gap: 10px;
            flex-wrap: nowrap;
        }

        .search-form-inline input[type="text"] {
            padding: 8px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 14px;
            width: 160px;
        }

        .search-form-inline button {
            padding: 8px 12px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }

        .search-form-inline .btn-search {
            background-color: #03C75A;
            color: white;
        }

        .search-form-inline .btn-reset {
            background-color: #6c757d;
            color: white;
        }

        .result-title {
            font-size: 16px;
            font-weight: bold;
        }

        .result-area {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }

        .panel {
            background-color: white;
            padding: 20px 25px;
            /*  border: 1px solid #e0e0e0;
              border-radius: 8px;
              box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);*/
        }

        .chart-panel {
            width: 70%;
        }

        .ranking-panel {
            width: 30%;
        }

        .panel-title {
            font-size: 1.2em;
            font-weight: bold;
            margin-bottom: 15px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
        }

        .ranking-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .ranking-table th,
        .ranking-table td {
            padding: 10px;
            text-align: left;
        }

        .ranking-table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #e0e0e0;
        }

        .ranking-table td.rank {
            text-align: center;
            font-weight: bold;
            color: #03C75A;
        }

        .ranking-table td.rank-secondary {
            text-align: center;
            color: #6c757d;
        }

        .ranking-table td.count {
            text-align: right;
        }

        .related-keyword {
            cursor: pointer; /* 마우스를 올리면 손가락 모양으로 변경 */
            color: #0d6efd; /* 링크처럼 보이도록 색상 지정 */
            text-decoration: underline;
            font-weight: bold;
        }

        .related-keyword:hover {
            color: #0a58ca; /* 마우스를 올렸을 때 색상 변경 */
        }

        /* search.jsp 전용 헤더 가운데 정렬 */
        .search-page .mypage-header {
            display: flex;
            flex-direction: column;
            align-items: center; /* 가로 가운데 */
            text-align: center; /* 텍스트도 가운데 */
        }

        .search-page .page-header h2 {
            margin: 0 0 10px 0;
        }

        .search-page .page-header p {
            margin: 0;
        }

    </style>
</head>
<body>

<jsp:include page="/WEB-INF/views/include/top.jsp"/>

<%-- 초기 데이터 할당 --%>
<script>
    window.initialKeyword = "${initialKeyword}";
    window.initialData = ${initialData};
</script>

<div class="keyword-container">
    <div class="search-page">
        <div class="mypage-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                SNS 키워드 분석
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">키워드를 입력하면 SNS에서 함께 언급되는 키워드의 순위를 확인 할 수 있습니다.</p>
            </div>
        </div>
    </div>
    <div id="resultContainer" style="display: none;">
        <!-- ⬇ 헤더: 검색창 / 제목 / 순위 텍스트 -->
        <div class="result-header">
        </div>

        <!-- ⬇ 차트 + 순위 패널 -->
        <div class="result-area">
            <div class="panel chart-panel">
                <h4 class="panel-title" style="display: flex; justify-content: space-between">검색 키워드
                    <form id="searchForm" onsubmit="startSearch(event)">
                        <div class="search-form-inline">
                            <input type="text" id="keywordInput" name="keyword" placeholder="예: 여름휴가" required>
                            <button id="searchBtn" type="submit" class="btn-search">분석하기</button>
                            <button type="button" class="btn-reset" onclick="resetPage()">초기화</button>
                        </div>
                    </form>
                </h4>
                <div class="center">
                    <h3 class="result-title" style="font-size: 30px; text-align:  center;"><span
                            id="searchedKeyword"></span> SNS 분석 결과</h3>
                </div>
                <div id="chart-container" style="height: 600px;"></div>
            </div>

            <div class="panel ranking-panel">
                <h4 class="panel-title" style="padding-bottom: 24px;">연관어 순위</h4>
                <table class="ranking-table">
                    <thead>
                    <tr>
                        <th style="width: 15%;">순위</th>
                        <th style="width: 55%;">연관어</th>
                        <th style="width: 30%; text-align: right;">검색량</th>
                    </tr>
                    </thead>
                    <tbody id="ranking-body"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="/js/bizstats/keyword/search.js"></script>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

</body>
</html>
