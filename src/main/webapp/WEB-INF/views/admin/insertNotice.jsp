<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공지사항 관리 - 관리자 페이지</title>
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

        /* 상단 컨트롤 바 */
        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .left-controls { display: flex; align-items: center; gap: 15px; }
        .total-count { font-size: 14px; }
        .total-count strong { color: #0d6efd; }
        .category-buttons button {
            padding: 8px 15px;
            border: 1px solid #ccc;
            background-color: #fff;
            cursor: pointer;
        }
        .category-buttons button.active {
            background-color: #192a56;
            color: white;
            border-color: #192a56;
            font-weight: bold;
        }
        .search-box { display: flex; }
        .search-box input { width: 200px; padding: 8px; border: 1px solid #ccc; }
        .search-box button {
            padding: 8px 15px;
            border: 1px solid #192a56;
            background-color: #192a56;
            color: white;
            cursor: pointer;
        }

        /* 데이터 테이블 */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
            font-size: 14px;
        }
        .data-table thead { background-color: #f2f2f2; }
        .data-table th, .data-table td { padding: 12px 8px; border-bottom: 1px solid #e0e0e0; }
        .data-table th { font-weight: bold; border-top: 1px solid #e0e0e0; }
        .data-table .title { text-align: left; }
        .data-table .title span { font-weight: bold; margin-right: 5px; }
        .data-table .title .notice { color: #dc3545; }
        .data-table .title .event { color: #0d6efd; }

        /* 하단 컨트롤 */
        .bottom-controls { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; }
        .pagination { flex-grow: 1; display: flex; justify-content: center; }
        .pagination ul { display: flex; list-style: none; padding: 0; margin: 0; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; }
        .pagination li a { display: block; padding: 8px 12px; text-decoration: none; color: #333; border-right: 1px solid #ddd; }
        .pagination li:last-child a { border-right: none; }
        .pagination li.active a { background-color: #0d6efd; color: white; font-weight: bold; }
        .btn-create {
            padding: 10px 25px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            background-color: #333;
            color: white;
        }
    </style>
</head>
<body>
<div class="main-container">
    <h2>공지사항 작성</h2>
    <div class="top-bar">
        <div class="left-controls">
            <div class="total-count">총 <strong>44</strong> 건</div>
            <div class="category-buttons">
                <button class="active">전체</button>
                <button>개인회원</button>
                <button>기관회원</button>
            </div>
        </div>
        <div class="search-box">
            <input type="text" placeholder="키워드를 입력해주세요.">
            <button>검색</button>
        </div>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성일</th>
            <th>조회수</th>
        </tr>
        </thead>
        <tbody>
        <tr><td>44</td><td class="title"><span class="notice">[공지]</span> 공지사항test</td><td>2025-05-08</td><td>0</td></tr>
        <tr><td>43</td><td class="title"><span class="event">[이벤트]</span> 공공데이터 활용 공모전</td><td>2025-05-07</td><td>13</td></tr>
        <tr><td>42</td><td class="title"><span class="event">[이벤트]</span> 기업 이벤트 알림 서비스</td><td>2025-04-25</td><td>19</td></tr>
        <tr><td>41</td><td class="title"><span class="notice">[공지]</span> 기업회원 전용 채용관 안내</td><td>2025-04-25</td><td>7</td></tr>
        <tr><td>40</td><td class="title"><span class="notice">[공지]</span> 계약 관련 공지사항 안내</td><td>2025-04-25</td><td>6</td></tr>
        <tr><td>39</td><td class="title"><span class="event">[이벤트]</span> 추천 채용 이벤트 안내</td><td>2025-04-25</td><td>3</td></tr>
        </tbody>
    </table>

    <div class="bottom-controls">
        <div class="pagination">
            <ul>
                <li><a href="#">처음</a></li>
                <li><a href="#">이전</a></li>
                <li class="active"><a href="#">1</a></li>
                <li><a href="#">2</a></li>
                <li><a href="#">3</a></li>
                <li><a href="#">다음</a></li>
                <li><a href="#">마지막</a></li>
            </ul>
        </div>
        <button class="btn-create">공지 작성하기</button>
    </div>
</div>
</body>
</html>