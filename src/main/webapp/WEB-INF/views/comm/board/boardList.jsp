<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="/WEB-INF/views/include/topBar.jsp" %>
    <title>창업 후기 공유 게시판 - 목록</title>
    <style>
        /* 기본 스타일링 */
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 960px; /* 게시판에 맞게 너비 확장 */
            margin: 0 auto;
            background-color: #fff;
            padding: 30px;
            border: 1px solid #ddd;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }
        .board-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .board-header h2 {
            font-size: 24px;
            margin-bottom: 15px;
        }

        /* 게시판 고유 스타일 */
        .search-area {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 20px;
            gap: 10px;
        }
        .search-area select, .search-area input[type="date"], .search-area input[type="text"], .search-area button {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .search-area button {
            background-color: #00695c;
            color: white;
            cursor: pointer;
        }

        .post-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); /* 카드형 리스트 */
            gap: 20px;
            margin-bottom: 30px;
        }
        .post-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: transform 0.2s;
            cursor: pointer;
        }
        .post-card:hover {
            transform: translateY(-5px);
        }
        .post-card h3 {
            font-size: 18px;
            margin-top: 0;
            margin-bottom: 10px;
            color: #00695c;
        }
        .post-card p {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        .post-card .post-meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #999;
            margin-top: 15px;
        }

        .pagination {
            text-align: center;
            margin-top: 30px;
        }
        .pagination a {
            display: inline-block;
            padding: 8px 12px;
            border: 1px solid #ddd;
            margin: 0 5px;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
        }
        .pagination a.active {
            background-color: #00695c;
            color: white;
            border-color: #00695c;
        }

        .write-button-area {
            text-align: right;
            margin-bottom: 20px;
        }
        .write-button-area .btn-write {
            background-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
    </style>
</head>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
<body>

<div class="container">
    <main>
        <div class="board-header">
            <h2>창업 후기 공유 게시판</h2>
        </div>

        <div id="post-list-view">
            <div class="search-area">
                <input type="date" id="search-date-start">
                <span>~</span>
                <input type="date" id="search-date-end">
                <select id="search-type">
                    <option value="title_content">제목+내용</option>
                    <option value="title">제목</option>
                    <option value="content">내용</option>
                    <option value="author">작성자</option>
                </select>
                <input type="text" id="search-keyword" placeholder="검색어를 입력하세요">
                <button>검색</button>
            </div>

            <div class="write-button-area">
                <button type="button" class="btn-write" onclick="alert('글쓰기 화면으로 이동 (단독 파일에서는 동작 제한)');">글쓰기</button>
            </div>

            <div class="post-list">
                <div class="post-card" onclick="alert('상세 화면으로 이동 (단독 파일에서는 동작 제한)');">
                    <h3>[1] 성공적인 카페 창업 후기!</h3>
                    <p>작성자: 김철수</p>
                    <div class="post-meta">
                        <span>작성일: 2024-07-10</span>
                        <span>조회수: 125</span>
                    </div>
                </div>
                <div class="post-card" onclick="alert('상세 화면으로 이동 (단독 파일에서는 동작 제한)');">
                    <h3>[2] 온라인 쇼핑몰 시작의 모든 것</h3>
                    <p>작성자: 이영희</p>
                    <div class="post-meta">
                        <span>작성일: 2024-07-08</span>
                        <span>조회수: 98</span>
                    </div>
                </div>
                <div class="post-card" onclick="alert('상세 화면으로 이동 (단독 파일에서는 동작 제한)');">
                    <h3>[3] 요식업 창업, 이것만은 꼭!</h3>
                    <p>작성자: 박민수</p>
                    <div class="post-meta">
                        <span>작성일: 2024-07-05</span>
                        <span>조회수: 210</span>
                    </div>
                </div>
                <div class="post-card" onclick="alert('상세 화면으로 이동 (단독 파일에서는 동작 제한)');">
                    <h3>[4] IT 스타트업 초기 경험 공유</h3>
                    <p>작성자: 최지영</p>
                    <div class="post-meta">
                        <span>작성일: 2024-07-03</span>
                        <span>조회수: 75</span>
                    </div>
                </div>
                <div class="post-card" onclick="alert('상세 화면으로 이동 (단독 파일에서는 동작 제한)');">
                    <h3>[5] 프랜차이즈 가맹점 오픈 후기</h3>
                    <p>작성자: 한지훈</p>
                    <div class="post-meta">
                        <span>작성일: 2024-07-01</span>
                        <span>조회수: 150</span>
                    </div>
                </div>
            </div>

            <div class="pagination">
                <a href="#">&laquo;</a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#">&raquo;</a>
            </div>
        </div>

    </main>
</div>

<script>
    // showPostList, showPostDetail, showWriteForm, showEditForm, savePost, submitComment 함수는
    // 다른 파일이 없으므로 단독 실행 시 동작하지 않거나 경고 메시지를 표시합니다.
    // 각 링크/버튼의 onclick에 임시 alert를 추가했습니다.
</script>

</body>
</html>