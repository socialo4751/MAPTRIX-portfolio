<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<head>
    <!-- Pretendard Variable 웹폰트 (가변폰트 버전) -->
    <link rel="preload"
          href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css"
          as="style"
          onload="this.onload=null;this.rel='stylesheet'">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- 통합된 CSS -->
    <link rel="stylesheet" href="/css2/top.css">

    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <meta name="theme-color" content="#ffffff">
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    <c:set var="SITE_NAME" value="MAPTRIX"/>
    <!-- 우선순위: (모델/요청속성) pageTitle → (include param) param.pageTitle -->
    <c:set var="pageTitleFinal" value="${not empty pageTitle ? pageTitle : param.pageTitle}"/>

    <title>
        <c:choose>
            <c:when test="${not empty pageTitleFinal}">
                <c:out value="${pageTitleFinal}"/> - <c:out value="${SITE_NAME}"/>
            </c:when>
            <c:otherwise>
                <c:out value="${SITE_NAME}"/>
            </c:otherwise>
        </c:choose>
    </title>
</head>
<div id="wrap">
    <header class="header">
        <div class="wrap_gnb">
            <!-- 왼쪽: 로고 -->
            <div class="gnb-left">
                <a href="/"><img src="/images/main/logofix.png" style="width: 50px; height: 50px;" alt="홈"/></a>
            </div>

            <!-- 중앙: 사이트 메인 메뉴 (드롭다운 포함) -->
            <div class="gnb-center">
                <div class="major has-sub">
                    <a class="depth1" href="/intro"><span class="txt">사이트 소개</span></a>
                    <ul class="depth2">
                        <li><a href="/intro">소개</a></li>
                        <li><a href="/intro/org/chart">조직 안내</a></li>
                        <li><a href="/intro/history">프로젝트 연혁</a></li>
                    </ul>
                </div>
                <!-- 상권분석 -->
                <div class="major has-sub">
                    <a class="depth1" href="/market/simple" target="_blank"><span class="txt">상권분석</span></a>
                    <ul class="depth2">
                        <li><a href="/market/simple" target="_blank">간단 분석</a></li>
                        <li><a href="/market/detailed" target="_blank">상세 분석</a></li>
                        <li><a href="/market/indicators">분석 지표</a></li>
                        <li><a href="/biz-stats/chart">상권 통계</a></li>
                        <li><a href="/biz-stats/keyword">SNS키워드 분석</a></li>
                        <li><a href="/biz-stats/franchises" target="_blank">주요 프랜차이즈 현황</a></li>
                    </ul>
                </div>

                <!-- 창업 지원 -->
                <div class="major has-sub">
                    <a class="depth1" href="/start-up/test"><span class="txt">창업 지원</span></a>
                    <ul class="depth2">
                        <li><a href="/start-up/test">창업 역량 테스트</a></li>
                        <li><a href="/start-up/mt">지원사업 안내</a></li>
                        <li><a href="/start-up/show" target="_blank">내 가게 만들기</a></li>
                    </ul>
                </div>

                <!-- 커뮤니티 -->
                <div class="major has-sub">
                    <a class="depth1" href="/comm/entry"><span class="txt">커뮤니티</span></a>
                    <ul class="depth2">
                        <li><a href="/comm/entry">업종별 커뮤니티</a></li>
                        <li><a href="/comm/news">상권 뉴스</a></li>
                        <li><a href="/comm/review">창업 후기</a></li>
                    </ul>
                </div>

                <!-- 고객센터 -->
                <div class="major has-sub">
                    <a class="depth1" href="/cs/notice"><span class="txt">고객센터</span></a>
                    <ul class="depth2">
                        <li><a href="/cs/notice">공지사항</a></li>
                        <li><a href="/cs/qna">질의응답 (Q&A)</a></li>
                        <li><a href="/cs/faq">자주 묻는 질문 (FAQ)</a></li>
                        <li><a href="/cs/praise">직원 칭찬 게시판</a></li>
                        <li><a href="/cs/survey">설문 조사</a></li>
                    </ul>
                </div>

                <!-- 마이페이지 -->
                <sec:authorize access="isAuthenticated()">
                    <div class="major has-sub">
                        <a class="depth1" href="/my/profile"><span class="txt">마이페이지</span></a>
                        <ul class="depth2">
                            <li><a href="/my/profile">회원정보 관리</a></li>
                            <li><a href="/my/report">분석 및 지표 다운로드</a></li>
                            <li><a href="/my/post/comm">활동 내역 조회</a></li>
                            <li><a href="/my/bizapply/status">스탬프 가맹신청 현황</a></li>
                            <li><a href="/my/openapi/status">OPEN API 신청 현황</a></li>
                        </ul>
                    </div>
                </sec:authorize>

                <!-- OPEN API -->
                <div class="major has-sub">
                    <a class="depth1" href="/openapi"><span class="txt">OPEN API</span></a>
                    <ul class="depth2">
                        <li><a href="/openapi/intro">서비스 소개</a></li>
                        <li><a href="/openapi">서비스 목록</a></li>
                    </ul>
                </div>
            </div>

            <!-- 오른쪽: 유틸 영역 (스탬프투어 + 로그인/로그아웃 + 모바일 버튼) -->
            <div class="gnb-right">
                <sec:authorize access="isAuthenticated()">
                    <a style="color: white;" href="/my/profile">
                        <sec:authentication property="principal.usersVO.name"/>님 환영합니다.
                    </a>
                </sec:authorize>


                <sec:authorize access="isAuthenticated()">
                    <div class="notification-container">
                        <a href="#" id="notification-bell" class="util-link">
                            <i class="bi bi-bell-fill"></i>
                            <span id="notification-badge" class="badge"></span>
                        </a>
                        <div id="notification-dropdown" class="notification-dropdown">
                            <div class="notification-header">
                                <span class="notification-title">알림</span>
                                <button type="button" id="read-all-btn">모두 읽음</button>
                            </div>
                            <ul id="notification-list" class="notification-list">
                            </ul>
                            <div id="no-notifications"
                                 style="display: none; text-align: center; padding: 10px; color: #666;">
                                새로운 알림이 없습니다.
                            </div>
                            <a href="/my/notifications" class="notification-all-link">전체보기</a>
                        </div>
                    </div>

                    <a href="/logout" class="util-link">로그아웃</a>
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="/admin" class="util-link">관리자</a>
                    </sec:authorize>
                </sec:authorize>

                <sec:authorize access="isAnonymous()">
                    <a href="/login" class="util-link">로그인</a>
                </sec:authorize>

                <div class="mbtn">
                    <button type="button"
                            aria-controls="drawer"
                            aria-expanded="false"
                            onclick="
