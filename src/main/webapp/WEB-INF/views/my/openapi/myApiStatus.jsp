<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>OPEN API 활용 현황</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css"
	rel="stylesheet" />

<%@ include file="/WEB-INF/views/include/top.jsp"%>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/mypagestyle.css" />

<style>
.api-card {
	border: 1px solid #e9ecef;
	border-radius: 10px;
	background: #fff;
	box-shadow: 0 2px 8px rgba(0, 0, 0, .04);
	overflow: hidden;
	margin-bottom: 18px;
}

.api-card-header {
	background: #f8f9fa;
	padding: 14px 18px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	border-bottom: 1px solid #edf1f5;
}

.api-title {
	font-size: 1.05rem;
	font-weight: 700;
	margin: 0;
}

.api-card-body {
	padding: 16px 18px;
}

.api-key-group {
	display: flex;
	gap: 8px;
}

.api-key-group input {
	flex: 1;
}

.api-guide-details {
	background: #fafbfd;
	border: 1px solid #edf1f5;
	border-radius: 8px;
	padding: 14px;
	margin-top: 12px;
}

.api-guide-details h4 {
	margin: 18px 0 8px;
	font-size: .95rem;
	font-weight: 700;
	border-bottom: 1px solid #e9ecef;
	padding-bottom: 6px;
}

.api-guide-details h4:first-child {
	margin-top: 0;
}

.api-guide-details code, .api-guide-details pre {
	font-size: .9rem;
}

.api-guide-details table {
	width: 100%;
	border-collapse: collapse;
}

.api-guide-details table th, .api-guide-details table td {
	padding: 8px 10px;
	border: 1px solid #dee2e6;
	text-align: left;
	vertical-align: top;
	background: #fff;
}

details.api-details summary {
	cursor: pointer;
	font-weight: 700;
	color: #0d6efd;
	list-style: none;
}

details.api-details summary::-webkit-details-marker {
	display: none;
}

details.api-details[open] summary .chev {
	transform: rotate(180deg);
}

.chev {
	display: inline-block;
	transition: transform .2s ease;
	margin-left: 4px;
}

.mypage-help {
	position: relative;
	display: inline-block;
	margin-left: 6px;
}

.mypage-help .tooltip-box {
	position: absolute;
	top: 28px;
	left: -6px;
	background: #111827;
	color: #fff;
	font-size: 12px;
	padding: 8px 10px;
	border-radius: 6px;
	display: none;
	white-space: nowrap;
	z-index: 10;
	box-shadow: 0 6px 16px rgba(0, 0, 0, .18);
}

.mypage-help:hover .tooltip-box {
	display: block;
}

.empty-state {
	background: #fff;
	border: 1px dashed #d0d7de;
	border-radius: 12px;
	padding: 42px 16px;
	text-align: center;
	color: #6b7280;
}

