<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>오픈 API 서비스 관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Admin common style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css"/>

    <style>
        .admin-header h2 {
            font-weight: 800;
        }

        .admin-header p {
            margin: 0;
            color: #6c757d;
        }

        .table thead th {
            background-color: #f8f9fa;
        }

        .pagination-container {
            margin-top: 20px;
            padding-top: 10px;
            border-top: 1px solid #eee;
        }

        .text-ellipsis {
            max-width: 520px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            display: inline-block;
            vertical-align: bottom;
        }

        .cat-badge {
            background: #e9f5ff;
            color: #0d6efd;
            border: 1px solid #cfe7ff;
            font-weight: 600;
        }

        .type-badge {
            background: #f4f4f6;
            color: #6c757d;
            border: 1px solid #e4e6ea;
            font-weight: 600;
        }

        .table td:nth-child(1),
        .table td:nth-child(2),
        .table td:nth-child(3),
        .table td:nth-child(5) {
            text-align: center;
        }
        table thead th {
            text-align: center;
            vertical-align: middle;
        }
        .badge{
            font-size: 15px !important;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>

<body>


<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <!-- 타이틀 -->
            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header">
                    <h2 class="mb-1"><i class="bi bi-diagram-3 me-2 text-primary"></i>API 등록 및 삭제</h2>
                    <p>플랫폼에서 제공하는 API 서비스의 목록을 관리합니다.</p>
                </div>
                <div>
                    <a class="btn btn-success btn-sm fw-semibold"
                       href="${pageContext.request.contextPath}/admin/openapi/services/form">
                        <i class="bi bi-plus-circle me-1"></i> 신규 서비스 등록
                    </a>
                </div>
            </div>

            <!-- 검색 영역 -->
            <div class="d-flex justify-content-between align-items-end flex-wrap mb-4">
                <form name="searchForm"
                      class="d-flex flex-wrap gap-2 align-items-end ms-auto"
                      method="get"
                      action="${pageContext.request.contextPath}/admin/openapi/services">
                    <div>
                        <label class="form-label mb-1">카테고리</label>
                        <select name="catCodeId" class="form-select form-select-sm" style="min-width:200px;">
                            <option value="" ${empty param.catCodeId ? 'selected' : ''}>전체 카테고리</option>
                            <c:forEach items="${apiCateList}" var="cate">
                                <option value="${cate.codeId}" ${param.catCodeId == cate.codeId ? 'selected' : ''}>${cate.codeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="form-label mb-1">검색어</label>
                        <input type="text" name="keyword"
                               value="${param.keyword != null ? param.keyword : articlePage.keyword}"
                               class="form-control form-control-sm" placeholder="API 이름으로 검색" style="min-width:240px;">
                    </div>
                    <div>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>
            </div>

            <!-- 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle table-bordered text-center">
                    <thead class="table-light">
                    <tr>
                        <th style="width: 110px;">API ID</th>
                        <th style="width: 200px;">카테고리</th>
                        <th style="width: 200px;">서비스 타입</th>
                        <th>API 이름</th>
                        <th style="width: 120px;">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty articlePage.content}">
                            <c:forEach items="${articlePage.content}" var="svc">
                                <tr>
                                    <td>${svc.apiId}</td>

                                    <!-- 카테고리명 매핑 (없으면 코드 그대로) -->
                                    <td>
                                        <c:set var="catName" value="${svc.apiCategory}"/>
                                        <c:if test="${not empty apiCateList}">
                                            <c:forEach items="${apiCateList}" var="cate">
                                                <c:if test="${cate.codeId == svc.apiCategory}">
                                                    <c:set var="catName" value="${cate.codeName}"/>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        <span class="badge cat-badge rounded-pill px-3 py-2">${catName}</span>
                                    </td>

                                    <!-- 서비스 타입명 매핑 (없으면 코드 그대로) -->
                                    <td>
                                        <c:set var="typeName" value="${svc.serviceType}"/>
                                        <c:if test="${not empty apiTypeList}">
                                            <c:forEach items="${apiTypeList}" var="type">
                                                <c:if test="${type.codeId == svc.serviceType}">
                                                    <c:set var="typeName" value="${type.codeName}"/>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                        <span class="badge type-badge rounded-pill px-3 py-2">${typeName}</span>
                                    </td>

                                    <td class="text-start">
                                        <a class="link-dark text-decoration-none fw-semibold text-ellipsis"
                                           title="${svc.apiNameKr}"
                                           href="${pageContext.request.contextPath}/admin/openapi/services/form?apiId=${svc.apiId}">
                                                ${svc.apiNameKr}
                                        </a>
                                    </td>

                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="${pageContext.request.contextPath}/admin/openapi/services/form?apiId=${svc.apiId}"
                                               class="btn btn-outline-primary">수정</a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="py-5">
                                    <c:choose>
                                        <c:when test="${not empty param.keyword or not empty param.catCodeId}">
                                            <span class="text-muted">검색 결과가 없습니다.</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">등록된 API 서비스가 없습니다.</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination-container text-center">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>

        </div><!-- /.main-container -->
    </div><!-- /#content -->
</div><!-- /#wrapper -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
