<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>창업 후기 공유 게시판</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/commstyle.css">
	<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<div class="container">
		<c:set var="activeMenu" value="review" />
		<%@ include file="/WEB-INF/views/include/commSideBar.jsp"%>

		<main>
			<!-- ✅ 페이지 헤더 -->
			<div class="page-header">
				<h2>창업 후기</h2>
			</div>
			<div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">창업 과정에서 얻은 경험과 노하우를 서로 공유하는 공간입니다.</p>
            </div>
        </div>

			<!-- ✅ 총 게시글 + 검색 바 -->
			<form id="searchForm"
				action="${pageContext.request.contextPath}/comm/review" method="get"
				class="mb-4">
				<input type="hidden" name="currentPage" value="1" />

				<div
					class="d-flex justify-content-between align-items-center flex-wrap gap-2">
					<div class="fw-semibold"
						style="min-width: 120px; padding-left: 10px;">
						총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
					</div>

					<div
						class="d-flex align-items-center flex-wrap gap-2 justify-content-end">

						<select name="catCodeId" class="form-select form-select-sm"
							style="width: 130px;" onchange="this.form.submit()">
							<option value="">카테고리 전체</option>
							<c:forEach var="tag" items="${reviewTags}">
								<option value="${tag.codeId}"
									${catCodeId == tag.codeId ? 'selected' : ''}>${tag.codeName}</option>
							</c:forEach>
						</select> <select name="searchType" class="form-select form-select-sm"
							style="width: 130px;">
							<c:forEach var="tag" items="${searchTags}">
								<option value="${tag.codeId}"
									${searchType == tag.codeId ? 'selected' : ''}>${tag.codeName}</option>
							</c:forEach>
						</select>

						<div class="position-relative" style="width: 220px;">
							<input type="text" name="keyword"
								value="${fn:escapeXml(param.keyword)}"
								class="form-control form-control-sm pe-5"
								placeholder="검색어를 입력해 주세요"> <span
								class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
								style="color: #666; cursor: pointer;"
								onclick="this.closest('form').submit()"> search </span>
						</div>
					</div>
				</div>
			</form>

			<!-- ✅ 카드형 게시글 목록 -->
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
    <c:choose>
        <c:when test="${empty articlePage.content}">
            <div class="col-12 text-center text-muted py-5">
                작성된 게시글이 없습니다.
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="post" items="${articlePage.content}">
                <div class="col">
                    <div class="card h-100 news-card position-relative">

                        <%-- ▼▼▼ 썸네일 이미지 표시 부분 ▼▼▼ --%>
                        <c:if test="${not empty post.thumbnailUrl}">
                            <img src="${post.thumbnailUrl}" class="card-img-top" alt="게시글 썸네일" 
                                 style="height: 150px; object-fit: cover;">
                        </c:if>
                        <%-- ▲▲▲ 썸네il 이미지 표시 부분 ▲▲▲ --%>

                        <div class="card-body d-flex flex-column">
                            <h5 class="news-title mb-1 text-truncate"
                                style="font-size: 1.05rem; line-height: 1.3; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                ${post.title}
                            </h5>

                            <div class="text-secondary small mb-2"
                                 style="line-height: 1.5em; max-height: 4.5em; overflow: hidden;">
                                <c:choose>
                                    <c:when test="${fn:length(post.previewContent) > 103}">
                                        ${fn:substring(post.previewContent, 0, 103)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${post.previewContent}
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="mt-auto pt-2 border-top d-flex justify-content-between small text-muted">
                                <span>작성자: ${post.writerName}</span>
                                <span>
                                    <fmt:formatDate value="${post.createdAt}" pattern="yyyy-MM-dd" /> · 조회수 ${post.viewCount}
                                </span>
                            </div>

                            <a href="${pageContext.request.contextPath}/comm/review/detail?postId=${post.postId}"
                               class="stretched-link"></a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

			<!-- ✅ 페이지네이션 -->
			<div class="pagination-container mt-4 d-flex justify-content-center">
				<c:out value="${articlePage.pagingArea}" escapeXml="false" />
			</div>
			<div class="d-flex justify-content-end mt-3">
				<sec:authorize access="isAuthenticated()">
					<button type="button" class="btn btn-danger btn-sm"
						onclick="location.href='${pageContext.request.contextPath}/comm/review/form';">
						<i class="bi bi-pencil-square me-1"></i> 글쓰기
					</button>
				</sec:authorize>
			</div>
		</main>
	</div>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.getElementById('searchForm').addEventListener('submit',
				function() {
					this.querySelector('input[name="currentPage"]').value = 1;
				});

		document
				.addEventListener(
						'click',
						function(e) {
							const link = e.target.closest('.page-link');
							if (link && link.dataset.page) {
								e.preventDefault();
								document
										.querySelector('input[name="currentPage"]').value = link.dataset.page;
								document.getElementById('searchForm').submit();
							}
						});
	</script>
</body>
</html>
