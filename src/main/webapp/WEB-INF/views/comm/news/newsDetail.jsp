<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${newsPost.title} - 상권 뉴스</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commstyle.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <c:set var="activeMenu" value="news"/>
    <%@ include file="/WEB-INF/views/include/commSideBar.jsp" %>

    <main>

        <!-- ✅ 페이지 헤더 (뉴스 제목 + 언론사 / 날짜 등) -->
        <div class="detail-header border-bottom pb-3 mb-4">
            <h2>${newsPost.title}</h2>
            <p class="d-flex justify-content-between flex-wrap align-items-center">
                <span>언론사: ${newsPost.press}</span>
                <span class="d-flex gap-3">
            <span>작성일: <fmt:formatDate value="${newsPost.createdAt}" pattern="yyyy-MM-dd"/></span>
            <span>조회수: ${newsPost.viewCount}</span>
            <c:if test="${not empty newsPost.adminId}">
                <span>작성자: ${newsPost.writerName}</span>
            </c:if>
        </span>
            </p>
        </div>
		
	        <!-- ✅ 뉴스 본문 -->
        <section class="content-wrapper">
            <div class="mb-4" id="detail-content">
                <p>${newsPost.content}</p>
            </div>

            <div class="text-end mb-3">
                <a class="btn btn-outline-primary" href="${newsPost.linkUrl}" target="_blank">
                    기사 원문 보기
                </a>
            </div>

            <div class="d-flex justify-content-center gap-2 mt-4">
                <button type="button" class="btn btn-secondary"
                        onclick="location.href='${pageContext.request.contextPath}/comm/news';">목록으로
                </button>
            </div>
        </section>
    </main>
</div>
<footer>
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</footer>
</body>
</html>
