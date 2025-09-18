<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>MAPTRIX</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <!-- 공용 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>

    <!-- 페이지 전용 스타일 (폭 1200px 제한 + 옵션 한 줄 + 버튼 정렬 + legend 위로) -->
    <style>
        .page-container {
            width: 100%;
            max-width: 1200px;
            margin: 54px auto;
            background: #fff;
            border-radius: 10px;
            padding: 0 24px 32px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .04);
        }

        main.content-wrapper {
            width: 100%;
        }

        .page-header {
            text-align: center;
            margin: 20px 0 6px; /* 위쪽 여백 + 제목과 문구 간격 */
        }

        .page-header h1,
        .page-header h2 {
            margin: 0;
            font-size: 32px;
            font-weight: 800;
            color: #0056b3;
        }

        .note-text {
            text-align: center;
            margin: 0 0 20px; /* 제목 바로 붙고, 아래는 띄움 */
            padding-bottom: 10px; /* 밑줄과 문구 사이 간격 */
            font-size: 15px;
            color: #666;
            border-bottom: 1px solid #eee;
        }

        .progress-bar-container {
            margin: 20px 0 30px; /* 문구와 간격, 아래쪽 여백 */
        }

        .questions-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 18px;
        }

        /* 문항 그룹: legend를 카드 위로 분리 */
        .question-group {
            border: none; /* 기본 fieldset 테두리 제거 */
            padding: 0; /* 내부 패딩 제거 */
            margin: 0;
        }

        .q-legend {
            display: block;
            margin: 0 0 8px; /* 제목과 카드 사이 간격 */
            color: #333;
            font-size: 18px;
            font-weight: 700;
            padding: 0;
        }

        .q-legend .q-idx {
            color: #0056b3;
            margin-right: 4px;
        }

        /* 실제 카드(테두리/배경/패딩) */
        .q-card {
            background: #f9f9f9;
            border: 1px solid #eee;
            border-radius: 10px;
            padding: 18px;
        }

        /* 포커스 들어오면 카드에 아웃라인 */
        .question-group:focus-within .q-card {
            outline: 2px solid #8ab4f8;
            outline-offset: 2px;
        }

        /* 보기(라디오) — 한 줄 고정 + 가로 스크롤 */
        .options {
            display: flex;
            flex-wrap: nowrap;
            align-items: center;
            gap: 0 14px;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .options::-webkit-scrollbar {
            height: 8px;
        }

        .options::-webkit-scrollbar-thumb {
            background: #d0d7e2;
            border-radius: 999px;
        }

        .options::-webkit-scrollbar-track {
            background: transparent;
        }

        .options label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            cursor: pointer;
            padding: 8px 10px;
            border-radius: 8px;
            transition: background .15s ease;
            white-space: nowrap;
            flex: 0 0 auto;
        }

        .options label:hover {
            background: #f1f5ff;
        }

        .options input[type="radio"] {
            width: 18px;
            height: 18px;
            transform: scale(1.15);
            margin: 0;
        }

        .options input[type="radio"]:checked {
            transform: scale(1.25);
        }

        /* 버튼 영역: 두 버튼 나란히 */
        .button-container {
            display: inline-flex;
            gap: 12px;
            justify-content: center;
            align-items: center;
            margin: 28px 0 10px;
        }

        .button-container button,
        .button-container .btn {
            padding: 12px 28px;
            border-radius: 28px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s ease, transform .2s ease, box-shadow .2s ease, color .2s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, .12);
        }

        .btn-primary {
            background: #007bff;
            color: #fff;
            border: 0;
        }

        .btn-primary:hover {
            background: #0056b3;
            transform: translateY(-1px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, .22);
        }

        .btn-outline {
            background: #fff;
            color: #007bff;
            border: 1px solid #007bff;
        }

        .btn-outline:hover {
            background: #e6f0ff;
        }

        @media (max-width: 576px) {
            .page-header h1 {
                font-size: 26px;
            }

            .button-container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<div id="wrap">
    <!-- 전역 상단 -->
    <jsp:include page="/WEB-INF/views/include/top.jsp"/>

    <!-- ✅ 폭 1200px 제한된 페이지 컨테이너 -->
    <div class="page-container">
        <main role="main" class="content-wrapper">

            <!-- ===== 상단 헤더 (test) ===== -->
            <div style="text-align:center; margin:7px 0 6px;">
                <h1 style="margin:0; font-size:32px; font-weight:800; color:#0056b3;">
                    창업 역량 테스트
                </h1>
            </div>

            <p style="text-align:center; margin:0 0 20px; padding-bottom:10px;
		          font-size:15px; color:#666; border-bottom:1px solid #eee;">
                총 ${questionMap.size()}개 문항을 통해 당신의 창업 역량 유형을 진단합니다.
            </p>
            <div>
                <div style="margin:20px 0 30px;">
                    <div style="display:flex; justify-content:center;">
                        <jsp:include page="/WEB-INF/views/startup/test/testProgressBar.jsp">
                            <jsp:param name="step" value="2"/>
                        </jsp:include>
                    </div>
                </div>
            </div>
            <!-- ===== /상단 헤더 ===== -->


            <!-- 설문 폼 -->
            <form id="quizForm" action="${pageContext.request.contextPath}/start-up/test/submit" method="post"
                  data-total="${questionMap.size()}">
                <div class="questions-grid">
                    <c:forEach items="${questionMap}" var="entry" varStatus="status">
                        <c:set var="question" value="${entry.key}"/>
                        <c:set var="options" value="${entry.value}"/>

                        <fieldset class="question-group">
                            <legend class="q-legend">
                                <span class="q-idx">${status.count}.</span>
                                <span class="q-text">${question.questionText}</span>
                            </legend>

                            <!-- 실제 카드 -->
                            <div class="q-card">
                                <div class="options">
                                    <c:forEach items="${options}" var="option">
                                        <label style="margin-bottom: 0;">
                                            <input type="radio"
                                                   name="q_${question.questionId}"
                                                   value="${option.optionId}"
                                                   required/>
                                            <span>${option.optionText}</span>
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </fieldset>
                    </c:forEach>

                    <!-- 버튼 묶음: 랜덤 일괄선택 + 제출 -->
                    <div class="button-container">
                        <button type="button" id="btnRandomPick" class="btn btn-outline">일괄선택</button>
                        <button type="submit" class="btn btn-primary">결과 보기</button>
                    </div>
                </div>
            </form>
        </main>
    </div>

    <!-- 전역 하단 -->
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</div>

<script>
    (function () {
        const form = document.getElementById('quizForm');
        const total = Number(form.dataset.total || 0);

        // 제출 전 검증
        form.addEventListener('submit', function (e) {
            const checked = form.querySelectorAll('input[type="radio"]:checked').length;
            if (checked < total) {
                e.preventDefault();
                const groups = Array.from(form.querySelectorAll('.question-group'));
                const firstUnanswered = groups.find(g => !g.querySelector('input[type="radio"]:checked'));
                if (firstUnanswered) {
                    firstUnanswered.scrollIntoView({behavior: 'smooth', block: 'center'});
                }
                alert('모든 문항에 답변해주세요.');
            }
        });

        // ✅ 랜덤 일괄선택(20)
        document.getElementById('btnRandomPick').addEventListener('click', function () {
            const groups = Array.from(form.querySelectorAll('.question-group'));
            if (groups.length === 0) return;

            // 셔플
            const shuffle = (arr) => {
                for (let i = arr.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [arr[i], arr[j]] = [arr[j], arr[i]];
                }
                return arr;
            };

            const targetCount = Math.min(20, groups.length);
            const chosen = shuffle(groups.slice()).slice(0, targetCount);

            chosen.forEach(group => {
                const radios = Array.from(group.querySelectorAll('input[type="radio"]'));
                if (!radios.length) return;
                const name = radios[0].name;
                form.querySelectorAll(`input[name="${name}"]`).forEach(r => r.checked = false);
                const pick = radios[Math.floor(Math.random() * radios.length)];
                pick.checked = true;
            });
        });
    })();
</script>
</body>
</html>
