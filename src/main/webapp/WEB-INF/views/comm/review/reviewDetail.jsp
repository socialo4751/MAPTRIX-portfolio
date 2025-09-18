<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${postVO.title} - 창업 후기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/commstyle.css"/>
</head>
<body>

<%@ include file="/WEB-INF/views/include/top.jsp" %>

<div class="container">
    <c:set var="activeMenu" value="review"/>
    <%@ include file="/WEB-INF/views/include/commSideBar.jsp" %>

    <main>
        <!-- ✅ 페이지 헤더 -->
        <div class="detail-header border-bottom pb-3 mb-4">
            <h2>${postVO.title}</h2>
            <p class="d-flex justify-content-between flex-wrap align-items-center">
                <span>카테고리: ${postVO.catCodeName}</span>
                <span class="d-flex gap-3">
                    <span>작성자: ${postVO.writerName}</span>
                    <span>작성일: <fmt:formatDate value="${postVO.createdAt}" pattern="yyyy-MM-dd HH:mm"/></span>
                    <span>조회수: ${postVO.viewCount}</span>
                </span>
            </p>
        </div>

        <!-- ✅ 본문 내용 -->
        <section class="content-wrapper">
            <div class="mb-4" id="detail-content" style="line-height: 1.7;">
                <c:out value="${postVO.content}" escapeXml="false"/>
            </div>

           <c:if test="${not empty reviewFiles}">
    <div class="border rounded bg-white p-4 mb-4">
        <div class="fw-semibold mb-2">첨부파일</div>
        <ul class="list-unstyled d-flex flex-column gap-2 mb-0">
            <c:forEach var="file" items="${reviewFiles}" varStatus="status">
                <li class="d-flex align-items-center">
                    <i class="material-icons me-2 text-secondary" style="font-size: 20px;">attach_file</i>
                    <a href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                       class="text-decoration-none text-dark text-truncate"
                       style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                        붙임${status.index + 1}. ${file.fileOriginalName}
                    </a>
                </li>
            </c:forEach>
        </ul>

  

    </div>
