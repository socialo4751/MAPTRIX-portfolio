<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>개인정보 · 보안</title>


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

        .cardy {
            border: 1px solid #eee;
            border-radius: 14px;
            padding: 18px;
            background: #fff;
            height: 100%;
        }

        .cardy .icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f3f5;
            margin-bottom: 8px;
        }

        .muted {
            color: #6c757d;
        }

        .micro {
            font-size: .86rem;
            color: #6c757d;
        }
    </style>
</head>

<body>
<div class="container">
    <c:set var="activeMenu" value="stamp"/>
    <c:set var="activeSub" value="privacy"/>
    <%@ include file="/WEB-INF/views/include/stSideBar.jsp" %>

    <main class="vstack gap-3">
        <div class="page-header">
            <h2><span class="material-icons" style="font-size:28px;">shield</span> 개인정보 · 보안</h2>
            <p class="mb-0 muted">핵심만 간단히, 자세한 조치는 하단 '자세히'에서 확인하세요.</p>
        </div>

        <section>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="cardy">
                        <div class="icon"><span class="material-icons">fingerprint</span></div>
                        <h6 class="mb-1">최소 수집</h6>
                        <p class="mb-0 muted">리워드 운영에 필요한 위치·기기 정보 중심의 최소 수집</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="cardy">
                        <div class="icon"><span class="material-icons">toggle_on</span></div>
                        <h6 class="mb-1">완전 컨트롤</h6>
                        <p class="mb-0 muted">권한 ON/OFF, 동의 철회, 데이터 삭제 요청 지원</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="cardy">
                        <div class="icon"><span class="material-icons">lock</span></div>
                        <h6 class="mb-1">강화 보안</h6>
                        <p class="mb-0 muted">TLS, 가명화/익명화, 기기 바인딩, 일회용 토큰(JTI/TTL)</p>
                    </div>
                </div>
            </div>
        </section>

        <section>
            <details>
                <summary class="mb-2"><b>자세히 보기</b> <span class="muted">(수집 항목/보유 기간/제3자 제공/위탁 등)</span></summary>
                <div class="micro">
                    <p class="mb-1"><b>수집 항목</b> 위치(위/경도/정확도), 시간, 속도/방향, 가명 기기ID, 미션/체크인 기록.</p>
                    <p class="mb-1"><b>보유</b> 원본 최대 12개월, 분석은 가명·집계로 장기 보관.</p>
                    <p class="mb-1"><b>제공/위탁</b> 원칙적 미제공, 지도/메시지/결제 등 일부 위탁 가능(변경 고지).</p>
                    <p class="mb-1"><b>권리</b> 열람·정정·삭제·이동요청·처리정지·동의철회.</p>
                    <p class="mb-0"><b>연락처</b> privacy@team2.co.kr / 042-632-2222</p>
                </div>
            </details>
        </section>

        <section class="d-flex justify-content-end gap-2 mb-3">
           <%--  <a class="btn btn-outline-secondary" href="<c:url value='/stamp/intro'/>"><span class="material-icons"
                                                                                            style="font-size:18px;vertical-align:-4px;">info</span>
                소개</a> --%>
            <a class="btn btn-primary" href="<c:url value='/attraction/apply-stamp'/>"><span class="material-icons"
                                                                                             style="font-size:18px;vertical-align:-4px;">store</span>
                가맹점 신청</a>
        </section>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
