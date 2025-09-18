<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>상권 뉴스 게시판</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css">
	
	
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<div id="wrapper">
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

		<div id="content">
			<div class="main-container">
				<div class="d-flex justify-content-between align-items-center">
					<div class="admin-header" style="min-width: 250px;">
						<h2 class="mb-1">뉴스 관리</h2>
						<p class="mb-0 small">최신 상권 뉴스를 확인하고 관리할 수 있습니다.</p>
					</div>
				</div>
				<div
					class="d-flex justify-content-between align-items-end flex-wrap gap-2 mb-4">
					<div class="flex-grow-1">
						<form id="searchForm" action="/admin/news" method="get"
							class="d-flex flex-wrap align-items-end gap-2 mb-0">
							<input type="hidden" name="currentPage"
								value="${articlePage.currentPage}" />

							<div>
								<label class="form-label mb-1">날짜</label>
								<div class="input-group input-group-sm">
									<input type="date" name="startDate" class="form-control"
										value="${startDate}"> <span class="input-group-text">~</span>
									<input type="date" name="endDate" class="form-control"
										value="${endDate}">
								</div>
							</div>

							<div>
								<label class="form-label mb-1">검색 구분</label> <select
									name="searchType" class="form-select form-select-sm">
									<c:forEach var="c" items="${nsearchTags}">
										<option value="${c.codeId}"
											<c:if test="${searchType eq c.codeId}">selected</c:if>>
											${c.codeName}</option>
									</c:forEach>
								</select>
							</div>

							<div>
								<label class="form-label mb-1">검색어</label> <input type="text"
									name="keyword" class="form-control form-control-sm"
									placeholder="검색어 입력" value="${fn:escapeXml(keyword)}">
							</div>

							<div>
								<button type="submit" class="btn btn-primary btn-sm">
									<i class="bi bi-search"></i> 검색
								</button>
							</div>
						</form>
					</div>

					<div>
						<button class="btn btn-success btn-sm fw-semibold"
							onclick="location.href='/admin/news/form';">
							<i class="bi bi-plus-circle me-1"></i> 뉴스 등록
						</button>
					</div>
				</div>


				<div class="table-responsive" style="overflow: visible">
					<table
						class="table table-bordered table-hover align-middle text-center">
						<thead class="table-light">
							<tr>
								<th style="width: 80px;">No</th>
								<th style="width: 120px;">썸네일</th>
								<th class="text-start">제목</th>
								<th style="width: 160px;">언론사</th>
								<th style="width: 140px;">작성일</th>
								<th style="width: 100px;">조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty articlePage.content}">
									<c:forEach var="news" items="${articlePage.content}"
										varStatus="status">
										<tr>
											<td>${articlePage.total - (articlePage.currentPage - 1) * articlePage.size - status.index}</td>

											<%-- ======================================================= --%>
											<%--               [수정] 썸네일 표시 로직                   --%>
											<%-- ======================================================= --%>
											<td>
												<c:choose>
													<%-- thumbnailUrl에 값이 있는 경우 --%>
													<c:when test="${not empty news.thumbnailUrl}">
														<%-- contextPath를 추가하여 이미지 경로를 완성합니다. --%>
														<img src="${pageContext.request.contextPath}${news.thumbnailUrl}" 
															 alt="썸네일" style="width: 100px; height: 60px; object-fit: cover; border-radius: 4px;">
													</c:when>
													<%-- thumbnailUrl에 값이 없는 경우 --%>
													<c:otherwise>
														<%-- 기본 이미지를 표시합니다. 이 이미지는 프로젝트 내에 위치해야 합니다. --%>
														<img src="${pageContext.request.contextPath}/images/no-image.png" 
															 alt="이미지 없음" style="width: 100px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #dee2e6;">
													</c:otherwise>
												</c:choose>
											</td>

											<td class="text-start"><a
												href="/admin/news/detail?newsId=${news.newsId}"
												class="text-decoration-none text-dark fw-semibold">
													${news.title} </a></td>
											<td>${news.press}</td>
											<td><fmt:formatDate value="${news.createdAt}"
													pattern="yyyy-MM-dd" /></td>
											<td>${news.viewCount}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="6" class="text-center text-muted">등록된 뉴스가
											없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>

				<div class="pagination-container mt-4 text-center">
					<c:out value="${articlePage.pagingArea}" escapeXml="false" />
				</div>

			</div>
		</div>
	</div>
</body>
</html>