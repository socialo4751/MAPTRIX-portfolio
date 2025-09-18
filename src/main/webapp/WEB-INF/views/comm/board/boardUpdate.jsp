<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
</head>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
<body>

    <h1>게시글 수정</h1>
    <p><strong>카테고리:</strong> ${categoryCode}, <strong>게시글 번호:</strong> ${boardId}</p>
    <hr>
    
    <form action="/comm/${categoryCode}/board/${boardId}/update" method="post">
        <div>
            <label for="title">제목:</label><br>
            <input type="text" id="title" name="title" size="50" value="(임시) 게시글 제목 ${boardId}" required>
        </div>
        <br>
        <div>
            <label for="content">내용:</label><br>
            <textarea id="content" name="content" rows="10" cols="50" required>(임시) 게시글 내용입니다.</textarea>
        </div>
        <hr>
        <button type="submit">수정 완료</button>
        
        <a href="/comm/${categoryCode}/board/${boardId}">취소</a>
    </form>

</body>
</html>