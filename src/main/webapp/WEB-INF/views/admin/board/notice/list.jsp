<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 공지사항</title>
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
            <!-- 헤더 -->
            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header">
                    <h2><i class="bi bi-megaphone-fill me-2"></i> 공지사항</h2>
                    <p class="mb-0">공지사항을 등록하고 수정할 수 있습니다.</p>
                </div>
            </div>

            <!-- 검색 -->
            <div class="d-flex justify-content-between align-items-end flex-wrap mb-4 gap-3 mt-3">
                <!-- 폼은 왼쪽 영역을 차지 -->
                <form method="get" action="/admin/notice"
                      class="d-flex flex-wrap align-items-end gap-3 flex-grow-1">
                    <div>
                        <label class="form-label mb-1">카테고리</label>
                        <select name="catCodeId" class="form-select form-select-sm" style="min-width: 160px;">
                            <option value="">전체</option>
                            <c:forEach var="c" items="${codeDetails}">
                                <option value="${c.codeId}" <c:if test="${param.catCodeId == c.codeId}">selected</c:if>>
                                        ${c.codeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="form-label mb-1">검색어</label>
                        <input type="text" name="keyword"
                               value="${fn:escapeXml(param.keyword)}"
                               class="form-control form-control-sm"
                               placeholder="제목/내용 검색" style="min-width: 220px;">
                    </div>

                    <div>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>

                <!-- 등록 버튼: 오른쪽 끝 -->
                <div class="ms-auto">
                    <a href="/admin/notice/insert" class="btn btn-success fw-semibold btn-sm">
                        <i class="bi bi-plus-circle me-1"></i> 등록하기
                    </a>
                </div>
            </div>


            <!-- 목록 -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover table-sm text-center align-middle">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 80px;">No</th>
                        <th style="width: 150px;">카테고리</th>
                        <th class="text-start">제목</th>
                        <th style="width: 120px;">작성자</th>
                        <th style="width: 120px;">작성일</th>
                        <th style="width: 80px;">조회수</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty articlePage.content}">
                            <tr>
                                <td colspan="6" class="text-muted text-center">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="notice" items="${articlePage.content}" varStatus="status">
                                <tr>
                                    <td>${articlePage.total - ((articlePage.currentPage - 1) * articlePage.size) - status.index}</td>
                                    <td><c:out value="${notice.catCodeName}"/></td>
                                    <td class="text-start">
                                        <a href="/admin/notice/detail?postId=${notice.postId}"
                                           class="text-decoration-none">
                                            <c:out value="${notice.title}"/>
                                        </a>
                                    </td>
                                    <td><c:out value="${notice.writerName}"/></td>
                                    <td><fmt:formatDate value="${notice.createdAt}" pattern="yyyy-MM-dd"/></td>
                                    <td>${notice.viewCount}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination-container mt-4 text-center">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>
        </div>
    </div>
</div>
</body>
</html>
