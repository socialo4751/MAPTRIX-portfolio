<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 글 작성</title>
</head>
<body>

    <h1>새 글 작성</h1>
    <p><strong>카테고리:</strong> ${categoryCode}</p>
    <hr>
    
    <form action="/comm/${categoryCode}/board" method="post">
        <div>
            <label for="title">제목:</label><br>
            <input type="text" id="title" name="title" size="50" required>
        </div>
        <br>
        <div>
            <label for="content">내용:</label><br>
            <textarea id="content" name="content" rows="10" cols="50" required></textarea>
        </div>
        <hr>
        <button type="submit">등록</button>
        <a href="/comm/${categoryCode}">취소</a>
    </form>

</body>
</html>