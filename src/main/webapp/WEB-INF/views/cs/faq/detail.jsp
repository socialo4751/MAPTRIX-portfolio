<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commstyle.css"/>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <c:set var="activeMenu" value="inquiry"/>
    <c:set var="activeSub" value="faq"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <div class="detail-header border-bottom pb-3 mb-4">
            <h2>${faq.title}</h2>
            <p class="d-flex justify-content-between flex-wrap align-items-center mt-2">
                <span>카테고리: ${faq.catCodeName}</span>
            </p>
        </div>

        <div class="p-4 mb-4" style="font-size: 16px; line-height: 1.8;">
            <c:out value="${faq.content}" escapeXml="false"/>
        </div>

        <div class="d-flex justify-content-end gap-2">
            <a href="${pageContext.request.contextPath}/cs/faq" class="btn btn-secondary btn-sm">목록</a>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
