// WEB-INF/views/openapi/apiApplyComplete.jsp (새 파일)

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>API 서비스 신청 완료</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">
    <style>
        .completion-box {
            background-color: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 48px 24px;
            text-align: center;
            margin-top: 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,.05);
        }
        .completion-box .icon {
            font-size: 60px;
            color: #198754; /* 부트스트랩 'success' 색상 */
        }
        .completion-box h2 {
            font-size: 1.5rem;
            font-weight: 600;
            margin-top: 16px;
        }
        .completion-box p {
            color: #6c757d;
            margin-top: 8px;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="openapi"/>
    <c:set var="activeSub" value="list"/>
    <%@ include file="/WEB-INF/views/include/openapiSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2>API 서비스 신청 완료</h2>
        </div>

        <div class="completion-box">
            <span class="material-icons icon">check_circle</span>
            <h2>'<c:out value="${apiNameKr}"/>' 서비스 신청이 완료되었습니다.</h2>
            <p>관리자 승인 후 API Key가 발급됩니다. 처리 현황은 '나의 API 현황'에서 확인하실 수 있습니다.</p>
            <div>
                <a href="<c:url value='/my/openapi/status'/>" class="btn btn-primary btn-lg">
                    OPEN API 신청현황 조회
                </a>
                <a href="<c:url value='/openapi'/>" class="btn btn-outline-secondary btn-lg">
                    다른 API 둘러보기
                </a>
            </div>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>