<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>


<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <!-- ✅ 제목 -->
            <div class="admin-header mb-4">
                <h2><i class="bi bi-megaphone-fill me-2"></i> 공지사항 상세보기</h2>
                <p>공지사항의 내용을 확인하고 관리할 수 있습니다.</p>
            </div>

            <!-- ✅ 상세 카드 -->
            <div class="card mb-4">
                <div class="card-header bg-white border-bottom px-4 py-3">
                    <h4 class="m-0 fw-bold">${notice.title}</h4>
                    <div class="text-muted mt-2 small">
                        <span>카테고리: ${notice.catCodeName}</span> |
                        <span>작성자: ${notice.writerName}</span> |
                        <span><fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd HH:mm"/></span> |
                        <span>조회수: ${notice.viewCount}</span>
                    </div>
                </div>

                <div class="card-body px-4 py-4" style="font-size: 16px; line-height: 1.8;">
                    <c:out value="${notice.content}" escapeXml="false"/>
                </div>

                <!-- ✅ 첨부파일 -->
                <c:if test="${not empty files}">
                    <div class="card-footer bg-white px-4 py-3">
                        <div class="fw-semibold mb-2">첨부파일</div>
                        <ul class="list-unstyled mb-0">
                            <c:forEach var="file" items="${files}" varStatus="status">
                                <li class="mb-1">
                                    <i class="bi bi-paperclip me-1 text-secondary"></i>
                                    <a href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                                       class="text-decoration-none text-dark">
                                        붙임${status.index + 1}. ${file.fileOriginalName}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>
            </div>

            <!-- ✅ 버튼 영역 -->
            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/admin/notice" class="btn btn-secondary btn-sm">
                    <i class="bi bi-list"></i> 목록
                </a>
                <a href="${pageContext.request.contextPath}/admin/notice/update?postId=${notice.postId}"
                   class="btn btn-primary btn-sm">
                    <i class="bi bi-pencil"></i> 수정
                </a>
            </div>

        </div>
    </div>
</div>

</body>
</html>
