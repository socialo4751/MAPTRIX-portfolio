<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 관리자 레이아웃에 맞는 사이드바 디자인 -->
<style>
    @font-face {
        font-family: 'Pretendard-Regular';
        src: url('https://fastly.jsdelivr.net/gh/Project-Noonnu/noonfonts_2107@1.1/Pretendard-Regular.woff') format('woff');
        font-weight: 400;
        font-style: normal;
    }

    #sidebar {
        width: 260px;
        background-color: #0a3d62;
        color: #ecf0f1;
        padding-top: 20px;
        box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
        overflow-y: auto;
        flex-shrink: 0;
        min-height: 100vh;
        font-family: 'Pretendard-Regular', sans-serif;
    }

    #sidebar nav ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    #sidebar nav ul li {
        border-bottom: 1px solid rgba(255, 255, 255, 0.04);
    }

    #sidebar nav ul li:last-child {
        border-bottom: none;
    }

    #sidebar nav ul li a {
        color: #ecf0f1;
        text-decoration: none;
        display: flex;
        align-items: center;
        padding: 14px 22px;
        transition: background-color 0.2s ease-in-out;
        font-size: 16px;
        font-weight: 500;
        gap: 10px;
    }

    #sidebar nav ul li a:hover {
        background-color: #0c4d7f;
        color: #ffffff;
    }

    #sidebar nav ul li.active > a {
        background-color: #0d588f;
        color: #ffffff;
        font-weight: bold;
    }

    #sidebar nav ul .submenu {
        background-color: #0b456e;
        display: none;
        overflow: hidden;
        transition: max-height 0.3s ease;
    }

    #sidebar nav ul .submenu.active {
        display: block;
    }

    #sidebar nav ul .submenu li a {
        padding: 10px 36px;
        font-size: 15px;
        color: #d0e3f7;
        background-color: transparent;
    }

    #sidebar nav ul .submenu li a:hover {
        background-color: #0d588f;
        color: #ffffff;
    }

    #sidebar nav ul .submenu li.active > a {
        background-color: transparent;
        color: #fff;
        font-weight: 600;
    }
</style>

