<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>오픈 API 소개</title>
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

        .lead {
            color: #6c757d;
        }

        .feature-item {
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 16px;
            background: #fff;
            height: 100%;
        }
    </style>
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="openapi"/>
    <c:set var="activeSub" value="intro"/>
    <%@ include file="/WEB-INF/views/include/openapiSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2><span class="material-icons" style="font-size:28px;">api</span>서비스 소개</h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:45px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">상권분석 플랫폼이 제공하는 API를 통해 외부 서비스에서 다양한 데이터와 기능을 활용할 수 있습니다.</p>
            </div>
        </div>

        <section class="mb-4">
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="feature-item">
                        <h5 class="mb-2"><i class="material-icons"
                                            style="font-size:20px;vertical-align:-4px;">verified</i> 인증</h5>
                        <p class="mb-0">API Key 기반 인증(예정), 요청 빈도 제한 및 로그 모니터링을 통해 안정적으로 운영됩니다.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="feature-item">
                        <h5 class="mb-2"><i class="material-icons"
                                            style="font-size:20px;vertical-align:-4px;">dataset</i> 데이터</h5>
                        <p class="mb-0">상권, 매출, 인구, 업종 분류 등의 지표를 REST/JSON 형태로 제공합니다.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="feature-item">
                        <h5 class="mb-2"><i class="material-icons" style="font-size:20px;vertical-align:-4px;">code</i>
                            사용성</h5>
                        <p class="mb-0">직관적인 엔드포인트와 일관된 응답 포맷으로 빠르게 연동할 수 있습니다.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="feature-item">
                        <h5 class="mb-2"><i class="material-icons" style="font-size:20px;vertical-align:-4px;">support_agent</i>
                            지원</h5>
                        <p class="mb-0">버전 관리, 공지/변경 이력, 샘플 코드, FAQ 문서를 순차적으로 제공할 예정입니다.</p>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <h5 class="mb-2">빠른 시작</h5>
            <ol class="mb-0">
                <li>오픈 API 목록에서 원하는 API를 선택합니다.</li>
                <li>상세 페이지의 호출 예시와 파라미터 설명을 참고하여 연동합니다.</li>
                <li>요청 제한 및 에러 코드를 확인해 안전하게 사용합니다.</li>
            </ol>
        </section>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
