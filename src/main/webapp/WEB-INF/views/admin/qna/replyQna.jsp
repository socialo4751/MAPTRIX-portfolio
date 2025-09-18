<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>QnA 문의 관리 - 관리자 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
    <style>
        /* ===== 갇혀있는 느낌을 줄이기 위한 override ===== */
        .panel {
            background-color: transparent !important;
            padding: 16px 8px !important;
            border: none !important;
            box-shadow: none !important;
        }

        .inquiry-lists .panel {
            background-color: #fcfcfc !important;
            border-radius: 0 !important;
            border: 1px solid #f0f0f0 !important;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            padding: 20px !important;
        }

        .content-box {
            background-color: transparent !important;
            border: none !important;
            padding: 0 !important;
        }

        .inquiry-wrapper {
            gap: 40px;
        }

        .date-stamp {
            margin-top: 20px;
        }

        textarea {
            background-color: #f9f9f9;
        }
        .inquiry-lists .admin-header {
            border-bottom: none !important;
        }
        .list-header {
            padding-bottom: 0 !important;
        }
        .panel textarea[name="answerContent"] {
            resize: none;
            min-height: 220px;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>
    <div class="main-container">
        <div class="inquiry-wrapper">

            <div class="inquiry-details">

                <div class="panel">
                    <div class="admin-header mb-4">
                        <h2><i class="bi bi-chat-left-text me-2"></i> 문의 상세</h2>
                    </div>

                    <div class="mb-2">
                        <div class="detail-item"><strong>분류:</strong> <span class="badge bg-primary-subtle text-primary-emphasis"><c:out value="${qna.catCodeName}"/></span></div>
                        <div class="detail-item"><strong>작성자:</strong> <c:out value="${qna.writerName}"/></div>
                        <div class="detail-item"><strong>제목:</strong> <span class="fw-bold"><c:out value="${qna.title}"/></span></div>
                    </div>

                    <div class="mb-3">
                        <label class="text-secondary fw-semibold mb-2 d-block">내용</label>
                        <div class="content-box">
                            <c:out value="${qna.content}" escapeXml="false"/>
                        </div>
                    </div>

                    <c:if test="${not empty files}">
                        <div class="mt-3">
                            <label class="text-secondary fw-semibold mb-2 d-block">첨부파일</label>
                            <ul class="list-unstyled mb-0 d-flex flex-column gap-2">
                                <c:forEach var="file" items="${files}" varStatus="status">
                                    <li class="d-flex align-items-center">
                                        <i class="bi bi-paperclip me-2 text-primary"></i>
                                        <a href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                                           class="text-decoration-none text-dark text-truncate"
                                           style="font-size: 14px; white-space: nowrap;">
                                            붙임${status.index + 1}. <c:out value="${file.fileOriginalName}"/>
                                        </a>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>

                    <div class="date-stamp">
                        작성일: <fmt:formatDate value="${qna.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/admin/qna" method="post"
                      class="flex-grow-1 d-flex flex-column">
                    <input type="hidden" name="quesId" value="${qna.quesId}"/>
                    <input type="hidden" name="ansId" value="${qna.ansId}"/>
                    <div class="panel flex-grow-1 d-flex flex-column">
                        <div class="admin-header mb-4">
                            <h2><i class="bi bi-chat-right-dots me-2"></i> 관리자 답변</h2>
                        </div>

                        <label class="text-secondary fw-semibold mb-2 d-block">답변</label>
                        <textarea name="answerContent" placeholder="답변을 입력하세요." class="flex-grow-1"><c:out value="${qna.answerContent}"/></textarea>

                        <div class="date-stamp">
                            <c:choose>
                                <c:when test="${not empty qna.answeredAt}">
                                    최종 수정: <fmt:formatDate value="${qna.answeredAt}" pattern="yyyy-MM-dd HH:mm"/>
                                </c:when>
                                <c:otherwise>
                                    아직 등록된 답변이 없습니다.
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="button-group">
                            <button type="submit" class="btn-submit">
                                <c:choose>
                                    <c:when test="${not empty qna.ansId}">답변 수정</c:when>
                                    <c:otherwise>답변 등록</c:otherwise>
                                </c:choose>
                            </button>
                            <c:if test="${not empty qna.ansId}">
                                <button type="button" class="btn-delete"
                                        onclick="if(confirm('정말로 답변을 삭제하시겠습니까?')) { location.href='${pageContext.request.contextPath}/admin/qna/deleteAnswer?ansId=${qna.ansId}&quesId=${qna.quesId}' }">
                                    답변 삭제
                                </button>
                            </c:if>
                        </div>
                    </div>
                </form>
            </div>

            <div class="inquiry-lists">

                <div class="panel inquiry-list">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <div class="admin-header mb-0">
                            <h5 class="mb-0"><i class="bi bi-hourglass-split text-warning me-2"></i> 미답변 목록</h5>
                        </div>
                        <span class="text-muted small">${unansweredPage.total} 건</span>
                    </div>

                    <ul class="question-list">
                        <c:forEach var="item" items="${unansweredPage.content}" varStatus="stat">
                            <li>
                                <span class="me-2 text-muted">
                                        ${ (unansweredPage.currentPage - 1) * unansweredPage.size + stat.index + 1 }
                                </span>
                                <a href="?quesId=${item.quesId}&answeredYn=N&currentPage=${unansweredPage.currentPage}">
                                    <c:out value="${item.title}"/>
                                </a>
                                <span class="ms-auto text-secondary" style="margin-right: 5px;">
                                    <fmt:formatDate value="${item.createdAt}" pattern="MM-dd"/>
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty unansweredPage.content}">
                            <li class="text-center text-muted py-4">미답변 문의가 없습니다.</li>
                        </c:if>
                    </ul>

                    <div class="pagination-container">
                        <c:out value="${unansweredPage.pagingArea}" escapeXml="false"/>
                    </div>
                </div>

                <div class="panel inquiry-list">
                    <div class="list-header d-flex justify-content-between align-items-center">
                        <div class="admin-header mb-0">
                            <h5 class="mb-0"><i class="bi bi-check-circle text-success me-2"></i> 답변완료 목록</h5>
                        </div>
                        <span class="text-muted small">${answeredPage.total} 건</span>
                    </div>

                    <ul class="question-list">
                        <c:forEach var="item" items="${answeredPage.content}" varStatus="stat">
                            <li>
                                <span class="me-2 text-muted">
                                        ${ (answeredPage.currentPage - 1) * answeredPage.size + stat.index + 1 }
                                </span>
                                <a href="?quesId=${item.quesId}&answeredYn=Y&currentPage=${answeredPage.currentPage}">
                                    <c:out value="${item.title}"/>
                                </a>
                                <span class="ms-auto text-secondary" style="margin-right: 5px;">
                                    <fmt:formatDate value="${item.createdAt}" pattern="MM-dd"/>
                                </span>
                            </li>
                        </c:forEach>
                        <c:if test="${empty answeredPage.content}">
                            <li class="text-center text-muted py-4">답변완료된 문의가 없습니다.</li>
                        </c:if>
                    </ul>

                    <div class="pagination-container">
                        <c:out value="${answeredPage.pagingArea}" escapeXml="false"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
