<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>설문 목록</title>
    <!-- Bootstrap, top.jsp 포함 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">
    <style>
        .survey-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            background-color: #fff;
            text-decoration: none;
            transition: box-shadow 0.3s ease, transform 0.2s ease;

            /* 기본 그림자 */
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        }

        .survey-card:hover {
            /* 강조된 그림자 */
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            transform: translateY(-4px);
        }


        .survey-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #212529;
        }

        .survey-description {
            font-size: 0.95rem;
            color: #6c757d;
        }

        .survey-badge {
            font-size: 0.85rem;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .survey-card,
        .survey-card:hover,
        .survey-card:focus,
        .survey-card:active,
        .survey-card:visited {
            text-decoration: none !important;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 활성 메뉴 지정 -->
    <c:set var="activeMenu" value="survey"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <!-- 페이지 헤더 -->
        <div class="page-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                설문 조사
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:45px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">여러분의 소중한 의견이 서비스 개선에 큰 힘이 됩니다.</p>
            </div>
        </div>

        <div class="w-100" style="margin-top: -15px;">
            <c:choose>
                <c:when test="${empty surveyList}">
                    <div class="alert alert-info mt-3">등록된 설문이 없습니다.</div>
                </c:when>
                <c:otherwise>
                    <div class="row">
                        <c:forEach var="sv" items="${surveyList}">
                            <div class="col-12">

                                <c:choose>
                                    <c:when test="${!loggedIn}">
                                        <c:url var="detailUrl" value="/cs/survey/detail">
                                            <c:param name="surveyId" value="${sv.surveyId}"/>
                                        </c:url>

                                        <div class="survey-card d-flex justify-content-between align-items-start bg-light text-muted">
                                            <div>
                                                <div class="survey-title">${sv.surveyTitle}</div>
                                                <div class="survey-description">${sv.surveyDescription}</div>
                                            </div>
                                            <a class="btn btn-sm btn-outline-warning survey-badge"
                                               href="${pageContext.request.contextPath}/login?redirect=${pageContext.request.contextPath}${detailUrl}">
                                                로그인 필요
                                            </a>
                                        </div>
                                    </c:when>

                                    <c:otherwise>

                                        <c:url var="detailUrl" value="/cs/survey/detail">
                                            <c:param name="surveyId" value="${sv.surveyId}"/>
                                            <c:if test="${sv.participated}">
                                                <c:param name="readonly" value="true"/>
                                            </c:if>
                                        </c:url>

                                        <a href="${pageContext.request.contextPath}${detailUrl}"
                                           class="survey-card d-flex justify-content-between align-items-start
                  ${sv.participated ? 'bg-light text-muted' : ''}">
                                            <div>
                                                <div class="survey-title">${sv.surveyTitle}</div>
                                                <div class="survey-description">${sv.surveyDescription}</div>
                                            </div>

                                            <c:choose>
                                                <c:when test="${sv.participated}">
                                                    <span class="survey-badge bg-secondary text-white">참여완료</span>
                                                </c:when>
                                                <c:when test="${sv.useYn == 'Y'}">
                                                    <span class="survey-badge bg-primary text-white">참여하기</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="survey-badge bg-dark text-white">비활성</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </c:forEach>

                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<!-- Bootstrap JS, footer 포함 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
