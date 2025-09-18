<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:useBean id="now" class="java.util.Date"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지원사업 게시판</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css"/>
    <style>
        .post-card-title {
            font-size: 1.05rem;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .post-card-desc {
            font-size: 0.9rem;
            color: #555;
            height: 3em;
            overflow: hidden;
            text-overflow: ellipsis;
            line-height: 1.5;
        }

        .post-card-footer {
            font-size: 0.85rem;
            color: #777;
        }
        
        .card:hover {
	        transform: translateY(-5px); /* 살짝 위로 움직이는 효과 */
	        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
    	}
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header mb-4">
                    <h2><i class="bi bi-clipboard-data me-2"></i> 지원사업 안내 게시판 관리</h2>
                    <p>지원사업에 관련된 멘토링 및 교육 프로그램을 확인하고 관리할 수 있습니다.</p>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-end flex-wrap mb-4 gap-3">

                <%-- [수정] 폼 action 경로를 /admin/mentoring 으로 변경 --%>
                <form id="searchForm" method="get" action="${pageContext.request.contextPath}/admin/mentoring"
                      class="d-flex flex-wrap align-items-end gap-3">

                    <input type="hidden" name="page" id="currentPage" value="1"/>
                    
                    <div>
                        <label class="form-label mb-1">분류</label>
                        <select class="form-select form-select-sm" name="searchType" >
                            <option value="">전체</option>
                            <c:forEach items="${categoryList}" var="category">
                                 <option value="${category.codeId}" ${searchType eq category.codeId ? 'selected' : ''}>${category.codeName}</option>
                            </c:forEach>
                        </select>
                    </div>

                     <div>
                        <label class="form-label mb-1">접수 상태</label>
                        <select class="form-select form-select-sm" name="statusType">
                            <option value="">전체</option>
                            <c:forEach var="status" items="${statusList}">
                                <option value="${status.codeId}" ${statusType eq status.codeId ? 'selected' : ''}>
                                    ${status.codeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div>
                        <label class="form-label mb-1">키워드</label>
                         <input type="text" name="searchWord" value="${searchWord}"
                               class="form-control form-control-sm" placeholder="제목 또는 내용 검색"/>
                    </div>

                    <div>
                         <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>

                <div>
                    <a href="${pageContext.request.contextPath}/admin/mentoring/form" class="btn btn-success btn-sm">
                        <i class="bi bi-plus-circle me-1"></i> 게시글 등록
                    </a>
                </div>
            </div>


            <div class="row g-4">
                <c:if test="${empty postList}">
                    <div class="col-12 text-center text-muted">등록된 게시물이 없습니다.</div>
                </c:if>
				<c:forEach items="${postList}" var="post">
				    <c:set var="isClosed" value="${post.deadline.time < now.time}"/>
				    <div class="col-md-4">
				        <a href="${pageContext.request.contextPath}/admin/mentoring/${post.postId}" 
				           class="card h-100 text-decoration-none text-dark">
								<c:choose>
								  <c:when test="${not empty post.thumbnailPath}">
								    <div style="position:relative;width:100%;height:200px;overflow:hidden;background:#f8f9fa;border-bottom:1px solid #eee;">
								      <img
								        src="${pageContext.request.contextPath}${post.thumbnailPath}"
								        alt="${fn:escapeXml(post.title)}"
								        style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:top center;display:block;"
								      />
								    </div>
								  </c:when>
								  <c:otherwise>
								    <div style="position:relative;width:100%;height:200px;overflow:hidden;background:#f8f9fa;border-bottom:1px solid #eee;">
								      <img
								        src="${pageContext.request.contextPath}/images/startup/mentoring/mentoring_default.png"
								        alt="기본 이미지"
								        style="position:absolute;inset:0;width:100%;height:100%;object-fit:cover;object-position:top center;display:block;"
								      />
								    </div>
								  </c:otherwise>
								</c:choose>
				            <div class="card-body">
				                <div class="post-card-title">${post.title}</div>
				                <div class="post-card-desc">${fn:substring(post.content, 0, 100)}...</div>
				            </div>
				            <div class="card-footer d-flex justify-content-between align-items-center">
				                <div class="post-card-footer">
				                    <strong>${post.catCodeId}</strong><br/>
				                    <fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/>
				                </div>
				                <span class="btn btn-sm ${isClosed ? 'btn-secondary' : 'btn-success'}">
				                    ${isClosed ? '마감' : '접수 중'}
				                </span>
				            </div>
				        </a>
				    </div>
				</c:forEach>
            </div>

            <div class="pagination-container mt-4">
                <%-- 페이징 HTML이 ArticlePage 유틸리티 클래스에서 생성된다고 가정 --%>
                <%-- <c:out value="${articlePage.pagingArea}" escapeXml="false"/> --%>
                
                <%-- 임시 페이징 (컨트롤러 로직에 맞춰 수정 필요) --%>
                <nav>
                    <ul class="pagination justify-content-center">
                        <c:if test="${startPage > 1}">
                            <li class="page-item"><a class="page-link" href="javascript:changePage(${startPage - 1});">이전</a></li>
                        </c:if>
                        <c:forEach var="i" begin="${startPage}" end="${endPage}">
                            <li class="page-item ${i eq currentPage ? 'active' : ''}">
                                <a class="page-link" href="javascript:changePage(${i});">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${endPage < totalPage}">
                            <li class="page-item"><a class="page-link" href="javascript:changePage(${endPage + 1});">다음</a></li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<script>
    // 페이징 링크 클릭 시 폼 제출하는 함수
    function changePage(page) {
        document.getElementById('searchForm').querySelector('input[name="page"]').value = page;
        document.getElementById('searchForm').submit();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('searchForm');
        
        // 검색 버튼(submit) 클릭 시, 1페이지로 초기화 (폼 자체에 hidden input으로 구현되어 있어 중복될 수 있으나 안전장치로 둠)
        form.addEventListener('submit', function () {
            this.querySelector('input[name="page"]').value = 1;
        });
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>