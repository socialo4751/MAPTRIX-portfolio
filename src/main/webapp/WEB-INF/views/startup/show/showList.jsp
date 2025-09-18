<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자랑 게시판</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>

    <!-- Swiper -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"/>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>

    <jsp:include page="/WEB-INF/views/include/top.jsp"/>
    <style>
    /* 이 페이지에서만 적용 */
    .myshop-showlist .page-header {
        display: flex; /* 가운데 배치용 */
        flex-direction: column;
        align-items: center; /* 수평 가운데 */
        text-align: center; /* 텍스트 가운데 */
    }

    .myshop-showlist .page-header h2 {
        margin: 0 0 10px 0; /* 필요 시 여백 정리 */
    }

    .myshop-showlist .page-header p {
        margin: 0; /* 부제목 여백 정리 */
    }

    /* 혹시 부트스트랩 유틸로 좌우 정렬된 경우 강제 해제 */
    .myshop-showlist .page-header.d-flex {
        justify-content: center !important;
        gap: .5rem;
    }
    
    /* 목록 카드 썸네일 높이 조정 */
	.mt-thumb{
	  width: 100%;
	  height: 240px !important; 
	  object-fit: cover;
	  display: block;
	  /* 모서리 둥글게(카드와 자연스럽게) */
	  border-top-left-radius: .5rem;
	  border-top-right-radius: .5rem;
	}
	

