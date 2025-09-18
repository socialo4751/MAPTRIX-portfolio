<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title><c:choose>
		<c:when test="${formMode == 'edit'}">OPEN API 서비스 수정</c:when>
		<c:otherwise>신규 OPEN API 서비스 등록</c:otherwise>
	</c:choose></title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<!-- Bootstrap & Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />

<!-- Admin common style -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css" />

<style>
.admin-header h2 {
	font-weight: 800;
}

.admin-header p {
	margin: 0;
	color: #6c757d;
}

.required::after {
	content: " *";
	color: #dc3545;
	font-weight: 700;
}

.help {
	color: #6c757d;
	font-size: .875rem;
}

.card section+section {
	margin-top: 1rem;
}

.url-preview {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
		"Liberation Mono", monospace;
	background: #f8f9fa;
	border: 1px dashed #e9ecef;
	border-radius: .5rem;
	padding: .5rem .75rem;
	word-break: break-all;
}

textarea.font-mono {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
		"Liberation Mono", monospace;
}
</style>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<div id="wrapper">
		<c:set var="activeMenu" value="openapi" />
		<c:set var="activeSub" value="services" />
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

		<div id="content">
			<div class="main-container">

				<!-- 타이틀 -->
				<div class="d-flex justify-content-between align-items-center">
					<div class="admin-header">
						<h2 class="mb-1">
							<i class="bi bi-gear-wide-connected me-2 text-primary"></i>
							<c:choose>
								<c:when test="${formMode == 'edit'}">OPEN API 서비스 수정</c:when>
								<c:otherwise>신규 OPEN API 서비스 등록</c:otherwise>
							</c:choose>
						</h2>
						<p>서비스 메타데이터와 호출 정보를 등록/수정합니다.</p>
					</div>
					<div>
						<a class="btn btn-outline-secondary btn-sm"
							href="${pageContext.request.contextPath}/admin/openapi/services">
							<i class="bi bi-list-ul"></i> 목록으로
						</a>
					</div>
				</div>

				<!-- 입력 폼 -->
				<form name="serviceForm" method="post"
					action="${pageContext.request.contextPath}/admin/openapi/services/process"
					class="needs-validation" novalidate>
					<c:if test="${formMode == 'edit'}">
						<input type="hidden" name="apiId" value="${apiServiceVO.apiId}">
					</c:if>
					<!-- (선택) CSRF -->
					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />

					<div class="card shadow-sm">
						<div class="card-body">
							<div class="row g-3">
								<!-- API 이름 -->
								<div class="col-md-6">
									<label for="apiNameKr" class="form-label required">API
										이름</label> <input type="text" id="apiNameKr" name="apiNameKr"
										value="${apiServiceVO.apiNameKr}" class="form-control"
										maxlength="100" required>
									<div class="invalid-feedback">API 이름을 입력하세요.</div>
								</div>

								<!-- 카테고리 -->
								<div class="col-md-6">
									<label for="apiCategory" class="form-label required">API
										카테고리</label> <select id="apiCategory" name="apiCategory"
										class="form-select" required>
										<option value="">-- 선택 --</option>
										<c:forEach items="${apiCateList}" var="cate">
											<option value="${cate.codeId}"
												${apiServiceVO.apiCategory == cate.codeId ? 'selected' : ''}>${cate.codeName}</option>
										</c:forEach>
									</select>
									<div class="invalid-feedback">카테고리를 선택하세요.</div>
								</div>

								<!-- 서비스 타입 -->
								<div class="col-md-6">
									<label for="serviceType" class="form-label required">서비스
										타입</label> <select id="serviceType" name="serviceType"
										class="form-select" required>
										<option value="">-- 선택 --</option>
										<c:forEach items="${apiTypeList}" var="type">
											<option value="${type.codeId}"
												${apiServiceVO.serviceType == type.codeId ? 'selected' : ''}>${type.codeName}</option>
										</c:forEach>
									</select>
									<div class="invalid-feedback">서비스 타입을 선택하세요.</div>
								</div>

								<!-- 제공 포맷 -->
								<div class="col-md-6">
									<label for="supportedFormats" class="form-label required">제공
										포맷</label> <select id="supportedFormats" name="supportedFormats"
										class="form-select" required>
										<option value="">-- 선택 --</option>
										<c:forEach items="${apiFormatList}" var="format">
											<option value="${format.codeId}"
												${apiServiceVO.supportedFormats == format.codeId ? 'selected' : ''}>${format.codeName}</option>
										</c:forEach>
									</select>
									<div class="invalid-feedback">제공 포맷을 선택하세요.</div>
								</div>

								<!-- Base URL -->
								<div class="col-md-6">
									<label for="baseUrl" class="form-label">Base URL</label> <input
										type="text" id="baseUrl" name="baseUrl"
										value="${apiServiceVO.baseUrl}" class="form-control"
										placeholder="https://api.example.com" pattern="https?://.*">
									<div class="help">예) https://api.example.com</div>
									<div class="invalid-feedback">유효한 URL(https://...)을
										입력하세요.</div>
								</div>

								<!-- 엔드포인트 -->
								<div class="col-md-6">
									<label for="requestEndpoint" class="form-label required">요청
										엔드포인트</label> <input type="text" id="requestEndpoint"
										name="requestEndpoint" value="${apiServiceVO.requestEndpoint}"
										class="form-control" placeholder="/api/v1/stats/population"
										pattern="^/.*$" required>
									<div class="help">슬래시(/)로 시작해야 합니다.</div>
									<div class="invalid-feedback">엔드포인트를 입력하세요. 예:
										/api/v1/...</div>
								</div>

								<!-- URL 미리보기 -->
								<div class="col-12">
									<label class="form-label">요청 URL 미리보기</label>
									<div id="urlPreview" class="url-preview">-</div>
								</div>

								<!-- 호출 제한 -->
								<div class="col-md-6">
									<label for="dailyCallLimit" class="form-label">일일 호출 제한</label>
									<input type="number" id="dailyCallLimit" name="dailyCallLimit"
										value="${apiServiceVO.dailyCallLimit}" class="form-control"
										placeholder="1000" min="0" step="1">
								</div>

								<div class="col-md-6">
									<label for="subscriptionPeriodMonths"
										class="form-label required">구독 기간 (개월)</label> <input
										type="number" id="subscriptionPeriodMonths"
										name="subscriptionPeriodMonths"
										value="${apiServiceVO.subscriptionPeriodMonths == 0 ? 12 : apiServiceVO.subscriptionPeriodMonths}"
										class="form-control" placeholder="12" min="1" required>
									<div class="help">사용자가 한 번 승인받았을 때 이용할 수 있는 개월 수입니다.</div>
									<div class="invalid-feedback">구독 기간(개월 수)을 입력하세요.</div>
								</div>
								<div class="col-md-6">

									<!-- 데이터 출처 -->
									<div class="col-md-6">
										<label for="dataSourceInfo" class="form-label">데이터 출처</label>
										<input type="text" id="dataSourceInfo" name="dataSourceInfo"
											value="${apiServiceVO.dataSourceInfo}" class="form-control"
											placeholder="통계청, 공공데이터포털 등" maxlength="200">
									</div>

									<!-- Swagger URL + 열기 -->
									<div class="col-md-8">
										<label for="swaggerUrl" class="form-label">Swagger URL</label>
										<div class="input-group">
											<input type="text" id="swaggerUrl" name="swaggerUrl"
												value="${apiServiceVO.swaggerUrl}" class="form-control"
												placeholder="https://api.example.com/swagger-ui/index.html">
											<button type="button" class="btn btn-outline-secondary"
												onclick="openSwagger()">
												<i class="bi bi-box-arrow-up-right"></i> 문서 열기
											</button>
										</div>
									</div>

									<!-- 설명 -->
									<div class="col-12">
										<label for="apiDesc" class="form-label">API 설명</label>
										<textarea id="apiDesc" name="apiDesc" rows="4"
											class="form-control" maxlength="2000">${apiServiceVO.apiDesc}</textarea>
									</div>

									<!-- 요청 파라미터 설명 -->
									<div class="col-12">
										<label for="requestParamsDesc" class="form-label">요청
											파라미터 설명 (Markdown)</label>
										<textarea id="requestParamsDesc" name="requestParamsDesc"
											rows="8" class="form-control font-mono"
											placeholder="| 파라미터 | 타입 | 필수 | 설명 |
|:---|:---|:---|:---|
| apiKey | String | Y | 인증키 |">${apiServiceVO.requestParamsDesc}</textarea>
										<div class="help">마크다운 표 형식을 지원합니다.</div>
									</div>

									<div class="col-12">
										<label for="requestExample" class="form-label">입력 예시
											(Request Example)</label>
										<textarea id="requestExample" name="requestExample" rows="8"
											class="form-control font-mono"
											placeholder="{&#10;  &quot;key&quot;: &quot;value&quot;&#10;}">${apiServiceVO.requestExample}</textarea>
										<div class="help">JSON, XML, cURL 등 API 요청의 전체 예시를
											작성합니다.</div>
									</div>

									<div class="col-12">
										<label for="responseExample" class="form-label">출력 예시
											(Response Example)</label>
										<textarea id="responseExample" name="responseExample" rows="8"
											class="form-control font-mono"
											placeholder="{&#10;  &quot;status&quot;: &quot;success&quot;,&#10;  &quot;data&quot;: []&#10;}">${apiServiceVO.responseExample}</textarea>
										<div class="help">API 호출 성공 시 반환되는 응답의 전체 예시를 작성합니다.</div>
									</div>

									<!-- 샘플 코드 -->
									<div class="col-12">
										<label for="sampleCode" class="form-label">샘플 코드</label>
										<textarea id="sampleCode" name="sampleCode" rows="12"
											class="form-control font-mono" placeholder="// fetch 예시 등">${apiServiceVO.sampleCode}</textarea>
									</div>
								</div>
							</div>

							<div
								class="card-footer d-flex justify-content-between align-items-center flex-wrap gap-2">
								<div class="text-muted small">* 표시 항목은 필수입니다.</div>
								<div class="d-flex gap-2">
									<button type="submit" class="btn btn-primary">
										<i class="bi bi-save"></i> 저장하기
									</button>
									<a
										href="${pageContext.request.contextPath}/admin/openapi/services"
										class="btn btn-outline-secondary"> 취소 </a>
								</div>
							</div>
						</div>
				</form>

			</div>
			<!-- /.main-container -->
		</div>
		<!-- /#content -->
	</div>
	<!-- /#wrapper -->

	<!-- Bootstrap JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

	<script>
    // 폼 검증 (부트스트랩)
    (function () {
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();

    // URL 미리보기 구성
    const $base = document.getElementById('baseUrl');
    const $ep = document.getElementById('requestEndpoint');
    const $pv = document.getElementById('urlPreview');

    function buildUrlPreview() {
        const base = ($base?.value || '').trim().replace(/\/+$/, '');
        const ep = ($ep?.value || '').trim();
        if (!base && !ep) {
            $pv.textContent = '-';
            return;
        }
        const full = (base ? base : '') + (ep ? (ep.startsWith('/') ? ep : '/' + ep) : '');
        $pv.textContent = full;
    }

    [$base, $ep].forEach(el => el && el.addEventListener('input', buildUrlPreview));
    buildUrlPreview();

    // Swagger 열기
    function openSwagger() {
        const url = (document.getElementById('swaggerUrl')?.value || '').trim();
        if (!url) return alert('Swagger URL을 입력하세요.');
        try {
            window.open(url, '_blank');
        } catch (e) {
        }
    }
</script>

</body>
</html>
