<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<link rel="stylesheet" href="/css/mypagestyle.css">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>회원 탈퇴</title>
    <style>
        /* CSS 부분은 변경하지 않고 그대로 유지합니다. */
        /* 마이페이지 레이아웃을 위한 최상위 컨테이너 */
        .mypage-wrapper {
            display: flex; /* 사이드바와 메인 콘텐츠를 가로로 배치 */
            width: 100%; /* 전체 너비 사용 */
            max-width: 1200px; /* 전체 마이페이지 레이아웃의 최대 너비 */
            background-color: #fff;
            border-radius: 8px;
            overflow: hidden; /* 자식 요소의 둥근 모서리를 위해 */
            flex-grow: 1; /* body 내에서 남은 공간을 차지하도록 */
        }

        /* main 태그에 적용될 메인 콘텐츠 스타일 */
        main.main-content {
            flex-grow: 1; /* 사이드바가 차지하고 남은 공간을 모두 차지 */
        }

        .header h2 {
            font-size: 2.5em;
            margin-bottom: 15px;
            color: #2c3e50;
        }

        .header p {
            font-size: 1.1em;
            color: #7f8c8d;
        }

        .warning-section {
            background-color: #fef8f8;
            border: 1px solid #f0b4b4;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }

        .warning-section h3 {
            color: #c0392b;
            font-size: 1.5em;
            margin-bottom: 15px;
            text-align: center;
        }

        .warning-section ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .warning-section ul li {
            font-size: 1em;
            color: #555;
            line-height: 1.8;
            margin-bottom: 8px;
            position: relative;
            padding-left: 20px;
        }

        .warning-section ul li::before {
            content: "\f06a"; /* Font Awesome info-circle icon */
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            color: #e74c3c;
            position: absolute;
            left: 0;
            top: 2px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input[type="password"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box;
        }

        .form-group textarea {
            resize: vertical;
        }

        .form-actions {
            text-align: center;
            margin-top: 30px;
        }

        .form-actions button {
            padding: 12px 30px;
            border: none;
            font-size: 1.05em;
            cursor: pointer;
            margin: 0 10px;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .form-actions .btn-withdraw {
            background-color: #e74c3c;
            color: white;
        }

        .form-actions .btn-withdraw:hover {
            background-color: #c0392b;
        }

        .form-actions .btn-cancel {
            background-color: #6c757d;
            color: white;
        }

        .form-actions .btn-cancel:hover {
            background-color: #5a6268;
        }

        /* 추가된 에러/성공 메시지 스타일 */
        .message {
            margin-top: 15px;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }

        .message.error {
            background-color: #fdd;
            color: #c0392b;
            border: 1px solid #e74c3c;
        }

        .message.success {
            background-color: #dfd;
            color: #28a745;
            border: 1px solid #218838;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div class="container">
     <c:set var="activeMenu" value="profile"/>   <!-- profile | report | activity | apply -->
    <c:set var="activeSub" value="del"/>
    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>
    <div class="mypage-wrapper">
        <main class="main-content">
            <div class="mypage-header">
                <h2>회원 탈퇴</h2>
                <p>서비스를 탈퇴하시기 전에 아래 내용을 확인해 주세요.</p>
                <%-- 에러/성공 메시지 표시 --%>
                <c:if test="${not empty errorMessage}">
                    <div class="message error">${errorMessage}</div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="message success">${successMessage}</div>
                </c:if>
            </div>

            <div class="warning-section">
                <h3>탈퇴 전 주의사항</h3>
                <ul>
                    <li>회원 탈퇴 시 모든 개인 정보 및 서비스 이용 기록이 즉시 삭제됩니다. (실제로는 비활성화/마스킹 권장)</li>
                    <li>삭제된 정보는 복구할 수 없으니 신중하게 결정해 주세요.</li>
                    <li>보유하신 포인트, 쿠폰, 이용권 등은 모두 소멸됩니다.</li>
                    <li>작성하신 게시물(게시글, 댓글 등)은 삭제되지 않으며, 탈퇴 후에는 수정 또는 삭제가 불가능합니다.</li>
                    <li>서비스 재가입은 가능하나, 탈퇴 전 정보는 연동되지 않습니다.</li>
                </ul>
            </div>

            <form id="withdrawForm" action="<c:url value="/my/profile/delprocess"/>" method="post">
                <div class="form-group">
                    <label for="reason">탈퇴 사유 (선택)</label>
                    <select id="reason" name="reason">
                        <option value="">선택해 주세요</option>
                        <option value="개인 정보 보호">개인 정보 보호</option>
                        <option value="서비스 불만족">서비스 불만족</option>
                        <option value="잦은 알림">잦은 알림/광고</option>
                        <option value="다른 서비스 이용">다른 서비스 이용</option>
                        <option value="사용 빈도 낮음">사용 빈도 낮음</option>
                        <option value="기타">기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reasonDetail">기타 사유 (자세히)</label>
                    <textarea id="reasonDetail" name="reasonDetail" placeholder="탈퇴 사유를 자세히 알려주시면 서비스 개선에 큰 도움이 됩니다."
                              rows="3"></textarea>
                </div>
                <div class="form-group">
                    <label for="password">비밀번호 확인</label>
                    <input type="password" id="password" name="password" required placeholder="비밀번호를 입력하여 본인 확인">
                    <%-- 비밀번호 입력 시 사용자에게 피드백을 줄 수 있는 공간 (선택 사항) --%>
                    <p class="input-hint">계정 보안을 위해 정확한 비밀번호를 입력해주세요.</p>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-withdraw">회원 탈퇴</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </main>
    </div>
</div>

<script>
    document.getElementById('withdrawForm').addEventListener('submit', function (event) {
        const password = document.getElementById('password').value;

        if (password === '') {
            alert('비밀번호를 입력해주세요.');
            event.preventDefault(); // 비밀번호가 비어있으면 폼 제출을 막음
            return;
        }

        if (!confirm('정말로 회원 탈퇴를 진행하시겠습니까?\n모든 데이터는 삭제되며 복구할 수 없습니다.')) {
            event.preventDefault(); // 사용자가 취소하면 폼 제출을 막음
            return; // 추가된 부분: confirm에서 '취소'를 누르면 더 이상 진행하지 않음
        }
        // 비밀번호가 비어있지 않고, 사용자가 확인하면 폼이 서버로 제출됩니다.
        // 실제 비밀번호 유효성 검증은 서버에서 처리합니다.
    });
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
