<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Pretendard -->
    <link href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/variable/pretendardvariable.min.css"
          rel="preload">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    
    <!-- SweetAlerts -->
    <link rel="stylesheet" href="<c:url value='/css/sweetalert2.min.css'/>"/>
    <script src="<c:url value='/js/sweetalert2.min.js'/>"></script>
    
    <style>
        body {
            font-family: 'Pretendard Variable', Pretendard, sans-serif;
            background: #fff;
            margin: 0;
            padding: 0;
        }

        .login-wrapper {
            max-width: 400px;
            width: 100%;
            margin: 0 auto;
            padding: 10px 30px;
            background: #fff;
            text-align: center;
        }

        .maptrix-logo {
            height: 30px;
            display: block;
            margin: -20px auto 1rem; /* 👈 위로 10px 당김 */
        }

        .login-title {
            font-weight: 700;
            font-size: 20px;
            margin-bottom: 10px;
        }

        .tab-menu {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
            font-size: 14px;
        }

        .tab-menu a {
            color: #999;
            text-decoration: none;
            position: relative;
        }

        .tab-menu a.active {
            color: #000;
            font-weight: bold;
        }

        .tab-menu a.active::after {
            content: "";
            position: absolute;
            bottom: -6px;
            left: 0;
            right: 0;
            height: 2px;
            background: #000;
        }

        input.form-control {
            height: 50px;
            border-radius: 0;
            border: 1px solid #ddd;
            font-size: 14px;
        }

        .btn-login {
            background: #000;
            color: #fff;
            font-weight: bold;
            height: 50px;
            font-size: 16px;
            border-radius: 0;
            width: 100%;
        }

        .btn-login:hover {
            background: #222;
        }

        .bottom-links {
            font-size: 13px;
            margin-top: 15px;
            color: #666;
        }

        .bottom-links a {
            text-decoration: none;
            color: #333;
            margin: 0 5px;
        }

        .quick-login-box a {
            display: block;
            padding: 10px;
            margin-top: 10px;
            font-size: 14px;
            text-align: left;
            color: #333;
            border-radius: 0;
            background: #fff;
            transition: all 0.2s ease;
            border: 1px solid #ddd;
        }

        .quick-login-box a:hover {
            background: #f9f9f9;
        }

        .quick-login-box img {
            height: 30px;
        }

        /* 로그인 버튼 공통 */
        .btn-kakao,
        .btn-naver {
            height: 50px;
            font-size: 16px;
            font-weight: bold;
            width: 100%;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 0;
        }

        /* 브랜드 색상 */
        .btn-kakao {
            background-color: #FEE500;
            color: #000;
        }

        .btn-kakao:hover {
            background-color: #e4cb00;
        }

        .btn-naver {
            background-color: #03C75A;
            color: #fff;
        }

        .btn-naver:hover {
            background-color: #02b24f;
        }

        /* 아이콘 왼쪽 고정 */
        .icon-absolute {
            position: absolute;
            left: 16px;
            height: 24px;
            width: auto;
        }

        /* 텍스트는 정확히 가운데 */
        .login-btn-text {
            position: absolute;
            left: 50%;
            top: 51%; /* ← 약간 아래로 */
            transform: translate(-50%, -50%);
            z-index: 1;
        }

        .square-check {
            border-radius: 0 !important; /* 둥근 모서리 제거 */
            width: 16px;
            height: 16px;
        }

        .square-check:focus {
            outline: none;
            box-shadow: none;
        }
        
        /* 개발용 모달을 여는 버튼 스타일 */
		.dev-modal-trigger {
    		position: fixed;
    		top: 150px;
    		right: 900px;
    		z-index: 1050; /* 다른 요소들 위에 보이도록 z-index 설정 */
		}
    </style>
</head>
<body>

<%-- 로그아웃 성공 시 URL(?logout)을 감지하여 메시지 표시 --%>
<c:if test="${param.logout != null}">
    <script>
        // 페이지가 완전히 로드된 후 스윗알러트를 실행합니다.
        document.addEventListener('DOMContentLoaded', () => {
            Swal.fire({
                toast: true,
                position: 'top-end',
                icon: 'success',
                title: '정상적으로 로그아웃되었습니다.',
                showConfirmButton: false,
                timer: 3000
            });
        });
    </script>
