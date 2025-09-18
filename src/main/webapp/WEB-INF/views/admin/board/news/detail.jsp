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
<title>${newsPost.title}-상권뉴스</title>

<!-- Bootstrap & Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />
<!-- 공통 admin 스타일 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css">
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<!-- ★ list.jsp 와 똑같이 #wrapper 로 감싸기 -->
	<div id="wrapper">
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

		<!-- ★ #content → .main-container 구조 유지 -->
		<div id="content">
			<div class="main-container">

				<div class="admin-header mb-4">
					<h2>뉴스 상세보기</h2>
					<p>뉴스 내용과 관련 정보를 확인하고 관리할 수 있습니다.</p>
				</div>


				<div class="card mb-4">
					<div class="card-body">
						<div class="d-flex justify-content-between text-secondary mb-3">
							<span>언론사: ${newsPost.press}</span> <span>작성일: <fmt:formatDate
									value="${newsPost.createdAt}" pattern="yyyy-MM-dd HH:mm" /></span> <span>조회수:
								${newsPost.viewCount}</span>
							<c:if test="${not empty newsPost.adminId}">
								<span>작성자: ${newsPost.adminId}</span>
							</c:if>
						</div>
						<div class="post-content mb-4">
							<c:out value="${newsPost.content}" escapeXml="false" />
						</div>
						<div class="text-end">
							<a href="${newsPost.linkUrl}" target="_blank"
								class="btn btn-outline-primary btn-sm"> <i
								class="bi bi-box-arrow-up-right"></i> 기사 원문 보기
							</a>
						</div>
					</div>
				</div>

				<div class="d-flex justify-content-center gap-2 mb-4">
					<button type="button" class="btn btn-secondary"
						onclick="location.href='/admin/news';">
						<i class="bi bi-list-ul"></i> 목록
					</button>
					<button type="button" class="btn btn-primary"
						onclick="location.href='/admin/news/update?newsId=${newsPost.newsId}';">
						<i class="bi bi-pencil-square"></i> 수정
					</button>
					<button type="button" class="btn btn-danger"
						onclick="confirmAndDelete(${newsPost.newsId});">
						<i class="bi bi-trash"></i> 삭제
					</button>
				</div>

			</div>
			<!-- /.main-container -->
		</div>
		<!-- /#content -->
	</div>
	<!-- /#wrapper -->

	<form id="deleteNewsForm" action="/admin/news/delete" method="post"
		style="display: none;">
		<input type="hidden" name="newsId" id="deleteNewsIdInput" />
	</form>
	<script>
    function confirmAndDelete(newsId) {
        if (confirm('정말 삭제하시겠습니까?')) {
            document.getElementById('deleteNewsIdInput').value = newsId;
            document.getElementById('deleteNewsForm').submit();
        }
    }
</script>
</body>
</html>
