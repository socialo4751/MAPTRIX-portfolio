<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/style.css">
    <!--

    부트스트랩은 클래스명에 이름을 붙이면 적용이 됩니다.

    예) <div class="card-footer d-flex justify-content-end gap-2 bg-white px-4 py-3">
        └ <div class="card-footer (카드 컴포넌트 기본 클래스) d-flex (Flexbox 컨테이너로 설정)
        justify-content-end(Flexbox 오른쪽으로 정렬) gap-2(간격 2[8px]만큼 넓힘 bg-white(배경색 하얀색으로) px-4 (좌우패딩 24px씩) py-3(상하 패딩 16xp씩)">

        이런식으로 클래스명을 달면 부트스트랩내에 있는 속성들이 적용됩니다.
        어떻게 해야하는지 잘 모르겠으면 지피티또는 최예찬에게 말해주세요.
    -->
</head>


<body>
<div class="content">
    <c:set var="activeMenu" value="notice"/><!-- 사이드바.jsp에 가면 액티브메뉴가 있는데 거기에 있는 밸류로 변경하면 해당 메뉴를 클릭했을때 활성화 됩니다. -->
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>
    <div class="content-wrapper">
        <div class="page-header">
            넣을 게시판 이름 <!-- 여기다 게시판 이름을 넣어주시고 -->
        </div>

        <div class="search-bar">
            <!-- 왼쪽: 총 게시글 수 (동적) -->
            <div class="fw-semibold" style="min-width: 120px; padding-left: 10px;">
                총 게시글 <span class="text-success fw-bold">${fn:length(noticeList)}</span>건
            </div>

            <!-- 오른쪽: 카테고리 + 검색창 (static) -->
            <div class="search-tools">
                <select class="form-select form-select-sm" style="width: 150px;">
                    <option value="">전체</option> <!-- 여기에 카테고리 항목을 option으로 추가해주시면 됩니다. -->
                    <option value="general">일반</option>
                    <option value="tech">이벤트</option>
                    <option value="account">공지</option>
                </select>
                <div class="position-relative flex-grow-1" style="min-width: 0;">
                    <input type="text" class="form-control form-control-sm pe-5" placeholder="검색어를 입력해 주세요">
                    <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                          style="color: #666; cursor: pointer;">
                        search
                    </span>
                </div>
            </div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr class="text-center">
                    <th>번호</th>
                    <th>카테고리</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>작성일</th>
                    <th>조회수</th>
                </tr>
                </thead>
                <tbody class="text-center">
                <c:forEach var="notice" items="${noticeList}" varStatus="status">
                    <tr style="height: 60px;">
                        <td>${fn:length(noticeList) - status.index}</td>
                        <td class="fw-light">[${notice.catCodeId}]</
                        >
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
                    <li class="page-item active"><span class="page-link">1</span></li>
                    <li class="page-item"><a class="page-link" href="#">2</a></li>
                    <li class="page-item"><a class="page-link" href="#">3</a></li>
                    <li class="page-item"><a class="page-link" href="#">다음</a></li>
                    <li class="page-item"><a class="page-link" href="#">맨뒤</a></li>
                </ul>
            </nav>
        </div>

        <!-- 작성하기 버튼 -->
        <div class="d-flex justify-content-end mt-2">
            <a href="${pageContext.request.contextPath}/cs/notice/insert"
               class="btn btn-success btn-sm">작성하기</a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>