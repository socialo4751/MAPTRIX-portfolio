<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>이력조회 및 다운로드</title>
    <style>
        .row {
            display: flex;
            flex-wrap: wrap;
            align-items: flex-start;
        }

        .my-page-content {
            padding: 20px;
            min-height: 500px;
        }

        /* 필터 버튼 스타일 */
        .filter-buttons {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-btn {
            padding: 8px 16px;
            border: 2px solid #dee2e6;
            background-color: #fff;
            color: #6c757d;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .filter-btn:hover {
            border-color: #0d6efd;
            color: #0d6efd;
            text-decoration: none;
        }

        .filter-btn.active {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: #fff;
        }

        .filter-btn.active:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
            color: #fff;
        }

        /* 검색 폼 스타일 */
        .search-form {
            margin-bottom: 20px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .search-form .input-group {
            max-width: 500px;
        }

        .search-form .form-control {
            border-radius: 6px 0 0 6px;
        }

        .search-form .btn {
            border-radius: 0 6px 6px 0;
            padding: 0.375rem 1rem;
        }

        /* 이력 타입에 따른 뱃지 스타일 */
        .badge {
            display: inline-block;
            padding: .25em .5em;
            font-size: .75em;
            font-weight: 600;
            line-height: 1;
            color: #fff;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: .375rem;
            margin: 2px;
        }

        .badge-simple {
            background-color: #0d6efd;
        }

        .badge-detail {
            background-color: #198754;
        }

        .badge-excel {
            background-color: #ffc107;
            color: #000;
        }

        /* 분석 모델별 뱃지 스타일 */
        .badge-model {
            background-color: #6f42c1;
            font-size: .65em;
            display: block;
            margin-top: 4px;
            width: fit-content;
        }

        .download-btn {
            padding: 6px 12px;
            font-size: 12px;
            text-decoration: none;
            background-color: #6c757d;
            color: white;
            border-radius: 4px;
            transition: background-color 0.2s;
            display: inline-block;
        }

        .download-btn:hover {
            background-color: #5a6268;
            color: white;
            text-decoration: none;
        }

        /* 분석 정보 표시 스타일 */
        .analysis-info {
            line-height: 1.4;
        }

        /* 테이블 셀 정렬 */
        .table td {
            vertical-align: middle;
        }

        .table th {
            background-color: #f8f9fa;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
        }

        .table thead th {
            text-align: center;
        }

        .table tbody td {
            text-align: center;
        }

        .table tbody td:nth-child(3) {
            text-align: left;
        }

        /* 검색 결과 정보 */
        .search-info {
            margin-bottom: 15px;
            color: #6c757d;
            font-size: 0.9em;
        }

        .search-keyword {
            color: #0d6efd;
            font-weight: 600;
        }
    </style>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <%-- 상단(헤더) 영역 포함 --%>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/mypagestyle.css">
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="report"/>
    <c:set var="activeSub" value="history"/>
    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>
    <main>
        <div class="mypage-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                이력조회 및 다운로드
            </h2>
            <p>상권분석 이력조회 및 다운로드를 할 수 있습니다.</p>
        </div>

        <%-- 메인 콘텐츠 영역 --%>
        <div class="card-container">
            <div class="user-info-section-2" style="padding:0;">
                
                <%-- 필터 버튼 --%>
                <div class="filter-buttons">
                    <a href="/my/report" class="filter-btn ${empty param.filterType ? 'active' : ''}">
                        <i class="fas fa-list"></i> 전체
                    </a>
                    <a href="/my/report?filterType=simple" class="filter-btn ${param.filterType eq 'simple' ? 'active' : ''}">
                        <i class="fas fa-file-alt"></i> 간단분석
                    </a>
                    <a href="/my/report?filterType=detail" class="filter-btn ${param.filterType eq 'detail' ? 'active' : ''}">
                        <i class="fas fa-chart-line"></i> 상세분석
                    </a>
                    <a href="/my/report?filterType=excel" class="filter-btn ${param.filterType eq 'excel' ? 'active' : ''}">
                        <i class="fas fa-file-excel"></i> 엑셀다운로드
                    </a>
                </div>

                <%-- 검색 폼 --%>
                <div class="search-form">
                    <form action="/my/report" method="get" class="d-flex align-items-center gap-3">
                        <input type="hidden" name="filterType" value="${param.filterType}">
                        <div class="input-group">
                            <input type="text" class="form-control" name="keyword" 
                                   value="${param.keyword}" placeholder="제목으로 검색하세요">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search"></i> 검색
                            </button>
                        </div>
                        <c:if test="${not empty param.keyword}">
                            <a href="/my/report?filterType=${param.filterType}" class="btn btn-outline-secondary">
                                <i class="fas fa-times"></i> 초기화
                            </a>
                        </c:if>
                    </form>
                </div>

                <%-- 검색 결과 정보 --%>
                <c:if test="${not empty param.keyword or not empty param.filterType}">
                    <div class="search-info">
                        <c:choose>
                            <c:when test="${not empty param.keyword and not empty param.filterType}">
                                '<span class="search-keyword">${param.keyword}</span>' 키워드로 
                                <c:choose>
                                    <c:when test="${param.filterType eq 'simple'}">간단분석</c:when>
                                    <c:when test="${param.filterType eq 'detail'}">상세분석</c:when>
                                    <c:when test="${param.filterType eq 'excel'}">엑셀다운로드</c:when>
                                </c:choose>
                                에서 검색된 결과 <strong>${articlePage.total}</strong>건
                            </c:when>
                            <c:when test="${not empty param.keyword}">
                                '<span class="search-keyword">${param.keyword}</span>' 키워드로 검색된 결과 <strong>${articlePage.total}</strong>건
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${param.filterType eq 'simple'}">간단분석</c:when>
                                    <c:when test="${param.filterType eq 'detail'}">상세분석</c:when>
                                    <c:when test="${param.filterType eq 'excel'}">엑셀다운로드</c:when>
                                </c:choose>
                                이력 <strong>${articlePage.total}</strong>건
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <%-- 테이블 --%>
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 70px;">번호</th>
                        <th style="width: 100px;">구분</th>
                        <th>제목</th>
                        <th style="width: 150px;">등록일</th>
                        <th style="width: 150px;">다시 다운로드</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%-- 데이터가 없는 경우 --%>
                    <c:if test="${articlePage.total == 0}">
                        <tr>
                            <td colspan="5" class="text-center py-5">
                                <c:choose>
                                    <c:when test="${not empty param.keyword}">
                                        '<strong>${param.keyword}</strong>' 검색 결과가 없습니다.
                                    </c:when>
                                    <c:when test="${not empty param.filterType}">
                                        <c:choose>
                                            <c:when test="${param.filterType eq 'simple'}">간단분석</c:when>
                                            <c:when test="${param.filterType eq 'detail'}">상세분석</c:when>
                                            <c:when test="${param.filterType eq 'excel'}">엑셀다운로드</c:when>
                                        </c:choose>
                                        이력이 없습니다.
                                    </c:when>
                                    <c:otherwise>
                                        분석 및 다운로드 이력이 없습니다.
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>

                    <%-- 데이터가 있는 경우 --%>
                    <c:forEach var="history" items="${articlePage.content}" varStatus="status">
                        <tr>
                            <%-- 게시물 번호 --%>
                            <td>${articlePage.total - ((articlePage.currentPage - 1) * articlePage.size) - status.index}</td>

                            <%-- 이력 구분 --%>
                            <td>
                                <div class="analysis-info">
                                    <c:choose>
                                        <c:when test="${history.historyType eq 'SIMPLE_PDF'}">
                                            <span class="badge badge-simple">간단 분석</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'DETAIL_PDF'}">
                                            <span class="badge badge-detail">상세 분석</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'AI_군집분석' or history.historyType eq 'AI_군집'}">
                                            <span class="badge badge-detail">상세 분석</span>
                                            <span class="badge badge-model">군집분석</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'AI_다중회귀' or history.historyType eq 'AI_GRID'}">
                                            <span class="badge badge-detail">상세 분석</span>
                                            <span class="badge badge-model">다중회귀</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'AI_로지스틱' or history.historyType eq 'AI_LOGISTIC'}">
                                            <span class="badge badge-detail">상세 분석</span>
                                            <span class="badge badge-model">로지스틱</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'AI_중력모형' or history.historyType eq 'AI_GRAVITY'}">
                                            <span class="badge badge-detail">상세 분석</span>
                                            <span class="badge badge-model">중력모형</span>
                                        </c:when>
                                        <c:when test="${history.historyType.startsWith('AI_')}">
                                            <span class="badge badge-detail">상세 분석</span>
                                            <span class="badge badge-model">AI분석</span>
                                        </c:when>
                                        <c:when test="${history.historyType eq 'INDICATOR_EXCEL'}">
                                            <span class="badge badge-excel">지표 다운로드</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </td>

                            <%-- 이력 제목 --%>
                            <td>${history.historyTitle}</td>

                            <%-- 등록일 --%>
                            <td>
                                <fmt:formatDate value="${history.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                            </td>

                            <%-- 다시 다운로드 버튼 --%>
                            <td>
                                <c:choose>
                                    <c:when test="${history.historyType eq 'INDICATOR_EXCEL'}">
                                        <button type="button" class="download-btn"
                                                onclick="reDownloadExcel(${history.historyId})">
                                            <i class="fas fa-download"></i> 다운로드
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="/my/report/download/${history.fileGroupNo}" class="download-btn">
                                            <i class="fas fa-download"></i> 다운로드
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <%-- 페이징 (데이터가 있을 때만 표시) --%>
                <c:if test="${articlePage.total > 0}">
                    <div class="d-flex justify-content-center mt-4" style="margin-bottom: 1.5rem;">
                        <nav>
                            <ul class="pagination pagination-sm mb-0">
                                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<%-- 엑셀 다운로드용 JavaScript 함수 --%>
