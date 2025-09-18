<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>오픈 API 신청 상세 및 심사</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Admin common style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css"/>

    <style>
        .admin-header h2 {
            font-weight: 800;
        }

        .admin-header p {
            margin: 0;
            color: #6c757d;
        }

        .table-view th {
            width: 220px;
            background: #f8f9fa;
        }

        .purpose-box {
            white-space: pre-wrap;
            font-family: inherit;
            padding: .75rem;
            background: #fcfcfd;
            border: 1px solid #e9ecef;
            border-radius: .5rem;
        }

        .status-badge {
            font-weight: 700;
        }

        .status-pending {
            background-color: #ffc107;
            color: #212529;
        }

        .status-approved {
            background-color: #28a745;
        }

        .status-rejected {
            background-color: #dc3545;
        }

        .action-bar {
            gap: .5rem;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>


<div id="wrapper">

    <c:set var="activeMenu" value="openapi"/>
    <c:set var="activeSub" value="applications"/>

    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <!-- 타이틀 / 안내 -->
            <div class="d-flex justify-content-between align-items-center">
                <div class="admin-header">
                    <h2 class="mb-1">
                        <i class="bi bi-plug me-2 text-primary"></i> 오픈 API 신청 상세 및 심사
                    </h2>
                    <p>신청 내용을 검토하고 승인 또는 반려 처리를 진행합니다.</p>
                </div>
            </div>

            <!-- 상세 카드 -->
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-view align-middle mb-0">
                            <tbody>
                            <tr>
                                <th scope="row">신청 ID</th>
                                <td>${application.applicationId}</td>
                            </tr>
                            <tr>
                                <th scope="row">신청 API</th>
                                <td>${application.apiNameKr}</td>
                            </tr>
                            <tr>
                                <th scope="row">신청자</th>
                                <td>
                                    <span class="fw-semibold">${application.userName}</span>
                                    <span class="text-muted">(${application.userId})</span>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">신청일</th>
                                <td><fmt:formatDate value="${application.applicatedAt}"
                                                    pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            </tr>
                            <tr>
                                <th scope="row">현재 상태</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${application.status eq '제출완료' || application.statusCode eq 'PENDING'}">
                                            <span class="badge rounded-pill status-badge status-pending">제출완료</span>
                                        </c:when>
                                        <c:when test="${application.status eq '승인' || application.statusCode eq 'APPROVED'}">
                                            <span class="badge rounded-pill status-badge status-approved">승인</span>
                                        </c:when>
                                        <c:when test="${application.status eq '반려' || application.statusCode eq 'REJECTED'}">
                                            <span class="badge rounded-pill status-badge status-rejected">반려</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill bg-secondary">${application.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">활용 목적</th>
                                <td>
                                    <div class="purpose-box">${application.purposeDesc}</div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 심사 액션 -->
                <c:if test="${application.statusCode == 'PENDING'}">
                    <div class="card-footer d-flex justify-content-between align-items-center flex-wrap">
                        <div class="text-muted small">
                            심사 상태를 선택하세요. 승인 시 즉시 효력이 발생합니다.
                        </div>
                        <form id="processForm"
                              class="d-flex action-bar"
                              method="post"
                              action="${pageContext.request.contextPath}/admin/openapi/applications/process">
                            <input type="hidden" name="applicationId" value="${application.applicationId}">
                            <input type="hidden" name="rejectReason" id="rejectReason" value="">

                            <button type="button" class="btn btn-success"
                                    onclick="onApprove()">
                                <i class="bi bi-check2-circle"></i> 승인하기
                            </button>
                            <button type="button" class="btn btn-outline-danger"
                                    onclick="onReject()">
                                <i class="bi bi-x-circle"></i> 반려하기
                            </button>

                            <!-- 실제 서버 분기용 -->
                            <input type="hidden" name="action" id="actionField" value="">
                        </form>
                    </div>
                </c:if>
            </div>

            <!-- 하단 목록 버튼 (대체 경로) -->
            <div class="mt-3 text-end">
                <a class="btn btn-outline-secondary"
                   href="${pageContext.request.contextPath}/admin/openapi/applications">
                    목록으로
                </a>
            </div>

        </div><!-- /.main-container -->
    </div><!-- /#content -->
</div><!-- /#wrapper -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const CP = '${pageContext.request.contextPath}' || '';

    function submitWith(action) {
        const form = document.getElementById('processForm');
        document.getElementById('actionField').value = action;
        form.submit();
    }

    function onApprove() {
        if (confirm('해당 신청을 승인하시겠습니까?')) {
            submitWith('approve');
        }
    }

    function onReject() {
        const reason = prompt('반려 사유를 입력하세요 (필수):', '');
        if (reason === null) return; // 취소
        const trimmed = String(reason).trim();
        if (!trimmed) {
            alert('반려 사유를 입력해야 합니다.');
            return;
        }
        document.getElementById('rejectReason').value = trimmed;
        submitWith('reject');
    }
</script>

</body>
</html>
