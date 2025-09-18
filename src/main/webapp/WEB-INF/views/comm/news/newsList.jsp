<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>상권 뉴스 게시판</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commstyle.css"/>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div class="container">
    <c:set var="activeMenu" value="news"/>
    <%@ include file="/WEB-INF/views/include/commSideBar.jsp" %>

    <main>
        <!-- ✅ 페이지 헤더 -->
        <div class="page-header">
            <h2>상권 뉴스</h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">소상공인을 위한 최신 창업 및 상권 뉴스를 한눈에 확인하세요.</p>
            </div>
        </div>
        <!-- ✅ 총 게시글 + 검색 바 한 줄 정렬 -->
        <form id="searchForm" action="/comm/news" method="get" class="mb-4">
            <input type="hidden" name="currentPage" value="${articlePage.currentPage}"/>

            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">

                <!-- 총 게시글 -->
                <div class="fw-semibold" style="min-width: 120px; padding-left: 10px;">
                    총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
                </div>

                <!-- 검색창 영역 -->
                <div class="d-flex align-items-center flex-wrap gap-2 justify-content-end">
                    <div class="input-group input-group-sm" style="width: 280px;">
                        <input type="date" name="startDate" value="${startDate}" class="form-control"/>
                        <span class="input-group-text">~</span>
                        <input type="date" name="endDate" value="${endDate}" class="form-control"/>
                    </div>

                    <select name="searchType" class="form-select form-select-sm" style="width:130px;">
                        <c:forEach var="cd" items="${nsearchTags}">
                            <option value="${cd.codeId}" ${searchType eq cd.codeId ? 'selected' : ''}>
                                    ${cd.codeName}
                            </option>
                        </c:forEach>
                    </select>

                    <div class="position-relative" style="width: 220px;">
                        <input type="text"
                               name="keyword"
                               value="${fn:escapeXml(keyword)}"
                               class="form-control form-control-sm pe-5"
                               placeholder="검색어를 입력해 주세요">
                        <input type="hidden" name="currentPage" value="1"/>
                        <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                              style="color:#666; cursor:pointer;"
                              onclick="this.closest('form').submit()"> search</span>
                    </div>
                </div>

            </div>
        </form>

        <!-- ✅ 뉴스 목록 (그리드 스타일 카드형) -->
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:choose>
                <c:when test="${not empty articlePage.content}">
                    <c:forEach var="news" items="${articlePage.content}" varStatus="status">
                        <div class="col">
                            <div class="card h-100 news-card position-relative">

                                    <%-- ★★★ 1. 썸네일 표시 방법 수정 ★★★
                                         - 잘못된 <td> 태그를 삭제하고, Bootstrap 카드 상단 이미지 전용 클래스인 'card-img-top'을 사용합니다.
                                         - 이미지가 없으면, 레이아웃이 깨지지 않도록 회색 배경의 'No Image' 영역을 표시합니다. --%>
                                <c:choose>
                                    <c:when test="${not empty news.thumbnailUrl}">
                                        <img src="${news.thumbnailUrl}" class="card-img-top" alt="뉴스 썸네일"
                                             style="height: 180px; object-fit: cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top d-flex align-items-center justify-content-center"
                                             style="height: 180px; background-color: #f8f9fa; color: #adb5bd;">
                                            <span>No Image</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                <div class="card-body d-flex flex-column">
                                        <%-- ★★★ 2. 긴 제목 처리 (말 줄임표) ★★★
                                             - 제목이 너무 길 경우, 2줄까지 보여주고 나머지는 '...'으로 표시하여 카드 높이를 맞춥니다. --%>
                                    <h5 class="news-title mb-3">
                                        <c:choose>
                                            <c:when test="${fn:length(news.title) > 48}">
                                                ${fn:substring(news.title, 0, 48)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${news.title}
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>

                                    <div class="mt-auto pt-2 border-top d-flex justify-content-between small text-muted">
                                        <span>언론사: ${news.press}</span>
                                        <span>
                                            <fmt:formatDate value="${news.createdAt}" pattern="yyyy-MM-dd"/>
                                            · 조회수 ${news.viewCount}
                                        </span>
                                    </div>

                                    <a href="/comm/news/detail?newsId=${news.newsId}" class="stretched-link"></a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12">
                        <div class="alert alert-light text-center">등록된 뉴스가 없습니다.</div>
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
</body>
<script>
    (function () {
        const form = document.getElementById('searchForm');
        const startInput = form.querySelector('input[name="startDate"]');
        const endInput = form.querySelector('input[name="endDate"]');

        function syncMinMax() {
            // 선택된 값 기준으로 상호 제약
            if (startInput.value) endInput.min = startInput.value; else endInput.removeAttribute('min');
            if (endInput.value) startInput.max = endInput.value; else startInput.removeAttribute('max');
        }

        startInput.addEventListener('change', syncMinMax);
        endInput.addEventListener('change', syncMinMax);
        syncMinMax();

        form.addEventListener('submit', function (e) {
            const s = startInput.value;
            const t = endInput.value;
            if (s && t && s > t) {
                // ✅ 옵션 A: 자동 교정(스왑)
                [startInput.value, endInput.value] = [endInput.value, startInput.value];
                syncMinMax();
                // 안내만 간단히
                alert('기간이 거꾸로여서 자동으로 교정했습니다.');
                // 만약 교정 말고 제출을 막고 싶으면 위 3줄 대신 아래 2줄만 쓰세요.
                // e.preventDefault();
                // alert('시작일이 종료일보다 클 수 없습니다. 기간을 다시 선택해 주세요.');
            }
        });
    })();
</script>

</html>
