<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>나의 게시판 활동 내역</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <!-- Bootstrap 먼저 로드 (프로젝트 전역 Override는 mypagestyle.css가 하도록 순서 유지) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Icons / Styles -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypagestyle.css"/>
    <style>
        .card-body {
            padding: 0 !important;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>

<body>
<div id="wrap">
<%-- 헤더는 body 안에서 include --%>

    <div class="container"><%-- mypagestyle.css: 사이드바 + 메인 flex 레이아웃 --%>
        <%-- 사이드바: CSS가 .container > aside 를 잡도록 래핑 --%>
        <c:set var="activeMenu" value="activity"/>   <!-- profile | report | activity | apply -->
        <c:set var="activeSub" value="activity"/>
        <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>
        <main>
            <div class="mypage-header">
                <h2>
                    <c:out value="${bizInfo.bizName}"/>
                    <h2>나의 게시판 활동 내역</h2>
                </h2>
            </div>

            <div class="card">
                <div class="card-header">
                    <h5 class="card-title mb-3">활동 내역 조회</h5>

                    <!-- 필터 및 검색 영역 -->
                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label class="form-label">활동 분류</label>
                            <div class="btn-group w-100" role="group">
                                <input type="radio" class="btn-check" name="activityFilter" id="filterAll" value="all"
                                       checked>
                                <label class="btn btn-outline-primary" for="filterAll">전체</label>

                                <input type="radio" class="btn-check" name="activityFilter" id="filterPost"
                                       value="post">
                                <label class="btn btn-outline-primary" for="filterPost">게시글</label>

                                <input type="radio" class="btn-check" name="activityFilter" id="filterComment"
                                       value="comment">
                                <label class="btn btn-outline-primary" for="filterComment">댓글</label>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <label for="boardFilter" class="form-label">게시판 선택</label>
                            <select class="form-select" id="boardFilter">
                                <option value="all">전체 게시판</option>
                                <option value="칭찬게시판">칭찬게시판</option>
                                <option value="Q&A">Q&amp;A</option>
                                <option value="창업후기">창업후기</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label for="searchInput" class="form-label">제목 검색</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="searchInput" placeholder="제목을 입력하세요">
                            </div>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label d-none d-md-block">&nbsp;</label>
                            <button type="button" class="btn btn-secondary w-100" id="resetBtn">
                                <i class="fas fa-undo"></i> 초기화
                            </button>
                        </div>
                    </div>

                    <!-- 결과 요약 -->
                    <div class="d-flex justify-content-between align-items-center">
                        <small class="text-muted">
                            전체 <span id="totalCount"><c:out value="${articlePage.total}"/></span>개의 활동 중
                            <span id="filteredCount"><c:out value="${articlePage.total}"/></span>개 표시
                        </small>
                        <small class="text-muted">
                            <span id="currentFilter">전체</span> 활동 보기
                        </small>
                    </div>
                </div>

                <div class="card-body">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">${errorMessage}</div>
                    </c:if>

                    <div id="noDataMessage" class="text-center py-5" style="display: none;">
                        <i class="fas fa-search fa-3x text-muted mb-3"></i>
                        <p class="text-muted">검색 조건에 맞는 활동이 없습니다.</p>
                    </div>

                    <c:if test="${empty articlePage.content and empty errorMessage}">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <p class="text-muted">아직 작성한 게시글이나 댓글이 없습니다.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty articlePage.content}">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle" id="activityTable">
                                <thead class="table-light">
                                <tr>
                                    <th style="width: 10%">분류</th>
                                    <th style="width: 15%">게시판</th>
                                    <th style="width: 45%">제목</th>
                                    <th style="width: 15%">작성일</th>
                                    <th style="width: 15%">관리</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${articlePage.content}" var="activity">
                                    <tr class="activity-row"
                                        data-activity-type="${activity.activityType}"
                                        data-board-type="${activity.boardType}"
                                        data-title="${fn:escapeXml(activity.title)}">
                                        <td>
                                            <c:choose>
                                                <c:when test="${activity.activityType == 'post'}">
                                                    <span class="badge bg-primary">게시글</span>
                                                </c:when>
                                                <c:when test="${activity.activityType == 'comment'}">
                                                    <span class="badge bg-secondary">댓글</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-light text-dark">기타</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="badge bg-info">${activity.boardType}</span></td>
                                        <td>
                                            <a href="javascript:void(0)"
                                               class="text-decoration-none activity-title"
                                               data-board-type="${activity.boardType}"
                                               data-activity-type="${activity.activityType}"
                                               data-post-id="${activity.postId}"
                                               data-comment-id="${activity.commentId}"
                                               data-title="${fn:escapeXml(activity.title)}">
                                                <c:out value="${activity.title}"/>
                                            </a>
                                            <c:if test="${activity.activityType == 'comment'}">
                                                <small class="text-muted">(댓글)</small>
                                            </c:if>
                                        </td>
                                        <td><fmt:formatDate value="${activity.createdAt}"
                                                            pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <button type="button"
                                                    class="btn btn-sm btn-outline-danger delete-btn"
                                                    data-board-type="${activity.boardType}"
                                                    data-activity-type="${activity.activityType}"
                                                    data-post-id="${activity.postId}"
                                                    data-comment-id="${activity.commentId}">
                                                삭제
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- 페이징: 블록 이동(이전/다음), Disabled/Active 톤 일치 -->
                        <c:set var="hasPrevBlock" value="${articlePage.startPage > 1}"/>
                        <c:set var="hasNextBlock" value="${articlePage.endPage < articlePage.totalPages}"/>

                        <!-- 페이징: 관심구역&업종 페이지와 동일 레이아웃 -->
                        <div class="d-flex justify-content-center mt-4" style="margin-bottom: 1.5rem;">
                            <nav>
                                <ul class="pagination pagination-sm mb-0" id="pagination-area">
                                        <%-- 맨앞 --%>
                                    <li class="page-item <c:if test='${articlePage.currentPage == 1}'>disabled</c:if>">
                                        <a class="page-link" href="?currentPage=1">맨앞</a>
                                    </li>
                                        <%-- 이전 --%>
                                    <li class="page-item <c:if test='${articlePage.currentPage == 1}'>disabled</c:if>">
                                        <a class="page-link" href="?currentPage=${articlePage.currentPage - 1}">이전</a>
                                    </li>

                                        <%-- 숫자 --%>
                                    <c:forEach begin="${articlePage.startPage}" end="${articlePage.endPage}" var="pNo">
                                        <li class="page-item <c:if test='${pNo == articlePage.currentPage}'>active</c:if>">
                                            <a class="page-link" href="?currentPage=${pNo}">${pNo}</a>
                                        </li>
                                    </c:forEach>

                                        <%-- 다음 --%>
                                    <li class="page-item <c:if test='${articlePage.currentPage == articlePage.totalPages}'>disabled</c:if>">
                                        <a class="page-link" href="?currentPage=${articlePage.currentPage + 1}">다음</a>
                                    </li>
                                        <%-- 맨뒤 --%>
                                    <li class="page-item <c:if test='${articlePage.currentPage == articlePage.totalPages}'>disabled</c:if>">
                                        <a class="page-link" href="?currentPage=${articlePage.totalPages}">맨뒤</a>
                                    </li>
                                </ul>
                            </nav>
                        </div>

                    </c:if>
                </div>
            </div>
            <div class="modal fade" id="contentModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <span class="badge me-2" id="modalActivityType">게시글</span>
                            <h5 class="modal-title" id="contentModalLabel"></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                        </div>
                        <div class="modal-body">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="badge bg-info" id="modalBoardType"></span>
                                <small id="modalCreatedAt" class="text-muted"></small>
                            </div>
                            <div id="modalContent"></div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <%-- 푸터 --%>
    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</div>

