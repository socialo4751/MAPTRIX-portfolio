<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>프로젝트 연혁</title>

    <!-- 공통 리소스 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <!-- 프로젝트 공용 스타일 (헤더/컨테이너/페이지 타이틀 등) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/introstyle.css">

    <!-- 페이지 전용(스코프) 스타일: 타임라인 UI -->
    <style>
        /* 섹션 설명 텍스트(선택) */
        .page-header .desc {
            color: #7f8c8d;
            font-size: 0.95rem;
            margin-top: .25rem;
        }

        /* 빠른 이동 바 */
        .history-nav {
            position: sticky;
            top: 12px;
            z-index: 5;
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: .75rem;
            display: flex;
            flex-wrap: wrap;
            gap: .5rem;
        }

        .history-nav .btn {
            --bs-btn-padding-y: .375rem;
            --bs-btn-padding-x: .75rem;
            --bs-btn-font-size: .875rem;
        }

        .history-nav .btn.active {
            border-color: #1cc88a;
            color: #1cc88a;
            font-weight: 700;
        }

        /* 타임라인 래퍼 */
        .timeline {
            padding-left: 22px; /* 세로선과 도트 여백 */
            margin-top: 24px;
        }

        .timeline::before {
            content: "";
            position: absolute;
            left: 8px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }

        /* 연도 구획 */
        .year-section {
            margin-bottom: 40px;
        }

        .year-title {
            position: sticky;
            top: 12px;
            z-index: 2;
            font-family: 'GongGothicMedium', sans-serif; /* 프로젝트 톤 맞춤 */
            font-size: 24px;
            color: #2c3e50;
            background: #fff;
            padding: 6px 10px;
            border-left: 4px solid #1cc88a;
            border-radius: 6px;
        }

        /* 항목 */
        .tl-list {
            list-style: none;
            padding-left: 0;
            margin: 14px 0 0 0;
        }

        .tl-item {
            position: relative;
            padding-left: 18px;
            margin: 0 0 18px 0;
        }

        .tl-item::before {
            content: "";
            position: absolute;
            left: -6px;
            top: .6em;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #1cc88a;
            border: 2px solid #fff;
            box-shadow: 0 0 0 2px rgba(28, 200, 138, .25);
        }

        .tl-date {
            display: inline-block;
            min-width: 58px;
            font-weight: 600;
            color: #6c757d;
        }

        .tl-card {
            display: inline-block;
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            padding: 10px 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .03);
        }

        .tl-title {
            margin: 0;
            font-size: 1rem;
            color: #1a1c27;
            font-weight: 700;
        }

        .tl-desc {
            margin: .25rem 0 0 0;
            color: #586174;
            font-size: .95rem;
        }

        .tl-tags {
            margin: .5rem 0 0 0;
            display: flex;
            gap: .375rem;
            flex-wrap: wrap;
        }

        .tl-tag {
            display: inline-block;
            font-size: .75rem;
            padding: .25rem .5rem;
            border-radius: 999px;
            background: #f1fff9;
            border: 1px solid #d2f5e7;
            color: #138f5c;
        }

        /* 맨 위로 버튼 스타일 */
        .back-to-top-wrapper {
            text-align: center;
            margin-top: 40px; /* 타임라인과 버튼 사이 여백 */
        }

        #backToTop {
            --bs-btn-padding-y: .5rem;
            --bs-btn-padding-x: 1rem;
            --bs-btn-font-size: .9rem;
            border-width: 1px;
            font-weight: 600;
            box-shadow: 0 4px 12px rgba(0, 0, 0, .08);
            border-color: #1cc88a;
            color: #1cc88a;
        }

        #backToTop:hover {
            background-color: #1cc88a;
            color: #fff;
        }


        /* 작은 화면에서 날짜/본문 줄바꿈 */
        @media (max-width: 992px) {
            .tl-date {
                display: block;
                margin-bottom: .25rem;
            }
        }
    </style>
</head>

<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>

