<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="preload"
      href="https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff"
      as="font" type="font/woff" crossorigin>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<style>
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
        background: linear-gradient(135deg, rgba(4, 26, 47, .87), #0a3d62);
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
        width: 100%
    }

    .sidebar-menu ul {
        list-style: none;
        padding: 0;
        margin: 0
    }

    .sidebar-menu .nav-item {
        width: 100%;
        border-bottom: 1px solid #eee
    }

    .sidebar-menu .nav-link {
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
        gap: 8px
    }

    .sidebar-menu .nav-link .label {
        display: flex;
        align-items: center;
        gap: 8px
    }

    .sidebar-menu .nav-link:hover {
        background: linear-gradient(90deg, #ddd);
        color: #000 !important
    }

    .sidebar-menu .nav-link.active {
        background: linear-gradient(90deg, #0a3d62);
        color: #fff !important
    }

    .submenu {
        padding: 10px 0 10px 25px;
        border-left: 2px solid #eee;
        margin: 0 0 8px 14px
    }

    .submenu .sub-link {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 0;
        font-size: .98em;
        color: #333;
        text-decoration: none;
        border-radius: 6px
    }

    .submenu .sub-link:hover {
        text-decoration: underline
    }

    .submenu .sub-link.active {
        color: #0a3d62;
        font-weight: 600
    }

    .chevron {
        transition: transform .25s ease
    }

    .nav-link[aria-expanded="true"] .chevron {
        transform: rotate(180deg)
    }

    .sidebar-menu .nav-item:last-child {
        border-bottom: none
    }
</style>

<aside class="sidebar">
    <div class="menu-header-box">사이트 소개</div>

    <nav class="sidebar-menu">
        <ul>
            <li class="nav-item">
                <a class="nav-link ${activeMenu eq 'introduce' ? 'active' : ''}" href="<c:url value='/intro' />">
                    <span class="label"><i class="bi bi-info-circle-fill"></i> 소개</span>
                </a>
            </li>

            <!-- ✅ 조직안내 (부모) + 조직도/직원안내 (자식) -->
            <li class="nav-item">
                <button type="button"
                        id="btn-org-guide"
                        class="nav-link ${activeMenu eq 'orgGuide' ? 'active' : ''}"
                        aria-expanded="${activeMenu eq 'orgGuide' ? 'true' : 'false'}"
                        aria-controls="menu-org-guide">
                    <span class="label"><i class="bi bi-building-fill-gear"></i> 조직 안내</span>
                    <i class="bi bi-chevron-down chevron"></i>
                </button>

                <div id="menu-org-guide" class="collapse ${activeMenu eq 'orgGuide' ? 'show' : ''}">
                    <div class="submenu">
                        <a class="sub-link ${activeSub eq 'orgchart' ? 'active' : ''}"
                           href="<c:url value='/intro/org/chart'/>">
                            조직도
                        </a>
                        <a class="sub-link ${activeSub eq 'org' ? 'active' : ''}" href="<c:url value='/intro/org'/>">
                            직원 안내
                        </a>
                    </div>
                </div>
            </li>

            <!-- 연혁 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu eq 'history' ? 'active' : ''}" href="<c:url value='/intro/history' />">
                    <span class="label"><i class="bi bi-clock-history"></i>프로젝트 연혁</span>
                </a>
            </li>

        </ul>
    </nav>
</aside>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- jQuery (레이아웃에 이미 있으면 생략) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    // ✅ 아코디언: 열림/닫힘만 제어, .active는 절대 건드리지 않음
    $(function () {
        // 1) 초기 상태 동기화 (서버가 붙인 .show만 기준)
        $('.nav-item > button.nav-link[aria-controls]').each(function () {
            var $btn = $(this);
            var panelId = $btn.attr('aria-controls');
            var $panel = $('#' + panelId);
            var isOpen = $panel.hasClass('show');

            // .active는 건드리지 않음 (색칠은 서버 렌더링 책임)
            $btn.attr('aria-expanded', isOpen ? 'true' : 'false');

            // jQuery slide와 충돌 막기 위해 display를 명시
            if (isOpen) $panel.stop(true, true).show();
            else $panel.stop(true, true).hide();
        });

        // 2) 클릭 토글 (한번에 하나만 열기) — .active는 건드리지 않음
        $('.nav-item > button.nav-link[aria-controls]').on('click', function (e) {
            e.preventDefault();

            var $btn = $(this);
            var panelId = $btn.attr('aria-controls');
            var $panel = $('#' + panelId);
            var isOpen = $panel.is(':visible');

            // (a) 다른 열린 패널 닫기 — 그 버튼의 .active는 유지
            $('.sidebar .collapse:visible').not($panel).each(function () {
                var $p = $(this);
                var id = this.id;
                $p.stop(true, true).slideUp(180).removeClass('show');
                $('.nav-item > button.nav-link[aria-controls="' + id + '"]')
                    .attr('aria-expanded', 'false'); // 색칠(.active) 유지
            });

            // (b) 대상 패널 토글 — .active는 변경하지 않음
            if (isOpen) {
                $panel.stop(true, true).slideUp(180).removeClass('show');
                $btn.attr('aria-expanded', 'false');
            } else {
                $panel.stop(true, true).slideDown(180).addClass('show');
                $btn.attr('aria-expanded', 'true');
            }
        });

        // 3) (옵션) 하위 링크 자동 활성 — 필요 없으면 삭제
        var uri = window.location.pathname || '';
        if (!$('.submenu .sub-link.active').length) {
            $('.submenu .sub-link').each(function () {
                var href = $(this).attr('href');
                if (href && uri.indexOf(href) === 0) $(this).addClass('active');
            });
        }
    });
</script>