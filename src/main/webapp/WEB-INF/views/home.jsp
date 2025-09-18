<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAPTRIX</title>

    <!-- 아이콘 & 부트스트랩 -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"/>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <script>
        const contextPath = "${pageContext.request.contextPath}";
    </script>

    <!-- 웹폰트 -->
    <style>

        /* 내 현황 컨테이너 */
        .status-container {
            position: relative;
            top: 200px;
            left: 110px;
            z-index: 10;
        }

        .status-container strong {
            padding-right: 165px;
        }

        .status-container2 {
            position: relative;
            top: 200px;
            left: 110px;
            z-index: 10;
        }

        .status-badges-wrapper {
            display: flex;
            gap: 8px; /* 뱃지 사이 간격 */
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(0, 0, 0, 0.5); /* 반투명 배경 */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 30px; /* 글씨 크기 키움 */
            font-weight: 600;
            color: #fff;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
        }

        .badge i {
            font-size: 30px;
        }

        /* =========================
                   Design Tokens (Light)
                ========================== */
        :root {
            /* 색 */
            --bg: #ffffff; /* 완전 흰색 배경 */
            --surface: #ffffff; /* 카드 배경 */
            --muted-surface: #f7f8fa; /* 섹션 옅은 배경 */
            --border: #e7eaf0; /* 미세 경계선 */
            --text: #12151c; /* 본문 */
            --text-dim: #5d6470; /* 보조 텍스트 */
            --accent: #2563eb; /* 포인트(코발트 블루) */
            --accent-2: #16a34a; /* 보조 포인트(그린) */
            --chip-bg: #eef4ff; /* 칩 배경 */
            --chip-text: #23407a; /* 칩 텍스트 */
            /* 레이아웃 */
            --radius-lg: 16px;
            --radius-md: 12px;
            --radius-sm: 10px;
            /* 섀도우: 아주 얕게 */
            --shadow-1: 0 4px 16px rgba(10, 20, 30, .06);
            --shadow-2: 0 10px 30px rgba(10, 20, 30, .08);
            /* 애니메이션 */
            --ease: cubic-bezier(.22, .61, .36, 1);
        }

        /* Reset & Base */
        * {
            box-sizing: border-box;
        }

        html, body {
            font-family: 'Pretendard Variable', Pretendard, -apple-system,
            BlinkMacSystemFont, system-ui, 'Noto Sans KR', 'Malgun Gothic',
            sans-serif;
            letter-spacing: normal; /* 기존 .1px 대신 */
        }

        body {
            margin: 0;
            background: #f1f1f2;
            color: var(--text);
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        img {
            display: block;
            max-width: 100%;
        }

        button, input {
            font-family: inherit;
        }

        /* 포커스 접근성 */
        :focus-visible {
            outline: 3px solid rgba(37, 99, 235, .35);
            outline-offset: 2px;
            border-radius: 8px;
        }

        /* 컨테이너 */
        .main-container {
            width: 100%;
            max-width: 1500px;
            margin: 0 auto;
            padding: 24px 20px 64px;
        }

        /* 공용 카드 */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-1);
            transition: box-shadow .2s var(--ease), transform .2s var(--ease),
            border-color .2s var(--ease);
        }

        .card:hover {
            box-shadow: var(--shadow-2);
            transform: translateY(-2px);
        }

        /* HERO: 라이트, 사진 optional */
        .hero {
            position: relative; /* 자식 요소를 absolute로 위치시키기 위한 기준 */
            border-radius: 24px;
            padding: clamp(40px, 6vw, 72px) 24px;
            display: grid;
            place-items: center;
            min-height: 440px;
            overflow: hidden; /* 컨테이너 밖으로 나가는 영상 숨기기 */
            /* background: url(...) 이 줄을 삭제하거나 주석 처리하세요. */
            /* background: url('/images/main/main_1.png') center/cover no-repeat; */
            border: 1px solid var(--border);
            box-shadow: var(--shadow-1);
        }

        /* 새로 추가: 배경 영상 스타일 */
        .hero-video {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%); /* 중앙 정렬 */
            min-width: 100%;
            min-height: 100%;
            width: auto;
            height: auto;
            z-index: 1; /* 콘텐츠보다 뒤로 보내기 */
        }

        /* 텍스트 가독성을 위한 어두운 오버레이 (권장) */
        .hero::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4); /* 검은색 반투명 오버레이 */
            z-index: 2;
        }

        .hero-inner {
            position: relative; /* 오버레이와 영상보다 위에 오도록 */
            z-index: 3;
            width: 100%;
            max-width: 820px;
            text-align: center;
        }

        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 12px;
            border-radius: 999px;
            background: var(--chip-bg);
            color: var(--chip-text);
            font-size: 12px;
            font-weight: 700;
            border: 1px solid #dfe8ff;
            margin-bottom: 12px;
        }

        .hero h1 {
            font-weight: 800;
            font-size: clamp(28px, 4.3vw, 44px);
            color: white;
            line-height: 1.12;
            margin: 0 0 12px;
        }

        .hero p {
            color: var(--text-dim);
            font-size: clamp(14px, 2vw, 16px);
            margin: 0 0 22px;
        }

        /* 검색바 */
        .searchbar {
            display: flex;
            align-items: center;
            gap: 12px;
            background: #f7f9fc;
            border: 1px solid var(--border);
            border-radius: 999px;
            padding: 10px;
            transition: box-shadow .2s var(--ease), transform .2s var(--ease),
            border-color .2s var(--ease);
        }

        .searchbar:focus-within {
            box-shadow: 0 0 0 4px rgba(37, 99, 235, .15);
            border-color: #cfe0ff;
            transform: translateY(-1px);
        }

        .searchbar i {
            color: #6b7280;
            padding-left: 8px;
        }

        .searchbar input {
            flex: 1;
            background: transparent;
            border: 0;
            color: var(--text);
            outline: none;
            padding: 12px 4px 12px 0;
            font-size: 16px;
        }

        .searchbar input::placeholder {
            color: #9aa3af;
        }

        .searchbar button {
            appearance: none;
            border: 0;
            border-radius: 999px;
            padding: 10px 16px;
            background: linear-gradient(180deg, #3b82f6, #2563eb);
            color: #fff;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: transform .12s var(--ease), filter .12s var(--ease),
            box-shadow .12s var(--ease);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .35), 0 6px 18px rgba(37, 99, 235, .25);
        }

        .searchbar button:hover {
            filter: brightness(1.04);
            transform: translateY(-1px);
        }

        .searchbar button:active {
            transform: translateY(0);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .35);
        }

        /* 어드민 환영 바 */
        .admin-welcome {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 16px 18px;
        }

        .admin-welcome .meta {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--text-dim);
        }

        .badge-admin {
            padding: 4px 10px;
            border-radius: 999px;
            border: 1px solid var(--border);
            background: #f1f5ff;
            color: #23407a;
            font-size: 12px;
            font-weight: 700;
        }

        .btn-dashboard, .btn-ghost {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 12px;
            border-radius: var(--radius-sm);
            border: 1px solid var(--border);
            font-weight: 600;
            transition: transform .12s var(--ease), background .12s var(--ease),
            border-color .12s var(--ease), color .12s var(--ease);
        }

        .btn-dashboard {
            background: #eef4ff;
            color: #1e3a8a;
        }

        .btn-dashboard:hover {
            background: #e2ecff;
            transform: translateY(-1px);
        }

        .btn-ghost {
            background: #f8fafc;
            color: #0f172a;
        }

        .btn-ghost:hover {
            background: #f3f6f9;
            transform: translateY(-1px);
        }

        /* 섹션 타이틀 & 설명 */
        .section-title {
            font-size: 18px;
            font-weight: 800;
            margin: 0 0 10px;
            color: #0f172a;
        }

        .section-title.stamp {
            position: absolute;
            color: #fff;
            top: 20px;
        }

        .section-desc {
            margin: 0 0 14px;
            color: var(--text-dim);
            font-size: 14px;
        }

        /* Grid */
        .grid {
            display: grid;
            gap: 16px;
        }

        .grid-2 {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .grid-3 {
            grid-template-columns: repeat(3, minmax(0, 1fr));
        }

        @media ( max-width: 992px) {
            .grid-3 {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media ( max-width: 640px) {
            .grid-2, .grid-3 {
                grid-template-columns: 1fr;
            }
        }

        /* 인포 카드 */
        .infocard {
            padding: 20px;
        }

        .infocard .cover {
            height: 300px;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 14px;
            background: #eef2f7 center/cover no-repeat;
            border: 1px solid var(--border);
        }

        .infocard .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .infocard .stamp {
            border-radius: 10px;
            height: 280px; /* 전체 높이 유지 */
            background-image: url('/images/main/stamp_tourCard.png');
            background-repeat: no-repeat; /* 반복 방지 */
            background-position: center top; /* 상단 중앙 기준 */
            background-size: 100% auto; /* 세로 높이를 100%로 맞춤, 가로는 자동 */
        }

        .infocard .stamp2 {
            border-radius: 10px;
            height: 280px; /* 전체 높이 유지 */
            background-image: url('/images/main/stamp_tourCard3.png');
            background-repeat: no-repeat; /* 반복 방지 */
            background-position: center top; /* 상단 중앙 기준 */
            background-size: 100% auto; /* 세로 높이를 100%로 맞춤, 가로는 자동 */
        }

        /* 예시 카드(업종) */
        .examples {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        @media ( max-width: 992px) {
            .examples {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media ( max-width: 576px) {
            .examples {
                grid-template-columns: 1fr;
            }
        }

        .example-card {
            height: 120px;
            border-radius: var(--radius-lg);
            border: 1px dashed #d9dde5;
            background: linear-gradient(180deg, #fbfcfe 0%, #f8fafc 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0f172a;
            font-weight: 700;
            text-align: center;
            padding: 0 10px;
            transition: transform .15s var(--ease), border-color .15s var(--ease),
            background .15s var(--ease), box-shadow .15s var(--ease);
        }

        .example-card:hover {
            transform: translateY(-2px);
            border-color: #c7d2fe;
            background: #ffffff;
            box-shadow: var(--shadow-1);
        }

        /* 칩 */
        .chip {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 10px;
            background: var(--chip-bg);
            color: var(--chip-text);
            border: 1px solid #dfe8ff;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        /* 보조 섹션 배경 래퍼 (선택) */
        .section-wrap {
            background: var(--muted-surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 16px;
        }

        /* 모션 선호 */
        @media ( prefers-reduced-motion: reduce) {
            .card, .example-card, .searchbar, .btn-ghost, .btn-dashboard {
                transition: none !important;
            }
        }

        .hero.card:hover {
            box-shadow: var(--shadow-1);
            transform: none;
        }

        /* 통계 차트 부분 추가 */
        .map-layout-container {
            display: flex;
            gap: 16px; /* 좌우 간격 */
            height: 280px; /* 전체 높이 유지 */
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px;
        }

        #map-svg-wrapper {
            flex: 1.5; /* 왼쪽 영역을 더 넓게 (60%) */
            position: relative;
            margin-right: 50px; /* [추가] SVG를 오른쪽으로 이동시키기 위한 왼쪽 여백 */
        }

        #map-svg-wrapper svg {
            width: 100%;
            height: 100%;
        }

        /* 클릭된 구(path)에 적용될 스타일 */
        #map-svg-wrapper svg path.active {
            stroke: #1e3a8a; /* 진한 파란색 테두리 */
            stroke-width: 3px;
            stroke-linejoin: round;
        }

        #map-info-panel {
            flex: 1;
            background-color: var(--muted-surface);
            border-radius: 8px;
            padding: 16px;
            display: flex;
            flex-direction: column;
        }

        /* ▼▼▼ [추가] 이 한 줄의 코드가 문제를 해결합니다! ▼▼▼ */
        #info-content {
            flex: 1;
        }

        /* ▲▲▲ 여기까지 ▲▲▲ */
        #info-content .placeholder {
            text-align: center;
            color: var(--text-dim);
            font-size: 14px;
            /* margin-top에서 padding-top으로 변경하면 더 안정적입니다. */
            padding-top: 60px;
        }

        #info-content .placeholder i {
            font-size: 24px;
            margin-bottom: 8px;
        }

        #info-content h5 {
            font-weight: 800;
            color: var(--accent);
            margin-bottom: 16px;
            padding-bottom: 8px;
            border-bottom: 2px solid var(--accent);
        }

        #info-content .info-item {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            margin-bottom: 12px;
        }

        #info-content .info-label {
            color: var(--text-dim);
        }

        #info-content .info-value {
            font-weight: 700;
            color: var(--text);
        }

        @media ( max-width: 768px) {
            .grid-2 {
                grid-template-columns: 1fr;
            }

            .map-layout-container {
                flex-direction: column;
                height: auto;
            }
        }

        .review-showcase-grid {
            /* 기본 4단, 반응형으로 조정 */
            grid-template-columns: repeat(4, 1fr);
        }

        @media ( max-width: 992px) {
            .review-showcase-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media ( max-width: 576px) {
            .review-showcase-grid {
                grid-template-columns: 1fr;
            }
        }

        .review-showcase-card {
            display: block;
            background: var(--surface);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            overflow: hidden;
            box-shadow: var(--shadow-1);
            transition: transform .2s var(--ease), box-shadow .2s var(--ease);
        }

        .review-showcase-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-2);
        }

        .review-showcase-card .card-image-wrapper {
            position: relative;
            height: 180px;
        }

        .review-showcase-card img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .3s var(--ease);
        }

        .review-showcase-card:hover img {
            transform: scale(1.05);
        }

        .review-showcase-card .badge-overlay {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 4px 8px;
            font-size: 11px;
            font-weight: 700;
            color: #fff;
            border-radius: 999px;
            border: 1px solid rgba(255, 255, 255, 0.4);
        }

        /* 뱃지 색상 */
        .badge-overlay.tech {
            background: #3b82f6;
        }

        .badge-overlay.edu {
            background: #16a34a;
        }

        .badge-overlay.lifestyle {
            background: #f97316;
        }

        .badge-overlay.creative {
            background: #9333ea;
        }

        .review-showcase-card .card-content {
            padding: 16px;
        }

        .review-showcase-card .card-title {
            font-size: 16px;
            font-weight: 700;
            margin: 0 0 6px;
            color: var(--text);
        }

        .review-showcase-card .card-tag {
            display: inline-block;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 10px;
            border-radius: 999px;
            background: var(--chip-bg);
            color: var(--chip-text);
            margin-bottom: 12px;
        }

        .review-showcase-card .card-description {
            font-size: 13px;
            color: var(--text-dim);
            margin: 0 0 10px;
            /* 2줄 이상 넘어가면 말줄임표(...) 처리 */
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .review-showcase-card .card-author {
            font-size: 12px;
            color: var(--text-dim);
            text-align: right;
            font-style: italic;
            margin: 0;
        }

        .community-feed {
            margin-top: 20px;
            border-top: 1px solid var(--border);
        }

        .feed-item {
            display: flex;
            align-items: center; /* 세로 중앙 정렬 */
            gap: 12px;
            padding: 14px 8px;
            border-bottom: 1px solid var(--border);
            transition: background-color .2s var(--ease);
            border-radius: var(--radius-sm);
        }

        .feed-item:last-child {
            border-bottom: none;
        }

        .feed-item:hover {
            background-color: var(--muted-surface);
        }

        .feed-item .feed-icon {
            flex-shrink: 0;
            width: 36px;
            height: 36px;
            display: grid;
            place-items: center;
            background-color: var(--muted-surface);
            border-radius: 50%;
            color: var(--text-dim);
            font-size: 16px;
        }

        .feed-item .feed-main-content {
            flex-grow: 1;
            overflow: hidden; /* 제목이 길 경우를 대비 */
        }

        .feed-item .feed-tag {
            display: inline-block;
            padding: 3px 8px;
            font-size: 11px;
            font-weight: 700;
            border-radius: 999px;
            color: #fff;
        }

        /* 태그 색상 */
        .feed-tag.tag-forum {
            background: var(--accent);
        }

        .feed-tag.tag-news {
            background: var(--accent-2);
        }

        .feed-tag.tag-qna {
            background: #f97316;
        }

        .feed-item .feed-title {
            display: block; /* 태그 아래에 표시되도록 block으로 변경 */
            margin-top: 4px;
            font-size: 14px;
            font-weight: 600;
            color: var(--text);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .feed-item .feed-time {
            flex-shrink: 0;
            font-size: 12px;
            color: var(--text-dim);
            margin-left: auto; /* 오른쪽 끝으로 밀어내기 */
        }

        /* 1행 창업 지원 소식 슬라이더 스타일 (최종 수정본) */
        .cover-slider {
            position: relative;
            height: 300px;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 14px;
        }

        .slider-track {
            display: flex;
            height: 100%;
            transition: transform 0.5s ease-in-out;
        }

        /* ▼▼▼ [핵심 수정] a 태그에 position: relative 추가 ▼▼▼ */
        .slider-item {
            position: relative; /* 이미지가 이 태그를 기준으로 위치하도록 '목줄' 역할을 합니다. */
            flex: 0 0 100%;
            width: 100%;
            height: 100%;
        }

        /* ▼▼▼ [핵심 수정] img 태그의 스타일을 명확하게 지정 ▼▼▼ */
		.slider-item img{
		  position:absolute; inset:0;
		  width:100%; height:100%;
		  object-fit: cover;
		  object-position: top center;   /* top/center/bottom 등으로 조절 */
		}

        /* 슬라이더 화살표 버튼 스타일 (수정 없음) */
        .slider-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            background-color: rgba(0, 0, 0, 0.4);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.2s;
        }

        .slider-arrow:hover {
            background-color: rgba(0, 0, 0, 0.7);
        }

        .slider-arrow.left {
            left: 10px;
        }

        .slider-arrow.right {
            right: 10px;
        }

        .slider-arrow[disabled] {
            opacity: 0.3;
            cursor: default;
        }

        /* == 3행 업종 ===*/

        /* 업종 예시 카드 컨테이너 (그리드 표시용 - 슬라이더 미사용 시 그대로 동작) */
        .examples {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }

        /* 이미지 꽉 채우기 + 흰색 글씨 스타일 */
        .home-showcase-card {
            position: relative;
            display: flex;
            align-items: flex-end;
            padding: 12px;
            border-radius: 12px;
            overflow: hidden;
            height: 350px;
            transition: transform .15s ease, box-shadow .15s ease;
        }

        .home-showcase-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(10, 20, 30, .12);
        }

        /* 텍스트 가독성 오버레이 */
        .home-showcase-card::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 70%;
            background: linear-gradient(to top, rgba(0, 0, 0, .75) 0%,
            rgba(0, 0, 0, 0) 100%);
            z-index: 1;
            border-radius: 12px;
        }

        /* 이미지를 카드의 배경처럼 사용 */
        .card-image-wrapper {
            position: absolute;
            inset: 0;
            z-index: 0;
        }

        .card-image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform .2s ease;
        }

        /* 호버 시 살짝 확대 */
        .home-showcase-card:hover .card-image-wrapper img {
            transform: scale(1.05);
        }

        /* 텍스트(타이틀) */
        .card-title {
            position: relative; /* 오버레이 위에 */
            z-index: 2;
            font-size: 19px;
            font-weight: 700;
            color: #fff;
            text-shadow: 0 1px 3px rgba(0, 0, 0, .5);
        }

        /* 반응형 (그리드 버전용) */
        @media ( max-width: 992px) {
            .examples {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media ( max-width: 576px) {
            .examples {
                grid-template-columns: 1fr;
            }
        }

        /* =========================
           ▼▼ 3행 "슬라이더" 전용 추가 ▼▼
           (showcase-slider-*) 구조가 있을 때만 적용됨
           ========================= */

        /* 슬라이더 컨테이너 */
        .showcase-slider-container {
            position: relative;
            width: 100%;
        }

        /* 가시 영역 */
        .showcase-slider-wrapper {
            overflow: hidden;
            width: 100%;
        }

        /* 1. 슬라이드 트랙 (가로로 카드 나열) */
        .showcase-slider-track {
            display: flex;
            gap: 24px; /* [수정] 카드 사이 간격을 12px에서 16px로 넓힘 */
            will-change: transform;
            transition: transform .4s ease;
        }

        /* 2. 한 화면에 5개씩 보이도록 카드 폭 고정 */
        .showcase-slider-track .home-showcase-card {
            flex: 0 0 calc(20% - 19.2px); /* (100% - 16px*4)/5 */
            height: 300px;
        }

        /* 반응형: 992px 이하 2개, 576px 이하 1개 */
        @media ( max-width: 992px) {
            .showcase-slider-track .home-showcase-card {
                flex: 0 0 calc(50% - 6px);
            }
        }

        @media ( max-width: 576px) {
            .showcase-slider-track .home-showcase-card {
                flex: 0 0 100%;
            }
        }

        /* 좌우 화살표 */
        .showcase-slider-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 5;
            background: rgba(0, 0, 0, .4);
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: grid;
            place-items: center;
            cursor: pointer;
            transition: background-color .2s ease;
        }

        .showcase-slider-arrow:hover {
            background: rgba(0, 0, 0, .7);
        }

        .showcase-slider-arrow.prev {
            left: 8px;
        }

        .showcase-slider-arrow.next {
            right: 8px;
        }

        .showcase-slider-arrow[disabled] {
            opacity: .3;
            cursor: default;
        }

        /* 마지막 '더보기' 카드 전용 */
        .home-showcase-card.add-more {
            justify-content: center;
            align-items: center;
            background: #ffffff;
            border: none;
            box-shadow: none;
            text-decoration: none;
        }

        .home-showcase-card.add-more::after {
            display: none;
        }

        /* 이미지 카드용 그라데이션 제거 */
        .home-showcase-card.add-more:hover {
            transform: translateY(-2px);
            box-shadow: none;
            text-decoration: none;
        }

        /* 내부 레이아웃 */
        .more-wrap {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        /* 동그란 아이콘 버튼 */
        .more-circle {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: #eef2f7; /* 밝은 회색 원 */
            display: grid;
            place-items: center;
            box-shadow: inset 0 1px 0 #ffffff, 0 1px 2px rgba(0, 0, 0, .06);
            transition: transform .15s ease, background .15s ease;
        }

        .more-circle i {
            font-size: 26px;
            color: #374151; /* 다크 그레이 화살표 */
        }

        .home-showcase-card.add-more:hover .more-circle {
            background: #e5e7eb;
            transform: none;
        }

        /* '더보기' 텍스트 */
        .more-label {
            font-size: 16px;
            font-weight: 600;
            color: #6b7280; /* 중간 회색 */
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/rightFab.jsp" %>
<div class="main-container">

    <!-- ADMIN -->
    <sec:authorize access="hasRole('ADMIN')">
        <section class="admin-welcome card" style="margin-bottom : 15px;">
            <div class="meta">
					<span class="badge-admin"><i class="fa-solid fa-user-gear"></i>
						ADMIN</span>
                <div>
                    <strong><sec:authentication
                            property="principal.usersVO.name"/></strong> 관리자님, 환영합니다.
                </div>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a class="btn-dashboard" href="/admin"><i
                        class="fa-solid fa-gauge-high"></i> 대시보드</a>
                <form action="/logout" method="post" class="m-0 d-inline">
                    <button type="submit" class="btn-ghost">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> 로그아웃
                    </button>
                </form>
            </div>
        </section>
    </sec:authorize>

    <!-- HERO -->
    <section class="hero card">
        <%-- 배경 영상 --%>
        <video class="hero-video" autoplay loop muted playsinline>
            <source
                    src="${pageContext.request.contextPath}/images/main/21116-315137080_small.mp4"
                    type="video/mp4">
            브라우저가 비디오 태그를 지원하지 않습니다.
        </video>

        <div class="hero-inner">
            <div class="hero-eyebrow">
                <i class="fa-solid fa-chart-line"></i> 대전 상권 데이터로 보는 창업 인사이트
            </div>
            <h1>
                지역·업종 한 번에 검색하고<br/>수요·경쟁을 빠르게 파악하세요
            </h1>
            <p style="color: white;">
                추천 지역: <a
                    href="${pageContext.request.contextPath}/market/simple?query=오류동"  target="_blank"
                    class="chip"><i class="fa-regular fa-lightbulb"></i> 오류동</a> <a
                    href="${pageContext.request.contextPath}/market/simple?query=대흥동"  target="_blank"
                    class="chip"><i class="fa-regular fa-lightbulb"></i> 대흥동</a> <a
                    href="${pageContext.request.contextPath}/market/simple?query=관평동"  target="_blank"
                    class="chip"><i class="fa-regular fa-lightbulb"></i> 관평동</a> <a
                    href="${pageContext.request.contextPath}/market/simple?query=학하동"  target="_blank"
                    class="chip"><i class="fa-regular fa-lightbulb"></i> 학하동</a>
            </p>

            <form class="searchbar mt-2" action="${contextPath}/market/simple" target="_blank"
                  method="get" role="search" aria-label="상권 간단 검색">
                <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i> <input
                    type="text" name="query"
                    placeholder="관심있는 창업 아이템이나 지역을 검색해보세요. (예: 유성구 음식점)"
                    aria-label="검색어 입력">
                <button type="submit">
                    검색 <i class="fa-solid fa-arrow-right" aria-hidden="true" style="color: white;"></i>
                </button>
            </form>
        </div>
    </section>

    <!-- 1행: 배너/통계 -->
    <section class="grid grid-2 mt-3">
        <!-- 배너 카드 -->
        <article class="infocard card">
            <h2 class="section-title">
                <i class="fa-solid fa-bullhorn"></i> 창업 지원 소식
            </h2>
            <p class="section-desc">대전광역시 공고·보조금·교육 소식을 확인하세요.</p>

            <div class="cover-slider">
                <div class="slider-track">

                    <!-- 슬라이드 1 -->
                    <a href="${pageContext.request.contextPath}/start-up/mt/369" class="slider-item"> <img
                            src="/images/startup/mentoring/mt_law_2.png"
                            alt="소상공인 무료 법률서비스 지원사업 안내">
                    </a>

                    <!-- 슬라이드 2 -->
                    <a href="${pageContext.request.contextPath}/start-up/mt/368" class="slider-item"> <img
                            src="/images/startup/mentoring/mt_consulting_2.jpg "
                            alt="2025년 1인 영세 자영업자 고용산재보험료 지원사업 공고">
                    </a>

                    <!-- 슬라이드 3 -->
                    <a href="${pageContext.request.contextPath}/start-up/mt/366" class="slider-item"> <img
                            src="/images/startup/mentoring/mt_mentoring_3.PNG"
                            alt="K-ICT창업멘토링센터 하반기 선택형 멘토링 지원 안내">
                    </a>

                </div>
                <button type="button" class="slider-arrow left"
                        aria-label="이전 슬라이드">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
                <button type="button" class="slider-arrow right"
                        aria-label="다음 슬라이드">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>

            <div class="actions">
            
				<a href="${pageContext.request.contextPath}/start-up/mt" class="btn-ghost">
					<i class="bi bi-clipboard-check me-1"></i>지원사업 전체보기
				</a>
            </div>
        </article>

        <!-- 통계 카드 -->
        <article class="infocard card">
            <h2 class="section-title">
                <i class="fa-solid fa-chart-column"></i>2024 대전광역시 상권 현황
            </h2>
            <p class="section-desc">지도를 클릭하여 자치구별 상세 정보를 확인하세요.</p>

            <div class="map-layout-container">
                <div id="map-svg-wrapper"></div>
                <div id="map-info-panel">
                    <div id="info-content">
                        <h5>상세 정보</h5>
                        <div class="info-item">
                            <span class="info-label">총 사업체 수</span> <span class="info-value">172,782
									개</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">총 종사자 수</span> <span class="info-value">376,063
									명</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">소상공인 창업률</span> <span
                                class="info-value">19.0 %</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">소상공인 폐업률</span> <span
                                class="info-value">11.4 %</span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">평균 매출액</span> <span class="info-value">7.7
									억원</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="actions mt-3">
                <a href="${contextPath}/biz-stats/chart" class="btn-ghost"><i
                        class="fa-solid fa-magnifying-glass-chart"></i> 통계 자세히 보기</a>
            </div>
        </article>
    </section>

    <!-- 2행: 스토리/커뮤니티 -->
    <section class="grid grid-2 mt-3">
        <sec:authorize access="isAuthenticated()">
            <article class="infocard card">
                <h2 class="section-title">
                    <i class="fa-solid fa-stamp"></i>스탬프 여행 in 대전
                </h2>
                <p class="section-desc">골목상권 탐색 콘텐츠 스탬프투어를 경험해보세요.</p>

                <div class="stamp2">
                    <div class="status-container">
                        <strong id="totalPoint">1000</strong> <strong id="todayCount">3개</strong>
                        <strong id="totalCount">3개</strong>
                    </div>
                </div>
            </article>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
            <article class="infocard card">
                <h2 class="section-title">
                    <i class="fa-solid fa-stamp"></i>스탬프 여행 in 대전
                </h2>
                <p class="section-desc">골목상권 탐색 콘텐츠 스탬프투어를 경험해보세요.</p>

                <div class="stamp"
                     onclick="location.href='/attraction/apply-stamp/intro'"></div>
            </article>
        </sec:authorize>
        <article class="infocard card">
            <h2 class="section-title">
                <i class="fa-solid fa-people-group"></i> 커뮤니티 소식
            </h2>
            <p class="section-desc">같은 업종, 같은 지역 창업가들과 정보를 나누세요.</p>

            <div class="community-feed">
                <a href="/comm/free/56" class="feed-item">
                    <div class="feed-icon">
                        <i class="fa-regular fa-comments"></i>
                    </div>
                    <div class="feed-main-content">
                        <span class="feed-tag tag-forum">자유</span> <span
                            class="feed-title">유성구 카페 사장님들, 원두 어디서 받으세요?</span>
                    </div>

                </a> <a href="/comm/news/detail?newsId=74" class="feed-item">
                <div class="feed-icon">
                    <i class="fa-regular fa-newspaper"></i>
                </div>
                <div class="feed-main-content">
                    <span class="feed-tag tag-news">뉴스</span> <span
                        class="feed-title">통계데이터 활용대회 대상에 '소상공인 생존 높이는 전략'</span>
                </div>

            </a> <a href="/comm/free/84" class="feed-item">
                <div class="feed-icon">
                    <i class="fa-regular fa-comments"></i>
                </div>
                <div class="feed-main-content">
                    <span class="feed-tag tag-forum">자유</span> <span
                        class="feed-title">처음인데 세무 신고가 너무 막막하네요...</span>
                </div>

            </a>
            </div>
            <div class="actions" style="margin-top: 16px;">
                <a href="/comm/entry" class="btn-ghost"><i
                        class="fa-regular fa-rectangle-list"></i> 업종별 게시판 가기</a> <a
                    href="/comm/news" class="btn-ghost"><i
                    class="fa-regular fa-newspaper"></i> 상권 뉴스 더보기</a>
            </div>
        </article>
    </section>


    <!-- 3행: 업종 예시 카드 -->
    <section class="card mt-3 p-3" id="startup-examples">
        <div
                class="d-flex align-items-center justify-content-between flex-wrap gap-2 px-1">
            <h2 class="section-title m-0">
                <i class="fa-solid fa-store"></i> 어떤 매장처럼 창업하고 싶나요?
            </h2>
            <a href="${contextPath}/start-up/show" class="btn-ghost"
               style="font-size: 14px;"> 게시판 전체보기 <i
                    class="fa-solid fa-arrow-right" style="font-size: 0.8em;"></i>
            </a>
        </div>
        <p class="section-desc px-1">관심 업종 카드를 눌러 예시 상권과 벤치마크 포인트를 확인하세요.</p>

        <!-- ▼▼▼ 슬라이더 래퍼 추가 ▼▼▼ -->
        <div class="showcase-slider-container">
            <button type="button" class="showcase-slider-arrow prev"
                    aria-label="이전">
                <i class="fa-solid fa-chevron-left"></i>
            </button>

            <div class="showcase-slider-wrapper">
                <div class="showcase-slider-track">
                    <!-- 카드 1 -->
                    <a href="/start-up/show/detail/382" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="/images/startup/showcase/19_white_flower1.jpg"
                                    alt="햇살과 식물이 머무는 꽃집">
                        </div>
                        <span class="card-title">햇살과 식물이 머무는 꽃집</span>
                    </a>

                    <!-- 카드 2 -->
                    <a href="/start-up/show/detail/368" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/22_retro_pizza1.jpg"
                                    alt="레트로 감성 22평 피자집">
                        </div>
                        <span class="card-title">레트로 감성 22평 피자집</span>
                    </a>

                    <!-- 카드 3 -->
                    <a href="/start-up/show/detail/364" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/15_vintage_Izakaya1.jpg"
                                    alt="15평대 감성 요리 주점">
                        </div>
                        <span class="card-title">15평대 감성 요리 주점</span>
                    </a>

                    <!-- 카드 4 -->
                    <a href="/start-up/show/detail/369" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/retro_salad1.jpg"
                                    alt="캐주얼 감성 샐러드집">
                        </div>
                        <span class="card-title">캐주얼 감성 샐러드집</span>
                    </a>

                    <!-- 카드 5 -->
                    <a href="/start-up/show/detail/362" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/40_white_bigcafe1.jpg"
                                    alt="판암역 근처 대형 카페">
                        </div>
                        <span class="card-title">판암역 근처 대형 카페</span>
                    </a>

                    <!-- 카드 6 -->
                    <a href="/start-up/show/detail/381" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/30_white_cafe1.jpg"
                                    alt="햇살이 흐르는 까페">
                        </div>
                        <span class="card-title">햇살이 흐르는 까페</span>
                    </a>

                    <!-- 카드 7 -->
                    <a href="/start-up/show/detail/361" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/23_white_ramen1.jpg"
                                    alt="화이트&우드톤 라멘집">
                        </div>
                        <span class="card-title">화이트&우드톤 라멘집</span>
                    </a>

                    <!-- 카드 8 -->
                    <a href="/start-up/show/detail/365" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/25_vintage_diningBar1.jpg"
                                    alt="학원가 근처 빈티지한 버거샵">
                        </div>
                        <span class="card-title">학원가 근처 빈티지한 버거샵</span>
                    </a>

                    <!-- 카드 9 -->
                    <a href="/start-up/show/detail/367" class="home-showcase-card">
                        <div class="card-image-wrapper">
                            <img
                                    src="${pageContext.request.contextPath}/images/startup/showcase/retro_buger1.jpg"
                                    alt="비비드한 느낌의 수제버거집">
                        </div>
                        <span class="card-title">비비드한 느낌의 수제버거집</span>
                    </a>

                    <!-- 카드 10 -->
                    <a href="${contextPath}/start-up/show"
                       class="home-showcase-card add-more" aria-label="게시판 전체보기">
                        <div class="more-wrap">
								<span class="more-circle"><i
                                        class="fa-solid fa-arrow-right"></i></span> <span class="more-label">더보기</span>
                        </div>
                    </a>

                    <!-- 필요하면 카드 더 추가 -->
                </div>
            </div>

            <button type="button" class="showcase-slider-arrow next"
                    aria-label="다음">
                <i class="fa-solid fa-chevron-right"></i>
            </button>
        </div>
        <!-- ▲▲▲ 여기까지 ▲▲▲ -->
    </section>

    <!-- 4행: 후기 섹션 -->
    <section class="card mt-3 p-3">
        <div
                class="d-flex align-items-center justify-content-between flex-wrap gap-2 px-1">
            <h2 class="section-title m-0">
                <i class="fa-regular fa-star" style="color: var(--accent);"></i>
                생생한 창업 후기
            </h2>
            <a href="/comm/review" class="btn-ghost" style="font-size: 14px;">
                게시판 전체보기 <i class="fa-solid fa-arrow-right"
                            style="font-size: 0.8em;"></i>
            </a>
        </div>
        <p class="section-desc px-1">선배 창업가들의 노하우와 값진 경험을 만나보세요.</p>

        <div class="grid review-showcase-grid">

            <a href="comm/review/detail?postId=64" class="review-showcase-card">
                <div class="card-image-wrapper">
                    <img
                            src="${pageContext.request.contextPath}/images/main/창업후기1.jpg"
                            alt="어은동 테이블 대표"> <span class="badge-overlay creative">외식업
							/ F&B</span>
                </div>
                <div class="card-content">
                    <h4 class="card-title">어은동 테이블</h4>
                    <span class="card-tag">상권분석으로 찾은 나만의 골목</span>
                    <p class="card-description">유성구의 비싼 임대료가 부담이었지만, 상권분석 데이터를 활용해
                        대학생과 연구원들을 타겟으로 한 골목상권을 발굴할 수 있었습니다.</p>
                    <p class="card-author">박서준 대표</p>
                </div>
            </a> <a href="comm/review/detail?postId=65" class="review-showcase-card">
            <div class="card-image-wrapper">
                <img
                        src="${pageContext.request.contextPath}/images/main/창업후기2.jpg"
                        alt="리-클로젯 대표"> <span class="badge-overlay lifestyle">소매업
							/ 패션</span>
            </div>
            <div class="card-content">
                <h4 class="card-title">리-클로젯</h4>
                <span class="card-tag">데이터로 온라인 고객을 사로잡다</span>
                <p class="card-description">SNS 키워드 분석으로 친환경 소재에 관심 많은 20대
                    고객층을 파악했고, 타겟 광고를 통해 온라인 매출을 300% 이상 성장시켰습니다.</p>
                <p class="card-author">이지은 대표</p>
            </div>
        </a> <a href="comm/review/detail?postId=66" class="review-showcase-card">
            <div class="card-image-wrapper">
                <img
                        src="${pageContext.request.contextPath}/images/main/창업후기3.jpg"
                        alt="가게파트너 대표"> <span class="badge-overlay tech">IT
							/ 서비스</span>
            </div>
            <div class="card-content">
                <h4 class="card-title">가게파트너</h4>
                <span class="card-tag">정부지원사업으로 날개를 달다</span>
                <p class="card-description">아이디어는 있었지만 개발 자금이 부족했습니다. 이곳의 지원사업
                    안내를 통해 '소상공인 디지털 전환' 과제에 선정된 것이 결정적이었습니다.</p>
                <p class="card-author">김도윤 대표</p>
            </div>
        </a> <a href="comm/review/detail?postId=67" class="review-showcase-card">
            <div class="card-image-wrapper">
                <img
                        src="${pageContext.request.contextPath}/images/main/창업후기4.jpg"
                        alt="오늘의 흙 대표"> <span class="badge-overlay edu">제조 /
							공방</span>
            </div>
            <div class="card-content">
                <h4 class="card-title">오늘의 흙</h4>
                <span class="card-tag">위기를 기회로 만든 사업 다각화</span>
                <p class="card-description">오프라인 수강생이 줄어 힘들었을 때, 커뮤니티 조언을 얻어
                    온라인 DIY 키트 판매를 시작했고, 지금은 주력 매출이 되었습니다.</p>
                <p class="card-author">최아름 대표</p>
            </div>
        </a>

        </div>

    </section>

</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<jsp:include page="/WEB-INF/views/include/chatbot.jsp"/>

<!-- 스크립트 자리 -->
<script>
    //로그인 했는지
    const isAuthenticated = <sec:authorize access="isAuthenticated()">true</sec:authorize><sec:authorize access="!isAuthenticated()">false</sec:authorize>;

    document.addEventListener('DOMContentLoaded', function () {
        console.log("🚀 페이지 스크립트 실행 시작!");
        loadMainStatsChart();


        initSlider(); // 1행 슬라이더 초기화 함수
        initShowcaseSliderLogic(); // 3행 자랑게시판 슬라이더 초기화 함수

        if (isAuthenticated) {
            loadMyStamp();
        }
    });


    /**
     * [최종 개선] 슬라이더의 모든 기능을 하나의 함수로 통합
     */
    function initSlider() {

        const slider = document.querySelector('.cover-slider');
        if (!slider) {
            console.error("❌ 오류: '.cover-slider' 요소를 찾을 수 없습니다.");
            return;
        }

        const track = slider.querySelector('.slider-track');
        const prevBtn = slider.querySelector('.slider-arrow.left');
        const nextBtn = slider.querySelector('.slider-arrow.right');
        const items = Array.from(slider.querySelectorAll('.slider-item'));

        // 필수 요소 존재 여부 확인
        if (!track || !prevBtn || !nextBtn || items.length === 0) {
            console.error("❌ 오류: 슬라이더에 필요한 요소(track, buttons, items) 중 하나 이상이 누락되었습니다. HTML 구조를 확인해주세요.");
            return;
        }

        let current = 0;
        const count = items.length;
        let autoSlideTimer;

        // 슬라이드 이동 함수
        function moveTo(index, animate = true) {
            current = Math.max(0, Math.min(count - 1, index));
            const offsetPct = (100 / count) * current;

            // 🚨 백틱을 사용하지 않는 코드로 변경
            const transformValue = 'translateX(-' + offsetPct + '%)';

            if (!animate) {
                const old = track.style.transition;
                track.style.transition = 'none';
                track.style.transform = transformValue;
                track.offsetHeight; // Reflow를 강제하여 transition을 즉시 제거
                track.style.transition = old || 'transform 0.5s ease-in-out';
            } else {
                track.style.transform = transformValue;
            }
            // 버튼 활성화/비활성화
            prevBtn.disabled = (current === 0);
            nextBtn.disabled = (current === count - 1);
        }

        // 자동 슬라이드를 다음장으로 이동
        function nextSlide() {
            const nextIndex = (current + 1) % count;
            moveTo(nextIndex);
        }

        // 자동 슬라이드 타이머 리셋
        function resetAutoSlideTimer() {
            if (autoSlideTimer) {
                clearInterval(autoSlideTimer);
            }
            autoSlideTimer = setInterval(nextSlide, 3000); // 3초 간격
        }

        // 초기 레이아웃 설정
        function layout() {
            track.style.width = (count * 100) + '%';
            const each = (100 / count) + '%';
            items.forEach(el => {
                el.style.flex = '0 0 ' + each;
                el.style.width = each;
                el.style.height = '100%';
            });
            moveTo(current, false); // 애니메이션 없이 초기 위치 설정
        }

        // 이벤트 리스너 설정
        prevBtn.addEventListener('click', () => {
            moveTo(current - 1);
            resetAutoSlideTimer();
        });

        nextBtn.addEventListener('click', () => {
            moveTo(current + 1);
            resetAutoSlideTimer();
        });

        window.addEventListener('resize', () => moveTo(current, false));

        layout(); // 초기 레이아웃 실행
        resetAutoSlideTimer(); // 페이지 로드 시 자동 슬라이드 시작
    }

    //3행 자랑게시판 슬라이더의 동작(좌우 이동)을 처리하는 함수
    function initShowcaseSliderLogic() {
        const container = document.querySelector('#startup-examples .showcase-slider-container');
        if (!container) {
            console.warn("⏭ 3행 슬라이더 컨테이너가 없습니다. (HTML 래퍼가 필요한 구조예요)");
            return;
        }

        const wrapper = container.querySelector('.showcase-slider-wrapper');
        const track = container.querySelector('.showcase-slider-track');
        const prevBtn = container.querySelector('.showcase-slider-arrow.prev');
        const nextBtn = container.querySelector('.showcase-slider-arrow.next');

        if (!wrapper || !track || !prevBtn || !nextBtn) {
            console.error("❌ showcase 슬라이더 필수 요소 누락 (wrapper/track/prev/next).");
            return;
        }

        const items = track.querySelectorAll('.home-showcase-card');
        const itemsPerPage = getItemsPerPage(); // 반응형에 따라 계산
        const totalItems = items.length;
        let currentPage = 0;

        // 카드 개수가 한 페이지보다 적으면 버튼 숨김
        if (totalItems <= itemsPerPage) {
            prevBtn.style.display = 'none';
            nextBtn.style.display = 'none';
            return;
        }

        // 화면 크기에 따른 슬라이드 갯수 조절
        function getItemsPerPage() {
            const w = window.innerWidth;
            if (w <= 576) return 1;
            if (w <= 992) return 2;
            return 5;
        }

        function totalPages() {
            return Math.ceil(totalItems / getItemsPerPage());
        }

        function updateButtons() {
            prevBtn.disabled = (currentPage === 0);
            nextBtn.disabled = (currentPage >= totalPages() - 1);
        }

        function updateSlider() {
            const wrapperWidth = wrapper.clientWidth;

            // 현재 페이지 보정
            const maxPage = totalPages() - 1;
            if (currentPage < 0) currentPage = 0;
            if (currentPage > maxPage) currentPage = maxPage;

            // 이동
            const x = currentPage * wrapperWidth;
            track.style.transform = 'translateX(-' + x + 'px)';

            // << 여기서 화살표 show/hide >>
            // 첫 페이지면 prev 숨김, 마지막 페이지면 next 숨김
            prevBtn.style.display = (currentPage === 0) ? 'none' : 'grid';
            nextBtn.style.display = (currentPage === maxPage) ? 'none' : 'grid';
        }

        nextBtn.addEventListener('click', () => {
            if (currentPage < totalPages() - 1) {
                currentPage++;
                updateSlider();
            }
        });

        prevBtn.addEventListener('click', () => {
            if (currentPage > 0) {
                currentPage--;
                updateSlider();
            }
        });

        // 리사이즈 시 현재 페이지 유지한 채 위치 보정
        let resizeTimer;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(() => {
                // 반응형에서 itemsPerPage가 바뀌면 현재 페이지가 범위를 넘어갈 수 있으니 보정
                if (currentPage >= totalPages()) currentPage = Math.max(0, totalPages() - 1);
                updateSlider();
            }, 120);
        });

        updateSlider();
    }


    // [수정] 이미지의 모든 데이터를 객체 하나로 통합하여 저장합니다.
    const staticDistrictData = {
        '동구': {employeeCount: 36002, startupRate: 17.1, closureRate: 10.4},
        '중구': {employeeCount: 47212, startupRate: 16.8, closureRate: 12.0},
        '서구': {employeeCount: 107071, startupRate: 21.1, closureRate: 12.4},
        '유성구': {employeeCount: 120992, startupRate: 22.1, closureRate: 11.7},
        '대덕구': {employeeCount: 64786, startupRate: 14.4, closureRate: 9.3}
    };

    /**
     * [수정] 오른쪽 정보 패널을 업데이트하는 함수
     * API 데이터(총 사업체 수)와 위 staticDistrictData 객체의 데이터를 함께 사용합니다.
     */
    function updateDistrictInfo(districtData) {
        const infoContent = document.getElementById('info-content');
        if (!infoContent) {
            console.error("업데이트 실패: #info-content 요소를 찾을 수 없습니다.");
            return;
        }

        // 1. API로부터 받아온 데이터 처리 (총 사업체 수)
        const districtName = districtData?.districtName || '정보 없음';
        const activeCount = typeof districtData?.activeCount === 'number' ? districtData.activeCount : 0;

        // 2. staticDistrictData 객체에서 정적 데이터 가져오기 (종사자 수, 창업률, 폐업률)
        const staticData = staticDistrictData[districtName] || {employeeCount: 0, startupRate: 0, closureRate: 0};
        const employeeCount = staticData.employeeCount;
        const startupRate = staticData.startupRate;
        const closureRate = staticData.closureRate;

        console.log("🔄 정보 패널 업데이트 시도:", {districtName, activeCount, employeeCount, startupRate, closureRate});

        // 3. HTML 문자열 구성
        var htmlString =
            '<h5>' + districtName + ' 상세 정보</h5>' +
            '<div class="info-item">' +
            '<span class="info-label">총 사업체 수</span>' +
            '<span class="info-value">' + activeCount.toLocaleString() + ' 개</span>' +
            '</div>' +
            '<div class="info-item">' +
            '<span class="info-label">총 종사자 수</span>' +
            '<span class="info-value">' + employeeCount.toLocaleString() + ' 명</span>' +
            '</div>' +
            '<div class="info-item">' +
            '<span class="info-label">소상공인 창업률</span>' +
            '<span class="info-value">' + startupRate + ' %</span>' +
            '</div>' +
            '<div class="info-item">' +
            '<span class="info-label">소상공인 폐업률</span>' +
            '<span class="info-value">' + closureRate + ' %</span>' +
            '</div>';

        infoContent.innerHTML = htmlString;
        console.log("✅ 정보 패널 업데이트 완료!");
    }


    /**
     * 메인 SVG 지도와 통계를 로드하는 함수
     */
    async function loadMainStatsChart() {
        console.log("🗺️ loadMainStatsChart 함수 시작...");
        const container = document.getElementById('map-svg-wrapper');
        if (!container) {
            console.error("오류: #map-svg-wrapper 요소를 찾을 수 없습니다.");
            return;
        }
        container.innerHTML = '<p style="text-align:center; padding-top:20px;">지도 로딩 중...</p>';

        try {
            const dataResponse = await fetch(contextPath + '/api/biz-stats/chart/district-business');
            if (!dataResponse.ok) throw new Error('데이터 API 호출 실패 (상태 코드: ' + dataResponse.status + ')');
            const apiData = await dataResponse.json();
            console.log("📥 API에서 받아온 데이터:", apiData);

            const svgResponse = await fetch(contextPath + '/data/svg/Daejeon_sigungu.svg');
            if (!svgResponse.ok) throw new Error('SVG 파일 로딩 실패');
            const svgText = await svgResponse.text();

            container.innerHTML = svgText;
            const svg = container.querySelector('svg');
            svg.removeAttribute('width');
            svg.removeAttribute('height');
            svg.setAttribute('preserveAspectRatio', 'xMidYMid meet');

            const districtOrder = ['동구', '중구', '서구', '유성구', '대덕구'];
            const paths = svg.querySelectorAll('g[inkscape\\:label*="Daejeon_sigungu"] path');

            const getColor = (count) => {
                if (count >= 50000) return '#0a3d62';
                if (count >= 40000) return '#3c6382';
                if (count >= 25000) return '#82ccdd';
                return '#f1f2f6';
            };

            paths.forEach((path, index) => {
                if (index >= districtOrder.length) return;

                const districtName = districtOrder[index];
                const districtData = apiData.find(d => d.districtName === districtName);

                if (districtData) {
                    path.style.fill = getColor(districtData.activeCount);
                    path.style.cursor = 'pointer';

                    path.addEventListener('click', () => {
                        console.log('--- 🖱️ 클릭: \'' + districtName + '\' ---');
                        svg.querySelectorAll('path.active').forEach(p => p.classList.remove('active'));
                        path.classList.add('active');
                        updateDistrictInfo(districtData);
                    });

                    // =======================================================
                    // [추가] SVG 위에 텍스트 라벨(구 이름)을 추가하는 부분
                    // =======================================================
                    const bbox = path.getBBox(); // path의 경계 상자 정보
                    const centerX = bbox.x + bbox.width / 2;
                    const centerY = bbox.y + bbox.height / 2;

                    const textElement = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                    textElement.setAttribute('x', centerX);
                    textElement.setAttribute('y', centerY);
                    textElement.textContent = districtName;

                    // 텍스트 스타일링
                    textElement.setAttribute('text-anchor', 'middle'); // 수평 중앙 정렬
                    textElement.setAttribute('dominant-baseline', 'middle'); // 수직 중앙 정렬
                    textElement.setAttribute('font-size', '110');
                    textElement.setAttribute('font-weight', 'bold');
                    textElement.setAttribute('fill', 'rgba(0, 0, 0, 0.7)');

                    // [중요] 텍스트가 클릭 이벤트를 가로채지 않도록 설정
                    // 글씨 배경으로 희미한 흰색 테두리를 주어 가독성을 높입니다.
                    textElement.style.pointerEvents = 'none';
                    textElement.style.textShadow = '0 0 3px #fff, 0 0 3px #fff';


                    // 생성한 text 요소를 path와 같은 그룹에 추가
                    path.parentNode.appendChild(textElement);
                    // =======================================================
                }
            });

            // =======================================================
            // 범례 HTML 생성 및 SVG 컨테이너에 추가
            // =======================================================
            const legendHtml = `
         <h4>범례 (총 사업체 수, 단위: 개)</h4>
         <ul>
             <li><span class="color-box" style="background-color: #0a3d62;"></span>45,000 이상</li>
             <li><span class="color-box" style="background-color: #3c6382;"></span>35,000 ~ 45,000</li>
             <li><span class="color-box" style="background-color: #82ccdd;"></span>25,000 ~ 35,000</li>
             <li><span class="color-box" style="background-color: #f1f2f6;"></span>25,000 미만</li>
         </ul>`;

            const legendContainer = document.createElement('div');
            legendContainer.classList.add('legend-container');
            legendContainer.innerHTML = legendHtml;
            container.appendChild(legendContainer);

            // 범례 스타일링 (CSS)
            const style = document.createElement('style');
            style.textContent = `
   	    .legend-container {
   	        position: absolute;
   	        bottom: 10px;
   	        left: 230px; /* [수정] 10px에서 값을 늘려 오른쪽으로 이동 */
   	        background-color: rgba(255, 255, 255, 0.85);
   	        border: 1px solid #ccc;
   	        border-radius: 5px;
   	        padding: 8px 10px;
   	        font-size: 11px;
   	        line-height: 1.4;
   	        z-index: 10;
   	        box-shadow: 0 2px 4px rgba(0,0,0,0.1);
   	    }
   	    .legend-container h4 {
   	        margin-top: 0;
   	        margin-bottom: 4px;
   	        font-size: 12px;
   	        font-weight: bold;
   	    }
   	    .legend-container ul {
   	        list-style: none;
   	        padding: 0;
   	        margin: 0;
   	    }
   	    .legend-container li {
   	        margin-bottom: 2px;
   	        display: flex;
   	        align-items: center;
   	    }
   	    .legend-container li:last-child {
   	        margin-bottom: 0;
   	    }
   	    .legend-container .color-box {
   	        display: inline-block;
   	        width: 12px;
   	        height: 12px;
   	        margin-right: 5px;
   	        border: 1px solid #ddd;
   	    }
   	`;
            document.head.appendChild(style);

        } catch (error) {
            console.error("❗️ 지도 로딩 중 심각한 오류 발생:", error);
            container.innerHTML = '<p style="text-align:center; color:red;">차트 로딩 중 오류가 발생했습니다.<br>F12 개발자 콘솔을 확인해주세요.</p>';
        }
    }

    //스탬프정보
    // 전역에 함수 정의
    function loadMyStamp() {
        fetch("/attraction/dayMyStamp", {
            method: 'GET',
            credentials: 'include'
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("네트워크 응답이 실패했습니다.");
                }
                return response.json();
            })
            .then(data => {
                document.getElementById("totalPoint").textContent = data.totalPoint + "point" || 0 + "point";
                document.getElementById("todayCount").textContent = (data.dayStampList?.length || 0) + "개";
                document.getElementById("totalCount").textContent = (data.allStampList?.length || 0) + "개";
            })
            .catch(error => {
                console.error("데이터 로드 오류:", error);
            });
    }
</script>
</body>
</html>
