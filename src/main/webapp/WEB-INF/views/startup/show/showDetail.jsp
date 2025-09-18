<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>${post.title} - 자랑 게시판</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
    <!-- Font Awesome (한 번만) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <!-- 공통 CSS (프로젝트 전역) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>

    <!-- ===== 페이지 전용 스타일: 전역 오염 방지를 위해 .post-detail-card 하위로 한정 ===== -->
    <style>
        /* 카드 래핑 */
        .post-detail-card {
            max-width: 1000px;
            margin: 40px auto;
            border-radius: 12px;
        }

        .post-detail-card .card-body {
            padding: 32px;
        }

        /* 헤더 */
        .post-detail-card .detail-header {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .post-detail-card .detail-header .page-title {
            font-size: 1.9rem;
            color: #333;
            margin: 0 0 10px 0;
            word-break: keep-all;
            font-weight: 700;
        }

        .post-detail-card .detail-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9em;
            color: #777;
            gap: 12px;
            flex-wrap: wrap;
        }

        .post-detail-card .detail-meta .author-date {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .post-detail-card .detail-meta .author-profile img {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 5px;
            vertical-align: middle;
        }

        .post-detail-card .detail-meta .views-likes-comments {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .post-detail-card .detail-meta .views-likes-comments span {
            display: flex;
            align-items: center;
        }

        .post-detail-card .detail-meta .views-count i, .post-detail-card .detail-meta .comments-count i {
            margin-right: 5px;
            color: #999;
        }

        /* 이미지 섹션 */
        .post-detail-card .image-section {
            margin-bottom: 30px;
        }

        .post-detail-card .main-image-wrapper {
            width: 100%;
            height: 600px;
            overflow: hidden;
            border-radius: 8px;
            margin-bottom: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .post-detail-card .main-image-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .post-detail-card .thumbnail-gallery {
            display: flex;
            gap: 10px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .post-detail-card .thumbnail-gallery img {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 6px;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color 0.2s, transform 0.2s;
        }

        .post-detail-card .thumbnail-gallery img.active, .post-detail-card .thumbnail-gallery img:hover {
            border-color: #007bff;
            transform: scale(1.05);
        }

        /* 해시태그 & 좋아요 */
        .post-detail-card .tag-like-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 20px 0 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
            flex-wrap: wrap;
            gap: 10px;
        }

        .post-detail-card .detail-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .post-detail-card .detail-tags span {
            background-color: #f5f0e1;
            color: #333;
            padding: 5px 12px;
            border-radius: 10px;
            font-size: 0.9em;
            white-space: nowrap;
        }

        .post-detail-card .likes-count-wrapper {
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 20px;
            background-color: #f0f0f0;
            transition: background-color 0.2s ease-in-out, color 0.2s ease-in-out;
            display: inline-flex;
            align-items: center;
            font-size: 1em;
            color: #777;
            gap: 6px;
        }

        .post-detail-card .likes-count-wrapper:hover {
            background-color: #e2e2e2;
        }

        .post-detail-card .likes-count-wrapper.liked {
            background-color: #ffebeb;
            color: #dc3545;
        }

        .post-detail-card .likes-count-wrapper.liked i {
            color: #dc3545;
        }

        /* 본문 */
        .post-detail-card .detail-content {
            margin-bottom: 40px;
            font-size: 1.05em;
            line-height: 1.8;
            color: #444;
        }
        
        .detail-content{
            white-space: pre-wrap;   /* 줄바꿈 + 공백 보존 */
 		    word-break: break-word;  /* 긴 단어 자동 줄바꿈 */
        }

        .post-detail-card .detail-content p {
            margin-bottom: 1em;
        }

        .post-detail-card .detail-content p:last-child {
            margin-bottom: 0;
        }

        /* 첨부 바 */
        .post-detail-card .attachment-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            margin: 30px 0;
            border-top: 1px solid #e9ecef;
            border-bottom: 1px solid #e9ecef;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .post-detail-card .attachment-bar .file-name {
            color: #495057;
            font-size: 1.05em;
        }

        .post-detail-card .attachment-bar .file-name i {
            margin-right: 8px;
            color: #868e96;
        }

        .post-detail-card .attachment-bar .btn-import {
            padding: 8px 18px;
            font-size: 0.95em;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background-color: #17a2b8;
            color: #fff;
        }

        .post-detail-card .attachment-bar .btn-import:hover {
            background-color: #138496;
        }

        /* 버튼 그룹 */
        .post-detail-card .button-group {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin: 0 0 50px;
        }

        .post-detail-card .button-group .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .post-detail-card .btn-list {
            background-color: #6c757d;
            color: #fff;
        }

        .post-detail-card .btn-list:hover {
            background-color: #5a6268;
        }

        .post-detail-card .btn-edit {
            background-color: #007bff;
            color: #fff;
        }

        .post-detail-card .btn-edit:hover {
            background-color: #0056b3;
        }

        .post-detail-card .btn-delete {
            background-color: #dc3545;
            color: #fff;
        }

        .post-detail-card .btn-delete:hover {
            background-color: #c82333;
        }

        /* 댓글 */
        .post-detail-card .comments-section {
            padding-top: 30px;
            border-top: 1px solid #e0e0e0;
        }

        .post-detail-card .comments-section h4 {
            font-size: 1.3rem;
            color: #333;
            margin-bottom: 20px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 5px;
            display: inline-block;
        }

        .post-detail-card .comment-form {
            position: relative;
        }

        .post-detail-card .comment-form textarea {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            min-height: 80px;
            font-size: 0.95em;
        }

        .post-detail-card .btn-comment-submit {
            background-color: #28a745;
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            color: #fff;
            white-space: nowrap;
            width: auto;
        }

        .post-detail-card .btn-comment-submit:hover {
            background-color: #218838;
        }

        .post-detail-card .comment-form .btn-cancel-reply {
            float: right;
            margin-right: 5px;
            background-color: #6c757d;
            color: #fff;
            padding: 10px 15px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1em;
            display: none;
        }

        .post-detail-card .comment-form .btn-cancel-reply:hover {
            background-color: #5a6268;
        }

        .post-detail-card .comment-list {
            clear: both;
            margin-top: 20px;
        }

        .post-detail-card .comment-item {
            padding: 15px 0;
            position: relative;
        }

        .post-detail-card .comment-item:not(:last-child) {
            border-bottom: 1px solid #ddd;
        }

        .post-detail-card .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 8px;
            width: 100%;
        }

        .post-detail-card .comment-author-info {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 1em;
        }

        .post-detail-card .comment-author-tag {
            background-color: #007bff;
            color: #fff;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 0.8em;
            font-weight: 700;
        }

        .post-detail-card .comment-text {
            font-size: 0.95em;
            color: #444;
            margin-bottom: 10px;
            word-wrap: break-word;
        }

        .post-detail-card .comment-footer {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.85em;
            color: #666;
            margin-top: 10px;
        }

        .post-detail-card .comment-footer .divider {
            color: #ccc;
        }

        .post-detail-card .comment-actions button {
            background: none;
            border: none;
            font-size: 0.8em;
            cursor: pointer;
            padding: 3px 5px;
            border-radius: 4px;
            transition: color 0.2s, background-color 0.2s;
        }

        .post-detail-card .comment-actions button.btn-comment-edit {
            color: #007bff;
        }

        .post-detail-card .comment-actions button.btn-comment-delete {
            color: #dc3545;
        }

        .post-detail-card .comment-actions button:hover {
            background-color: #e0e0e0;
        }

        .post-detail-card .comment-item.editing .comment-text {
            display: none;
        }

        .post-detail-card .comment-item .edit-textarea {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            min-height: 60px;
            font-size: 0.95em;
            display: none;
        }

        .post-detail-card .comment-item.editing .edit-textarea {
            display: block;
        }

        .post-detail-card .edit-buttons {
            display: none;
            gap: 5px;
        }

        .post-detail-card .comment-item.editing .edit-buttons {
            display: flex;
        }

        .post-detail-card .comment-item.editing .comment-actions {
            display: none;
        }

        .post-detail-card .comment-item.reply {
            margin-left: 30px;
            background-color: #fcfcfc;
            border-left: 3px solid #ddd;
            padding-left: 15px;
        }

        .post-detail-card .btn-comment-reply {
            background: none;
            border: none;
            color: #888;
            font-size: 0.8em;
            cursor: pointer;
            padding: 3px 5px;
            border-radius: 4px;
            transition: color 0.2s, background-color 0.2s;
        }

        .post-detail-card .btn-comment-reply:hover {
            color: #333;
            background-color: #e0e0e0;
        }

        .post-detail-card .reply-form {
            display: none;
        }

        .post-detail-card .reply-form-active {
            display: block;
        }

        .post-detail-card .reply-form-inner {
            padding: 10px;
            margin-top: 10px;
            background-color: #f0f2f5;
            border-radius: 8px;
        }

        .post-detail-card .reply-form-inner textarea {
            width: calc(100% - 20px);
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            min-height: 60px;
            font-size: 0.9em;
            padding: 8px;
            margin-bottom: 5px;
        }

        .post-detail-card .reply-form-inner button {
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 12px;
            font-size: 0.9em;
            float: right;
        }

        .post-detail-card .reply-form-inner button.btn-cancel-reply-dynamic {
            background-color: #6c757d;
            margin-right: 5px;
        }

        .post-detail-card .comment-form textarea,
        .post-detail-card .reply-form-inner textarea,
        .post-detail-card .edit-textarea {
            resize: none; /* 크기 조절 비활성화 */
        }

        /* 답글 입력창: 폭/여백 안정화 */
        .post-detail-card .reply-form-inner textarea {
            width: 100%;
            box-sizing: border-box; /* ← calc(...) 대신 */
            margin: 0 0 8px 0;
            min-height: 80px;
            /* 필요 시: resize: none; */
        }

        /* 버튼 컨테이너를 flex로 우측 정렬 */
        .post-detail-card .reply-buttons {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        /* 기존 float 제거 (덮어쓰기) */
        .post-detail-card .reply-form-inner button {
            float: none !important;
        }

        /* 1) 수정 입력폼: 크기조절 막고, 폭/포커스 스타일 정리 */
        .post-detail-card .comment-item .edit-textarea {
            /* 기존 width: calc(100% - 20px);, resize: vertical; 을 대체 */
            width: 100%;
            box-sizing: border-box;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            min-height: 100px;
            resize: none !important; /* ← 강제 비활성화 */
        }

        .post-detail-card .comment-item .edit-textarea:focus {
            outline: 0;
            border-color: #86b7fe;
            box-shadow: 0 0 0 .2rem rgba(13, 110, 253, .25);
        }

        /* 2) 저장/취소 버튼을 오른쪽 정렬 + 버튼 스타일 */
        .post-detail-card .comment-footer {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .post-detail-card .comment-actions,
        .post-detail-card .edit-buttons {
            margin-left: auto; /* 오른쪽으로 밀기 */
        }

        .post-detail-card .edit-buttons {
            display: none; /* 기본 숨김, editing일 때만 표시 */
            gap: 8px;
        }

        .post-detail-card .comment-item.editing .edit-buttons {
            display: flex;
        }

        /* 버튼 룩앤필 */
        .post-detail-card .btn-comment-save,
        .post-detail-card .btn-comment-cancel {
            border: none;
            border-radius: 6px;
            padding: 6px 12px;
            font-size: .9em;
            cursor: pointer;
        }

        .post-detail-card .btn-comment-save {
            background: #0d6efd;
            color: #fff;
        }

        .post-detail-card .btn-comment-save:hover {
            background: #0b5ed7;
        }

        .post-detail-card .btn-comment-cancel {
            background: #6c757d;
            color: #fff;
        }

        .post-detail-card .btn-comment-cancel:hover {
            background: #5a6268;
        }

    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<main class="container-xxl py-4">
    <section class="post-detail-card card custom-shadow">
        <div class="card-body">
            <div class="detail-header">
                <h1 class="page-title">${post.title}</h1>
                <div class="detail-meta">
                    <div class="author-date">
                        <span class="author-profile">
                            <img src="https://placehold.co/30x30/cccccc/ffffff?text=U" alt="프로필 이미지"
                                 onerror="this.onerror=null; this.src='https://placehold.co/30x30/cccccc/ffffff?text=U';">
                            <span>${post.userId}</span>
                        </span>
                        <span><i class="fas fa-clock"></i> <fmt:formatDate value="${post.createdAt}"
                                                                           pattern="yyyy-MM-dd HH:mm"/></span>
                    </div>
                    <div class="views-likes-comments">
                        <span class="views-count"><i class="fas fa-eye"></i> <span
                                id="viewCount">&nbsp;${post.viewCount}</span></span>
                        <span class="comments-count"><i class="fas fa-comment"></i> <span id="commentCount">&nbsp;<c:out
                                value="${fn:length(commentList)}" default="0"/></span></span>
                    </div>
                </div>
            </div>

            <div class="image-section">
                <div class="main-image-wrapper">
                    <c:choose>
                        <c:when test="${not empty post.fileDetailList}">
                            <c:set var="mainImgSrc" value="${post.fileDetailList[0].fileSaveLocate}"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="mainImgSrc" value="https://placehold.co/900x450/cccccc/ffffff?text=No+Image"/>
                        </c:otherwise>
                    </c:choose>
                    <img id="mainImage" src="<c:url value='${mainImgSrc}'/>"
                         alt="${post.title} 메인 이미지"
                         onerror="this.onerror=null;this.src='https://placehold.co/900x450/cccccc/ffffff?text=No+Image';">
                </div>
                <div class="thumbnail-gallery">
                    <c:forEach items="${post.fileDetailList}" var="file" varStatus="status">
                        <c:url var="thumbUrl" value="${file.fileSaveLocate}"/>
                        <img src="${thumbUrl}" alt="썸네일 ${status.count}"
                             class="${status.first ? 'active' : ''}"
                             data-img-src="${thumbUrl}"
                             onerror="this.onerror=null;this.src='https://placehold.co/90x90/cccccc/ffffff?text=N/A';">
                    </c:forEach>
                </div>
            </div>

            <div class="tag-like-container">
                <div class="detail-tags">
                    <c:choose>
                        <c:when test="${not empty post.hashtags}">
                            <c:forEach items="${post.hashtags}" var="tag">
                                <span>#${tag}</span>
                            </c:forEach>
                        </c:when>
                        <c:otherwise></c:otherwise>
                    </c:choose>
                </div>
                <span class="likes-count-wrapper" id="likesCountWrapper">
                    <i class="fas fa-heart"></i> <span id="likesCount">${post.likeCount}</span>
                </span>
            </div>

            <div class="detail-content">
                <p>${post.content}</p>
            </div>

            <!-- 도면 파일 저장 버튼 -->
            <div class="attachment-bar">
                <span class="file-name">
                    <i class="fas fa-download"></i>
                    <strong>내 라이브러리에 도면 추가 : </strong>
                    <a href="#" class="file-link clone-trigger" data-design-id="${post.designId}" 
                       data-design-name="${post.designName}">
                        ${post.designName}
                    </a>
                </span>
            </div>

            <div class="button-group">
                <a href="<c:url value='/start-up/show'/>" class="btn btn-list">목록으로</a>
                <c:if test="${not empty userId and userId eq post.userId}">
                    <button class="btn btn-edit" type="button">수정</button>
                    <button class="btn btn-delete" type="button">삭제</button>
                </c:if>
            </div>

            <div class="comments-section">
                <h4>댓글 (<span id="actualCommentCount"><c:out value="${fn:length(commentList)}" default="0"/></span>)
                </h4>

                <div class="comment-form">
                    <div class="button-group">
                        <textarea id="commentContent" placeholder="댓글을 입력하세요..."></textarea>
                        <button id="submitCommentBtn" class="btn-comment-submit" type="button">댓글 작성</button>
                        <button id="cancelReplyBtn" class="btn-cancel-reply" style="display:none;" type="button">답글 취소
                        </button>
                        <input type="hidden" id="mainParentId" value=""/>
                    </div>

                    <div class="comment-list">
                        <c:if test="${empty commentList}">
                            <p id="noCommentMessage" style="text-align: center; color: #777;">아직 댓글이 없습니다.</p>
                        </c:if>
                        <c:forEach items="${commentList}" var="comment">
                            <div class="comment-item <c:if test='${comment.depth > 0}'>reply</c:if>"
                                 data-comment-id="${comment.commentId}"
                                 data-comment-author="${comment.userId}"
                                 data-comment-depth="${comment.depth}"
                                 data-root-id="${comment.rootId}">
                                <div class="comment-header">
                                    <div class="comment-author-info">
                                        <strong>${comment.userId}</strong>
                                        <c:if test="${comment.userId eq post.userId}">
                                            <span class="comment-author-tag">작성자</span>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="comment-text">${comment.content}</div>
                                <textarea class="edit-textarea">${comment.content}</textarea>

                                <div class="comment-footer">
                                    <span><fmt:formatDate value="${comment.createdAt}" pattern="yyyy.MM.dd"/></span>
                                    <div class="comment-actions">
                                        <c:if test="${comment.parentId == null}">
                                            <span class="divider">|</span>
                                            <button class="btn-comment-reply" type="button">답글달기</button>
                                        </c:if>
                                        <c:if test="${not empty userId and userId eq comment.userId}">
                                            <span class="divider">|</span>
                                            <button class="btn-comment-edit" type="button">수정</button>
                                            <button class="btn-comment-delete" type="button">삭제</button>
                                        </c:if>
                                    </div>
                                    <div class="edit-buttons">
                                        <button class="btn-comment-save" type="button">저장</button>
                                        <button class="btn-comment-cancel" type="button">취소</button>
                                    </div>
                                </div>

                                <div class="reply-form">
                                    <div class="reply-form-inner">
                                        <textarea class="reply-textarea"
                                                  placeholder="@${comment.userId} 님에게 답글 작성..."></textarea>
                                        <div class="reply-buttons">
                                            <button class="btn-cancel-reply-dynamic" type="button">취소</button>
                                            <button class="btn-submit-reply-dynamic" type="button">답글 등록</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<!-- jQuery (하단 로드) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- 페이지 전용 스크립트 -->
<script>
//게시글 파일 저장 스크립트
	$(document.body).on('click', '.clone-trigger', function (event) {
	    event.preventDefault();
	    const currentUserId = '${userId}';
	    if (!currentUserId) {
	        alert('로그인이 필요한 서비스입니다.');
	        window.location.href = '<c:url value="/login"/>';
	        return;
	    }
	
	    const designId = $(this).data('design-id');
	    const originalDesignName = $(this).data('design-name');
	
	    const newDesignName = prompt('새로운 도면 이름을 입력하세요:', originalDesignName + '의 사본');
	
	    if (newDesignName === null) {
	        return;
	    }
	
	    if (newDesignName.trim() === '') {
	        newDesignName = originalDesignName;
	    }
	
	    $.ajax({
	        url: '<c:url value="/start-up/design/clone/"/>' + designId,
	        type: 'POST',
	        dataType: 'json',
	        data: {
	            newDesignName: newDesignName
	        },
	        success: function (response) {
	            if (response.success) {
	                if (confirm(response.message + '\n내 도면 라이브러리로 이동하시겠습니까?')) {
	                    window.location.href = '<c:url value="/start-up/design/myDesignPage"/>';
	                }
	            } else {
	                alert(response.message);
	            }
	        },
	        error: function (xhr) {
	            if (xhr.status === 401) alert('로그인이 필요합니다.');
	            else alert('요청 처리 중 오류가 발생했습니다.');
	        }
	    });
	});

    $(function () {
        const postId = '${post.postId}';
        const currentUserId = '${userId}';
        let isLiked = ${isLiked};

        // 삭제
        $('.btn-delete').on('click', function () {
            if (!confirm('정말로 이 게시물을 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.')) return;
            $.ajax({
                url: '<c:url value="/start-up/show/delete/"/>' + postId,
                type: 'POST',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        alert('게시물이 성공적으로 삭제되었습니다.');
                        window.location.href = '<c:url value="/start-up/show"/>';
                    } else {
                        alert(response.message);
                    }
                },
                error: function (xhr) {
                    alert('삭제 처리 중 오류가 발생했습니다. (오류코드: ' + xhr.status + ')');
                }
            });
        });

        // 수정
        $('.btn-edit').on('click', function () {
            window.location.href = '<c:url value="/start-up/show/update/"/>' + postId;
        });

        // 조회수 (하루 1회)
        const viewedPostsKey = 'viewedPosts';
        try {
            let viewedPosts = JSON.parse(localStorage.getItem(viewedPostsKey)) || {};
            const postViewInfo = viewedPosts[postId];
            const now = Date.now();
            const oneDay = 24 * 60 * 60 * 1000;
            if (!postViewInfo || (now - postViewInfo.timestamp > oneDay)) {
                $.ajax({
                    url: '<c:url value="/start-up/show/view/" />' + postId,
                    type: 'POST',
                    success: function () {
                        let currentViews = parseInt($('#viewCount').text());
                        $('#viewCount').text(currentViews + 1);
                        viewedPosts[postId] = {timestamp: now};
                        localStorage.setItem(viewedPostsKey, JSON.stringify(viewedPosts));
                    }
                });
            }
        } catch (e) {
            console.error('localStorage error:', e);
        }

        // 좋아요
        if (isLiked) $('#likesCountWrapper').addClass('liked');
        $('#likesCountWrapper').on('click', function () {
            if (!currentUserId) {
                alert('로그인이 필요한 서비스입니다.');
                window.location.href = '<c:url value="/login"/>';
                return;
            }
            $.ajax({
                url: '<c:url value="/start-up/show/like/" />' + postId,
                type: 'POST',
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        $('#likesCountWrapper').toggleClass('liked', response.isLiked);
                        $('#likesCount').text(response.likeCount);
                    } else {
                        alert(response.message);
                    }
                },
                error: function () {
                    alert('좋아요 처리 중 오류가 발생했습니다.');
                }
            });
        });

        // 썸네일 클릭 → 메인이미지 교체
        $('.thumbnail-gallery').on('click', 'img', function () {
            $('#mainImage').attr('src', $(this).data('img-src'));
            $('.thumbnail-gallery img').removeClass('active');
            $(this).addClass('active');
        });

        // ===== 댓글 =====
        // 최상위 댓글 작성
        $('#submitCommentBtn').on('click', function () {
            if (!currentUserId) {
                alert('로그인이 필요한 서비스입니다.');
                window.location.href = '<c:url value="/login"/>';
                return;
            }
            const commentContent = $('#commentContent').val().trim();
            if (!commentContent) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }
            const commentData = {postId: parseInt(postId), content: commentContent, parentId: null, depth: 0};
            $.ajax({
                url: '<c:url value="/start-up/show/comment/insert"/>',
                type: 'POST', contentType: 'application/json', data: JSON.stringify(commentData), dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload();
                    } else {
                        alert(res.message);
                    }
                },
                error: function () {
                    alert('댓글 등록 중 오류가 발생했습니다.');
                }
            });
        });

        // 답글달기 토글
        $(document).on('click', '.btn-comment-reply', function (e) {
            e.preventDefault();
            if (!currentUserId) {
                alert('로그인이 필요한 서비스입니다.');
                window.location.href = '<c:url value="/login"/>';
                return;
            }
            const $commentItem = $(this).closest('.comment-item');
            const $replyForm = $commentItem.find('.reply-form');
            $('.reply-form').not($replyForm).slideUp();
            $replyForm.slideToggle(function () {
                if ($replyForm.is(':visible')) $replyForm.find('.reply-textarea').focus();
            });
        });

        // 동적 답글 취소
        $(document).on('click', '.btn-cancel-reply-dynamic', function () {
            $(this).closest('.reply-form').slideUp();
        });

        // 동적 답글 등록
        $(document).on('click', '.btn-submit-reply-dynamic', function () {
            if (!currentUserId) {
                alert('로그인이 필요한 서비스입니다.');
                window.location.href = '<c:url value="/login"/>';
                return;
            }
            const $replyForm = $(this).closest('.reply-form');
            const replyContent = $replyForm.find('.reply-textarea').val().trim();
            if (!replyContent) {
                alert('답글 내용을 입력해주세요.');
                return;
            }
            const $currentItem = $(this).closest('.comment-item');
            const rootId = $currentItem.data('root-id') || $currentItem.data('comment-id');
            const $threadComments = $('.comment-item[data-root-id="' + rootId + '"]');
            const $lastCommentInThread = $threadComments.length > 0 ? $threadComments.last() : $currentItem;
            const parentId = $lastCommentInThread.data('comment-id');
            const parentDepth = parseInt($lastCommentInThread.data('depth')) || 0;
            const newDepth = parentDepth + 1;
            const commentData = {postId: parseInt(postId), content: replyContent, parentId: parentId, depth: newDepth};
            $.ajax({
                url: '<c:url value="/start-up/show/comment/insert"/>',
                type: 'POST', contentType: 'application/json', data: JSON.stringify(commentData), dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload();
                    } else {
                        alert(res.message);
                    }
                },
                error: function () {
                    alert('답글 등록 중 오류가 발생했습니다.');
                }
            });
        });

        // 댓글 수정 시작
        $(document).on('click', '.btn-comment-edit', function () {
            const $commentItem = $(this).closest('.comment-item');
            $commentItem.addClass('editing');
            $commentItem.find('.comment-actions').hide();
            $commentItem.find('.edit-buttons').show();
            $commentItem.find('.edit-textarea').val($commentItem.find('.comment-text').text().trim()).focus();
        });

        // 댓글 수정 취소
        $(document).on('click', '.btn-comment-cancel', function () {
            const $commentItem = $(this).closest('.comment-item');
            $commentItem.removeClass('editing');
            $commentItem.find('.comment-actions').show();
            $commentItem.find('.edit-buttons').hide();
        });

        // 댓글 수정 저장
        $(document).on('click', '.btn-comment-save', function () {
            const $commentItem = $(this).closest('.comment-item');
            const commentId = $commentItem.data('comment-id');
            const newContent = $commentItem.find('.edit-textarea').val().trim();
            if (!newContent) {
                alert('댓글 내용을 입력해주세요.');
                return;
            }
            const commentData = {commentId: commentId, content: newContent};
            $.ajax({
                url: '<c:url value="/start-up/show/comment/update"/>',
                type: 'POST', contentType: 'application/json', data: JSON.stringify(commentData), dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload();
                    } else {
                        alert(res.message);
                    }
                },
                error: function (xhr) {
                    if (xhr.status === 403) alert('댓글을 수정할 권한이 없습니다.'); else alert('댓글 수정 중 오류가 발생했습니다. (오류코드: ' + xhr.status + ')');
                },
                complete: function () {
                    $commentItem.removeClass('editing');
                    $commentItem.find('.comment-actions').show();
                    $commentItem.find('.edit-buttons').hide();
                }
            });
        });

        // 댓글 삭제
        $(document).on('click', '.btn-comment-delete', function () {
            if (!confirm('정말로 이 댓글을 삭제하시겠습니까?')) return;
            const commentId = $(this).closest('.comment-item').data('comment-id');
            $.ajax({
                url: '<c:url value="/start-up/show/comment/"/>' + commentId,
                type: 'DELETE', dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        alert(res.message);
                        location.reload();
                    } else {
                        alert(res.message);
                    }
                },
                error: function (xhr) {
                    if (xhr.status === 403) alert('댓글을 삭제할 권한이 없습니다.'); else alert('댓글 삭제 중 오류가 발생했습니다.');
                }
            });
        });
    });
</script>
</body>
</html>