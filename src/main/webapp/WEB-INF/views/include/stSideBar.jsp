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

    .sidebar{width:250px;display:flex;flex-direction:column;align-items:center;flex-shrink:0;border-radius:3px;margin-right:15px;}
    .menu-header-box{background:linear-gradient(135deg,rgba(4,26,47,.87),#0a3d62);color:#fff;text-align:center;font-size:30px;font-weight:bold;padding:30px 0;border-radius:.5rem;margin-bottom:30px;box-shadow:0 4px 6px rgba(0,0,0,.1);width:100%;font-family:'GongGothicMedium',sans-serif;}
    .sidebar-menu{color:#000;width:100%}
    .sidebar-menu ul{list-style:none;padding:0;margin:0}
    .sidebar-menu .nav-item{width:100%;border-bottom:1px solid #eee}
    .sidebar-menu .nav-item:last-child{border-bottom:none}

    .sidebar-menu .nav-link{
        width:100%;display:flex;align-items:center;justify-content:space-between;
        padding:12px 16px;font-size:1.05em;color:#000;text-decoration:none;
        transition:background-color .3s ease,color .3s ease;border-radius:8px;
        box-sizing:border-box;gap:8px
    }
    .sidebar-menu .nav-link .label{display:flex;align-items:center;gap:8px}
    .sidebar-menu .nav-link:hover{background:linear-gradient(90deg,#ddd);color:#000!important}
    .sidebar-menu .nav-link.active{background:linear-gradient(90deg,#0a3d62);color:#fff!important}

    /* 아이콘/박스모델 통일 */
    .sidebar .label .bi{font-size:1rem;line-height:1}
    .sidebar, .sidebar *{box-sizing:border-box}
</style>

<aside class="sidebar">
    <div class="menu-header-box">
        <div>스탬프 앱</div>
    </div>

    <nav class="sidebar-menu">
        <ul>
            <li class="nav-item">
                <a class="nav-link ${activeSub eq 'intro' ? 'active' : ''}"
                   href="<c:url value='/attraction/apply-stamp/intro'/>">
                    <span class="label"><i class="bi bi-info-circle-fill"></i> 소개</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeSub eq 'applyStoreList' ? 'active' : ''}"
                   href="<c:url value='/attraction/apply-stamp/applyStoreList'/>">
                    <span class="label"><i class="bi bi-shop-window"></i>맵트릭스 가맹점</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeSub eq 'merchant' ? 'active' : ''}"
                   href="<c:url value='/attraction/apply-stamp'/>">
                    <span class="label"><i class="bi bi-shop-window"></i> 가맹 신청</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeSub eq 'policy' ? 'active' : ''}"
                   href="<c:url value='/attraction/apply-stamp/policy'/>">
                    <span class="label"><i class="bi bi-gift-fill"></i> 리워드 정책</span>
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${activeSub eq 'privacy' ? 'active' : ''}"
                   href="<c:url value='/attraction/apply-stamp/privacy'/>">
                    <span class="label"><i class="bi bi-shield-lock-fill"></i> 개인정보·보안</span>
                </a>
            </li>
        </ul>
    </nav>
</aside>

<script>
    // 선택적으로: 서버가 activeSub를 안 붙여준 경우 URL 기반으로 자동 활성화
    (function(){
        var uri = window.location.pathname || '';
        if (!document.querySelector('.sidebar .nav-link.active')) {
            document.querySelectorAll('.sidebar .nav-link[href]').forEach(function(a){
                var href = a.getAttribute('href');
                if (href && uri.indexOf(href) === 0) a.classList.add('active');
            });
        }
    })();
</script>
