<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>스템프 가맹 신청 현황</title>
    <%-- 필요한 CSS, JS 라이브러리 링크 --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypagestyle.css"/> <%-- 마이페이지 공통 스타일 --%>
    
    <!-- 프로젝트 공통 헤더 -->
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    
    <style>
        .api-card { border: 1px solid #e9ecef; border-radius: 10px; background-color: #fff; box-shadow: 0 2px 8px rgba(0,0,0,.04); overflow: hidden; margin-bottom: 18px; }
        .api-card-header { background-color: #f8f9fa; padding: 14px 18px; display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #edf1f5; }
        .api-title { font-size: 1.05rem; font-weight: 700; margin: 0; }
        .api-card-body { padding: 16px 18px; }
        .empty-state { background: #fff; border: 1px dashed #d0d7de; border-radius: 12px; padding: 42px 16px; text-align: center; color: #6b7280; }
        
        /* 처리 상태에 따른 뱃지 스타일 */
        .status-badge { padding: .3em .6em; font-size: .85em; font-weight: 700; border-radius: .25rem; }
        .status-APPROVED, .status-접수완료 { background-color: #d1e7dd; color: #0f5132; } /* 승인 */
        .status-REJECTED { background-color: #f8d7da; color: #842029; } /* 반려 */
        .status-WAITING, .status-처리중 { background-color: #fff3cd; color: #664d03; } /* 대기 */
    </style>
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="apply"/>
    <c:set var="activeSub" value="stampbiz"/>
    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>

    <main>
        <div class="mypage-header">
            <h2>스탬프 가맹 신청 현황</h2>
            <p>가맹 신청 내역의 처리 상태(승인, 반려)를 확인하세요.</p>
        </div>

        <div class="card-container">
            <c:choose>
                <c:when test="${not empty myApplyList}">
                    <c:forEach items="${myApplyList}" var="apply">
                        <section class="api-card">
                            <div class="api-card-header">
                                <h3 class="api-title"><c:out value="${apply.applyStoreName}"/></h3>
                                <div>
                                    <%-- DB에 저장된 status 값(예: 처리중, 접수완료)에 따라 동적으로 스타일 적용 --%>
                                    <span class="status-badge status-${apply.status}">
                                        <c:out value="${apply.status}"/>
                                    </span>
                                </div>
                            </div>
                            <div class="api-card-body">
                                <div class="row g-3">
                                    <div class="col-12 col-md-6">
                                        <label class="form-label mb-1">신청일</label>
                                        <div class="form-control" style="background:#f8fafc;">
                                            ${apply.applicatedAt}
                                        </div>
                                    </div>
                                    <div class="col-12 col-md-6">
                                        <label class="form-label mb-1">처리일</label>
                                        <div class="form-control" style="background:#f8fafc;">
                                            <c:out value="${not empty apply.acceptAt ? apply.acceptAt : '처리 대기중'}" />
                                        </div>
                                    </div>
                                    <c:if test="${not empty apply.memo}">
                                        <div class="col-12">
                                            <label class="form-label mb-1">담당자 메모</label>
                                            <div class="form-control" style="background:#f8fafc;">
                                                <c:out value="${apply.memo}"/>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </section>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p class="mb-3">신청하신 내역이 없습니다.</p>
                        <a href="${pageContext.request.contextPath}/attraction/apply-stamp" class="btn btn-primary">가맹점 신청하기</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>