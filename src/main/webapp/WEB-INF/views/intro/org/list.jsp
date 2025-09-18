<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="/css/introstyle.css">
    <title>직원 안내</title>
</head>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>

<div class="container">
    <c:set var="activeMenu" value="orgGuide"/>
    <c:set var="activeSub" value="org"/>
    <%@ include file="/WEB-INF/views/include/introSideBar.jsp" %>
    <main>
        <div class="page-header">
            <h2 style="display:flex;align-items:center;gap:8px;position:relative;">직원 안내</h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">각 부서와 담당 직원을 확인하실 수 있습니다.</p>
            </div>
        </div>

        <!-- (1) 폴백 변수: articlePage가 있으면 그걸, 없으면 empList 사용 -->
        <c:choose>
            <c:when test="${not empty articlePage}">
                <c:set var="totalCount" value="${articlePage.total}"/>
                <c:set var="empItems" value="${articlePage.content}"/>
            </c:when>
            <c:otherwise>
                <c:set var="totalCount" value="${fn:length(empList)}"/>
                <c:set var="empItems" value="${empList}"/>
            </c:otherwise>
        </c:choose>

        <!-- 검색 폼 -->
        <form method="get" action="${pageContext.request.contextPath}/intro/org"
              class="search-bar d-flex align-items-center mb-4">

            <div class="fw-semibold" style="min-width:120px;padding-left:10px;">
                직원 수 : <span class="text-dark-blue fw-bold">${totalCount}</span>명
            </div>

            <div class="search-tools d-flex align-items-center gap-2">
                <!-- 부서 -->
                <select name="catCodeId" class="form-select form-select-sm" style="width:160px;">
                    <option value="">전체 부서</option>
                    <c:forEach var="cd" items="${codeDetails}">
                        <option value="${cd.codeId}" <c:if test="${param.catCodeId == cd.codeId}">selected</c:if>>
                                ${cd.codeName}
                        </option>
                    </c:forEach>
                </select>

                <!-- 키워드 -->
                <div class="position-relative flex-grow-1" style="min-width:240px;">
                    <input type="text" name="keyword" value="${fn:escapeXml(param.keyword)}"
                           class="form-control form-control-sm pe-5" placeholder="이름/이메일/부서/직책">
                    <span class="material-icons position-absolute top-50 end-0 translate-middle-y me-2"
                          style="color:#666;cursor:pointer;" onclick="this.closest('form').submit()">search</span>
                </div>
            </div>
        </form>

        <!-- 목록 -->
        <div class="row g-4">
            <c:forEach var="emp" items="${empItems}">
                <div class="col-12 col-md-6">
                    <div class="card p-3 h-100 border border-1 border-light-subtle custom-shadow">
                        <div class="row g-0 align-items-center">
                            <!-- 이미지 -->
                            <div class="col-auto">
                                <c:choose>
                                    <c:when test="${not empty emp.empImage}">
                                        <img src="${pageContext.request.contextPath}/upload/${emp.empImage}"
                                             class="img-fluid rounded" style="width:100px;height:100px;" alt="프로필"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="bg-secondary text-white rounded d-flex align-items-center justify-content-center"
                                             style="width:100px;height:130px;">No Image
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- 텍스트 -->
                            <div class="col ps-3">
                                <div class="text-dark-blue fw-semibold mb-1">${emp.empPosition}</div>
                                <h5 class="mb-1" style="font-size:25px;"><strong>${emp.empName}</strong></h5>
                                <hr class="my-2"/>
                                <p class="mb-1"><strong>부서:</strong> ${emp.deptName}</p>
                                <p class="mb-1"><strong>이메일:</strong> ${emp.email}</p>
                                <p class="mb-0"><strong>내선:</strong> ${emp.empExt}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty empItems}">
                <div class="col-12 text-center text-muted py-5">검색 결과가 없습니다.</div>
            </c:if>
        </div>

        <!-- (3) 페이징: ArticlePage가 이미 nav/ul을 포함하는 경우가 많으니 래퍼 없이 출력 -->
        <c:if test="${not empty articlePage}">
            <div class="d-flex justify-content-center mt-4">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>
        </c:if>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