<script>
    function reDownloadExcel(historyId) {
        fetch('/api/market/dashboard/re-download-excel', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({historyId: historyId}),
        })
            .then(response => {
                if (response.ok) {
                    const contentDisposition = response.headers.get('Content-Disposition');
                    let filename = 'download.xlsx';
                    if (contentDisposition) {
                        const filenameMatch = contentDisposition.match(/filename\*=UTF-8''(.+)/);
                        if (filenameMatch && filenameMatch.length > 1) {
                            filename = decodeURIComponent(filenameMatch[1]);
                        } else {
                            const filenameMatchFallback = contentDisposition.match(/filename="(.+)"/);
                            if (filenameMatchFallback && filenameMatchFallback.length > 1) {
                                filename = filenameMatchFallback[1];
                            }
                        }
                    }
                    return response.blob().then(blob => ({blob, filename}));
                } else if (response.status === 403) {
                    alert('다운로드 권한이 없습니다.');
                    throw new Error('Forbidden');
                } else if (response.status === 404) {
                    alert('파일을 찾을 수 없습니다. 관리자에게 문의하세요.');
                    throw new Error('Not Found');
                } else {
                    return response.json().then(errorData => {
                        throw new Error(errorData.error || '다운로드에 실패했습니다.');
                    });
                }
            })
            .then(({blob, filename}) => {
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.style.display = 'none';
                a.href = url;
                a.download = filename;
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                alert('엑셀 다운로드가 시작되었습니다.');
            })
            .catch(error => {
                console.error('다운로드 중 오류 발생:', error);
                if (error.message === 'Forbidden' || error.message === 'Not Found') {
                    // 이미 alert 처리됨
                } else {
                    alert(error.message);
                }
            });
    }
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>