<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/commstyle.css"/>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <c:set var="activeMenu" value="notice"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <!-- ✅ 페이지 헤더 -->
        <div class="detail-header border-bottom pb-3 mb-4">
            <h2>${notice.title}</h2>
            <p
                    class="d-flex justify-content-between flex-wrap align-items-center mt-2">
                <!-- 왼쪽: 카테고리 -->
                <span>카테고리: ${notice.catCodeName}</span>

                <!-- 오른쪽: 날짜, 조회수, 작성자 -->
                <span class="d-flex gap-3"> <span>작성일: <fmt:formatDate
                        value="${notice.createdAt}" pattern="yyyy-MM-dd"/></span> <span>조회수:
                    ${notice.viewCount}</span> <span>작성자: ${notice.writerName}</span>
					</span>
            </p>
        </div>


        <!-- ✅ 본문 내용 -->
        <div class="p-4 mb-4" style="font-size: 16px; line-height: 1.8;">
            <c:out value="${notice.content}" escapeXml="false"/>
        </div>

        <!-- ✅ 첨부파일 -->
        <c:if test="${not empty files}">
            <div class="border rounded bg-white p-4 mb-4">
                <div class="fw-semibold mb-2">첨부파일</div>
                <ul class="list-unstyled d-flex flex-column gap-2 mb-0">
                    <c:forEach var="file" items="${files}" varStatus="status">
                        <li class="d-flex align-items-center"><i
                                class="material-icons me-2 text-secondary"
                                style="font-size: 20px;">attach_file</i> <a
                                href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                                class="text-decoration-none text-dark text-truncate"
                                style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                            붙임${status.index + 1}. ${file.fileOriginalName} </a></li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- ✅ 버튼 그룹 -->
        <div class="d-flex justify-content-end gap-2">
            <a href="${pageContext.request.contextPath}/cs/notice"
               class="btn btn-secondary btn-sm"> 목록 </a>
            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/cs/notice/update?postId=${notice.postId}"
                   class="btn btn-outline-primary btn-sm">수정</a>

                <form action="${pageContext.request.contextPath}/cs/notice/delete"
                      method="post" class="d-inline"
                      onsubmit="return confirm('정말 삭제할까요?');">
                    <input type="hidden" name="postId" value="${notice.postId}"/>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
                </form>
            </sec:authorize>
        </div>
    </main>
</div>

<!-- Bootstrap JS -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
