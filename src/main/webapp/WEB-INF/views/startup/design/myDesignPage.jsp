<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>내 도면 라이브러리</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<%@ include file="/WEB-INF/views/include/top.jsp"%>
<style>
/* 기본 폰트 및 전체 레이아웃 설정 */
body {
	font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI',
		Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif,
		'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol';
	color: #2f3438;
	margin: 0;
	line-height: 1.6;
}

/* 마이페이지 컨테이너 */
.my-design-container {
	position: relative;
	max-width: 1000px;
	margin: 40px auto;
	padding: 20px;
	background-color: #ffffff;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

/* --- 수정된 부분 --- */
/* 페이지 헤더 (제목 + 버튼을 감싸는 컨테이너) */
.page-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 24px;
	padding-bottom: 16px;
	border-bottom: 1px solid #eaedef;
}

/* 페이지 제목 */
.page-header h1 {
	font-size: 28px;
	font-weight: 700;
	margin: 0; /* 컨테이너가 마진을 가지므로 h1 자체의 마진 제거 */
}

/* 메인으로 돌아가기 버튼 (고스트 버튼 스타일) */
.btn-go-main {
	display: inline-flex;
	align-items: center;
	padding: 7px 15px; /* 패딩을 살짝 줄여 더 날렵하게 */
	background-color: transparent; /* 배경 투명하게 */
	color: #35C5F0; /* 탭과 동일한 파란색 텍스트 */
	text-decoration: none;
	border-radius: 8px;
	font-size: 15px;
	font-weight: 500;
	transition: all 0.2s ease;
	border: 1px solid #35C5F0; /* 파란색 테두리 */
}

.btn-go-main:hover {
	background-color: #35C5F0; /* 마우스를 올리면 배경색 채우기 */
	color: #ffffff; /* 텍스트는 흰색으로 변경 */
}

.btn-go-main .fa-arrow-left {
	margin-right: 8px;
}

/* 탭 네비게이션 스타일 */
.tabs {
	border-bottom: 2px solid #eaedef;
	margin-bottom: 24px;
}

.tab-link {
	background: none;
	border: none;
	padding: 14px 20px;
	font-size: 17px;
	font-weight: 600;
	cursor: pointer;
	color: #757575;
	transition: all 0.2s ease-in-out;
	border-bottom: 2px solid transparent;
	margin-bottom: -2px; /* 탭 아래 선과 컨테이너 아래 선이 겹치도록 */
}

.tab-link:hover, .tab-link:focus {
	color: #35C5F0;
	outline: none; /* 브라우저 기본 테두리(outline) 제거 */
}

.tab-link.active {
	color: #35C5F0; /* 오늘의집 블루 */
	border-bottom: 2px solid #35C5F0;
}

/* 탭 콘텐츠 기본 스타일 */
.tab-content {
	display: none;
	animation: fadeIn 0.5s;
}

@
keyframes fadeIn {from { opacity:0;
	
}

to {
	opacity: 1;
}

}

/* 디자인 카드 그리드 레이아웃 */
.design-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
	gap: 28px;
}

/* 디자인 카드 스타일 */
.design-card {
	border: 1px solid #eaedef;
	border-radius: 8px;
	overflow: hidden;
	position: relative;
	transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
	cursor: pointer;
}

.design-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.design-card img {
	width: 100%;
	height: 200px;
	object-fit: cover; /* 이미지가 카드 비율에 맞게 잘리도록 */
	display: block;
}

/* 카드 정보 텍스트 영역 */
.design-card .card-info {
	padding: 16px;
}

.design-card h4 {
	margin: 0 0 5px;
	font-size: 16px;
	font-weight: 600;
	/* 텍스트가 길어지면 ...으로 표시 */
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.design-card p {
	margin: 0;
	color: #828c94;
	font-size: 14px;
}

/* 카드 위에 마우스 올렸을 때 나타나는 액션 버튼 영역 */
.design-card .card-actions {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.6);
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	opacity: 0;
	transition: opacity 0.3s ease;
}

.design-card:hover .card-actions {
	opacity: 1;
}

.btn-action {
    color: white;
    background: transparent;
    padding: 10px 22px;
    border-radius: 20px;
    text-decoration: none;
    margin: 6px;
    font-size: 14px;
    font-weight: 600;
    transition: all 0.2s ease;
    border: 2px solid white;
}

.btn-action:hover {
    background: white;
    color: #2f3438; 
}

.btn-action btn-delete{
	color : red;
}


/* '스크랩됨' 버튼 활성 스타일 */
.btn-action.btn-scrap.active {
	background-color: #35C5F0;
	border-color: #35C5F0;
}

