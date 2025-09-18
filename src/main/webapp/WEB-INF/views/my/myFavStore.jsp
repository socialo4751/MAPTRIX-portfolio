<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 내 관심가게 리스트</title>
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

        /* Board specific styles */
        .board-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            table-layout: fixed; /* Ensures columns respect defined widths */
        }
        .board-table th, .board-table td {
            border: 1px solid #ddd;
            padding: 12px 15px;
            text-align: left;
            vertical-align: middle;
            white-space: normal; /* 기본적으로 텍스트 줄바꿈 허용 */
            word-wrap: break-word; /* 긴 단어가 셀을 넘어가면 줄바꿈 */
        }

        /* Specific styles for ellipsis on '가게명', '주소', and '업종' columns */
        .board-table td:nth-child(2), /* 가게명 */
        .board-table td:nth-child(3), /* 주소 */
        .board-table td:nth-child(4) {  /* 업종 */
            white-space: nowrap; /* 해당 컬럼만 텍스트를 한 줄로 강제 */
            overflow: hidden; /* 넘치는 텍스트 숨김 */
            text-overflow: ellipsis; /* 숨긴 텍스트를 ...으로 표시 */
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

        /* Specific column widths for better layout control */
        .board-table th:nth-child(1), .board-table td:nth-child(1) { width: 8%; text-align: center; } /* 번호 */
        .board-table th:nth-child(2), .board-table td:nth-child(2) { width: 22%; } /* 가게명 */
        .board-table th:nth-child(3), .board-table td:nth-child(3) { width: 28%; } /* 주소: 저장일 늘리느라 줄임 */
        .board-table th:nth-child(4), .board-table td:nth-child(4) { width: 10%; } /* 업종 */
        .board-table th:nth-child(5), .board-table td:nth-child(5) { width: 14%; } /* 저장일: 늘림 */
        .board-table th:nth-child(6), .board-table td:nth-child(6) { width: 18%; } /* 관리 */


        .board-table .action-buttons {
            display: flex;
            gap: 5px; /* 버튼 간격 유지 */
            flex-wrap: nowrap; /* 버튼들이 한 줄에 유지되도록 */
            justify-content: center; /* 관리 셀 내에서 버튼 중앙 정렬 */
            align-items: center;
            height: 100%; /* 부모 셀 높이에 맞춤 */
        }
        .board-table .btn-view,
        .board-table .btn-delete {
            padding: 7px 10px; /* 버튼 패딩 유지 */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85em; /* 폰트 사이즈 유지 */
            transition: background-color 0.2s ease, transform 0.1s ease;
            white-space: nowrap; /* 버튼 텍스트 줄바꿈 방지 */
            flex-shrink: 0; /* 버튼이 줄어들지 않도록 */
            min-width: 55px; /* 최소 너비 유지 */
        }
        .board-table .btn-view {
            background-color: #2ecc71; /* Green for view */
            color: white;
        }
        .board-table .btn-view:hover {
            background-color: #27ae60;
            transform: translateY(-1px);
        }
        .board-table .btn-delete {
            background-color: #e74c3c; /* Red for delete */
            color: white;
        }
        .board-table .btn-delete:hover {
            background-color: #c0392b;
            transform: translateY(-1px);
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

            /* For small screens, adjust table column widths if necessary */
            .board-table th, .board-table td {
                font-size: 0.9em; /* Smaller font size for tables on mobile */
                padding: 8px 10px;
            }
            .board-table .action-buttons {
                flex-direction: column; /* Buttons stack vertically on small screens */
                align-items: stretch; /* Make buttons fill available width */
            }
            .board-table .btn-view,
            .board-table .btn-delete {
                min-width: unset; /* Remove min-width to allow shrinking */
                width: 100%; /* Take full width of parent flex item */
            }
            /* Adjust specific column widths for smaller screens if content is too crunched */
            .board-table th:nth-child(1), .board-table td:nth-child(1) { width: 10%; } /* 번호 */
            .board-table th:nth-child(2), .board-table td:nth-child(2) { width: 30%; } /* 가게명 */
            .board-table th:nth-child(3), .board-table td:nth-child(3) { width: 25%; } /* 주소 */
            .board-table th:nth-child(4), .board-table td:nth-child(4) { width: 15%; } /* 업종 */
            .board-table th:nth-child(5), .board-table td:nth-child(5) { width: 20%; } /* 저장일 */
            .board-table th:nth-child(6), .board-table td:nth-child(6) { width: 25%; } /* 관리 */
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
    <main class="main-content">
        <div class="mypage-header">
            <h2>내 관심가게 리스트 ❤️</h2>
            <p>관심 있는 가게를 이곳에서 확인하고 관리할 수 있습니다.</p>
        </div>

        <div class="board-section">
            <h3>저장된 관심가게 목록</h3>
            <table class="board-table">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>가게명</th>
                        <th>주소</th>
                        <th>업종</th>
                        <th>저장일</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>1</td>
                        <td>로마의 휴일 레스토랑 아주 긴 이름의 가게입니다</td>
                        <td>대전광역시 유성구 봉명동 아주 아주 긴 주소라서 줄바꿈이 될 수 있습니다</td>
                        <td>이탈리안 레스토랑 아주 긴 업종명 테스트</td>
                        <td>2024.07.12</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-view">정보 보기</button>
                                <button class="btn-delete">삭제</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>모던 카페 스페이스</td>
                        <td>서울특별시 강남구 역삼동</td>
                        <td>카페</td>
                        <td>2024.06.25</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-view">정보 보기</button>
                                <button class="btn-delete">삭제</button>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>명인 헤어샵 (프리미엄 지점)</td>
                        <td>부산광역시 해운대구 우동 마린시티 2로 32번길 15-10</td>
                        <td>미용실 및 피부관리 전문점</td>
                        <td>2024.05.15</td>
                        <td>
                            <div class="action-buttons">
                                <button class="btn-view">정보 보기</button>
                                <button class="btn-delete">삭제</button>
                            </div>
                        </td>
                    </tr>
                    </tbody>
            </table>
        </div>
    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Add event listeners for view buttons
        const viewButtons = document.querySelectorAll('.btn-view');
        viewButtons.forEach(button => {
            button.addEventListener('click', function() {
                const row = this.closest('tr');
                const storeName = row.children[1].textContent; // Get the store name
                alert(storeName + '의 상세 정보를 봅니다. (실제로는 새 페이지로 이동)');
                // In a real application, you would navigate to a detailed store info page
                // e.g., window.location.href = 'store_detail.html?name=' + encodeURIComponent(storeName);
            });
        });

        // Add event listeners for delete buttons
        const deleteButtons = document.querySelectorAll('.btn-delete');
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const row = this.closest('tr'); // Get the closest table row
                const storeName = row.children[1].textContent; // Get the store name from the second column
                if (confirm(storeName + '을(를) 정말로 삭제하시겠습니까?')) {
                    row.remove(); // Remove the row from the table
                    // In a real application, you would also send a request to the server to delete the data
                    alert(storeName + '이(가) 삭제되었습니다.');
                }
            });
        });
    });
</script>
    <!-- 인클루드한 top.jsp 첫줄에는 </div> 닫기 태그가 달려있음 -->
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>