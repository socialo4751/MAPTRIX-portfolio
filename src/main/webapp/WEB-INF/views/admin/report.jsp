<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>상권분석 내역 조회</title>
    <style>
        /* body 스타일 제거 */
        /* font-family, margin, background 속성이 body에서 제거되었습니다. */

        .content-container { margin: 30px 40px; }
        .page-title { font-size: 24px; margin-bottom: 24px; }
        .filter-form { margin-bottom: 20px }
        .filter-form input, .filter-form select { padding: 5px; margin-right: 10px; border: 1px solid #ccc; border-radius: 4px; }
        .filter-form button { padding: 8px 15px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .filter-form button:hover { background-color: #0056b3; }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
            table-layout: fixed;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #e1e1e1;
            text-align: left;
            word-wrap: break-word;
        }
        th {
            background: #f1f6fa;
            font-weight: bold;
        }
        td {
            font-size: 14px;
        }

        /* 각 컬럼 너비 및 정렬 조정 */
        th:nth-child(1), td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
        th:nth-child(2), td:nth-child(2) { width: 15%; text-align: center; } /* 분석일 */
        th:nth-child(3), td:nth-child(3) { width: 15%; text-align: center; } /* 분석자 */
        th:nth-child(4), td:nth-child(4) { width: 25%; } /* 상권명 */
        th:nth-child(5), td:nth-child(5) { width: 20%; text-align: center; } /* 분석결과 */
        th:nth-child(6), td:nth-child(6) { width: 20%; text-align: center; } /* 상세보기 */

        .pagination { margin: 15px 0; text-align: right; }
        .pagination button {
            padding: 8px 12px;
            margin-left: 5px;
            background-color: #f0f0f0;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
        }
        .pagination button:hover:not([disabled]) {
            background-color: #e0e0e0;
        }
        .pagination button[disabled] {
            background-color: #e9ecef;
            color: #6c757d;
            cursor: not-allowed;
            border-color: #dee2e6;
        }
        .pagination button.active {
            background-color: #007bff;
            color: white;
            border-color: #007bff;
        }

        /* 상세보기 링크 스타일 */
        td a {
            color: #007bff;
            text-decoration: none;
        }
        td a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="content-container">
        <div class="page-title">상권분석 내역 조회</div>
        <form class="filter-form">
            <label>분석일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
            <label>분석자: <input type="text" name="user" placeholder="분석자명"></label>
            <label>상권명: <input type="text" name="area" placeholder="상권명"></label>
            <button type="submit">검 색</button>
        </form>
        <table>
            <thead>
                <tr>
                    <th>번호</th>
                    <th>분석일</th>
                    <th>분석자</th>
                    <th>상권명</th>
                    <th>분석결과</th>
                    <th>상세보기</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>2025-07-18</td>
                    <td>홍길동</td>
                    <td>강남역</td>
                    <td>매우 양호</td>
                    <td><a href="#">상세보기</a></td>
                </tr>
                </tbody>
        </table>
        <div class="pagination">
            <button disabled>이전</button>
            <button class="active">1</button>
            <button>2</button>
            <button>다음</button>
        </div>
    </div>
</body>
</html>