<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>회원 목록 관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css"/>

    <style>
        body.modal-open { padding-right: 0 !important; }

        /* compact chips + badges */
        .chip-btn { border-radius: 9999px; --bs-btn-padding-y: .25rem; --bs-btn-padding-x: .6rem; --bs-btn-font-size: .8rem; }
        .chip-badge { font-size: .75rem; font-weight: 600; background-color: var(--bs-gray-100); border: 1px solid rgba(0,0,0,.08); margin-left: .4rem; }
        .chips { gap: .375rem; }
        @media (max-width: 576px) { .chips { gap: .25rem; } }

        .chip-btn { font-weight: 600; letter-spacing: -.2px; }
        .chip-btn.btn-outline-secondary { color:#212529!important; border-color:#cfd4da; background:#fff; }
        .chip-btn.btn-outline-secondary:hover { color:#000!important; background:#f8f9fa; border-color:#adb5bd; }
        .btn.btn-secondary .chip-badge { background: rgba(255,255,255,.18); color:#fff; border-color:transparent; }
        .btn.btn-outline-secondary .chip-badge { background:#f1f3f5; color:#495057; border-color:#e9ecef; }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>

<body>
<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">
            <!-- 제목 + 설명 -->
            <div class="admin-header mb-4" style="margin-top: 60px;">
                <h2><i class="bi bi-people-fill me-2"></i> 회원 상태 조회 및 관리</h2>
                <p class="mb-0 text-muted">전체 회원을 확인하고 상태를 관리할 수 있습니다.</p>
            </div>

            <!-- 🔍 필터 + 검색 (같은 줄, 컴팩트) -->
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">

                <%-- 필터 링크용 URL 생성: 검색어 유지 --%>
                <c:url var="urlAll" value="/admin/users">
                    <c:if test="${not empty param.searchKeyword}">
                        <c:param name="searchKeyword" value="${param.searchKeyword}"/>
                    </c:if>
                </c:url>
                <c:url var="urlActive" value="/admin/users">
                    <c:param name="searchType" value="USER_Y"/>
                    <c:if test="${not empty param.searchKeyword}">
                        <c:param name="searchKeyword" value="${param.searchKeyword}"/>
                    </c:if>
                </c:url>
                <c:url var="urlSuspended" value="/admin/users">
                    <c:param name="searchType" value="USER_N"/>
                    <c:if test="${not empty param.searchKeyword}">
                        <c:param name="searchKeyword" value="${param.searchKeyword}"/>
                    </c:if>
                </c:url>
                <c:url var="urlWithdrawn" value="/admin/users">
                    <c:param name="searchType" value="USER_W"/>
                    <c:if test="${not empty param.searchKeyword}">
                        <c:param name="searchKeyword" value="${param.searchKeyword}"/>
                    </c:if>
                </c:url>
                <c:url var="urlNewMonth" value="/admin/users">
                    <c:param name="searchType" value="USER_NEW_MONTH"/>
                    <c:if test="${not empty param.searchKeyword}">
                        <c:param name="searchKeyword" value="${param.searchKeyword}"/>
                    </c:if>
                </c:url>

                <%-- 왼쪽: 상태 칩 버튼 + 카운트 --%>
                <div class="d-flex align-items-center flex-wrap chips">
                    <a href="${urlAll}" class="btn chip-btn ${empty param.searchType ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        전체
                        <span class="badge rounded-pill chip-badge">
                            <c:out value="${statusSummary.TOTAL_COUNT}" default="0"/>명
                        </span>
                    </a>
                    <a href="${urlActive}" class="btn chip-btn ${param.searchType == 'USER_Y' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        활성
                        <span class="badge rounded-pill chip-badge">
                            <c:out value="${statusSummary.ACTIVE_COUNT}" default="0"/>명
                        </span>
                    </a>
                    <a href="${urlSuspended}" class="btn chip-btn ${param.searchType == 'USER_N' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        정지
                        <span class="badge rounded-pill chip-badge">
                            <c:out value="${statusSummary.SUSPENDED_COUNT}" default="0"/>명
                        </span>
                    </a>
                    <a href="${urlWithdrawn}" class="btn chip-btn ${param.searchType == 'USER_W' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        탈퇴
                        <span class="badge rounded-pill chip-badge">
                            <c:out value="${statusSummary.WITHDRAWN_COUNT}" default="0"/>명
                        </span>
                    </a>
                    <a href="${urlNewMonth}" class="btn chip-btn ${param.searchType == 'USER_NEW_MONTH' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        신규 가입(당월)
                        <span class="badge rounded-pill chip-badge">
                            <c:out value="${statusSummary.NEW_MONTH_COUNT}" default="0"/>명
                        </span>
                    </a>
                </div>

                <%-- 오른쪽: 컴팩트 검색폼 --%>
                <form action="/admin/users" method="get" class="d-flex align-items-center ms-auto flex-wrap gap-1">
                    <select name="searchType" class="form-select form-select-sm" style="width: 140px;" onchange="this.form.submit()">
                        <option value="" ${empty param.searchType ? 'selected' : ''}>모든 상태</option>
                        <option value="USER_Y" ${param.searchType == 'USER_Y' ? 'selected' : ''}>활성</option>
                        <option value="USER_N" ${param.searchType == 'USER_N' ? 'selected' : ''}>정지</option>
                        <option value="USER_W" ${param.searchType == 'USER_W' ? 'selected' : ''}>탈퇴</option>
                        <option value="USER_NEW_MONTH" ${param.searchType == 'USER_NEW_MONTH' ? 'selected' : ''}>신규 가입(당월)</option>
                    </select>

                    <div class="input-group input-group-sm" style="width: 300px;">
                        <input type="text" name="searchKeyword" class="form-control"
                               placeholder="ID·이름·이메일·전화번호"
                               value="${fn:escapeXml(param.searchKeyword)}">
                        <button type="submit" class="btn btn-primary" title="검색">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- 메시지 출력 -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success"><c:out value="${successMessage}"/></div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
            </c:if>

            <!-- 회원 목록 테이블 -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle text-center">
                    <thead class="table-light">
                    <tr>
                        <th>회원 ID</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>전화번호</th>
                        <th>가입일</th>
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty usersList}">
                            <c:forEach var="user" items="${usersList}">
                                <tr>
                                    <td><c:out value="${user.userId}"/></td>
                                    <td><c:out value="${user.name}"/></td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td><c:out value="${user.phoneNumber}"/></td>
                                    <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                    <td>
                                        <c:choose>
                                            <%-- 탈퇴 우선 --%>
                                            <c:when test="${not empty user.withdrawnAt}">
                                                <span class="status-withdrawn text-danger">
                                                    <i class="bi bi-x-circle-fill"></i>
                                                    탈퇴 (<fmt:formatDate value="${user.withdrawnAt}" pattern="yyyy-MM-dd"/>)
                                                </span>
                                            </c:when>
                                            <%-- 정지 --%>
                                            <c:when test="${user.enabled eq 'N' or user.enabled eq 'false'}">
                                                <span class="status-suspended text-warning">
                                                    <i class="bi bi-pause-circle-fill"></i> 정지
                                                </span>
                                            </c:when>
                                            <%-- 활성 --%>
                                            <c:when test="${user.enabled eq 'Y' or user.enabled eq 'true'}">
                                                <span class="status-active text-success">
                                                    <i class="bi bi-check-circle-fill"></i> 활성화
                                                </span>
                                            </c:when>
                                            <c:otherwise><span class="text-muted">알 수 없음</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-outline-primary"
                                                data-bs-toggle="modal" data-bs-target="#userDetailModal"
                                                data-user-id="${user.userId}">상세</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="7">조회된 회원이 없습니다.</td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="pagination-container mt-4 text-center">
                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
            </div>
        </div>
    </div>
</div>

<!-- 회원 상세 모달 -->
<div class="modal fade" id="userDetailModal" tabindex="-1" aria-labelledby="userDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">회원 상세 정보 및 관리</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-2"><div class="col-4 text-end fw-bold">회원 ID:</div><div class="col-8" id="modalUserId"></div></div>
                <div class="row mb-2"><div class="col-4 text-end fw-bold">이름:</div><div class="col-8" id="modalUserName"></div></div>
                <div class="row mb-2"><div class="col-4 text-end fw-bold">이메일:</div><div class="col-8" id="modalUserEmail"></div></div>
                <div class="row mb-2"><div class="col-4 text-end fw-bold">전화번호:</div><div class="col-8" id="modalUserPhoneNumber"></div></div>
                <div class="row mb-2"><div class="col-4 text-end fw-bold">가입일:</div><div class="col-8" id="modalUserCreatedAt"></div></div>
                <div class="row mb-3"><div class="col-4 text-end fw-bold">현재 상태:</div><div class="col-8" id="modalUserCurrentStatus"></div></div>

                <hr/>
                <h5 class="mb-3">정지 이력</h5>
                <div class="table-responsive">
                    <table class="table table-bordered small text-center">
                        <thead class="table-light">
                        <tr><th>번호</th><th>정지 사유</th><th>정지일</th><th>해제일</th></tr>
                        </thead>
                        <tbody id="suspensionHistoryBody"></tbody>
                    </table>
                    <div id="noSuspensionHistory" class="alert alert-info text-center" style="display:none;">정지 이력이 없습니다.</div>
                </div>

                <hr/>
                <h5 class="mt-4 mb-3">회원 상태 변경</h5>
                <form id="userStatusUpdateForm">
                    <input type="hidden" id="statusUpdateUserId" name="userId">
                    <div id="statusChangeSection"></div>
                    <div class="text-end mt-3">
                        <button type="submit" class="btn btn-warning" id="statusChangeButton">상태 변경</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // (1) 오늘로부터 days일 뒤를 'YYYY-MM-DD HH:mm'으로 계산
    function calculateReleaseDate(days) {
        const d = parseInt(days, 10);
        if (isNaN(d)) return '--:';
        const today = new Date();
        const future = new Date(today);
        future.setDate(today.getDate() + d);
        const y = future.getFullYear();
        const m = String(future.getMonth() + 1).padStart(2, '0');
        const dd = String(future.getDate()).padStart(2, '0');
        const hh = String(future.getHours()).padStart(2, '0');
        const mm = String(future.getMinutes()).padStart(2, '0');
        return `${y}-${m}-${dd} ${hh}:${mm}`;
    }

    $(document).ready(function () {
        // 모달이 열릴 때
        $('#userDetailModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const userId = button.data('user-id');
            const $modal = $(this);

            // 초기화
            $('#suspensionHistoryBody').empty();
            $('#noSuspensionHistory').hide();
            $('#statusChangeSection').empty();
            $('#statusUpdateUserId').val(userId);
            $('#statusChangeButton').text('상태 변경').show();
            $('#modalUserCurrentStatus').empty();

            // 상세 조회
            $.ajax({
                url: '/admin/users/api/' + encodeURIComponent(userId),
                method: 'GET',
                success: function (response) {
                    if (!response || !response.user) {
                        alert('회원 정보를 불러오는데 실패했습니다.');
                        $modal.modal('hide');
                        return;
                    }

                    const user = response.user;

                    // 모달 기본정보 채우기 (텍스트로만)
                    $modal.find('#modalUserId').text(user.userId ?? '');
                    $modal.find('#modalUserName').text(user.name ?? '');
                    $modal.find('#modalUserEmail').text(user.email ?? '');
                    $modal.find('#modalUserPhoneNumber').text(user.phoneNumber ?? '');
                    $modal.find('#modalUserCreatedAt').text(user.createdAt ?? '');

                    // 현재 상태 배지 생성 (우리 템플릿으로만)
                    const $status = $('<span>');
                    if (user.enabled === 'N' && user.withdrawnAt) {
                        $status.addClass('status-withdrawn text-danger').text(`탈퇴 (${user.withdrawnAt})`);
                        $status.prepend($('<i>').addClass('bi bi-x-circle-fill me-1'));
                        // 탈퇴자는 상태 변경 불가
                        $('#statusChangeSection').empty()
                            .append($('<p>').addClass('alert alert-info mb-0').text('탈퇴한 회원은 상태 변경이 불가합니다.'));
                        $('#statusChangeButton').hide();
                    } else if (user.enabled === 'N' && !user.withdrawnAt) {
                        $status.addClass('status-suspended text-warning').text('정지');
                        $status.prepend($('<i>').addClass('bi bi-pause-circle-fill me-1'));
                        // 즉시 활성화 버튼만 제공
                        const $row = $('<div>').addClass('form-group row');
                        const $col = $('<div>').addClass('col-md-8 offset-md-4');
                        const $btn = $('<button type="button">').addClass('btn btn-success').attr('id','activateUserBtn').text('즉시 활성화');
                        $col.append($btn); $row.append($col);
                        $('#statusChangeSection').empty().append($row);
                        $('#statusChangeButton').hide();

                        $('#activateUserBtn').off('click').on('click', function () {
                            if (confirm(userId + ' 회원을 즉시 활성화하시겠습니까?')) {
                                sendUserStatusUpdate(userId, 'Y', null, null); // 활성화
                            }
                        });
                    } else {
                        $status.addClass('status-active text-success').text('활성화');
                        $status.prepend($('<i>').addClass('bi bi-check-circle-fill me-1'));

                        // 상태 변경 섹션 스켈레톤
                        const $section = $('#statusChangeSection').empty();

                        // 정지 기간 선택
                        const $row1 = $('<div>').addClass('form-group row');
                        $row1.append($('<label>').addClass('col-md-4 col-form-label text-right font-weight-bold')
                            .attr('for','suspensionPeriod').text('정지 기간:'));
                        const $col1 = $('<div>').addClass('col-md-8');
                        const $select = $('<select>').addClass('form-control').attr({id:'suspensionPeriod', name:'suspensionPeriod'});
                        $select.append($('<option>').val('').text('기간 선택'));
                        (response.suspensionDays || []).forEach(day => {
                            // days 추정: 서버가 day.days 제공하면 사용, 없으면 codeName 내 숫자 추출
                            const days = (day.days != null) ? parseInt(day.days, 10)
                                : parseInt(String(day.codeName || '').match(/\d+/)?.[0] || '0', 10);
                            const $opt = $('<option>')
                                .val(day.codeId)
                                .text(day.codeName || '')
                                .attr('data-days', isNaN(days) ? '' : String(days));
                            $select.append($opt);
                        });
                        $col1.append($select); $row1.append($col1);

                        // 정지 사유
                        const $row2 = $('<div>').addClass('form-group row').attr('id','suspensionReasonGroup');
                        $row2.append($('<label>').addClass('col-md-4 col-form-label text-right font-weight-bold')
                            .attr('for','suspensionReason').text('정지 사유:'));
                        const $col2 = $('<div>').addClass('col-md-8');
                        $col2.append($('<textarea>').addClass('form-control').attr({id:'suspensionReason', name:'suspensionReason', rows:3, placeholder:'정지 사유를 입력하세요'}));
                        $row2.append($col2);

                        // 해제 예정일 표시
                        const $row3 = $('<div>').addClass('form-group row').attr('id','calculatedReleaseDateGroup');
                        $row3.append($('<label>').addClass('col-md-4 col-form-label text-right font-weight-bold')
                            .text('해제 예정일:'));
                        const $col3 = $('<div>').addClass('col-md-8 d-flex align-items-center');
                        $col3.append($('<span>').attr('id','calculatedReleaseDate').text('--:'));
                        $row3.append($col3);

                        $section.append($row1, $row2, $row3);

                        // 버튼 텍스트
                        $('#statusChangeButton').show().text('정지');

                        // 기간 변경 시 해제 예정일 계산
                        $('#suspensionPeriod').off('change').on('change', function () {
                            const days = parseInt($(this).find('option:selected').attr('data-days') || '', 10);
                            $('#calculatedReleaseDate').text(calculateReleaseDate(days));
                        });
                        // 초기값
                        $('#calculatedReleaseDate').text('--:');
                    }
                    $('#modalUserCurrentStatus').empty().append($status);

                    // 정지 이력 테이블 (안전하게 DOM 추가)
                    if (response.suspensionHistory && response.suspensionHistory.length > 0) {
                        const $tbody = $('#suspensionHistoryBody').empty();
                        response.suspensionHistory.forEach((history, idx) => {
                            const $tr = $('<tr>');
                            $('<td>').text(idx + 1).appendTo($tr);
                            $('<td>').text(history?.reason || '사유 없음').appendTo($tr);
                            $('<td>').text(history?.changedAt || '').appendTo($tr);
                            $('<td>').text(history?.expiresAt || '만료일 없음').appendTo($tr);
                            $tbody.append($tr);
                        });
                    } else {
                        $('#noSuspensionHistory').show();
                    }
                },
                error: function (xhr) {
                    alert('회원 정보를 불러오는 중 오류가 발생했습니다: ' + (xhr.responseText || '서버 오류'));
                    $modal.modal('hide');
                }
            });
        });

        // 상태 변경 요청
        function sendUserStatusUpdate(userId, newStatus, suspensionReason, suspensionPeriod) {
            $.ajax({
                url: '/admin/users/api/updateStatus',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    userId: userId,
                    newStatus: newStatus,
                    suspensionReason: suspensionReason,
                    suspensionPeriod: suspensionPeriod
                }),
                success: function (response) {
                    if (response && response.success) {
                        alert(response.message || '처리되었습니다.');
                        $('#userDetailModal').modal('hide');
                        location.reload();
                    } else {
                        alert('상태 변경 실패: ' + (response?.message || '알 수 없는 오류'));
                    }
                },
                error: function (xhr) {
                    alert('상태 변경 중 오류가 발생했습니다: ' + (xhr.responseText || '서버 오류'));
                }
            });
        }

        // 정지 상태 변경 폼 제출
        $('#userStatusUpdateForm').on('submit', function (e) {
            e.preventDefault();

            const userId = $('#statusUpdateUserId').val();
            const actionType = $('#statusChangeButton').text().trim();

            if (actionType === '정지') {
                const suspensionPeriodCode = $('#suspensionPeriod').val(); // 서버 전송용 코드
                const suspensionPeriodText = $('#suspensionPeriod option:selected').text(); // 안내문용
                const suspensionReason = $('#suspensionReason').val() || '';

                if (!suspensionPeriodCode) {
                    alert('정지 기간을 선택해야 합니다.');
                    return;
                }
                if (suspensionReason.trim() === '') {
                    alert('정지 사유를 입력해야 합니다.');
                    return;
                }
                if (!confirm(`${userId} 회원을 ${suspensionPeriodText}로 전환(정지)하시겠습니까?`)) {
                    return;
                }
                sendUserStatusUpdate(userId, 'N', suspensionReason, suspensionPeriodCode);
            }
            // '즉시 활성화'는 별도 클릭 핸들러에서 처리
        });
    });
</script>
</body>
</html>
