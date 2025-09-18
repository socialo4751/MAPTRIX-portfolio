<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%-- 모든 날짜 포맷을 KST(Asia/Seoul)로 출력 (안전하게 기본도 설정) --%>
<fmt:setTimeZone value="Asia/Seoul" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>시스템 로그</title>
<%-- adminMain.jsp의 기본 스타일을 그대로 사용합니다. --%>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    rel="stylesheet" />
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
    rel="stylesheet" />
<link rel="stylesheet"
    href="${pageContext.request.contextPath}/css/adminstyle.css">
<style>
.log-row:hover {
    cursor: pointer;
    background-color: #f8f9fa;
}

body.modal-open {
    padding-right: 0 !important;
}

.chip-btn {
    border-radius: 9999px;
    --bs-btn-padding-y: .25rem;
    --bs-btn-padding-x: .6rem;
    --bs-btn-font-size: .8rem;
    font-weight: 600;
    letter-spacing: -.2px;
}

.chip-badge {
    font-size: .75rem;
    font-weight: 600;
    background-color: var(--bs-gray-100);
    border: 1px solid rgba(0, 0, 0, .08);
    margin-left: .4rem;
}

.chips {
    gap: .375rem;
}

.chip-btn.btn-outline-secondary {
    color: #212529 !important;
    border-color: #cfd4da;
    background-color: #fff;
}

.chip-btn.btn-outline-secondary:hover {
    color: #000 !important;
    background-color: #f8f9fa;
    border-color: #adb5bd;
}

.btn.btn-secondary .chip-badge {
    background-color: rgba(255, 255, 255, .18);
    color: #fff;
    border-color: transparent;
}

.btn.btn-outline-secondary .chip-badge {
    background-color: #f1f3f5;
    color: #495057;
    border-color: #e9ecef;
}
</style>
<%@ include file="/WEB-INF/views/include/top.jsp"%>

</head>

