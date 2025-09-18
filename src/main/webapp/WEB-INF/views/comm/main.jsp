<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${categoryCode} 커뮤니티</title>
    <style>
        body { font-family: sans-serif; }
        .container { display: flex; gap: 20px; padding: 20px; }
        .board { flex-grow: 1; }
        .chat { width: 300px; border: 1px solid #ccc; padding: 10px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        a { text-decoration: none; color: #007bff; }
        .btn { padding: 8px 12px; background-color: #007bff; color: white; border-radius: 4px; }
    </style>
</head>
<body>

    <h1>${categoryCode} 커뮤니티</h1>

    <div class="container">
        <div class="board">
            <h2>소통 게시판</h2>
            <p>
                <a href="/comm/${categoryCode}/board/form" class="btn">새 글 작성</a>
            </p>
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- 나중에 boardList를 받아서 반복문으로 처리할 부분 --%>
                    <tr>
                        <td>1</td>
                        <td>
                            <a href="/comm/${categoryCode}/board/1">첫 번째 게시글입니다.</a>
                        </td>
                        <td>user01</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td><a href="/comm/${categoryCode}/board/2">두 번째 게시글입니다.</a></td>
                        <td>user02</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="chat">
            <h2>오픈 채팅</h2>
            <div id="chat-messages" style="height: 400px; border: 1px solid #eee; overflow-y: auto; margin-bottom: 10px;">
                </div>
            <input type="text" style="width: calc(100% - 10px);" placeholder="메시지 입력...">
        </div>
    </div>

</body>
</html>