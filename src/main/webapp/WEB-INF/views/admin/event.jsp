<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="page-title">축제 정보 관리</div>

<form class="filter-form">
    <label>등록일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
    <label>축제명: <input type="text" name="festival_name" placeholder="축제명"></label>
    <label>지역:
        <select name="region">
            <option value="daejeon">대전</option>
            </select>
    </label>
    <label>기간: <input type="date" name="festival_start_date"> ~ <input type="date" name="festival_end_date"></label>
    <button type="submit">검 색</button>
</form>

<div class="new-post-button-container">
    <button class="new-post-btn">새 축제 등록</button>
</div>

<table>
    <thead>
        <tr>
            <th>번호</th>
            <th>등록일</th>
            <th>축제명</th>
            <th>기간</th>
            <th>지역</th>
            <th>조회수</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <td>2025-07-24</td>
            <td>대전 사이언스 페스티벌</td>
            <td>2025-10-10 ~ 2025-10-13</td>
            <td>대전</td>
            <td>4500</td>
            <td class="action-buttons">
                <button class="edit-btn">수정</button>
                <button class="delete-btn">삭제</button>
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>2</td>
            <td>2025-07-20</td>
            <td>대전 효 문화 뿌리 축제</td>
            <td>2025-09-20 ~ 2025-09-22</td>
            <td>대전</td>
            <td>3800</td>
            <td class="action-buttons">
                <button class="edit-btn">수정</button>
                <button class="delete-btn">삭제</button>
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td>2025-07-15</td>
            <td>유성 국화 전시회</td>
            <td>2025-10-25 ~ 2025-11-03</td>
            <td>대전</td>
            <td>2100</td>
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

<style>
    /* 축제 정보 관리 목록 컬럼 너비 조정 (이 페이지에만 특화) */
    table th:nth-child(1), table td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
    table th:nth-child(2), table td:nth-child(2) { width: 10%; text-align: center; } /* 등록일 */
    table th:nth-child(3), table td:nth-child(3) { width: 25%; } /* 축제명 */
    table th:nth-child(4), table td:nth-child(4) { width: 20%; text-align: center; } /* 기간 */
    table th:nth-child(5), table td:nth-child(5) { width: 10%; text-align: center; } /* 지역 */
    table th:nth-child(6), table td:nth-child(6) { width: 8%; text-align: center; } /* 조회수 */
    table th:nth-child(7), table td:nth-child(7) { width: 22%; text-align: center; } /* 관리 */
</style>