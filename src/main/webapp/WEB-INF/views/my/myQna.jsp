<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 내 Q&A 내역</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>
        /* 마이페이지 레이아웃을 위한 최상위 컨테이너 */
        .mypage-wrapper { /* .container 대신 이 클래스를 사용 */
            display: flex; /* 사이드바와 메인 콘텐츠를 가로로 배치 */
            width: 100%; /* 전체 너비 사용 */
            max-width: 1200px; /* 전체 마이페이지 레이아웃의 최대 너비 */
            margin: 20px auto; /* 중앙 정렬 */
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            overflow: hidden; /* 자식 요소의 둥근 모서리를 위해 */
            flex-grow: 1; /* body 내에서 남은 공간을 차지하도록 */
        }
        /* ------------------------------------------- */

        /* main 태그에 적용될 메인 콘텐츠 스타일 */
        main.main-content { /* main 태그에 직접 .main-content 클래스 적용 */
            flex-grow: 1; /* 사이드바가 차지하고 남은 공간을 모두 차지 */
            padding: 40px; /* 메인 콘텐츠 내부 패딩 */
        }
        
        .mypage-header {
            text-align: center;
            margin-bottom: 40px;
            border-bottom: 1px solid #eee;
            padding-bottom: 20px;
        }
        .mypage-header h2 {
            font-size: 2.5em;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        .mypage-header p {
            font-size: 1.1em;
            color: #7f8c8d;
        }
        .board-section {
            background-color: #fcfcfc;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.03);
        }
        .board-section h3 {
            font-size: 1.8em;
            color: #34495e;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid #3498db;
            display: inline-block;
        }

        .top-actions {
            text-align: right;
            margin-bottom: 20px;
        }
        .top-actions .btn-register {
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.2s ease;
        }
        .top-actions .btn-register:hover {
            background-color: #218838;
        }

        .board-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed;
        }
        .board-table th, .board-table td {
            border: 1px solid #ddd;
            padding: 12px 15px;
            text-align: left;
            vertical-align: middle;
            white-space: normal;
            word-wrap: break-word;
        }

        .board-table td:nth-child(3) { /* Q&A 제목 */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .board-table th {
            background-color: #f2f2f2;
            font-weight: bold;
            color: #555;
        }
        .board-table tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .board-table tr:hover {
            background-color: #f1f1f1;
        }

        /* Column widths - Adjusted for Q&A */
        .board-table th:nth-child(1), .board-table td:nth-child(1) { width: 7%; text-align: center; } /* 번호 */
        .board-table th:nth-child(2), .board-table td:nth-child(2) { width: 12%; text-align: center;} /* 분류 */
        .board-table th:nth-child(3), .board-table td:nth-child(3) { width: 29%; } /* Q&A 제목 */
        .board-table th:nth-child(4), .board-table td:nth-child(4) { width: 13%; text-align: center;} /* 등록일 */
        .board-table td:nth-child(4) { white-space: nowrap; } /* 등록일 한 줄로 */
        .board-table th:nth-child(5), .board-table td:nth-child(5) { width: 13%; text-align: center;} /* 답변여부 */
        .board-table td:nth-child(5) { white-space: nowrap; } /* 답변여부 한 줄로 */
        .board-table th:nth-child(6), .board-table td:nth-child(6) { width: 30%; text-align: center;} /* 관리 (늘린 부분) */


        .board-table .action-buttons {
            display: flex;
            gap: 8px; /* 간격 증가 */
            flex-wrap: nowrap;
            justify-content: center;
            align-items: center;
            height: 100%;
        }
        .board-table .btn-detail,
        .board-table .btn-edit,
        .board-table .btn-delete {
            padding: 8px 12px; /* 패딩 증가 */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85em;
            transition: background-color 0.2s ease, transform 0.1s ease;
            white-space: nowrap;
            flex-shrink: 0;
            min-width: 50px;
        }
        .board-table .btn-detail {
            background-color: #3498db;
            color: white;
        }
        .board-table .btn-detail:hover {
            background-color: #2980b9;
        }
        .board-table .btn-edit {
            background-color: #f39c12;
            color: white;
        }
        .board-table .btn-edit:hover {
            background-color: #e67e22;
        }
        .board-table .btn-delete {
            background-color: #e74c3c;
            color: white;
        }
        .board-table .btn-delete:hover {
            background-color: #c0392b;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-weight: bold;
            font-size: 0.85em;
            text-align: center;
            white-space: nowrap; 
        }
        .status-complete {
            background-color: #d4edda;
            color: #155724;
        }
        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }

        /* Popup Form Styles (for Register/Edit/Detail) */
        .popup-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .popup-content {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            width: 500px;
            max-width: 90%;
            position: relative;
        }
        .popup-content h3 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
            font-size: 1.6em;
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
        }
        .popup-content .form-group {
            margin-bottom: 15px;
        }
        .popup-content label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }
        .popup-content select,
        .popup-content input[type="text"],
        .popup-content textarea {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .popup-content textarea {
            resize: vertical;
            min-height: 120px;
        }
        .popup-content .detail-field {
            padding: 10px;
            border: 1px solid #eee;
            background-color: #f9f9f9;
            border-radius: 5px;
            font-size: 1em;
            color: #444;
            margin-bottom: 15px;
            word-wrap: break-word;
            display: flex; /* flex 컨테이너로 설정 */
            align-items: center; /* 내부 아이템을 세로 중앙 정렬 */
        }

        .popup-content .form-actions {
            text-align: right;
            margin-top: 30px;
        }
        .popup-content .form-actions button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1em;
            margin-left: 10px;
            transition: background-color 0.2s ease;
        }
        .popup-content .btn-submit {
            background-color: #3498db;
            color: white;
        }
        .popup-content .btn-submit:hover {
            background-color: #2980b9;
        }
        .popup-content .btn-cancel {
            background-color: #ccc;
            color: #333;
        }
        .popup-content .btn-cancel:hover {
            background-color: #bbb;
        }
        .popup-content .btn-close-detail {
            background-color: #6c757d;
            color: white;
        }
        .popup-content .btn-close-detail:hover {
            background-color: #5a6268;
        }

        /* Sidebar Styles - Added for consistent layout */
        .sidebar {
            width: 250px;
            background-color: #2c3e50; /* Darker sidebar for contrast */
            color: #ecf0f1;
            padding: 30px 0;
            box-shadow: 2px 0 8px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            align-items: center;
            flex-shrink: 0; /* 사이드바 크기가 줄어들지 않도록 */
        }
        .sidebar h2 {
            color: #ecf0f1;
            margin-bottom: 30px;
            font-size: 1.8em;
            text-align: center;
        }
        .sidebar-menu {
            width: 100%;
        }
        /* <a> 태그를 버튼처럼 보이게 하는 스타일 */
        .sidebar-menu a {
            width: 100%;
            padding: 15px 25px;
            text-align: left;
            background-color: transparent;
            border: none;
            color: #ecf0f1;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease, color 0.3s ease;
            display: flex; /* Flexbox로 아이콘과 텍스트 정렬 */
            align-items: center;
            gap: 10px;
            text-decoration: none; /* 밑줄 제거 */
            box-sizing: border-box; /* 패딩 포함 너비 계산 */
        }
        .sidebar-menu a:hover,
        .sidebar-menu a.active {
            background-color: #34495e; /* Slightly lighter on hover/active */
            color: #ffeaa7; /* Accent color for active state */
        }
        .sidebar-menu a i { /* 폰트 어썸 아이콘 스타일 */
            font-size: 1.2em;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .mypage-wrapper {
                flex-direction: column; /* 작은 화면에서는 수직으로 쌓이도록 */
                margin: 0; /* 마진 없애고 전체 너비 사용 */
                border-radius: 0; /* 둥근 모서리 없애기 */
                box-shadow: none; /* 그림자 없애기 */
            }
            .sidebar {
                width: 100%; /* 사이드바가 전체 너비 차지 */
                padding: 20px 0;
            }
            .sidebar-menu {
                display: flex; /* 메뉴 항목을 가로로 정렬 (스크롤 가능하게 할 수도 있음) */
                flex-wrap: wrap; /* 필요한 경우 줄바꿈 */
                justify-content: center; /* 가운데 정렬 */
                gap: 5px; /* 메뉴 항목 간 간격 */
            }
            .sidebar-menu a {
                padding: 10px 15px; /* 패딩 줄임 */
                font-size: 1em;
                justify-content: center; /* 아이콘과 텍스트 중앙 정렬 */
                width: auto; /* 너비 자동 조정 */
            }
            main.main-content {
                padding: 20px; /* 메인 콘텐츠 패딩 줄임 */
            }

            /* For small screens, adjust table column widths if necessary */
            .board-table th, .board-table td {
                font-size: 0.8em; /* Smaller font size for tables on mobile */
                padding: 6px 8px;
            }
            /* Adjust specific column widths for smaller screens */
            .board-table th:nth-child(1), .board-table td:nth-child(1) { width: 10%; } /* 번호 */
            .board-table th:nth-child(2), .board-table td:nth-child(2) { width: 15%; } /* 분류 */
            .board-table th:nth-child(3), .board-table td:nth-child(3) { width: 20%; } /* Q&A 제목 */
            .board-table th:nth-child(4), .board-table td:nth-child(4) { width: 15%; } /* 등록일 */
            .board-table th:nth-child(5), .board-table td:nth-child(5) { width: 15%; } /* 답변여부 */
            .board-table th:nth-child(6), .board-table td:nth-child(6) { width: 25%; } /* 관리 */

            .board-table .action-buttons {
                flex-direction: column; /* Buttons stack vertically on small screens */
                align-items: stretch; /* Make buttons fill available width */
            }
            .board-table .btn-detail,
            .board-table .btn-edit,
            .board-table .btn-delete {
                min-width: unset; /* Remove min-width to allow shrinking */
                width: 100%; /* Take full width of parent flex item */
            }
            .popup-content {
                padding: 20px;
            }
            .popup-content select,
            .popup-content input[type="text"],
            .popup-content textarea {
                width: calc(100% - 16px); /* Adjust for smaller padding */
                padding: 8px;
            }
            .popup-content .form-actions button {
                padding: 8px 15px;
                font-size: 0.9em;
            }
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
    <!-- 인클루드한 top.jsp 마지막 줄에는 <div> 열기 태그가 달려있음 -->

    <div class="mypage-wrapper"> <aside class="sidebar">
            <h2>마이페이지</h2>
            <nav class="sidebar-menu">
                <%-- JSTL c:url을 사용하여 컨텍스트 패스 문제를 해결하고, 실제 컨트롤러 매핑 경로에 맞게 URL을 수정해주세요. --%>
                <a href="/myPage/profile" class="active"><i class="fas fa-user-circle"></i> 회원정보 관리</a>
	            <a href="/myPage/report"><i class="fas fa-chart-line"></i> 상권분석 내역 조회</a>
	            <a href="/myPage/interior"><i class="fas fa-hammer"></i> 셀프인테리어</a>
	            <a href="/myPage/activity"><i class="fas fa-hammer"></i> 활동 기록</a>
	            <a href="/myPage/favZone"><i class="fas fa-map-marked-alt"></i> 내 관심구역 리스트</a>
	            <a href="/myPage/favStore"><i class="fas fa-store"></i> 내 관심가게 리스트</a>
	            <a href="/myPage/qna"><i class="fas fa-question-circle"></i> 내 Q&A 내역</a>
	            <a href="/myPage/deleteAcc"><i class="fas fa-user-minus"></i> 회원 탈퇴</a>
            </nav>
        </aside>
    <main class="main-content">
        <div class="mypage-header">
            <h2>내 Q&A 내역 ❓</h2>
            <p>자주 묻는 질문을 확인하고 답변을 받아보세요.</p>
        </div>

        <div class="board-section">
            <h3>나의 Q&A 목록</h3>
            <div class="top-actions">
                <button class="btn-register" id="btnRegisterQnA">Q&A 등록</button>
            </div>
            <table class="board-table" id="qnaTable">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>분류</th>
                        <th>질문 제목</th>
                        <th>등록일</th>
                        <th>답변여부</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>3</td>
                        <td>서비스 이용</td>
                        <td>사용자 가이드가 필요합니다.</td>
                        <td>2024.07.12</td>
                        <td><span class="status-badge status-complete">답변 완료</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-detail" data-id="3" data-category="서비스 이용" data-title="사용자 가이드가 필요합니다." data-content="서비스 사용법에 대한 자세한 가이드 문서가 있는지 궁금합니다.">상세 보기</button>
                                <button class="btn-edit" data-id="3">수정</button>
                                <button class="btn-delete" data-id="3">삭제</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>계정</td>
                        <td>비밀번호를 잊어버렸어요.</td>
                        <td>2024.07.08</td>
                        <td><span class="status-badge status-pending">미완료</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-detail" data-id="2" data-category="계정" data-title="비밀번호를 잊어버렸어요." data-content="로그인 비밀번호를 찾을 수 없습니다. 어떻게 해야 하나요?">상세 보기</button>
                                <button class="btn-edit" data-id="2">수정</button>
                                <button class="btn-delete" data-id="2">삭제</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>1</td>
                        <td>기술 지원</td>
                        <td>데이터 로딩 속도가 너무 느려요.</td>
                        <td>2024.07.01</td>
                        <td><span class="status-badge status-complete">답변 완료</span></td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-detail" data-id="1" data-category="기술 지원" data-title="데이터 로딩 속도가 너무 느려요." data-content="최근 들어 데이터 로딩 속도가 현저히 느려졌습니다. 확인 부탁드립니다.">상세 보기</button>
                                <button class="btn-edit" data-id="1">수정</button>
                                <button class="btn-delete" data-id="1">삭제</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div class="popup-overlay" id="qnaPopupOverlay">
    <div class="popup-content">
        <h3 id="popupTitle"></h3>
        <form id="qnaForm" style="display: none;">
            <input type="hidden" id="qnaId">
            <div class="form-group">
                <label for="qnaCategory">분류</label>
                <select id="qnaCategory" required>
                    <option value="">선택하세요</option>
                    <option value="서비스 이용">서비스 이용</option>
                    <option value="계정">계정</option>
                    <option value="기술 지원">기술 지원</option>
                    <option value="기타">기타</option>
                </select>
            </div>
            <div class="form-group">
                <label for="qnaTitle">제목</label>
                <input type="text" id="qnaTitle" required maxlength="100">
            </div>
            <div class="form-group">
                <label for="qnaContent">내용</label>
                <textarea id="qnaContent" required rows="8"></textarea>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn-submit" id="formSubmitButton">저장</button>
                <button type="button" class="btn-cancel" id="formCancelButton">취소</button>
            </div>
        </form>

        <div id="qnaDetailView" style="display: none;">
            <div class="form-group">
                <label>분류</label>
                <div class="detail-field" id="detailCategory"></div>
            </div>
            <div class="form-group">
                <label>제목</label>
                <div class="detail-field" id="detailTitle"></div>
            </div>
            <div class="form-group">
                <label>내용</label>
                <div class="detail-field" id="detailContent"></div>
            </div>
            <div class="form-group">
                <label>등록일</label>
                <div class="detail-field" id="detailDate"></div>
            </div>
            <%-- 답변여부 필드 제거 --%>
            <div class="form-actions">
                <button type="button" class="btn-close-detail" id="btnCloseDetail">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const qnaTableBody = document.querySelector('#qnaTable tbody');
        const btnRegisterQnA = document.getElementById('btnRegisterQnA');
        const qnaPopupOverlay = document.getElementById('qnaPopupOverlay');
        const popupTitle = document.getElementById('popupTitle');
        
        // Form elements
        const qnaForm = document.getElementById('qnaForm');
        const qnaIdInput = document.getElementById('qnaId');
        const qnaCategoryInput = document.getElementById('qnaCategory');
        const qnaTitleInput = document.getElementById('qnaTitle');
        const qnaContentInput = document.getElementById('qnaContent');
        const formSubmitButton = document.getElementById('formSubmitButton');
        const formCancelButton = document.getElementById('formCancelButton');

        // Detail view elements
        const qnaDetailView = document.getElementById('qnaDetailView');
        const detailCategory = document.getElementById('detailCategory');
        const detailTitle = document.getElementById('detailTitle');
        const detailContent = document.getElementById('detailContent');
        const detailDate = document.getElementById('detailDate');
        // const detailStatus = document.getElementById('detailStatus'); // 답변여부 제거로 주석 처리
        const btnCloseDetail = document.getElementById('btnCloseDetail');

        let currentMaxId = 3; // Initial max ID for dummy data

        // Function to open the popup
        function openPopup(mode = 'register', qna = null) {
            // Reset visibility for both sections and buttons
            qnaForm.style.display = 'none';
            qnaDetailView.style.display = 'none';
            formSubmitButton.style.display = 'inline-block'; 
            formCancelButton.style.display = 'inline-block';
            btnCloseDetail.style.display = 'none';

            if (mode === 'register') {
                popupTitle.textContent = 'Q&A 등록';
                qnaForm.reset(); // Clear form fields
                qnaIdInput.value = '';
                qnaForm.style.display = 'block';
            } else if (mode === 'edit') {
                popupTitle.textContent = 'Q&A 수정';
                qnaIdInput.value = qna.id;
                qnaCategoryInput.value = qna.category;
                qnaTitleInput.value = qna.title;
                qnaContentInput.value = qna.content;
                qnaForm.style.display = 'block';
            } else if (mode === 'detail') {
                popupTitle.textContent = 'Q&A 상세 보기';
                detailCategory.textContent = qna.category;
                detailTitle.textContent = qna.title;
                detailContent.textContent = qna.content;
                detailDate.textContent = qna.date;
                
                // --- 답변여부 제거로 이 부분 주석 처리 또는 삭제 ---
                // const statusText = qna.status.trim(); // "답변 완료" 또는 "미완료" 텍스트를 가져옴
                // let statusClass = '';
                // if (statusText === '답변 완료') {
                //     statusClass = 'status-complete';
                // } else if (statusText === '미완료') {
                //     statusClass = 'status-pending';
                // }
                // detailStatus.innerHTML = `<span class="status-badge ${statusClass}">${statusText}</span>`;
                // --- 여기까지 ---
                
                qnaDetailView.style.display = 'block';
                formSubmitButton.style.display = 'none'; 
                formCancelButton.style.display = 'none';
                btnCloseDetail.style.display = 'inline-block';
            }
            qnaPopupOverlay.style.display = 'flex'; // Show the overlay
        }

        // Function to close the popup
        function closePopup() {
            qnaPopupOverlay.style.display = 'none';
        }

        // Event Listener for "Q&A 등록" button
        btnRegisterQnA.addEventListener('click', () => openPopup('register'));

        // Event Listener for form cancel button
        formCancelButton.addEventListener('click', closePopup);

        // Event Listener for detail view close button
        btnCloseDetail.addEventListener('click', closePopup);

        // Event Listener for form submission (Register/Edit)
        qnaForm.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent default form submission

            const id = qnaIdInput.value;
            const category = qnaCategoryInput.value;
            const title = qnaTitleInput.value;
            const content = qnaContentInput.value;
            const today = new Date().toISOString().slice(0, 10).replace(/-/g, '.'); // YYYY.MM.DD

            if (id) { // Edit mode
                const rowToUpdate = qnaTableBody.querySelector(`tr[data-id="${id}"]`);
                if (rowToUpdate) {
                    rowToUpdate.children[1].textContent = category;
                    rowToUpdate.children[2].textContent = title;
                    const detailButton = rowToUpdate.querySelector('.btn-detail');
                    detailButton.dataset.category = category;
                    detailButton.dataset.title = title;
                    detailButton.dataset.content = content;
                    alert('Q&A가 수정되었습니다.');
                }
            } else { // Register mode
                currentMaxId++;
                const newRow = document.createElement('tr');
                newRow.dataset.id = currentMaxId;
                newRow.innerHTML = `
                    <td>${currentMaxId}</td>
                    <td>${category}</td>
                    <td>${today}</td>
                    <td><span class="status-badge status-pending">미완료</span></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-detail" 
                                data-id="${currentMaxId}" 
                                data-category="${category}" 
                                data-title="${title}" 
                                data-content="${content}"
                                data-date="${today}"
                                data-status="미완료"
                                >상세 보기</button>
                            <button class="btn-edit" data-id="${currentMaxId}">수정</button>
                            <button class="btn-delete" data-id="${currentMaxId}">삭제</button>
                        </div>
                    </td>
                `;
                qnaTableBody.prepend(newRow);
                alert('Q&A가 등록되었습니다.');
            }
            closePopup();
            attachEventListenersToButtons(); // Re-attach event listeners for new/updated buttons
        });

        // Function to attach event listeners to all buttons
        function attachEventListenersToButtons() {
            // Event Listeners for "상세 보기" buttons
            document.querySelectorAll('.btn-detail').forEach(button => {
                button.onclick = function() {
                    const row = this.closest('tr');
                    const qna = {
                        id: this.dataset.id,
                        category: this.dataset.category, 
                        title: this.dataset.title,      
                        content: this.dataset.content,  
                        date: row.children[3].textContent, 
                        // status 값을 직접 span 내부의 텍스트로 가져오도록 수정
                        status: row.children[4].querySelector('.status-badge').textContent 
                    };
                    openPopup('detail', qna);
                };
            });

            // Event Listeners for "수정" buttons
            document.querySelectorAll('.btn-edit').forEach(button => {
                button.onclick = function() {
                    const row = this.closest('tr');
                    const detailButton = row.querySelector('.btn-detail'); 
                    const qna = {
                        id: this.dataset.id,
                        category: row.children[1].textContent,
                        title: row.children[2].textContent,
                        content: detailButton.dataset.content 
                    };
                    openPopup('edit', qna);
                };
            });

            // Event Listeners for "삭제" buttons
            document.querySelectorAll('.btn-delete').forEach(button => {
                button.onclick = function() {
                    const row = this.closest('tr');
                    const qnaTitle = row.children[2].textContent;
                    if (confirm(`Q&A를 정말로 삭제하시겠습니까?`)) {
                        row.remove();
                        alert('Q&A가 삭제되었습니다.');
                    }
                };
            });
        }

        // Initial attachment of event listeners for existing dummy data
        attachEventListenersToButtons();
    });
</script>
    <!-- 인클루드한 top.jsp 첫줄에는 </div> 닫기 태그가 달려있음 -->
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>