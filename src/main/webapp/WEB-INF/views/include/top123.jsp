<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!-- Trendy Top (Header + Nav) - h6 제거, 수직 단일 리스트 드롭다운, URL/구조 유지 -->

<style>
:root{
  --top-bg: rgba(255,255,255,0.65);
  --top-border: rgba(0,0,0,0.06);
  --text-strong: #111;
  --text-muted: #6c757d;
  --brand: #0a3d62;
}

/* Reset-ish */
.header, .topbar, .nav, .mega, .util { box-sizing: border-box; }
a{ text-decoration:none; color:inherit; }
button{ background:none; border:0; }

/* Sticky translucent topbar (video-friendly) */
.topbar{
  position: sticky; top: 0; z-index: 1000;
  backdrop-filter: saturate(180%) blur(10px);
  background: var(--top-bg);
  border-bottom: 1px solid var(--top-border);
}
.top-inner{
  max-width: 1240px; margin: 0 auto;
  padding: 12px 16px; display:flex; align-items:center; gap:12px;
}

/* Left: Logo */
.brand{ display:flex; align-items:center; gap:10px; font-weight:800; letter-spacing:.2px; }
.brand-img img{height:28px; width:auto; display:block;}
.brand span{ color:var(--text-strong); font-size:18px; }
.brand small{ color:var(--text-muted); font-weight:600; }

/* Center: Primary nav */
.nav{ margin-left: 16px; display:flex; align-items:center; gap:8px; }
.nav > li{ position:relative; list-style:none; }
.nav > li > a{
  display:flex; align-items:center; gap:6px;
  padding:10px 12px; border-radius:10px;
  font-weight:600; color:#222;
}
.nav > li > a:hover{ background:rgba(0,0,0,0.05); }

/* Mega dropdown (simplified vertical list) */
.mega{
  position:absolute; left:0; top:100%;
  padding:10px; display:none;
  background:#fff; border:1px solid var(--top-border); border-radius:12px;
  box-shadow:0 10px 26px rgba(0,0,0,0.1);
  min-width: 260px;
}
.nav > li:hover .mega{ display:block; }

