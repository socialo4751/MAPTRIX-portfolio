<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>오픈 API 서비스 목록</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/csstyle.css">
    <style>
        .page-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 6px 0 12px 0;
        }

        .page-header p {
            margin: 0;
            color: #6c757d;
        }

        .search-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 12px;
            border: 1px solid #eee;
            border-radius: 8px;
            background: #fafafa;
            margin: 12px 0 18px 0;
        }

        .api-link {
            text-decoration: none;
            color: inherit;
        }

        .api-link:hover {
            text-decoration: underline;
        }

        .badge-cat {
            font-weight: 500;
        }
    </style>
</head>

<!-- ...head 동일... -->

<body>
<div class="container">
    <c:set var="activeMenu" value="openapi"/>
    <c:set var="activeSub" value="list"/>
    <%@ include file="/WEB-INF/views/include/openapiSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2><span class="material-icons" style="font-size: 28px;">api</span>서비스 목록</h2>
        </div>

        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:18px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
                <span class="material-icons me-2"
                      style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right:8px;">notifications</span>
                <p class="mb-0">제공 중인 API 목록을 확인하고 원하는 API 서비스를 신청할 수 있습니다.</p>
            </div>
        </div>

        <div class="search-bar">
            <div class="fw-semibold" style="min-width: 120px; padding-left: 4px;">
                총 서비스 <span class="text-dark-blue fw-bold"><c:out value="${fn:length(apiList)}"/></span>건
            </div>
            <div class="d-flex align-items-center gap-2"><!-- 필터/검색 배치 자리 --></div>
        </div>

        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr class="text-center">
                    <th style="width:100px;">카테고리</th>
                    <th>API 이름</th>
                    <th style="width:55%;">주요 설명</th>
                    <th style="width:140px;">신청</th> <!-- ✅ 추가 -->
                </tr>
                </thead>
                <tbody class="text-center">
                <c:choose>
                    <c:when test="${not empty apiList}">
                        <c:forEach items="${apiList}" var="api">
                            <tr style="height:60px;">
                                <td>
                                    <span class="badge text-bg-light badge-cat"><c:out value="${api.apiCategory}"/></span>
                                </td>
                                <td class="text-start">
                                    <a class="api-link"
                                       href="<c:url value='/openapi/detail'/>?apiId=${api.apiId}">
                                        <c:out value="${api.apiNameKr}"/>
                                    </a>
                                </td>
                                <td class="text-start"><c:out value="${api.apiDesc}"/></td>

                                <!-- ✅ ‘신청하기’도 상세 페이지로 이동 -->
                                <td>
                                    <a class="btn btn-outline-primary btn-sm"
                                       href="<c:url value='/openapi/detail'/>?apiId=${api.apiId}">
                                       <!-- 필요 시 끝에 #apply 또는 &mode=apply 추가 -->
                                       신청하기
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr style="height:60px;">
                            <td colspan="4" class="text-center fw-light">현재 제공 중인 API 서비스가 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <c:if test="${not empty pagingArea}">
            <div class="d-flex justify-content-center mt-4">
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <c:out value="${pagingArea}" escapeXml="false"/>
                    </ul>
                </nav>
            </div>
        </c:if>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
