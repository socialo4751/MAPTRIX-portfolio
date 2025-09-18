<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><c:out value="${bizInfo.bizName}"/> 커뮤니티 - 대전 상권 데이터 포털</title>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="/css/commstyle.css">
    <style>
        /* ===== 기본 레이아웃 ===== */
        .community-header {
            margin: 20px 0 40px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
            font-family: 'GongGothicMedium', sans-serif;
        }

        .main-content {
            display: flex;
            gap: 20px;
        }

        .board-area {
            flex: 2;
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
        }

        /* ===== 게시판 리스트 ===== */
        .board-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .board-table {
            width: 100%;
            border-collapse: collapse;
        }

        .board-table th, .board-table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
            text-align: center;
        }

        .board-table th {
            background: #f8f9fa;
        }

        .board-table .title {
            text-align: left;
        }

        .board-table .title a {
            color: #333;
            text-decoration: none;
        }

        .board-table .title a:hover {
            text-decoration: underline;
        }

        /* ===== 페이징 ===== */
        .pagination {
            display: flex;
            list-style: none;
            justify-content: center;
            margin-top: 20px;
            padding: 0;
        }

        .page-link {
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            color: #007bff;
            text-decoration: none;
        }

        .page-item.active .page-link {
            background: #007bff;
            color: #fff;
            border-color: #007bff;
        }

        .page-item.disabled .page-link {
            color: #6c757d;
            background: #fff;
            border-color: #dee2e6;
        }

        /* ===== 글쓰기 폼 ===== */
        .post-form-container {
            padding: 20px;
            background: #f9f9f9;
            border-radius: 8px;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, .05);
        }

        .post-form-container label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: #555;
        }

        .post-form-container input[type="text"],
        .post-form-container textarea {
            width: calc(100% - 24px);
            padding: 12px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1em;
            box-sizing: border-box;
        }

        .post-form-container textarea {
            min-height: 150px;
            resize: vertical;
        }

        .form-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }

        /* ===== 버튼 공통 & 상태 ===== */
        .btn-primary, .btn-secondary, .btn-danger, .btn-success,
        #submitCommentBtn, #categoryGoBtn, #writePostBtn, #cancelPostBtn, #chatSendBtn, .comment-del-btn {
            border: none;
            border-radius: 20px;
            font-weight: 700;
            font-size: 15px;
            padding: 10px 24px;
            cursor: pointer;
            transition: transform .1s ease, box-shadow .2s ease, background-color .2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary, .btn-success, #writePostBtn, #submitPostBtn, #categoryGoBtn, #submitCommentBtn {
            background: #3B82F6;
            color: #fff;
        }

        .btn-primary:hover, .btn-success:hover, #writePostBtn:hover, #submitPostBtn:hover, #categoryGoBtn:hover, #submitCommentBtn:hover {
            background: #2563EB;
            box-shadow: 0 4px 12px rgba(59, 130, 246, .3);
            transform: translateY(-2px);
        }

        .btn-secondary, #cancelPostBtn {
            background: #e4e6eb;
            color: #333;
        }

        .btn-secondary:hover, #cancelPostBtn:hover {
            background: #d8dbe0;
            box-shadow: 0 4px 10px rgba(0, 0, 0, .08);
            transform: translateY(-2px);
        }

        .btn-danger, .comment-del-btn {
            background: #f1f3f5;
            color: #e53e3e;
            font-size: 13px;
            padding: 6px 16px;
        }

        .btn-danger:hover, .comment-del-btn:hover {
            background: #e53e3e;
            color: #fff;
            box-shadow: 0 4px 12px rgba(229, 62, 62, .3);
            transform: translateY(-2px);
        }

        #writePostBtn::before {
            content: '\f304';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            margin-right: 8px;
        }

        /* ===== 채팅 영역 ===== */
        .chat-area {
            flex: 1;
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            height: 850px;
        }

        .chat-header {
            text-align: center;
            font-weight: 700;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            flex-shrink: 0;
        }

        .chat-messages {
            flex-grow: 1;
            overflow-y: auto;
            border: 1px solid #eee;
            margin: 10px 0;
            padding: 10px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .chat-input-area {
            display: flex;
            gap: 5px;
            flex-shrink: 0;
        }

        .chat-input-area textarea {
            flex-grow: 1;
            resize: none;
        }

        .message {
            max-width: 75%;
            display: flex;
            align-items: flex-end;
            gap: 8px;
        }

        .message .content {
            padding: 10px 14px;
            border-radius: 18px;
            line-height: 1.4;
            word-break: break-word;
        }

        .message .timestamp {
            font-size: 12px;
            color: #999;
            white-space: nowrap;
            margin-bottom: 2px;
        }

        .message.me {
            align-self: flex-end;
            flex-direction: column;
            gap: 4px;
        }

        .message.me .content {
            background: #3498db;
            color: #fff;
            border-top-right-radius: 4px;
        }

        .message.me .timestamp {
            order: 1;
        }

        .message.other {
            align-self: flex-start;
            display: flex;
            flex-direction: column;
            gap: 0;
            align-items: flex-start;
        }

        .message.other .sender {
            font-size: 13px;
            font-weight: 700;
            color: #555;
            margin: 0 0 4px 4px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            line-height: 1.2;
        }

        .message.other .content-wrapper {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            gap: 4px;
        }

        .message.other .content {
            background: #f1f3f5;
            color: #333;
            border-top-left-radius: 4px;
        }

        /* 관리자 표시(아이콘은 crown이든 shield든 색만 통일) */
        .message.other .sender.admin .name {
            color: #e74c3c;
            font-weight: 700;
        }

        .message.other .sender.admin i {
            color: #e74c3c;
            margin-right: 2px;
        }

        .message.system {
            align-self: center;
            text-align: center;
            background: #e9e9e9;
            color: #555;
            font-size: 13px;
            padding: 6px 12px;
            border-radius: 15px;
            margin: 10px 0;
            font-weight: bold;
        }

        /* ===== 게시글 상세 ===== */
        .post-detail-container {
            padding: 20px;
        }

        .post-detail-container .post-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
        }

        .post-detail-container .post-title {
            margin: 0;
            font-size: 22px;
            font-weight: 700;
        }

        .post-detail-container .post-actions {
            display: flex;
            gap: 8px;
            margin: 0;
        }

        .post-info {
            color: #666;
            margin-bottom: 20px;
        }

        .post-content {
            min-height: 200px;
            padding: 20px 0;
            border-bottom: 1px solid #eee;
            line-height: 1.7;
            word-break: break-word;
        }

        .post-content img {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
        }

        /* ===== 댓글 영역 ===== */
        .comments-section {
            margin-top: 24px;
        }

        .comments-section h3, #comment-section h4 {
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin: 0 0 12px;
        }

        .comment-item {
            padding: 12px 0;
            border-bottom: 1px dotted #ddd;
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 6px;
        }

        .comment-content {
            margin-left: 4px;
        }

        /* 댓글 입력: 세로 스택 + 버튼을 아래 오른쪽 */
        #comment-section .comment-input-area {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            gap: 8px;
            margin-top: 16px;
        }

        #comment-section .comment-input-area textarea {
            width: 100%;
            min-height: 140px;
            padding: 12px 14px;
            font-size: 14px;
            line-height: 1.5;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            background: #fff;
            box-shadow: inset 0 1px 2px rgba(0, 0, 0, .03);
            resize: none;
        }

        #comment-section #submitCommentBtn {
            align-self: flex-end;
            height: 38px;
        }

        /* ===== 카테고리 네비게이터 ===== */
        .category-navigator {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, .05);
        }

        .category-navigator h3 {
            margin: 0 0 15px;
            font-size: 1.1em;
            color: #333;
        }

        .selector-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .selector-group select {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            height: 38px;
        }

        .selector-group select:first-child {
            min-width: 180px;
        }

        .selector-group select:nth-child(2) {
            min-width: 220px;
        }

        .selector-group button {
            padding: 0 20px;
            height: 38px;
        }

        #categoryGoBtn {
            white-space: nowrap;
        }

        /* ===== 전송 버튼(채팅) 원형 스타일 ===== */
        #chatSendBtn {
            font-size: 18px;
            padding: 0;
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: #f0f2f5;
            color: #bcc0c4;
            flex-shrink: 0;
            text-indent: -9999px;
            position: relative;
            overflow: hidden;
        }

        #chatSendBtn.is-active {
            background: #FEE500;
            color: #333;
        }

        #chatSendBtn.is-active:hover {
            background: #fddc00;
            box-shadow: 0 4px 12px rgba(254, 229, 0, .4);
            transform: translateY(-2px);
        }

        #chatSendBtn::after {
            content: '\f1d8';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            text-indent: 0;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }

        /* ===== 반응형 보정 ===== */
        @media (max-width: 640px) {
            #comment-section #submitCommentBtn {
                width: 100%;
                height: 40px;
            }
        }
    </style>