/* 콘텐츠가 없을 때 보여주는 메시지 */
.empty-message {
	text-align: center;
	padding: 80px 20px;
	color: #828c94;
	font-size: 16px;
	border: 1px dashed #dce0e4;
	border-radius: 8px;
	margin-top: 20px;
}
</style>
</head>
<body>
	<div class="my-design-container">

		<div class="page-header">
			<h1>내 도면 라이브러리</h1>
			<a href="${pageContext.request.contextPath}/start-up/show"
				class="btn-go-main"> <i class="fa-solid fa-arrow-left"></i> 메인으로
				돌아가기
			</a>
		</div>

		<div class="tabs">
			<button class="tab-link active"
				onclick="openTab(event, 'myProjects')">내 프로젝트</button>
			<button class="tab-link" onclick="openTab(event, 'scrappedProjects')">스크랩한
				프로젝트</button>
		</div>

		<div id="myProjects" class="tab-content" style="display: block;">
		    <c:choose>
		        <%-- 1. 조건문 변수 변경 --%>
		        <c:when test="${not empty articlePage.content}">
		            <div class="design-grid">
		                <%-- 2. 반복문 변수 변경 --%>
		                <c:forEach var="design" items="${articlePage.content}">
		                    <div class="design-card">
		                        <c:choose>
		                            <c:when test="${not empty design.screenshotUrl}">
		                                <img src="${design.screenshotUrl}" alt="${design.designName}">
		                            </c:when>
		                            <c:otherwise>
		                                <img src="/resources/images/default-thumbnail.png"
		                                    alt="${design.designName}">
		                            </c:otherwise>
		                        </c:choose>
		                        <div class="card-info">
		                            <h4>${design.designName}</h4>
		                            <p>
		                                <fmt:formatDate value="${design.createdAt}"
		                                    pattern="yyyy.MM.dd" />
		                                저장
		                            </p>
		                        </div>
		                        <div class="card-actions">
		                            <a href="/start-up/design/edit?designId=${design.designId}"
		                                class="btn-action">수정하기</a> <a href="#"
		                                class="btn-action btn-rename"
		                                data-design-id="${design.designId}">이름 변경</a> <a href="#"
		                                class="btn-action btn-delete"
		                                data-design-id="${design.designId}">삭제</a>
		                        </div>
		                    </div>
		                </c:forEach>
		            </div>
		        </c:when>
		        <c:otherwise>
		            <div class="empty-message">저장된 도면이 없습니다.</div>
		        </c:otherwise>
		    </c:choose>
		
		    <%-- 3. 페이지네이션 UI 추가 --%>
		    <div class="pagination-container mt-4 d-flex justify-content-center">
		        <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
		    </div>
		</div>

		<div id="scrappedProjects" class="tab-content">
			<c:choose>
				<c:when test="${not empty likedPosts}">
					<div class="design-grid">
						<c:forEach var="post" items="${likedPosts}">
							<div class="design-card">
								<img src="${post.screenshotUrl}" alt="${post.title}">
								<div class="card-info">
									<h4>${post.title}</h4>
									<p>by ${post.creatorId}</p>
								</div>
								<div class="card-actions">
									<a href="/start-up/show/detail/${post.postId}"
										class="btn-action">보러가기</a>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:when>
				<c:otherwise>
					<div class="empty-message">좋아요한 글이 없습니다.</div>
				</c:otherwise>
			</c:choose>
		</div>
		
	</div>

	<script>
        // 탭 전환 JS
        function openTab(evt, tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tab-link");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(tabName).style.display = "block";
            evt.currentTarget.className += " active";
        }
        
    	 // 모든 이름 변경 버튼에 클릭 이벤트 리스너 추가
        document.querySelectorAll('.btn-rename').forEach(button => {
            button.addEventListener('click', function(event) {
                event.preventDefault();

                const designId = this.dataset.designId;
                const cardElement = this.closest('.design-card');
                const currentNameElement = cardElement.querySelector('h4');
                const currentName = currentNameElement.innerText;

                const newDesignName = prompt('새로운 도면 이름을 입력하세요:', currentName);

                if (newDesignName === null || newDesignName.trim() === '') {
                    return;
                }

                fetch('/start-up/design/rename/' + designId, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ newDesignName: newDesignName })
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('서버 응답이 올바르지 않습니다.');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        alert(data.message);
                        currentNameElement.innerText = newDesignName; // 화면의 이름도 바로 변경
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('이름 변경 요청 중 오류:', error);
                    alert('이름 변경 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                });
            });
        });
        
     // 모든 삭제 버튼에 클릭 이벤트 리스너 추가
        document.querySelectorAll('.btn-delete').forEach(button => {
            button.addEventListener('click', function(event) {
                event.preventDefault(); // a 태그의 기본 동작 방지

                const designId = this.dataset.designId;
                const cardElement = this.closest('.design-card');
                const designName = cardElement.querySelector('h4').innerText;

                if (confirm('"' + designName + '" 도면을 정말로 삭제하시겠습니까?')) {
                    
                    fetch('/start-up/design/delete/' + designId, {
                        method: 'POST'
                    })
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('서버 응답이 올바르지 않습니다.');
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            alert(data.message);
                            // ✅ [수정] 카드만 지우는 대신, 페이지 전체를 새로고침합니다.
                            location.reload(); 
                        } else {
                            alert(data.message);
                        }
                    })
                    .catch(error => {
                        console.error('삭제 요청 중 오류:', error);
                        alert('삭제 처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                    });
                }
            });
        });  
    </script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>