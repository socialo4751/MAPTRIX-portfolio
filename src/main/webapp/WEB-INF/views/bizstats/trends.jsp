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
            background-color: #f8f9fa;
        }
        * { box-sizing: border-box; }

        /* 페이지 컨테이너 */
        .page-container {
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px;
        }

        /* 페이지 헤더 */
        .page-header h1 { font-size: 28px; margin: 0 0 20px 0; }

        /* 탭 메뉴 */
        .tab-menu { border-bottom: 2px solid #ddd; margin-bottom: 25px; }
        .tab-menu button {
            background: none; border: none; font-size: 18px; font-weight: bold;
            padding: 15px 25px; cursor: pointer; color: #888;
            border-bottom: 4px solid transparent; margin-bottom: -2px;
        }
        .tab-menu button.active { color: #19a538; border-bottom-color: #19a538; }
        
        /* 분석 컨텐츠 컨테이너 */
        .analysis-container { display: none; }
        .analysis-container.active { display: block; }

        /* --- 1. 상권 키워드 분석 스타일 --- */
        .filter-panel {
            background-color: white; padding: 20px 25px; border: 1px solid #e0e0e0;
            border-radius: 8px; display: flex; align-items: center; gap: 15px; margin-bottom: 25px;
        }
        .filter-panel input[type="text"], .filter-panel input[type="date"] {
            border: 1px solid #ccc; border-radius: 5px; padding: 8px 12px; font-size: 14px;
        }
        .filter-panel input[type="text"] { width: 250px; }
        .filter-panel .radio-group label { margin: 0 15px 0 5px; font-size: 14px; cursor: pointer; }
        .filter-panel .buttons { margin-left: auto; display: flex; gap: 10px; }
        .filter-panel button {
            border: none; padding: 8px 20px; font-size: 14px;
            font-weight: bold; border-radius: 5px; cursor: pointer;
        }
        .btn-primary { background-color: #19a538; color: white; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-reset { background-color: #f8f9fa; color: #333; border: 1px solid #ccc; }

        .analysis-content { background-color: white; padding: 30px; border: 1px solid #e0e0e0; border-radius: 8px; }
        .content-header { text-align: center; margin-bottom: 40px; }
        .content-header h2 { font-size: 24px; margin: 0; }
        .content-header h2 span { color: #19a538; }
        .content-body { display: flex; gap: 40px; }
        .word-cloud-container { flex: 3; position: relative; height: 500px; }
        .bubble {
            position: absolute; border-radius: 50%; display: flex; justify-content: center;
            align-items: center; color: white; font-weight: bold; font-size: 16px;
        }
        .legend { margin-top: 20px; display: flex; flex-wrap: wrap; gap: 15px; font-size: 12px; }
        .legend-item { display: flex; align-items: center; }
        .legend-color { width: 12px; height: 12px; border-radius: 50%; margin-right: 5px; }

        .keyword-rank-container { flex: 2; }
        .keyword-rank-container h3 { margin-top: 0; font-size: 18px; }
        .rank-table { width: 100%; border-collapse: collapse; font-size: 14px; }
        .rank-table th, .rank-table td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #eee; }
        .rank-table thead th { background-color: #f8f9fa; border-top: 2px solid #ddd; border-bottom: 2px solid #ddd; font-weight: bold; }
        .rank-table td:first-child { text-align: center; font-weight: bold; color: #19a538; }
        .rank-table td:last-child { text-align: right; color: #666; }
        .rank-table tbody tr:hover { background-color: #f8f9fa; }

        /* --- 2. 뉴스 기사 분석 스타일 (아코디언) --- */
        .accordion-item {
            background-color: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            margin-bottom: 15px;
            overflow: hidden;
        }
        .accordion-header {
            background-color: #f8f9fa;
            width: 100%;
            border: none;
            padding: 15px 25px;
            text-align: left;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e0e0e0;
        }
        .accordion-header.active {
            background-color: #2c3e50;
            color: white;
        }
        .accordion-header::after {
            content: '+';
            font-size: 28px;
            font-weight: bold;
            color: #aaa;
        }
        .accordion-header.active::after {
            content: '−';
            color: white;
        }
        .accordion-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease-out;
            background-color: white;
        }
        .accordion-content-inner { padding: 25px; }
        .result-table { width: 100%; border-collapse: collapse; font-size: 14px; }
        .result-table th, .result-table td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        .result-table thead { background-color: #f8f9fa; }
        .result-table input[type="checkbox"] { width: 16px; height: 16px; }
        
        .sub-tab-menu {
            display: flex;
            border: 1px solid #ccc;
            border-radius: 6px;
            overflow: hidden;
        }
        .sub-tab-menu button {
            flex: 1;
            background-color: #fff;
            color: #555;
            border: none;
            border-right: 1px solid #ccc;
            padding: 12px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }
        .sub-tab-menu button:last-child { border-right: none; }
        .sub-tab-menu button.active {
            background-color: #19a538;
            color: white;
        }

    </style>
</head>
<body>

    <div class="page-container">
        <div class="page-header">
            <h1>트렌드 분석</h1>
        </div>

        <div class="tab-menu">
            <button class="active" data-tab="keywordAnalysis">1. 상권 키워드 분석</button>
            <button data-tab="newsAnalysis">2. 상권 뉴스 기사 키워드 분석</button>
        </div>

        <div id="keywordAnalysis" class="analysis-container active">
            <div class="filter-panel">
                <input type="text" value="소상공인">
                <input type="date" value="2025-07-07">
                <span>~</span>
                <input type="date" value="2025-07-13">
                <div class="radio-group">
                    <input type="radio" name="period" id="p1" checked><label for="p1">1개월</label>
                    <input type="radio" name="period" id="p2"><label for="p2">3개월</label>
                    <input type="radio" name="period" id="p3"><label for="p3">6개월</label>
                    <input type="radio" name="period" id="p4"><label for="p4">12개월</label>
                </div>
                <div class="buttons">
                    <button class="btn-secondary">상세검색</button>
                    <button class="btn-primary">분석하기</button>
                    <button class="btn-reset">초기화</button>
                </div>
            </div>
            <div class="analysis-content">
                <div class="content-header"><h2>'<span>소상공인</span>' 상권 키워드 분석</h2></div>
                <div class="content-body">
                    <div class="word-cloud-container">
                        <div class="bubble" style="background-color: #4e79a7; width: 220px; height: 220px; top: 120px; left: 150px;">지원</div>
                        <div class="bubble" style="background-color: #f28e2b; width: 170px; height: 170px; top: 250px; left: 350px;">사업</div>
                        <div class="bubble" style="background-color: #e15759; width: 160px; height: 160px; top: 50px; left: 380px;">지역</div>
                    </div>
                    <div class="keyword-rank-container">
                        <h3>연관 키워드 순위</h3>
                        <table class="rank-table">
                           <thead><tr><th style="width:15%;">순위</th><th style="width:55%;">연관 키워드</th><th style="width:30%;">언급량</th></tr></thead>
                           <tbody>
                               <tr><td>1</td><td>지원</td><td>608</td></tr><tr><td>2</td><td>사업</td><td>347</td></tr>
                               <tr><td>3</td><td>지역</td><td>330</td></tr><tr><td>4</td><td>지원금</td><td>251</td></tr>
                               <tr><td>5</td><td>정부</td><td>245</td></tr><tr><td>6</td><td>온라인</td><td>239</td></tr>
                               <tr><td>7</td><td>경제</td><td>233</td></tr><tr><td>8</td><td>쿠폰</td><td>232</td></tr>
                           </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div id="newsAnalysis" class="analysis-container">
            <div class="accordion-item">
                <button class="accordion-header">STEP 01 : 뉴스 검색</button>
                <div class="accordion-content">
                    <div class="accordion-content-inner">
                        <p>뉴스 검색을 위한 조건(키워드, 기간, 언론사 등)을 입력하는 영역입니다.</p>
                        </div>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header">STEP 02 : 검색 결과</button>
                <div class="accordion-content">
                    <div class="accordion-content-inner">
                        <p>선택된 조건에 맞는 뉴스 기사 목록이 테이블 형태로 표시됩니다.</p>
                        <table class="result-table">
                            <thead>
                                <tr>
                                    <th><input type="checkbox"></th>
                                    <th>기사 제목</th>
                                    <th>언론사</th>
                                    <th>게시일</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td>소상공인 지원 정책, 실효성 논란... 현장 목소리 반영해야</td>
                                    <td>한국경제</td>
                                    <td>2025-07-14</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox"></td>
                                    <td>지역 화폐와 연계한 소상공인 매출 증대 효과 '톡톡'</td>
                                    <td>디지털타임스</td>
                                    <td>2025-07-14</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <button class="accordion-header active">STEP 03 : 분석 결과 및 시각화</button>
                <div class="accordion-content" style="max-height: fit-content;"> <div class="accordion-content-inner">
                        <div class="sub-tab-menu">
                            <button>데이터 다운로드</button>
                            <button>관계도 분석</button>
                            <button class="active">키워드 트렌드</button>
                            <button>연관어 분석</button>
                            <button>정보 추출</button>
                        </div>
                        <div class="analysis-content" style="margin-top: 20px; border: none; padding: 0;">
                             <div class="content-body">
                                <div class="word-cloud-container">
                                    <div class="bubble" style="background-color: #59a14f; width: 200px; height: 200px; top: 100px; left: 180px;">정책</div>
                                    <div class="bubble" style="background-color: #e15759; width: 150px; height: 150px; top: 280px; left: 350px;">매출</div>
                                    <div class="bubble" style="background-color: #f28e2b; width: 140px; height: 140px; top: 30px; left: 400px;">효과</div>
                                </div>
                                <div class="keyword-rank-container">
                                    <h3>뉴스 기사 키워드 순위</h3>
                                    <table class="rank-table">
                                       <thead><tr><th style="width:15%;">순위</th><th style="width:55%;">키워드</th><th style="width:30%;">빈도수</th></tr></thead>
                                       <tbody>
                                           <tr><td>1</td><td>정책</td><td>120</td></tr>
                                           <tr><td>2</td><td>매출</td><td>98</td></tr>
                                           <tr><td>3</td><td>효과</td><td>85</td></tr>
                                           <tr><td>4</td><td>지역화폐</td><td>77</td></tr>
                                           <tr><td>5</td><td>현장</td><td>64</td></tr>
                                       </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <script>
        // 메인 탭 전환 스크립트
        const tabButtons = document.querySelectorAll('.tab-menu button');
        const analysisContainers = document.querySelectorAll('.analysis-container');

        tabButtons.forEach(button => {
            button.addEventListener('click', () => {
                // 버튼 활성화 처리
                tabButtons.forEach(btn => btn.classList.remove('active'));
                button.classList.add('active');

                // 컨텐츠 표시 처리
                const targetId = button.getAttribute('data-tab');
                analysisContainers.forEach(container => {
                    if (container.id === targetId) {
                        container.classList.add('active');
                    } else {
                        container.classList.remove('active');
                    }
                });
            });
        });

        // 아코디언 스크립트
        const accordionHeaders = document.querySelectorAll('.accordion-header');
        accordionHeaders.forEach(header => {
            header.addEventListener('click', () => {
                const content = header.nextElementSibling;
                header.classList.toggle('active');

                if (content.style.maxHeight && content.style.maxHeight !== '0px') {
                    content.style.maxHeight = '0px';
                } else {
                    content.style.maxHeight = content.scrollHeight + 'px';
                }
            });
        });
    </script>
</body>
</html>