<div class="container">
    <c:set var="activeMenu" value="history"/>
    <%@ include file="/WEB-INF/views/include/introSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display:flex;align-items:center;gap:8px;position:relative;">프로젝트 연혁 </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">도전과 성장을 이어온 우리의 여정을 만나보세요.</p>
            </div>
        </div>

        <!-- 타임라인 -->
        <section class="timeline">

            <div class="year-section" id="y2025" aria-labelledby="y2025-title">
                <h3 class="year-title" id="y2025-title">2025</h3>
                <ol class="tl-list">
                    <li class="tl-item">
                        <span class="tl-date">08.28</span>
                        <div class="tl-card">
                            <p class="tl-title">NAVER CLOUD 서버 배포</p>
                            <p class="tl-desc">프로젝트 최종 결과물을 클라우드 서버에 배포하여 서비스를 시작했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">배포</span><span class="tl-tag">서버</span><span
                                    class="tl-tag">클라우드</span>
                            </div>
                        </div>
                    </li>

                    <li class="tl-item">
                        <span class="tl-date">08.26</span>
                        <div class="tl-card">
                            <p class="tl-title">사용자 경험(UX)에 대한 새로운 접근</p>
                            <p class="tl-desc">현업 멘토 분들의 피드백을 통해, 사용자 경험(UX)의 본질을 고민해보는 중요한 계기가 되었고, 재구성을 진행하였습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">UX</span><span class="tl-tag">성장</span><span
                                    class="tl-tag">개선</span>
                            </div>
                        </div>
                    </li>

                    <li class="tl-item">
                        <span class="tl-date">07.28</span>
                        <div class="tl-card">
                            <p class="tl-title">프로젝트 개발 착수</p>
                            <p class="tl-desc">설계 및 프로토타입을 기반으로 실제 기능 구현을 시작했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">개발</span><span class="tl-tag">구현</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.26</span>
                        <div class="tl-card">
                            <p class="tl-title">프론트엔드 화면 설계 완료</p>
                            <p class="tl-desc">사용자 인터페이스(UI) 및 사용자 경험(UX) 설계를 최종 완료했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">프론트엔드</span><span class="tl-tag">UI/UX</span><span class="tl-tag">디자인</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.25</span>
                        <div class="tl-card">
                            <p class="tl-title">핵심 기능 프로토타입 구현 완료</p>
                            <p class="tl-desc">LLM AI를 활용한 상권 분석 기능의 핵심 프로토타입을 구현하고 테스트를 완료했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">AI</span><span class="tl-tag">LLM</span><span
                                    class="tl-tag">프로토타입</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.14</span>
                        <div class="tl-card">
                            <p class="tl-title">데이터베이스 및 아키텍처 설계 완료</p>
                            <p class="tl-desc">안정적인 서비스 운영을 위한 시스템 아키텍처와 데이터베이스 설계를 마쳤습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">DB</span><span class="tl-tag">아키텍처</span><span
                                    class="tl-tag">설계</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.11</span>
                        <div class="tl-card">
                            <p class="tl-title">JWT 및 Spring Security 구성 완료</p>
                            <p class="tl-desc">안전한 서비스 이용을 위한 JWT 기반 인증 및 인가 기능을 구현했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">보안</span><span class="tl-tag">인증</span><span
                                    class="tl-tag">백엔드</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.11</span>
                        <div class="tl-card">
                            <p class="tl-title">기획서 및 기타 문서 작업 완료</p>
                            <p class="tl-desc">프로젝트의 목표와 범위를 정의하는 기획서와 관련 문서 작업을 마무리했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">기획</span><span class="tl-tag">문서화</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">07.04</span>
                        <div class="tl-card">
                            <p class="tl-title">데이터 수집 및 전처리</p>
                            <p class="tl-desc">대전 안심 데이터 센터에 방문하여 상권 분석에 필요한 데이터를 수집하고 정제했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">데이터</span><span class="tl-tag">전처리</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">06.30</span>
                        <div class="tl-card">
                            <p class="tl-title">데이터 시각화 테스트</p>
                            <p class="tl-desc">수집된 데이터를 지도 앱에 효과적으로 표현하기 위한 시각화 기술을 테스트했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">시각화</span><span class="tl-tag">지도</span><span
                                    class="tl-tag">테스트</span>
                            </div>
                        </div>
                    </li>
                    <li class="tl-item">
                        <span class="tl-date">06.20</span>
                        <div class="tl-card">
                            <p class="tl-title">상권 분석 방법론 스터디</p>
                            <p class="tl-desc">프로젝트의 이론적 기반을 다지기 위해 관련 논문을 스터디했습니다.</p>
                            <div class="tl-tags">
                                <span class="tl-tag">리서치</span><span class="tl-tag">스터디</span><span
                                    class="tl-tag">기획</span>
                            </div>
                        </div>
                    </li>
                </ol>
            </div>

            <!-- 맨 위로 버튼 (페이지 콘텐츠 하단 중앙) -->
            <div class="back-to-top-wrapper">
                <button id="backToTop" class="btn">
                    <span class="material-icons" style="font-size:18px; vertical-align:middle;">north</span>
                    <span style="vertical-align:middle;">TOP</span>
                </button>
            </div>
        </section>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // TOP 버튼
    const topBtn = document.getElementById('backToTop');
    // 스크롤과 상관없이 항상 보이므로, 클릭 이벤트만 남겨둡니다.
    topBtn.addEventListener('click', () => window.scrollTo({top: 0, behavior: 'smooth'}));
</script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
