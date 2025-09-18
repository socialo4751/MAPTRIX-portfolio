<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>리워드 정책</title>


  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  <%@ include file="/WEB-INF/views/include/top.jsp" %>
  <link rel="stylesheet" href="/css/csstyle.css">
  <style>
    .page-header h2{ display:flex; align-items:center; gap:8px; margin:6px 0 12px 0; }
    .tile{ border:1px solid #eee; border-radius:14px; padding:18px; background:#fff; height:100%; }
    .tile .icon{ width:42px; height:42px; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#f1f3f5; margin-bottom:8px; }
    .muted{ color:#6c757d; }
    .micro{ font-size:.86rem; color:#6c757d; }
    .kv th{ width:170px; background:#fafafa; }
  </style>
</head>

<body>
<div class="container">
  <c:set var="activeMenu" value="stamp"/>
  <c:set var="activeSub" value="policy"/>
  <%@ include file="/WEB-INF/views/include/stSideBar.jsp" %>

  <main class="vstack gap-3">
    <div class="page-header">
      <h2><span class="material-icons" style="font-size:28px;">redeem</span> 리워드 정책</h2>
      <p class="mb-0 muted">핵심만 빠르게 확인하세요. 자세한 수치는 아래 '자세히'에서.</p>
    </div>

    <section>
      <div class="row g-3">
        <div class="col-md-4">
          <div class="tile">
            <div class="icon"><span class="material-icons">directions_walk</span></div>
            <h6 class="mb-1">적립(Earn)</h6>
            <p class="mb-0 muted">우편번호 구역으로 이동해서 스탬프 획득</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="tile">
            <div class="icon"><span class="material-icons">compare_arrows</span></div>
            <h6 class="mb-1">전환(Convert)</h6>
            <p class="mb-0 muted">스탬프 → 포인트 전환</p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="tile">
            <div class="icon"><span class="material-icons">qr_code_scanner</span></div>
            <h6 class="mb-1">사용(Spend)</h6>
            <p class="mb-0 muted">가맹점에서 QR/NFC로 결제처럼 사용</p>
          </div>
        </div>
      </div>
    </section>

    <section>
      <div class="row g-3">
        <div class="col-md-6">
          <div class="tile">
            <h6 class="mb-2">일·월 한도</h6>
            <table class="table table-bordered align-middle kv mb-0">
              <tbody>
              <tr><th>일일 적립</th><td>최대 범위 운영(프로모션별 공지)</td></tr>
              <tr><th>일일 사용</th><td>최소 단위/일 한도 운영</td></tr>
              </tbody>
            </table>
          </div>
        </div>
        <div class="col-md-6">
          <div class="tile">
            <h6 class="mb-2">부정 방지</h6>
            <ul class="mb-0 muted">
              <li>동일 루트 반복 · 비정상 패턴 모니터링</li>
              <li>일회용 토큰(JTI/TTL), 기기 바인딩</li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <section>
      <details>
        <summary class="mb-2"><b>자세히 보기</b> <span class="muted">(정책 수치/예외 포함)</span></summary>
        <div class="micro">
          <p class="mb-1"><b>적립 예시</b> 우편번호별 도로명스탬프를 채워 우편번호당 1,000 스탬프 수급 가능(베타 기준).</p>
          <p class="mb-1"><b>사용 제한</b> 일부 상품/서비스는 사용 제외(가맹점 정책).</p>
          <p class="mb-0"><b>변경</b> 베타 기간 정책은 예고 후 조정될 수 있습니다.</p>
        </div>
      </details>
    </section>

    <section class="d-flex justify-content-end gap-2 mb-3">
      <a class="btn btn-primary" href="<c:url value='/attraction/apply-stamp'/>"><span class="material-icons" style="font-size:18px;vertical-align:-4px;">store</span> 가맹점 신청</a>
    </section>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
