<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>관심구역 & 관심업종 설정</title>

    <!-- Bootstrap 먼저 로드 (프로젝트 전역 Override는 mypagestyle.css가 하도록 순서 유지) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Icons / Styles -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypagestyle.css"/>

    <!-- CKEditor -->
    <script src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>

    <!-- 페이지 전용 스타일 (myActivity.jsp 스타일 적용) -->
    <style>
        /* myActivity.jsp 스타일 적용 */
        .card-body {
            padding: 0 !important;
        }

        /* 상단 타이틀 */
        .mypage-header h2 {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0;
        }

        /* 카드 스타일 */
        .card {
            border: 1px solid #e9ecef;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 20px;
            border-radius: 12px 12px 0 0;
        }

        .card-title {
            color: #2c3e50;
            font-weight: 600;
            margin: 0;
        }

        /* 필터 및 검색 영역 스타일 */
        .search-area {
            align-items: center;
        }

        .search-result-info {
            margin: 10px 0;
            padding: 8px 12px;
            background: #f8f9fa;
            border-left: 4px solid #3498db;
            font-size: 14px;
            color: #555;
        }

        .search-result-info .keyword {
            font-weight: bold;
            color: #3498db;
        }

        .no-results {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }

        /* 버튼 체크 스타일 */
        .btn-check:checked + .btn-outline-primary {
            background-color: #0d6efd;
            border-color: #0d6efd;
            color: #fff;
        }

        /* 통계 네비게이터 */
        .category-navigator {
            margin: 10px 0 20px;
        }

        .category-navigator .stats-list {
            display: flex;
            gap: 20px;
            list-style: none;
            padding: 0;
            margin: 10px 0 0;
        }

        .category-navigator .stats-list a {
            text-decoration: none;
            color: #555;
            padding: 8px 12px;
            border-radius: 6px;
            transition: all 0.2s ease;
        }

        .category-navigator .stats-list a.active {
            font-weight: 700;
            color: #3498db;
            background-color: rgba(52, 152, 219, 0.1);
        }

        .category-navigator .stats-list a:hover {
            background-color: #f8f9fa;
            color: #3498db;
        }

        /* 보드 카드 */
        .main-content {
            margin-top: 10px;
        }

        .board-area {
            background: #fff;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 0;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .board-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 0;
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            border-radius: 12px 12px 0 0;
        }

        .board-header h3 {
            color: #2c3e50;
            font-weight: 600;
            margin: 0;
        }

        /* 테이블 스타일 */
        .board-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .board-table thead th {
            background: #f8f9fa;
            font-weight: 600;
            border-bottom: 2px solid #e9ecef;
            padding: 12px 15px;
            text-align: center;
            color: #2c3e50;
        }

        .board-table th, .board-table td {
            padding: 12px 15px;
            border-bottom: 1px solid #f1f3f5;
            text-align: center;
            word-break: break-word;
            vertical-align: middle;
        }

        .board-table td.title {
            text-align: left;
        }

        .board-table tr:hover {
            background-color: #f8f9fa;
        }

        /* 뱃지 스타일 */
        .badge {
            padding: 4px 8px;
            font-size: 12px;
            border-radius: 4px;
        }

        /* 페이지네이션 */
        #pagination-area {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            padding: 0 20px 20px;
        }

        .pagination {
            margin: 0;
        }

        .pagination .page-link {
            color: #2c3e50;
            border: 1px solid #dee2e6;
            padding: 8px 12px;
        }

        .pagination .page-item.active .page-link {
            background-color: #3498db;
            border-color: #3498db;
            color: white;
        }

        .pagination .page-link:hover {
            background-color: #f8f9fa;
            color: #3498db;
        }

        /* 댓글 */
        #comment-section {
            margin-top: 20px;
            padding: 20px;
        }

        #comment-form {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        #comment-form textarea {
            flex: 1;
            min-height: 80px;
            resize: vertical;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            padding: 10px;
        }

        /* 숨김 */
        #writePostBtn {
            display: none !important;
        }

        /* 빈 데이터 메시지 */
        .no-data-message {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }

        .no-data-message i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 16px;
        }

        /* ============================
           Modal 스타일 (boardAndChat 전용, myActivity.jsp 스타일 적용)
           ============================ */

        /* 공통 베이스 */
        #detailModal .modal-content,
        #editPostModal .modal-content {
            border-radius: 12px;
            border: 1px solid #e9ecef;
            box-shadow: 0 16px 40px rgba(4, 26, 47, .15);
            overflow: hidden;
        }

        /* 헤더 */
        #detailModal .modal-header,
        #editPostModal .modal-header {
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            padding: 16px 20px;
        }

        /* 타이틀 폰트/컬러 (프로젝트 기본 톤) */
        #detailModal .modal-title,
        #editPostModal .modal-title {
            font-family: 'GongGothicMedium', sans-serif;
            font-size: 20px;
            color: #2c3e50;
            margin: 0;
        }

        /* 닫기 버튼 */
        #detailModal .btn-close,
        #editPostModal .btn-close {
            outline: none;
            box-shadow: none;
            opacity: .75;
        }

        #detailModal .btn-close:hover,
        #editPostModal .btn-close:hover {
            opacity: 1;
        }

        /* 바디 */
        #detailModal .modal-body,
        #editPostModal .modal-body {
            padding: 20px;
        }

        /* 푸터 */
        #detailModal .modal-footer,
        #editPostModal .modal-footer {
            border-top: 1px solid #e9ecef;
            background: #f8f9fa;
            padding: 12px 16px;
        }

        /* 버튼 톤(네이비 포인트로 통일) */
        .btn-primary {
            background-color: #3498db;
            border-color: #3498db;
            color: #fff;
        }

        .btn-primary:hover,
        .btn-primary:focus {
            background-color: #2980b9;
            border-color: #2980b9;
        }

        .btn-danger {
            background: #e74c3c;
            border-color: #e74c3c;
        }

        .btn-danger:hover,
        .btn-danger:focus {
            background: #c0392b;
            border-color: #c0392b;
        }

        .btn-secondary {
            background-color: #95a5a6;
            border-color: #95a5a6;
        }

        .btn-secondary:hover,
        .btn-secondary:focus {
            background-color: #7f8c8d;
            border-color: #7f8c8d;
        }

        /* 상세 모달 안 콘텐츠 가독성 */
        #detailModal .post-detail-modal h3 {
            font-size: 22px;
            margin-bottom: 6px;
            color: #2c3e50;
        }

        #detailModal .post-detail-modal .post-info {
            color: #8b95a1;
            font-size: 13px;
        }

        #detailModal .post-detail-modal .post-content {
            color: #2c3e50;
            line-height: 1.65;
        }

        #detailModal .post-detail-modal .post-content img {
            max-width: 100%;
            height: auto;
            border: 1px solid #eee;
            border-radius: 6px;
            padding: 4px;
        }

        /* 첨부 스타일(본문/모달 공통 느낌) */
        #attachments-area > div,
        #detailModal #attachments-area > div {
            margin: 8px 0;
            padding: 10px;
            border: 1px solid #eee;
            border-radius: 6px;
            background: #fafafa;
        }

        #attachments-area strong,
        #detailModal #attachments-area strong {
            color: #2c3e50;
        }

        /* 댓글영역 */
        #detailModal .comments-section h5 {
            font-size: 16px;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        #detailModal .comments-section .comment-item {
            padding: 10px 0;
            border-bottom: 1px solid #f1f3f5;
        }

        #detailModal .comments-section .comment-item:last-child {
            border-bottom: 0;
        }

        #detailModal .comments-section .comment-item strong {
            color: #2c3e50;
        }

        #detailModal .comments-section .comment-item small {
            color: #8b95a1;
        }

        /* 리스트에서 제목 링크 톤통일 */
        .board-table a.post-title-link {
            color: #2c3e50;
            text-decoration: none;
        }

        .board-table a.post-title-link:hover {
            color: #3498db;
            text-decoration: underline;
        }

        /* 반응형(좁은 화면에서 여백 조금 더) */
        @media (max-width: 576px) {
            #detailModal .modal-body,
            #editPostModal .modal-body {
                padding: 16px;
            }

            .board-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

            .search-area {
                flex-direction: column;
                width: 100%;
            }

            .search-area > * {
                width: 100% !important;
            }
        }

        /* 헤더에 X 버튼 고정 */
        #detailModal .modal-header {
            position: relative;
        }

        #detailModal .modal-x {
            position: absolute;
            right: 12px;
            top: 10px;
            background: transparent;
            border: 0;
            padding: 0;
            line-height: 1;
            cursor: pointer;
        }

        #detailModal .modal-x i {
            font-size: 20px;
            color: #8b95a1;
        }

        #detailModal .modal-x:hover i {
            color: #2c3e50;
        }

        /* 폼 컨트롤 스타일 */
        .form-control:focus,
        .form-select:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }
    </style>
    <%-- 헤더/글로벌 네비게이션은 body 안에서 include --%>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>
