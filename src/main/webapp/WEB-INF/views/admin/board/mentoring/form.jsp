<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>멘토링 · 컨설팅 · 교육 등록</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css" />
	<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>

	<div id="wrapper">
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

		<div id="content">
			<div class="main-container">
				<div class="admin-header mb-4">
					<h2>
						<i class="bi bi-pencil-square me-2"></i> 게시물 등록
					</h2>
					<p>지원사업 게시글을 등록합니다.</p>
				</div>

				<form action="${pageContext.request.contextPath}/admin/mentoring"
					method="post" enctype="multipart/form-data" class="row g-4">
					<div class="col-md-12">
						<label for="postTitle" class="form-label fw-bold">제목</label> <input
							type="text" id="postTitle" name="title" class="form-control"
							placeholder="게시물 제목을 입력하세요." required>
					</div>

					<div class="col-md-6">
						<label for="postCategory" class="form-label fw-bold">카테고리</label>
						<select id="postCategory" name="catCodeId" class="form-select"
							required>
							<option value="">-- 카테고리 선택 --</option>
							<%-- 컨트롤러에서 받은 categoryList로 동적으로 옵션을 생성합니다. --%>
							<c:forEach var="category" items="${categoryList}">
								<%-- DB에 저장될 값(value)은 코드ID, 화면에 보일 값은 코드명으로 설정합니다. --%>
								<option value="${category.codeId}">${category.codeName}</option>
							</c:forEach>
						</select>
					</div>

					<div class="col-md-6">
						<label for="endDate" class="form-label fw-bold">신청 마감일</label> <input
							type="date" id="endDate" name="deadline" class="form-control"
							required>
					</div>

					<div class="col-md-12">
						<label for="mainImage" class="form-label fw-bold">대표 이미지</label> <input
							type="file" id="mainImage" name="mainImageFile"
							class="form-control" accept="image/*">
					</div>

					<div class="col-md-12">
						<label for="postContent" class="form-label fw-bold">상세 내용</label>
						<textarea id="postContent" name="content" rows="10"
							class="form-control" placeholder="게시물의 상세 내용을 입력하세요." required></textarea>
					</div>

					<div class="col-md-12">
						<label for="applyLink" class="form-label fw-bold">신청/상세
							페이지 링크</label> <input type="url" id="applyLink" name="linkUrl"
							class="form-control"
							placeholder="예: https://example.com/apply-form" required>
					</div>

					<div class="col-12 d-flex justify-content-center mt-4 gap-3">
						<button type="submit" class="btn btn-primary px-4">
							<i class="bi bi-check-circle me-1"></i> 등록하기
						</button>
						<button type="button" class="btn btn-secondary px-4"
							onclick="history.back()">
							<i class="bi bi-x-circle me-1"></i> 취소
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
