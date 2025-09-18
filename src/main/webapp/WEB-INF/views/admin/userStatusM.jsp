<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 상태 관리 - 관리자 페이지</title>
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
        .top-filter-bar {
            display: flex;
            justify-content: flex-start;
            gap: 10px;
            margin-bottom: 20px;
        }
        .top-filter-bar input[type="text"],
        .top-filter-bar select {
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .top-filter-bar input[type="text"] {
            width: 200px;
        }

        /* 데이터 테이블 */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
            font-size: 14px;
        }
        .data-table thead {
            background-color: #f2f2f2;
        }
        .data-table th, .data-table td {
            padding: 12px 8px;
            border-bottom: 1px solid #e0e0e0;
        }
        .data-table th {
            font-weight: bold;
            border-top: 1px solid #e0e0e0;
        }
        .data-table td a {
            color: #0d6efd;
            text-decoration: none;
            font-weight: bold;
        }
        .data-table td a:hover {
            text-decoration: underline;
        }

        /* 상태 버튼 */
        .status-button {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: white;
            font-size: 12px;
            cursor: pointer;
        }
        .btn-suspend {
            background-color: #dc3545;
            color: white;
            border-color: #dc3545;
            font-weight: bold;
        }

        /* 페이지네이션 */
        .pagination {
            display: flex;
            justify-content: center;
            margin-top: 25px;
        }
        .pagination ul {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .pagination li a {
            display: block;
            padding: 8px 12px;
            text-decoration: none;
            color: #333;
            margin: 0 2px;
        }
        .pagination li.active a {
            background-color: #0d6efd;
            color: white;
            font-weight: bold;
            border-radius: 4px;
        }

    </style>
</head>
<body>
<div class="main-container">
    <h2>회원 상태 관리</h2>

    <div class="top-filter-bar">
        <input type="text" placeholder="이름">
        <select>
            <option>전체상태</option>
        </select>
        <select>
            <option>전체유형</option>
        </select>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>회원번호</th>
            <th>이메일</th>
            <th>이름</th>
            <th>유형</th>
            <th>탈퇴=N</th>
            <th>가입일</th>
            <th>정지건수</th>
            <th>정지상태</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td><a href="#">1039</a></td>
            <td>hanbat@example.com</td>
            <td>한밭대학교</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-02-12</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1038</a></td>
            <td>lh@example.com</td>
            <td>한국토지주택공사</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-03-17</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1037</a></td>
            <td>bok@example.com</td>
            <td>한국은행</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-03-08</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1036</a></td>
            <td>knoc@example.com</td>
            <td>한국석유공사</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-02-12</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1035</a></td>
            <td>chungnam@example.com</td>
            <td>충남대학교</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-03-17</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1034</a></td>
            <td>nonghyup@example.com</td>
            <td>농협중앙회</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-03-05</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        <tr>
            <td><a href="#">1033</a></td>
            <td>nia@example.com</td>
            <td>이정보</td>
            <td>ORG</td>
            <td>Y</td>
            <td>2025-02-14</td>
            <td>0</td>
            <td>활동중 <button class="status-button btn-suspend">정지</button></td>
        </tr>
        </tbody>
    </table>

    <nav class="pagination">
        <ul>
            <li class="active"><a href="#">1</a></li>
            <li><a href="#">2</a></li>
            <li><a href="#">3</a></li>
            <li><a href="#">4</a></li>
            <li><a href="#">5</a></li>
            <li><a href="#">6</a></li>
            <li><a href="#">7</a></li>
        </ul>
    </nav>
</div>
</body>
</html>