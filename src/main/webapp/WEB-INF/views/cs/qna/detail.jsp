<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Q&A 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commstyle.css">
</head>
<body>

<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <c:set var="activeMenu" value="inquiry"/>
    <c:set var="activeSub" value="qna"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>

        <!-- ✅ 제목 및 메타정보 -->
        <div class="detail-header border-bottom pb-3 mb-4">

            <!-- ✅ 제목 + 뱃지 한 줄 정렬 -->
            <div class="d-flex justify-content-between align-items-center flex-wrap"
                 style="margin-top: -20px; margin-bottom: 50px;">
                <h2 class="mb-0">${qna.title}</h2>
                <c:choose>
                    <c:when test="${empty answer}">
                        <span class="badge bg-warning text-white fw-semibold" style="margin-top:50px;">답변대기</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-success fw-semibold" style="margin-top:50px;">답변완료</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ✅ 메타 정보 -->
            <p class="d-flex justify-content-between flex-wrap align-items-center mt-2">
                <span>카테고리: ${qna.catCodeName}</span>
                <span class="d-flex gap-3">
            <span>작성자: ${qna.maskedWriterName}</span>
            <span><fmt:formatDate value="${qna.createdAt}" pattern="yyyy-MM-dd"/></span>
        </span>
            </p>
        </div>


        <!-- ✅ 질문 본문 -->
        <div class="p-4 mb-4" style="font-size: 16px; line-height: 1.8;">
            <c:out value="${qna.content}" escapeXml="false"/>
        </div>

        <!-- ✅ 첨부파일 -->
        <c:if test="${not empty files}">
            <div class="border rounded bg-white p-4 mb-4">
                <div class="fw-semibold mb-2">첨부파일</div>
                <ul class="list-unstyled d-flex flex-column gap-2 mb-0">
                    <c:forEach var="file" items="${files}" varStatus="status">
                        <li class="d-flex align-items-center">
                            <i class="material-icons me-2 text-secondary" style="font-size: 20px;">attach_file</i>
                            <a href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                               class="text-decoration-none text-dark text-truncate"
                               style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                                붙임${status.index + 1}. ${file.fileOriginalName}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <!-- ✅ 관리자 답변 -->
        <c:if test="${not empty answer}">
            <div class="border-top bg-light px-4 py-4 mb-4">
                <h5 class="text-black fw-bold mb-3">관리자 답변</h5>
                <div style="font-size: 16px; line-height: 1.8;">
                    <c:out value="${answer.content}" escapeXml="false"/>
                </div>
            </div>
        </c:if>

        <!-- ✅ 버튼 영역 -->
        <div class="d-flex justify-content-end gap-2">
            <a href="${pageContext.request.contextPath}/cs/qna" class="btn btn-secondary btn-sm">목록</a>

            <!-- 작성자 본인 -->
            <c:if test="${pageContext.request.userPrincipal.name == qna.userId}">
                <a href="${pageContext.request.contextPath}/cs/qna/update?quesId=${qna.quesId}"
                   class="btn btn-outline-primary btn-sm">수정</a>
                <form action="${pageContext.request.contextPath}/cs/qna/delete" method="post" class="d-inline"
                      onsubmit="return confirm('삭제하시겠습니까?');">
                    <input type="hidden" name="quesId" value="${qna.quesId}"/>
                    <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
                </form>
            </c:if>

            <!-- 관리자이면서 작성자 아님 -->
            <sec:authorize access="hasRole('ADMIN')">
                <c:if test="${pageContext.request.userPrincipal.name != qna.userId}">
                    <a href="${pageContext.request.contextPath}/cs/qna/update?quesId=${qna.quesId}"
                       class="btn btn-outline-primary btn-sm">수정</a>
                    <form action="${pageContext.request.contextPath}/cs/qna/delete" method="post" class="d-inline"
                          onsubmit="return confirm('삭제하시겠습니까?');">
                        <input type="hidden" name="quesId" value="${qna.quesId}"/>
                        <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
                    </form>
                </c:if>
            </sec:authorize>
        </div>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
