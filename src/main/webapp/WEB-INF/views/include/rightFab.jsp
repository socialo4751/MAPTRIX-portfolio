<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 파라미터 기본값 세팅 --%>
<c:url var="stampIntroUrl" value="/attraction/apply-stamp/intro" />
<c:set var="fabUrl"    value="${empty param.fabUrl    ? stampIntroUrl : param.fabUrl}" />
<c:set var="fabTitle"  value="${empty param.fabTitle  ? '바로가기' : param.fabTitle}" />
<c:set var="fabSize"   value="${empty param.fabSize   ? '150' : param.fabSize}" />
<c:set var="fabTarget" value="${empty param.fabTarget ? '_self' : param.fabTarget}" />

<%-- 기본 fabText(실제 개행 포함). param이 있으면 그걸 사용 --%>
<c:choose>
  <c:when test="${not empty param.fabText}">
    <c:set var="fabText" value="${param.fabText}" />
  </c:when>
  <c:otherwise>
    <c:set var="fabText">스탬프 앱에 대해
궁금하신가요?</c:set>
  </c:otherwise>
</c:choose>

<%-- 개행 치환용 토큰 --%>
<c:set var="NL">
</c:set>
<c:set var="SLASHN" value="\\n" />
<c:set var="BR" value="<br/>" />

<style>
  /* ===== Right Fixed Text-only FAB — Glossy Sticker Variant ===== */
  #rightFab {
    --fab-size: ${fabSize}px;
    --fab-bg-1: #fff79c;    /* 하이라이트 톤 */
    --fab-bg-2: #ffe732;    /* 기본 베이스 */
    --fab-bg-3: #ffc400;    /* 가장자리 살짝 진한 톤 */
    --fab-text: #061a2a;

    position: fixed;
    right: clamp(12px, 1.8vw, 24px);
    top: 30%;
    transform: translateY(-50%);
    z-index: 9999;
    display: grid;
    place-items: center;
  }

  #rightFab .fab-btn {
    position: relative;
    width: var(--fab-size);
    height: var(--fab-size);
    border-radius: 50%;
    /* 깊이감 있는 글로시 구형 그라디언트 */
    background:
      radial-gradient(120% 120% at 32% 28%, var(--fab-bg-1) 0%, var(--fab-bg-2) 42%, var(--fab-bg-3) 100%);
    color: var(--fab-text);
    display: grid;
    place-items: center;
    text-decoration: none;
    cursor: pointer;

    /* 얕은 엠보싱 + 자연스러운 바깥 그림자 */
    box-shadow:
      0 1px 0 rgba(255,255,255,.65) inset,
      0 -12px 24px rgba(0,0,0,.06) inset,
      0 8px 18px rgba(0,0,0,.18);
    border: 1px solid rgba(255,255,255,.60);

    outline: none;
    transition: transform .22s ease, box-shadow .22s ease, filter .22s ease;
    isolation: isolate; /* pseudo-elements와의 레이어 안정화 */
  }

  /* 상단 글로시 하이라이트 */
  #rightFab .fab-btn::before {
    content: "";
    position: absolute;
    left: 10%; right: 10%;
    top: 6%;  bottom: 58%;
    border-radius: 48% 48% 52% 52% / 70% 70% 30% 30%;
    background: linear-gradient(to bottom, rgba(255,255,255,.75), rgba(255,255,255,0));
    filter: blur(.2px);
    pointer-events: none;
  }

  /* 바닥쪽 부드러운 접지 그림자 */
  #rightFab .fab-btn::after {
    content: "";
    position: absolute;
    inset: -16%;
    border-radius: 50%;
    background: radial-gradient(closest-side, rgba(0,0,0,.22), transparent 70%);
    transform: translateY(8%);
    z-index: -1;
    opacity: .28;
    transition: opacity .22s ease, transform .22s ease;
  }

  /* Hover / Active / Focus states */
  #rightFab .fab-btn:hover {
    transform: translateY(-1px) scale(1.02) rotate(.2deg);
    box-shadow:
      0 1px 0 rgba(255,255,255,.7) inset,
      0 -12px 24px rgba(0,0,0,.07) inset,
      0 12px 28px rgba(0,0,0,.22);
    filter: brightness(1.02);
  }
  #rightFab .fab-btn:hover::after { opacity: .36; transform: translateY(10%) scale(1.02); }
  #rightFab .fab-btn:active { transform: translateY(0) scale(.985); }
  #rightFab .fab-btn:focus-visible {
    outline: 3px solid rgba(26,115,232,.45);
    outline-offset: 4px;
  }

  /* 텍스트(아이콘 없음) — 가독성 & 밀도 조정 */
  #rightFab .fab-label {
    display: -webkit-box;
    -webkit-line-clamp: 3;        /* 최대 3줄 */
    -webkit-box-orient: vertical;
    overflow: hidden;

    width: 78%;
    text-align: center;
    line-height: clamp(1.10, calc(var(--fab-size) * 0.0085), 1.18);
    letter-spacing: clamp(-0.6px, calc(var(--fab-size) * -0.0045), -0.2px);
    word-break: keep-all;
    text-wrap: balance;

    font-family: 'GongGothicMedium', 'Pretendard Variable', 'Pretendard',
                 'Noto Sans KR', system-ui, -apple-system, 'Segoe UI', Arial, sans-serif;
    font-weight: 770;
    font-variation-settings: "wght" 770;
    font-optical-sizing: auto;
    font-size: clamp(12px, calc(var(--fab-size) * 0.12), 28px);
    -webkit-font-smoothing: antialiased;
    text-rendering: optimizeLegibility;

    padding: 0 2px;
    color: var(--fab-text);

    /* 노란 배경에서 선명도 보정: 하이라이트 + 극미세 그림자 */
    text-shadow:
      0 1px 0 rgba(255,255,255,.34),
      0 .5px .6px rgba(0,0,0,.16);
  }

  /* 모바일: 우하단 플로팅 */
  @media (max-width: 768px) {
    #rightFab { top: auto; bottom: clamp(16px, 4vw, 24px); transform: none; }
  }

  /* 다크모드: 텍스트 대비 소폭 증강 */
  @media (prefers-color-scheme: dark) {
    #rightFab .fab-label { color: #021628; }
  }

  /* 모션 최소화 환경 존중 */
  @media (prefers-reduced-motion: reduce) {
    #rightFab .fab-btn,
    #rightFab .fab-btn::before,
    #rightFab .fab-btn::after { transition: none; }
  }
</style>


<div id="rightFab" role="complementary" aria-label="우측 고정 바로가기">
  <a href="${fabUrl}" target="${fabTarget}" class="fab-btn" aria-label="${fabTitle}" title="${fabTitle}">
    <span class="fab-label">
      <c:out value="${fn:replace(fn:replace(fabText, NL, BR), SLASHN, BR)}" escapeXml="false" />
    </span>
  </a>
</div>