.status-badge {
	position: absolute;
	top: 10px;
	right: 10px;
	z-index: 1;
}
</style>
</head>
<body>
	<div class="container">
		<c:set var="activeMenu" value="apply" />
		<c:set var="activeSub" value="openapi" />
		<%@ include file="/WEB-INF/views/include/mySideBar.jsp"%>

		<main>
			<div class="mypage-header">
				<h2 style="display: flex; align-items: center; gap: 8px;">
					OPEN API 신청 현황</h2>
				<p>신청 현황을 확인하고, 발급된 API Key 및 활용 예제를 확인 하세요.</p>
			</div>

			<c:set var="approvedCnt" value="${approvedPage.total}" />
			<c:set var="pendingCnt" value="${pendingPage.total}" />
			<c:set var="rejectedCnt" value="${rejectedPage.total}" />

			<style>
			/* 숫자만 은은하게, 색 없음 */
			.tab-count {
				font-weight: 600;
				opacity: .6;
				margin-left: 6px;
			}
			
			.nav-pills .nav-link.active .tab-count {
				opacity: .9;
			}
			</style>

			<ul class="nav nav-pills mb-3" id="statusTabs" role="tablist">
				<li class="nav-item" role="presentation">
					<button class="nav-link ${activeTab == 'approved' ? 'active' : ''} d-flex align-items-center"
						id="tab-approved-btn" data-bs-toggle="pill"
						data-bs-target="#tab-approved" type="button" role="tab"
						aria-controls="tab-approved" aria-selected="${activeTab == 'approved'}">
						승인됨 <span class="tab-count">${approvedCnt}</span>
					</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${activeTab == 'pending' ? 'active' : ''} d-flex align-items-center"
						id="tab-pending-btn" data-bs-toggle="pill"
						data-bs-target="#tab-pending" type="button" role="tab"
						aria-controls="tab-pending" aria-selected="${activeTab == 'pending'}">
						승인 대기 <span class="tab-count">${pendingCnt}</span>
					</button>
				</li>
				<li class="nav-item" role="presentation">
					<button class="nav-link ${activeTab == 'rejected' ? 'active' : ''} d-flex align-items-center"
						id="tab-rejected-btn" data-bs-toggle="pill"
						data-bs-target="#tab-rejected" type="button" role="tab"
						aria-controls="tab-rejected" aria-selected="${activeTab == 'rejected'}">
						반려 <span class="tab-count">${rejectedCnt}</span>
					</button>
				</li>
			</ul>

			<div class="tab-content" id="statusTabsContent">

				<div class="tab-pane fade ${activeTab == 'approved' ? 'show active' : ''}" id="tab-approved"
					role="tabpanel" aria-labelledby="tab-approved-btn">
					<div class="card-container">
						<c:choose>
							<c:when test="${approvedPage.total > 0}">
								<c:forEach items="${approvedPage.content}" var="sub">
									<section class="api-card position-relative">
										<div class="api-card-header">
											<h3 class="api-title">
												<c:out value="${sub.apiNameKr}" />
											</h3>
										</div>
										<div class="api-card-body">
											<div class="row g-3">
												<div class="col-12 col-lg-7">
													<label class="form-label mb-1">나의 인증키 (API Key)</label>
													<div class="api-key-group">
														<input type="text" id="apiKey-${sub.subscriptionId}"
															class="form-control"
															value="<c:out value='${sub.apiKey}'/>" readonly>
														<button type="button" class="btn btn-outline-secondary"
															onclick="copyApiKey('apiKey-${sub.subscriptionId}')">
															<i class="far fa-copy"></i> 복사
														</button>
													</div>
												</div>
												<div class="col-12 col-lg-5">
													<label class="form-label mb-1">구독 기간</label>
													<div class="form-control" style="background: #f8fafc;">
														<fmt:formatDate value="${sub.startedAt}"
															pattern="yyyy.MM.dd" />
														~
														<c:choose>
															<c:when test="${not empty sub.expiredAt}">
																<fmt:formatDate value="${sub.expiredAt}"
																	pattern="yyyy.MM.dd" />
															</c:when>
															<c:otherwise>무기한</c:otherwise>
														</c:choose>
													</div>
												</div>
											</div>

											<details class="api-details" style="margin-top: 14px;">
												<summary>
													API 상세 이용 가이드 펼치기 <span class="chev"><i
														class="fas fa-chevron-down"></i></span>
												</summary>
												<div class="api-guide-details">
													<h4>요청 URL</h4>
													<p>
														<code>
															<c:out value="${sub.baseUrl}" />
															<c:out value="${sub.requestEndpoint}" />
														</code>
													</p>

													<h4>요청 파라미터</h4>
													<div>
														<c:out value="${sub.requestParamsDescHtml}"
															escapeXml="false" />
													</div>

													<h4>API 호출 시 주의사항</h4>
													<pre class="mb-0">
														<c:out value="${sub.apiCautions}" />
													</pre>

														<h4>입력 예시 (Request Example)</h4>
														<pre>
															<code class="language-json">
																<c:out value="${sub.requestExample}" />
															</code>
														</pre>

														<h4>출력 예시 (Response Example)</h4>
														<pre>
															<code class="language-json">
																<c:out value="${sub.responseExample}" />
															</code>
														</pre>

													<h4>샘플 코드 (JavaScript)</h4>
													<pre>
														<code class="language-javascript">
															<c:out value="${sub.sampleCode}" />
														</code>
													</pre>
												</div>
											</details>
										</div>
									</section>
								</c:forEach>
								<div class="mt-4">
									${approvedPage.pagingArea}
								</div>
							</c:when>
							<c:otherwise>
								<div class="empty-state">
									<p class="mb-3">현재 승인되어 사용 중인 API가 없습니다.</p>
									<a href="${pageContext.request.contextPath}/openapi"
										class="btn btn-primary">API 신청하러 가기</a>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="tab-pane fade ${activeTab == 'pending' ? 'show active' : ''}" id="tab-pending" role="tabpanel"
					aria-labelledby="tab-pending-btn">
					<div class="card-container">
						<c:choose>
							<c:when test="${pendingPage.total > 0}">
								<c:forEach items="${pendingPage.content}" var="p">
									<section class="api-card position-relative">
										<span class="badge bg-warning text-dark status-badge">승인
											대기</span>
										<div class="api-card-header">
											<h3 class="api-title">
												<c:out value="${p.apiNameKr}" />
											</h3>
										</div>
										<div class="api-card-body">
											<div class="mb-2 text-muted">
												<c:out value="${p.apiDesc}" />
											</div>
											<div class="row g-3">
												<div class="col-12 col-lg-6">
													<label class="form-label mb-1">신청일</label>
													<div class="form-control" style="background: #f8fafc;">
														<fmt:formatDate value="${p.applicatedAt}"
															pattern="yyyy.MM.dd HH:mm" />
													</div>
												</div>
												<div class="col-12 col-lg-6">
													<label class="form-label mb-1">신청 목적</label>
													<div class="form-control" style="background: #f8fafc;">
														<c:out value="${p.purposeDesc}" />
													</div>
												</div>
											</div>
										</div>
									</section>
								</c:forEach>
								<div class="mt-4">
									${pendingPage.pagingArea}
								</div>
							</c:when>
							<c:otherwise>
								<div class="empty-state">
									<p class="mb-0">승인 대기 중인 신청이 없습니다.</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="tab-pane fade ${activeTab == 'rejected' ? 'show active' : ''}" id="tab-rejected" role="tabpanel"
					aria-labelledby="tab-rejected-btn">
					<div class="card-container">
						<c:choose>
							<c:when test="${rejectedPage.total > 0}">
								<c:forEach items="${rejectedPage.content}" var="r">
									<section class="api-card position-relative">
										<span class="badge bg-danger status-badge">반려</span>
										<div class="api-card-header">
											<h3 class="api-title">
												<c:out value="${r.apiNameKr}" />
											</h3>
										</div>
										<div class="api-card-body">
											<div class="mb-2 text-muted">
												<c:out value="${r.apiDesc}" />
											</div>
											<div class="row g-3">
												<div class="col-12 col-lg-6">
													<label class="form-label mb-1">신청일</label>
													<div class="form-control" style="background: #f8fafc;">
														<fmt:formatDate value="${r.applicatedAt}"
															pattern="yyyy.MM.dd HH:mm" />
													</div>
												</div>
												<div class="col-12 col-lg-6">
													<label class="form-label mb-1">신청 목적</label>
													<div class="form-control" style="background: #f8fafc;">
														<c:out value="${r.purposeDesc}" />
													</div>
												</div>
											</div>

											<div class="mt-3">
												<a class="btn btn-primary btn-sm"
													href="${pageContext.request.contextPath}/openapi/apply?apiId=${r.apiId}">
													다시 신청 </a>
											</div>
										</div>
									</section>
								</c:forEach>
								<div class="mt-4">
									${rejectedPage.pagingArea}
								</div>
							</c:when>
							<c:otherwise>
								<div class="empty-state">
									<p class="mb-0">반려된 신청이 없습니다.</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

			</div>
			</main>
	</div>

	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-core.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/plugins/autoloader/prism-autoloader.min.js"></script>
	<script>
    function copyApiKey(inputId) {
        var el = document.getElementById(inputId);
        var text = el ? el.value : '';
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text).then(function(){ alert('API 키가 복사되었습니다: ' + text); })
            .catch(function(){ fallbackCopy(el, text); });
        } else { fallbackCopy(el, text); }
    }
    function fallbackCopy(inputEl, text) {
        try {
            if (inputEl) { inputEl.removeAttribute('readonly'); inputEl.select(); inputEl.setSelectionRange(0, 99999); }
            document.execCommand('copy');
            if (inputEl) inputEl.setAttribute('readonly','readonly');
            alert('API 키가 복사되었습니다: ' + text);
        } catch (e) { console.error(e); alert('복사에 실패했습니다. 수동으로 복사해주세요.'); }
    }
</script>
</body>
</html>