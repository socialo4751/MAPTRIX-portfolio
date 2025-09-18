<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>뉴스 등록</title>
<script
	src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css">
<style>
.ck-editor__editable {
	min-height: 300px;
}
</style>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>

	<div id="wrapper">
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>
		<div id="content">
			<div class="main-container">
				<div class="admin-header mb-4">
					<h2>뉴스 등록</h2>
					<p>새로운 상권 뉴스를 직접 입력하거나 네이버 뉴스 API를 통해 자동으로 등록할 수 있습니다.</p>
				</div>

				<div class="panel">
					<h3>네이버 뉴스 API 검색</h3>
					<div class="d-flex gap-2 mb-3">
						<input type="text" id="naver-search-keyword" class="form-control"
							placeholder="검색할 뉴스 키워드를 입력하세요">
						<button type="button" class="btn btn-success"
							style="min-width: 80px;" onclick="searchNaverNews()">검색</button>
					</div>
					<div class="search-results-container">
						<div id="naver-news-results" class="news-results-grid">
							<div class="no-results-message">검색 키워드를 입력하고 검색 버튼을 클릭하세요.</div>
						</div>
					</div>
					<div class="text-end mt-3">
						<button type="button" class="btn btn-success"
							onclick="autoFillManualForm()">선택된 뉴스 자동입력</button>
					</div>
				</div>

				<form id="manualNewsForm" action="/admin/news/insert" method="POST"
					class="mt-5" enctype="multipart/form-data">
					<div class="mb-3">
						<label for="manual-catCodeId" class="form-label">카테고리</label> <select
							id="manual-catCodeId" name="catCodeId" class="form-select">
							<option value="NW101">정치</option>
							<option value="NW102">사회</option>
							<option value="NW103">경제</option>
							<option value="NW104">문화</option>
							<option value="NW105">기타</option>
						</select>
					</div>
					<div class="mb-3">
						<label for="manual-title" class="form-label">제목</label> <input
							type="text" id="manual-title" name="title" class="form-control"
							required>
					</div>
					
					<div class="mb-3">
						<label for="manual-press" class="form-label">언론사</label> <input
							type="text" id="manual-press" name="press" class="form-control"
							required>
					</div>
					<div class="mb-3">
						<label for="manual-publishedAt" class="form-label">작성일
							(YYYYMMDD)</label> <input type="text" id="manual-publishedAt"
							name="publishedAt" class="form-control" required>
					</div>
					<div class="mb-3">
						<label for="manual-content" class="form-label">본문 내용</label>
						<textarea id="manual-content" name="content" class="form-control"></textarea>
					</div>
					<input type="hidden" name="fileGroupNo" id="fileGroupNo" value="0">
					<input type="hidden" name="apiNewsId" id="manual-apiNewsId"
						value=""> <input type="hidden" id="manual-linkUrl"
						name="linkUrl" value="">
					<div class="button-group">
						<button type="button" class="btn btn-secondary"
							onclick="location.href='/comm/news';">목록으로</button>
						<button type="submit" class="btn btn-primary">등록</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script src="/js/news/form.js"></script>
	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>