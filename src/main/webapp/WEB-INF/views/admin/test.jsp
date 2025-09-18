<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="page-title">역량테스트 문항 관리</div>

<form class="filter-form">
    <label>등록일: <input type="date" name="start_date"> ~ <input type="date" name="end_date"></label>
    <label>문항 내용: <input type="text" name="question_content" placeholder="문항 내용"></label>
    <label>유형:
        <select name="question_type">
            <option value="">전체</option>
            <option value="multiple_choice">객관식</option>
            <option value="short_answer">단답형</option>
            <option value="essay">서술형</option>
        </select>
    </label>
    <label>난이도:
        <select name="difficulty">
            <option value="">전체</option>
            <option value="easy">하</option>
            <option value="medium">중</option>
            <option value="hard">상</option>
        </select>
    </label>
    <button type="submit">검 색</button>
</form>

<div class="new-post-button-container">
    <button class="new-post-btn">새 문항 등록</button>
</div>

<table>
    <thead>
        <tr>
            <th>번호</th>
            <th>등록일</th>
            <th>문항 내용</th>
            <th>유형</th>
            <th>난이도</th>
            <th>정답률</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1</td>
            <td>2025-07-24</td>
            <td>다음 중 파이썬의 올바른 변수명 규칙이 아닌 것은?</td>
            <td>객관식</td>
            <td>중</td>
            <td>75%</td>
            <td class="action-buttons">
                <button class="edit-btn">수정</button>
                <button class="delete-btn">삭제</button>
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>2</td>
            <td>2025-07-23</td>
            <td>SQL에서 데이터를 필터링하는 데 사용되는 절은 무엇인가요?</td>
            <td>단답형</td>
            <td>하</td>
            <td>90%</td>
            <td class="action-buttons">
                <button class="edit-btn">수정</button>
                <button class="delete-btn">삭제</button>
                <button class="view-detail-btn">상세</button>
            </td>
        </tr>
        <tr>
            <td>3</td>
            <td>2025-07-22</td>
            <td>클라우드 컴퓨팅의 장점과 단점을 서술하시오.</td>
            <td>서술형</td>
            <td>상</td>
            <td>40%</td>
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
    /* 역량테스트 문항 관리 목록 컬럼 너비 조정 (이 페이지에만 특화) */
    table th:nth-child(1), table td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
    table th:nth-child(2), table td:nth-child(2) { width: 10%; text-align: center; } /* 등록일 */
    table th:nth-child(3), table td:nth-child(3) { width: 35%; } /* 문항 내용 */
    table th:nth-child(4), table td:nth-child(4) { width: 10%; text-align: center; } /* 유형 */
    table th:nth-child(5), table td:nth-child(5) { width: 8%; text-align: center; } /* 난이도 */
    table th:nth-child(6), table td:nth-child(6) { width: 8%; text-align: center; } /* 정답률 */
    table th:nth-child(7), table td:nth-child(7) { width: 24%; text-align: center; } /* 관리 */
</style>