<div id="wrap">

    <div class="container"><%-- mypagestyle.css의 1440px 기준선과 flex 레이아웃 적용 --%>
        <c:set var="activeMenu" value="activity"/>   <!-- profile | report | activity | apply -->
        <c:set var="activeSub" value="comm"/>
        <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>

        <main>
            <div class="mypage-header">
                <h2>
                    <c:out value="${bizInfo.bizName}"/><span>커뮤니티 활동 내역</span>
                </h2>
            </div>

            <div class="category-navigator" id="statistics-navigator">
                <h3 class="mb-0"><i class="fas fa-chart-bar"></i> 총 활동수, 게시글, 댓글 통계</h3>
                <ul class="stats-list">
                    <li>
                        <a href="#" id="allActivityLink" data-type="all" class="active">
                            총 활동수 <span id="totalCount" style="font-weight:700;">0</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" id="postCountLink" data-type="posts">
                            게시글 <span id="postCount" style="font-weight:700;">0</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" id="commentCountLink" data-type="comments">
                            댓글 <span id="commentCount" style="font-weight:700;">0</span>
                        </a>
                    </li>
                </ul>
            </div>

            <div class="main-content">
                <div class="card">
                    <div class="board-header">
                        <h3>게시판</h3>
                        <!-- 검색 폼 추가 -->
                        <div class="search-area d-flex gap-2">
                            <select id="searchType" class="form-select form-select-sm" style="width: 120px;">
                                <option value="all">전체</option>
                                <option value="title">제목</option>
                                <option value="content">내용</option>
                                <option value="writer">작성자</option>
                            </select>
                            <input type="text" id="searchKeyword" class="form-control form-control-sm" 
                                   placeholder="검색어를 입력하세요" style="width: 200px;">
                            <button type="button" id="searchBtn" class="btn btn-primary btn-sm">
                                <i class="fas fa-search"></i> 검색
                            </button>
                            <button type="button" id="resetSearchBtn" class="btn btn-secondary btn-sm">
                                <i class="fas fa-undo"></i> 전체보기
                            </button>
                        </div>
                        <button type="button" id="writePostBtn" class="btn-success">새 글 작성</button>
                    </div>

                    <div class="card-body">
                        <div id="board-list-view">
                            <div id="board-content">
                                <p style="text-align:center; padding: 40px 20px;">게시글을 불러오는 중입니다...</p>
                            </div>

                            <div class="d-flex justify-content-center mt-4" style="margin-bottom: 1.5rem;">
                                <nav>
                                    <ul class="pagination pagination-sm mb-0" id="pagination-area">
                                        <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                                    </ul>
                                </nav>
                            </div>
                        </div>

                        <%-- 상세보기(페이지 전환 버전/보조용) --%>
                        <div id="post-detail-view" style="display:none;">
                            <div id="post-detail-container"></div>
                            <div id="attachments-area"></div>

                            <div id="comment-section">
                                <h4>댓글</h4>
                                <div id="comment-list"></div>
                                <div id="comment-form">
                                    <textarea id="newCommentContent" placeholder="댓글을 입력하세요" class="form-control"></textarea>
                                    <button id="submitCommentBtn" class="btn btn-primary">댓글 등록</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</div>

