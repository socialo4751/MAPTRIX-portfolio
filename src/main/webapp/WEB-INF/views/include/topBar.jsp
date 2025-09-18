<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>상단바 예제</title>
    <style>
        /* 기본 스타일 초기화 */
        body, html {
            margin: 0;
            padding: 0;
            font-family: 'Malgun Gothic', '맑은 고딕', sans-serif;
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        ul {
            list-style: none;
            margin: 0;
            padding: 0;
        }

        /* 전체 헤더 컨테이너 */
        header {
            width: 100%;
            border-bottom: 1px solid #e0e0e0;
        }

        /* --- 1. 상단 유틸리티 바 --- */
        .top-utility-bar {
            background-color: #f8f9fa; /* 연한 회색 배경 */
            padding: 4px 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: #555;
            border-bottom: 1px solid #e9ecef;
        }

        .top-utility-bar .left-links a,
        .top-utility-bar .right-links a,
        .top-utility-bar .right-links span {
            margin: 0 10px;
            display: inline-block;
        }
        
        /* '무료상담' 버튼 스타일 */
        .btn-consult {
            background-color: #19a538; /* 초록색 */
            color: white;
            font-weight: bold;
            padding: 8px 15px;
            border-radius: 5px;
            font-size: 13px;
        }

        /* --- 2. 메인 내비게이션 바 --- */
        .main-navigation-bar {
            background-color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 50px;
        }

        /* 로고 스타일 */
        .logo {
            display: flex;
            align-items: center;
            font-weight: bold;
        }
        .logo .main-title {
            font-size: 28px;
            color: #2c2f79;
        }
        .logo .sub-title {
            font-size: 28px;
            color: #19a538;
            margin-left: 8px;
        }

        /* 메인 메뉴 스타일 */
        .main-menu {
            display: flex;
        }

        .main-menu li a {
            padding: 10px 20px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            transition: color 0.2s ease-in-out;
        }

        .main-menu li a:hover {
            color: #19a538; /* 호버 시 초록색 */
        }

    </style>
</head>
<body>
    <header>
        <div class="top-utility-bar">
            <div class="left-links">
                <a href="#1">소상공인시장진흥공단</a>
                <a href="#2">소상공인24</a>
                <a href="#3">중소벤처기업부</a>
            </div>
            <div class="right-links">
                <a href="#consult" class="btn-consult">무료상담</a>
                <span><strong>김창업</strong>님</span>
                <a href="#my">마이페이지</a>
                <a href="#logout">로그아웃</a>
                <a href="#menu">☰</a>
            </div>
        </div>

        <div class="main-navigation-bar">
            <div class="logo">
                <span class="main-title">상권분석</span>
            </div>

            <nav>
                <ul class="main-menu">
                    <li><a href="#intro">사이트 소개</a></li>
                    <li><a href="#data">상권 데이터 분석</a></li>
                    <li><a href="#startup-support">창업 지원</a></li>
                    <li><a href="#startup-calc">창업 정밀 계산기</a></li>
                    <li><a href="#region-info">지역 특화 정보</a></li>
                    <li><a href="#customer-service">고객센터</a></li>
                    <li><a href="/my">마이페이지</a></li>
                </ul>
            </nav>
        </div>
    </header>

</body>
</html>