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
    <style>
        /* 기본 스타일 초기화 */
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
            height: 100%;
            background-color: #f8f9fa;
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

        /* 전체 레이아웃 */
        .page-wrapper {
            display: flex;
            flex-direction: column;
            height: 100vh;
        }
        
        /* 메인 컨텐츠 영역 */
        .container {
            display: flex;
            flex-grow: 1;
            height: 100vh; /* 헤더가 없으므로 전체 높이 사용 */
        }

        /* 사이드바 */
        .sidebar {
            background-color: white;
            width: 350px;
            padding: 25px;
            box-sizing: border-box;
            border-right: 1px solid #e0e0e0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
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
        
        .filter-options {
            flex-grow: 1;
            overflow-y: auto;
        }
        
        /* 필터 섹션 스타일 */
        .filter-section {
            margin-bottom: 25px;
        }

        .filter-section h3 {
            font-size: 16px;
            color: #333;
            margin: 0 0 15px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .filter-section .input-group {
            margin-bottom: 10px;
        }

        .filter-section label {
            display: block;
            font-size: 14px;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .filter-section input[type="date"],
        .filter-section select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        .date-range {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .date-range span {
            font-weight: bold;
        }


        .sidebar-footer {
            margin-top: auto; /* 하단에 고정 */
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .btn-submit {
            width: 100%;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
            color: white;
            background-color: #19a538; /* 초록색 */
            border: none;
            border-radius: 5px;
        }
        
        /* 메인 콘텐츠 (분석 결과) */
        .main-content {
            flex-grow: 1;
            padding: 30px;
            overflow-y: auto;
        }
        
        .analysis-result-placeholder {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
            background-color: white;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            text-align: center;
            color: #777;
        }
        .analysis-result-placeholder h3 {
            font-size: 24px;
            margin: 0;
        }
        .analysis-result-placeholder p {
            font-size: 16px;
        }

    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="container">
            <aside class="sidebar">
                <div class="sidebar-header">
                    <h2>매장 필터</h2>
                </div>
                
                <div class="filter-options">
                    
                    <div class="filter-section">
                        <h3>신규 오픈 매장 조회</h3>
                        <div class="input-group">
                            <label for="open-start-date">오픈 기간</label>
                            <div class="date-range">
                                <input type="date" id="open-start-date">
                                <span>~</span>
                                <input type="date" id="open-end-date">
                            </div>
                        </div>
                    </div>

                    <div class="filter-section">
                        <h3>폐업 매장 조회</h3>
                        <div class="input-group">
                            <label for="close-start-date">폐업 기간</label>
                            <div class="date-range">
                                <input type="date" id="close-start-date">
                                <span>~</span>
                                <input type="date" id="close-end-date">
                            </div>
                        </div>
                    </div>

                    <div class="filter-section">
                        <h3>오픈/폐업 필터 설정</h3>
                        <div class="input-group">
                            <label for="industry-type">업종 선택</label>
                            <select id="industry-type">
                                <option>전체 업종</option>
                                <option>음식점</option>
                                <option>소매업</option>
                                <option>서비스업</option>
                                <option>교육</option>
                            </select>
                        </div>
                        <div class="input-group">
                            <label for="region">지역 선택</label>
                            <select id="region">
                                <option>대전광역시 전체</option>
                                <option>유성구</option>
                                <option>서구</option>
                                <option>중구</option>
                                <option>동구</option>
                                <option>대덕구</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="sidebar-footer">
                    <button class="btn-submit">필터 적용</button>
                </div>
            </aside>

            <main class="main-content">
                <div class="analysis-result-placeholder">
                    <div>
                        <h3>지도 데이터</h3>
                        <p>왼쪽에서 필터를 설정하고 '필터 적용' 버튼을 누르면<br>결과가 지도에 표시됩니다.</p>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
</body>
</html>