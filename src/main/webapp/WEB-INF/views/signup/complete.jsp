<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="step" value="${sessionScope.SIGNUP_STEP}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/signupstyle.css" />

    <style>
        .completion-box {
            background: #fff;
            border-radius: 6px;
            padding: 40px 30px;
            text-align: center;
            margin: 30px 0;
        }

        @keyframes pop {
            0%   { opacity: 0; transform: scale(0.3) rotate(-20deg); }
            60%  { opacity: 1; transform: scale(1.2) rotate(10deg); }
            100% { opacity: 1; transform: scale(1) rotate(0deg); }
        }

        .completion-box .icon {
            display: inline-block;
            font-size: 50px;
            color: #2ecc71;
            margin-bottom: 15px;
            opacity: 0;
            animation: pop 0.6s ease-out forwards;
            animation-delay: 0.2s;
        }

        .completion-box h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
            color: #333;
        }
        .completion-box p {
            font-size: 1em;
            color: #666;
            line-height: 1.6;
            margin: 0;
        }

        /* 버튼 그룹 - 통일된 스타일 */
        .form-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-top: 40px;
        }
        .btn-primary,
        .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 48px;
            padding: 0 28px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: #00796b;
            color: #fff;
        }
        .btn-primary:hover {
            background-color: #00695c;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #e0e0e0;
            color: #333;
        }
        .btn-secondary:hover {
            background-color: #d5d5d5;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
<div class="container">
    <main>
        <div class="signup-header">
            <h2>회원가입</h2>
        </div>

		<ol class="steps">
    		<li class="active">STEP 01. 약관동의</li>
    		<li class="active">STEP 02. 정보 입력</li>
    		<li class="active">STEP 03. 가입 완료</li>
    		<li>STEP 04. 사업자등록번호 등록 (선택)</li>
		</ol>

        <div class="completion-box">
            <div class="icon">✔</div>
            <h3>회원가입이 완료되었습니다.</h3>
            <p>
                <strong>홍길동님</strong>께서
                대전 상권 데이터 포털의 회원이 되신 것을
                진심으로 환영합니다.<br/>
                더 정확한 맞춤형 정보를 원하시면 사업자 정보를 등록해주세요.
            </p>
        </div>

        <div class="form-buttons">
            <c:url var="homeUrl" value="/" />
            <c:url var="bizUrl"  value="/sign-up/biz" />
            <button type="button" class="btn-secondary"
                    onclick="location.href='${homeUrl}'">
                메인으로
            </button>
            <button type="button" class="btn-primary"
                    onclick="location.href='${bizUrl}'">
                다음단계
            </button>
        </div>
    </main>
</div>
</body>
</html>