</head>
<body>
<jsp:include page="/WEB-INF/views/include/top.jsp"/>

<div class="container">
    <main>
        <div class="community-header">
            <h2
                    style="display: flex; align-items: center; gap: 8px; position: relative; justify-content: center;">
                <c:out value="${bizInfo.bizName}"/>
                커뮤니티
            </h2>
            <c:if test="${not empty errorMessage}">
                <p style="color: red;">
                    <c:out value="${errorMessage}"/>
                </p>
            </c:if>
        </div>

        <div class="category-navigator">
            <h3><i class="fas fa-map-signs"></i> 다른 커뮤니티로 이동</h3>
            <div class="selector-group">
                <select id="mainCategorySelect" class="form-control">
                    <option value="">:: 대분류 선택 ::</option>
                    <c:forEach var="mainCat" items="${mainCategories}">
                        <option value="${mainCat.bizCodeId}">${mainCat.bizName}</option>
                    </c:forEach>
                </select>
                <select id="subCategorySelect" class="form-control" disabled>
                    <option value="">:: 중분류 선택 ::</option>
                </select>
                <button id="categoryGoBtn" class="btn-primary" disabled>이동</button>
            </div>
        </div>

        <div class="main-content">
            <div class="board-area">
                <div id="board-list-view">
                    <div class="board-header">
                        <h3 style="margin: 0;">게시판</h3>
                        <c:choose>
                            <c:when test="${empty loginUserId}">
                                <button id="writePostBtn" class="btn-success" disabled title="로그인 후 이용 가능합니다.">새 글 작성</button>
                            </c:when>
                            <c:otherwise>
                                <button id="writePostBtn" class="btn-success">새 글 작성</button>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div id="board-content">
                        <p>게시글을 불러오는 중입니다...</p>
                    </div>
                    <div id="pagination-area"></div>
                </div>

                <div id="post-form-view" style="display: none;">
                    <div class="post-form-container">
                        <h3 id="formTitle">새 게시글 작성</h3>
                        <form id="postForm" enctype="multipart/form-data">
                            <div>
                                <label for="postTitle">제목</label> <input type="text"
                                                                         id="postTitle" name="title" required>
                            </div>
                            <div>
                                <label for="postContent">내용</label>
                                <div id="ckeditor-container"></div>
                                <textarea id="postContent" name="content" style="display: none;"></textarea>
                            </div>
                            <div>
                                <label for="attachments">첨부파일</label> <input type="file"
                                                                             id="attachments" name="attachments"
                                                                             multiple>
                            </div>
                            <div class="form-buttons">
                                <button type="submit" id="submitPostBtn" class="btn-primary">등록</button>
                                <button type="button" id="cancelPostBtn" class="btn-secondary">취소</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div id="post-detail-view" style="display: none;">
                    <div id="post-detail-container"></div>
                    <div id="attachments-area"></div>
                    <section id="comment-section" class="comments-section">
                        <h4>댓글</h4>
                        <div id="comment-list"></div>
                        <div id="comment-form" class="comment-input-area">
                            <textarea id="newCommentContent" placeholder="댓글을 입력하세요"></textarea>
                            <button id="submitCommentBtn" class="btn-primary">댓글 등록</button>
                        </div>
                    </section>
                </div>

            </div>

            <div class="chat-area">
                <div class="chat-header">
                    <c:out value="${room.roomName}"/>
                </div>
                <div class="chat-messages" id="chatMessages">
                    <%-- 기존 메시지 내역이 있다면 JSTL로 미리 출력 --%>
                    <c:if test="${not empty messageHistory}">
                        <c:forEach var="msg" items="${messageHistory}">
                            <c:choose>
                                <%-- 내 메시지일 경우 --%>
                                <c:when test="${msg.senderId == loginUserId}">
                                    <div class="message me">
                                        <div class="content">
                                            <c:out value="${msg.content}"/>
                                        </div>
                                        <div class="timestamp">
                                            <fmt:formatDate value="${msg.sentAt}" pattern="a hh:mm"/>
                                        </div>
                                    </div>
                                </c:when>

                                <%-- 다른 사람 메시지일 경우 --%>
                                <c:otherwise>
                                    <%-- 닉네임의 공백을 제거하고, 관리자인지 여부를 변수에 미리 저장합니다. --%>
                                    <c:set var="trimmedNickname" value="${fn:trim(msg.senderNickname)}"/>
                                    <c:set var="isAdmin" value="${trimmedNickname == '관리자'}"/>

                                    <div class="message other">
                                        <div class="sender${isAdmin ? ' admin' : ''}">
                                                <%-- 관리자일 경우에만 아이콘을 표시합니다. --%>
                                            <c:if test="${isAdmin}">
                                                <i class="fas fa-user-shield"></i>
                                            </c:if>

                                                <%-- 닉네임 텍스트를 span으로 감싸서 스타일 관리를 편하게 합니다. --%>
                                            <span class="name">
                <c:choose>
                    <c:when test="${not empty trimmedNickname}">
                        <c:out value="${trimmedNickname}"/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${fn:split(msg.senderId, '@')[0]}"/>
                    </c:otherwise>
                </c:choose>
            </span>
                                        </div>
                                        <div class="content-wrapper">
                                            <div class="content">
                                                <c:out value="${msg.content}"/>
                                            </div>
                                            <div class="timestamp">
                                                <fmt:formatDate value="${msg.sentAt}" pattern="a hh:mm"/>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:if>

                </div>

                <div class="chat-input-area">
                    <textarea id="chatInput" rows="3"></textarea>
                    <button id="chatSendBtn" class="btn-primary">전송</button>
                </div>
            </div>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>


