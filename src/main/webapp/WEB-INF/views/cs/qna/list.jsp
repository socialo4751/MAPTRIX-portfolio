<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>질의응답(Q&A)</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/csstyle.css">
</head>

<body>
<div class="container">
    <c:set var="activeMenu" value="inquiry"/>
    <c:set var="activeSub" value="qna"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                질의응답 (Q&A)
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">서비스 이용 중 궁금한 점을 자유롭게 질문하고, 다른 이용자들의 문의와 답변을 통해 필요한 정보를 확인할 수 있습니다.</p>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/cs/qna" method="get">
            <div class="search-bar">
                <!-- 왼쪽: 총 게시글 수 (동적) -->
                <div class="fw-semibold" style="min-width: 120px; padding-left: 10px;">
                    총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
                </div>

                <!-- 오른쪽: 카테고리 + 검색창 -->
                <div class="search-tools">
                    <select name="catCodeId" id="categorySelect" class="form-select form-select-sm"
                            style="width:120px;">
                        <option value="">전체</option>
                        <c:forEach var="cd" items="${qnaTags}">
                            <option value="${cd.codeId}" ${param.catCodeId == cd.codeId ? 'selected' : ''}>${cd.codeName}</option>
                        </c:forEach>
                    </select>

                    <select name="searchType" id="searchTypeSelect" class="form-select form-select-sm"
                            style="width:120px;">
                        <c:forEach var="cd" items="${searchTags}">
                            <option value="${cd.codeId}" ${param.searchType == cd.codeId ? 'selected' : ''}>${cd.codeName}</option>
                        </c:forEach>
                    </select>

                    <%-- 검색어 입력 창 --%>
                    <div class="position-relative flex-grow-1" style="min-width: 0;">
                        <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}"
                               class="form-control form-control-sm pe-5" placeholder="검색어를 입력해 주세요">
                        <input type="hidden" name="currentPage" value="1"/>
                        <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                              style="color:#666; cursor:pointer;"
                              onclick="this.closest('form').submit()">search</span>
                    </div>
                </div>
            </div>
        </form>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr class="text-center">
                    <th style="width: 100px;">번호</th>
                    <th style="width: 150px;">카테고리</th>
                    <th>제목</th>
                    <th style="width: 150px;">작성자</th>
                    <th style="width: 100px;">작성일</th>
                    <th style="width: 100px;">문의상태</th>
                </tr>
                </thead>
                <tbody class="text-center">
                <!-- 데이터 없을 때 -->
                <c:if test="${empty articlePage.content}">
                    <tr style="height:60px;">
                        <td colspan="6" class="text-center fw-light">등록된 문의가 없습니다.</td>
                    </tr>
                </c:if>
                <!-- 데이터 있을 때 -->
                <c:forEach var="item" items="${articlePage.content}" varStatus="st">
                    <tr style="height:60px;">
                        <td>
                                ${articlePage.total
                                        - ((articlePage.currentPage - 1) * articlePage.size)
                                        - st.index}
                        </td>
                        <td class="fw-light">[<c:out value="${item.catCodeName}"/>]</td>
                        <td class="text-start notice-title" style="width:500px;">
                            <c:choose>
                                <c:when test="${item.publicYn == 'N'}">
                                    <!-- 관리자 또는 본인일 경우: 제목 1번만 출력 -->
                                    <c:if test="${pageContext.request.userPrincipal.name == item.userId}">
                                        <a href="${pageContext.request.contextPath}/cs/qna/detail?quesId=${item.quesId}"
                                           class="notice-link text-muted">
                                            <span class="material-icons lock-icon" title="비공개">lock</span>
                                            <c:out value="${item.title}"/>
                                        </a>
                                    </c:if>
                                    <sec:authorize access="hasRole('ADMIN')">
                                        <c:if test="${pageContext.request.userPrincipal.name != item.userId}">
                                            <a href="${pageContext.request.contextPath}/cs/qna/detail?quesId=${item.quesId}"
                                               class="notice-link text-muted">
                                                <span class="material-icons lock-icon" title="비공개">lock</span>
                                                <c:out value="${item.title}"/>
                                            </a>
                                        </c:if>
                                    </sec:authorize>

                                    <!-- 접근 불가 사용자 -->
                                    <c:if test="${pageContext.request.userPrincipal.name != item.userId}">
                                        <sec:authorize access="!hasRole('ADMIN')">
                                            <a href="javascript:void(0);" onclick="return false;"
                                               class="notice-link text-muted link-disabled">
                                                <span class="material-icons lock-icon" title="비공개">lock</span>
                                                <c:out value="${item.title}"/>
                                            </a>
                                        </sec:authorize>
                                    </c:if>
                                </c:when>

                                <c:otherwise>
                                    <!-- 공개글 -->
                                    <a href="${pageContext.request.contextPath}/cs/qna/detail?quesId=${item.quesId}"
                                       class="notice-link">
                                        <c:out value="${item.title}"/>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="fw-light"><c:out value="${item.maskedWriterName}"/></td>
                        <td class="fw-light">
                            <fmt:formatDate value="${item.createdAt}" pattern="yyyy.MM.dd"/>
                        </td>
                        <td class="fw-light">
                            <c:choose>
                                <c:when test="${item.answered eq 'N'}">
                                <span class="badge bg-warning text-white fw-semibold status-badge px-2 py-1 fs-7"
                                      style="font-size: 14px;">답변대기</span>
                                </c:when>
                                <c:otherwise>
                                <span class="badge bg-success fw-semibold status-badge px-2 py-1 fs-7"
                                      style="font-size: 14px;">답변완료</span>
                                </c:otherwise>
                            </c:choose>
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

        <!-- 작성하기 버튼 (로그인 사용자만) -->
        <sec:authorize access="isAuthenticated()">
            <div class="d-flex justify-content-end mt-2">
                <a href="${pageContext.request.contextPath}/cs/qna/insert"
                   class="btn btn-primary btn-sm">작성하기</a>
            </div>
        </sec:authorize>

    </main><!-- /.content-wrapper -->
