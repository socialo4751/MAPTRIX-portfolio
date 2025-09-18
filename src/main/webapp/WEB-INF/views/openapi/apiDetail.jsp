<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오픈 API 상세</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css"
	rel="stylesheet" />

<%@ include file="/WEB-INF/views/include/top.jsp"%>
<link rel="stylesheet" href="/css/csstyle.css">
<style>
.page-header h2 {
	display: flex;
	align-items: center;
	gap: 8px;
	margin-bottom: 50px;
	margin-top: 50px;
}

.badge-cat {
	font-weight: 500;
}

.kv-table th {
	width: 150px;
	background: #fafafa;
	text-align: center;
}

.btn-area {
	display: flex;
	gap: 8px;
	justify-content: flex-end;
	margin-top: 20px;
}

/* Styles for new sections */
.api-guide-section {
	margin-bottom: 2.5rem;
}

.api-guide-section h4 {
	font-size: 1.1rem;
	font-weight: 700;
	border-bottom: 1px solid #eee;
	padding-bottom: 8px;
	margin-bottom: 12px;
}
</style>
</head>

<body>
	<div class="container">
		<c:set var="activeMenu" value="openapi" />
		<c:set var="activeSub" value="list" /><%@ include
			file="/WEB-INF/views/include/openapiSideBar.jsp"%>

		<main>
			<div class="page-header">
				<h2>
					<span class="material-icons" style="font-size: 28px;">integration_instructions</span>
					<c:out value="${apiService.apiNameKr}" />
				</h2>
			</div>

			<section class="mb-3">
				<div class="table-responsive">
					<table class="table table-bordered align-middle kv-table">
						<tbody>
							<tr>
								<th scope="row">API 카테고리</th>
								<td><c:out value="${apiService.apiCategory}" /></td>
								<th scope="row">서비스 유형</th>
								<td><c:out value="${apiService.serviceType}" /></td>
							</tr>
							<tr>
								<th scope="row">지원 포맷</th>
								<td><c:out value="${apiService.supportedFormats}" /></td>
								<th scope="row">일일 호출 제한</th>
								<td><fmt:formatNumber value="${apiService.dailyCallLimit}"
										pattern="#,##0" /> 회</td>
							</tr>
							<tr>
								<th scope="row">데이터 출처</th>
								<td><c:out value="${apiService.dataSourceInfo}" /></td>
								<th scope="row">구독 기간</th>
								<td><c:out value="${apiService.subscriptionPeriodMonths}" />
									개월</td>
							</tr>
						</tbody>
					</table>
				</div>
			</section>

			<div class="mt-5">

				<section class="api-guide-section">
					<h4>API 설명</h4>
					<p>
						<c:out value="${apiService.apiDesc}" />
					</p>
				</section>

				<c:if test="${not empty apiService.requestExample}">
					<section class="api-guide-section">
						<h4>입력 예시 (Request Example)</h4>
						<pre>
							<code class="language-json">
								<c:out value="${apiService.requestExample}" />
							</code>
						</pre>
					</section>
				</c:if>

				<c:if test="${not empty apiService.responseExample}">
					<section class="api-guide-section">
						<h4>출력 예시 (Response Example)</h4>
						<pre>
							<code class="language-json">
								<c:out value="${apiService.responseExample}" />
							</code>
						</pre>
					</section>
				</c:if>

				<c:if test="${not empty apiService.sampleCode}">
					<section class="api-guide-section">
						<h4>샘플 코드 (JavaScript)</h4>
						<pre>
							<code class="language-javascript">
								<c:out value="${apiService.sampleCode}" />
							</code>
						</pre>
					</section>
				</c:if>
			</div>

			<c:if test="${hasApplied}">
				<p
					style="text-align: right; margin-bottom: 8px; color: #dc3545; font-weight: 500;">
					* 이미 신청한 API 서비스입니다.</p>
			</c:if>

			<div class="btn-area">
				<c:choose>
					<c:when test="${hasApplied}">
						<a href="<c:url value='/my/openapi/status'/>"
							class="btn btn-primary"> <i class="material-icons"
							style="font-size: 18px; vertical-align: -4px;">manage_search</i>
							신청 현황 확인하기
						</a>
					</c:when>
					<c:otherwise>
						<sec:authorize access="isAuthenticated()">
							<a
								href="<c:url value='/openapi/apply'/>?apiId=${apiService.apiId}"
								class="btn btn-primary"> <i class="material-icons"
								style="font-size: 18px; vertical-align: -4px;">assignment</i>
								서비스 신청하기
							</a>
						</sec:authorize>
						<sec:authorize access="isAnonymous()">
							<a
								href="<c:url value='/login?redirect=/openapi/detail?apiId=${apiService.apiId}'/>"
								class="btn btn-secondary"> <i class="material-icons"
								style="font-size: 18px; vertical-align: -4px;">login</i> 로그인 후
								사용하세요
							</a>
						</sec:authorize>
					</c:otherwise>
				</c:choose>

				<a href="<c:url value='/openapi'/>"
					class="btn btn-outline-secondary"> <i class="material-icons"
					style="font-size: 18px; vertical-align: -4px;">list</i> 목록으로
				</a>
			</div>

		</main>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-core.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/autoloader/prism-autoloader.min.js"></script>

</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>