<!-- JSP 값 → JS 전역 변수(안전하게 c:out 사용) -->
<script>
    window.contextPath = '<c:out value="${pageContext.request.contextPath}" />';
    window.bizCodeId = '<c:out value="${bizInfo.bizCodeId}" />';
    window.chatRoomId = '<c:out value="${room.roomId}" />';

    // 이제 컨트롤러에서 직접 전달받으므로, 이 값들이 항상 최신 상태를 보장합니다.
    window.loginUserId = '<c:out value="${loginUserId}" />';
    window.loginUserRole = '<c:out value="${loginUserRole}" />';
    window.virtualNickname = '<c:out value="${virtualNickname}" />';
</script>

<!-- CKEditor -->
<script src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>

<!-- ===== 게시판/댓글/첨부 전체 로직 ===== -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // 전역/환경
        const contextPath = window.contextPath || '';
        const bizCodeId = (window.bizCodeId || '').trim();

        // 카테고리 이동 DOM
        const mainCategorySelect = document.getElementById('mainCategorySelect');
        const subCategorySelect = document.getElementById('subCategorySelect');
        const categoryGoBtn = document.getElementById('categoryGoBtn');

        // 리스트/상세/폼 DOM
        const boardListView = document.getElementById('board-list-view');
        const postFormView = document.getElementById('post-form-view');
        const postDetailView = document.getElementById('post-detail-view');

        const boardContentDiv = document.getElementById('board-content');
        const paginationAreaDiv = document.getElementById('pagination-area');

        const writePostBtn = document.getElementById('writePostBtn');
        const postForm = document.getElementById('postForm');
        const postTitleInput = document.getElementById('postTitle');
        const submitPostBtn = document.getElementById('submitPostBtn');
        const cancelPostBtn = document.getElementById('cancelPostBtn');
        const ckeditorContainer = document.querySelector('#ckeditor-container');

        // 상세/댓글 DOM
        const postDetailContainer = document.getElementById('post-detail-container');
        const commentList = document.getElementById('comment-list');
        const newCommentContent = document.getElementById('newCommentContent');
        const submitCommentBtn = document.getElementById('submitCommentBtn');

        // 상태
        let editor;
        let currentPostId = null;
        let isSubmittingComment = false;
		
        if (submitCommentBtn) {
            submitCommentBtn.addEventListener('click', function () {
                // 버튼을 '클릭하는 시점'에 화면(DOM)에 명시된 게시글 ID를 가져옵니다.
                // 이렇게 하면 백그라운드에서 다른 스크립트가 내부 변수를 바꿔도 영향을 받지 않습니다.
                const currentVisiblePostId = postDetailContainer.dataset.postId;

                if (currentVisiblePostId) {
                    submitComment(currentVisiblePostId);
                } else {
                    console.error('화면에서 현재 게시물 ID를 찾을 수 없습니다.');
                    showMessageBox('게시글 정보를 찾을 수 없어 댓글을 등록할 수 없습니다.');
                }
            });
        }
        
        // 유틸
        const joinUrl = (base, path) =>
            String(base || '').replace(/\/+$/, '') + '/' + String(path || '').replace(/^\/+/, '');

        // 본문 내 /media/ 경로를 contextPath 포함으로 보정
        const fixMediaSrc = (html) => {
            const base = String(contextPath || '').replace(/\/+$/, '');
            return String(html || '')
                .replace(/src="\/media\//g, 'src="' + base + '/media/')
                .replace(/src='\/media\//g, "src='" + base + "/media/");
        };

        // ===== 카테고리 네비게이터 =====
        mainCategorySelect.addEventListener('change', function () {
            const parentCodeId = this.value;
            subCategorySelect.innerHTML = '<option value="">:: 중분류 선택 ::</option>';
            subCategorySelect.disabled = true;
            categoryGoBtn.disabled = true;

            if (!parentCodeId) return;

            const requestUrl = `${contextPath}/comm/sub-categories/` + parentCodeId;

            fetch(requestUrl)
                .then(r => {
                    if (!r.ok) throw new Error('중분류 로드 실패');
                    return r.json();
                })
                .then(subs => {
                    subs.forEach(item => subCategorySelect.add(new Option(item.bizName, item.bizCodeId)));
                    subCategorySelect.disabled = false;
                })
                .catch(err => console.error('중분류 로드 오류:', err));
        });

        subCategorySelect.addEventListener('change', function () {
            categoryGoBtn.disabled = !this.value;
        });

        categoryGoBtn.addEventListener('click', function () {
            const selectedBizCode = subCategorySelect.value;
            if (selectedBizCode) window.location.href = `${contextPath}/comm/free/` + selectedBizCode;
        });

        // ===== 뷰 전환 =====
        const showView = (viewId) => {
            boardListView.style.display = 'none';
            postFormView.style.display = 'none';
            postDetailView.style.display = 'none';
            document.getElementById(viewId).style.display = 'block';
        };

        const showMessageBox = (message, callback) => {
            alert(message);
            if (callback) callback();
        };

        // ===== 목록 렌더 =====
        const renderPostList = function (posts, pageInfo) {
            if (!posts || posts.length === 0) {
                boardContentDiv.innerHTML = '<p style="text-align: center; color: #666;">게시글이 없습니다.</p>';
                return;
            }
            let html = ''
                + '<table class="board-table">'
                + '  <thead>'
                + '    <tr>'
                + '      <th style="width:10%;">번호</th>'
                + '      <th style="width:50%;">제목</th>'
                + '      <th style="width:15%;">작성자</th>'
                + '      <th style="width:15%;">작성일</th>'
                + '      <th style="width:10%;">조회수</th>'
                + '    </tr>'
                + '  </thead>'
                + '  <tbody>';

            posts.forEach(post => {
                const createdDate = post.createdAt ? new Date(post.createdAt).toLocaleDateString('ko-KR') : '';
                const writer = post.writerName || (post.userId ? post.userId.split('@')[0] : '알 수 없음');
                html += ''
                    + '<tr>'
                    + '<td>' + (post.rnum ?? '') + '</td>'
                    + '<td class="title">'
                    + '<a href="#" class="post-title-link" data-post-id="' + post.postId + '">' + (post.title || '') + '</a>'
                    + '</td>'
                    + '<td>' + writer + '</td>'
                    + '<td>' + createdDate + '</td>'
                    + '<td>' + ((post.viewCount != null) ? post.viewCount : 0) + '</td>'
                    + '</tr>';
            });

            html += '</tbody></table>';
            boardContentDiv.innerHTML = html;
        };

        // ===== 페이징 렌더 =====
        const renderPagination = function (pageInfo) {
            const totalPages = pageInfo.totalPages || 1;
            const currentPage = pageInfo.currentPage || 1;
            const startPage = pageInfo.startPage || 1;
            const endPage = pageInfo.endPage || totalPages;

            let html = '<ul class="pagination">';
            const prevDisabled = currentPage === 1 ? 'disabled' : '';
            html += '<li class="page-item ' + prevDisabled + '">'
                + '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">이전</a>'
                + '</li>';

            for (let i = startPage; i <= endPage; i++) {
                const active = currentPage === i ? 'active' : '';
                html += '<li class="page-item ' + active + '">'
                    + '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>'
                    + '</li>';
            }

            const nextDisabled = currentPage === totalPages ? 'disabled' : '';
            html += '<li class="page-item ' + nextDisabled + '">'
                + '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">다음</a>'
                + '</li>'
                + '</ul>';

            paginationAreaDiv.innerHTML = html;
        };

        // ===== 목록 호출 (★ 여기서 페이징 노출 가드 처리) =====
        const showPostList = function (page) {
            page = page || 1;
            showView('board-list-view');
            boardContentDiv.innerHTML = '<p style="text-align: center;">게시글을 불러오는 중입니다...</p>';
            paginationAreaDiv.innerHTML = '';

            if (!bizCodeId) {
                boardContentDiv.innerHTML =
                    '<p style="color:red; text-align:center;">카테고리 코드(bizCodeId)가 없습니다. 컨트롤러에서 bizInfo.bizCodeId를 모델에 담아주세요.</p>';
                console.warn('bizCodeId is empty. Check the JSP model attribute: bizInfo.bizCodeId');
                return;
            }

            const url = joinUrl(contextPath, '/api/comm/free/' + encodeURIComponent(bizCodeId) + '/posts?currentPage=' + page);

            fetch(url, {credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('목록 조회 실패 (' + res.status + ')');
                    return res.json();
                })
                .then(data => {
                    const posts = data.content || [];
                    renderPostList(posts, data);

                    // ✅ 게시글이 1개 이상일 때만 페이징 표시
                    if (posts.length > 0) {
                        renderPagination(data);
                    } else {
                        paginationAreaDiv.innerHTML = ''; // 감추기
                    }

                    // (원한다면 한 페이지뿐이면 숨기기)
                    // if (posts.length > 0 && (data.totalPages ?? 1) > 1) renderPagination(data); else paginationAreaDiv.innerHTML = '';
                })
                .catch(err => {
                    console.error('목록 조회 에러:', err);
                    boardContentDiv.innerHTML = '<p style="color:red; text-align:center;">' + err.message + '</p>';
                });
        };

        // ===== 상세 호출 =====
        const showPostDetail = function (postId) {
            postId = Number(postId);
            if (!postId) return;

            currentPostId = postId;
            showView('post-detail-view');

            if (postDetailContainer) {
                postDetailContainer.innerHTML = '<div class="post-detail-container"><h1>게시글을 불러오는 중...</h1></div>';
            }

            const url = joinUrl(contextPath, '/api/comm/free/posts/' + postId);
            fetch(url, {credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('게시글 조회 실패: ' + res.status);
                    return res.json();
                })
                .then(data => {
                    const post = data.post || {};
                    currentPostId = post.postId || null;
                    if (postDetailContainer) {
                        postDetailContainer.dataset.postId = String(post.postId || '');
                        postDetailContainer.setAttribute('data-current-post-id', String(post.postId || ''));
                    }

                    const comments = data.comments || [];
                    const currentUserId = data.currentUserId || '';
                    const currentUserRole = data.currentUserRole || '';
                    window.loginUserId = currentUserId || window.loginUserId || '';
                    window.loginUserRole = currentUserRole || window.loginUserRole || '';

                    const createdDate = post.createdAt ? new Date(post.createdAt).toLocaleDateString('ko-KR') : '';
                    const writer = post.writerName || (post.userId ? post.userId.split('@')[0] : '알 수 없음');

                    const isPostAuthor = !!(currentUserId && post.userId && currentUserId === post.userId);
                    const isAdmin = !!(currentUserRole && currentUserRole.toUpperCase().includes('ADMIN'));

                    let postActionButtons = '<button id="backToListBtn" class="btn-secondary">목록으로</button>';
                    if (isPostAuthor || isAdmin) {
                        if (isPostAuthor) postActionButtons += '<button id="editPostBtn" class="btn-primary">수정</button>';
                        postActionButtons += '<button id="deletePostBtn" class="btn-danger">삭제</button>';
                    }

                    // 본문 렌더
                    if (postDetailContainer) {
                        const fixedContent = fixMediaSrc(post.content || '');
                        postDetailContainer.innerHTML =
                            '<div class="post-detail-container">'
                            + '  <div class="post-header">'
                            + '    <h1 class="post-title">' + (post.title || '') + '</h1>'
                            + '    <div class="post-actions">' + postActionButtons + '</div>'
                            + '  </div>'
                            + '  <div class="post-info"><p>작성자: ' + writer + ' | 작성일: ' + createdDate + ' | 조회수: ' + (post.viewCount || 0) + '</p></div>'
                            + '  <hr>'
                            + '  <div class="post-content">' + fixedContent + '</div>'
                            + '  <div id="attachments-area"></div>'
                            + '</div>';
                    }

                    // 버튼 바인딩
                    const backBtn = document.getElementById('backToListBtn');
                    const editBtn = document.getElementById('editPostBtn');
                    const deleteBtn = document.getElementById('deletePostBtn');

                    backBtn && backBtn.addEventListener('click', () => showPostList());
                    editBtn && editBtn.addEventListener('click', () => showPostForm(post));
                    deleteBtn && deleteBtn.addEventListener('click', () => deletePost(post.postId));

                    // 첨부
                    if (post.fileGroupNo && Number(post.fileGroupNo) > 0) {
                        loadAttachments(post.fileGroupNo);
                    }

                    // 댓글
                    renderComments(comments, post, currentUserId, currentUserRole);
                    /*
                    if (submitCommentBtn) {
                        submitCommentBtn.onclick = null;
                        submitCommentBtn.addEventListener('click', () => submitComment(post.postId));
                    }*/
                })
                .catch(err => {
                    console.error('게시글 상세 조회 오류:', err);
                    showMessageBox('게시글을 불러오는 중 오류가 발생했습니다.');
                    if (postDetailContainer) {
                        postDetailContainer.innerHTML =
                            '<p>게시글을 불러오는 중 오류가 발생했습니다.</p><button id="backToListBtn" class="btn-secondary">목록으로</button>';
                        const backBtn = document.getElementById('backToListBtn');
                        backBtn && backBtn.addEventListener('click', () => showPostList());
                    }
                });
        };

        // ===== 댓글 렌더/갱신/CRUD =====
        function renderComments(comments, post, currentUserId, currentUserRole) {
            if (!commentList) return;
            if (!comments || comments.length === 0) {
                commentList.innerHTML = '<p style="color:#666;">아직 댓글이 없습니다.</p>';
                return;
            }
            const html = comments.map(c => {
                const u = c.userId ? c.userId.split('@')[0] : '익명';
                const t = c.createdAt ? new Date(c.createdAt).toLocaleString('ko-KR') : '';
                const canDelete = (currentUserId && c.userId === currentUserId)
                    || (currentUserRole && currentUserRole.toUpperCase().includes('ADMIN'))
                    || (post.userId && currentUserId && post.userId === currentUserId);
                return ''
                    + '<div class="comment-item">'
                    + '  <div class="comment-header"><span>' + u + '</span><span>' + t + '</span></div>'
                    + '  <div class="comment-content">' + (c.content || '') + '</div>'
                    + (canDelete ? '<div class="comment-actions" style="margin-top:6px;">'
                        + '    <button class="btn-danger comment-del-btn" data-comment-id="' + c.commentId + '">삭제</button>'
                        + '  </div>' : '')
                    + '</div>';
            }).join('');
            commentList.innerHTML = html;
        }

        const reloadComments = function (postId) {
            const url = joinUrl(contextPath, '/api/comm/free/posts/' + postId);
            fetch(url, {credentials: 'include'})
                .then(r => r.json())
                .then(d => {
                    const post = d.post || {};
                    const comments = d.comments || [];
                    const currentUserId = d.currentUserId || window.loginUserId || '';
                    const currentUserRole = d.currentUserRole || window.loginUserRole || '';
                    renderComments(comments, post, currentUserId, currentUserRole);
                })
                .catch(() => {
                });
        };

   

        const submitComment = function (postId) {
            // 1. 인자로 받은 postId를 명확히 숫자로 변환하여 사용하고, 유효하지 않으면 실행을 중단합니다.
            const finalPostId = Number(postId);
            if (!finalPostId) {
                return alert('게시글 ID가 올바르지 않습니다. 새로고침 후 다시 시도하세요.');
            }

            // 기존의 불안정한 postId 할당 로직을 제거합니다.
            // postId = Number(postId || currentPostId || document.getElementById('post-detail-container')?.dataset.postId);

            if (isSubmittingComment) return;

            const userId = window.loginUserId || '';
            const btn = document.getElementById('submitCommentBtn');
            const area = document.getElementById('newCommentContent');
            const content = (area && area.value ? area.value : '').trim();

            if (!userId) return alert('로그인이 필요합니다.');
            if (!content) return alert('댓글 내용을 입력하세요.');

            isSubmittingComment = true;
            btn && (btn.disabled = true);

            const fd = new FormData();
            fd.append('content', content);

            // 2. 전역 변수가 아닌, 인자로 받은 명확한 finalPostId를 사용하여 요청 URL을 생성합니다.
            const url = joinUrl(contextPath, '/api/comm/free/posts/' + finalPostId + '/comments');
            fetch(url, {method: 'POST', body: fd, credentials: 'include'})
                .then(r => {
                    if (!r.ok) throw new Error('fail');
                    return r.json();
                })
                .then(() => {
                    if (area) area.value = '';
                    // 3. 댓글 목록을 새로고침할 때도 전역 변수(currentPostId)가 아닌, 명확한 finalPostId를 사용합니다.
                    reloadComments(finalPostId);
                })
                .catch(() => alert('댓글 등록 중 오류가 발생했습니다.'))
                .finally(() => {
                    isSubmittingComment = false;
                    btn && (btn.disabled = false);
                });
        };

        if (commentList) {
            commentList.addEventListener('click', function (e) {
                const btn = e.target.closest('.comment-del-btn');
                if (!btn) return;
                
                const commentId = btn.getAttribute('data-comment-id');
                
                // 4. 댓글 삭제 시에도 클릭 시점의 postId를 DOM에서 직접 가져와 사용합니다.
                // 이렇게 하면 전역 변수인 currentPostId의 상태와 관계없이 안전하게 동작합니다.
                const currentVisiblePostId = postDetailContainer.dataset.postId;
                if (!currentVisiblePostId) {
                    alert("게시글 정보를 찾을 수 없어 댓글을 삭제할 수 없습니다.");
                    return;
                }
                deleteComment(commentId, currentVisiblePostId);
            });
        }

        const deleteComment = function (commentId, postId) {
            postId = Number(postId || currentPostId || document.getElementById('post-detail-container')?.dataset.postId);
            if (!postId) return alert('게시글 정보를 찾을 수 없습니다. 새로고침 후 다시 시도하세요.');
            if (!confirm('댓글을 삭제하시겠습니까?')) return;

            const url = joinUrl(contextPath, '/api/comm/free/comments/' + commentId);
            fetch(url, {method: 'DELETE', credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('삭제 실패');
                    return res.json();
                })
                .then(() => reloadComments(postId))
                .catch(err => {
                    console.error(err);
                    alert('댓글 삭제 중 오류가 발생했습니다.');
                });
        };

        // ===== 첨부 =====
        const loadAttachments = function (fileGroupNo) {
            let area = document.getElementById('attachments-area');
            if (!area && postDetailContainer) {
                area = document.createElement('div');
                area.id = 'attachments-area';
                postDetailContainer.appendChild(area);
            }
            if (!area) return;

            area.innerHTML = '<p>첨부파일을 불러오는 중...</p>';
            const url = joinUrl(contextPath, '/api/comm/free/files?groupNo=' + encodeURIComponent(fileGroupNo));
            fetch(url, {credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('파일 목록 조회 실패: ' + res.status);
                    return res.json();
                })
                .then(files => {
                    if (!files || files.length === 0) {
                        area.innerHTML = '';
                        return;
                    }
                    const extsImage = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
                    const items = files.map(f => {
                        const rel = (f.fileSaveLocate || '').replace('/media/', '');
                        const imgUrl = joinUrl(contextPath, '/media/' + rel);
                        const dlUrl = joinUrl(contextPath, '/download?fileName=' + encodeURIComponent(rel));
                        const name = f.fileOriginalName || '첨부파일';
                        const lower = name.toLowerCase();
                        const isImage = extsImage.some(ext => lower.endsWith(ext));

                        return isImage
                            ? '<div style="margin:6px 0">'
                            + '<a href="' + imgUrl + '" target="_blank" rel="noopener">'
                            + '<img src="' + imgUrl + '" alt="' + name + '"'
                            + ' style="max-width:100%;height:auto;border:1px solid #eee;border-radius:6px;padding:4px"/>'
                            + '</a>'
                            + '<div><a href="' + dlUrl + '">' + name + '</a></div>'
                            + '</div>'
                            : '<div style="margin:6px 0">'
                            + '<i class="fas fa-paperclip"></i> '
                            + '<a href="' + dlUrl + '">' + name + '</a>'
                            + '</div>';
                    }).join('');

                    area.innerHTML =
                        '<div style="margin:8px 0; padding:10px; border:1px solid #eee; border-radius:6px; background:#fafafa">'
                        + '<strong>첨부파일</strong>'
                        + '<div style="margin-top:8px">' + items + '</div>'
                        + '</div>';
                })
                .catch(err => {
                    console.error('첨부 불러오기 오류:', err);
                    area.innerHTML = '';
                });
        };

        // ===== 글쓰기/수정 =====
        const showPostForm = function (post) {
            showView('post-form-view');

            const isEditMode = !!post;
            document.getElementById('formTitle').innerText = isEditMode ? '게시글 수정' : '새 게시글 작성';
            submitPostBtn.innerText = isEditMode ? '수정' : '등록';

            if (isEditMode) {
                postForm.dataset.postId = post.postId;
                postTitleInput.value = post.title || '';
            } else {
                delete postForm.dataset.postId;
                postTitleInput.value = '';
            }

            if (editor && editor.destroy) editor.destroy();

            ClassicEditor.create(ckeditorContainer, {
                initialData: isEditMode ? (post.content || '') : '',
                simpleUpload: {
                    uploadUrl: joinUrl(contextPath, '/api/comm/free/images/upload'),
                    withCredentials: true,
                    headers: (function () {
                        const h = document.querySelector('meta[name="_csrf_header"]');
                        const t = document.querySelector('meta[name="_csrf"]');
                        return (h && t) ? {[h.content]: t.content} : {};
                    })()
                }
            })
                .then(newEditor => {
                    editor = newEditor;
                })
                .catch(error => {
                    console.error('CKEditor 초기화 중 오류:', error);
                    showMessageBox('에디터 로딩 중 오류가 발생했습니다.');
                });
        };

        const handlePostSubmit = function (e) {
            e.preventDefault();
            const title = postTitleInput.value.trim();
            const content = editor && editor.getData ? editor.getData() : '';
            if (!title || !String(content).trim()) {
                showMessageBox('제목과 내용을 모두 입력해주세요.');
                return;
            }

            const formData = new FormData();
            formData.append('title', title);
            formData.append('content', content);
            formData.append('catCodeId', bizCodeId);
            formData.append('bizCodeId', bizCodeId);

            const files = document.getElementById('attachments').files;
            for (let i = 0; i < files.length; i++) formData.append('attachments', files[i]);

            const postId = postForm.dataset.postId;
            const isEdit = !!postId;
            const method = isEdit ? 'PUT' : 'POST';
            const url = isEdit
                ? joinUrl(contextPath, '/api/comm/free/posts/' + postId)
                : joinUrl(contextPath, '/api/comm/free/posts');

            fetch(url, {method, body: formData, credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('게시글 저장 실패');
                    return res.json();
                })
                .then(() => showMessageBox('게시글이 성공적으로 저장되었습니다.', () => showPostList(1)))
                .catch(err => {
                    console.error('게시글 저장 오류:', err);
                    showMessageBox('게시글 저장 중 오류가 발생했습니다.');
                });
        };

        const deletePost = function (postId) {
            if (!confirm('정말로 이 게시글을 삭제하시겠습니까?')) return;
            const url = joinUrl(contextPath, '/api/comm/free/posts/' + postId);
            fetch(url, {method: 'DELETE', credentials: 'include'})
                .then(res => {
                    if (!res.ok) throw new Error('게시글 삭제 실패');
                    return res.json();
                })
                .then(() => showMessageBox('게시글이 삭제되었습니다.', () => showPostList(1)))
                .catch(err => {
                    console.error('게시글 삭제 오류:', err);
                    showMessageBox('게시글 삭제 중 오류가 발생했습니다.');
                });
        };

        // ===== 이벤트 바인딩 =====
        writePostBtn.addEventListener('click', () => showPostForm());
        postForm.addEventListener('submit', handlePostSubmit);
        cancelPostBtn.addEventListener('click', () => showPostList());

        boardContentDiv.addEventListener('click', function (event) {
            const a = event.target.closest('.post-title-link');
            if (!a) return;
            event.preventDefault();
            const id = Number(a.dataset.postId);
            if (!id) return;
            showPostDetail(id);
        });

        paginationAreaDiv.addEventListener('click', function (event) {
            const link = event.target.closest('a.page-link');
            if (!link) return;
            const li = link.closest('.page-item');
            if (li && li.classList.contains('disabled')) return;
            event.preventDefault();
            const page = Number(link.getAttribute('data-page'));
            showPostList(page);
        });

        // 초기 로드
        showPostList(1);
    });