<aside id="sidebar">
    <nav>
        <ul>
            <li class="${activeMenu=='admin' ? 'active' : ''}">
                <a href="<c:url value='/admin'/>">
                    <i class="bi bi-speedometer2"></i> 대시보드
                </a>
            </li>
            <li class="${activeMenu=='userManagement' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="userManagement">
                    <i class="bi bi-people-fill"></i> 회원관리
                </a>
                <ul id="userManagement" class="submenu ${activeMenu=='userManagement' ? 'active' : ''}">
                    <li><a href="<c:url value='/admin/users'/>">회원 상태 조회 및 관리</a></li>
                </ul>
            </li>


            <li class="${activeMenu=='postManagement' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="postManagement">
                    <i class="bi bi-layout-text-window-reverse"></i> 게시글 등록 관리
                </a>
                <ul id="postManagement" class="submenu ${activeMenu=='postManagement' ? 'active' : ''}">
                    <li><a href="<c:url value='/admin/mentoring'/>">지원사업 안내 게시판 관리</a></li>
                    <li><a href="<c:url value='/admin/news'/>">뉴스 관리</a></li>
                </ul>
            </li>
            <li class="${activeMenu=='qna' || activeMenu=='satisfaction' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="customerCenter">
                    <i class="bi bi-chat-dots-fill"></i> 고객센터 관리
                </a>
                <ul id="customerCenter"
                    class="submenu ${activeMenu=='qna' || activeMenu=='satisfaction' ? 'active' : ''}">
                    <li><a href="<c:url value='/admin/notice'/>">공지사항</a></li>
                    <li><a href="<c:url value='/admin/qna'/>">질의응답 (Q&A)</a></li>
                    <li><a href="<c:url value='/admin/faq'/>">자주 묻는 질문 (FAQ)</a></li>
                    <li><a href="<c:url value='/admin/survey'/>">설문 조사 등록 및 통계</a></li>

                </ul>
            </li>


            <li class="${activeMenu=='qna' || activeMenu=='satisfaction' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="stampAttraction">
                    <i class="bi bi-chat-dots-fill"></i>가맹사업 관리
                </a>
                <ul id="stampAttraction"
                    class="submenu ${activeMenu=='qna' || activeMenu=='satisfaction' ? 'active' : ''}">
                    <li><a href="<c:url value='/admin/apply'/>">가맹 신청 목록</a></li>
                    <li class="${activeMenu=='qna' || activeMenu=='satisfaction' ? 'active' : ''}">
                        <a href="<c:url value='/admin/apply/stats'/>">행정동별 가맹 통계</a>
                    </li>
                </ul>
            </li>


            <li class="${activeMenu=='dataManagement' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="dataManagement">
                    <i class="bi bi-bar-chart-line-fill"></i>플랫폼 통계 및 분석
                </a>
                <ul id="dataManagement" class="submenu ${activeMenu=='dataManagement' ? 'active' : ''}">
                    <li><a href="<c:url value='/admin/stats/system'/>">시스템 로그</a></li>
                    <li><a href="<c:url value='/admin/stats/market'/>">상권 분석 통계</a></li>
                    <li><a href="<c:url value='/admin/stats/user-stats'/>">플랫폼 이용 통계</a></li>
                </ul>
            </li>
            <li class="${activeMenu=='openapi' ? 'active' : ''}">
                <a href="#" class="menu-toggle" data-target="openapi">
                    <i class="bi-diagram-3-fill"></i> OPEN API 서비스 관리</a>
                <ul id="openapi" class="submenu ${activeMenu=='openapi' ? 'active' : ''}">
                    <li class="${activeSub=='applications' ? 'active' : ''}">
                        <a href="<c:url value='/admin/openapi/applications'/>">API 신청 관리</a>
                    </li>
                    <li class="${activeSub=='services' ? 'active' : ''}">
                        <a href="<c:url value='/admin/openapi/services'/>">API 등록 및 삭제</a>
                    </li>
                </ul>
            </li>
        </ul>
    </nav>
</aside>

<script>
    document.querySelectorAll('.menu-toggle').forEach(function (toggle) {
        toggle.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.getElementById(this.dataset.target);
            document.querySelectorAll('#sidebar .submenu.active').forEach(function (open) {
                if (open !== target) {
                    open.classList.remove('active');
                    open.parentElement.classList.remove('active');
                }
            });
            target.classList.toggle('active');
            this.parentElement.classList.toggle('active');
        });
    });
</script>
<script>
    (function () {
        const path = location.pathname.replace(/\/+$/, '');
        document.querySelectorAll('#sidebar .submenu a').forEach(a => {
            const hrefPath = new URL(a.href, location.origin).pathname.replace(/\/+$/, '');
            if (hrefPath === path) {
                a.parentElement.classList.add('active');               // li 활성
                const submenu = a.closest('.submenu');
                submenu?.classList.add('active');                      // ul 펼침
                submenu?.parentElement.classList.add('active');        // 상위 li 활성
            }
        });
    })();
</script>
<script>
    (function () {
        const path = location.pathname.replace(/\/+$/, '');

        // 하위(submenu) 링크 경로 매칭(기존)
        document.querySelectorAll('#sidebar .submenu a').forEach(a => {
            const hrefPath = new URL(a.href, location.origin).pathname.replace(/\/+$/, '');
            if (hrefPath === path) {
                a.parentElement.classList.add('active');
                const submenu = a.closest('.submenu');
                submenu?.classList.add('active');
                submenu?.parentElement.classList.add('active');
            }
        });

        // 상위(직접 링크) 경로 매칭 추가 ✅
        document.querySelectorAll('#sidebar > nav > ul > li > a:not(.menu-toggle)').forEach(a => {
            const hrefPath = new URL(a.href, location.origin).pathname.replace(/\/+$/, '');
            if (hrefPath && hrefPath !== '#' && hrefPath === path) {
                a.parentElement.classList.add('active');
            }
        });
    })();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>