.mega-list{ display:flex; flex-direction:column; gap:6px; }
.mega-list a{
  font-size:13px; padding:8px 10px; border-radius:8px; color:#222; background:#f7f8f9;
}
.mega-list a:hover{ background:#eef1f4; }

/* Right: Utility */
.util{ margin-left:auto; display:flex; align-items:center; gap:10px; }
.util .pill{
  display:inline-flex; align-items:center; gap:8px;
  padding:6px 10px; border-radius:999px; background:#fff; border:1px solid var(--top-border);
  font-size:12px; color:#333;
}
.util .btn{
  padding:8px 12px; border-radius:10px; font-weight:700; border:1px solid var(--top-border);
}
.util .btn.primary{ background:var(--brand); color:#fff; border-color:var(--brand); }

/* Mobile */
.mbtn{ display:none; margin-left:8px; }
.mbtn button{
  width:40px; height:40px; border-radius:10px; border:1px solid var(--top-border);
}
@media (max-width: 1100px){
  .nav{ display:none; }
  .mbtn{ display:block; }
}

/* Mobile Drawer */
.drawer{ position:fixed; inset:0; display:none; background: rgba(0,0,0,.35); }
.drawer.open{ display:block; }
.drawer .panel{
  position:absolute; right:0; top:0; height:100%; width:86%;
  max-width:420px; background:#fff; border-left:1px solid var(--top-border);
  display:flex; flex-direction:column;
}
.drawer .p-head{ padding:14px 14px; display:flex; align-items:center; justify-content:space-between; border-bottom:1px solid var(--top-border); }
.drawer .p-body{ padding:8px 8px 16px 8px; overflow:auto; }
.acco{ border:1px solid #eee; border-radius:12px; margin:8px; overflow:hidden; }
.acco summary{ list-style:none; cursor:pointer; padding:12px 14px; font-weight:800; }
.acco summary::-webkit-details-marker{ display:none; }
.acco .inner{ padding:8px 12px 12px 12px; display:grid; gap:6px; }
.acco a{ display:block; padding:8px 10px; border-radius:8px; color:#222; background:#f7f8f9; }
.acco a:hover{ background:#eef1f4; }

/* Compact top info (greeting) */
.greeting{ font-size:13px; color:var(--text-muted); }
</style>

<header class="topbar" role="banner" aria-label="메인 헤더">
  <div class="top-inner">
    <!-- Brand -->
    <c:if test="${empty logoPath}"><c:set var="logoPath" value="/images/MAPTRIX.png"/></c:if>
    <a href="/" class="brand brand-img" aria-label="홈으로">
      <img src="<c:url value='${logoPath}'/>" alt="대전광역시" />
    </a>

    <!-- Primary Nav (Desktop) -->
    <ul class="nav" role="menubar" aria-label="주요 메뉴">
      <!-- 상권분석 -->
      <li role="none">
        <a href="/market/simple" role="menuitem">상권분석</a>
        <div class="mega" aria-label="상권분석 하위 메뉴">
          <div class="mega-list">
            <a href="/market/simple">간단 분석</a>
            <a href="/market/detailed">상세 분석</a>
            <a href="/market/indicators">분석 지표</a>
            <a href="/biz-stats/chart">상권 통계</a>
            <a href="/biz-stats/keyword">SNS키워드 분석</a>
            <a href="/biz-stats/franchises">프랜차이즈</a>
          </div>
        </div>
      </li>

      <!-- 지역특화 정보 -->
      <li role="none">
        <a href="/attraction/apply-stamp" role="menuitem">지역특화 정보</a>
        <div class="mega" aria-label="지역특화 하위 메뉴">
          <div class="mega-list">
            <a href="/attraction">지역특화 정보</a>
            <a href="/attraction/1">My Place</a>
            <a href="/attraction/apply-stamp/intro">스탬프 소개</a>
            <a href="/attraction/apply-stamp">가맹 신청</a>
          </div>
        </div>
      </li>

      <!-- 창업 지원 -->
      <li role="none">
        <a href="/start-up/main" role="menuitem">창업 지원</a>
        <div class="mega" aria-label="창업 지원 하위 메뉴">
          <div class="mega-list">
            <a href="/start-up/test">창업 역량 테스트</a>
            <a href="/start-up/mt">멘토링 신청</a>
            <a href="/start-up/design">2D/3D 도면 설계</a>
            <a href="/start-up/show">도면 공유</a>
          </div>
        </div>
      </li>

      <!-- 커뮤니티 -->
      <li role="none">
        <a href="/comm/entry" role="menuitem">커뮤니티</a>
        <div class="mega" aria-label="커뮤니티 하위 메뉴">
          <div class="mega-list">
            <a href="/comm/entry">입장하기</a>
            <a href="/comm/board">게시판</a>
            <a href="/comm/news">상권 뉴스</a>
            <a href="/comm/review">창업 후기</a>
          </div>
        </div>
      </li>

      <!-- 고객센터 -->
      <li role="none">
        <a href="/cs/notice" role="menuitem">고객센터</a>
        <div class="mega" aria-label="고객센터 하위 메뉴">
          <div class="mega-list">
            <a href="/cs/notice">공지사항</a>
            <a href="/cs/qna">Q&A</a>
            <a href="/cs/freqna">자주 묻는 질문</a>
            <a href="/cs/praise">칭찬 게시판</a>
            <a href="/cs/survey">설문 조사</a>
            <a href="/cs/org">조직도</a>
          </div>
        </div>
      </li>

      <!-- 마이페이지 -->
      <li role="none">
        <a href="/my/profile" role="menuitem">마이페이지</a>
        <div class="mega" aria-label="마이페이지 하위 메뉴">
          <div class="mega-list">
            <a href="/my/profile">나의 정보</a>
            <a href="/my/userDlHistory">분석내역 조회</a>
            <a href="/my/stampbiz">스탬프 가맹신청 현황</a>
            <a href="/my/openapi">OPENAPI 신청 현황</a>
          </div>
        </div>
      </li>

      <!-- OPEN API -->
      <li role="none">
        <a href="/openapi" role="menuitem">OPEN API</a>
        <div class="mega" aria-label="OPEN API 하위 메뉴">
          <div class="mega-list">
            <a href="/openapi/intro">서비스 소개</a>
            <a href="/openapi">API 활용 신청</a>
          </div>
        </div>
      </li>
    </ul>

    <!-- Utility -->
    <div class="util">
      <a class="pill" href="${frontendUrl}/stampMap">스탬프 투어</a>

      <sec:authorize access="isAuthenticated()">
        <span class="greeting">환영합니다, <strong><sec:authentication property="principal.usersVO.name"/></strong>님</span>
        <a class="btn" href="/logout">로그아웃</a>
        <sec:authorize access="hasRole('ADMIN')">
          <a class="btn" href="/admin">관리자 대시보드</a>
        </sec:authorize>
      </sec:authorize>

      <sec:authorize access="isAnonymous()">
        <a class="btn" href="/login">로그인</a>
      </sec:authorize>

      <!-- Mobile Button -->
      <div class="mbtn">
        <button type="button" aria-label="메뉴 열기" onclick="document.getElementById('drawer').classList.add('open')">☰</button>
      </div>
    </div>
  </div>
</header>

<!-- Mobile Drawer -->
<aside class="drawer" id="drawer" aria-hidden="true">
  <div class="panel">
    <div class="p-head">
      <strong>메뉴</strong>
      <button type="button" aria-label="닫기" onclick="document.getElementById('drawer').classList.remove('open')">✕</button>
    </div>
    <div class="p-body">
      <details class="acco" open>
        <summary>상권분석</summary>
        <div class="inner">
          <a href="/market/simple">간단 분석</a>
          <a href="/market/detailed">상세 분석</a>
          <a href="/market/indicators">분석 지표 </a>
          <a href="/biz-stats/chart">상권 통계</a>
          <a href="/biz-stats/keyword">SNS키워드 분석</a>
          <a href="/biz-stats/franchises">프랜차이즈</a>
        </div>
      </details>

      <details class="acco">
        <summary>지역특화 정보</summary>
        <div class="inner">
          <a href="/attraction">지역특화 정보</a>
          <a href="/attraction/1">축제/인기가게/스탬프가맹점 지도</a>
          <a href="/attraction/apply-stamp/intro">스탬프 소개</a>
          <a href="/attraction/apply-stamp">가맹 신청</a>
        </div>
      </details>

      <details class="acco">
        <summary>창업 지원</summary>
        <div class="inner">
          <a href="/start-up/test">창업 역량 테스트</a>
          <a href="/start-up/mt">멘토링 신청</a>
          <a href="/start-up/design">내 가게 만들기</a>
          <a href="/start-up/show">도면 공유</a>
        </div>
      </details>

      <details class="acco">
        <summary>커뮤니티</summary>
        <div class="inner">
          <a href="/comm/entry">입장하기</a>
          <a href="/comm/board">게시판</a>
          <a href="/comm/news">상권 뉴스</a>
          <a href="/comm/review">창업 후기</a>
        </div>
      </details>

      <details class="acco">
        <summary>고객센터</summary>
        <div class="inner">
          <a href="/cs/notice">공지사항</a>
          <a href="/cs/qna">Q&A</a>
          <a href="/cs/freqna">자주 묻는 질문</a>
          <a href="/cs/praise">칭찬 게시판</a>
          <a href="/cs/survey">설문 조사</a>
          <a href="/cs/org">조직도</a>
        </div>
      </details>

      <details class="acco">
        <summary>마이페이지</summary>
        <div class="inner">
          <a href="/my/profile">나의 정보</a>
          <a href="/my/userDlHistory">분석내역 조회</a>
          <a href="/my/stampbiz">스탬프 가맹신청 현황</a>
          <a href="/my/openapi">OPENAPI 신청 현황</a>
        </div>
      </details>

      <details class="acco">
        <summary>OPEN API</summary>
        <div class="inner">
          <a href="/openapi/intro">서비스 소개</a>
          <a href="/openapi">API 활용 신청</a>
        </div>
      </details>

      <div class="inner" style="margin-top:8px;">
        <a href="${frontendUrl}/stampMap">스탬프 투어</a>
        <sec:authorize access="isAuthenticated()">
          <a href="/logout">로그아웃</a>
          <sec:authorize access="hasRole('ADMIN')">
            <a href="/admin">관리자</a>
          </sec:authorize>
        </sec:authorize>
        <sec:authorize access="isAnonymous()">
          <a href="/login">로그인</a>
        </sec:authorize>
      </div>
    </div>
  </div>
</aside>
