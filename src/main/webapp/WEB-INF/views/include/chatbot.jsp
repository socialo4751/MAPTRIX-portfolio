<%@ page contentType="text/html; charset=UTF-8" %>

<%-- 챗봇 & 모달 스타일 --%>
<style>
    /* ... (기존 챗봇 아이콘, 말풍선, 애니메이션 스타일) ... */
    .chatbot-container {
        position: fixed;
        bottom: 30px;
        right: 30px;
        z-index: 1000;
        cursor: pointer;
    }
    .chatbot-button {
        position: relative;
        background: transparent;
        border: none;
        padding: 0;
        animation: floatAnimation 3s ease-in-out infinite;
    }
    .chatbot-button img {
        width: 150px;
        height: auto;
        filter: drop-shadow(0 4px 12px rgba(37, 99, 235, 0.3));
        transition: transform 0.2s ease;
    }
    .chatbot-button:hover img {
        transform: scale(1.1);
    }
    .chatbot-bubble {
        position: absolute;
        bottom: 50%;
        right: 105px;
        transform: translateY(50%);
        background-color: #0f172a;
        color: #fff;
        padding: 12px 16px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 600;
        width: max-content;
        box-shadow: 0 6px 20px rgba(10, 20, 30, 0.15);
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.2s ease, transform 0.2s ease;
        white-space: nowrap;
    }
    .chatbot-container:hover .chatbot-bubble {
        opacity: 1;
        visibility: visible;
    }
    @keyframes floatAnimation {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
    }
    
    /* =================================
       모달 스타일
    ================================= */
    .modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: transparent;
        z-index: 1999;
    }
    .modal-window {
        display: none;
        position: fixed;
        bottom: 30px;
        right: calc(30px + 90px + 15px);
        z-index: 2000;
        background-color: #fff;
        border-radius: 16px;
        box-shadow: 0 10px 30px rgba(10, 20, 30, 0.15);
        width: 90%;
        max-width: 450px;
        animation: modalAppear 0.3s ease-out;
        transform-origin: bottom right;
        display: none;
        flex-direction: column;
        height: 650px; /* 챗봇창 높이 지정 */
    }
    @keyframes modalAppear {
        from {
            opacity: 0;
            transform: scale(0.9) translateY(10px);
        }
        to {
            opacity: 1;
            transform: scale(1) translateY(0);
        }
    }
    .modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid #e7eaf0;
        padding: 16px 20px;
        flex-shrink: 0;
    }
    .modal-header h2 {
        font-size: 18px;
        font-weight: 700;
        color: #12151c;
        margin: 0;
    }
    .btn-close {
        background: transparent;
        border: none;
        font-size: 24px;
        line-height: 1;
        cursor: pointer;
        color: #5d6470;
        padding: 4px 8px;
    }
    
    /* =================================
       채팅 UI 스타일
    ================================= */
    .chat-messages {
        flex-grow: 1;
        overflow-y: auto;
        padding: 20px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }
    .chat-bubble {
        padding: 10px 14px;
        border-radius: 18px;
        max-width: 80%;
        line-height: 1.5;
    }
    .bot-message {
        background-color: #f1f5f9;
        color: #1e293b;
        border-bottom-left-radius: 4px;
        align-self: flex-start;
    }
    /* ▼▼▼ [CSS 수정] 예시 질문 링크 스타일 추가 ▼▼▼ */
    .bot-message .example-question {
        color: #2563eb;
        text-decoration: underline;
        cursor: pointer;
    }
    .bot-message .example-question:hover {
        color: #1d4ed8;
        font-weight: 600;
    }
    /* ▲▲▲ [CSS 수정] 예시 질문 링크 스타일 추가 ▲▲▲ */
    
    .user-message {
        background-color: #2563eb;
        color: #fff;
        border-bottom-right-radius: 4px;
        align-self: flex-end;
    }
    .typing-indicator {
        display: flex;
        align-items: center;
        gap: 4px;
        padding: 10px 14px;
        align-self: flex-start;
    }
    .typing-indicator span {
        width: 8px;
        height: 8px;
        background-color: #94a3b8;
        border-radius: 50%;
        animation: typing 1.2s infinite ease-in-out;
    }
    .typing-indicator span:nth-child(2) { animation-delay: 0.2s; }
    .typing-indicator span:nth-child(3) { animation-delay: 0.4s; }
    @keyframes typing {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-5px); }
    }
    
    .chat-input-form {
        display: flex;
        gap: 8px;
        padding: 16px 20px;
        border-top: 1px solid #e7eaf0;
        flex-shrink: 0;
    }
    .chat-input-form input {
        flex-grow: 1;
        border: 1px solid #cbd5e1;
        border-radius: 999px;
        padding: 10px 16px;
        font-size: 15px;
        outline: none;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .chat-input-form input:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }
    .chat-input-form button {
        border: none;
        background-color: #2563eb;
        color: #fff;
        font-weight: 600;
        border-radius: 999px;
        padding: 10px 16px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .chat-input-form button:hover {
        background-color: #1d4ed8;
    }
    .chat-input-form button:disabled {
        background-color: #94a3b8;
        cursor: not-allowed;
    }
</style>

<%-- 챗봇 아이콘 HTML --%>
<div class="chatbot-container">
    <button type="button" class="chatbot-button" title="챗봇 열기" onclick="openChatbot();">
        <img src="${pageContext.request.contextPath}/images/common/chatbot_icon1.png" alt="챗봇 아이콘">
    </button>
    <div class="chatbot-bubble">
        궁금한 점이 있으신가요?
    </div>
</div>

<%-- 모달 HTML (채팅 UI로 변경) --%>
<div id="chatbotModalOverlay" class="modal-overlay"></div>
<div id="chatbotModalWindow" class="modal-window">
    <div class="modal-header">
        <h2>무엇을 도와드릴까요?</h2>
        <button type="button" class="btn-close" title="닫기" onclick="closeChatbotModal();">&times;</button>
    </div>
    
    <div class="chat-messages" id="chatMessages">
        <div class="chat-bubble bot-message">
            안녕하세요! 대전 상권 분석 도우미입니다. <br>
            궁금한 점을 입력해주세요.<br>
            <br><br>
            예시질문 태그 클릭<br>
			<a href="javascript:void(0);" class="example-question">창업 관련 지원사업에 대해 알고 싶어.</a><br>
			<a href="javascript:void(0);" class="example-question">오류동 음식점 상권은 어때?</a><br>
        </div>
    </div>
    
    <form class="chat-input-form" id="chatForm">
        <input type="text" id="chatInput" placeholder="여기에 질문을 입력하세요..." autocomplete="off">
        <button type="submit" id="chatSubmitBtn">전송</button>
    </form>
</div>

<script>
    const chatbotModalOverlay = document.getElementById('chatbotModalOverlay');
    const chatbotModalWindow = document.getElementById('chatbotModalWindow');
    const chatMessages = document.getElementById('chatMessages');
    const chatForm = document.getElementById('chatForm');
    const chatInput = document.getElementById('chatInput');
    const chatSubmitBtn = document.getElementById('chatSubmitBtn');

    function openChatbot() {
        if (chatbotModalOverlay) chatbotModalOverlay.style.display = 'block';
        if (chatbotModalWindow) chatbotModalWindow.style.display = 'flex';
    }

    function closeChatbotModal() {
        if (chatbotModalOverlay) chatbotModalOverlay.style.display = 'none';
        if (chatbotModalWindow) chatbotModalWindow.style.display = 'none';
    }

    if (chatbotModalOverlay) {
        chatbotModalOverlay.addEventListener('click', closeChatbotModal);
    }
    
    // 폼 제출 이벤트 처리 수정
    // 입력창에서 직접 입력 후 전송하는 경우
    chatForm.addEventListener('submit', function(event) {
        event.preventDefault(); // 폼 기본 동작(새로고침) 방지
        const question = chatInput.value.trim();
        submitQuestion(question); // 분리된 함수 호출
    });
    
    // ▼▼▼ [JS 추가] 예시 질문 클릭 이벤트 처리 ▼▼▼
    document.querySelectorAll('.example-question').forEach(item => {
        item.addEventListener('click', function() {
            const question = this.textContent; // 클릭된 a 태그의 텍스트를 가져옴
            submitQuestion(question); // 분리된 함수 호출
        });
    });

    /**
     * 질문을 서버로 전송하고 응답을 처리하는 로직을 별도 함수로 분리
     * @param {string} question - 사용자 질문
     */
    async function submitQuestion(question) {
        if (!question) return; // 입력 내용이 없으면 중단
        
        // 1. 사용자 메시지 화면에 표시
        appendMessage(question, 'user');
        chatInput.value = ''; // 입력창 비우기
        
        // 2. 로딩 인디케이터 표시 및 전송 버튼 비활성화
        showLoadingIndicator();
        chatSubmitBtn.disabled = true;

        try {
            // 3. 서버 API로 질문 전송
            const response = await fetch('${pageContext.request.contextPath}/api/chatbot/ask', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ question: question })
            });

            if (!response.ok) {
                throw new Error('서버 응답 오류: ' + response.status);
            }

            const data = await response.json();
            
            // 4. 챗봇 답변 화면에 표시
            appendMessage(data.answer, 'bot');

        } catch (error) {
            console.error('챗봇 API 요청 실패:', error);
            appendMessage('죄송합니다. 답변을 가져오는 중 문제가 발생했습니다.', 'bot');
        } finally {
            // 5. 로딩 인디케이터 제거 및 전송 버튼 활성화
            hideLoadingIndicator();
            chatSubmitBtn.disabled = false;
            chatInput.focus(); // 다시 입력창에 포커스
        }
    }
    
    function appendMessage(text, sender) {
        const messageDiv = document.createElement('div');
        messageDiv.classList.add('chat-bubble', sender + '-message');
        messageDiv.innerHTML = text.replace(/\n/g, '<br>');
        chatMessages.appendChild(messageDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function showLoadingIndicator() {
        const indicatorDiv = document.createElement('div');
        indicatorDiv.id = 'loadingIndicator';
        indicatorDiv.classList.add('typing-indicator');
        indicatorDiv.innerHTML = '<span></span><span></span><span></span>';
        chatMessages.appendChild(indicatorDiv);
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    function hideLoadingIndicator() {
        const indicator = document.getElementById('loadingIndicator');
        if (indicator) {
            indicator.remove();
        }
    }
</script>