</div><!-- /.content -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 페이지가 로드되면 실행될 함수를 정의합니다. (async 키워드 사용)
    async function setupDynamicSelects() {
        // 공통으로 사용할 URL 파라미터 객체
        const urlParams = new URLSearchParams(window.location.search);

        // 데이터를 가져와서 select box를 채우는 공통 함수
        const populateSelect = async (groupId, selectId, defaultValue) => {
            const selectElement = document.getElementById(selectId);
            const selectedValue = urlParams.get(selectElement.name) || defaultValue;
            const url = '${pageContext.request.contextPath}/codes/' + groupId;

            try {
                // fetch로 서버에 데이터 요청 (await로 결과가 올 때까지 기다림)
                const response = await fetch(url);
                if (!response.ok) {
                    // 응답이 실패하면 에러 발생
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                const codes = await response.json(); // JSON 데이터 변환

                // 받아온 데이터로 <option> 태그를 만들어 select box에 추가
                codes.forEach(code => {
                    const option = document.createElement('option');
                    option.value = code.codeId;
                    option.textContent = code.codeName;
                    if (code.codeId === selectedValue) {
                        option.selected = true; // 현재 선택된 값과 일치하면 selected로 지정
                    }
                    selectElement.appendChild(option);
                });

            } catch (error) {
                console.error(`Error loading data for ${groupId}:`, error);
            }
        };

        // 위에서 만든 공통 함수를 사용해 각 드롭다운을 채웁니다.
        // Promise.all을 사용해 두 요청을 동시에 보내고 모두 끝날 때까지 기다립니다.
        await Promise.all([
            populateSelect('QNATAG', 'categorySelect', ''), // 카테고리 (기본값: 전체)
            populateSelect('SEARCHTAG', 'searchTypeSelect', 'title_content') // 검색 유형 (기본값: 제목+내용)
        ]);
    }
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
