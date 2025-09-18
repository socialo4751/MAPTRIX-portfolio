<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>자주 묻는 질문</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="stylesheet" href="/css/csstyle.css">
</head>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>
<main class="site-main">
    <div class="container">
        <c:set var="activeMenu" value="inquiry"/>
        <c:set var="activeSub" value="faq"/>
        <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

        <main>
            <div class="page-header">
                <h2>자주 묻는 질문 (FAQ)</h2>
            </div>
            <div class="title-info"
                 style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                    <p class="mb-0">이용자들이 자주 묻는 질문과 답변을 한곳에 모아, 궁금증을 해결할 수 있습니다.</p>
                </div>
            </div>
            <!-- 검색 + 카테고리 필터 -->
            <form action="${pageContext.request.contextPath}/cs/faq" method="get">
                <div class="search-bar">
                    <!-- 왼쪽: 총 FAQ 수 -->
                    <div class="fw-semibold" style="min-width: 120px; padding-left: 10px;">
                        총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
                    </div>

                    <!-- 오른쪽: 카테고리 + 검색창 -->
                    <div class="search-tools">
                        <select name="catCodeId" class="form-select form-select-sm" style="width: 120px;">
                            <option value="">전체</option>
                            <c:forEach var="code" items="${codeDetails}">
                                <option value="${code.codeId}"
                                        <c:if test="${param.catCodeId == code.codeId}">selected</c:if>>
                                        ${code.codeName}
                                </option>
                            </c:forEach>
                        </select>

                        <div class="position-relative flex-grow-1" style="min-width: 0;">
                            <input type="text"
                                   name="keyword"
                                   value="${fn:escapeXml(param.keyword)}"
                                   class="form-control form-control-sm pe-5"
                                   placeholder="검색어를 입력해 주세요">
                            <input type="hidden" name="currentPage" value="1"/>
                            <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                                  style="color:#666; cursor:pointer;"
                                  onclick="this.closest('form').submit()">search</span>
                        </div>
                    </div>
                </div>
            </form>


            <!-- FAQ 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr class="text-center">
                        <th style="width: 60px;">번호</th>
                        <th style="width: 90px;">카테고리</th>
                        <th>제목</th>
                    </tr>
                    </thead>
                    <tbody class="text-center">
                    <c:if test="${empty articlePage.content}">
                        <tr style="height: 60px;">
                            <td colspan="3" class="text-center fw-light">등록된 FAQ가 없습니다.</td>
                        </tr>
                    </c:if>
                    <c:forEach var="faq" items="${articlePage.content}" varStatus="status">
                        <tr style="height: 60px; cursor: pointer;"
                            onclick="location.href='${pageContext.request.contextPath}/cs/faq/detail?faqId=${faq.faqId}'">
                            <td>
                                    ${articlePage.total - ((articlePage.currentPage - 1) * articlePage.size) - status.index}
                            </td>
                            <td class="fw-light">${faq.catCodeName}</td>
                            <td class="text-center fw-light" style="width: 500px;">
                                <strong>${faq.title}</strong>
                            </td>
                        </tr>
                    </c:forEach>

                    </tbody>
                </table>
            </div>


            <!-- 페이징 -->
            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                    </ul>
                </nav>
            </div>
        </main>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
