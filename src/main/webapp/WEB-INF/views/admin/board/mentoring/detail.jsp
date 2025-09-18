<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8"/>
	<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<title>지원사업 상세 보기</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
<%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
	<%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

	<div id="content">
		<div class="main-container">

			<!-- ✅ 관리자 헤더 -->
			<div class="admin-header mb-4">
				<h2><i class="bi bi-file-earmark-text me-2"></i> 상세 보기</h2>
				<p>지원사업에 대해 상세 정보를 확인할 수 있습니다.</p>
			</div>

			<!-- ✅ 제목 및 메타 정보 -->
			<div class="card shadow-sm mb-4">
				<div class="card-body">
					<h4 class="fw-bold text-center">${post.title}</h4>
					<div class="d-flex justify-content-end text-muted small gap-3 mt-2">
						<span><strong>분류</strong> ${post.catCodeId}</span>
						<span><strong>등록일</strong> <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/></span>
						<span><strong>조회수</strong> ${post.viewCount}</span>
					</div>
				</div>
			</div>

			<!-- ✅ 이미지 -->
			<div class="mb-4">
				<div class="ratio ratio-16x9 rounded overflow-hidden shadow-sm">
					<c:choose>
						<c:when test="${not empty post.thumbnailPath}">
							<img src="${pageContext.request.contextPath}${post.thumbnailPath}" class="object-fit-cover" alt="${post.title}">
						</c:when>
						<c:otherwise>
							<img src="${pageContext.request.contextPath}/images/startUp/mentoring/mentoring_default.png" class="object-fit-cover" alt="기본 이미지">
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<!-- ✅ 본문 내용 -->
			<div class="card mb-4">
				<div class="card-body" style="white-space: pre-line; word-break: break-word; line-height:1.7;">
					<c:out value="${post.content}" escapeXml="false"/>
				</div>
			</div>
			
			<!-- ✅ 수정, 삭제 버튼 -->
			<c:set var="isClosed" value="${post.deadline.time < now.time}" />
			<div class="text-center mt-4 mb-5">
			    <div>
					<a href="${pageContext.request.contextPath}/admin/mentoring/updateForm?postId=${post.postId}"
					   class="btn btn-success px-4 py-2 ms-2">
					   <i class="bi bi-pencil-square me-1"></i> 수정하기
					</a>
			        <button type="button" class="btn btn-danger px-4 py-2 ms-2" onclick="deletePost(${post.postId})">
			            <i class="bi bi-trash me-1"></i> 삭제하기
			        </button>
			    </div>
			</div>
			
			<div class="d-flex justify-content-between align-items-center border-top pt-4 mt-4">
			    <c:choose>
			        <c:when test="${not empty prevPost and prevPost.prevPostId != 0}">
			            <a href="${pageContext.request.contextPath}/admin/mentoring/${prevPost.prevPostId}" class="btn btn-outline-secondary">
			                <i class="bi bi-chevron-left"></i> 이전 게시물
			            </a>
			        </c:when>
			        <c:otherwise>
			            <a href="#" class="btn btn-outline-secondary disabled">이전 게시물이 없습니다</a>
			        </c:otherwise>
			    </c:choose>
			
			    <a href="${pageContext.request.contextPath}/admin/mentoring" class="btn btn-primary">
			        <i class="bi bi-list"></i> 목록
			    </a>
			
			    <c:choose>
			        <c:when test="${not empty nextPost and nextPost.nextPostId != 0}">
			            <a href="${pageContext.request.contextPath}/admin/mentoring/${nextPost.nextPostId}" class="btn btn-outline-secondary">
			                다음 게시물 <i class="bi bi-chevron-right"></i>
			            </a>
			        </c:when>
			        <c:otherwise>
			            <a href="#" class="btn btn-outline-secondary disabled">다음 게시물이 없습니다</a>
			        </c:otherwise>
			    </c:choose>
			</div>

		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function deletePost(postId) {
        if (confirm("정말 이 게시물을 삭제하시겠습니까?")) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/admin/mentoring/delete';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'postId';
            input.value = postId;
            form.appendChild(input);

            document.body.appendChild(form);
            form.submit();
        }
    }
</script>

</body>
</html>
