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
    <title>공지사항</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <c:set var="pageTitle" value="공지사항" scope="request"/>
    <jsp:include page="/WEB-INF/views/include/top.jsp"/>
    <link rel="stylesheet" href="/css/csstyle.css">
</head>


<body>
<div class="container">
    <c:set var="activeMenu" value="notice"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>
    <main>
        <div class="page-header" style="margin-bottom: 25px;">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                공지사항
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">서비스 이용에 필요한 최신 소식을 확인하세요.</p>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/cs/notice" method="get">
            <div class="search-bar">
                <!-- 왼쪽: 총 게시글 수 (동적) -->
                <div class="fw-semibold" style="min-width: 120px; padding-left: 10px;">
                    총 게시글 <span class="text-dark-blue fw-bold">${articlePage.total}</span>건
                </div>

                <!-- 오른쪽: 카테고리 + 검색창 (static) -->
                <div class="search-tools">
                    <!-- 카테고리 (AJAX로 동적 채움) -->
                    <select name="catCodeId" class="form-select form-select-sm" style="width:120px;">
                        <option value="">전체</option>
                        <c:forEach var="cd" items="${codeDetails}">
                            <option value="${cd.codeId}" ${param.catCodeId == cd.codeId ? 'selected' : ''}>${cd.codeName}</option>
                        </c:forEach>
                    </select>
                    <!-- 검색 대상 (name 바꿔야 함) -->
                    <select id="searchSelect" name="searchType" class="form-select form-select-sm" style="width:120px;">
                        <c:forEach var="cd" items="${searchTags}">
                            <option value="${cd.codeId}" ${param.searchType == cd.codeId ? 'selected' : ''}>${cd.codeName}</option>
                        </c:forEach>
                    </select>

                    <!-- 키워드 -->
                    <div class="position-relative flex-grow-1" style="min-width:0;">
                        <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}"
                               class="form-control form-control-sm pe-5" placeholder="검색어를 입력해 주세요">
                        <input type="hidden" name="currentPage" value="1"/>
                        <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                              style="color:#666; cursor:pointer;" onclick="this.closest('form').submit()">search</span>
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
                    <th style="width: 100px;">조회수</th>
                </tr>
                </thead>
                <tbody class="text-center">
                <!-- 1) 데이터가 없으면 한 줄로 메시지 출력 -->
                <c:if test="${empty articlePage.content}">
                    <tr style="height: 60px;">
                        <td colspan="6" class="text-center fw-light">작성된 게시글이 없습니다.</td>
                    </tr>
                </c:if>
                <c:forEach var="notice" items="${articlePage.content}" varStatus="status">
                    <tr style="height: 60px;">
                        <td>
                                ${articlePage.total
                                        - ((articlePage.currentPage - 1) * articlePage.size)
                                        - status.index}
                        </td>
                        <td class="fw-light">(<c:out value="${notice.catCodeName}"/>)</td>
                        <td class="text-start fw-light notice-title" style="width: 500px;">
                            <a href="${pageContext.request.contextPath}/cs/notice/detail?postId=${notice.postId}"
                               class="notice-link">
                                <c:out value="${notice.title}"/>
                            </a>
                        </td>
                        <td class="fw-light"><c:out value="${notice.writerName}"/></td>
                        <td class="fw-light">
                            <fmt:formatDate value="${notice.createdAt}" pattern="yyyy.MM.dd"/>
                        </td>
                        <td class="fw-light"><c:out value="${notice.viewCount}"/></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 페이징: static -->
        <div class="d-flex justify-content-center mt-4">
            <nav>
                <ul class="pagination pagination-sm mb-0">
                    <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                </ul>
            </nav>
        </div>

        <!-- 작성하기 버튼 -->
        <sec:authorize access="hasRole('ADMIN')">
            <sec:authentication property="principal.UsersVO.userId" var="userId"/>
            <div class="d-flex justify-content-end mt-2">
                <a href="${pageContext.request.contextPath}/cs/notice/insert"
                   class="btn btn-primary btn-sm">작성하기</a>
            </div>
        </sec:authorize>
    </main>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<script>
    document.addEventListener('DOMContentLoaded', async () => {
        const groupId = 'NOTICETAG';                  // 실제 그룹ID (맞음)
        const selected = new URLSearchParams(location.search).get('catCodeId') || '';
        const sel = document.getElementById('catSelect');
        const url = '${ctx}/codes/' + groupId;    // ★ EL은 문자열로 확정 후 이어붙이기

        try {
            const res = await fetch(url, {headers: {'Accept': 'application/json'}});
            if (!res.ok) {
                console.error('fetch failed:', res.status, res.statusText);
                return;
            }

            const data = await res.json(); // 예: [{codeId, groupId, codeName, useYn}, ...]
            // 혹시 백엔드가 groupId 필터를 안 하면 클라에서 한 번 더 거르기
            const list = (Array.isArray(data) ? data : []).filter(cd =>
                (cd.groupId ?? cd.codeGroupId) === groupId && (cd.useYn ?? 'Y') === 'Y'
            );

            list.forEach(cd => {
                const codeId = cd.codeId ?? cd.detailCodeId ?? cd.code;
                const codeName = cd.codeName ?? cd.detailCodeName ?? cd.name;
                if (!codeId || !codeName) return;

                const opt = document.createElement('option');
                opt.value = codeId;
                opt.textContent = codeName;
                if (codeId === selected) opt.selected = true;
                sel.appendChild(opt);
            });
        } catch (e) {
            console.error(e);
        }
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', async () => {
        const groupId = 'SEARCHTAG';
        const selected = new URLSearchParams(location.search).get('searchType') || 'SC101';
        const sel = document.getElementById('searchSelect');
        const url = '${pageContext.request.contextPath}/codes/' + groupId;

        try {
            const res = await fetch(url, {headers: {'Accept': 'application/json'}});
            if (!res.ok) throw new Error(res.statusText);

            const data = await res.json();

            // 필드명 호환
            const getGroup = (cd) => cd.groupId ?? cd.codeGroupId ?? cd.grpId;
            const getUseYn = (cd) => (cd.useYn ?? cd.use_yn ?? 'Y');
            const getId = (cd) => cd.codeId ?? cd.detailCodeId ?? cd.code ?? cd.id;
            const getName = (cd) => cd.codeName ?? cd.detailCodeName ?? cd.codeNm ?? cd.name ?? cd.code_name;

            const list = (Array.isArray(data) ? data : []).filter(cd =>
                getGroup(cd) === groupId && getUseYn(cd) === 'Y'
            );

            // 옵션 채우기
            sel.innerHTML = ''; // 혹시 모를 잔여 제거
            list.forEach(cd => {
                const val = getId(cd);
                const txt = getName(cd);
                if (!val || !txt) return;
                const opt = document.createElement('option');
                opt.value = val;
                opt.textContent = txt;
                if (val === selected) opt.selected = true;
                sel.appendChild(opt);
            });

            // 아무것도 선택 안됐으면 기본값(SC101) 보정
            if (!sel.value && list.length) {
                const idx = list.findIndex(cd => getId(cd) === 'SC101');
                sel.selectedIndex = idx >= 0 ? idx : 0;
            }
        } catch (err) {
            console.error(err);
        }
    });
</script>

</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>