<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시스템 로그 조회 - 관리자 페이지</title>
    <style>
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f8f9fa;
            color: #333;
            margin: 0;
        }
        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border: 1px solid #e0e0e0;
        }
        h2 {
            font-size: 24px;
            margin-top: 0;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #333;
        }

        /* 검색 필터 영역 */
        .search-filters {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 20px;
            margin-bottom: 30px;
            display: grid;
            grid-template-columns: auto 1fr auto 1fr;
            gap: 15px 20px;
            align-items: center;
        }
        .search-filters label {
            font-weight: bold;
            font-size: 14px;
        }
        .search-filters input[type="text"],
        .search-filters select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .search-filters .date-picker {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .search-filters .btn-search {
            grid-column: 4; /* 4번째 열에 배치 */
            justify-self: end; /* 오른쪽 정렬 */
            width: 120px;
            padding: 10px;
            background-color: #0d6efd;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
        }

        /* 로그 테이블 */
        .log-table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
            font-size: 14px;
        }
        .log-table thead {
            background-color: #f2f2f2;
        }
        .log-table th, .log-table td {
            padding: 12px 8px;
            border-bottom: 1px solid #e0e0e0;
        }
        .log-table th {
            font-weight: bold;
            border-top: 1px solid #e0e0e0;
        }

        /* 결과 배지 스타일 */
        .status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            color: white;
            font-size: 12px;
            font-weight: bold;
        }
        .status-success {
            background-color: #28a745;
        }
        .status-failure {
            background-color: #dc3545;
        }

        /* 하단 정보 및 페이지네이션 */
        .bottom-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 25px;
        }
        .total-count {
            font-size: 14px;
            color: #555;
        }
        .pagination ul {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            overflow: hidden;
        }
        .pagination li a {
            display: block;
            padding: 8px 12px;
            text-decoration: none;
            color: #333;
            border-right: 1px solid #ddd;
        }
        .pagination li:last-child a {
            border-right: none;
        }
        .pagination li a:hover {
            background-color: #f0f0f0;
        }
        .pagination li.active a {
            background-color: #0d6efd;
            color: white;
            font-weight: bold;
        }

    </style>
</head>
<body>
<div class="main-container">
    <h2>시스템 로그 조회</h2>

    <div class="search-filters">
        <label for="mem-no">회원 번호</label>
        <input type="text" id="mem-no">

        <label for="user-role">사용자 역할</label>
        <select id="user-role">
            <option>전체</option>
            <option>ADMIN</option>
            <option>UNKNOWN</option>
        </select>

        <label for="start-date">시작일</label>
        <div class="date-picker">
            <input type="text" value="연도-월-일">
            <button>📅</button>
        </div>

        <label for="end-date">종료일</label>
        <div class="date-picker">
            <input type="text" value="연도-월-일">
            <button>📅</button>
        </div>

        <label for="action-type">액션 타입</label>
        <select id="action-type">
            <option>전체</option>
            <option>LOGIN</option>
            <option>LOGOUT</option>
        </select>

        <label for="target">대상</label>
        <input type="text" id="target">

        <label for="result-code">결과 코드</label>
        <select id="result-code">
            <option>전체</option>
            <option>성공</option>
            <option>실패</option>
        </select>

        <button class="btn-search">검색</button>
    </div>

    <table class="log-table">
        <thead>
        <tr>
            <th>NO</th>
            <th>MEM_NO</th>
            <th>사용자 역할</th>
            <th>TYPE</th>
            <th>대상</th>
            <th>액션 내용</th>
            <th>로그 일시</th>
            <th>결과</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>2275</td>
            <td>1</td>
            <td>ADMIN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 성공 (ID: testAdmin)</td>
            <td>2025-07-14 12:25:10</td>
            <td><span class="status status-success">성공</span></td>
        </tr>
        <tr>
            <td>2274</td>
            <td>1</td>
            <td>ADMIN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 성공 (ID: testAdmin)</td>
            <td>2025-07-12 10:53:30</td>
            <td><span class="status status-success">성공</span></td>
        </tr>
        <tr>
            <td>2273</td>
            <td>1</td>
            <td>ADMIN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 성공 (ID: testAdmin)</td>
            <td>2025-07-11 15:15:01</td>
            <td><span class="status status-success">성공</span></td>
        </tr>
        <tr>
            <td>2272</td>
            <td>0</td>
            <td>UNKNOWN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 실패 (ID: testAdmin)</td>
            <td>2025-07-11 15:14:56</td>
            <td><span class="status status-failure">실패</span></td>
        </tr>
        <tr>
            <td>2271</td>
            <td>1</td>
            <td>ADMIN</td>
            <td>LOGOUT</td>
            <td>MEMBER</td>
            <td>로그아웃 (ID: testAdmin)</td>
            <td>2025-07-11 15:14:48</td>
            <td><span class="status status-success">성공</span></td>
        </tr>
        <tr>
            <td>2270</td>
            <td>1</td>
            <td>ADMIN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 성공 (ID: testAdmin)</td>
            <td>2025-07-11 15:12:59</td>
            <td><span class="status status-success">성공</span></td>
        </tr>
        <tr>
            <td>2269</td>
            <td>0</td>
            <td>UNKNOWN</td>
            <td>LOGIN</td>
            <td>MEMBER</td>
            <td>로그인 실패 (ID: testAdmin)</td>
            <td>2025-07-11 15:12:55</td>
            <td><span class="status status-failure">실패</span></td>
        </tr>
        </tbody>
    </table>

    <div class="bottom-info">
        <div class="total-count">
            총 994건의 로그가 있습니다.
        </div>
        <nav class="pagination">
            <ul>
                <li><a href="#">처음</a></li>
                <li><a href="#">이전</a></li>
                <li class="active"><a href="#">1</a></li>
                <li><a href="#">2</a></li>
                <li><a href="#">3</a></li>
                <li><a href="#">4</a></li>
                <li><a href="#">5</a></li>
                <li><a href="#">다음</a></li>
                <li><a href="#">마지막</a></li>
            </ul>
        </nav>
    </div>
</div>
</body>
</html>