<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 상세</title>
</head>
<body>

    <h1>게시글 상세 보기</h1>
    <p><strong>카테고리:</strong> ${categoryCode}, <strong>게시글 번호:</strong> ${boardId}</p>
    <hr>

    <div>
        <h3>(임시) 게시글 제목 ${boardId}</h3>
        <p>작성자: user01</p>
        <p>작성일: 2025-07-18</p>
        <div style="border: 1px solid #ccc; padding: 10px; min-height: 200px;">
            (임시) 게시글 내용입니다.
        </div>
    </div>
    <hr>
    
    <a href="/comm/${categoryCode}">목록</a>

    <a href="/comm/${categoryCode}/board/${boardId}/edit">수정</a>
    
    <form action="/comm/${categoryCode}/board/${boardId}/delete" method="post" style="display:inline;">
        <button type="submit" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</button>
    </form>
    
</body>
</html>