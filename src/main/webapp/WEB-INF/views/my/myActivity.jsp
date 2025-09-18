%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 활동 기록</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <style>


        /* ------------------------------------------- */
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

        /* Board table styles */
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

        /* Titles/Content in tables */
        #postActivityTable td:nth-child(3),
        #commentActivityTable td:nth-child(3),
        #apiDataTable td:nth-child(2) { /* API Data Table은 신청 데이터명이 2번째 열입니다. */
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

        /* Column widths for Posts Table */
        #postActivityTable th:nth-child(1), #postActivityTable td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
        #postActivityTable th:nth-child(2), #postActivityTable td:nth-child(2) { width: 20%; text-align: center;} /* 카테고리 */
        #postActivityTable th:nth-child(3), #postActivityTable td:nth-child(3) { width: 40%; } /* 제목 */
        #postActivityTable th:nth-child(4), #postActivityTable td:nth-child(4) { width: 15%; text-align: center;} /* 작성일 */
        #postActivityTable th:nth-child(5), #postActivityTable td:nth-child(5) { width: 20%; text-align: center;} /* 관리 */

        /* Column widths for Comments Table */
        #commentActivityTable th:nth-child(1), #commentActivityTable td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
        #commentActivityTable th:nth-child(2), #commentActivityTable td:nth-child(2) { width: 20%; text-align: center;} /* 카테고리 */
        #commentActivityTable th:nth-child(3), #commentActivityTable td:nth-child(3) { width: 45%; } /* 내용 일부 */
        #commentActivityTable th:nth-child(4), #commentActivityTable td:nth-child(4) { width: 15%; text-align: center;} /* 작성일 */
        #commentActivityTable th:nth-child(5), #commentActivityTable td:nth-child(5) { width: 15%; text-align: center;} /* 관리 */

        /* Column widths for API Data Table */
        #apiDataTable th:nth-child(1), #apiDataTable td:nth-child(1) { width: 5%; text-align: center; } /* 번호 */
        #apiDataTable th:nth-child(2), #apiDataTable td:nth-child(2) { width: 25%; text-align: center;} /* 신청 데이터명 */
        #apiDataTable th:nth-child(3), #apiDataTable td:nth-child(3) { width: 20%; text-align: center;} /* 신청일 */
        #apiDataTable th:nth-child(4), #apiDataTable td:nth-child(4) { width: 15%; text-align: center;} /* 처리 상태 */
        #apiDataTable th:nth-child(5), #apiDataTable td:nth-child(5) { width: 15%; text-align: center;} /* 관리 */


        .board-table .action-buttons {
            display: flex;
            gap: 5px;
            flex-wrap: nowrap;
            justify-content: center;
            align-items: center;
            height: 100%;
        }
        .board-table .btn-view,
        .board-table .btn-edit,
        .board-table .btn-delete {
            padding: 7px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85em;
            transition: background-color 0.2s ease, transform 0.1s ease;
            white-space: nowrap;
            flex-shrink: 0;
            min-width: 50px;
        }
        .board-table .btn-view {
            background-color: #3498db;
            color: white;
        }
        .board-table .btn-view:hover {
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

        /* Common Popup Styles */
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
            width: 600px;
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
            white-space: pre-wrap; /* 줄바꿈 유지 */
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

        /* Specific styles for Comment Detail View */
        #commentDetailView .detail-field {
            min-height: 80px; /* 댓글은 좀 더 짧게 */
        }
        /* Specific styles for API Data Detail View */
        #apiDataDetailView .detail-field {
            min-height: 50px;
        }
        /* Improved Status Badges */
        .status-badge {
            display: inline-block;
            padding: 7px 12px; /* Increased padding for better look */
            border-radius: 5px;
            font-weight: bold;
            font-size: 0.9em;
            text-align: center;
            min-width: 80px; /* Ensure consistent width */
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        /* Color themes for new statuses */
        .status-processing { background-color: #3498db; color: white; } /* 처리 중 (파랑) */
        .status-completed { background-color: #2ecc71; color: white; } /* 처리 완료 (초록) */
        .status-rejected { background-color: #e74c3c; color: white; } /* 신청 반려 (빨강) */

        /* Comment count style for post titles */
        .comment-count {
            color: #7f8c8d; /* Grey color for consistency */
            font-size: 0.9em;
            margin-left: 5px;
            font-weight: normal;
        }
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
        }
    </style>
</head>
<body>
            <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <!-- 인클루드한 top.jsp 마지막 줄에는 <div> 열기 태그가 달려있음 -->

    <div class="mypage-wrapper"> 
    	<aside class="sidebar">
            <h2>마이페이지</h2>
            <nav class="sidebar-menu">
                <%-- JSTL c:url을 사용하여 컨텍스트 패스 문제를 해결하고, 실제 컨트롤러 매핑 경로에 맞게 URL을 수정해주세요. --%>
                <a href="/my/profile" class="active"><i class="fas fa-user-circle"></i> 회원정보 관리</a>
	            <a href="/my/report"><i class="fas fa-chart-line"></i> 상권분석 내역 조회</a>
	            <a href="/my/interior"><i class="fas fa-hammer"></i> 셀프인테리어</a>
	            <a href="/my/activity"><i class="fas fa-hammer"></i> 활동 기록</a>
	            <a href="/my/favZone"><i class="fas fa-map-marked-alt"></i> 내 관심구역 리스트</a>
	            <a href="/my/favStore"><i class="fas fa-store"></i> 내 관심가게 리스트</a>
	            <a href="/my/qna"><i class="fas fa-question-circle"></i> 내 Q&A 내역</a>
	            <a href="/my/delete-acc"><i class="fas fa-user-minus"></i> 회원 탈퇴</a>
            </nav>
        </aside>

        <main class="main-content"> <div class="mypage-header">
                <h2>활동 기록 📝</h2>
                <p>회원님이 작성하신 글과 댓글, 그리고 데이터 신청 내역을 한눈에 확인하고 관리하세요.</p>
            </div>

            <div class="board-section">
                <h3>게시글 활동</h3>
                <table class="board-table" id="postActivityTable">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>카테고리</th>
                            <th>게시글 제목</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-id="5" data-type="post">
                            <td>5</td>
                            <td>자유게시판</td>
                            <td>새로운 상권분석 기능에 대한 의견입니다.<span class="comment-count"></span></td> 
                            <td>2024.07.15</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="5" data-type="post" data-category="자유게시판" data-title="새로운 상권분석 기능에 대한 의견입니다." data-content="새롭게 추가된 상권분석 기능이 매우 유용합니다. 하지만 특정 필터링 옵션이 추가되면 더 좋을 것 같습니다. 예를 들어, '주말 유동인구' 필터가 있다면 더욱 정확한 분석이 가능할 것 같습니다. 검토 부탁드립니다.">보기</button>
                                    <button class="btn-edit" data-id="5" data-type="post">수정</button>
                                    <button class="btn-delete" data-id="5" data-type="post">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr data-id="3" data-type="post">
                            <td>3</td>
                            <td>질문과 답변</td>
                            <td>엑셀 다운로드 오류가 발생합니다.<span class="comment-count"></span></td>
                            <td>2024.07.12</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="3" data-type="post" data-category="질문과 답변" data-title="엑셀 다운로드 오류가 발생합니다." data-content="상권 분석 리포트를 엑셀로 다운로드 하려는데 자꾸 오류 메시지가 뜹니다. 현재 크롬 브라우저를 사용 중이며, 다른 브라우저에서도 동일합니다. 빠른 확인 부탁드립니다.">보기</button>
                                    <button class="btn-edit" data-id="3" data-type="post">수정</button>
                                    <button class="btn-delete" data-id="3" data-type="post">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr data-id="1" data-type="post">
                            <td>1</td>
                            <td>자유게시판</td>
                            <td>첫 방문 후기 남겨요!<span class="comment-count"></span></td>
                            <td>2024.07.01</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="1" data-type="post" data-category="자유게시판" data-title="첫 방문 후기 남겨요!" data-content="오늘 처음으로 이 서비스를 이용해봤는데 정말 유용하네요! 특히 지도를 통해 상권 정보를 직관적으로 볼 수 있어서 좋았습니다. 앞으로 자주 이용할 것 같아요.">보기</button>
                                    <button class="btn-edit" data-id="1" data-type="post">수정</button>
                                    <button class="btn-delete" data-id="1" data-type="post">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="board-section">
                <h3>댓글 활동</h3>
                <table class="board-table" id="commentActivityTable">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>카테고리</th>
                            <th>내용 일부</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-id="4" data-type="comment">
                            <td>4</td>
                            <td>Q&A 게시판</td>
                            <td>내가 쓴 댓글 확인목록</td>
                            <td>2024.07.14</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="4" data-type="comment" data-category="Q&A 게시판" data-content="문의하신 엑셀 다운로드 오류는 현재 확인 중에 있습니다. 임시적으로는 다른 브라우저를 사용하시거나 PDF 다운로드를 이용해 주시길 권장합니다. 빠른 시일 내에 수정하여 공지하겠습니다.">보기</button>
                                    <button class="btn-delete" data-id="4" data-type="comment">삭제</button>
                                </div>
                            </td>
                        </tr>
                        <tr data-id="2" data-type="comment">
                            <td>2</td>
                            <td>공지사항</td>
                            <td>점검 공지 감사합니다! 덕분에 서비스 이용에 차질 없이 대비할 수 있었습니다. 항상 빠른 공지 해주셔서 좋아요!</td>
                            <td>2024.07.05</td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="2" data-type="comment" data-category="공지사항" data-content="점검 공지 감사합니다! 덕분에 서비스 이용에 차질 없이 대비할 수 있었습니다. 항상 빠른 공지 해주셔서 좋아요!">보기</button>
                                    <button class="btn-delete" data-id="2" data-type="comment">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="board-section">
                <h3>API 데이터 신청 내역</h3>
                <table class="board-table" id="apiDataTable">
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>신청 데이터명</th>
                            <th>신청일</th>
                            <th>처리 상태</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr data-id="101" data-type="apiData">
                            <td>101</td>
                            <td>대전시 유동인구 데이터 (2023년)</td>
                            <td>2024.07.10</td>
                            <td><span class="status-badge status-processing">처리 중</span></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="101" data-type="apiData" data-api-name="대전시 유동인구 데이터 (2023년)" data-api-purpose="상권 분석 보고서 작성용" data-api-status-text="처리 중" data-api-status-class="processing" data-api-date="2024.07.10">보기</button>
                                </div>
                            </td>
                        </tr>
                        <tr data-id="102" data-type="apiData">
                            <td>102</td>
                            <td>전국 소상공인 매출 데이터 (2022년)</td>
                            <td>2024.06.25</td>
                            <td><span class="status-badge status-completed">처리 완료</span></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="102" data-type="apiData" data-api-name="전국 소상공인 매출 데이터 (2022년)" data-api-purpose="투자 유치 사업 계획서 작성" data-api-status-text="처리 완료" data-api-status-class="completed" data-api-date="2024.06.25">보기</button>
                                </div>
                            </td>
                        </tr>
                        <tr data-id="103" data-type="apiData">
                            <td>103</td>
                            <td>서울시 상가 임대료 변동 데이터 (2024년 1분기)</td>
                            <td>2024.06.01</td>
                            <td><span class="status-badge status-rejected">신청 반려</span></td>
                            <td>
                                <div class="action-buttons">
                                    <button class="btn-view" data-id="103" data-type="apiData" data-api-name="서울시 상가 임대료 변동 데이터 (2024년 1분기)" data-api-purpose="부동산 투자 컨설팅 자료" data-api-status-text="신청 반려" data-api-status-class="rejected" data-api-date="2024.06.01">보기</button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div> <div class="popup-overlay" id="postPopupOverlay">
        <div class="popup-content">
            <h3 id="postPopupTitle"></h3>
            <form id="postForm" style="display: none;">
                <input type="hidden" id="postId">
                <div class="form-group">
                    <label for="postCategory">카테고리</label>
                    <input type="text" id="postCategory" readonly>
                </div>
                <div class="form-group">
                    <label for="postTitle">제목</label>
                    <input type="text" id="postTitle" required maxlength="100">
                </div>
                <div class="form-group">
                    <label for="postContent">내용</label>
                    <textarea id="postContent" required rows="10"></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn-submit" id="postFormSubmitButton">저장</button>
                    <button type="button" class="btn-cancel" id="postFormCancelButton">취소</button>
                </div>
            </form>

            <div id="postDetailView" style="display: none;">
                <div class="form-group">
                    <label>카테고리</label>
                    <div class="detail-field" id="postDetailCategory"></div>
                </div>
                <div class="form-group">
                    <label>제목</label>
                    <div class="detail-field" id="postDetailTitle"></div>
                </div>
                <div class="form-group">
                    <label>내용</label>
                    <div class="detail-field" id="postDetailContent"></div>
                </div>
                <div class="form-group">
                    <label>작성일</label>
                    <div class="detail-field" id="postDetailDate"></div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-close-detail" id="postBtnCloseDetail">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <div class="popup-overlay" id="commentPopupOverlay">
        <div class="popup-content">
            <h3 id="commentPopupTitle">댓글 상세 보기</h3>
            <div id="commentDetailView">
                <div class="form-group">
                    <label>카테고리</label>
                    <div class="detail-field" id="commentDetailCategory"></div>
                </div>
                <div class="form-group">
                    <label>내용</label>
                    <div class="detail-field" id="commentDetailContent"></div>
                </div>
                <div class="form-group">
                    <label>작성일</label>
                    <div class="detail-field" id="commentDetailDate"></div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-close-detail" id="commentBtnCloseDetail">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <div class="popup-overlay" id="apiDataPopupOverlay">
        <div class="popup-content">
            <h3 id="apiDataPopupTitle">API 데이터 신청 내역 상세</h3>
            <div id="apiDataDetailView">
                <div class="form-group">
                    <label>신청 데이터명</label>
                    <div class="detail-field" id="apiDataDetailName"></div>
                </div>
                <div class="form-group">
                    <label>신청 목적</label>
                    <div class="detail-field" id="apiDataDetailPurpose"></div>
                </div>
                <div class="form-group">
                    <label>신청일</label>
                    <div class="detail-field" id="apiDataDetailDate"></div>
                </div>
                <div class="form-group">
                    <label>처리 상태</label>
                    <div class="detail-field" id="apiDataDetailStatus"></div>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn-close-detail" id="apiDataBtnCloseDetail">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Get all "보기" (View) buttons
            const viewButtons = document.querySelectorAll('.btn-view');

            // Get popup overlays and content areas
            const postPopupOverlay = document.getElementById('postPopupOverlay');
            const commentPopupOverlay = document.getElementById('commentPopupOverlay');
            const apiDataPopupOverlay = document.getElementById('apiDataPopupOverlay');

            const postForm = document.getElementById('postForm');
            const postDetailView = document.getElementById('postDetailView');
            const commentDetailView = document.getElementById('commentDetailView');
            const apiDataDetailView = document.getElementById('apiDataDetailView');

            // Get "닫기" (Close) buttons
            const postBtnCloseDetail = document.getElementById('postBtnCloseDetail');
            const commentBtnCloseDetail = document.getElementById('commentBtnCloseDetail');
            const apiDataBtnCloseDetail = document.getElementById('apiDataBtnCloseDetail');

            // Get "수정" (Edit) and "삭제" (Delete) buttons
            const editButtons = document.querySelectorAll('.btn-edit');
            const deleteButtons = document.querySelectorAll('.btn-delete');

            // --- Event Listeners for View Buttons ---
            viewButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const type = this.dataset.type; // 'post', 'comment', or 'apiData'
                    const row = this.closest('tr');
                    
                    // Hide all popups and forms/detail views initially
                    postPopupOverlay.style.display = 'none';
                    commentPopupOverlay.style.display = 'none';
                    apiDataPopupOverlay.style.display = 'none';
                    postForm.style.display = 'none';
                    postDetailView.style.display = 'none';
                    commentDetailView.style.display = 'none';
                    apiDataDetailView.style.display = 'none';

                    if (type === 'post') {
                        document.getElementById('postPopupTitle').textContent = '게시글 상세 보기';
                        document.getElementById('postDetailCategory').textContent = this.dataset.category;
                        document.getElementById('postDetailTitle').textContent = this.dataset.title;
                        document.getElementById('postDetailContent').textContent = this.dataset.content;
                        document.getElementById('postDetailDate').textContent = row.children[3].textContent; // 작성일
                        postDetailView.style.display = 'block';
                        postPopupOverlay.style.display = 'flex';
                    } else if (type === 'comment') {
                        document.getElementById('commentDetailCategory').textContent = this.dataset.category;
                        document.getElementById('commentDetailContent').textContent = this.dataset.content;
                        document.getElementById('commentDetailDate').textContent = row.children[3].textContent; // 작성일
                        commentDetailView.style.display = 'block';
                        commentPopupOverlay.style.display = 'flex';
                    } else if (type === 'apiData') {
                        document.getElementById('apiDataDetailName').textContent = this.dataset.apiName;
                        document.getElementById('apiDataDetailPurpose').textContent = this.dataset.apiPurpose;
                        document.getElementById('apiDataDetailDate').textContent = this.dataset.apiDate;
                        const statusBadge = row.querySelector('.status-badge');
                        if (statusBadge) {
                            document.getElementById('apiDataDetailStatus').innerHTML = `<span class="status-badge ${statusBadge.className.split(' ').pop()}">${statusBadge.textContent}</span>`;
                        }
                        apiDataDetailView.style.display = 'block';
                        apiDataPopupOverlay.style.display = 'flex';
                    }
                });
            });

            // --- Event Listeners for Close Buttons ---
            postBtnCloseDetail.addEventListener('click', () => postPopupOverlay.style.display = 'none');
            commentBtnCloseDetail.addEventListener('click', () => commentPopupOverlay.style.display = 'none');
            apiDataBtnCloseDetail.addEventListener('click', () => apiDataPopupOverlay.style.display = 'none');

            // --- Event Listeners for Edit Buttons ---
            editButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const postId = this.dataset.id;
                    const row = this.closest('tr');
                    
                    // Populate form with current data
                    document.getElementById('postId').value = postId;
                    document.getElementById('postCategory').value = this.dataset.category;
                    document.getElementById('postTitle').value = this.dataset.title;
                    document.getElementById('postContent').value = this.dataset.content;
                    
                    document.getElementById('postPopupTitle').textContent = '게시글 수정';
                    postDetailView.style.display = 'none'; // Hide detail view
                    postForm.style.display = 'block';     // Show form
                    postPopupOverlay.style.display = 'flex';
                });
            });

            // --- Event Listeners for Form Action Buttons (Save/Cancel) ---
            document.getElementById('postFormSubmitButton').addEventListener('click', function(event) {
                event.preventDefault(); // Prevent default form submission
                // In a real application, you'd send an AJAX request to update the data
                alert('게시글이 저장되었습니다. (실제로는 서버에 업데이트 요청)');
                postPopupOverlay.style.display = 'none'; // Close popup
                // Optionally, update the table row with new data
            });

            document.getElementById('postFormCancelButton').addEventListener('click', function() {
                postPopupOverlay.style.display = 'none'; // Close popup
            });

            // --- Event Listeners for Delete Buttons ---
            deleteButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const id = this.dataset.id;
                    const type = this.dataset.type; // 'post' or 'comment'
                    const row = this.closest('tr');
                    
                    let confirmMessage = '';
                    if (type === 'post') {
                        confirmMessage = '이 게시글을 정말로 삭제하시겠습니까?';
                    } else if (type === 'comment') {
                        confirmMessage = '이 댓글을 정말로 삭제하시겠습니까?';
                    }

                    if (confirm(confirmMessage)) {
                        row.remove(); // Remove the row from the table
                        // In a real application, send an AJAX request to the server to delete the data
                        alert(type === 'post' ? '게시글이 삭제되었습니다.' : '댓글이 삭제되었습니다.');
                    }
                });
            });
        });
    </script>
        <!-- 인클루드한 top.jsp 첫줄에는 </div> 닫기 태그가 달려있음 -->
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
    
</body>
</html>