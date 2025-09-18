<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${apiService.apiNameKr}"/> 서비스 신청</title>

    <!-- Vendor & Common -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">

    <style>
        /* 페이지 헤더 톤 맞춤 */
        .page-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 6px 0 12px 0;
        }

        .page-header p {
            margin: 0;
            color: #6c757d;
        }

        /* 카드 */
        .form-card {
            border: 1px solid #eee;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 2px 12px rgba(0, 0, 0, .04);
            overflow: hidden;
        }

        .form-card .card-header {
            background: #fafafa;
            border-bottom: 1px solid #f0f0f0;
            padding: 14px 18px;
        }

        .form-card .card-body {
            padding: 18px;
        }

        /* 라벨/도움말 */
        .form-label {
            font-weight: 600;
        }

        .help-text {
            color: #6c757d;
            font-size: .9rem;
        }

        /* 카운터 / 버튼 영역 */
        .count-wrap {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .char-counter {
            font-size: .9rem;
            color: #6c757d;
        }

        .btn-area {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 18px;
        }

        /* 플로팅 텍스트에어리어 (부트스트랩 호환) */
        .form-floating > textarea {
            min-height: 180px;
        }

        @media (min-width: 992px) {
            .form-floating > textarea {
                min-height: 240px;
            }
        }

        /* 요약 배지 */
        .badge-cat {
            font-weight: 500;
        }

        /* 에러 메시지 톤 */
        .invalid-feedback {
            display: block;
        }

        #purposeDesc {
            height: 300px; /* 높이 고정 */
            max-height: 300px; /* 최대 높이도 300px */
            resize: none; /* 크기 조절 비활성화 */
        }
    </style>
</head>

<body>
<div class="container">
    <c:set var="activeMenu" value="openapi"/>
    <c:set var="activeSub" value="list"/>
    <%@ include file="/WEB-INF/views/include/openapiSideBar.jsp" %>

    <main>
        <!-- 페이지 타이틀 -->
        <div class="page-header">
            <h2>
                <span class="material-icons" style="font-size:28px;">assignment</span>
                '<c:out value="${apiService.apiNameKr}"/>' 서비스 신청
            </h2>
            <p>API 활용 목적을 기재하여 제출해 주세요. 관리자가 확인 후 승인 처리됩니다.</p>
        </div>

        <!-- 신청 폼 -->
        <div class="form-card">
            <div class="card-header">
                <strong>신청 정보 입력</strong>
            </div>
            <div class="card-body">
                <form name="applyForm" action="<c:url value='/openapi/apply'/>" method="post" id="applyForm" novalidate>
                    <!-- 컨트롤러로 apiId 전달 -->
                    <input type="hidden" name="apiId" value="${apiService.apiId}"/>

                    <!-- 활용 목적 -->
                    <div class="mb-3">
                        <label for="purposeDesc" class="form-label">활용 목적 <span class="text-danger">*</span></label>
                        <div class="form-floating">
              <textarea class="form-control" id="purposeDesc" name="purposeDesc"
                        placeholder="API 활용 목적을 자세히 기재해주세요."
                        maxlength="1000" required></textarea>
                            <label for="purposeDesc">예: 졸업 작품 프로젝트의 상권 분석 데이터로 활용</label>
                        </div>
                        <div class="count-wrap mt-1">
                            <small class="help-text">프로젝트 개요, 사용 범위(내부/외부 배포), 예상 호출량 등을 포함해 주세요.</small>
                            <div class="char-counter"><span id="curCount">0</span>/<span id="maxCount">1000</span></div>
                        </div>
                        <div class="invalid-feedback" id="purposeError" style="display:none;">
                            활용 목적을 10자 이상 입력해 주세요.
                        </div>
                    </div>

                    <!-- 약관 동의 (선택 또는 필수로 변경 가능) -->
                    <div class="mb-2 form-check">
                        <input class="form-check-input" type="checkbox" value="Y" id="agree" checked>
                        <label class="form-check-label" for="agree">
                            본 서비스의 <a href="<c:url value='/policy/api-terms'/>" target="_blank">이용 약관</a>을 확인했습니다.
                        </label>
                    </div>

                    <!-- 버튼 -->
                    <div class="btn-area">
                        <a href="<c:url value='/openapi/detail'/>?apiId=${apiService.apiId}"
                           class="btn btn-outline-secondary">
                            취소
                        </a>
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            제출하기
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        const textarea = document.getElementById('purposeDesc');
        const cur = document.getElementById('curCount');
        const max = document.getElementById('maxCount');
        const err = document.getElementById('purposeError');
        const form = document.getElementById('applyForm');
        const submitBtn = document.getElementById('submitBtn');
        const agree = document.getElementById('agree');

        // 초기값
        max.textContent = textarea.getAttribute('maxlength') || '1000';

        // 글자수 카운터
        const updateCount = () => {
            const len = (textarea.value || '').trim().length;
            cur.textContent = len;
        };
        textarea.addEventListener('input', updateCount);
        updateCount();

        // 간단 유효성 검사
        form.addEventListener('submit', function (e) {
            const text = (textarea.value || '').trim();
            let valid = true;

            // 최소 글자수 예: 10자
            if (text.length < 10) {
                err.style.display = 'block';
                textarea.classList.add('is-invalid');
                valid = false;
            } else {
                err.style.display = 'none';
                textarea.classList.remove('is-invalid');
            }

            // 약관 확인 (선택적으로 필수 처리)
            if (!agree.checked) {
                if (!confirm('이용 약관 확인 없이 계속 진행하시겠습니까?')) {
                    valid = false;
                }
            }

            if (!valid) {
                e.preventDefault();
                e.stopPropagation();
                return;
            }

            // 전송 확인
            const ok = confirm('해당 내용으로 신청서를 제출하시겠습니까?');
            if (!ok) {
                e.preventDefault();
                e.stopPropagation();
            } else {
                submitBtn.disabled = true; // 중복 제출 방지
            }
        });
    })();
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