</c:if>

<div class="container d-flex justify-content-center align-items-center min-vh-100">
    <div class="login-wrapper">
    	        <%-- ✨ 1. 이 위치에 버튼을 붙여넣고, div로 감싸 중앙 정렬과 간격을 줍니다. --%>
        <div class="mb-4">
            <button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#devLoginModal">
                개발자 로그인 Click!
            </button>
        </div>

        <div class="text-center mb-2">
            <img src="<c:url value='/images/MAPTRIX.png'/>" alt="MAPTRIX 로고" class="maptrix-logo mb-3">
            <div class="login-title" style="padding-bottom: 15px; font-size: 20px; padding-top: 40px;">통합 로그인</div>
        </div>

        <!-- 로그인 폼 -->
        <form id="loginForm" action="/auth/login" method="post">
            <div class="mb-3">
                <input type="text" id="userId" name="userId" class="form-control" placeholder="아이디 또는 이메일" required>
            </div>
            <div class="mb-3">
                <input type="password" id="password" name="password" class="form-control" placeholder="비밀번호" required>
            </div>
            <div class="form-check text-start mb-3">
                <input class="form-check-input square-check" type="checkbox" id="rememberMe">
                <label class="form-check-label small" for="rememberMe">로그인 상태 유지</label>
            </div>
            <button type="submit" class="btn btn-login">맵트릭스ID 로그인</button>
        </form>

        <!-- 아이디/비밀번호 링크 -->
        <div class="bottom-links">
            <a href="/sign-up/agree">회원가입</a> |
            <a href="/find-id">ID 찾기</a> |
            <a href="/find-password">비밀번호 찾기</a>
        </div>

        <!-- 간편 로그인 -->
        <div class="quick-login-box mt-4 position-relative">
            <a href="<c:url value='/oauth/kakao'/>" class="btn btn-kakao w-100 position-relative">
                <img src="<c:url value='/images/kakao_login_btn.png'/>" alt="카카오" class="login-icon icon-absolute">
                <span class="login-btn-text">카카오 로그인</span>
            </a>
            <a href="<c:url value='/oauth/naver'/>" class="btn btn-naver w-100 position-relative mt-2">
                <img src="<c:url value='/images/naver_login_btn.png'/>" alt="네이버" class="login-icon icon-absolute">
                <span class="login-btn-text">네이버 로그인</span>
            </a>
        </div>
    </div>
</div>

