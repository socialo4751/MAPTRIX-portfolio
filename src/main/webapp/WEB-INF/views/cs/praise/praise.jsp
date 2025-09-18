<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>직원 칭찬게시판</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!-- custom styles -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">

    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>

    <style>
        /* Collapse 애니메이션 제거 (즉시 토글) */
        .collapse, .collapsing {
            transition: none !important;
        }

        /* === Select2를 Bootstrap .form-control-sm와 동일하게 맞춤 === */
        :root {
            --ctrl-h-sm: 38px; /* form-control-sm 높이 */
            --ctrl-py-sm: .25rem;
            --ctrl-px-sm: .5rem;
        }

        .select2-container .select2-selection--single {
            min-height: var(--ctrl-h-sm);
            height: var(--ctrl-h-sm);
            padding: var(--ctrl-py-sm) var(--ctrl-px-sm);
            border: 1px solid var(--bs-border-color, #ced4da);
            border-radius: var(--bs-border-radius, .2rem);
            background-color: var(--bs-body-bg, #fff);
            font-size: .875rem; /* form-control-sm */
            line-height: 1.5;
            display: flex;
            align-items: center;
            outline: 0;
        }

        .select2-container--default .select2-selection--single .select2-selection__rendered {
            padding-left: 0 !important;
            margin-left: 0;
            line-height: 1.5;
        }

        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 100%;
            right: .5rem;
            top: 50%;
            transform: translateY(-50%);
        }

        .select2-container--default .select2-selection__placeholder {
            color: var(--bs-secondary-color, #6c757d) !important;
        }

        .select2-container--default .select2-selection--single:focus,
        .select2-container--default.select2-container--focus .select2-selection--single {
            border-color: var(--bs-primary, #0d6efd);
            box-shadow: 0 0 0 .25rem rgba(var(--bs-primary-rgb, 13, 110, 253), .25);
            outline: 0;
        }

        .select2-container--default.select2-container--disabled .select2-selection--single {
            background-color: var(--bs-secondary-bg, #e9ecef);
            opacity: 1;
        }

        /* 드롭다운 디테일(선택) */
        .select2-dropdown {
            border-color: var(--bs-border-color, #ced4da);
            border-radius: .375rem;
            overflow: hidden;
        }

        .select2-results__option {
            font-size: .875rem;
        }

        .select2-search--dropdown .select2-search__field {
            font-size: .875rem;
            padding: .25rem .5rem;
            border-radius: .2rem;
        }

        /* === 유효성 오류 표시 === */
        .select2-container .select2-selection.is-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 .25rem rgba(220, 53, 69, .25) !important;
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<div class="container">
    <c:set var="activeMenu" value="praise"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display:flex; align-items:center; gap:8px; position:relative;">
                직원 칭찬 게시판
            </h2>
        </div>
        <div class="title-info"
             style="border:1px solid #eee; padding:20px; margin-bottom:25px; background-color:#f9f9f9;">
            <div class="d-flex" style="align-items:center;" role="note" aria-label="알림">
    <span class="material-icons me-2"
          style="font-size:22px; line-height:1.5; color:#0a3d62; position:relative; top:0; padding-right: 8px;">notifications</span>
                <p class="mb-0">격려와 응원의 메시지를 남기고, 감사한 마음을 전하세요.</p>
            </div>
        </div>

        <div class="card-body" style="padding:0;">
            <!-- 저장 폼 -->
            <form id="praiseForm" action="<c:url value='/cs/praise/save'/>" method="post">
                <div class="filter-bar mb-3">
                    <!-- 1행: 직원선택 / 제목 / 저장 -->
                    <div class="row g-2 align-items-center">
                        <!-- 직원 선택 -->
                        <div class="col-12 col-md-3">
                            <label for="empSelect" class="form-label mb-1 small d-block">직원</label>
                            <c:choose>
                                <c:when test="${loggedIn}">
                                    <!-- required 추가 -->
                                    <select id="empSelect" name="empId" class="form-select form-select-sm"
                                            required></select>
                                </c:when>
                                <c:otherwise>
                                    <select id="empSelect" class="form-select form-select-sm" disabled></select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 제목 -->
                        <div class="col">
                            <label class="form-label mb-1 small d-block">제목</label>
                            <c:choose>
                                <c:when test="${loggedIn}">
                                    <input type="text" name="title"
                                           class="form-control form-control-sm"
                                           placeholder="제목을 입력해주세요." required/>
                                </c:when>
                                <c:otherwise>
                                    <div class="form-control form-control-sm bg-light text-muted">
                                        로그인 후 이용 가능합니다.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 저장 버튼 -->
                        <div class="col-auto">
                            <label class="form-label mb-1 small d-block">&nbsp;</label>
                            <c:if test="${loggedIn}">
                                <button type="submit" class="btn btn-primary btn-sm"
                                        style="width:92px; background-color:rgba(4,26,47,1);">
                                    저장
                                </button>
                            </c:if>
                        </div>
                    </div>

                    <!-- 2행: 내용 -->
                    <div class="row g-2 mt-2">
                        <div class="col-12">
                            <label class="form-label mb-1 small d-block">내용</label>
                            <c:choose>
                                <c:when test="${loggedIn}">
                                    <textarea name="content" class="form-control"
                                              style="height:200px; resize:none;"
                                              placeholder="내용을 입력해주세요." required></textarea>
                                </c:when>
                                <c:otherwise>
                                    <div class="form-control bg-light text-muted" style="height:200px;">
                                        로그인 후 이용 가능합니다.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </form>

            <!-- 결과 테이블 -->
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0 text-center">
                    <thead>
                    <tr>
                        <th style="width:100px;">번호</th>
                        <th style="width:120px;">직원명</th>
                        <th>제목</th>
                        <th style="width:120px;">작성자</th>
                        <th style="width:150px;">작성일</th>
                    </tr>
                    </thead>
                    <tbody id="praiseAccordion">
                    <c:forEach var="post" items="${articlePage.content}" varStatus="st">
                        <!-- 클릭 가능한 요약 행 -->
                        <tr class="accordion-trigger"
                            data-bs-target="#detail-${post.praiseId}"
                            style="cursor:pointer;">
                            <td>
                                    ${articlePage.total
                                            - ((articlePage.currentPage - 1) * articlePage.size)
                                            - (st.count - 1)}
                            </td>
                            <td>${post.empName}</td>
                            <td class="text-start fw-medium text-truncate" style="max-width:300px;">
                                    ${post.title}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty post.userName}">
                                        <c:out value="${post.maskedUserName}"/>
                                    </c:when>
                                    <c:otherwise>이름없음</c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${post.createdAt}" pattern="yyyy.MM.dd"/></td>
                        </tr>

                        <!-- 상세 내용 행 -->
                        <tr id="detail-${post.praiseId}" class="collapse" data-bs-parent="#praiseAccordion">
                            <td colspan="5" class="bg-light text-start">
                                <div class="p-3" style="word-break:break-all;">
                                        ${post.content}
                                    <c:if test="${pageContext.request.isUserInRole('ROLE_ADMIN') or pageContext.request.userPrincipal.name == post.userId}">
                                        <div class="text-end mt-3">
                                            <form action="<c:url value='/cs/praise/delete'/>" method="post"
                                                  class="d-inline">
                                                <input type="hidden" name="praiseId" value="${post.praiseId}"/>
                                                <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                                            </form>
                                        </div>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty articlePage.content}">
                        <tr>
                            <td colspan="5">등록된 칭찬글이 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <!-- 페이징 -->
            <div class="position-relative mt-4">
                <nav class="d-flex justify-content-center">
                    <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                </nav>
            </div>
        </div>
    </main>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- (중요) jQuery를 조건부 로드: top.jsp에서 이미 있으면 건너뜀 -->
<script>
    if (!window.jQuery) {
        document.write('<script src="https://code.jquery.com/jquery-3.6.0.min.js"><\\/script>');
    }
</script>

<!-- Select2 JS (항상 최종 jQuery 이후) -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    // JSP boolean을 JS boolean으로 안전하게 주입
    const isLoggedIn = ${loggedIn ? 'true' : 'false'};

    // 직원 자동완성 (Select2 + AJAX)
    (function () {
        if (!isLoggedIn) return;

        if (!window.jQuery || !jQuery.fn || !jQuery.fn.select2) {
            console.error("Select2가 로드되지 않았습니다 (jQuery 중복 또는 로드 순서 문제).");
            return;
        }

        jQuery(function ($) {
            $("#empSelect").prop("disabled", false).select2({
                placeholder: "직원 검색",
                allowClear: true,
                width: "100%",           // 제목 입력과 폭 일치
                minimumInputLength: 1,
                dropdownParent: $(document.body),
                language: {
                    inputTooShort: function () {
                        return "한 글자 이상 입력하세요";
                    },
                    searching: function () {
                        return "검색 중…";
                    },
                    noResults: function () {
                        return "검색 결과가 없어요";
                    }
                },
                ajax: {
                    url: "<c:url value='/cs/praise/emp-search'/>",
                    dataType: "json",
                    delay: 200,
                    data: function (params) {
                        return {q: params.term || "", limit: 20};
                    },
                    processResults: function (data) {
                        if (Array.isArray(data)) return {results: data};
                        if (data && data.results) return {results: data.results};
                        return {results: []};
                    },
                    cache: true
                },
                templateResult: function (item) {
                    return item.text;
                },
                templateSelection: function (item) {
                    return item.text || item.id;
                }
            });
        });
    })();

    // 표 행 클릭으로 상세 토글
    document.addEventListener("DOMContentLoaded", function () {
        const rows = document.querySelectorAll("#praiseAccordion .accordion-trigger");
        rows.forEach(function (tr) {
            tr.addEventListener("click", function () {
                const targetSel = this.getAttribute("data-bs-target");
                const targetEl = document.querySelector(targetSel);
                if (!targetEl) return;
                const c = bootstrap.Collapse.getOrCreateInstance(targetEl);
                c.toggle();
            });
        });
    });

    // ===== 직원 미선택 시 제출 막고 메시지 출력 =====
    document.addEventListener('DOMContentLoaded', function () {
        const form = document.getElementById('praiseForm');
        if (!form || !isLoggedIn) return;

        const $ = window.jQuery;
        const $emp = $ ? $('#empSelect') : null;

        // 값 변경 시 에러 해제
        if ($emp) {
            $emp.on('change', function () {
                const $s2 = $emp.next('.select2');
                $s2.find('.select2-selection').removeClass('is-invalid');
                if ($s2.next('.invalid-feedback').length) {
                    $s2.next('.invalid-feedback').remove();
                }
            });
        }

        form.addEventListener('submit', function (e) {
            if ($emp) {
                const val = $emp.val();
                if (!val) {
                    e.preventDefault();

                    const $s2 = $emp.next('.select2');
                    $s2.find('.select2-selection').addClass('is-invalid');
                    if (!$s2.next('.invalid-feedback').length) {
                        $s2.after('<div class="invalid-feedback d-block">직원을 입력해주세요.</div>');
                    }

                    try {
                        $emp.select2('open');
                    } catch (_) {
                    }
                }
            }
        });
    });
</script>
</body>
</html>