<!-- 상세 모달 -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalLabel">상세 보기</h5>
                <button type="button" class="modal-x" data-bs-dismiss="modal" aria-label="닫기">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body" id="modal-content"><!-- 동적 로드 --></div>
            <div class="modal-footer">
                <div id="modal-post-actions" class="d-flex justify-content-end gap-2 w-100"></div>
            </div>
        </div>
    </div>
</div>

<!-- 작성/수정 모달 (단일 폼만 사용) -->
<div class="modal fade" id="editPostModal" tabindex="-1" aria-labelledby="editPostModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="formTitle">새 게시글 작성</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <form id="postForm" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label for="postTitle" class="form-label">제목</label>
                        <input type="text" class="form-control" id="postTitle" name="title" required/>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">내용</label>
                        <div id="ckeditor-container"></div>
                    </div>
                    <div class="mb-3">
                        <label for="attachments" class="form-label">첨부파일</label>
                        <input type="file" class="form-control" id="attachments" name="attachments" multiple/>
                    </div>
                    <div class="d-flex justify-content-end gap-2">
                        <button type="submit" id="submitPostBtn" class="btn btn-primary">등록</button>
                        <button type="button" id="cancelBtn" class="btn btn-secondary" data-bs-dismiss="modal">취소
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // JSP → JS 전달
    window.contextPath = '<c:out value="${pageContext.request.contextPath}" />';
    window.bizCodeId = '<c:out value="${bizInfo.bizCodeId}" />';
    window.loginUserId = '<c:out value="${not empty loginUser ? loginUser.userId : loginUserId}" />';
    window.loginUserRole = '<sec:authentication property="principal.authorities[0].authority" />';
    window.chatRoomId = '<c:out value="${room.roomId}" />';

    document.addEventListener('DOMContentLoaded', function () {
        const contextPath = window.contextPath || '';
        const bizCodeId = (window.bizCodeId || '').trim();

        // 상태
        let currentDataType = 'all';
        let currentPostId = null;
        // 기존 전역 변수에 추가(검색)
        let currentSearchType = '';
        let currentSearchKeyword = '';
        
        let isSubmittingComment = false;
        let editor; // CKEditor 인스턴스

        // util
        const joinUrl = function (base, path) {
            return String(base || '').replace(/\/+$/, '') + '/' + String(path || '').replace(/^\/+/, '');
        };

        const fixMediaSrc = function (html) {
            const base = String(contextPath || '').replace(/\/+$/, '');
            return String(html || '')
                .replace(/src="\/media\//g, 'src="' + base + '/media/')
                .replace(/src='\/media\//g, "src='" + base + "/media/");
        };

        const showMessageBox = function (message, cb) {
            alert(message);
            if (typeof cb === 'function') cb();
        };

        // 뷰 전환 (더 안전)
        const showView = function (targetId) {
            ['board-list-view', 'post-detail-view', 'post-form-view'].forEach(function (id) {
                const el = document.getElementById(id);
                if (!el) return;
                el.style.display = (id === targetId) ? 'block' : 'none';
            });
        };

        // DOM
        const boardContentDiv = document.getElementById('board-content');
        const paginationAreaDiv = document.getElementById('pagination-area');
        const statsNavigator = document.getElementById('statistics-navigator');
        const postDetailContainer = document.getElementById('post-detail-container');
        const commentList = document.getElementById('comment-list');
        const submitCommentBtn = document.getElementById('submitCommentBtn');
        const writePostBtn = document.getElementById('writePostBtn');

        // 통계
        const fetchStatistics = function () {
            fetch(joinUrl(contextPath, '/api/my/free/statistics'))
                .then(function (res) {
                    if (!res.ok) throw new Error('Failed to fetch statistics');
                    return res.json();
                })
                .then(function (data) {
                    document.getElementById('totalCount').innerText = data.totalCount;
                    document.getElementById('postCount').innerText = data.postCount;
                    document.getElementById('commentCount').innerText = data.commentCount;
                })
                .catch(function (err) {
                    console.error('Error fetching statistics:', err);
                });
        };

        // 리스트 렌더
        const renderActivityList = function (activities, pageInfo) {
            if (!activities || activities.length === 0) {
                var noResultMsg = '';
                if (currentSearchKeyword) {
                    noResultMsg = '<div class="no-data-message">' +
                                 '<i class="fas fa-search"></i>' +
                                 '<h5>검색 결과가 없습니다</h5>' +
                                 '<p>"' + currentSearchKeyword + '"에 대한 검색 결과를 찾을 수 없습니다.</p>' +
                                 '</div>';
                } else {
                    noResultMsg = '<div class="no-data-message">' +
                                 '<i class="fas fa-inbox"></i>' +
                                 '<p>활동 내역이 없습니다.</p>' +
                                 '</div>';
                }
                boardContentDiv.innerHTML = noResultMsg;
                paginationAreaDiv.innerHTML = '';
                return;
            }
            var html = ''
                + '<table class="board-table">'
                + '  <thead>'
                + '    <tr>'
                + '      <th style="width:10%;">분류</th>'
                + '      <th style="width:30%;">카테고리</th>'
                + '      <th style="width:50%;">제목 / 내용</th>'
                + '      <th style="width:15%;">작성자</th>'
                + '      <th style="width:15%;">작성일</th>'
                + '    </tr>'
                + '  </thead><tbody>';

            activities.forEach(function (item) {
                var isPost = item.hasOwnProperty('postId') && item.postId !== 0;
                var isComment = item.hasOwnProperty('commentId') && item.commentId !== null;

                var itemType = isPost ? '게시글' : (isComment ? '댓글' : '알수없음');
                var bizName = item.bizName || '';
                var writer = item.writerName || (item.userId ? item.userId.split('@')[0] : '알 수 없음');
                var createdDate = item.createdAt
                    ? new Date(item.createdAt).toLocaleDateString('ko-KR').trim().replace(/\.$/, '')
                    : '';

                var linkHtml = '알 수 없는 항목';
                if (isPost) {
                    linkHtml = '<a href="#" class="post-title-link" data-post-id="' + item.postId + '">'
                        + (item.title || '제목 없음')
                        + '</a>';
                } else if (isComment) {
                    if (item.postId == 0) item.postId = item.postId2;
                    var truncated = (item.content && item.content.length > 50) ? item.content.substring(0, 50) + '...' : (item.content || '내용 없음');
                    linkHtml = '<a href="#" class="post-title-link" data-post-id="' + item.postId + '">'
                        + truncated
                        + '</a>';
                }

                // 뱃지 스타일 적용
                var typeBadge = isPost ? 
                    '<span class="badge bg-primary">게시글</span>' : 
                    '<span class="badge bg-secondary">댓글</span>';

                html += ''
                    + '<tr>'
                    + '<td>' + typeBadge + '</td>'
                    + '<td><span class="badge bg-info">' + bizName + '</span></td>'
                    + '<td class="title">' + linkHtml + '</td>'
                    + '<td>' + writer + '</td>'
                    + '<td>' + createdDate + '</td>'
                    + '</tr>';
            });

            html += '</tbody></table>';
            boardContentDiv.innerHTML = html;
        };

        // 페이지네이션
        // 교체 후 (안전)
        // ☆ UL#pagination-area 안에는 li만 채우는 게 맞습니다.
        // ☆ #pagination-area는 <ul> 이라고 가정하고, li만 채웁니다.
        const renderPagination = (p) => {
            const totalPages = Number(p.totalPages || 1);
            const currentPage = Number(p.currentPage || 1);
            const startPage = Number(p.startPage || 1);
            const endPage = Number(p.endPage || totalPages);

            let html = '';

            // 맨앞
            html += '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '">'
                + '<a class="page-link" href="#" data-page="1">맨앞</a>'
                + '</li>';

            // 이전
            html += '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '">'
                + '<a class="page-link" href="#" data-page="' + (currentPage - 1) + '">이전</a>'
                + '</li>';

            // 숫자
            for (let i = startPage; i <= endPage; i++) {
                html += '<li class="page-item' + (currentPage === i ? ' active' : '') + '">'
                    + '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>'
                    + '</li>';
            }

            // 다음
            html += '<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '">'
                + '<a class="page-link" href="#" data-page="' + (currentPage + 1) + '">다음</a>'
                + '</li>';

            // 맨뒤
            html += '<li class="page-item' + (currentPage === totalPages ? ' disabled' : '') + '">'
                + '<a class="page-link" href="#" data-page="' + totalPages + '">맨뒤</a>'
                + '</li>';

            // <ul id="pagination-area">의 안쪽에 li만 주입
            paginationAreaDiv.innerHTML = html;
        };

        // 목록 조회
        // 기존 showPostList 함수를 다음과 같이 수정
        const showPostList = function (page, type, searchType, searchKeyword) {
            if (typeof page === 'undefined') page = 1;
            if (typeof type === 'undefined') type = 'all';
            
            currentDataType = type;
            currentSearchType = searchType || '';
            currentSearchKeyword = searchKeyword || '';
            
            showView('board-list-view');
            boardContentDiv.innerHTML = '<div class="no-data-message"><p style="text-align:center;">게시글을 불러오는 중입니다...</p></div>';
            paginationAreaDiv.innerHTML = '';

            var url = joinUrl(contextPath, '/api/my/free/activities?currentPage=' + page);
            if (type && type !== 'all') url += '&type=' + type;
            
            // 검색 파라미터 추가
            if (searchType && searchKeyword) {
                url += '&searchType=' + encodeURIComponent(searchType);
                url += '&searchKeyword=' + encodeURIComponent(searchKeyword);
            }

            fetch(url, {credentials: 'include'})
                .then(function (res) {
                    if (!res.ok) throw new Error('목록 조회 실패 (' + res.status + ')');
                    return res.json();
                })
                .then(function (data) {
                    // 검색 결과 정보 표시 추가
                    showSearchResultInfo(data, searchType, searchKeyword);
                    renderActivityList(data.content || [], data);
                    renderPagination(data);
                })
                .catch(function (err) {
                    console.error('목록 조회 에러:', err);
                    boardContentDiv.innerHTML = '<div class="no-data-message"><p style="color:red; text-align:center;">' + err.message + '</p></div>';
                });
        };
        
        // 새로 추가할 함수
        const showSearchResultInfo = function(data, searchType, searchKeyword) {
            // 기존 검색 결과 정보 제거
            var existingInfo = document.querySelector('.search-result-info');
            if (existingInfo) {
                existingInfo.remove();
            }
            
            // 검색한 경우에만 정보 표시
            if (searchType && searchKeyword) {
                var totalCount = data.totalElements || 0;
                var searchTypeText = {
                    'all': '전체',
                    'title': '제목',
                    'content': '내용', 
                    'writer': '작성자'
                }[searchType] || '전체';
                
                var infoHtml = '<div class="search-result-info">';
                infoHtml += '<i class="fas fa-search"></i> ';
                infoHtml += '<span class="keyword">"' + searchKeyword + '"</span> ';
                infoHtml += '</div>';
                
                boardContentDiv.insertAdjacentHTML('beforebegin', infoHtml);
            }
        };

        // 상세(페이지 전환 버전)
        const showPostDetail = function (postId) {
            postId = Number(postId);
            if (!postId) return;

            currentPostId = postId;
            showView('post-detail-view');

            if (postDetailContainer) {
                postDetailContainer.innerHTML = '<div class="post-detail-container"><h1>게시글을 불러오는 중...</h1></div>';
            }

            var url = joinUrl(contextPath, '/api/my/free/posts/' + postId);
            fetch(url, {credentials: 'include'})
                .then(function (res) {
                    if (!res.ok) throw new Error('게시글 조회 실패: ' + res.status);
                    return res.json();
                })
                .then(function (data) {
                    var post = data.post || {};
                    currentPostId = post.postId || null;

                    var comments = data.comments || [];
                    var currentUserId = data.currentUserId || '';
                    var currentUserRole = data.currentUserRole || '';
                    window.loginUserId = currentUserId || window.loginUserId || '';
                    window.loginUserRole = currentUserRole || window.loginUserRole || '';

                    var createdDate = post.createdAt ? new Date(post.createdAt).toLocaleDateString('ko-KR') : '';
                    var writer = post.writerName || (post.userId ? post.userId.split('@')[0] : '알 수 없음');
                    var isPostAuthor = !!(currentUserId && post.userId && currentUserId === post.userId);
                    var isAdmin = !!(currentUserRole && currentUserRole.toUpperCase().includes('ADMIN'));

                    var postActionButtons = '<button id="backToListBtn" class="btn btn-secondary">목록으로</button>';
                    if (isPostAuthor || isAdmin) {
                        if (isPostAuthor) postActionButtons += '<button id="editPostBtn" class="btn btn-primary">수정</button>';
                        postActionButtons += '<button id="deletePostBtn" class="btn btn-danger">삭제</button>';
                    }

                    if (postDetailContainer) {
                        var fixedContent = fixMediaSrc(post.content || '');
                        postDetailContainer.innerHTML =
                            '<div class="post-detail-container">'
                            + '  <div class="post-header d-flex justify-content-between align-items-center">'
                            + '    <h1 class="post-title m-0">' + (post.title || '') + '</h1>'
                            + '    <div class="post-actions">' + postActionButtons + '</div>'
                            + '  </div>'
                            + '  <div class="post-info"><p>작성자: ' + writer + ' | 작성일: ' + createdDate + ' | 조회수: ' + (post.viewCount || 0) + '</p></div>'
                            + '  <hr>'
                            + '  <div class="post-content">' + fixedContent + '</div>'
                            + '  <div id="attachments-area"></div>'
                            + '</div>';
                    }

                    var backBtn = document.getElementById('backToListBtn');
                    var editBtn = document.getElementById('editPostBtn');
                    var deleteBtn = document.getElementById('deletePostBtn');
                    backBtn && backBtn.addEventListener('click', function () {
                        showPostList(1, currentDataType);
                    });
                    editBtn && editBtn.addEventListener('click', function () {
                        showPostForm(post);
                    });
                    deleteBtn && deleteBtn.addEventListener('click', function () {
                        deletePost(post.postId);
                    });

                    if (post.fileGroupNo && Number(post.fileGroupNo) > 0) loadAttachments(post.fileGroupNo);

                    renderComments(comments, post, currentUserId, currentUserRole);
                    submitCommentBtn && submitCommentBtn.addEventListener('click', function () {
                        submitComment(post.postId);
                    });
                })
                .catch(function (err) {
                    console.error('게시글 상세 조회 오류:', err);
                    showMessageBox('게시글을 불러오는 중 오류가 발생했습니다.');
                    if (postDetailContainer) {
                        postDetailContainer.innerHTML =
                            '<p>게시글을 불러오는 중 오류가 발생했습니다.</p>'
                            + '<button id="backToListBtn" class="btn btn-secondary">목록으로</button>';
                        var backBtn = document.getElementById('backToListBtn');
                        backBtn && backBtn.addEventListener('click', function () {
                            showPostList(1, currentDataType);
                        });
                    }
                });
        };

        // 상세(모달)
        const showPostDetailInModal = function (postId) {
            postId = Number(postId);
            if (!postId) return;

            var modalContent = document.getElementById('modal-content');
            modalContent.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> 게시글을 불러오는 중...</div>';

            var modal = new bootstrap.Modal(document.getElementById('detailModal'));
            modal.show();

            var url = joinUrl(contextPath, '/api/my/free/posts/' + postId);
            fetch(url, {credentials: 'include'})
                .then(function (res) {
                    if (!res.ok) throw new Error('게시글 조회 실패');
                    return res.json();
                })
                .then(function (data) {
                    var post = data.post || {};
                    var comments = data.comments || [];
                    var currentUserId = data.currentUserId || '';
                    var currentUserRole = data.currentUserRole || '';
                    var isPostAuthor = !!(currentUserId && post.userId && currentUserId === post.userId);
                    var isAdmin = !!(currentUserRole && currentUserRole.toUpperCase().includes('ADMIN'));
                    var writer = post.writerName || (post.userId ? post.userId.split('@')[0] : '알 수 없음');
                    var createdDate = post.createdAt ? new Date(post.createdAt).toLocaleDateString('ko-KR') : '';

                    var html = '';
                    html += '<div class="post-detail-modal">';
                    html += '<h3 class="mb-2">' + (post.title || '') + '</h3>';
                    html += '<div class="post-info text-muted mb-3"><small>작성자: ' + writer + ' | 작성일: ' + createdDate + ' | 조회수: ' + (post.viewCount || 0) + '</small></div>';
                    html += '<hr>';
                    html += '<div class="post-content mb-3">' + fixMediaSrc(post.content || '') + '</div>';

                    if (post.fileGroupNo && Number(post.fileGroupNo) > 0) {
                        html += '<div id="attachments-area"></div>';
                    }

                    html += '<div class="comments-section mt-4">';
                    html += '<h5 class="mb-2">댓글 (' + comments.length + ')</h5>';

                    if (comments.length > 0) {
                        comments.forEach(function (c) {
                            var u = c.userId ? c.userId.split('@')[0] : '익명';
                            var t = c.createdAt ? new Date(c.createdAt).toLocaleString('ko-KR') : '';
                            html += '<div class="comment-item border-bottom pb-2 mb-2">';
                            html += '<div class="d-flex justify-content-between"><strong>' + u + '</strong><small class="text-muted">' + t + '</small></div>';
                            html += '<div>' + (c.content || '') + '</div>';
                            html += '</div>';
                        });
                    } else {
                        html += '<p class="text-muted">댓글이 없습니다.</p>';
                    }
                    html += '</div>';

                    html += '</div>';

                    modalContent.innerHTML = html;
                    // 푸터 액션 영역에 버튼 채우기
                    var actions = document.getElementById('modal-post-actions');
                    if (actions) {
                        let btns = '';
                        if (isPostAuthor) btns += '<button id="editPostBtnInModal" class="btn btn-primary">수정</button>';
                        if (isPostAuthor || isAdmin) btns += '<button id="deletePostBtnInModal" class="btn btn-danger">삭제</button>';
                        actions.innerHTML = btns;
                    }

                    // 이벤트 바인딩 (동일 ID 사용)
                    var editBtn = document.getElementById('editPostBtnInModal');
                    var delBtn = document.getElementById('deletePostBtnInModal');
                    var m = bootstrap.Modal.getInstance(document.getElementById('detailModal'));

                    editBtn && editBtn.addEventListener('click', function () {
                        m.hide();
                        showPostForm(post);
                    });
                    delBtn && delBtn.addEventListener('click', function () {
                        deletePost(post.postId);
                        m.hide();
                    });
                    if (post.fileGroupNo && Number(post.fileGroupNo) > 0) loadAttachments(post.fileGroupNo);
                })
                .catch(function (err) {
                    console.error('게시글 조회 오류:', err);
                    modalContent.innerHTML = '<div class="alert alert-danger">게시글을 불러오는 중 오류가 발생했습니다.</div>';
                });
        };

        // 댓글 렌더
        function renderComments(comments, post, currentUserId, currentUserRole) {
            if (!commentList) return;
            if (!comments || comments.length === 0) {
                commentList.innerHTML = '<p style="color:#666;">아직 댓글이 없습니다.</p>';
                return;
            }
            var out = '';
            comments.forEach(function (c) {
                var u = c.userId ? c.userId.split('@')[0] : '익명';
                var t = c.createdAt ? new Date(c.createdAt).toLocaleString('ko-KR') : '';
                var canDelete = (currentUserId && c.userId === currentUserId)
                    || (currentUserRole && currentUserRole.toUpperCase().includes('ADMIN'))
                    || (post.userId && currentUserId && post.userId === currentUserId);

                out += '<div class="comment-item">'
                    + '<div class="comment-header d-flex justify-content-between"><span>' + u + '</span><span>' + t + '</span></div>'
                    + '<div class="comment-content">' + (c.content || '') + '</div>'
                    + (canDelete ? '<div class="comment-actions mt-1"><button class="btn btn-danger btn-sm comment-del-btn" data-comment-id="' + c.commentId + '">삭제</button></div>' : '')
                    + '</div>';
            });
            commentList.innerHTML = out;
        }

        // 댓글 갱신
        const reloadComments = function (postId) {
            fetch(joinUrl(contextPath, '/api/my/free/posts/' + postId), {credentials: 'include'})
                .then(function (r) {
                    return r.json();
                })
                .then(function (d) {
                    renderComments(d.comments || [], d.post || {}, d.currentUserId || window.loginUserId || '', d.currentUserRole || window.loginUserRole || '');
                })
                .catch(function () {
                });
        };

        // 댓글 등록
        const submitComment = function (postId) {
            postId = Number(postId || currentPostId || document.getElementById('post-detail-container')?.dataset.postId);
            if (!postId) return alert('게시글 정보를 찾을 수 없습니다. 새로고침 후 다시 시도하세요.');
            if (isSubmittingComment) return;

            var area = document.getElementById('newCommentContent');
            var content = (area && area.value ? area.value : '').trim();
            if (!window.loginUserId) return alert('로그인이 필요합니다.');
            if (!content) return alert('댓글 내용을 입력하세요.');

            isSubmittingComment = true;
            document.getElementById('submitCommentBtn')?.setAttribute('disabled', 'disabled');

            var fd = new FormData();
            fd.append('content', content);

            fetch(joinUrl(contextPath, '/api/my/free/posts/' + postId + '/comments'), {
                method: 'POST', body: fd, credentials: 'include'
            })
                .then(function (r) {
                    if (!r.ok) throw new Error('fail');
                    return r.json();
                })
                .then(function () {
                    if (area) area.value = '';
                    reloadComments(postId);
                })
                .catch(function () {
                    alert('댓글 등록 중 오류가 발생했습니다.');
                })
                .finally(function () {
                    isSubmittingComment = false;
                    document.getElementById('submitCommentBtn')?.removeAttribute('disabled');
                });
        };

        // 댓글 삭제(위임)
        commentList && commentList.addEventListener('click', function (e) {
            var btn = e.target.closest('.comment-del-btn');
            if (!btn) return;
            var commentId = btn.getAttribute('data-comment-id');
            deleteComment(commentId, currentPostId);
        });

        const deleteComment = function (commentId, postId) {
            postId = Number(postId || currentPostId || document.getElementById('post-detail-container')?.dataset.postId);
            if (!postId) return alert('게시글 정보를 찾을 수 없습니다. 새로고침 후 다시 시도하세요.');
            if (!confirm('댓글을 삭제하시겠습니까?')) return;

            fetch(joinUrl(contextPath, '/api/my/free/comments/' + commentId), {
                method: 'DELETE',
                credentials: 'include'
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('삭제 실패');
                    return res.json();
                })
                .then(function () {
                    reloadComments(postId);
                })
                .catch(function (err) {
                    console.error(err);
                    alert('댓글 삭제 중 오류가 발생했습니다.');
                });
        };

        // 첨부
        const loadAttachments = function (fileGroupNo) {
            var area = document.getElementById('attachments-area');
            if (!area && postDetailContainer) {
                area = document.createElement('div');
                area.id = 'attachments-area';
                postDetailContainer.appendChild(area);
            }
            if (!area) return;

            area.innerHTML = '<p>첨부파일을 불러오는 중...</p>';
            fetch(joinUrl(contextPath, '/api/my/free/files?groupNo=' + encodeURIComponent(fileGroupNo)), {credentials: 'include'})
                .then(function (res) {
                    if (!res.ok) throw new Error('파일 목록 조회 실패: ' + res.status);
                    return res.json();
                })
                .then(function (files) {
                    if (!files || files.length === 0) {
                        area.innerHTML = '';
                        return;
                    }
                    var extsImage = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
                    var items = files.map(function (f) {
                        var rel = (f.fileSaveLocate || '').replace('/media/', '');
                        var imgUrl = joinUrl(contextPath, '/media/' + rel);
                        var dlUrl = joinUrl(contextPath, '/download?fileName=' + encodeURIComponent(rel));
                        var name = f.fileOriginalName || '첨부파일';
                        var isImage = extsImage.some(function (ext) {
                            return name.toLowerCase().endsWith(ext);
                        });

                        if (isImage) {
                            return '<div style="margin:6px 0">'
                                + '<a href="' + imgUrl + '" target="_blank" rel="noopener">'
                                + '<img src="' + imgUrl + '" alt="' + name + '" style="max-width:100%;height:auto;border:1px solid #eee;border-radius:6px;padding:4px"/>'
                                + '</a>'
                                + '<div><a href="' + dlUrl + '">' + name + '</a></div>'
                                + '</div>';
                        } else {
                            return '<div style="margin:6px 0"><i class="fas fa-paperclip"></i> <a href="' + dlUrl + '">' + name + '</a></div>';
                        }
                    }).join('');

                    area.innerHTML =
                        '<div style="margin:8px 0; padding:10px; border:1px solid #eee; border-radius:6px; background:#fafafa">'
                        + '<strong>첨부파일</strong><div style="margin-top:8px">' + items + '</div></div>';
                })
                .catch(function (err) {
                    console.error('첨부 불러오기 오류:', err);
                    area.innerHTML = '';
                });
        };

        // 작성/수정 (모달 단일 폼)
        const showPostForm = function (post) {
            var editModalEl = document.getElementById('editPostModal');
            var editModal = new bootstrap.Modal(editModalEl);

            var ckContainer = editModalEl.querySelector('#ckeditor-container');
            var postFormEl = editModalEl.querySelector('#postForm');
            var formTitleEl = editModalEl.querySelector('#formTitle');
            var postTitleEl = editModalEl.querySelector('#postTitle');
            var submitBtnEl = editModalEl.querySelector('#submitPostBtn');

            var isEdit = !!post;
            formTitleEl.innerText = isEdit ? '게시글 수정' : '새 게시글 작성';
            submitBtnEl.innerText = isEdit ? '저장' : '등록';

            if (isEdit) {
                postFormEl.dataset.postId = post.postId;
                postTitleEl.value = post.title || '';
            } else {
                delete postFormEl.dataset.postId;
                postTitleEl.value = '';
            }

            if (editor && editor.destroy) {
                try {
                    editor.destroy();
                } catch (e) {
                }
            }

            ClassicEditor.create(ckContainer, {
                initialData: isEdit ? (post.content || '') : '',
                simpleUpload: {
                    uploadUrl: joinUrl(contextPath, '/api/my/free/images/upload'),
                    withCredentials: true,
                    headers: (function () {
                        var h = document.querySelector('meta[name="_csrf_header"]');
                        var t = document.querySelector('meta[name="_csrf"]');
                        return (h && t) ? (function (o) {
                            o[h.content] = t.content;
                            return o;
                        })({}) : {};
                    })()
                }
            }).then(function (newEditor) {
                editor = newEditor;

                postFormEl.removeEventListener('submit', handlePostSubmit);
                postFormEl.addEventListener('submit', handlePostSubmit);

                editModal.show();
            }).catch(function (err) {
                console.error('CKEditor 초기화 오류:', err);
                showMessageBox('에디터 로딩 중 오류가 발생했습니다.');
            });
        };

        // 저장 처리
        const handlePostSubmit = function (e) {
            e.preventDefault();
            var postFormEl = document.getElementById('postForm');
            var postTitleEl = document.getElementById('postTitle');
            if (!editor) return showMessageBox('에디터 로딩이 완료되지 않았습니다.');

            var title = (postTitleEl.value || '').trim();
            var content = editor.getData();
            var plain = content.replace(/<[^>]*>/g, '').replace(/&nbsp;/g, '').trim();
            if (!title || !plain) return showMessageBox('제목과 내용을 모두 입력해주세요.');

            var postId = postFormEl.dataset.postId;
            var isEdit = !!postId;
            var url = isEdit ? joinUrl(contextPath, '/api/my/free/posts/' + postId) : joinUrl(contextPath, '/api/my/free/posts');
            var method = isEdit ? 'PUT' : 'POST';

            var files = document.getElementById('attachments').files || [];

            if (isEdit && files.length === 0) {
                var payload = {
                    postId: postId,
                    title: title,
                    content: content,
                    catCodeId: bizCodeId,
                    bizCodeId: bizCodeId
                };
                fetch(url, {
                    method: method,
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content
                    },
                    body: JSON.stringify(payload),
                    credentials: 'include'
                })
                    .then(function (res) {
                        if (!res.ok) return res.text().then(function (t) {
                            throw new Error('게시글 수정 실패: ' + t);
                        });
                        return res.json();
                    })
                    .then(function () {
                        showMessageBox('게시글이 성공적으로 수정되었습니다.', function () {
                            bootstrap.Modal.getInstance(document.getElementById('editPostModal'))?.hide();
                            showPostList(1, currentDataType);
                        });
                    })
                    .catch(function (err) {
                        console.error('게시글 수정 오류:', err);
                        showMessageBox('게시글 수정 중 오류가 발생했습니다.');
                    });
            } else {
                var fd = new FormData();
                fd.append('title', title);
                fd.append('content', content);
                fd.append('catCodeId', bizCodeId);
                fd.append('bizCodeId', bizCodeId);
                if (postId) fd.append('postId', postId);
                for (var i = 0; i < files.length; i++) fd.append('attachments', files[i]);

                fetch(url, {
                    method: method,
                    headers: {'X-CSRF-TOKEN': document.querySelector('meta[name="_csrf"]').content},
                    body: fd,
                    credentials: 'include'
                })
                    .then(function (res) {
                        if (!res.ok) return res.text().then(function (t) {
                            throw new Error('게시글 저장 실패: ' + t);
                        });
                        return res.json();
                    })
                    .then(function () {
                        showMessageBox('게시글이 성공적으로 저장되었습니다.', function () {
                            bootstrap.Modal.getInstance(document.getElementById('editPostModal'))?.hide();
                            showPostList(1, currentDataType);
                        });
                    })
                    .catch(function (err) {
                        console.error('게시글 저장 오류:', err);
                        showMessageBox('게시글 저장 중 오류가 발생했습니다.');
                    });
            }
        };

        // 게시글 삭제
        const deletePost = function (postId) {
            if (!confirm('정말로 이 게시글을 삭제하시겠습니까?')) return;
            fetch(joinUrl(contextPath, '/api/my/free/posts/' + postId), {method: 'DELETE', credentials: 'include'})
                .then(function (res) {
                    if (!res.ok) throw new Error('게시글 삭제 실패');
                    return res.json();
                })
                .then(function () {
                    showMessageBox('게시글이 삭제되었습니다.', function () {
                        showPostList(1, currentDataType);
                    });
                })
                .catch(function (err) {
                    console.error('게시글 삭제 오류:', err);
                    showMessageBox('게시글 삭제 중 오류가 발생했습니다.');
                });
        };

        // 이벤트: 새 글 버튼
        writePostBtn && writePostBtn.addEventListener('click', function () {
            showPostForm();
        });

        // 이벤트: 리스트 내 제목 클릭 → 모달 상세
        document.getElementById('board-content').addEventListener('click', function (e) {
            var a = e.target.closest('a.post-title-link');
            if (!a) return;
            e.preventDefault();
            var id = Number(a.dataset.postId);
            if (id) showPostDetailInModal(id);
        });
        
        // DOMContentLoaded 이벤트 리스너 내부에 추가
        // 검색 버튼 클릭
        document.getElementById('searchBtn').addEventListener('click', function() {
            performSearch();
        });

        // 검색어 입력 후 엔터키
        document.getElementById('searchKeyword').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });

        // 검색 초기화 버튼
        document.getElementById('resetSearchBtn').addEventListener('click', function() {
            resetSearch();
        });

        // 검색 실행 함수
        const performSearch = function() {
            var searchType = document.getElementById('searchType').value;
            var searchKeyword = document.getElementById('searchKeyword').value.trim();
            
            if (!searchKeyword) {
                alert('검색어를 입력해주세요.');
                document.getElementById('searchKeyword').focus();
                return;
            }
            
            showPostList(1, currentDataType, searchType, searchKeyword);
        };

        // 검색 초기화 함수
        const resetSearch = function() {
            document.getElementById('searchType').value = 'all';
            document.getElementById('searchKeyword').value = '';
            currentSearchType = '';
            currentSearchKeyword = '';
            
            // 검색 결과 정보 제거
            var existingInfo = document.querySelector('.search-result-info');
            if (existingInfo) {
                existingInfo.remove();
            }
            
            showPostList(1, currentDataType);
        };

        // 기존 페이지네이션 이벤트 리스너 수정
        paginationAreaDiv.addEventListener('click', function (e) {
             var link = e.target.closest('a.page-link');
             if (!link || link.closest('.page-item.disabled')) return;
             e.preventDefault();
             
             // 검색 상태 유지
             showPostList(
                 Number(link.getAttribute('data-page')) || 1, 
                 currentDataType, 
                 currentSearchType, 
                 currentSearchKeyword
             );
        });

        // 이벤트: 통계 탭
        statsNavigator.addEventListener('click', function (e) {
            var link = e.target.closest('a[data-type]');
            if (!link) return;
            e.preventDefault();
            statsNavigator.querySelectorAll('.stats-list a').forEach(function (el) {
                el.classList.remove('active');
            });
            link.classList.add('active');
            
            // 탭 변경 시 검색 초기화
            resetSearch();
            showPostList(1, link.dataset.type);
        });

        // 초기 로드
        fetchStatistics();
        showPostList(1, 'all');
    });
</script>
</body>
</html>