<body>

    <div id="wrapper" style="display: flex;">
        <%-- ================================================================== --%>
        <%-- 2. 관리자 사이드바 (adminSideBar.jsp) 포함 --%>
        <%-- ================================================================== --%>
        <%-- 현재 메뉴를 '데이터관리'로 활성화하기 위해 activeMenu 변수 설정 --%>
        <c:set var="activeMenu" value="dataManagement" scope="request" />
        <%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

        <%-- ================================================================== --%>
        <%-- 3. 실제 로그 조회 컨텐츠 --%>
        <%-- ================================================================== --%>
        <div id="content">
            <div class="main-container">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="admin-header">
                        <h2 class="mb-1">
                            <i class="bi bi-bar-chart-line-fill me-2 text-primary"></i> 시스템
                            로그
                        </h2>
                        <p>사용자의 모든 로그를 확인 할 수 있습니다.</p>
                    </div>
                </div>

                <%-- 필터 링크용 URL 생성 --%>
                <c:url var="urlBase" value="/admin/stats/system">
                    <c:if test="${not empty params.searchStartDate}">
                        <c:param name="searchStartDate" value="${params.searchStartDate}" />
                    </c:if>
                    <c:if test="${not empty params.searchEndDate}">
                        <c:param name="searchEndDate" value="${params.searchEndDate}" />
                    </c:if>
                    <c:if test="${not empty params.category}">
                        <c:param name="category" value="${params.category}" />
                    </c:if>
                    <c:if test="${not empty params.keyword}">
                        <c:param name="keyword" value="${params.keyword}" />
                    </c:if>
                </c:url>

                <%-- 로그 레벨 칩 버튼 --%>
                <div class="d-flex align-items-end flex-wrap chips my-4">
                    <a href="${urlBase}"
                        class="btn chip-btn ${empty params.levelString ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        전체 <span class="badge rounded-pill chip-badge"><c:out
                                value="${logLevelSummary.TOTAL_COUNT}" default="0" />건</span>
                    </a>
                    <c:url var="urlError" value="${urlBase}"><c:param name="levelString" value="SYS_ERROR"/></c:url>
                    <a href="${urlError}"
                        class="btn chip-btn ${params.levelString == 'SYS_ERROR' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        ERROR <span class="badge rounded-pill chip-badge"><c:out
                                value="${logLevelSummary.ERROR_COUNT}" default="0" />건</span>
                    </a>
                    <c:url var="urlWarn" value="${urlBase}"><c:param name="levelString" value="SYS_WARN"/></c:url>
                    <a href="${urlWarn}"
                        class="btn chip-btn ${params.levelString == 'SYS_WARN' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        WARN <span class="badge rounded-pill chip-badge"><c:out
                                value="${logLevelSummary.WARN_COUNT}" default="0" />건</span>
                    </a>
                    <c:url var="urlInfo" value="${urlBase}"><c:param name="levelString" value="SYS_INFO"/></c:url>
                    <a href="${urlInfo}"
                        class="btn chip-btn ${params.levelString == 'SYS_INFO' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        INFO <span class="badge rounded-pill chip-badge"><c:out
                                value="${logLevelSummary.INFO_COUNT}" default="0" />건</span>
                    </a>
                    <c:url var="urlDebug" value="${urlBase}"><c:param name="levelString" value="SYS_DEBUG"/></c:url>
                    <a href="${urlDebug}"
                        class="btn chip-btn ${params.levelString == 'SYS_DEBUG' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        DEBUG <span class="badge rounded-pill chip-badge"><c:out
                                value="${logLevelSummary.DEBUG_COUNT}" default="0" />건</span>
                    </a>
                </div>

                <%-- 검색 폼 --%>
                <div class="card card-body mb-4">
                    <form id="searchForm" method="get" action="/admin/stats/system" class="row g-3 align-items-end">
                        <div class="col-md-3">
                            <label for="searchStartDate" class="form-label fw-bold">발생일시</label>
                            <div class="input-group">
                                <input type="date" id="searchStartDate" class="form-control" name="searchStartDate" value="${params.searchStartDate}">
                                <span class="input-group-text">~</span>
                                <input type="date" class="form-control" name="searchEndDate" value="${params.searchEndDate}">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label for="category" class="form-label fw-bold">카테고리</label>
                            <select id="category" name="category" class="form-select">
                                <option value="">-- 전체 --</option>
                                <c:forEach items="${logCategories}" var="cat">
                                    <option value="${cat.codeId}" <c:if test="${params.category == cat.codeId}">selected</c:if>>
                                        ${cat.codeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label for="levelString" class="form-label fw-bold">로그 레벨</label>
                            <select id="levelString" name="levelString" class="form-select">
                                <option value="">-- 전체 레벨 --</option>
                                <c:forEach items="${logLevels}" var="level">
                                    <option value="${level.codeId}" <c:if test="${params.levelString == level.codeId}">selected</c:if>>
                                        ${level.codeName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="keyword" class="form-label fw-bold">키워드</label>
                            <input type="text" id="keyword" name="keyword" class="form-control" value="${params.keyword}" placeholder="로그 메시지, 발생 위치 등">
                        </div>
                        <div class="col-md-2 d-flex">
                            <button type="submit" class="btn btn-primary flex-grow-1 me-1" title="검색">
                                <i class="bi bi-search"></i> 검색
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="location.href='/admin/stats/system'" title="초기화">
                                <i class="bi bi-arrow-clockwise"></i>
                            </button>
                        </div>
                    </form>
                </div>

                <table class="table table-hover table-bordered table-sm text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 5%;">번호</th>
                            <th style="width: 15%;">발생일시</th>
                            <th style="width: 8%;">레벨</th>
                            <th style="width: 32%;">발생 위치</th>
                            <th>메시지</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty articlePage.content}">
                                <tr>
                                    <td colspan="5" class="py-5">검색 결과가 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${articlePage.content}" var="log" varStatus="loop">
                                    <%-- KST 포맷팅 및 null 처리 --%>
                                    <c:choose>
                                        <c:when test="${not empty log.timestamp}">
                                            <c:set var="tsForModal"><fmt:formatDate value="${log.timestamp}" pattern="yyyy-MM-dd HH:mm:ss.SSS" timeZone="Asia/Seoul"/></c:set>
                                            <c:set var="tsForCell"><fmt:formatDate value="${log.timestamp}" pattern="yy-MM-dd HH:mm:ss" timeZone="Asia/Seoul"/></c:set>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="tsForModal">-</c:set>
                                            <c:set var="tsForCell">-</c:set>
                                        </c:otherwise>
                                    </c:choose>

                                    <tr class="log-row" data-bs-toggle="modal"
                                        data-bs-target="#logDetailModal"
                                        data-event-id="<c:out value='${log.eventId}'/>"
                                        data-timestamp="<c:out value='${tsForModal}'/>"
                                        data-level-string="<c:out value='${log.levelString}'/>"
                                        data-logger-name="<c:out value='${log.loggerName}'/>"
                                        data-thread-name="<c:out value='${log.threadName}'/>"
                                        data-formatted-message="<c:out value='${log.formattedMessage}'/>"
                                        data-caller-class="<c:out value='${log.callerClass}'/>"
                                        data-caller-method="<c:out value='${log.callerMethod}'/>"
                                        data-caller-line="<c:out value='${log.callerLine}'/>"
                                        data-caller-filename="<c:out value='${log.callerFilename}'/>">
                                        <td>${articlePage.total - (articlePage.currentPage - 1) * articlePage.size - loop.index}</td>
                                        <td><c:out value='${tsForCell}'/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.levelString == 'ERROR'}"><span class="badge text-bg-danger">ERROR</span></c:when>
                                                <c:when test="${log.levelString == 'WARN'}"><span class="badge text-bg-warning">WARN</span></c:when>
                                                <c:when test="${log.levelString == 'INFO'}"><span class="badge text-bg-info">INFO</span></c:when>
                                                <c:when test="${log.levelString == 'DEBUG'}"><span class="badge text-bg-secondary">DEBUG</span></c:when>
                                                <c:otherwise><span class="badge text-bg-light"><c:out value='${log.levelString}'/></span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-start text-truncate" style="max-width: 200px;"><c:out value='${log.loggerName}'/></td>
                                        <td class="text-start text-truncate" style="max-width: 300px;"><c:out value='${log.formattedMessage}'/></td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>

                <div class="mt-4">
                    <c:if test="${not empty articlePage.content}">
                        ${articlePage.pagingArea}
                    </c:if>
                </div>
            </div>
        </div>
    </div>


    <div class="modal fade" id="logDetailModal" tabindex="-1"
        aria-labelledby="logDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="logDetailModalLabel">로그 상세 정보</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                        aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalBodyContent">
                    <%-- 자바스크립트로 이 부분의 내용이 채워집니다. --%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary"
                        data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        const modalBody = document.getElementById('modalBodyContent');

        function getLevelBadge(levelString) {
            if (levelString === 'ERROR') {
                return '<span class="badge text-bg-danger">ERROR</span>';
            } else if (levelString === 'WARN') {
                return '<span class="badge text-bg-warning">WARN</span>';
            } else if (levelString === 'INFO') {
                return '<span class="badge text-bg-info">INFO</span>';
            } else if (levelString === 'DEBUG') {
                return '<span class="badge text-bg-secondary">DEBUG</span>';
            } else {
                return '<span class="badge text-bg-light">' + (levelString || '') + '</span>';
            }
        }

        document.querySelectorAll('.log-row').forEach(row => {
            row.addEventListener('click', function () {
                const dataset = this.dataset;

                // 데이터셋 값들을 안전하게 가져옵니다.
                const eventId = dataset.eventId || '-';
                const timestamp = dataset.timestamp || '-';
                const levelString = dataset.levelString || '';
                const threadName = dataset.threadName || '-';
                const loggerName = dataset.loggerName || '-';
                const formattedMessage = dataset.formattedMessage || '-';
                const callerFilename = dataset.callerFilename || '-';
                const callerLine = dataset.callerLine || '-';
                const callerClass = dataset.callerClass || '-';
                const callerMethod = dataset.callerMethod || '-';

                // 모달에 표시될 HTML 컨텐츠를 생성합니다.
                let contentHtml =
                    '<dl class="row">' +
                    '  <dt class="col-sm-3">이벤트 ID</dt><dd class="col-sm-9">' + eventId + '</dd>' +
                    '  <dt class="col-sm-3">발생일시</dt><dd class="col-sm-9">' + timestamp + '</dd>' +
                    '  <dt class="col-sm-3">레벨</dt><dd class="col-sm-9">' + getLevelBadge(levelString) + '</dd>' +
                    '  <dt class="col-sm-3">스레드 이름</dt><dd class="col-sm-9">' + threadName + '</dd>' +
                    '  <hr class="my-2">' +
                    '  <dt class="col-sm-3">발생 위치</dt><dd class="col-sm-9">' + loggerName + '</dd>' +
                    '  <hr class="my-2">' +
                    '  <dt class="col-sm-3">메시지</dt>' +
                    '  <dd class="col-sm-9"><pre style="white-space: pre-wrap; word-wrap: break-word; margin:0;">' + formattedMessage + '</pre></dd>' +
                    '  <hr class="my-2">' +
                    '  <dt class="col-sm-3">호출자 정보</dt>' +
                    '  <dd class="col-sm-9">' +
                    '    ' + callerFilename + '의 ' + callerLine + '번째 줄<br>' +
                    '    <small class="text-muted">' + callerClass + '#' + callerMethod + '()</small>' +
                    '  </dd>' +
                    '</dl>';

                modalBody.innerHTML = contentHtml;
            });
        });

        // 페이징 링크에 현재 검색 파라미터를 유지시킵니다.
        const searchParams = new URLSearchParams(location.search);
        searchParams.delete('currentPage');
        const preservedParams = searchParams.toString();
        const pagingLinks = document.querySelectorAll('.pagination a.page-link');

        if (preservedParams) {
            pagingLinks.forEach(link => {
                const separator = link.href.includes('?') ? '&' : '?';
                link.href += separator + preservedParams;
            });
        }
    });
</script>

</body>
</html>