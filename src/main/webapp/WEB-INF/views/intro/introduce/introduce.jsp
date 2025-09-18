<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>사이트 소개</title>

    <!-- 공통 리소스 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <!-- 프로젝트 공용 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/introstyle.css">

    <!-- 페이지 전용 스타일: 소개 레이아웃 -->
    <style>
        .intro-hero {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 16px;
            padding: 24px;
            display: grid;
            grid-template-columns: 140px 1fr;
            gap: 18px;
        }

        .brand-logo {
            width: 120px;
            height: 120px;
            border-radius: 12px;
            object-fit: contain;
        }

        .brand-head .kicker {
            display: inline-block;
            font-size: .85rem;
            font-weight: 700;
            letter-spacing: .04em;
            color: #198754;
            background: #e9f7f1;
            border: 1px solid #d2f5e7;
            padding: 2px 8px;
            border-radius: 999px;
            margin-bottom: 6px;
        }

        .brand-title {
            margin: 0;
            font-weight: 800;
            color: #1a1c27;
        }

        .brand-desc {
            margin: 8px 0 0 0;
            color: #586174;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        .feature-card {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 16px;
        }

        .feature-card h5 {
            margin: 0 0 6px 0;
            font-weight: 700;
            color: #27314a;
        }

        .feature-card p {
            margin: 0;
            color: #586174;
        }

        .feature-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #f6fffb;
            border: 1px solid #d2f5e7;
            margin-right: 8px;
        }

        .metrics {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
        }

        .metric {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
        }

        .metric .num {
            font-size: 1.6rem;
            font-weight: 800;
            color: #1a1c27;
        }

        .metric .lab {
            color: #6c757d;
            margin-top: 4px;
        }

        .cta {
            background: linear-gradient(180deg, #ffffff, #fbfdfc);
            border: 1px solid #e9ecef;
            border-radius: 14px;
            padding: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .cta .txt {
            color: #27314a;
            margin: 0;
        }

        .cta .btn {
            white-space: nowrap;
        }

        .section-gap {
            margin-top: 24px;
        }

        .page-header .desc {
            color: #7f8c8d;
            font-size: .95rem;
            margin-top: .25rem;
        }

        @media (max-width: 992px) {
            .intro-hero {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .brand-logo {
                margin: 0 auto;
            }

            .feature-grid {
                grid-template-columns: 1fr;
            }

            .metrics {
                grid-template-columns: 1fr 1fr;
            }

            .cta {
                flex-direction: column;
                text-align: center;
            }
        }

        /* === 기존 정의를 덮어쓰거나 교체 === */
        .intro-hero {
            margin: 0 0 -25px 0;
        }

        /* 히어로 아래 여백 */
        .section-gap {
            margin: 100px 0;
        }

        /* 각 섹션 위·아래 여백 */
    </style>
</head>

<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>
<div class="container">
    <c:set var="activeMenu" value="introduce"/>
    <%@ include file="/WEB-INF/views/include/introSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display:flex;align-items:center;gap:8px;position:relative;">사이트 소개</h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">창업자와 소상공인을 위한 실질적인 상권 분석, 모두가 함께하는 데이터 플랫폼입니다.</p>
            </div>
        </div>


        <!-- Hero: 브랜드 로고 + 한 줄 설명 -->
        <section class="intro-hero">
            <!-- 로고 이미지 경로만 교체하세요 -->
            <picture>
                <!-- WebP가 있으면 먼저 시도 -->
                <img src="${pageContext.request.contextPath}/images/main/logoinfo.png"
                     class="brand-logo" alt="서비스 로고">
            </picture>

            <div class="brand-head">
                <span class="kicker">ABOUT US</span>
                <h3 class="brand-title">MAPTRIX — 상권 분석 · 창업 지원 플랫폼</h3>
                <p class="brand-desc">
                    MAPTRIX는 지역 상권 데이터, 유동인구, 경쟁 현황, 임대료 등을 한 곳에서 확인하고,
                    <strong>맞춤 리포트</strong>와 <strong>추천 인사이트</strong>로 실행을 돕는 플랫폼입니다.
                    누구나 데이터 기반으로 빠르게 시장을 읽고, 더 나은 결정을 내릴 수 있도록 설계했습니다.
                </p>
            </div>
        </section>

        <!-- 핵심 가치/기능 -->
        <section class="section-gap">
            <h4 class="mb-4">우리가 제공하는 것</h4>
            <div class="feature-grid">
                <article class="feature-card">
                    <div class="d-flex align-items-center mb-1">
                        <span class="feature-icon" aria-hidden="true">
                            <span class="material-icons">query_stats</span>
                        </span>
                        <h5 class="mb-0">정교한 상권 데이터</h5>
                    </div>
                    <p>유동인구, 업종 분포, 임대료 추이 등 핵심 지표를 지도로 한눈에 확인.</p>
                </article>

                <article class="feature-card">
                    <div class="d-flex align-items-center mb-1">
                        <span class="feature-icon" aria-hidden="true">
                            <span class="material-icons">insights</span>
                        </span>
                        <h5 class="mb-0">맞춤형 인사이트</h5>
                    </div>
                    <p>관심 지역/업종을 기준으로 자동 추천 리포트를 생성해 실행 포인트 제시.</p>
                </article>

                <article class="feature-card">
                    <div class="d-flex align-items-center mb-1">
                        <span class="feature-icon" aria-hidden="true">
                            <span class="material-icons">dashboard</span>
                        </span>
                        <h5 class="mb-0">간편한 대시보드</h5>
                    </div>
                    <p>즐겨찾기, 알림, 비교 기능으로 필요한 정보만 빠르게 모아보세요.</p>
                </article>
            </div>
        </section>

        <!-- 핵심 지표(하드코딩 자리, 필요시 값만 바꿔 사용) -->
        <section class="section-gap">
            <h4 class="mb-4">한눈에 보는 지표</h4>
            <div class="metrics">
                <div class="metric">
                    <div class="num">1,240+</div>
                    <div class="lab">분석 리포트</div>
                </div>
                <div class="metric">
                    <div class="num">320개</div>
                    <div class="lab">주요 상권 커버리지</div>
                </div>
                <div class="metric">
                    <div class="num">98%</div>
                    <div class="lab">고객 만족도</div>
                </div>
                <div class="metric">
                    <div class="num">24시간</div>
                    <div class="lab">데이터 갱신 주기</div>
                </div>
            </div>
            <p class="text-muted mt-2" style="font-size:.9rem;">* 본 지표는 맵트릭스에서 자체적으로 수집한 데이터입니다.</p>
        </section>

        <!-- CTA / 문의 -->
        <section class="section-gap">
            <div class="cta">
                <p class="txt"><strong>문의/협업 제안</strong>이 있으신가요? 담당자가 빠르게 연락드릴게요.</p>
                <!-- 링크/주소를 실제로 교체하세요 -->
                <div class="d-flex gap-2">
                    <a href="mailto:contact@yourdomain.com" class="btn btn-outline-success btn-sm">
                        <span class="material-icons" style="font-size:18px;vertical-align:middle;">mail</span>
                        <span style="vertical-align:middle;"> 이메일 문의</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/cs/faq" class="btn btn-success btn-sm">
                        <span class="material-icons" style="font-size:18px;vertical-align:middle;">help_outline</span>
                        <span style="vertical-align:middle;"> 자주 묻는 질문</span>
                    </a>
                </div>
            </div>
        </section>

    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
