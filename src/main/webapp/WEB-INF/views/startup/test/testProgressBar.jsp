<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--   여러 JSP 페이지에 포함될 진행바 컴포넌트 (일반 .jsp 파일)
       각 페이지 상단에 다음 코드를 추가하여 포함				--%>

<style>
    .progress-bar-container {
        display: flex;
        justify-content: space-between;
        align-items: flex-start; /* 텍스트가 아래로 늘어날 때도 정렬 유지 */
        width: 100%;
        max-width: 800px;
        margin: 30px auto;
        position: relative;
        padding: 20px 0;
    }


    .progress-step {
        flex: 1;
        text-align: center;
        position: relative;
        z-index: 2;
        display: flex;
        flex-direction: column;
        align-items: center;
        color: #777;
        font-weight: bold;
        transition: color 0.3s ease;
    }

    /* 각 스텝 뒤에 연결 선 추가 */
	.progress-step:not(:last-child)::after {
	  content: '';
	  position: absolute;
	  top: 20px;
	  left: calc(50% + 20px);  /* 선이 오른쪽으로 가도록 */
	  width: calc(100% - 40px); /* 고정된 선 길이 */
	  height: 4px;
	  background-color: #ddd;
	  z-index: 1;
	}

    /* 완료된 스텝의 연결 선 색상 변경 */
    .progress-step.completed:not(:last-child)::after {
        background-color: #9CCC9D; /* 완료된 선 색상 */
    }

    .progress-step .circle {
        width: 40px;
        height: 40px;
        background-color: #ccc;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 8px;
        transition: background-color 0.3s ease;
        position: relative; /* z-index가 적용되도록 */
        z-index: 3; /* 선보다 위에 오도록 */
    }

    .progress-step.completed .circle {
        background-color: #A5D6A7;
    }

    .progress-step.active .circle {
        background-color: #4CAF50;
    }

    .progress-step.completed {
        color: #4CAF50;
    }

    .progress-step.active {
        color: #2E7D32;
    }

    /* 작은 화면을 위한 반응형 */
    @media (max-width: 768px) {
        .progress-bar-container {
            padding: 10px 0;
        }
        .progress-step .circle {
            width: 32px;
            height: 32px;
            font-size: 1em;
            margin-bottom: 5px;
        }
        .progress-step {
            font-size: 0.8em;
        }
        .progress-step:not(:last-child)::after {
            top: 16px; /* 작은 화면에 맞춰 원의 중간 높이 조정 */
        }
    }
</style>

<%
    int currentStep = 0;
    try {
        currentStep = Integer.parseInt(request.getParameter("step"));
    } catch (NumberFormatException e) {
        currentStep = 0; // 혹은 기본값 설정
    }
%>

<div class="progress-bar-container">
    <div class="progress-step <%= (currentStep >= 1 ? (currentStep == 1 ? "active" : "completed") : "") %>">
        <div class="circle">1</div>
        <span>창업 역량 테스트 소개</span>
    </div>
    <div class="progress-step <%= (currentStep >= 2 ? (currentStep == 2 ? "active" : "completed") : "") %>">
        <div class="circle">2</div>
        <span>테스트 진행</span>
    </div>
    <div class="progress-step <%= (currentStep >= 3 ? (currentStep == 3 ? "active" : "completed") : "") %>">
        <div class="circle">3</div>
        <span>결과 확인</span>
    </div>
</div>