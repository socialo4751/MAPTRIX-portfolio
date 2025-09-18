<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="preload"
      href="https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff"
      as="font" type="font/woff" crossorigin>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<style>
    /* 폰트 */
    @font-face {
        font-family: 'GongGothicMedium';
        src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff') format('woff');
        font-weight: 700;
        font-style: normal;
    }

    .sidebar {
        width: 250px;
        display: flex;
        flex-direction: column;
        align-items: center;
        flex-shrink: 0;
        border-radius: 3px;
        margin-right: 15px;
    }

    .menu-header-box {
        background: linear-gradient(135deg, rgba(4, 26, 47, 0.87), #0a3d62);
        color: #fff;
        text-align: center;
        font-size: 30px;
        font-weight: bold;
        padding: 30px 0;
        border-radius: .5rem;
        margin-bottom: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, .1);
        width: 100%;
        font-family: 'GongGothicMedium', sans-serif;
    }

    .sidebar-menu {
        color: #000;
        width: 100%;
    }

    .accordion-menu {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .accordion-menu > li {
        width: 100%;
        border-bottom: 1px solid #eee;
    }

    .accordion-menu > li:last-child {
        border-bottom: none;
    }

    /* 상위 토글을 nav-link처럼 */
    .accordion-toggle {
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 12px 16px;
        font-size: 1.05em;
        color: #000;
        text-decoration: none;
        transition: background-color .3s ease, color .3s ease;
        border-radius: 8px;
        box-sizing: border-box;
        gap: 10px;
        background: transparent;
        border: 0;
        cursor: pointer;
    }

    .accordion-toggle .label {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .accordion-toggle:hover {
        background: linear-gradient(90deg, #ddd);
        color: #000 !important;
    }

    .accordion-toggle.active {
        background: linear-gradient(90deg, #0a3d62);
        color: #fff !important;
    }

    /* 하위 메뉴 */
    .accordion-content {
        display: none;
        padding: 10px 0 10px 25px;
        border-left: 2px solid #eee;
        margin: 0 0 8px 14px;
    }

    .accordion-content li {
        list-style: none;
    }

    .accordion-content li a {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 0;
        font-size: .98em;
        color: #333;
        text-decoration: none;
        border-radius: 6px;
    }

    .accordion-content li a:hover {
        text-decoration: underline;
    }

    .accordion-content li a.active {
        color: #0a3d62;
        font-weight: 600;
    }

    /* 화살표 회전 */
    .chevron {
        transition: transform .25s ease;
    }

    .accordion-toggle[aria-expanded="true"] .chevron {
        transform: rotate(180deg);
    }
</style>

<aside class="sidebar">
    <div class="menu-header-box">마이페이지</div>

    <nav class="sidebar-menu">
        <ul class="accordion-menu">
            <!-- 나의 정보 -->
            <li>
                <a href="javascript:;"
                   class="accordion-toggle ${activeMenu eq 'profile' ? 'active' : ''}"
                   aria-expanded="${activeMenu eq 'profile' ? 'true' : 'false'}">
                    <span class="label"><i class="bi bi-person-circle"></i> <span class="text-label">나의 정보</span></span>
                    <i class="bi bi-chevron-down chevron"></i>
                </a>
                <ul class="accordion-content" style="${activeMenu eq 'profile' ? 'display:block;' : ''}">
                    <li><a class="${activeSub eq 'profile' ? 'active' : ''}" href="/my/profile">회원정보 관리</a></li>
                    <li><a class="${activeSub eq 'biz' ? 'active' : ''}" href="/my/profile/biznum">내 가게 등록</a></li>
                    <li><a class="${activeSub eq 'preference' ? 'active' : ''}" href="/my/profile/preference">관심구역 &
                        관심업종</a></li>
                    <li><a class="${activeSub eq 'del' ? 'active' : ''}" href="/my/profile/del">회원 탈퇴</a></li>
                </ul>
            </li>

            <!-- 분석 및 지표 다운로드 -->
            <li>
                <a href="javascript:;"
                   class="accordion-toggle ${activeMenu eq 'report' ? 'active' : ''}"
                   aria-expanded="${activeMenu eq 'report' ? 'true' : 'false'}">
                    <span class="label"><i class="bi bi-graph-up-arrow"></i> <span
                            class="text-label">분석 및 지표 다운로드</span></span>
                    <i class="bi bi-chevron-down chevron"></i>
                </a>
                <ul class="accordion-content" style="${activeMenu eq 'report' ? 'display:block;' : ''}">
                    <li><a class="${activeSub eq 'history' ? 'active' : ''}" href="/my/report">이력조회 및 다운로드</a></li>
                </ul>
            </li>

            <!-- 활동 내역 조회 -->
            <li>
                <a href="javascript:;"
                   class="accordion-toggle ${activeMenu eq 'activity' ? 'active' : ''}"
                   aria-expanded="${activeMenu eq 'activity' ? 'true' : 'false'}">
                    <span class="label"><i class="bi bi-chat-dots"></i> <span class="text-label">활동 내역 조회</span></span>
                    <i class="bi bi-chevron-down chevron"></i>
                </a>
                <ul class="accordion-content" style="${activeMenu eq 'activity' ? 'display:block;' : ''}">
                    <li><a class="${activeSub eq 'comm' ? 'active' : ''}" href="/my/post/comm">커뮤니티 활동 내역</a></li>
                    <li><a class="${activeSub eq 'activity' ? 'active' : ''}" href="/my/post/activity">그외 게시판 활동 내역</a></li>
                    <li><a class="${activeSub eq 'alarm' ? 'active' : ''}" href="/my/nt/history">알림 내역</a></li>
                </ul>

            </li>

            <!-- 신청 현황 조회 -->
            <li>
                <a href="javascript:;"
                   class="accordion-toggle ${activeMenu eq 'apply' ? 'active' : ''}"
                   aria-expanded="${activeMenu eq 'apply' ? 'true' : 'false'}">
                    <span class="label"><i class="bi bi-folder2-open"></i> <span
                            class="text-label">신청 현황 조회</span></span>
                    <i class="bi bi-chevron-down chevron"></i>
                </a>
                <ul class="accordion-content" style="${activeMenu eq 'apply' ? 'display:block;' : ''}">
                    <li><a class="${activeSub eq 'stampbiz' ? 'active' : ''}" href="/my/bizapply/status">스탬프 가맹신청 현황</a></li>
                    <li><a class="${activeSub eq 'openapi' ? 'active' : ''}" href="/my/openapi/status">OPEN API 신청 현황</a></li>
                </ul>

            </li>
        </ul>
    </nav>
</aside>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 기존 jQuery 아코디언 로직 유지 + 디자인 상태(aria/active) 동기화
    $(function () {
        $('.accordion-toggle').on('click', function () {
            const $btn = $(this);
            const $content = $btn.next('.accordion-content');
            const isOpen = $content.is(':visible');

            // 다른 열린 메뉴 닫기 (색칠은 유지)
            $('.accordion-content:visible').not($content).slideUp(180).prev('.accordion-toggle')
                .attr('aria-expanded', 'false');

            // 현재 메뉴 토글
            if (isOpen) {
                $content.slideUp(180);
                $btn.attr('aria-expanded', 'false');
            } else {
                $content.slideDown(180);
                $btn.attr('aria-expanded', 'true');
            }
        });

        // (옵션) 특정 섹션 기본 펼침: li에 .open 클래스 주면 시작 시 펼침
        $('.accordion-menu > li.open').each(function () {
            const $btn = $(this).children('.accordion-toggle');
            const $content = $(this).children('.accordion-content');
            $content.show();
            $btn.attr('aria-expanded', 'true');
        });
    });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
