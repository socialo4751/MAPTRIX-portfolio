<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 통계 대시보드 - 화면 정의서</title>
    <style>
        body {
            font-family: 'Malgun Gothic', 'Apple SD Gothic Neo', sans-serif;
            background-color: #f0f2f5;
            color: #333;
            margin: 0;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        h2 {
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }

        /* 탭 메뉴 */
        .dash-tabs {
            display: flex;
            margin-bottom: -1px; /* 아래 패널과 경계선 겹치게 */
        }
        .dash-tabs button {
            padding: 12px 25px;
            border: 1px solid #ddd;
            background-color: #f9f9f9;
            cursor: pointer;
            font-size: 16px;
            border-bottom: none;
        }
        .dash-tabs button.active {
            background-color: white;
            border-bottom: 1px solid white;
            font-weight: bold;
            position: relative;
            z-index: 2;
        }

        /* 패널 공통 스타일 */
        .panel {
            background-color: white;
            border: 1px solid #ddd;
            padding: 25px;
            border-radius: 5px;
        }
        .panel:first-of-type {
            border-top-left-radius: 0;
        }

        /* 차트 영역 */
        .chart-row {
            display: flex;
            gap: 25px;
            margin-top: 20px;
        }
        .chart-wrapper {
            flex: 1;
            padding: 20px;
            border: 1px solid #e9e9e9;
            border-radius: 5px;
        }
        .chart-wrapper h4 {
            margin-top: 0;
            text-align: center;
            font-size: 18px;
        }
        .chart-area {
            height: 200px;
            position: relative;
            display: flex;
            border-left: 1px solid #ccc;
            border-bottom: 1px solid #ccc;
        }
        .y-axis {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding-right: 10px;
            text-align: right;
            font-size: 12px;
            height: 100%;
        }
        .chart-body {
            flex-grow: 1;
            position: relative;
            display: flex;
            justify-content: space-around;
            align-items: flex-end;
        }
        .x-axis {
            position: absolute;
            bottom: -25px;
            width: 100%;
            display: flex;
            justify-content: space-around;
            font-size: 12px;
        }
        .legend {
            text-align: center;
            margin-top: 30px;
            font-size: 12px;
        }
        .legend-dot {
            display: inline-block;
            width: 10px;
            height: 10px;
            background-color: #5470c6;
            border-radius: 50%;
            margin-right: 5px;
            vertical-align: middle;
        }

        /* 막대 차트 */
        .bar {
            width: 10%;
            background-color: #91cc75;
        }
        .bar:nth-child(1) { height: 20%; background-color: #5470c6; }
        .bar:nth-child(2) { height: 70%; background-color: #fac858; }
        .bar:nth-child(3) { height: 70%; background-color: #ee6666; }
        .bar:nth-child(4) { height: 30%; background-color: #73c0de; }
        .bar:nth-child(5) { height: 0%;  }
        .bar:nth-child(6) { height: 95%; background-color: #fc8452; }

        /* 선 차트 */
        .line-chart .chart-body { align-items: initial; }
        .line-chart .point {
            position: absolute;
            width: 10px;
            height: 10px;
            background-color: #5470c6;
            border-radius: 50%;
            transform: translate(-50%, -50%); /* 중앙 정렬 */
        }
        /* 데이터 포인트 위치 시뮬레이션 */
        .line-chart .point:nth-child(1) { top: 85%; left: 10%; }
        .line-chart .point:nth-child(2) { top: 60%; left: 25%; }
        .line-chart .point:nth-child(3) { top: 20%; left: 40%; }
        .line-chart .point:nth-child(4) { top: 25%; left: 55%; }
        .line-chart .point:nth-child(5) { top: 30%; left: 70%; }
        .line-chart .point:nth-child(6) { top: 45%; left: 85%; }

        /* 영역형 차트 */
        .area-shape {
            width: 100%;
            height: 100%;
            background-color: rgba(84, 112, 198, 0.3);
            clip-path: polygon(10% 80%, 90% 10%, 90% 100%, 10% 100%);
        }

        /* 필터 패널 */
        .filter-panel {
            margin-top: 25px;
            margin-bottom: 25px;
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            padding: 15px;
        }
        .filter-panel label { font-weight: bold; }
        .filter-panel input[type="date"], .filter-panel select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .filter-panel button {
            padding: 8px 20px;
            background-color: #5470c6;
            color: white;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <h2>회원 통계 대시보드</h2>
    <nav class="dash-tabs">
        <button class="active">회원가입 현황</button>
        <button>회원유형 분포</button>
        <button>회원활동 현황</button>
        <button>지역별 조회 현황</button>
        <button>시스템 로그 통계</button>
    </nav>

    <div class="panel">
        <h3>회원 가입 현황</h3>
        <div class="chart-row">
            <div class="chart-wrapper">
                <h4>월별 회원 가입 수</h4>
                <div class="chart-area">
                    <div class="y-axis"><span>20</span><span>15</span><span>10</span><span>5</span><span>0</span></div>
                    <div class="chart-body">
                        <div class="bar"></div><div class="bar"></div><div class="bar"></div>
                        <div class="bar"></div><div class="bar"></div><div class="bar"></div>
                        <div class="x-axis">
                            <span>2024-12</span><span>2025-01</span><span>2025-02</span>
                            <span>2025-03</span><span>2025-04</span><span>2025-05</span>
                        </div>
                    </div>
                </div>
                <div class="legend"><span class="legend-dot"></span>가입 수</div>
            </div>
            <div class="chart-wrapper">
                <h4>요일별 회원 가입 수</h4>
                <div class="chart-area line-chart">
                    <div class="y-axis"><span>15</span><span>10</span><span>5</span><span>0</span></div>
                    <div class="chart-body">
                        <div class="point"></div><div class="point"></div><div class="point"></div>
                        <div class="point"></div><div class="point"></div><div class="point"></div>
                        <div class="x-axis">
                            <span>월요일</span><span>화요일</span><span>수요일</span>
                            <span>목요일</span><span>금요일</span><span>토요일</span>
                        </div>
                    </div>
                </div>
                <div class="legend"><span class="legend-dot"></span>가입 수</div>
            </div>
        </div>
    </div>

    <div class="panel filter-panel">
        <label for="start-date">시작일:</label>
        <input type="date" id="start-date" value="2025-04-14">
        <label for="end-date">종료일:</label>
        <input type="date" id="end-date" value="2025-07-14">
        <label for="unit">단위:</label>
        <select id="unit">
            <option>월별</option>
            <option>주별</option>
            <option>일별</option>
        </select>
        <button>조회</button>
    </div>

    <div class="panel">
        <div class="chart-wrapper">
            <h4>기간별 회원 가입</h4>
            <div class="chart-area">
                <div class="y-axis"><span>20</span><span>10</span><span>0</span></div>
                <div class="chart-body">
                    <div class="area-shape"></div>
                    <div class="x-axis"><span>2025-04</span><span>2025-05</span></div>
                </div>
            </div>
            <div class="legend"><span class="legend-dot"></span>가입 수</div>
        </div>
    </div>
</div>
</body>
</html>