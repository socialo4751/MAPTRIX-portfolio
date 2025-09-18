<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>스탬프 앱 소개</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/csstyle.css">
    <style>
    	.flow-step.long {
		  height: 437px; /* 원하는 만큼 높이를 늘려주세요. */
		}
        .hero {
            border-radius: 16px;
            padding: 28px;
            background: linear-gradient(135deg, #0a3d62, #3c6382);
            color: #fff;
            margin-bottom: 10px;
        }

        .hero h2 {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 8px 0;
        }

        .pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 10px;
            border-radius: 999px;
            background: rgba(255, 255, 255, .12);
            font-size: .9rem;
        }

        .value-card {
            border: 1px solid #eee;
            border-radius: 14px;
            padding: 16px;
            background: #fff;
            height: 100%;
        }

        .value-card .icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f1f3f5;
            margin-bottom: 8px;
        }

        .flow-step {
            display: flex;
            gap: 12px;
            align-items: flex-start;
            background: #fff;
            border: 1px solid #eee;
            border-radius: 12px;
            padding: 12px;
            margin-top: 10px;
        }

        .flow-step .num {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #0a3d62;
            color: #fff;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: .9rem;
        }

        .cta .btn {
            min-width: 160px;
        }

        .muted {
            color: #6c757d;
        }
        
        
        .intro-hero {
        	margin-bottom: 20px;
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
        
        .brand-button{
            display: flex;
        	flex-direction: column;
    		align-items: center;
        	background-color: #f1f3f5;
        	border-radius: 10px;
        	margin-left:50px;
        	padding : 20px;
        }

		.brand-head {
			display: flex;
			align-items: center;
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
    </style>
</head>

<body>
<div class="container">
    <c:set var="activeMenu" value="stamp"/>
    <c:set var="activeSub" value="intro"/>
    <%@ include file="/WEB-INF/views/include/stSideBar.jsp" %>

    <main>
    <!-- Hero: 브랜드 로고 + 한 줄 설명 -->
    <section class="intro-hero">
        <!-- 로고 이미지 경로만 교체하세요 -->
        <picture style="display: flex;align-items: center;">
            <!-- WebP가 있으면 먼저 시도 -->
            <img src="${pageContext.request.contextPath}/images/stamp_tour.png"
                 class="brand-logo" alt="서비스 로고">
        </picture>

        <div class="brand-head">
        	<div>
        		<span class="kicker">ABOUT US</span>
	            <h3 class="brand-title">스탬프투어 — 골목 탐색 · 소비자를 위한 콘텐츠</h3>
	            <p class="brand-desc">
	            	지도 위 우편번호와 도로명을 따라 스탬프를 모으고, 리워드 혜택도 받아가세요!<br>
	            	스탬프투어는 리워드 포인트를 통해 우리 동네의 유동인구를 늘리고 가맹점 방문율을 높이기 위해 만들어졌습니다.<br>
	            	스탬프투어와 맵트릭스 가맹팀은 소비자들이 더 쉽게 가맹점을 찾고 방문할 수 있도록 최선을 다하겠습니다.
	            </p>
        	</div>
            <div class="brand-button" onclick="window.open('https://wondrous-cat-a6c613.netlify.app/');">
            	영상보기
            	<div style="font-size: 20px">📽️</div>
            </div>
        </div>
    </section>
    <div class="row g-2">
    	<div class="col-md-6">
    		<section class="hero">
	            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
	                <div>
	                    <h2><span class="material-icons" style="font-size:28px;">emoji_events</span>스탬프투어 앱을 사용해보세요!
	                    </h2>
	                    <div class="pill"><span class="material-icons" style="font-size:18px;">my_location</span> GPS기반 스탬프 리워드 · 골목탐색 · 오프라인 사용
	                    </div>
	                </div>
	                <div class="cta d-flex gap-2">
	                    <a class="btn btn-outline-light disabled" href="#"><span class="material-icons"
	                                                                             style="font-size:18px;vertical-align:-4px;">get_app</span>
	                        앱 다운로드(준비중)</a>
	                        * 안드로이드만 가능
	                </div>
	            </div>
	        </section>
	
	        <section>
	            <div class="row g-3">
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">directions_walk</span></div>
	                        <h6 class="mb-1">실시간 이동 리워드</h6>
	                        <p class="mb-0 muted">이동·체류·방문이 자동 적립. 일일 요약으로 동기부여.</p>
	                    </div>
	                </div>
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">task_alt</span></div>
	                        <h6 class="mb-1">미션·스탬프</h6>
	                        <p class="mb-0 muted">체크인/루트/시간대 미션으로 재미있게 모으는 보상.</p>
	                    </div>
	                </div>
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">qr_code_2</span></div>
	                        <h6 class="mb-1">오프라인 사용</h6>
	                        <p class="mb-0 muted">가맹점에서 QR/NFC로 간편하게 포인트 사용.</p>
	                    </div>
	                </div>
	            </div>
	        </section>
	
	        <section>
	            <div class="row g-1">
	                <div class="col-12">
	                    <div class="flow-step">
	                        <div class="num">1</div>
	                        <div><b>동의 및 실행</b><br><span class="muted">위치 권한 ON · 백그라운드 추적</span></div>
	                    </div>
	                </div>
	                <div class="col-12">
	                    <div class="flow-step">
	                        <div class="num">2</div>
	                        <div><b>이동 데이터 수집</b><br><span class="muted">이동/체류/방문 자동 기록 & 요약</span></div>
	                    </div>
	                </div>
	                <div class="col-12">
	                    <div class="flow-step">
	                        <div class="num">3</div>
	                        <div><b>미션 수행 & 스탬프</b><br><span class="muted">체크인/루트/시간대</span></div>
	                    </div>
	                </div>
	                <div class="col-12">
	                    <div class="flow-step">
	                        <div class="num">4</div>
	                        <div><b>포인트 전환</b><br><span class="muted">스탬프카드를 채우면 리워드포인트 지급</span></div>
	                    </div>
	                </div>
	                <div class="col-12">
	                    <div class="flow-step">
	                        <div class="num">5</div>
	                        <div><b>오프라인 사용</b><br><span class="muted">가맹점에서 QR/NFC 사용</span></div>
	                    </div>
	                </div>
	            </div>
	        </section>
    	</div>
    	<div class="col-md-6">
    		<section class="hero">
	            <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
	                <div>
	                    <h2><span class="material-icons" style="font-size:28px;">emoji_events</span>손님과 가게를 잇는 스탬프투어
	                    </h2>
	                    <div class="pill"><span class="material-icons">call</span> 가맹점 신청 문의 042-222-8202  <span class="material-icons">call</span>
	                    </div>
	                </div>
	                <div class="cta d-flex gap-2">
	                    <a class="btn btn-light" href="<c:url value='/attraction/apply-stamp'/>"><span
	                            class="material-icons" style="font-size:18px;vertical-align:-4px;">store</span> 가맹 신청</a>
	                </div>
	            </div>
	        </section>
	
	        <section>
	            <div class="row g-3">
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">directions_walk</span></div>
	                        <h6 class="mb-1">가맹점 우선 탐색</h6>
	                        <p class="mb-0 muted">스탬프투어 지도 사용시 가맹점을 제일 먼저 확인.</p>
	                    </div>
	                </div>
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">task_alt</span></div>
	                        <h6 class="mb-1">맵트릭스 가맹팀</h6>
	                        <p class="mb-0 muted">맵트릭스 가맹팀의 지속적이고 철저한 가맹점 관리.</p>
	                    </div>
	                </div>
	                <div class="col-md-4">
	                    <div class="value-card">
	                        <div class="icon"><span class="material-icons">qr_code_2</span></div>
	                        <h6 class="mb-1">가게 방문</h6>
	                        <p class="mb-0 muted">사용자가 쌓은 포인트 가맹점에서 사용 · 방문율UP</p>
	                    </div>
	                </div>
	            </div>
	        </section>
	
	        <section>
                <div class="row g-1">
                    <div class="col-12">
                        <div class="card p-4 border-0">
                            <h4 class="fw-bold mb-3">스탬프투어만의 특별한 가치</h4>
                            <p class="mb-4 text-muted">스탬프투어는 사용자에게는 편리함을, 가맹점에는 실질적인 효과를 제공합니다.</p>
                            
                            <ul class="list-unstyled">
                                <li class="d-flex mb-3">
                                    <span class="material-icons me-2 text-primary">circle</span>
                                    <div>
                                        <b class="d-block">가맹점 우선 노출</b>
                                        <span class="text-muted small">소비자들이 지도를 보면서 우리 가게를 가장 먼저 발견하고 방문할 수 있도록 돕습니다.</span>
                                    </div>
                                </li>
                                <li class="d-flex mb-3">
                                    <span class="material-icons me-2 text-primary">circle</span>
                                    <div>
                                        <b class="d-block">체계적인 가맹점 관리</b>
                                        <span class="text-muted small">맵트릭스 가맹팀의 체계적인 관리를 통해 매장을 더 효율적으로 관리하고, 고객에게 더 나은 경험을 제공할 수 있도록 지원합니다.</span>
                                    </div>
                                </li>
                                <li class="d-flex">
                                    <span class="material-icons me-2 text-primary">circle</span>
                                    <div>
                                        <b class="d-block">포인트를 활용한 방문율 UP</b>
                                        <span class="text-muted small">사용자들이 쌓은 포인트를 매장에서 직접 사용하게 하여 자연스럽게 방문율을 높이고, 이는 곧 매출 증가로 이어집니다.</span>
                                    </div>
                                </li>
                            </ul>
                            
                            
                        </div>
                    </div>
                </div>
            </section>
    	</div>
    	</div>

        <section class="d-flex justify-content-end gap-2 mb-3" style="margin-top: 10px;">
            <a class="btn btn-outline-secondary" href="<c:url value='/attraction/apply-stamp/policy'/>"><span
                    class="material-icons" style="font-size:18px;vertical-align:-4px;">redeem</span> 리워드 정책</a>
            <a class="btn btn-outline-secondary" href="<c:url value='/attraction/apply-stamp/privacy'/>"><span
                    class="material-icons" style="font-size:18px;vertical-align:-4px;">shield</span> 개인정보·보안</a>
        </section>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
