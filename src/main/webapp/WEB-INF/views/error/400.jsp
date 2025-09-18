<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>400 잘못된 요청</title>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>

    <style>
        :root {
            --brand-navy: #0a3d62;
            --brand-navy-dark: #073251;
            --muted: #6b7280;
        }

        body {
            background-color: #fff;
            margin: 0;
        }

        .error-wrap {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 16px;
            text-align: center;
        }

        .error-box {
            max-width: 720px;
        }

        .error-code {
            font-size: clamp(48px, 8vw, 96px);
            font-weight: 900;
            color: var(--brand-navy);
            margin: 0;
        }

        .error-title {
            margin-top: 10px;
            font-size: 1.8rem;
            font-weight: 700;
            color: #0f172a;
        }

        .error-desc {
            margin-top: 14px;
            font-size: 1rem;
            line-height: 1.6;
            color: var(--muted);
        }

        .btn-group {
            margin-top: 32px;
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            font-size: 1rem;
            transition: background 0.2s ease;
        }

        .btn-primary {
            background: var(--brand-navy);
            color: #fff;
        }

        .btn-primary:hover {
            background: var(--brand-navy-dark);
        }

        .btn-ghost {
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #0f172a;
        }

        .btn-ghost:hover {
            background: #f8fafc;
        }
    </style>
</head>
<body>

<div class="error-wrap">
    <div class="error-box">
        <div class="error-code" style="margin-top: -150px;">400</div>
        <div class="error-title">잘못된 요청입니다</div>
        <p class="error-desc">
            전송하신 요청의 형식이 올바르지 않거나 필수 값이 누락되었습니다.<br/>
            주소(URL)나 입력 값을 다시 확인한 뒤 요청을 다시 시도해 주세요.
        </p>
        <div class="btn-group">
            <a href="javascript:history.back()" class="btn btn-ghost">이전으로</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">메인으로</a>
        </div>
    </div>
</div>

</body>
</html>
