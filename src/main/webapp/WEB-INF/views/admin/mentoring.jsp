<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 페이지 - 멘토링 관리</title>
    <style>
        /* body 태그에 직접적인 CSS 스타일 제거 */
        /* font-family, margin, background 등의 속성은 body에서 제거되었습니다. */

        /* 전체 레이아웃을 위한 컨테이너 */
        .page-wrapper {
            display: flex; /* 사이드바와 메인 콘텐츠를 나란히 배치 */
            background: #f5f6fa; /* 전체 배경색을 .page-wrapper에 적용 */
            font-family: 'Malgun Gothic', Arial, sans-serif; /* 전체 폰트도 여기에 적용 */
        }

        /*
         * 주의: 이 부분의 CSS는 인클루드될 탑바/헤더 파일의 CSS와 충돌하거나,
         * 상단 여백이 맞지 않을 수 있습니다.
         * 실제 프로젝트에서는 인클루드될 파일의 높이를 고려하여
         * .sidebar와 .main-content의 padding-top을 조정해야 합니다.
         */
        /* 상단 네비게이션과 메인 헤더 CSS는 이 파일에서 사용되지 않으므로 제거됩니다. *

        /* 메인 콘텐츠 영역 */
        .main-content {
            flex-grow: 1; /* 남은 공간을 모두 차지 */
            padding: 30px 40px;
            /* 상단 메뉴가 인클루드된다고 가정하고, 그 높이만큼 padding-top을 조정하거나,
             * 인클루드되는 CSS에서 .main-content의 margin-top을 조정해야 합니다. */
            padding-top: 30px; /* 임시로 조정, 실제로는 인클루드될 헤더 높이에 맞게 설정 필요 */
        }

        .page-title { font-size: 24px; margin-bottom: 24px; color: #333; }
        .filter-form { margin-bottom: 20px; background: #fff; padding: 15px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); display: flex; align-items: center; flex-wrap: wrap;}
        .filter-form label { margin-right: 15px; font-size: 14px; color: #555; }
        .filter-form input, .filter-form select {
            padding: 8px 10px;
            margin-right: 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
            flex-grow: 0;
        }
        .filter-form button {
            padding: 8px 18px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s ease;
        }
        .filter-form button:hover { background-color: #218838; }

        .new-post-button-container {
            text-align: right;
            margin-bottom: 15px;
        }

        .new-post-btn {
            padding: 8px 18px;
            background-color: #007bff; /* Blue for new post button */
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s ease;
        }

        .new-post-btn:hover {
            background-color: #0056b3;
        }


        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
            table-layout: fixed;
            margin-top: 20px;
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
            color: #333;
        }
        td {
            font-size: 14px;
            color: #495057;
        }

        /* 멘토링 관리 목록 컬럼 너비 조정 */
        th:nth-child(1), td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
        th:nth-child(2), td:nth-child(2) { width: 10%; text-align: center; } /* 등록일 */
        th:nth-child(3), td:nth-child(3) { width: 25%; } /* 제목 */
        th:nth-child(4), td:nth-child(4) { width: 10%; text-align: center; } /* 멘토 */
        th:nth-child(5), td:nth-child(5) { width: 10%; text-align: center; } /* 멘티 */
        th:nth-child(6), td:nth-child(6) { width: 8%; text-align: center; } /* 진행상태 */
        th:nth-child(7), td:nth-child(7) { width: 7%; text-align: center; } /* 조회수 */
        th:nth-child(8), td:nth-child(8) { width: 7%; text-align: center; } /* 댓글수 */
        th:nth-child(9), td:nth-child(9) { width: 18%; text-align: center; } /* 관리 */


        .pagination { margin: 20px 0; text-align: right; }
        .pagination button {
            padding: 8px 12px;
            margin-left: 5px;
            background-color: #f0f0f0;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
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

        .action-buttons button {
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 13px;
            margin: 0 2px;
        }
        .action-buttons .edit-btn {
            background-color: #ffc107; /* Yellow for edit button */
            color: #333;
        }
        .action-buttons .edit-btn:hover {
            background-color: #e0a800;
        }
        .action-buttons .delete-btn {
            background-color: #dc3545; /* Red for delete button */
            color: white;
        }
        .action-buttons .delete-btn:hover {
            background-color: #c82333;
        }
        .action-buttons .view-detail-btn {
            background-color: #007bff;
            color: white;
        }
        .action-buttons .view-detail-btn:hover {
            background-color: #0056b3;
        }

    </style>
</head>
<body>
    <div class="page-wrapper">
        <div class="main-content">
            <div class="page-title">멘토링 관리</div>

            <form class="filter-form">
                <label>등록일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
                <label>제목: <input type="text" name="title" placeholder="제목"></label>
                <label>멘토: <input type="text" name="mentor" placeholder="멘토명"></label>
                <label>멘티: <input type="text" name="mentee" placeholder="멘티명"></label>
                <label>상태:
                    <select name="status">
                        <option value="">전체</option>
                        <option value="pending">진행중</option>
                        <option value="completed">완료</option>
                        <option value="cancelled">취소</option>
                    </select>
                </label>
                <button type="submit">검 색</button>
            </form>

            <div class="new-post-button-container">
                <button class="new-post-btn">새 글 등록</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>등록일</th>
                        <th>제목</th>
                        <th>멘토</th>
                        <th>멘티</th>
                        <th>진행상태</th>
                        <th>조회수</th>
                        <th>댓글수</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>2025-07-24</td>
                        <td>상권 분석 노하우 공유</td>
                        <td>이멘토</td>
                        <td>김멘티</td>
                        <td>진행중</td>
                        <td>125</td>
                        <td>5</td>
                        <td class="action-buttons">
                            <button class="edit-btn">수정</button>
                            <button class="delete-btn">삭제</button>
                            <button class="view-detail-btn">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>2025-07-23</td>
                        <td>카페 창업 성공 전략</td>
                        <td>박멘토</td>
                        <td>최멘티</td>
                        <td>완료</td>
                        <td>230</td>
                        <td>12</td>
                        <td class="action-buttons">
                            <button class="edit-btn">수정</button>
                            <button class="delete-btn">삭제</button>
                            <button class="view-detail-btn">상세</button>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="pagination">
                <button disabled>이전</button>
                <button class="active">1</button>
                <button>2</button>
                <button>3</button>
                <button>다음</button>
            </div>
        </div>
    </div>
</body>
</html>