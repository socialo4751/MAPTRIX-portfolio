<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="now" class="java.util.Date"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MAPTRIX</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <!-- Font Awesome (상세 네비/외부링크 아이콘용) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <!-- 페이지 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css">
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <main>
        <!-- 헤더 -->
        <div class="page-header">
            <h2>${post.title}</h2>
            <p class="mb-0">
                <span class="me-3"><strong>분류 : </strong> ${post.catCodeId}</span>
                <span class="me-3"><strong>등록일: </strong> <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/></span>
                <span><strong>조회수 : </strong> ${post.viewCount}</span>
            </p>
        </div>

        <!-- 썸네일 -->
        <div class="mb-4">
            <c:choose>
                <c:when test="${not empty post.thumbnailPath}">
                    <img class="img-fluid rounded w-100"
                         src="${pageContext.request.contextPath}${post.thumbnailPath}"
                         alt="${fn:escapeXml(post.title)}"/>
                </c:when>
                <c:otherwise>
                    <img class="img-fluid rounded w-100"
                         src="${pageContext.request.contextPath}/images/startup/mentoring/mentoring_default.png"
                         alt="${fn:escapeXml(post.title)}"/>
                </c:otherwise>
            </c:choose>
        </div>

		<!-- 본문 -->
		<div class="detail-content mb-4"
		     style="white-space: pre-line; word-break: break-word; line-height:1.7;">
		  <c:out value="${fn:trim(post.content)}"/>
		</div>


        <!-- 마감 여부 -->
        <c:set var="isClosed" value="${post.deadline.time < now.time}"/>

        <!-- 신청 버튼 -->
        <div class="d-flex justify-content-center my-4">
            <c:choose>
                <c:when test="${isClosed}">
                    <button type="button" class="btn btn-secondary btn-lg" disabled>
                        접수 마감
                    </button>
                </c:when>
                <c:otherwise>
                    <a href="${post.linkUrl}" target="_blank" class="btn btn-primary btn-lg">
                        온라인 신청하기 <i class="fa-solid fa-up-right-from-square ms-1"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 이전 / 목록 / 다음 -->
        <div class="d-flex justify-content-between align-items-center gap-2 mt-4">
            <c:choose>
                <c:when test="${not empty prevPost and prevPost.prevPostId != 0}">
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/start-up/mt/${prevPost.prevPostId}">
                        <i class="fa-solid fa-chevron-left me-1"></i> 이전 게시물
                    </a>
                </c:when>
                <c:otherwise>
                    <button type="button" class="btn btn-outline-secondary" disabled>
                        <i class="fa-solid fa-chevron-left me-1"></i> 이전 게시물
                    </button>
                </c:otherwise>
            </c:choose>

            <a class="btn btn-outline-dark"
               href="${pageContext.request.contextPath}/start-up/mt">
                <i class="fa-solid fa-list me-1"></i> 목록
            </a>

            <c:choose>
                <c:when test="${not empty nextPost and nextPost.nextPostId != 0}">
                    <a class="btn btn-outline-secondary"
                       href="${pageContext.request.contextPath}/start-up/mt/${nextPost.nextPostId}">
                        다음 게시물 <i class="fa-solid fa-chevron-right ms-1"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <button type="button" class="btn btn-outline-secondary" disabled>
                        다음 게시물 <i class="fa-solid fa-chevron-right ms-1"></i>
                    </button>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