</c:if>

            <!-- ✅ 하단 버튼 -->
            <div class="text-end mt-4 d-flex justify-content-end gap-2" style="margin-bottom: 25px;">
                <a href="${pageContext.request.contextPath}/comm/review" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-list"></i> 목록으로
                </a>

                <sec:authorize access="isAuthenticated()">
                    <sec:authentication property="principal.username" var="currentUserId"/>
                    <sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"/>

                    <c:if test="${currentUserId eq postVO.userId}">
                        <a href="${pageContext.request.contextPath}/comm/review/updateForm?postId=${postVO.postId}"
                           class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-pencil"></i> 수정
                        </a>
                        <button type="button" class="btn btn-outline-danger btn-sm"
                                onclick="deletePost(${postVO.postId});">
                            <i class="bi bi-trash"></i> 삭제
                        </button>
                    </c:if>
                    <c:if test="${isAdmin and currentUserId ne postVO.userId}">
                        <button type="button" class="btn btn-outline-danger btn-sm"
                                onclick="deletePost(${postVO.postId});">
                            <i class="bi bi-trash"></i> 삭제
                        </button>
                    </c:if>
                </sec:authorize>
            </div>
        </section>


        <!-- ✅ 댓글 영역 -->
        <div class="comment-section border-top pt-4">
            <h5 class="mb-3 text-dark-blue">댓글</h5>

            <div id="comments-list" class="mb-4">
                <c:choose>
                    <c:when test="${not empty commentList}">
                        <c:forEach var="comment" items="${commentList}">
                            <div class="border rounded p-3 mb-3 <c:if test='${comment.parentId != 0}'>bg-light</c:if>">
                                <div class="d-flex justify-content-between small text-muted mb-2">
                                    <span>작성자: ${comment.writerName}</span>
                                    <span><fmt:formatDate value="${comment.createdAt}"
                                                          pattern="yyyy-MM-dd HH:mm"/></span>
                                </div>
                                <div class="mb-2">${comment.content}</div>
                                <div class="text-end">
                                    <sec:authorize access="isAuthenticated()">
                                        <sec:authentication property="principal.username" var="currentUserId"/>
                                        <sec:authorize access="hasRole('ROLE_ADMIN')" var="isAdmin"/>
                                        <c:if test="${currentUserId eq comment.userId}">
                                            <button class="btn btn-sm btn-outline-secondary me-1"
                                                    onclick="editComment(${comment.commentId})">수정
                                            </button>
                                        </c:if>
                                        <c:if test="${currentUserId eq comment.userId || isAdmin || currentUserId eq postVO.userId}">
                                            <button class="btn btn-sm btn-outline-danger"
                                                    onclick="deleteComment(${comment.commentId})">삭제
                                            </button>
                                        </c:if>
                                    </sec:authorize>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted text-center">등록된 댓글이 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ✅ 댓글 작성 -->
            <sec:authorize access="isAuthenticated()">
                <div class="mb-5">
        <textarea id="comment-text"
                  class="form-control mb-2"
                  rows="4"
                  placeholder="댓글을 입력하세요."
                  style="resize: none"></textarea>

                    <div class="text-end">
                        <button type="button"
                                id="comment-submit-btn"
                                class="btn btn-primary btn-sm">
                            댓글 등록
                        </button>
                    </div>
                </div>
            </sec:authorize>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    console.log("스크립트 파일 로드됨");

    // jQuery 준비 완료 시 실행
    $(document).ready(function () {
        console.log("jQuery ready 완료");
        console.log("postId 값:", ${postVO.postId});

        // 댓글 등록 버튼 이벤트 바인딩
        $('#comment-submit-btn').on('click', function () {
            console.log("댓글 등록 버튼 클릭됨");
            createComment(${postVO.postId});
        });
    });

    // 댓글 작성 함수
    function createComment(postId) {
        console.log("=== createComment 함수 시작 ===");
        console.log("createComment 함수 호출됨. postId:", postId);

        try {
            // jQuery 선택자 테스트
            var textArea = $('#comment-text');
            console.log("textarea 찾기 결과:", textArea.length);

            if (textArea.length === 0) {
                console.error("comment-text textarea를 찾을 수 없습니다!");
                alert("textarea를 찾을 수 없습니다!");
                return;
            }

            // 댓글 내용을 가져와서 앞뒤 공백을 제거합니다.
            var commentContent = textArea.val().trim();
            console.log("댓글 내용:", "'" + commentContent + "'");

            // 내용이 비어있으면 경고 메시지를 표시하고 함수를 종료합니다.
            if (commentContent === '') {
                console.log("댓글 내용이 비어있음");
                alert('댓글 내용을 입력해주세요.');
                return;
            }

            console.log("AJAX 요청 준비 시작");
            console.log("요청 URL:", '${pageContext.request.contextPath}/comm/review/comments/create?postId=' + postId);

            // AJAX 요청을 보냅니다.
            $.ajax({
                url: '${pageContext.request.contextPath}/comm/review/comments/create?postId=' + postId,
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    content: commentContent
                }),
                beforeSend: function () {
                    console.log("AJAX 요청 전송 시작");
                    // 버튼 비활성화로 중복 클릭 방지
                    $('#comment-submit-btn').prop('disabled', true).text('등록 중...');
                },
                success: function (response) {
                    console.log("AJAX 성공:", response);
                    alert(response);
                    $('#comment-text').val('');
                    location.reload();
                },
                error: function (xhr, status, error) {
                    console.error("AJAX 오류:");
                    console.error("Status:", xhr.status);
                    console.error("Response:", xhr.responseText);
                    console.error("Error:", error);
                    alert('댓글 작성에 실패했습니다: ' + xhr.responseText);
                },
                complete: function () {
                    // 요청 완료 후 버튼 다시 활성화
                    $('#comment-submit-btn').prop('disabled', false).text('댓글 등록');
                }
            });

        } catch (e) {
            console.error("createComment 함수에서 예외 발생:", e);
            alert("오류가 발생했습니다: " + e.message);
        }

        console.log("=== createComment 함수 끝 ===");
    }

    // 게시글 삭제 함수
    function deletePost(postId) {
        console.log("deletePost 함수 호출됨. postId:", postId);
        if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/comm/review/delete?postId=' + postId,
                type: 'DELETE',
                success: function (response) {
                    alert(response);
                    window.location.href = '${pageContext.request.contextPath}/comm/review';
                },
                error: function (xhr, status, error) {
                    alert('게시글 삭제에 실패했습니다: ' + xhr.responseText);
                    console.error('삭제 실패:', error);
                }
            });
        }
    }

    // 댓글 수정 함수
    function editComment(commentId) {
        console.log("editComment 함수 호출됨. commentId:", commentId);
        var currentContent = prompt('수정할 댓글 내용을 입력하세요:');
        if (currentContent !== null && currentContent.trim() !== '') {
            $.ajax({
                url: '${pageContext.request.contextPath}/comm/review/comments/update',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({
                    commentId: commentId,
                    content: currentContent
                }),
                success: function (response) {
                    alert(response);
                    location.reload();
                },
                error: function (xhr, status, error) {
                    alert('댓글 수정에 실패했습니다: ' + xhr.responseText);
                    console.error('댓글 수정 실패:', error);
                }
            });
        }
    }

    // 댓글 삭제 함수
    function deleteComment(commentId) {
        console.log("deleteComment 함수 호출됨. commentId:", commentId);
        if (confirm('정말로 이 댓글을 삭제하시겠습니까?')) {
            $.ajax({
                url: '${pageContext.request.contextPath}/comm/review/comments/delete?commentId=' + commentId,
                type: 'DELETE',
                success: function (response) {
                    alert(response);
                    location.reload();
                },
                error: function (xhr, status, error) {
                    alert('댓글 삭제에 실패했습니다: ' + xhr.responseText);
                    console.error('댓글 삭제 실패:', error);
                }
            });
        }
    }

    console.log("모든 함수 정의 완료");
</script>
</body>
</html>
