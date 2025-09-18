<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>관심구역 & 관심업종 설정</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="/css/mypagestyle.css">
    <%-- myMain.jsp의 콘텐츠 시작: aside와 main을 container div로 감쌉니다. --%>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<div class="container">
    <c:set var="activeMenu" value="profile"/>   <!-- profile | report | activity | apply -->
    <c:set var="activeSub" value="profile"/>   <!-- profile | biz | preference | del ... -->

    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>
    <main>
        <div class="mypage-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                회원정보 관리
            </h2>
        </div>

        <div class="user-info-section">
            <h3>기본 정보</h3>
            <div class="info-item">
                <label>이름</label>
                <span><c:out value="${user.name}"/></span>
            </div>
            <div class="info-item">
                <label>생년월일</label>
                <span><c:out value="${user.birthDate}"/></span>
            </div>
            <div class="info-item">
                <label>아이디</label>
                <span><c:out value="${user.userId}"/></span>
            </div>
            <div class="info-item">
                <label>휴대전화 번호</label>
                <span><c:out value="${user.phoneNumber}"/></span>
            </div>
            <div class="info-item">
                <label>이메일</label>
                <span><c:out value="${user.email}"/></span>
            </div>
        </div>

        <div class="user-info-section">
            <h3>주소 정보</h3>
            <div class="info-item">
                <label>우편번호</label>
                <span><c:out value="${user.postcode}"/></span>
            </div>
            <div class="info-item">
                <label>기본 주소</label>
                <span><c:out value="${user.address1}"/></span>
            </div>
            <div class="info-item">
                <label>상세 주소</label>
                <span><c:out value="${user.address2}"/></span>
            </div>
        </div>
        <div class="action-buttons">
            <form action="${pageContext.request.contextPath}/my/profile/form" method="get">
                <button type="submit" class="btn-edit">
                    <i class="fas fa-edit"></i> 회원정보 수정
                </button>
            </form>
        </div>
    </main>
</div>
<%-- div.container를 닫습니다. --%>=
<%-- footer.jsp가 나머지 닫는 태그들을 포함할 것입니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>