<!-- 로그인 처리 스크립트 -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const form = document.getElementById('loginForm');
        
        // ★ 로그인 폼 제출 이벤트 리스너 (이제 하나만 존재)
        form.addEventListener('submit', handleLogin);
        
        // 미리 정의할 계정 정보
        const creds = {
            admin0: { userId: 'admin@test.com', password: 'java' },
            admin1: { userId: 'admin01@test.com', password: 'java' },
            admin2: { userId: 'admin02@test.com', password: 'java' },
            user0:  { userId: 'user@test.com',  password: 'java'  },
            user1:  { userId: 'user01@test.com',  password: 'java'  },
            user2:  { userId: 'user02@test.com',  password: 'java'  },
            user3:  { userId: 'user03@test.com',  password: 'java'  },
            user4:  { userId: 'user04@test.com',  password: 'java'  },
            user5:  { userId: 'user05@test.com',  password: 'java'  },
            user6:  { userId: 'user06@test.com',  password: 'java'  },
            user7:  { userId: 'user07@test.com',  password: 'java'  },
            user8:  { userId: 'user08@test.com',  password: 'java'  },
            user9:  { userId: 'user09@test.com',  password: 'java'  },
            user10:  { userId: 'user10@test.com',  password: 'java'  },
            user11:  { userId: 'user11@test.com',  password: 'java'  },
            user12:  { userId: 'user12@test.com',  password: 'java'  },
            user13:  { userId: 'user13@test.com',  password: 'java'  },
            user14:  { userId: 'user14@test.com',  password: 'java'  },
            user15:  { userId: 'user15@test.com',  password: 'java'  },
            user16:  { userId: 'user16@test.com',  password: 'java'  },
            user17:  { userId: 'user17@test.com',  password: 'java'  },
            user18:  { userId: 'user18@test.com',  password: 'java'  },
            user19:  { userId: 'user19@test.com',  password: 'java'  },
            user20:  { userId: 'user20@test.com',  password: 'java'  }
        };

        // 자동로그인 버튼 이벤트 바인딩
        document.getElementById('btnAdminLogin0').addEventListener('click', () => autoLogin('admin0'));
        document.getElementById('btnAdminLogin1').addEventListener('click', () => autoLogin('admin1'));
        document.getElementById('btnAdminLogin2').addEventListener('click', () => autoLogin('admin2'));
        document.getElementById('btnUserLogin0').addEventListener('click', () => autoLogin('user0'));
        document.getElementById('btnUserLogin1').addEventListener('click', () => autoLogin('user1'));
        document.getElementById('btnUserLogin2').addEventListener('click', () => autoLogin('user2'));
        document.getElementById('btnUserLogin3').addEventListener('click', () => autoLogin('user3'));
        document.getElementById('btnUserLogin4').addEventListener('click', () => autoLogin('user4'));
        document.getElementById('btnUserLogin5').addEventListener('click', () => autoLogin('user5'));
        document.getElementById('btnUserLogin6').addEventListener('click', () => autoLogin('user6'));
        document.getElementById('btnUserLogin7').addEventListener('click', () => autoLogin('user7'));
        document.getElementById('btnUserLogin8').addEventListener('click', () => autoLogin('user8'));
        document.getElementById('btnUserLogin9').addEventListener('click', () => autoLogin('user9'));
        document.getElementById('btnUserLogin10').addEventListener('click', () => autoLogin('user10'));
        document.getElementById('btnUserLogin11').addEventListener('click', () => autoLogin('user11'));
        document.getElementById('btnUserLogin12').addEventListener('click', () => autoLogin('user12'));
        document.getElementById('btnUserLogin13').addEventListener('click', () => autoLogin('user13'));
        document.getElementById('btnUserLogin14').addEventListener('click', () => autoLogin('user14'));
        document.getElementById('btnUserLogin15').addEventListener('click', () => autoLogin('user15'));
        document.getElementById('btnUserLogin16').addEventListener('click', () => autoLogin('user16'));
        document.getElementById('btnUserLogin17').addEventListener('click', () => autoLogin('user17'));
        document.getElementById('btnUserLogin18').addEventListener('click', () => autoLogin('user18'));
        document.getElementById('btnUserLogin19').addEventListener('click', () => autoLogin('user19'));
        document.getElementById('btnUserLogin20').addEventListener('click', () => autoLogin('user20'));
        
        // --- 공통 로그인 처리 함수들 ---

        // 1. 수동 로그인 폼 처리
        async function handleLogin(e) {
            e.preventDefault();
            const body = JSON.stringify({
                userId: document.getElementById('userId').value,
                password: document.getElementById('password').value
            });
            await doLogin(body);
        }

        // 2. 개발용 자동로그인 처리
        async function autoLogin(role) {
            const { userId, password } = creds[role];
            const body = JSON.stringify({ userId, password });
            await doLogin(body);
        }
        
        
        
        // 3. 실제 로그인 요청을 보내는 공통 함수
        async function doLogin(body) {
            try {
                const res = await fetch(form.action, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body
                });

                if (!res.ok) {
                    const errorData = await res.json();
                    Swal.fire({
                        toast: true,
                        position: 'top-end',
                        icon: 'error',
                        title: errorData.message || '로그인 실패',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    return; // 오류 발생 시 함수 종료
                }
                
                // 로그인 성공 시 리다이렉트
                const params = new URLSearchParams(window.location.search);
                const redirectUrl = params.get("redirect");
                window.location.href = redirectUrl || "/";

            } catch (error) {
                console.error('Login request failed:', error);
                Swal.fire({
                    toast: true,
                    position: 'top-end',
                    icon: 'error',
                    title: '서버와 통신 중 오류가 발생했습니다.',
                    showConfirmButton: false,
                    timer: 3000
                });
            }
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<%-- ✨ 2. 개발용 자동로그인 버튼이 들어갈 모달 --%>
<div class="modal fade" id="devLoginModal" tabindex="-1" aria-labelledby="devLoginModalLabel" aria-hidden="true">
    <%-- modal-dialog-scrollable 클래스를 추가하면 버튼이 많아질 때 본문이 스크롤됩니다. --%>
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="devLoginModalLabel">개발용 자동로그인</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="text-muted small">클릭하면 해당 계정으로 자동 로그인됩니다.</p>
                <div class="d-grid gap-2">
                    <%-- 기존 자동로그인 버튼들을 이곳으로 옮깁니다. --%>
                    <button type="button" id="btnAdminLogin0" class="btn btn-outline-primary">관리자 (admin@test.com)</button>
                    <button type="button" id="btnAdminLogin1" class="btn btn-outline-primary">관리자 (admin01@test.com)</button>
                    <button type="button" id="btnAdminLogin2" class="btn btn-outline-primary">관리자 (admin02@test.com)</button>
                    <button type="button" id="btnUserLogin0" class="btn btn-outline-secondary">사용자 (user@test.com)</button>
                    <button type="button" id="btnUserLogin1" class="btn btn-outline-secondary">사용자01 (user01@test.com)</button>
                    <button type="button" id="btnUserLogin2" class="btn btn-outline-secondary">사용자02 (user02@test.com)</button>
                    <button type="button" id="btnUserLogin3" class="btn btn-outline-secondary">사용자03 (user03@test.com)</button>
                    <button type="button" id="btnUserLogin4" class="btn btn-outline-secondary">사용자04 (user04@test.com)</button>
                    <button type="button" id="btnUserLogin5" class="btn btn-outline-secondary">사용자05 (user05@test.com)</button>
                    <button type="button" id="btnUserLogin6" class="btn btn-outline-secondary">사용자06 (user06@test.com)</button>
                    <button type="button" id="btnUserLogin7" class="btn btn-outline-secondary">사용자07 (user07@test.com)</button>
                    <button type="button" id="btnUserLogin8" class="btn btn-outline-secondary">사용자08 (user08@test.com)</button>
                    <button type="button" id="btnUserLogin9" class="btn btn-outline-secondary">사용자09 (user09@test.com)</button>
                    <button type="button" id="btnUserLogin10" class="btn btn-outline-secondary">사용자10 (user10@test.com)</button>
                    <button type="button" id="btnUserLogin11" class="btn btn-outline-secondary">사용자11 (user11@test.com)</button>
                    <button type="button" id="btnUserLogin12" class="btn btn-outline-secondary">사용자12 (user12@test.com)</button>
                    <button type="button" id="btnUserLogin13" class="btn btn-outline-secondary">사용자13 (user13@test.com)</button>
                    <button type="button" id="btnUserLogin14" class="btn btn-outline-secondary">사용자14 (user14@test.com)</button>
                    <button type="button" id="btnUserLogin15" class="btn btn-outline-secondary">사용자15 (user15@test.com)</button>
                    <button type="button" id="btnUserLogin16" class="btn btn-outline-secondary">사용자16 (user16@test.com)</button>
                    <button type="button" id="btnUserLogin17" class="btn btn-outline-secondary">사용자17 (user17@test.com)</button>
                    <button type="button" id="btnUserLogin18" class="btn btn-outline-secondary">사용자18 (user18@test.com)</button>
                    <button type="button" id="btnUserLogin19" class="btn btn-outline-secondary">사용자19 (user19@test.com)</button>
                    <button type="button" id="btnUserLogin20" class="btn btn-outline-secondary">사용자20 (user20@test.com)</button>
                    
                    <%-- TODO: 나중에 여기에 버튼을 계속 추가하면 됩니다. --%>

                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
