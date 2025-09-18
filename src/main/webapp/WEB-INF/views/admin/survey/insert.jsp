<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>설문 조사 등록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
    <style>
        .question-group {
            transition: background-color 0.2s ease-in-out;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>


<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">
            <!-- ✅ 페이지 헤더 -->
            <div class="admin-header mb-4" style="margin-top: 60px;">
                <h2><i class="bi bi-bar-chart-line me-2 text-primary"></i> 설문 조사 등록</h2>
                <p>설문 조사를 등록하고 문항을 설정할 수 있습니다.</p>
            </div>

            <!-- ✅ 등록 폼 -->
            <form method="post" action="${pageContext.request.contextPath}/admin/survey/insert" class="needs-validation" novalidate>
                <div class="mb-3">
                    <label for="surveyTitle" class="form-label fw-semibold">조사명</label>
                    <input type="text" class="form-control" id="surveyTitle" name="surveyTitle" placeholder="예: 서비스 만족도 조사" required>
                    <div class="invalid-feedback">조사명을 입력해주세요.</div>
                </div>

                <div class="mb-3">
                    <label for="surveyDescription" class="form-label fw-semibold">설명</label>
                    <textarea class="form-control" id="surveyDescription" name="surveyDescription" rows="4" placeholder="조사 설명"></textarea>
                </div>

                <div id="question-wrapper"></div>
                <button type="button" class="btn btn-outline-primary btn-sm mb-3" onclick="addQuestion()">
                    <i class="bi bi-plus-circle"></i> 문항 추가
                </button>

                <div class="mb-3">
                    <label class="form-label fw-semibold">사용 여부</label>
                    <div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="useYn" id="useY" value="Y" checked>
                            <label class="form-check-label" for="useY">진행</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="useYn" id="useN" value="N">
                            <label class="form-check-label" for="useN">마감</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-end mt-4">
                    <a href="${pageContext.request.contextPath}/admin/survey/list" class="btn btn-secondary me-2">목록</a>
                    <button type="submit" class="btn btn-primary">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- ✅ 문항 관련 스크립트 -->
<script>
    let questionCount = 0;

    function addQuestion() {
        const wrapper = document.getElementById("question-wrapper");
        const idx = questionCount;
        const html = `
            <div class="mb-4 question-group border p-3 rounded bg-white position-relative">
                <button type="button" class="btn-close position-absolute top-0 end-0 m-2" onclick="removeQuestion(this)"></button>
                <div class="mb-3">
                    <label class="form-label fw-bold">문항</label>
                    <input type="text" class="form-control"
                           name="questions[\${idx}].questionText"
                           placeholder="질문 내용을 입력하세요" required>
                </div>
                <div class="option-wrapper">
                    <div class="input-group mb-2 option-item">
                        <span class="input-group-text">선택지</span>
                        <input type="text" class="form-control"
                               name="questions[\${idx}].options[0].optionText"
                               placeholder="선택지 내용" required>
                        <input type="number" class="form-control"
                               name="questions[\${idx}].options[0].optionValue"
                               placeholder="점수" required>
                        <button type="button" class="btn btn-outline-danger" onclick="removeOption(this)">
                            <i class="bi bi-x"></i>
                        </button>
                    </div>
                    <div class="input-group mb-2 option-item">
                        <span class="input-group-text">선택지</span>
                        <input type="text" class="form-control"
                               name="questions[\${idx}].options[1].optionText"
                               placeholder="선택지 내용" required>
                        <input type="number" class="form-control"
                               name="questions[\${idx}].options[1].optionValue"
                               placeholder="점수" required>
                        <button type="button" class="btn btn-outline-danger" onclick="removeOption(this)">
                            <i class="bi bi-x"></i>
                        </button>
                    </div>
                </div>
                <button type="button" class="btn btn-outline-secondary btn-sm mt-2" onclick="addOption(this, \${idx})">
                    <i class="bi bi-plus-circle"></i> 선택지 추가
                </button>
            </div>`;
        wrapper.insertAdjacentHTML("beforeend", html);
        questionCount++;
    }

    function removeQuestion(btn) {
        btn.closest(".question-group").remove();
        questionCount--;
    }

    function addOption(btn, qIdx) {
        const wrapper = btn.closest(".question-group").querySelector(".option-wrapper");
        const optIdx = wrapper.querySelectorAll(".option-item").length;
        const html = `
            <div class="input-group mb-2 option-item">
                <span class="input-group-text">선택지</span>
                <input type="text" class="form-control"
                       name="questions[\${qIdx}].options[\${optIdx}].optionText"
                       placeholder="선택지 내용" required>
                <input type="number" class="form-control"
                       name="questions[\${qIdx}].options[\${optIdx}].optionValue"
                       placeholder="점수" required>
                <button type="button" class="btn btn-outline-danger" onclick="removeOption(this)">
                    <i class="bi bi-x"></i>
                </button>
            </div>`;
        wrapper.insertAdjacentHTML("beforeend", html);
    }

    function removeOption(btn) {
        btn.closest(".option-item").remove();
    }
</script>

<!-- ✅ 유효성 검사 -->
<script>
    (() => {
        'use strict';
        const forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms).forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
