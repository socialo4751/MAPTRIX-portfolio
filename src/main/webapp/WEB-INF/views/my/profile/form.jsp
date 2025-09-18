<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--
    ****************************************************************************************
    ** 중요: 이 파일은 웹 페이지 전체가 아닌, 'top.jsp'와 'footer.jsp'에 의해 감싸질 '콘텐츠' 부분입니다. **
    ** ERR_INCOMPLETE_CHUNKED_ENCODING 오류는 중복된 HTML 구조 태그 때문에 발생하므로,         **
    ** 이 파일에서 <!DOCTYPE html>, <html>, <head>, <body> 태그를 제거해야 합니다.            **
    ** 'top.jsp'에 포함될 Font Awesome 링크와 <style> 블록은 여기에 그대로 유지합니다.            **
    ****************************************************************************************
--%>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
<link rel="stylesheet" href="/css/mypagestyle.css">
<style>
    /* 마이페이지 레이아웃을 위한 최상위 컨테이너 */
    .mypage-wrapper {
        display: flex; /* 사이드바와 메인 콘텐츠를 가로로 배치 */
        width: 100%; /* 전체 너비 사용 */
        max-width: 1500px; /* 전체 마이페이지 레이아웃의 최대 너비 */
        background-color: #fff;
        overflow: hidden; /* 자식 요소의 둥근 모서리를 위해 */
        flex-grow: 1; /* body 내에서 남은 공간을 차지하도록 */
    }

    /* main 태그에 적용될 메인 콘텐츠 스타일 */
    main.main-content {
        flex-grow: 1; /* 사이드바가 차지하고 남은 공간을 모두 차지 */
    }


    /* 정보 수정 폼 섹션 스타일 */
    .edit-form-section {
        margin-bottom: 30px;
        border: 1px solid #e0e0e0; /* 테두리 색상 조정 */
        padding: 25px; /* 패딩 조정 */
        border-radius: 8px; /* 둥근 모서리 조정 */
        background-color: #fcfcfc; /* 배경색 조정 */
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03); /* 그림자 추가 */
    }

    .edit-form-section h3 {
        font-size: 1.8em; /* 크기 조정 */
        color: #34495e; /* 색상 조정 */
        margin-bottom: 25px; /* 마진 조정 */
        border-bottom: 2px solid #3498db; /* 강조 색상으로 변경 */
        padding-bottom: 10px;
        display: inline-block; /* 텍스트 너비만큼만 선이 보이도록 */
    }

    .form-item {
        display: flex;
        margin-bottom: 15px;
        align-items: center;
    }

    .form-item label {
        flex: 0 0 150px; /* 라벨 너비 약간 증가 */
        font-weight: bold;
        color: #555; /* 색상 조정 */
    }

    .form-item input[type="text"],
    .form-item input[type="email"],
    .form-item input[type="date"]{
        flex-grow: 1;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px; /* 둥근 모서리 조정 */
        font-size: 1em; /* 크기 조정 */
        color: #444; /* 색상 조정 */
    }

    .form-item input[readonly] {
        background-color: #eff2f5; /* 읽기 전용 필드 배경색 조정 */
        cursor: not-allowed;
    }

    .action-buttons {
        text-align: center;
        margin-top: 40px;
    }

    .action-buttons button {
        padding: 12px 30px;
        border: none;
        font-size: 1.05em; /* 크기 약간 증가 */
        cursor: pointer;
        margin: 0 10px;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    .action-buttons .btn-submit {
        background-color: #28a745;
        color: white;
    }

    .action-buttons .btn-submit:hover {
        background-color: #218838;
    }

    .action-buttons .btn-cancel {
        background-color: #6c757d;
        color: white;
    }

    .action-buttons .btn-cancel:hover {
        background-color: #5a6268;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .mypage-wrapper {
            flex-direction: column; /* 작은 화면에서는 수직으로 쌓이도록 */
            margin: 0; /* 마진 없애고 전체 너비 사용 */
            border-radius: 0; /* 둥근 모서리 없애기 */
            box-shadow: none; /* 그림자 없애기 */
        }

        .sidebar {
            width: 100%; /* 사이드바가 전체 너비 차지 */
            padding: 20px 0;
        }

        .sidebar-menu {
            display: flex; /* 메뉴 항목을 가로로 정렬 */
            flex-wrap: wrap; /* 필요한 경우 줄바꿈 */
            justify-content: center; /* 가운데 정렬 */
            gap: 5px; /* 메뉴 항목 간 간격 */
        }

        .sidebar-menu a {
            padding: 10px 15px; /* 패딩 줄임 */
            font-size: 1em;
            justify-content: center; /* 아이콘과 텍스트 중앙 정렬 */
            width: auto; /* 너비 자동 조정 */
        }

        main.main-content {
            padding: 20px; /* 메인 콘텐츠 패딩 줄임 */
        }

        .mypage-header h2 {
            font-size: 2em;
        }

        .edit-form-section {
            padding: 15px;
        }

        .edit-form-section h3 {
            font-size: 1.5em;
            margin-bottom: 20px;
        }

        .form-item {
            flex-direction: column; /* 작은 화면에서 라벨과 입력 필드 세로로 쌓이도록 */
            align-items: flex-start;
        }

        .form-item label {
            margin-bottom: 5px;
            flex: none; /* 라벨 너비 고정 해제 */
        }

        .form-item input[type="text"],
        .form-item input[type="email"] {
            width: 100%;
        }

        .action-buttons button {
            padding: 10px 20px;
            font-size: 0.95em;
            margin: 0 5px;
        }
    }
