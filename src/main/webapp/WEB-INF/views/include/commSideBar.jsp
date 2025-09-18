<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="preload"
      href="https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff"
      as="font"
      type="font/woff"
      crossorigin>
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
        background: linear-gradient(135deg, rgba(4, 26, 47, 0.87), #0a3d62);
        color: #fff;
        text-align: center;
        font-size: 30px;
        font-weight: bold;
        padding: 30px 0;
        border-radius: 0.5rem;
        margin-bottom: 30px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        width: 100%;
        font-family: 'GongGothicMedium', sans-serif;
    }

    .sidebar-menu {
        color: #000;
        width: 100%;
    }

    .sidebar-menu ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar-menu .nav-item {
        width: 100%;
        border-bottom: 1px solid #eee;
    }

    .sidebar-menu .nav-link {
        width: 100%;
        display: flex;
        align-items: center;
        padding: 12px 20px;
        font-size: 1.1em;
        color: #000;
        text-decoration: none;
        transition: background-color 0.3s ease, color 0.3s ease;
        border-radius: 8px;
        box-sizing: border-box;
    }

    .sidebar-menu .nav-link:hover {
        background: linear-gradient(90deg, #ddd);
        color: #000 !important;
    }

    .sidebar-menu .nav-link.active {
        background: linear-gradient(90deg, #0a3d62);
        color: #fff !important;
    }
</style>

<aside class="sidebar">
    <div class="menu-header-box">
        커뮤니티
    </div>
    <nav class="sidebar-menu">
        <ul>
            <li class="nav-item">
                <a class="nav-link ${activeMenu eq 'entry' ? 'active' : ''}" href="<c:url value='/comm/entry' />">
                    <i class="bi bi-chat-dots-fill me-2"></i> 업종별 커뮤니티
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeMenu eq 'news' ? 'active' : ''}" href="<c:url value='/comm/news' />">
                    <i class="bi bi-newspaper me-2"></i> 상권 뉴스
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeMenu eq 'review' ? 'active' : ''}" href="<c:url value='/comm/review' />">
                    <i class="bi bi-journal-text me-2"></i> 창업 후기
                </a>
            </li>
        </ul>
    </nav>
</aside>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