<!-- 모달 스타일 (톤 통일/정렬 보정) -->
<style>
    p {
        margin-bottom: 0;
    }

    #contentModal .modal-dialog {
        margin: 30vh auto 4vh; /* 위 12vh, 양옆 auto, 아래 4vh */
    }

    .modal-dialog-centered {
        display: flex;
        align-items: center;
        min-height: calc(100vh - 3.5rem);
    }

    .btn-check:checked + .btn-outline-primary {
        background-color: #0d6efd;
        border-color: #0d6efd;
        color: #fff;
    }

    #contentModal .modal-content {
        border-radius: 12px;
        border: 1px solid #e9ecef;
        box-shadow: 0 16px 40px rgba(4, 26, 47, .15);
        overflow: hidden;
    }

    #contentModal .modal-header {
        background: #f8f9fa;
        border-bottom: 1px solid #e9ecef;
    }

    #contentModal .modal-title {
        font-family: 'GongGothicMedium', sans-serif;
        font-size: 20px;
        color: #2c3e50;
    }

    #contentModal .modal-body {
        padding: 20px;
    }

    #contentModal .modal-footer {
        background: #f8f9fa;
        border-top: 1px solid #e9ecef;
    }
</style>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(function () {
        // 원본 데이터 저장 (필터링용)
        let originalRows = [];
        $('#activityTable tbody tr').each(function () {
            originalRows.push($(this).clone(true));
        });

        // 필터링 함수
        function filterActivities() {
            const activityFilter = $('input[name="activityFilter"]:checked').val();
            const boardFilter = $('#boardFilter').val();
            const searchText = $('#searchInput').val().toLowerCase().trim();

            let filteredRows = originalRows.filter(function (row) {
                const $row = $(row);
                const activityType = $row.data('activity-type');
                const boardType = $row.data('board-type');
                const title = String($row.data('title') || '').toLowerCase();

                if (activityFilter !== 'all' && activityType !== activityFilter) return false;
                if (boardFilter !== 'all' && boardType !== boardFilter) return false;
                if (searchText && !title.includes(searchText)) return false;
                return true;
            });

            // 테이블 업데이트
            const tbody = $('#activityTable tbody');
            tbody.empty();

            if (filteredRows.length === 0) {
                $('#noDataMessage').show();
                $('#pagination').hide();
            } else {
                $('#noDataMessage').hide();
                $('#pagination').show();
                filteredRows.forEach(function (row) {
                    tbody.append(row);
                });
            }

            // 카운트/상태 업데이트
            $('#filteredCount').text(filteredRows.length);
            updateFilterStatus(activityFilter, boardFilter, searchText);
        }

        function updateFilterStatus(activityFilter, boardFilter, searchText) {
            let statusText = '';
            if (activityFilter === 'all' && boardFilter === 'all' && !searchText) {
                statusText = '전체';
            } else {
                const parts = [];
                if (activityFilter !== 'all') parts.push(activityFilter === 'post' ? '게시글' : '댓글');
                if (boardFilter !== 'all') parts.push(boardFilter);
                if (searchText) parts.push('"' + searchText + '" 검색');
                statusText = parts.join(' + ');
            }
            $('#currentFilter').text(statusText + ' 활동 보기');
        }

        // 이벤트
        $('input[name="activityFilter"]').change(filterActivities);
        $('#boardFilter').change(filterActivities);
        $('#searchInput').on('input', filterActivities);
        $('#searchInput').on('keypress', function (e) {
            if (e.which === 13) filterActivities();
        });

        // 초기화
        $('#resetBtn').click(function () {
            $('input[name="activityFilter"][value="all"]').prop('checked', true);
            $('#boardFilter').val('all');
            $('#searchInput').val('');
            filterActivities();
        });

        // 제목 클릭 → 모달
        $(document).on('click', '.activity-title', function () {
            const boardType = $(this).data('board-type');
            const activityType = $(this).data('activity-type');
            const postId = $(this).data('post-id');
            const commentId = $(this).data('comment-id');
            const title = $(this).data('title');

            const createdAt = $(this).closest('tr').find('td:nth-child(4)').text();
            const id = activityType === 'post' ? postId : commentId;

            $('#contentModalLabel').text(title);
            $('#modalActivityType')
                .text(activityType === 'post' ? '게시글' : '댓글')
                .removeClass('bg-primary bg-secondary')
                .addClass(activityType === 'post' ? 'bg-primary' : 'bg-secondary');
            $('#modalBoardType').text(boardType);
            $('#modalCreatedAt').text(createdAt);

            $('#modalContent').html(
                '<div class="text-center"><div class="spinner-border" role="status">' +
                '<span class="visually-hidden">Loading...</span></div></div>'
            );

            const ctx = '${pageContext.request.contextPath}';
            $('#contentModal').modal('show');

            $.ajax({
                url: ctx + '/my/post/activity/content',
                type: 'GET',
                data: {boardType, activityType, id},
                success: function (content) {
                    $('#modalContent').html('<div class="border rounded p-3 bg-light" style="white-space: pre-wrap;">' + content + '</div>');
                },
                error: function (xhr) {
                    console.error('AJAX Error:', xhr.responseText);
                    $('#modalContent').html('<div class="alert alert-danger">내용을 불러올 수 없습니다.</div>');
                }
            });
        });

        // 삭제
        $(document).on('click', '.delete-btn', function () {
            if (!confirm('정말로 삭제하시겠습니까? 삭제된 내용은 복구할 수 없습니다.')) return;

            const boardType = $(this).data('board-type');
            const activityType = $(this).data('activity-type');
            const postId = $(this).data('post-id');
            const commentId = $(this).data('comment-id');
            const $btn = $(this);
            const id = activityType === 'post' ? postId : commentId;

            $btn.prop('disabled', true).text('삭제 중...');

            const ctx = '${pageContext.request.contextPath}';
            $.ajax({
                url: ctx + '/my/post/activity/' + encodeURIComponent(boardType) + '/' + activityType + '/' + id,
                type: 'DELETE',
                success: function (response) {
                    if (response.success) {
                        alert(response.message);
                        location.reload();
                    } else {
                        alert(response.message);
                        $btn.prop('disabled', false).text('삭제');
                    }
                },
                error: function (xhr) {
                    console.error('Delete Error:', xhr.responseText);
                    alert('삭제 중 오류가 발생했습니다.');
                    $btn.prop('disabled', false).text('삭제');
                }
            });
        });
    });
</script>
</body>
</html>
