<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>오픈 API 신청 관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css"/>

    <style>
        .admin-header h2 { font-weight: 800; }
        .admin-header p { margin: 0; color: #6c757d; }
        .pagination-container { margin-top: 20px; padding-top: 10px; border-top: 1px solid #eee; }
        .table thead th { background-color: #f8f9fa; text-align: center; vertical-align: middle; }
        .badge { font-size: 15px !important; }
        .status-badge { font-weight: 700; }
        .status-pending { background-color: #ffc107; color: #212529; }
        .status-approved { background-color: #28a745; }
        .status-rejected { background-color: #dc3545; }
        .text-ellipsis { max-width: 420px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .table td:nth-child(1), .table td:nth-child(2), .table td:nth-child(4), .table td:nth-child(5), .table td:nth-child(6), .table td:nth-child(7) { text-align: center; }

        /* ▼▼▼▼▼ userList.jsp에서 가져온 칩(Chip) 스타일 ▼▼▼▼▼ */
        .chip-btn { border-radius: 9999px; --bs-btn-padding-y: .25rem; --bs-btn-padding-x: .6rem; --bs-btn-font-size: .8rem; font-weight: 600; letter-spacing: -.2px; }
        .chip-badge { font-size: .75rem; font-weight: 600; background-color: var(--bs-gray-100); border: 1px solid rgba(0, 0, 0, .08); margin-left: .4rem; }
        .chips { gap: .375rem; }
        .chip-btn.btn-outline-secondary { color: #212529 !important; border-color: #cfd4da; background-color: #fff; }
        .chip-btn.btn-outline-secondary:hover { color: #000 !important; background-color: #f8f9fa; border-color: #adb5bd; }
        .btn.btn-secondary .chip-badge { background-color: rgba(255, 255, 255, .18); color: #fff; border-color: transparent; }
        .btn.btn-outline-secondary .chip-badge { background-color: #f1f3f5; color: #495057; border-color: #e9ecef; }
        /* ▲▲▲▲▲ 여기까지 ▲▲▲▲▲ */
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header">
                    <h2 class="mb-1">
                        <i class="bi bi-plug me-2 text-primary"></i>API 신청 관리
                    </h2>
                    <p>사용자들이 제출한 오픈 API 이용 신청 목록입니다. <strong>‘심사하기’</strong>를 눌러 처리해주세요.</p>
                </div>
            </div>

            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 my-4">

                <%-- 필터 링크용 URL 생성: 검색어 유지 --%>
                <c:url var="urlAll" value="/admin/openapi/applications">
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                </c:url>
                <c:url var="urlPending" value="/admin/openapi/applications">
                    <c:param name="status" value="제출완료"/>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                </c:url>
                <c:url var="urlApproved" value="/admin/openapi/applications">
                    <c:param name="status" value="승인"/>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                </c:url>
                <c:url var="urlRejected" value="/admin/openapi/applications">
                    <c:param name="status" value="반려"/>
                    <c:if test="${not empty param.keyword}"><c:param name="keyword" value="${param.keyword}"/></c:if>
                </c:url>

                <%-- 왼쪽: 상태 칩 버튼 --%>
                <div class="d-flex align-items-center flex-wrap chips">
                    <a href="${urlAll}" class="btn chip-btn ${empty param.status ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        전체 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.TOTAL_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlPending}" class="btn chip-btn ${param.status == '제출완료' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        제출완료 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.PENDING_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlApproved}" class="btn chip-btn ${param.status == '승인' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        승인 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.APPROVED_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlRejected}" class="btn chip-btn ${param.status == '반려' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        반려 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.REJECTED_COUNT}" default="0"/>건</span>
                    </a>
                </div>

                <%-- 오른쪽: 검색폼 --%>
                <form action="${pageContext.request.contextPath}/admin/openapi/applications" method="get" class="d-flex align-items-center ms-auto flex-wrap gap-1">
                    <select name="status" class="form-select form-select-sm" style="width: 120px;" onchange="this.form.submit()">
                        <option value="" ${empty param.status ? 'selected' : ''}>모든 상태</option>
                        <option value="제출완료" ${param.status == '제출완료' ? 'selected' : ''}>제출완료</option>
                        <option value="승인" ${param.status == '승인' ? 'selected' : ''}>승인</option>
                        <option value="반려" ${param.status == '반려' ? 'selected' : ''}>반려</option>
                    </select>
                    <div class="input-group input-group-sm" style="width: 280px;">
                        <input type="text" name="keyword" class="form-control" placeholder="신청자 ID·이름 또는 API 이름" value="${param.keyword}">
                        <button type="submit" class="btn btn-primary" title="검색"><i class="bi bi-search"></i></button>
                    </div>
                </form>
            </div>
            <div class="table-responsive">
                <table class="table table-hover align-middle table-bordered text-center">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 80px;">번호</th>
                        <th style="width: 120px;">신청ID</th>
                        <th>신청 API</th>
                        <th style="width: 220px;">신청자</th>
                        <th style="width: 180px;">신청일</th>
                        <th style="width: 120px;">상태</th>
                        <th style="width: 160px;">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty articlePage.content}">
                            <c:forEach items="${articlePage.content}" var="app" varStatus="loop">
                                <tr>
                                    <td>${articlePage.total - ((articlePage.currentPage - 1) * articlePage.size + loop.index)}</td>
                                    <td>${app.applicationId}</td>
                                    <td class="text-start">
                                        <span class="text-ellipsis" title="${app.apiNameKr}">${app.apiNameKr}</span>
                                    </td>
                                    <td>
                                        <span class="fw-semibold">${app.userName}</span>
                                        <span class="text-muted">(${app.userId})</span>
                                    </td>
                                    <td><fmt:formatDate value="${app.applicatedAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${app.status == '제출완료'}"><span class="badge rounded-pill status-badge status-pending">제출완료</span></c:when>
                                            <c:when test="${app.status == '승인'}"><span class="badge rounded-pill status-badge status-approved text-white">승인</span></c:when>
                                            <c:when test="${app.status == '반려'}"><span class="badge rounded-pill status-badge status-rejected text-white">반려</span></c:when>
                                            <c:otherwise><span class="badge rounded-pill bg-secondary text-white">${app.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/admin/openapi/applications/detail?appId=${app.applicationId}">
                                                상세보기
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7" class="py-5">
                                    <c:choose>
                                        <c:when test="${not empty param.keyword}">
                                            <span class="text-muted">'<strong>${param.keyword}</strong>'에 대한 검색 결과가 없습니다.</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">접수된 API 이용 신청이 없습니다.</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="pagination-container text-center">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>

        </div></div></div><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>