</style>

<%@ include file="/WEB-INF/views/include/top.jsp" %>
<div class="container">
    <c:set var="activeMenu" value="profile"/>   <!-- profile | report | activity | apply -->
    <c:set var="activeSub" value="profile"/>
    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>
    <div class="mypage-wrapper">
        <main class="main-content">
            <div class="mypage-header">
                <h2>회원정보 수정</h2>
                <p>회원님의 정보를 수정하고 저장하세요.</p>
                <c:if test="${not empty errorMessage}">
                    <p style="color: red;">${errorMessage}</p>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <p style="color: green;">${successMessage}</p>
                </c:if>
            </div>

            <form action="<c:url value="/my/profile/mod"/>" method="post">
                <div class="edit-form-section">
                    <h3>기본 정보 수정</h3>
                    <div class="form-item">
                        <label for="name">이름</label>
                        <input type="text" id="name" name="name" value="<c:out value="${user.name}"/>" required>
                    </div>
                    <div class="form-item">
                        <label for="birthDate">생년월일</label>
                        <input type="date" id="birthDate" name="birthDate" value="<c:out value="${user.birthDate}"/>"
                               readonly>
                    </div>
                    <div class="form-item">
                        <label for="userId">아이디</label>
                        <input type="text" id="userId" name="userId" value="<c:out value="${user.userId}"/>" readonly>
                    </div>
                    <div class="form-item">
                        <label for="phoneNumber">휴대전화 번호</label>
                        <input type="text" id="phoneNumber" name="phoneNumber"
                               value="<c:out value="${user.phoneNumber}"/>"
                               required>
                    </div>
                    <div class="form-item">
                        <label for="email">이메일</label>
                        <input type="email" id="email" name="email" value="<c:out value="${user.email}"/>" required>
                    </div>
                </div>

                <div class="edit-form-section">
                    <h3>주소 정보 수정</h3>
                    <div class="form-item">
                        <label for="postcode">우편번호</label>
                        <input type="text" id="postcode" name="postcode" value="<c:out value="${user.postcode}"/>"
                               readonly>
                    </div>
                    <div class="form-item">
                        <label for="address1">기본 주소</label>
                        <input type="text" id="address1" name="address1" value="<c:out value="${user.address1}"/>"
                               readonly>
                    </div>
                    <div class="form-item">
                        <label for="address2">상세 주소</label>
                        <input type="text" id="address2" name="address2" value="<c:out value="${user.address2}"/>">
                    </div>
                </div>

                <div class="edit-form-section">
                    <h3>추가 정보 (조회 전용 - 수정 불가)</h3>
                    <div class="form-item">
                        <label>관심 지역</label>
                        <span>
                            <c:choose>
                                <c:when test="${not empty user.codeAdmDongVOList}">
                                    <c:forEach var="district" items="${user.codeAdmDongVOList}" varStatus="status">
                                        <c:out value="${district.admName}"/>
                                        <c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    등록된 관심 지역 없음
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="form-item">
                        <label>관심 업종</label>
                        <span>
                            <c:choose>
                                <c:when test="${not empty user.userMyBizVOList}">
                                    <c:forEach var="biz" items="${user.userMyBizVOList}" varStatus="status">
                                        <c:out value="${biz.bizName}"/>
                                        <c:if test="${!status.last}">, </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    등록된 관심 업종 없음
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <div class="action-buttons">
                    <button type="submit" class="btn-submit">저장</button>
                    <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                </div>
            </form>
        </main>
    </div>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>