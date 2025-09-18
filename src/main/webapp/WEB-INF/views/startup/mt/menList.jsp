<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="now" class="java.util.Date"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAPTRIX</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <!-- 커뮤니티 공통 레이아웃 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <style>
        .menlist-page .page-header {
            display: flex;
            flex-direction: column;
            align-items: center; /* 수평 가운데 */
            text-align: center; /* 텍스트 가운데 */
        }

        .menlist-page .page-header h2 {
            margin: 0 0 10px 0;
        }

        .menlist-page .page-header p {
            margin: 0;
        }

    </style>

</head>
<body>

<div class="container">
    <main>
        <!-- ✅ 페이지 헤더 -->
        <div class="menlist-page">
            <div class="page-header">
                <h2>지원사업 안내</h2>
            </div>
            <div class="title-info"
                 style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                    <p class="mb-0">지원사업 안내는 소상공인을 위한 최신 지원사업 정보를 제공하는 페이지입니다.</p>
                </div>
            </div>
        </div>
        <!-- ✅ 총 게시글 + 검색 바 한 줄 정렬 -->
        <form id="searchForm" action="${pageContext.request.contextPath}/start-up/mt" method="get" class="mb-4">
            <!-- 현재 페이지 (검색 시 1로 리셋) -->
            <input type="hidden" name="currentPage" id="currentPage"
                   value="${empty articlePage ? 1 : articlePage.currentPage}"/>


            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
                <!-- 총 게시글 -->
                <div class="fw-semibold" style="min-width:120px; padding-left:10px;">
                    총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
                </div>

                <!-- 검색툴 -->
                <div class="d-flex align-items-center flex-wrap gap-2 justify-content-end">
                    <!-- 분류 -->
                    <select name="searchType" class="form-select form-select-sm" style="width:130px;">
                        <option value="">전체</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.codeId}" ${param.searchType == category.codeId ? 'selected' : ''}>
                                    ${category.codeName}
                            </option>
                        </c:forEach>
                    </select>

                    <!-- 접수 여부 -->
                    <select name="statusType" class="form-select form-select-sm" style="width:130px;">
                        <option value="">전체</option>
                        <c:forEach var="status" items="${statusList}">
                            <option value="${status.codeId}" ${param.statusType == status.codeId ? 'selected' : ''}>
                                    ${status.codeName}
                            </option>
                        </c:forEach>
                    </select>

                    <!-- 키워드 -->
                    <div class="position-relative" style="width:260px;">
                        <input type="text"
                               name="keyword"
                               value="${fn:escapeXml(param.keyword)}"
                               class="form-control form-control-sm pe-5"
                               placeholder="키워드를 입력해 주세요"/>
                        <!-- 아이콘 클릭 제출 -->
                        <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                              style="color:#666; cursor:pointer;"
                              onclick="this.closest('form').submit()">search</span>
                    </div>
                </div>
            </div>
        </form>

        <!-- ✅ 지원사업 목록 (카드형 그리드) -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:choose>
                <c:when test="${not empty articlePage.content}">
                    <c:forEach items="${articlePage.content}" var="post">
                        <c:set var="isClosed" value="${post.deadline.time < now.time}"/>
                        <div class="col">
                            <div class="card h-100 position-relative mt-card">
                                <!-- 썸네일 -->
                                <c:choose>
                                    <c:when test="${not empty post.thumbnailPath}">
                                        <div style="position:relative;width:100%;height:200px;overflow:hidden;background:#f8f9fa;border-bottom:1px solid #eee;">
                                            <img
                                                    src="${pageContext.request.contextPath}${post.thumbnailPath}"
                                                    alt="${fn:escapeXml(post.title)}"
                                                    style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:top center;display:block;"
                                            />
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div style="position:relative;width:100%;height:200px;overflow:hidden;background:#f8f9fa;border-bottom:1px solid #eee;">
                                            <img
                                                    src="${pageContext.request.contextPath}/images/startup/mentoring/mentoring_default.png"
                                                    alt="기본 이미지"
                                                    style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:top center;display:block;"
                                            />
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="card-body d-flex flex-column">
                                    <!-- 카테고리 + 상태 배지 -->
                                    <div class="d-flex align-items-center justify-content-between mb-2">
                                        <span class="badge bg-secondary">
                                                ${post.catCodeId}
                                        </span>
                                        <c:choose>
                                            <c:when test="${isClosed}">
                                                <span class="badge bg-dark">접수마감</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-primary">접수중</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <!-- 제목 -->
                                    <h5 class="card-title mb-2">${post.title}</h5>


                                    <!-- 하단 메타 -->
                                    <div class="mt-auto pt-2 border-top small text-muted d-flex justify-content-between">
                                        <span>등록: <strong><fmt:formatDate value="${post.createdAt}"
                                                                          pattern="yyyy.MM.dd"/></strong></span>
                                        <span>마감: <strong><fmt:formatDate value="${post.deadline}"
                                                                          pattern="yyyy.MM.dd"/></strong></span>
                                    </div>

                                    <!-- 카드 전체 클릭 -->
                                    <a href="${pageContext.request.contextPath}/start-up/mt/${post.postId}"
                                       class="stretched-link"></a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col">
                        <div class="alert alert-light text-center">등록된 게시물이 없습니다.</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- ✅ 페이지네이션 -->
        <div class="pagination-container mt-4 d-flex justify-content-center">
            <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<!-- 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 검색 시 1페이지로 리셋
    document.getElementById('searchForm')?.addEventListener('submit', function () {
        const pageInput = this.querySelector('input[name="currentPage"]');
        if (pageInput) pageInput.value = 1;
    });
</script>

</body>
</html>
