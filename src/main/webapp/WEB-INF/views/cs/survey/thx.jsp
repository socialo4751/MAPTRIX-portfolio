<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>만족도 조사 완료</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="survey"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                설문 조사
            </h2>
        </div>
        <div class="text-center mt-5 mb-5">
            <h4 class="mb-4">설문에 응답해주셔서 감사합니다!</h4>
            <p class="text-muted">소중한 의견은 더 나은 서비스를 위해 활용됩니다.</p>
            <a href="${pageContext.request.contextPath}/cs/survey" class="btn btn-primary mt-4">
                목록으로 돌아가기
            </a>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