const d = document.getElementById('drawer');
const opened = d.classList.toggle('open');
this.setAttribute('aria-expanded', opened);
">
                        ☰
                    </button>
                </div>
            </div>
        </div>
    </header>


    <aside id="drawer" class="drawer"
           onclick="if (!event.target.closest('.panel')) this.classList.remove('open');">
        <div class="panel" onclick="event.stopPropagation()">
            <div class="p-head">
                <strong>메뉴</strong>
                <button type="button" aria-label="닫기"
                        onclick="document.getElementById('drawer').classList.remove('open')">✕
                </button>
            </div>

            <div class="p-body">
                <!-- 사이트 소개 (PC와 동일) -->
                <details class="acco">
                    <summary>사이트 소개</summary>
                    <div class="inner">
                        <a href="/intro">소개</a>
                        <a href="/intro/org/chart">조직 안내</a>
                        <a href="/intro/history">프로젝트 연혁</a>
                    </div>
                </details>

                <!-- 상권분석 (PC와 동일; target 유지) -->
                <details class="acco">
                    <summary>상권분석</summary>
                    <div class="inner">
                        <a href="/market/simple" target="_blank">간단 분석</a>
                        <a href="/market/detailed" target="_blank">상세 분석</a>
                        <a href="/market/indicators">분석 지표</a>
                        <a href="/biz-stats/chart">상권 통계</a>
                        <a href="/biz-stats/keyword">SNS키워드 분석</a>
                        <a href="/biz-stats/franchises" target="_blank">주요 프랜차이즈 현황</a>
                    </div>
                </details>

                <!-- 창업 지원 (PC와 동일) -->
                <details class="acco">
                    <summary>창업 지원</summary>
                    <div class="inner">
                        <a href="/start-up/test">창업 역량 테스트</a>
                        <a href="/start-up/mt">지원사업 안내</a>
                        <a href="/start-up/show">내 가게 만들기</a>
                    </div>
                </details>

                <!-- 커뮤니티 (PC와 동일) -->
                <details class="acco">
                    <summary>커뮤니티</summary>
                    <div class="inner">
                        <a href="/comm/entry">업종별 커뮤니티</a>
                        <a href="/comm/news">상권 뉴스</a>
                        <a href="/comm/review">창업 후기</a>
                    </div>
                </details>

                <!-- 고객센터 (PC와 동일) -->
                <details class="acco">
                    <summary>고객센터</summary>
                    <div class="inner">
                        <a href="/cs/notice">공지사항</a>
                        <a href="/cs/qna">질의응답 (Q&amp;A)</a>
                        <a href="/cs/faq">자주 묻는 질문 (FAQ)</a>
                        <a href="/cs/praise">직원 칭찬 게시판</a>
                        <a href="/cs/survey">설문 조사</a>
                    </div>
                </details>

                <!-- 마이페이지: 로그인 시 노출 (PC와 동일) -->
                <sec:authorize access="isAuthenticated()">
                    <details class="acco">
                        <summary>마이페이지</summary>
                        <div class="inner">
                            <a href="/my/profile">회원정보 관리</a>
                            <a href="/my/report">분석 및 지표 다운로드</a>
                            <a href="/my/post/comm">활동 내역 조회</a>
                            <a href="/my/bizapply/status">스탬프 가맹신청 현황</a>
                            <a href="/my/openapi/status">OPEN API 신청 현황</a>
                        </div>
                    </details>
                </sec:authorize>

                <!-- OPEN API (PC와 동일) -->
                <details class="acco">
                    <summary>OPEN API</summary>
                    <div class="inner">
                        <a href="/openapi/intro">서비스 소개</a>
                        <a href="/openapi">서비스 목록</a>
                    </div>
                </details>

                <!-- 로그인/로그아웃/관리자 (PC와 동일한 권한 처리) -->
                <div class="inner" style="margin-top:8px;">
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


    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.0/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
    <script>
        /* 최종 수정 버전 (2025-08-25) - 이 스크립트 하나만 사용해야 합니다. */
        (function () {
            const appRoot = "<%= request.getContextPath() %>" || "";
            const ROOT = appRoot.replace(/\/$/, "");

            // ---- Helper 함수: 날짜 형식 변환 등 --------------------------------
            function safeText(t, fallback = '알림이 도착했습니다.') {
                if (t == null) return fallback;
                t = String(t).trim();
                return t || fallback;
            }

            function normalizeTargetUrl(u) {
                if (u == null) return null;
                u = String(u).trim();
                if (!u || /^(false|null|undefined)$/i.test(u)) return null;
                if (/^https?:\/\//i.test(u)) return u;
                if (!u.startsWith('/')) u = '/' + u;
                return ROOT + u;
            }

            function toDateString(v) {
                if (v == null || v === '') return '';
                if (typeof v === 'number' || /^[0-9]+$/.test(String(v))) {
                    const num = Number(v);
                    const ms = String(v).length >= 13 ? num : num * 1000;
                    const d = new Date(ms);
                    return isNaN(d.getTime()) ? '' : d.toLocaleString();
                }
                const d = new Date(v);
                return isNaN(d.getTime()) ? String(v) : d.toLocaleString();
            }

            // ---- 1. 서버에서 안 읽은 알림 개수 가져와서 배지에 표시하는 함수 --------
            function fetchUnreadCount() {
                $.get(`${ROOT}/api/notifications/unread-count`, (data) => {
                    const count = Number(data?.count) || 0;
                    const $badge = $('#notification-badge');
                    if (count > 0) $badge.text(count).show();
                    else $badge.hide();
                }).fail(() => console.error('Failed to fetch notification count.'));
            }

            // ---- 2. 서버에서 알림 목록(읽지 않은 것만) 가져와서 화면에 그리는 함수 --
            function fetchNotifications() {
                const $list = $('#notification-list');
                const $noNotifications = $('#no-notifications');
                $list.empty().append('<li class="loading">알림을 불러오는 중...</li>');
                $noNotifications.hide();

                $.get(`${ROOT}/api/notifications`, (data) => {
                    $list.empty();
                    if (!Array.isArray(data) || data.length === 0) {
                        $noNotifications.show();
                        return;
                    }
                    data.forEach((notification) => {
                        const $li = $('<li>')
                            .addClass('notification-item unread')
                            .attr('data-notify-id', notification.notifyId);

                        const $a = $('<a>')
                            .attr('href', normalizeTargetUrl(notification.targetUrl) || '#')
                            .append($('<div>').addClass('message').text(safeText(notification.message)))
                            .append($('<div>').addClass('time').text(toDateString(notification.createdAt)));

                        $li.append($a);
                        $list.append($li);
                    });
                }).fail(() => {
                    $list.empty().append('<li class="error">알림을 불러올 수 없습니다.</li>');
                });
            }

            // ---- 3. 개별 알림 아이템 클릭 이벤트 처리 -----------------------------
            $('#notification-list').on('click', '.notification-item', function (e) {
                e.preventDefault();
                const $item = $(this);
                const notifyId = $item.attr('data-notify-id');

                console.log("--- 클릭 이벤트 시작 ---");
                console.log("1. 읽어온 notifyId:", notifyId);
                console.log("2. notifyId 타입:", typeof notifyId);

                if (!notifyId || String(notifyId).trim() === '') {
                    alert('알림 ID가 비어있거나 유효하지 않습니다. 요청을 보내지 않습니다.');
                    console.error("notifyId가 비어있어 중단됨.");
                    return;
                }

                // ▼▼▼ [핵심 변경] URL 생성 방식을 가장 기본적인 문자열 합치기로 변경 ▼▼▼
                const requestUrl = ROOT + '/api/notifications/' + notifyId + '/read';

                console.log("3. 요청을 보낼 최종 URL:", requestUrl);

                $item.css('opacity', '0.5'); // 읽음 처리 중임을 시각적으로 표시

                $.post(requestUrl) // 변경된 URL 변수 사용
                    .done(() => {
                        console.log("4. [성공] $.post 성공! 요청 URL:", requestUrl);
                        $item.slideUp(300, function () {
                            $(this).remove();
                        });
                        fetchUnreadCount();

                        const targetUrl = $item.find('a').attr('href');
                        if (targetUrl && targetUrl !== '#') {
                            window.location.href = targetUrl;
                        }
                    })
                    .fail((err) => {
                        console.error("4. [실패] $.post 실패! 요청 URL:", requestUrl, "에러 객체:", err);
                        alert('알림을 처리하는 중 오류가 발생했습니다. F12 콘솔을 확인해주세요.');
                        $item.css('opacity', '1'); // 실패 시 다시 원래대로
                    });

                console.log("5. 클릭 이벤트 핸들러 종료 (네트워크 요청은 비동기로 진행됨)");
            });
            // ---- 4. '모두 읽음' 버튼 클릭 이벤트 처리 ------------------------------
            $('#read-all-btn').off('click').on('click', function () {
                $.post(`${ROOT}/api/notifications/read-all`)
                    .done(() => {
                        fetchUnreadCount();
                        fetchNotifications();
                    })
                    .fail(() => alert('모든 알림을 처리하는 중 오류가 발생했습니다.'));
            });

            // ---- 5. 알림 벨 아이콘 클릭 이벤트 처리 ------------------------------
            $('#notification-bell').off('click').on('click', function (e) {
                e.preventDefault();
                const $dropdown = $('#notification-dropdown');
                const isVisible = $dropdown.hasClass('show');

                $dropdown.toggleClass('show', !isVisible);

                if (!isVisible) {
                    fetchNotifications();
                }
            });

            // ---- 6. 드롭다운 외부 영역 클릭 시 닫기 처리 --------------------------
            $(document).on('click.notification', function (e) {
                if (!$(e.target).closest('.notification-container').length) {
                    $('#notification-dropdown').removeClass('show');
                }
            });

            // ---- 7. 웹소켓(STOMP) 연결 -----------------------------------------
            function initWebSocket() {
                const socket = new SockJS(`${ROOT}/ws/stomp`);
                const client = Stomp.over(socket);
                client.debug = null;

                client.connect({}, function (frame) {
                    console.log('STOMP: 연결 성공');

                    client.subscribe('/user/queue/notifications/unread-count', () => {
                        fetchUnreadCount();
                        if ($('#notification-dropdown').hasClass('show')) {
                            fetchNotifications();
                        }
                    });
                }, (err) => {
                    console.error('STOMP: 연결 실패', err);
                });
            }

            // ---- 8. 페이지 로드 시 초기 실행 -------------------------------------
            $(function () {
                fetchUnreadCount();
                initWebSocket();
            });

        })();
    </script>