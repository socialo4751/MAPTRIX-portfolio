<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>관리자 페이지 - 만족도 조사 관리</title>
    
</head>
<body>
    <div class="page-wrapper">
        <div class="main-content">
            <div class="page-title">만족도 조사 관리</div>

            <form class="filter-form">
                <label>등록일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
                <label>조사명: <input type="text" name="survey_name" placeholder="조사명"></label>
                <label>참여자: <input type="text" name="participant" placeholder="참여자명"></label>
                <label>상태:
                    <select name="status">
                        <option value="">전체</option>
                        <option value="in_progress">진행중</option>
                        <option value="completed">완료</option>
                    </select>
                </label>
                <button type="submit">검 색</button>
            </form>

            <div class="new-post-button-container">
                <button class="new-post-btn">새 조사 등록</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>등록일</th>
                        <th>조사명</th>
                        <th>참여자 수</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>2025-07-24</td>
                        <td>2025년 상반기 서비스 만족도 조사</td>
                        <td>1250</td>
                        <td>진행중</td>
                        <td class="action-buttons">
                            <button class="edit-btn">수정</button>
                            <button class="delete-btn">삭제</button>
                            <button class="view-detail-btn">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>2025-07-10</td>
                        <td>신규 기능 도입 만족도 설문</td>
                        <td>875</td>
                        <td>완료</td>
                        <td class="action-buttons">
                            <button class="edit-btn">수정</button>
                            <button class="delete-btn">삭제</button>
                            <button class="view-detail-btn">상세</button>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>2025-06-15</td>
                        <td>고객센터 이용 경험 설문</td>
                        <td>2300</td>
                        <td>완료</td>
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