</script>

<!-- SockJS/STOMP (채팅) 라이브러리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.6.1/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<!-- ===== 채팅 로직 ===== -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = window.contextPath || '';
        const roomId = window.chatRoomId;
        const loginUserId = window.loginUserId;
        const virtualNickname = window.virtualNickname;

        const chatMessagesDiv = document.getElementById('chatMessages');
        const chatInput = document.getElementById('chatInput');
        const chatSendBtn = document.getElementById('chatSendBtn');

        let stompClient;

        function scrollToBottom() {
            if (chatMessagesDiv) chatMessagesDiv.scrollTop = chatMessagesDiv.scrollHeight;
        }

        function appendSystemMessage(message) {
            const msgDiv = document.createElement('div');
            msgDiv.className = 'message system';
            const contentDiv = document.createElement('div');
            contentDiv.className = 'content';
            contentDiv.textContent = message;
            msgDiv.appendChild(contentDiv);
            chatMessagesDiv.appendChild(msgDiv);
            scrollToBottom();
        }

        function appendUserMessage(msg) {
            const isMe = loginUserId === msg.senderId;

            const messageDiv = document.createElement('div');
            messageDiv.classList.add('message', isMe ? 'me' : 'other');

            const contentDiv = document.createElement('div');
            contentDiv.className = 'content';
            contentDiv.textContent = msg.content;

            const timeStr = msg.sentAt
                ? new Date(msg.sentAt).toLocaleTimeString('ko-KR', {hour: '2-digit', minute: '2-digit', hour12: true})
                : new Date().toLocaleTimeString('ko-KR', {hour: '2-digit', minute: '2-digit', hour12: true});

            const timestampDiv = document.createElement('div');
            timestampDiv.className = 'timestamp';
            timestampDiv.textContent = timeStr;

            if (isMe) {
                messageDiv.appendChild(contentDiv);
                messageDiv.appendChild(timestampDiv);
            } else {
                const rawName = msg.senderNickname || (msg.senderId ? msg.senderId.split('@')[0] : '') || '관리자';
                const senderNameNoSpace = (rawName + '').replace(/\s+/g, '');
                const isAdmin = senderNameNoSpace === '관리자' || (msg.senderRole || '').toUpperCase().includes('ADMIN');

                const senderDiv = document.createElement('div');
                senderDiv.className = 'sender' + (isAdmin ? ' admin' : '');

                const nameSpan = document.createElement('span');
                nameSpan.className = 'name';
                nameSpan.textContent = rawName;
                senderDiv.appendChild(nameSpan);

                if (isAdmin) {
                    const crown = document.createElement('i');
                    crown.className = 'fas fa-crown';
                    crown.style.marginLeft = '4px';
                    crown.style.color = '#f39c12';
                    senderDiv.appendChild(crown);
                }

                const contentWrapper = document.createElement('div');
                contentWrapper.className = 'content-wrapper';
                contentWrapper.appendChild(contentDiv);
                contentWrapper.appendChild(timestampDiv);

                messageDiv.appendChild(senderDiv);
                messageDiv.appendChild(contentWrapper);
            }

            chatMessagesDiv.appendChild(messageDiv);
            scrollToBottom();
        }

        function sendMessage() {
            if (!stompClient || !stompClient.connected) {
                appendSystemMessage("서버에 연결되어 있지 않습니다.");
                return;
            }
            const msgContent = chatInput.value.trim();
            if (!msgContent) return;

            const chatMessage = {
                roomId,
                senderId: loginUserId,
                senderNickname: virtualNickname,
                content: msgContent
            };
            stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
            chatInput.value = '';
            chatInput.focus();
        }

        function connectWebSocket() {
            const socket = new SockJS(contextPath + '/ws/stomp');
            stompClient = Stomp.over(socket);
            stompClient.connect({}, function (frame) {
                console.log('[STOMP] Connected: ' + frame);
                if (window.virtualNickname) {
                    appendSystemMessage(window.virtualNickname + ' 님이 입장하였습니다.');
                } else {
                    appendSystemMessage('채팅방에 입장했습니다.');
                }
                stompClient.subscribe('/topic/room/' + roomId, function (message) {
                    try {
                        const msg = JSON.parse(message.body);
                        appendUserMessage(msg);
                    } catch (e) {
                        console.error("메시지 파싱 오류:", e);
                    }
                });
            }, function (error) {
                console.error('[STOMP] Connection error: ' + error);
                appendSystemMessage('서버 연결에 실패했습니다.');
            });
        }

        function initChat() {
            if (!roomId || !loginUserId) {
                if (chatInput) chatInput.disabled = true;
                if (chatSendBtn) chatSendBtn.disabled = true;
                appendSystemMessage(loginUserId ? '채팅방 정보를 찾을 수 없습니다.' : '로그인 후 채팅에 참여할 수 있습니다.');
                return;
            }
            if (!chatMessagesDiv || !chatInput || !chatSendBtn) {
                console.error("채팅에 필요한 HTML 요소를 찾을 수 없습니다.");
                return;
            }
            connectWebSocket();
        }

        // 이벤트
        if (chatSendBtn && chatInput) {
            chatSendBtn.addEventListener('click', sendMessage);
            chatInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    sendMessage();
                }
            });
            chatInput.addEventListener('input', function () {
                if (chatInput.value.trim().length > 0) chatSendBtn.classList.add('is-active');
                else chatSendBtn.classList.remove('is-active');
            });
        }

        // 초기화
        initChat();
        (function scrollOnce() {
            if (chatMessagesDiv) chatMessagesDiv.scrollTop = chatMessagesDiv.scrollHeight;
        })();
    });
</script>

</body>
</html>