</style>
</head>
<body>
<div class="container">
    <main class="flex-grow-1">
        <div class="page-container myshop-showlist">
            <div class="page-header">
                <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                    내 가게 만들기
                </h2>
            </div>
            <div class="title-info"
                 style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
                <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                    <p class="mb-0">시뮬레이터로 나만의 가게를 디자인하고 다른 사람들과 공유할 수 있는 공간입니다.</p>
                </div>
            </div>
        </div>
        <!-- 섹션 타이틀 -->
        <h3 class="mb-3" style="font-family:'GongGothicMedium',sans-serif;">
            <i class="fas fa-crown text-warning"></i> 이번 달 BEST 게시물!
        </h3>

        <!-- 상단: BEST 배너 + 우측 액션 패널 -->
        <div class="mb-4">
            <div class="row align-items-stretch mx-0 gy-4 gx-0">

                <!-- 좌: 배너 (왼쪽만 0, 오른쪽은 간격) -->
                <div class="col-lg-8 ps-lg-0 pe-lg-3">
                    <c:if test="${not empty bestPosts}">
                        <div class="card border-0 rounded-3 overflow-hidden custom-shadow">
                            <div class="position-relative" style="height:400px;">
                                <div class="swiper main-banner-slider position-absolute top-0 bottom-0 start-0 end-0">
                                    <div class="swiper-wrapper">
                                        <c:forEach items="${bestPosts}" var="best">
                                            <div class="swiper-slide position-relative">
                                                <a href="<c:url value='/start-up/show/detail/${best.postId}'/>"
                                                   class="d-block w-100 h-100">
                                                    <c:choose>
                                                        <c:when test="${not empty best.thumbnailPath}">
                                                            <img src="<c:url value='${best.thumbnailPath}'/>"
                                                                 alt="${best.title}" class="w-100 h-100"
                                                                 style="object-fit:cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <img src="https://placehold.co/1200x600/eee/333?text=Image"
                                                                 alt="기본 이미지" class="w-100 h-100"
                                                                 style="object-fit:cover;">
                                                        </c:otherwise>
                                                    </c:choose>

                                                    <!-- 하단 오버레이 -->
                                                    <div class="position-absolute bottom-0 start-0 end-0 p-4"
                                                         style="background:linear-gradient(180deg,rgba(0,0,0,0) 0%,rgba(0,0,0,.65) 100%);">
                                                        <h2 class="h4 fw-bold text-white mb-1 text-truncate">${best.title}</h2>
                                                        <p class="text-white-50 mb-0 small">${best.userId}</p>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="swiper-pagination"></div>
                                    <div class="swiper-button-prev"></div>
                                    <div class="swiper-button-next"></div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- 우: 버튼 묶음 (오른쪽만 0, 왼쪽은 간격) -->
                <div class="col-lg-4 pe-lg-0 ps-lg-3 d-flex">
                    <div class="d-flex flex-column w-100 h-100 justify-content-between">
						<a href="<c:url value='/start-up/design/go-to-simulator'/>"
						   target="_blank"
						   class="card border-1 custom-shadow text-decoration-none text-reset rounded-3">
						    <div class="card-body d-flex align-items-center gap-3 p-4" style="min-height:110px;">
						        <i class="fas fa-arrow-right fs-5"></i>
						        <div class="fw-semibold">도면 시뮬레이터 하러가기</div>
						    </div>
						</a>

                        <a href="/start-up/design/myDesignPage"
                           class="card border-1 custom-shadow text-decoration-none text-reset rounded-3">
                            <div class="card-body d-flex align-items-center gap-3 p-4" style="min-height:110px;">
                                <i class="fas fa-folder-open fs-5"></i>
                                <div class="fw-semibold">나의 도면 라이브러리가기</div>
                            </div>
                        </a>

                        <a href="<c:url value='/start-up/show/insert'/>"
                           class="card border-1 custom-shadow text-decoration-none text-reset rounded-3">
                            <div class="card-body d-flex align-items-center gap-3 p-4" style="min-height:110px;">
                                <i class="fas fa-pencil-alt fs-5"></i>
                                <div class="fw-semibold">게시물 등록하기</div>
                            </div>
                        </a>
                    </div>
                </div>

            </div>
        </div>

        <!-- ===== 목록/검색 보조 변수 ===== -->
        <c:set var="posts"
               value="${not empty postList ? postList : (not empty ap ? ap.list : null)}"/>
        <c:set var="totalCount"
               value="${not empty totalRecord ? totalRecord : (not empty articlePage.total ? articlePage.total : articlePage.totalRecord)}"/>
        <c:set var="kw" value="${not empty param.searchWord ? param.searchWord : param.keyword}"/>
        <%-- 키워드 원본 --%>
        <c:set var="rawKw" value="${param.keyword}"/>
        <%-- null 이면 빈 문자열로 --%>
        <c:set var="kw" value="${empty rawKw ? '' : rawKw}"/>
        <%-- 필요하면 트림 --%>
        <c:set var="kwTrim" value="${fn:trim(kw)}"/>

        <%-- 검색을 시도했는지 여부 --%>
        <c:set var="searched" value="${not empty kwTrim or not empty param.searchType}"/>


        <!-- 목록 상단: 전체 건수 + 검색 -->
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 py-2 mb-3">
            <div class="fw-semibold" style="min-width:120px; padding-left:10px;">
                총 게시글 <span class="text-dark fw-bold">${totalCount}</span>건
            </div>

            <form id="searchForm"
                  class="d-flex align-items-center flex-wrap gap-2 justify-content-end"
                  method="get"
                  action="<c:url value='/start-up/show'/>">
                <input type="hidden" name="currentPage" value="1"/>

                <!-- 검색 옵션: 제목+내용 / 제목 / 내용 / 해시태그 -->
                <select name="searchType" class="form-select form-select-sm" style="width:120px;">
                    <option value="title_content" ${param.searchType == 'title_content' ? 'selected' : ''}>제목+내용
                    </option>
                    <option value="title"         ${param.searchType == 'title'         ? 'selected' : ''}>제목</option>
                    <option value="content"       ${param.searchType == 'content'       ? 'selected' : ''}>내용</option>
                    <option value="hashtag"       ${param.searchType == 'hashtag'       ? 'selected' : ''}>해시태그</option>
                </select>

                <!-- 키워드: name=keyword 로 변경 -->
                <div class="position-relative flex-grow-1" style="min-width:0;">
                    <input type="text"
                           name="keyword"
                           value="${fn:escapeXml(param.keyword)}"
                           class="form-control form-control-sm pe-5"
                           placeholder="키워드를 입력해 주세요"/>
                    <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                          style="color:#666; cursor:pointer;"
                          onclick="document.getElementById('searchForm').submit()">search</span>
                </div>
            </form>

        </div>

        <!-- 카드 그리드: 3열 유지 + 바깥쪽 패딩 제거 -->
        <div class="row mx-0 row-cols-1 row-cols-md-2 row-cols-lg-3 gy-4 gx-3">
            <c:if test="${empty posts}">
                <div class="col-12">
                    <!-- d-flex로 가로·세로 중앙정렬, min-height로 적당한 높이 확보 -->
                    <div class="d-flex align-items-center justify-content-center border rounded-3 bg-white"
                         style="min-height: 260px;">
                        <div class="text-center py-4">
                            <i class="bi bi-search fs-1 text-muted d-block mb-2"></i>
                            <c:choose>
                                <c:when test="${searched}">
                                    <div class="fw-semibold fs-5 mb-1">검색결과가 없습니다.</div>
                                    <div class="text-muted small">다른 키워드로 다시 검색해 보세요.</div>
                                </c:when>
                                <c:otherwise>
                                    <div class="fw-semibold fs-5 mb-1">등록된 게시물이 없습니다.</div>
                                    <div class="text-muted small">첫 게시물을 등록해 보세요.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:if>


            <c:forEach items="${posts}" var="post" varStatus="st">
                <c:set var="edgeClass"
                       value="${st.index % 3 == 0 ? 'ps-lg-0' : (st.index % 3 == 2 ? 'pe-lg-0' : '')}"/>

                <div class="col ${edgeClass}">
                    <a href="<c:url value='/start-up/show/detail/${post.postId}'/>"
                       class="card h-100 text-decoration-none text-reset border-1 custom-shadow mt-card rounded-3">
                        <c:choose>
                            <c:when test="${not empty post.thumbnailPath}">
                                <c:url var="imgUrl" value="${post.thumbnailPath}"/>
                            </c:when>
                            <c:otherwise>
                                <c:url var="imgUrl" value="/images/default_thumbnail.png"/>
                            </c:otherwise>
                        </c:choose>
                        <img src="${imgUrl}" alt="${post.title}" class="mt-thumb"
                             onerror="this.onerror=null;this.src='<c:url value="/images/default_thumbnail.png"/>';">
                        <div class="card-body d-flex flex-column p-3">
                            <h3 class="card-title h6 fw-bold mb-2">${post.title}</h3>
                            <div class="mb-3 d-flex flex-wrap gap-1">
                                <c:forEach items="${fn:split(post.hashtags, ',')}" var="tag">
                                    <span class="badge rounded-pill text-bg-beige"
                                          style="padding: 7px;">#${fn:trim(tag)}</span>
                                </c:forEach>
                            </div>
                            <p class="mt-auto text-muted small mb-0">
                                <span class="me-3"><i class="fas fa-heart me-1"></i>${post.likeCount}</span>
                                <span><i class="fas fa-eye me-1"></i>${post.viewCount}</span>
                            </p>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <div class="pagination-container mt-4 d-flex justify-content-center">
            <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        if (document.querySelector('.main-banner-slider')) {
            const swiper = new Swiper('.main-banner-slider', {
                loop: true,
                autoplay: {delay: 4000, disableOnInteraction: false},
                pagination: {el: '.swiper-pagination', clickable: true},
                navigation: {nextEl: '.swiper-button-next', prevEl: '.swiper-button-prev'},
                effect: 'fade',
                fadeEffect: {crossFade: true}
            });
        }
    });
</script>
</body>
</html>
