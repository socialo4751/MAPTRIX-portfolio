<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    /*
     * 이 스타일은 main.jsp의 #content 영역에 로드될 때 적용됩니다.
     * main.jsp의 전체적인 스타일과 조화를 이루도록 이미 정의된 공통 스타일은 제거하거나 조정했습니다.
     * 개별 페이지에만 필요한 스타일 (예: 테이블 컬럼 너비)은 여기에 유지합니다.
     */

    /* .main-content 내부 요소들에 대한 스타일은 유지하되,
       .main-content 자체의 레이아웃 (flex-grow, padding 등)은 main.jsp에서 처리하므로 여기서 제거 */

    .page-title { font-size: 24px; margin-bottom: 24px; color: #333; }
    .filter-form {
        margin-bottom: 20px;
        background: #fff;
        padding: 15px;
        border-radius: 8px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        gap: 15px; /* Added gap for better spacing between filter items */
    }
    .filter-form label {
        font-size: 14px;
        color: #555;
        display: flex; /* Ensure label content aligns */
        align-items: center;
        white-space: nowrap; /* Prevent label text from wrapping */
    }
    .filter-form input, .filter-form select {
        padding: 8px 10px;
        /* margin-right: 15px; // Removed as gap handles spacing */
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 14px;
        flex-grow: 0;
        margin-left: 5px; /* Space between label text and input */
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
        margin-left: auto; /* Push search button to the right */
    }
    .filter-form button:hover { background-color: #218838; }

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

    /* API 신청 목록 컬럼 너비 조정 */
    table th:nth-child(1), table td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
    table th:nth-child(2), table td:nth-child(2) { width: 10%; text-align: center; } /* 신청일 */
    table th:nth-child(3), table td:nth-child(3) { width: 12%; } /* 신청자 */
    table th:nth-child(4), table td:nth-child(4) { width: 20%; } /* API 종류 */
    table th:nth-child(5), table td:nth-child(5) { width: 15%; text-align: center; } /* 처리 상태 */
    table th:nth-child(6), table td:nth-child(6) { width: 10%; text-align: center; } /* 처리일 */
    table th:nth-child(7), table td:nth-child(7) { width: 28%; text-align: center; } /* 관리 */

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
    .action-buttons .approve-btn {
        background-color: #28a745;
        color: white;
    }
    .action-buttons .approve-btn:hover {
        background-color: #218838;
    }
    .action-buttons .reject-btn {
        background-color: #dc3545;
        color: white;
    }
    .action-buttons .reject-btn:hover {
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

<div class="page-title">API 신청 승인 관리</div>

<form class="filter-form">
    <label>신청일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
    <label>신청자: <input type="text" name="applicant" placeholder="신청자명"></label>
    <label>API 종류:
        <select name="api_type">
            <option value="">전체</option>
            <option value="commercial">상권 데이터 API</option>
            <option value="population">유동인구 데이터 API</option>
            <option value="sales">매출 데이터 API</option>
        </select>
    </label>
    <label>상태:
        <select name="status">
            <option value="">전체</option>
            <option value="pending">승인대기</option>
            <option value="approved">승인완료</option>
            <option value="rejected">승인거절</option>
        </select>
    </label>
    <button type="submit">검 색</button>
</form>

<table>
    <thead>
        <tr>
            <th>번호</th>
            <th>신청일</th>
            <th>신청자</th>
            <th>API 종류</th>
            <th>처리 상태</th>
            <th>처리일</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <td>2025-07-20</td>
            <td>이철수</td>
            <td>상권 데이터 API</td>
            <td>승인대기</td>
            <td>-</td>
            <td class="action-buttons">
                <button class="approve-btn">승인</button>
                <button class="reject-btn">거절</button>
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>2</td>
            <td>2025-07-19</td>
            <td>김영희</td>
            <td>유동인구 데이터 API</td>
            <td>승인완료</td>
            <td>2025-07-20</td>
            <td class="action-buttons">
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td>2025-07-18</td>
            <td>박민준</td>
            <td>매출 데이터 API</td>
            <td>승인거절</td>
            <td>2025-07-19</td>
            <td class="action-buttons">
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