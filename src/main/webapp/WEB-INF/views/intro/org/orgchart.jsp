<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>직원 안내</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!-- 프로젝트 공통 스타일 (틀) -->
    <link rel="stylesheet" href="/css/introstyle.css">

    <style>
        /* ================== Scoped OrgChart ================== */
        .org-scope {
            max-width: 1200px;
            margin: 40px auto;
            padding: 16px;
            background: #fff;
        }

        .org-scope * {
            box-sizing: border-box;
        }

        .org-title {
            font-family: 'GongGothicMedium', system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", sans-serif;
            margin: 8px 0 2px;
            font-size: 28px;
            color: #2c3e50;
        }

        .org-subtitle {
            margin: 0 0 24px;
            color: #7f8c8d;
            font-size: 14px;
        }

        /* 카드 공통 */
        .org-card {
            background: #ffffff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 14px 16px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, .04);
        }

        .org-card .label {
            font-weight: 700;
            color: #041a2f;
            font-size: 15px;
            margin-bottom: 4px;
        }

        .org-card .en {
            font-size: 12px;
            color: #6c757d;
        }

        /* 최상단: CEO + 감사위원회(독립) */
        .org-top {
            display: grid;
            grid-template-columns: 1fr;
            gap: 12px;
            align-items: start;
            justify-items: center;
            position: relative;
        }

        .org-top .ceo {
            text-align: center;
            border-left: 4px solid #0a3d62;
        }

        .org-top .audit {
            text-align: center;
            border-left: 4px solid #6f42c1;
        }

        .org-top .badge-note {
            display: inline-block;
            margin-top: 6px;
            font-size: 12px;
            padding: 2px 8px;
            border-radius: 999px;
            background: #f1f3f5;
            color: #495057;
        }

        /* 데스크탑: CEO 중앙, 감사위 우측 */
        @media (min-width: 720px) {
            .org-top {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr; /* 좌-중앙-우 3열 */
                gap: 12px;
                align-items: start;
                justify-items: center;
            }

            .org-top .ceo {
                grid-column: 2;
                justify-self: center;
            }

            .org-top .audit {
                grid-column: 3;
                justify-self: end;
            }
        }

        /* CEO → Divisions 연결부 (세로 + 가로 라인) */
        .org-connector {
            position: relative;
            height: 36px; /* (세로 18px) + (가로 라인 두께/여백) */
            margin: 18px 83px;
        }

        .org-connector .v-line {
            position: absolute;
            top: -52px;
            left: 50%;
            transform: translateX(-50%);
            width: 2px;
            height: 100px; /* CEO 아래로 내려오는 세로선 */
            background: #dee2e6;
        }

        .org-connector .h-line {
            position: absolute;
            top: 18px; /* 세로선 끝나는 지점에 맞춤 */
            left: 9.8%; /* 좌우 살짝 여백 */
            width: 80.5%; /* 본부 카드들 위를 가로지르는 길이 */
            height: 2px;
            background: #dee2e6;
        }

        /* 본부 3열 */
        .org-divisions {
            position: relative; /* 각 섹션의 ::before 기준 */
            display: grid;
            grid-template-columns: 1fr;
            gap: 16px;
            margin-top: 12px; /* h-line과 섹션을 잇는 세로선 길이 */
        }

        @media (min-width: 880px) {
            .org-divisions {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        /* 본부 카드 */
        .division-card {
            border-top: 4px solid #0a3d62;
            position: relative; /* ::before 세로선 위해 */
        }

        .division-head {
            display: flex;
            flex-direction: column;
            gap: 2px;
            margin-bottom: 10px;
        }

        .division-head .ko {
            font-weight: 700;
            color: #2c3e50;
        }

        .division-head .en {
            font-size: 12px;
            color: #6c757d;
        }

        /* 팀 목록 */
        .team-list {
            list-style: none;
            margin: 0;
            padding: 0;
            display: grid;
            gap: 8px;
        }

        .team-item {
            border: 1px dashed #e9ecef;
            border-radius: 10px;
            padding: 10px 12px;
            background: #fcfcfd;
        }

        .team-item .name {
            font-weight: 600;
            color: #041a2f;
            margin-bottom: 2px;
            font-size: 14px;
            line-height: 1.2;
        }

        .team-item .desc {
            font-size: 12px;
            color: #6c757d;
            line-height: 1.4;
        }

        /* 마케팅팀 하위 파트 */
        .subparts {
            margin-top: 6px;
            display: grid;
            gap: 6px;
            padding-left: 10px;
            border-left: 2px solid #e9ecef;
        }

        .subpart {
            font-size: 12px;
            background: #f8f9fa;
            border: 1px solid #eceff3;
            border-radius: 8px;
            padding: 6px 8px;
            color: #495057;
        }

        /* 섹션 간 여백 & 안전폭 */
        .mt-8 {
            margin-top: 8px;
        }

        .mt-12 {
            margin-top: 12px;
        }

        .mt-16 {
            margin-top: 16px;
        }

        .org-scope {
            overflow: hidden;
        }

        /* ── 연결선: h-line과 각 본부 카드를 잇는 세로선 ── */
        @media (min-width: 880px) {
            .division-card::before {
                content: "";
                position: absolute;
                top: -40px; /* .org-divisions의 margin-top과 동일 */
                left: 50%;
                transform: translateX(-44%);
                width: 2px;
                height: 36px; /* h-line(가로선)에서 카드 상단까지 */
                background: #dee2e6;
            }
        }

        /* 모바일/태블릿에서는 가로 연결선과 분기 세로선 숨김 (세로스택이라 시각적 혼선 방지) */
        @media (max-width: 879.98px) {
            .org-connector .h-line {
                display: none;
            }

            .division-card::before {
                display: none;
            }
        }

        /* 팀 카드 호버 효과 */
        .team-item {
            border: 1px dashed #e9ecef;
            border-radius: 10px;
            padding: 10px 12px;
            background: #fcfcfd;
            transition: transform 0.2s ease, box-shadow 0.2s ease; /* 부드러운 전환 */
        }

        .team-item:hover {
            transform: translateY(-4px); /* 살짝 위로 이동 */
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* 그림자 강조 */
            background: #ffffff; /* 배경 약간 밝게 */
            border-color: #438f75; /* 포인트 컬러로 강조 */
        }

        /* 모달 내부 카드 스타일 */
        .emp-card {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 12px;
            height: 100%;
        }

        .emp-photo {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            object-fit: cover;
            background: #f1f3f5;
        }

        .emp-name {
            font-weight: 700;
            color: #041a2f;
        }

        .emp-meta {
            font-size: 12px;
            color: #6c757d;
        }

        body.modal-open {
            padding-right: 0 !important;
        }

        /* 조직도 내부에서 전역 .org-card 규칙 무력화 */
        .org-scope .org-card {
            width: auto; /* 전역 width 강제 해제 */
            overflow: visible; /* 연결선 ::before 잘리지 않게 */
            cursor: default; /* 불필요한 손모양 제거 */
            transform: none; /* 기본 이동 제거(혹시 전역에 transform 기본값이 있으면) */
        }

        .org-scope .org-card:hover {
            transform: none; /* 전역 :hover 이동 막기 */
            /* 필요한 경우 기존 그림자만 유지 */
            box-shadow: 0 2px 12px rgba(0, 0, 0, .04);
        }

        /* 세로 연결선이 카드 밖으로 나가므로, division-card는 확실히 보이도록 */
        .org-scope .division-card {
            overflow: visible;
        }

        /* (선택) 연결 라인 안정화: org-scope 자체도 잘리지 않게 */
        .org-scope {
            overflow: visible; /* 현재는 hidden이라면 visible로 바꾸는 걸 추천 */
        }

        .org-cards-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .org-card {
            width: calc(33.33% - 20px);
            min-width: 300px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            background-color: #fff;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
            margin-bottom: 4px;
        }

        .org-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        }

        .org-card-logo {
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px;
            background-color: #fff;
            border-bottom: 1px solid #f0f0f0;
        }

        .org-card-logo img {
            max-height: 100%;
            max-width: 100%;
            object-fit: contain;
        }

        .org-card-info {
            padding: 15px;
        }

        .org-name-container {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }

        .org-name {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin: 0;
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .org-detail {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 10px;
        }

        .org-detail-item {
            font-size: 14px;
            color: #666;
            display: flex;
            align-items: center;
        }

        .org-detail-item i {
            margin-right: 5px;
            color: #888;
        }
    </style>
</head>

<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>
<div class="container">
    <c:set var="activeMenu" value="orgGuide"/>
    <c:set var="activeSub" value="orgchart"/>

    <%@ include file="/WEB-INF/views/include/introSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display:flex;align-items:center;gap:8px;">조직도</h2>

        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">대표이사를 중심으로 감사위원회와 경영관리본부, 플랫폼본부, 사업본부로 구성되어 있으며,<br> 각 본부는 기획·개발·데이터·마케팅·고객경험 등 핵심 기능을
                    담당합니다</p>
            </div>
        </div>
        <div class="org-scope">
            <!-- Top: CEO + 감사위원회 -->
            <div class="org-top">
                <div class="org-card ceo">
                    <div class="label">대표이사 (CEO)</div>
                    <div class="en">Chief Executive Officer</div>
                </div>
                <div class="org-card audit">
                    <div class="label">감사위원회 · 상임감사위원실</div>
                    <div class="en">Independent Audit Committee</div>
                    <span class="badge-note">독립 기구</span>
                </div>
            </div>

            <div class="org-connector">
                <div class="v-line"></div>
                <div class="h-line"></div>
            </div>

            <!-- Divisions -->
            <div class="org-divisions">

                <!-- 경영관리본부 -->
                <section class="org-card division-card">
                    <header class="division-head">
                        <div class="ko">경영관리본부</div>
                        <div class="en">Management Division</div>
                    </header>
                    <ul class="team-list">
                        <li class="team-item" data-dept-id="101" role="button" tabindex="0" aria-label="경영지원팀 상세">
                            <div class="name">경영지원팀</div>
                            <div class="desc">HR · 총무 등 경영지원 전반</div>
                        </li>
                        <li class="team-item" data-dept-id="102" role="button" tabindex="0" aria-label="재무회계팀 상세">
                            <div class="name">재무회계팀</div>
                            <div class="desc">자금 관리 · 결산 · 회계 정책</div>
                        </li>
                    </ul>
                </section>

                <!-- 플랫폼본부 -->
                <section class="org-card division-card">
                    <header class="division-head">
                        <div class="ko">플랫폼본부</div>
                        <div class="en">Platform / Product Division</div>
                    </header>
                    <ul class="team-list">
                        <li class="team-item" data-dept-id="201" role="button" tabindex="0" aria-label="기획/디자인팀 상세">
                            <div class="name">기획/디자인팀</div>
                            <div class="desc">Product Planning &amp; UX/UI</div>
                        </li>
                        <li class="team-item" data-dept-id="202" role="button" tabindex="0" aria-label="서버/백엔드팀 상세">
                            <div class="name">서버/백엔드팀</div>
                            <div class="desc">Server / Backend</div>
                        </li>
                        <li class="team-item" data-dept-id="203" role="button" tabindex="0" aria-label="클라이언트팀 상세">
                            <div class="name">클라이언트팀</div>
                            <div class="desc">App / Web Client</div>
                        </li>
                        <li class="team-item" data-dept-id="204" role="button" tabindex="0" aria-label="데이터사이언스팀 상세">
                            <div class="name">데이터사이언스팀</div>
                            <div class="desc">Data Science: 상권분석 · 유저분석</div>
                        </li>
                        <li class="team-item" data-dept-id="205" role="button" tabindex="0" aria-label="QA팀 상세">
                            <div class="name">QA팀</div>
                            <div class="desc">Quality Assurance — 서비스 품질 관리</div>
                        </li>
                    </ul>
                </section>

                <!-- 사업본부 -->
                <section class="org-card division-card">
                    <header class="division-head">
                        <div class="ko">사업본부</div>
                        <div class="en">Business Division</div>
                    </header>
                    <ul class="team-list">
                        <li class="team-item" data-dept-id="301" role="button" tabindex="0" aria-label="마케팅팀 상세">
                            <div class="name">마케팅팀</div>
                            <div class="desc">Marketing</div>
                            <div class="subparts mt-8">
                                <div class="subpart">B2C 파트 — 유저 마케팅</div>
                                <div class="subpart">B2B 파트 — 가맹 마케팅</div>
                            </div>
                        </li>
                        <li class="team-item" data-dept-id="302" role="button" tabindex="0" aria-label="가맹사업팀 상세">
                            <div class="name">가맹사업팀</div>
                            <div class="desc">Franchise Sales &amp; Management</div>
                        </li>
                        <li class="team-item" data-dept-id="303" role="button" tabindex="0" aria-label="고객경험팀 상세">
                            <div class="name">고객경험팀 (CX/CS)</div>
                            <div class="desc">유저 및 가맹점주 문의 응대</div>
                        </li>
                    </ul>
                </section>

            </div><!-- /org-divisions -->
        </div><!-- /org-scope -->
    </main>


    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        (function () {
            const ctx = '${pageContext.request.contextPath}';
            document.addEventListener('click', function (e) {
                const li = e.target.closest('.team-item[data-dept-id]');
                if (!li) return;
                const id = (li.dataset.deptId || '').trim();
                if (!id) return;
                window.location.href = ctx + '/intro/org/dept/' + encodeURIComponent(id) + '/page';

            });
            document.addEventListener('keydown', function (e) {
                if (e.key !== 'Enter' && e.key !== ' ') return;
                const li = e.target.closest('.team-item[data-dept-id]');
                if (!li) return;
                const id = (li.dataset.deptId || '').trim();
                if (!id) return;
                e.preventDefault();
                window.location.href = ctx + '/intro/org/dept/' + encodeURIComponent(id) + '/page';

            });
        })();
    </script>
</div>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>