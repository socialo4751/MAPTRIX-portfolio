<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>커뮤니티 입장</title>

    <!-- 외부 리소스 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/entrystyle.css"/>

    <style>
        /* ===== Theme Vars & Base ===== */
        :root {
            --bg: #f8fafc;
            --card: #fff;
            --text: #111827;
            --muted: #6b7280;
            --border: #e5e7eb;
            --brand: #0d6efd;
            --shadow: 0 6px 18px rgba(0, 0, 0, .06);

            /* chips */
            --chip-bg: #e8f5e9; /* 연한 초록 배경 */
            --chip-border: #a7d7b0; /* 테두리 초록 */
            --chip-text: #14532d; /* 글자 진한 초록 */
            --chip-bg-hover: #def0e2; /* 호버 배경 */
            --chip-border-hover: #8fd1a0; /* 호버 테두리 */
            --chip-bg-active: #d4ebdb; /* 클릭 배경 */
        }

        * {
            box-sizing: border-box
        }

        body {
            background: var(--bg);
            color: var(--text)
        }

        /* ===== Page Wrapper ===== */
        .entry-wrap {
            max-width: 1280px;
            margin: 16px auto 40px;
            padding: 0 12px;
        }

        /* ===== Top Shortcuts ===== */
        .entry-bar {
            background: #fff;
            padding: 10px 12px;
            margin-bottom: 14px;
        }

        .entry-bar .bar-inner {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
            justify-content: center;
        }

        .entry-bar select {
            min-width: 220px;
            height: 40px;
            padding: 8px 10px;
            border: 1px solid var(--border);
            border-radius: 8px;
            background: #fff;
            font-size: .95em;
        }

        .btn-enter {
            height: 40px;
            padding: 0 14px;
            border: none;
            border-radius: 8px;
            background: var(--brand);
            color: #fff;
            font-weight: 700;
            font-size: .95em;
        }

        .btn-enter:disabled {
            background: #cbd5e1
        }

        /* ===== 2-Column Layout ===== */
        .entry-main {
            display: grid;
            grid-template-columns:320px minmax(0, 1fr);
            gap: 16px;
        }

        @media (max-width: 992px) {
            .entry-main {
                grid-template-columns:1fr
            }
        }

        /* ===== Left: Themes ===== */
        .themes-col .sec-title {
            font-weight: 700;
            font-size: 18px;
            margin: 6px 0 10px
        }

        .themes-grid {
            display: grid;
            grid-template-columns:1fr;
            gap: 10px
        }

        .theme-card {
            position: relative;
            display: grid;
            grid-template-columns:1fr auto;
            grid-template-rows:auto auto;
            align-items: center;
            min-height: 88px;
            padding: 14px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 6px;
            cursor: pointer;
            transition: border-color .12s, box-shadow .12s, background .12s;
            box-shadow: var(--shadow);
        }

        .theme-card:focus {
            outline: none
        }

        .theme-card:hover {
            border-left: 4px solid #0a3d62;
            border-right: 4px solid #0a3d62;
            background: #fcfdff
        }

        .theme-card .title {
            grid-column: 1/2;
            grid-row: 1/2;
            font-weight: 700;
            color: var(--text);
            gap: 6px;
            align-items: center
        }

        .theme-card .badge-soft {
            grid-column: 2/3;
            grid-row: 1/2;
            justify-self: end;
            font-size: 12px;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(45deg, #60A5FA, #A78BFA);
            border: none;
            border-radius: 999px;
            padding: 3px 10px;
        }

        .theme-card .desc {
            grid-column: 1/3;
            grid-row: 2/3;
            font-size: 13px;
            color: var(--muted);
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        /* ===== Right: Preview Pane ===== */
        .preview-pane {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 16px;
            min-width: 920px;
            overflow: auto;
            scrollbar-gutter: stable both-edges;
            box-shadow: var(--shadow);
        }

        .preview-head {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 12px
        }

        .preview-title {
            font-weight: 700
        }

        .preview-note {
            margin-left: auto;
            font-size: 12px;
            color: var(--muted)
        }

        /* ===== Boards Grid ===== */
        .boards-grid {
            display: grid;
            grid-template-columns:repeat(3, minmax(0, 1fr));
            gap: 12px;
            grid-auto-rows: minmax(140px, auto); /* 유연 높이 */
        }

        @media (max-width: 1200px) {
            .boards-grid {
                grid-template-columns:repeat(2, 1fr)
            }
        }

        @media (max-width: 576px) {
            .boards-grid {
                grid-template-columns:1fr
            }
        }

        /* ===== Board Card (Anchor) ===== */
        .board-card {
            display: block;
            height: auto;
            overflow: hidden;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            color: inherit;
            text-decoration: none;
            transition: border-color .12s, box-shadow .12s, background .12s;
        }

        .board-card:hover,
        .board-card:focus,
        .board-card:active,
        .board-card:focus-visible {
            text-decoration: none !important;
            border-color: var(--brand);
            box-shadow: var(--shadow);
            outline: none
        }

        .preview-pane a.board-card:hover {
            text-decoration: none !important
        }

        /* bootstrap 덮어쓰기 */

        /* ===== Card Body → Grid (title + tags) ===== */
        .board-body {
            display: grid;
            grid-template-columns:1fr auto;
            grid-template-rows:auto auto; /* 제목(1) / 태그(2) */
            column-gap: 8px;
            row-gap: 6px;
            min-width: 0;
        }

        /* ===== Title (with icon) ===== */
        .board-name {
            grid-column: 1/2;
            grid-row: 1/2;
            margin: 0;
            font-size: 20px;
            font-weight: 800;
            line-height: 1.35;
            letter-spacing: -.01em;
            color: #0f172a;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-wrap: pretty;
            word-break: keep-all;
        }

        /* Material icon next to title */
        .material-icons.mi {
            font-size: 18px;
            line-height: 1;
            margin-right: 6px;
            vertical-align: -2px;
            color: var(--brand);
            opacity: .95;
        }

        /* (Optional) Meta spot at top-right */
        .board-meta {
            grid-column: 2/3;
            grid-row: 1/2;
            align-self: start;
            justify-self: end;
            margin-top: 2px;
            font-size: 12px;
            color: #64748b;
        }

        /* ===== Description removed per request ===== */
        .board-desc {
            display: none !important
        }

        /* ===== Tag Pills ===== */
        .tag-list {
            grid-column: 1 / -1;
            grid-row: 2 / 3;
            display: flex;
            flex-wrap: wrap;
            gap: 6px 6px;
            margin-top: 2px;
        }

        /* 초록 pill 버튼 */
        .tag-chip {
            display: inline-flex;
            align-items: center;
            user-select: none;
            padding: 4px 12px;
            font-size: 12px;
            font-weight: 700;
            line-height: 1.6;
            white-space: nowrap;
            color: var(--chip-text);
            background: linear-gradient(180deg, var(--chip-bg), #f6fbf8);
            border: 1px solid var(--chip-border);
            border-radius: 999px;
            text-decoration: none !important;
            border-bottom: 0 !important;
            transition: background .15s, border-color .15s, box-shadow .15s;
            cursor: default; /* 버튼처럼 보이되 클릭 이동 아님 */
        }

        .tag-chip:hover {
            background: linear-gradient(180deg, var(--chip-bg-hover), #f6fbf8);
            border-color: var(--chip-border-hover);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, .7),
            0 1px 3px rgba(16, 185, 129, .12);
        }

        .tag-chip:active {
            background: var(--chip-bg-active);
            box-shadow: inset 0 1px 2px rgba(20, 83, 45, .12);
        }

        .tag-chip:focus-visible {
            outline: 0;
            box-shadow: 0 0 0 2px rgba(16, 185, 129, .25),
            inset 0 1px 0 rgba(255, 255, 255, .65);
        }

        .tag-chip {
            background: var(--chip-bg) !important; /* 그라데이션 제거 */
            border: 1px solid var(--chip-border) !important; /* 전체 테두리 복구(아래 포함) */
            box-shadow: none !important; /* 내부 하이라이트 제거 */
        }

        /* 호버/포커스/액티브도 동일한 모양 유지 */
        .tag-chip:hover,
        .board-card:hover .tag-chip,
        .board-card:active .tag-chip,
        .board-card:focus .tag-chip,
        .board-card:focus-visible .tag-chip {
            background: var(--chip-bg) !important;
            border-color: var(--chip-border) !important;
            box-shadow: none !important;
        }

        .board-card:active .tag-chip {
            background: var(--chip-bg-active)
        }

        .board-card:focus-visible .tag-chip {
            box-shadow: var(--chip-ring)
        }

        /* ===== Skeleton ===== */
        .skeleton {
            background: linear-gradient(90deg, #f3f4f6, #e5e7eb, #f3f4f6);
            background-size: 200% 100%;
            animation: shimmer 1.1s infinite;
        }

        @keyframes shimmer {
            0% {
                background-position: 200% 0
            }
            100% {
                background-position: -200% 0
            }
        }

        .board-card.skel {
            height: 100%
        }

        .board-card.skel .board-name,
        .board-card.skel .board-desc {
            height: 14px;
            border-radius: 7px
        }

        .board-card.skel .board-name {
            width: 60%
        }

        .board-card.skel .board-desc {
            width: 80%;
            margin-top: 8px
        }

        /* ===== Small screens ===== */
        @media (max-width: 576px) {
            .board-name {
                font-size: 16px
            }
        }

        /* === Entry Button Guard & Toast === */
        .enter-wrap {
            position: relative;
            display: inline-block;
        }

        .enter-guard {
            position: absolute;
            inset: 0;
            display: none;
        }

        .btn-enter[disabled] + .enter-guard {
            display: block;
            cursor: not-allowed;
        }

        .entry-toast {
            position: fixed;
            top: 16px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(33, 37, 41, .95);
            color: #fff;
            padding: 10px 14px;
            border-radius: 10px;
            font-size: 14px;
            z-index: 2000;
            box-shadow: 0 8px 24px rgba(0, 0, 0, .2);
            opacity: 0;
            transition: opacity .15s ease;
        }

        .entry-toast.show {
            opacity: 1;
        }
    </style>

    <jsp:include page="/WEB-INF/views/include/top.jsp"/>
</head>

<body>

<main class="entry-wrap">
    <div class="page-header" style="margin-bottom: 20px;">
        <h2>업종별 커뮤니티</h2>
    </div>
    <div class="title-info"
         style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
        <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
            <p class="mb-0">다양한 업종의 사람들과 교류하며 아이디어와 노하우를 공유하는 소통 공간입니다.</p>
        </div>
    </div>
    <!-- 상단 빠른 이동 바 -->
    <nav class="entry-bar" aria-label="업종별 빠른 이동">
        <div class="bar-inner">
            <select id="mainCategorySelect" aria-label="대분류 선택">
                <option value="">대분류 선택</option>
                <c:forEach var="mainCat" items="${mainCategories}">
                    <option value="${mainCat.bizCodeId}">${mainCat.bizName}</option>
                </c:forEach>
            </select>

            <select id="subCategorySelect" aria-label="중분류 선택">
                <option value="">중분류 선택</option>
            </select>

            <div class="enter-wrap">
                <button type="button" id="enterBtn" class="btn-enter" disabled>입장</button>
                <span id="enterGuard" class="enter-guard" aria-hidden="true"></span></div>
        </div>
    </nav>

    <!-- 본문 2단 레이아웃 -->
    <section class="entry-main">
        <!-- 좌측: 테마 -->
        <aside class="themes-col" aria-label="상황별 테마">
            <h3 class="visually-hidden">상황별 테마</h3>
            <div class="themes-grid" id="themesGrid">
                <button type="button" class="theme-card" data-theme="best_menu">
                    <div class="title">가장 HOT한 인기커뮤니티</div>
                    <div class="desc">놓치지 말아야 할 인기 커뮤니티</div>
                </button>

                <button type="button" class="theme-card" data-theme="weekend_escape">
                    <div class="title">여행·맛집·힐링이 하고 싶을 때</div>
                    <div class="desc">숙박·운송·맛집·레저를 한 번에</div>
                </button>

                <button type="button" class="theme-card" data-theme="digital_now">
                    <div class="title">최신 디지털콘텐츠가 궁금할 때</div>
                    <div class="desc">IT·통신·미디어·전자</div>
                </button>

                <button type="button" class="theme-card" data-theme="money_home">
                    <div class="title">금융·부동산·보험이 고민될 때</div>
                    <div class="desc">금융·보험·부동산</div>
                </button>

                <button type="button" class="theme-card" data-theme="care_health">
                    <div class="title">건강과 돌봄이 필요할 때</div>
                    <div class="desc">의료·복지·의약·의료기기</div>
                </button>

                <button type="button" class="theme-card" data-theme="build_green">
                    <div class="title">건설하고 정리하고 싶을 때</div>
                    <div class="desc">건설·제조·에너지·환경</div>
                </button>
            </div>
        </aside>

        <!-- 우측: 프리뷰 -->
        <section class="preview-pane" id="previewPane" aria-live="polite">
            <header class="preview-head">
                <div class="preview-title">테마를 올려보면 오른쪽에 미리보기가 떠요</div>
                <div class="preview-note">항목을 클릭하면 바로 입장</div>
            </header>
            <div class="boards-grid" id="boardsGrid"></div>
        </section>
    </section>
</main>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // ====== 기본 엘리먼트 ======
        var contextPath = "${pageContext.request.contextPath}";
        var mainCategorySelect = document.getElementById('mainCategorySelect');
        var subCategorySelect = document.getElementById('subCategorySelect');
        var enterBtn = document.getElementById('enterBtn');
        var enterGuard = document.getElementById('enterGuard');

        function notify(msg) {
            var t = document.getElementById('entryToast');
            if (!t) {
                t = document.createElement('div');
                t.id = 'entryToast';
                t.className = 'entry-toast';
                document.body.appendChild(t);
            }
            t.textContent = msg;
            t.classList.add('show');
            setTimeout(function () {
                t.classList.remove('show');
            }, 1600);
        }

        function refreshEnterState() {
            var hasSub = !!(subCategorySelect && subCategorySelect.value);
            enterBtn.disabled = !hasSub;
            if (enterGuard) {
                enterGuard.style.display = hasSub ? 'none' : 'block';
            }
        }

        var boardsGrid = document.getElementById('boardsGrid');
        var previewPane = document.getElementById('previewPane');
        var themeCards = document.querySelectorAll('.theme-card');

        if (!boardsGrid || !previewPane) return;

        // ====== 테마별 고정 보드 ======
        var THEME_TO_FIXED_BOARDS = {
            best_menu: [
                {bizCodeId: 56, bizName: "음식점 및 주점업", desc: "식당·카페·주점·배달"},
                {bizCodeId: 55, bizName: "숙박업", desc: "호텔·모텔·리조트·펜션"},
                {bizCodeId: 87, bizName: "사회복지 서비스업", desc: "돌봄·요양·복지관·상담"},
                {bizCodeId: 71, bizName: "전문 서비스업", desc: "법률·회계·컨설팅·디자인"},
                {bizCodeId: 91, bizName: "스포츠 및 오락관련 서비스업", desc: "스포츠·피트니스·레저·공연"},
                {bizCodeId: 49, bizName: "육상 운송 및 파이프라인 운송업", desc: "택배·화물 운송"},
                {bizCodeId: 94, bizName: "협회 및 단체", desc: "산업협회·직능단체·노동조합"},
                {bizCodeId: 62, bizName: "컴퓨터 프로그래밍, 시스템 통합 및 관리업", desc: "SI·SM·클라우드·백/프론트"},
                {bizCodeId: 10, bizName: "식료품 제조업", desc: "가공식품·간편식·제과"}
            ],
            weekend_escape: [
                {bizCodeId: 49, bizName: "육상 운송 및 파이프라인 운송업", desc: "택배·화물 운송"},
                {bizCodeId: 50, bizName: "수상 운송업", desc: "여객·화물 선박"},
                {bizCodeId: 51, bizName: "항공 운송업", desc: "항공 여객·화물"},
                {bizCodeId: 52, bizName: "창고 및 운송관련 서비스업", desc: "보관·피킹·3PL"},
                {bizCodeId: 55, bizName: "숙박업", desc: "호텔·모텔·리조트"},
                {bizCodeId: 56, bizName: "음식점 및 주점업", desc: "식당·카페·주점"},
                {bizCodeId: 10, bizName: "식료품 제조업", desc: "가공식품·간편식·제과"}
            ],
            digital_now: [
                {bizCodeId: 59, bizName: "영상·오디오 기록물 제작 및 배급업", desc: "영상·음원 제작/배급"},
                {bizCodeId: 60, bizName: "방송 및 영상·오디오물 제공 서비스업", desc: "지상파·케이블·OTT"},
                {bizCodeId: 61, bizName: "우편 및 통신업", desc: "우편·통신망"},
                {bizCodeId: 62, bizName: "컴퓨터 프로그래밍, 시스템 통합 및 관리업", desc: "SI·SM·클라우드"},
                {bizCodeId: 63, bizName: "정보서비스업", desc: "포털·플랫폼·데이터"}
            ],
            money_home: [
                {bizCodeId: 64, bizName: "금융업", desc: "은행·증권·카드"},
                {bizCodeId: 65, bizName: "보험업", desc: "생·손보·GA"},
                {bizCodeId: 66, bizName: "금융 및 보험관련 서비스업", desc: "여신심사·대출중개·결제"},
                {bizCodeId: 68, bizName: "부동산업", desc: "매매·임대·중개"}
            ],
            care_health: [
                {bizCodeId: 84, bizName: "공공 행정, 국방 및 사회보장 행정", desc: "지자체·공공기관"},
                {bizCodeId: 85, bizName: "교육 서비스업", desc: "학교·학원·평생교육"},
                {bizCodeId: 86, bizName: "보건업", desc: "병원·의원·약국"},
                {bizCodeId: 87, bizName: "사회복지 서비스업", desc: "돌봄·요양·복지관"},
                {bizCodeId: 90, bizName: "창작, 예술 및 여가관련 서비스업", desc: "공연·전시·문화"},
                {bizCodeId: 91, bizName: "스포츠 및 오락관련 서비스업", desc: "스포츠·레저"}
            ],
            build_green: [
                {bizCodeId: 37, bizName: "하수, 폐수 및 분뇨 처리업", desc: "하수처리·정화"},
                {bizCodeId: 38, bizName: "폐기물 수집, 운반, 처리 및 원료 재생업", desc: "수거·운반·재활용"},
                {bizCodeId: 39, bizName: "환경 정화 및 복원업", desc: "오염정화·복원"},
                {bizCodeId: 41, bizName: "종합 건설업", desc: "주택·상가·인프라"},
                {bizCodeId: 42, bizName: "전문직별 공사업", desc: "전기·설비·토목"}
            ]
        };

        // ====== 업종코드 → 아이콘 ======
        var BIZ_ICON_BY_ID = {
            56: 'restaurant', 55: 'hotel', 87: 'groups', 71: 'work', 91: 'sports_soccer',
            49: 'local_shipping', 50: 'directions_boat', 51: 'flight', 52: 'inventory',
            94: 'group_work', 62: 'computer', 63: 'language', 10: 'restaurant_menu',
            59: 'movie', 60: 'live_tv', 61: 'local_post_office', 64: 'account_balance',
            65: 'verified_user', 66: 'credit_card', 68: 'home_work', 84: 'account_balance',
            85: 'school', 86: 'local_hospital', 90: 'theaters', 41: 'build', 42: 'build'
        };

        // ====== 유틸: XSS 방지 ======
        function escapeHtml(s) {
            return String(s)
                .replace(/&/g, '&amp;').replace(/</g, '&lt;')
                .replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#39;');
        }

        // ====== (옵션) 스켈레톤 ======
        function setSkeleton(n) {
            n = n || 12;
            boardsGrid.innerHTML = '';
            for (var i = 0; i < n; i++) {
                var sk = document.createElement('div');
                sk.className = 'board-card skel';
                sk.innerHTML =
                    '<div class="board-body">' +
                    '  <div class="board-name skeleton"></div>' +
                    '  <div class="board-desc skeleton"></div>' +
                    '</div>';
                boardsGrid.appendChild(sk);
            }
        }

        // ====== 렌더러 (태그 pill 포함) ======
        function renderBoards(items, label) {
            var titleEl = previewPane.querySelector('.preview-title');
            if (titleEl) titleEl.textContent = label || '추천 게시판';

            boardsGrid.innerHTML = '';
            if (!items || !items.length) {
                boardsGrid.innerHTML = '<div class="text-secondary">해당 목록이 없습니다.</div>';
                return;
            }

            for (var i = 0; i < items.length && i < 18; i++) {
                var it = items[i];
                var href = contextPath + '/comm/free/' + it.bizCodeId;
                var iconName = BIZ_ICON_BY_ID[it.bizCodeId] || 'folder';

                // 태그: it.tags 배열 > parentName 분리 > desc 분리 (fallback)
                var tags = Array.isArray(it.tags) ? it.tags.slice(0, 6)
                    : it.parentName ? String(it.parentName).split(/[,\s·|/]+/).filter(Boolean).slice(0, 6)
                        : it.desc ? String(it.desc).split(/[,\s·|/]+/).filter(Boolean).slice(0, 6)
                            : [];

                var tagsHtml = tags.length
                    ? '<div class="tag-list">' +
                    tags.map(function (t) {
                        return '<span class="tag-chip">' + escapeHtml(t) + '</span>';
                    }).join('') +
                    '</div>'
                    : '';

                var name =
                    '<div class="board-name">' +
                    '<span class="material-icons mi" aria-hidden="true">' + iconName + '</span>' +
                    escapeHtml(it.bizName || '') +
                    '</div>';

                var desc = it.desc ? '<div class="board-desc">' + escapeHtml(it.desc) + '</div>' : '';

                var html =
                    '<a class="board-card" data-biz-id="' + it.bizCodeId + '" href="' + href + '">' +
                    '<div class="board-body">' + name + tagsHtml + desc + '</div>' +
                    '</a>';

                boardsGrid.insertAdjacentHTML('beforeend', html);
            }
        }

        // ====== 상단 네비(대/중분류) ======
        if (mainCategorySelect && subCategorySelect && enterBtn) {
            mainCategorySelect.addEventListener('change', function () {
                subCategorySelect.innerHTML = '<option value="">중분류 선택</option>';
                enterBtn.disabled = true;
                refreshEnterState();
                if (!this.value) return;

                fetch(contextPath + '/comm/sub-categories/' + this.value, {
                    credentials: 'same-origin',
                    headers: {'Accept': 'application/json'}
                })
                    .then(function (r) {
                        if (!r.ok) throw new Error('중분류 로드 실패');
                        return r.json();
                    })
                    .then(function (subs) {
                        (subs || []).forEach(function (item) {
                            var opt = document.createElement('option');
                            opt.value = item.bizCodeId;
                            opt.textContent = item.bizName;
                            subCategorySelect.appendChild(opt);
                        });
                    })
                    .catch(function (e) {
                        console.error(e);
                    });
            });

            subCategorySelect.addEventListener('change', function () {
                refreshEnterState();
            });


            if (enterGuard) {
                enterGuard.addEventListener('click', function (e) {
                    e.preventDefault();
                    notify('중분류도 선택해주세요');
                });
            }

            enterBtn.addEventListener('click', function () {
                var id = subCategorySelect.value;
                if (!id) return;
                location.href = contextPath + '/comm/free/' + id;
            });
        }

        // ====== 테마 Hover 프리뷰 ======
        var hoverTimer = null;

        function showPreviewFor(cardEl) {
            var key = cardEl.getAttribute('data-theme');
            var labelNode = cardEl.querySelector('.title');
            var label = labelNode ? labelNode.textContent.trim() : '';

            clearTimeout(hoverTimer);
            hoverTimer = setTimeout(function () {
                var list = (THEME_TO_FIXED_BOARDS[key] || []).map(function (x) {
                    return {
                        bizCodeId: x.bizCodeId,
                        bizName: x.bizName,
                        desc: x.desc,
                        parentName: ''                 // 필요시 서버 데이터에 맞춰 채움
                    };
                });
                renderBoards(list, label);
            }, 100);
        }

        themeCards.forEach(function (card) {
            card.addEventListener('mouseenter', function () {
                showPreviewFor(card);
            });
            card.addEventListener('focus', function () {
                showPreviewFor(card);
            });
            card.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    showPreviewFor(card);
                }
            });
        });

        // ====== 초기 상태 ======
        boardsGrid.innerHTML = ''; // 혹은 setSkeleton();
        refreshEnterState();
    });
</script>

</body>
</html>
