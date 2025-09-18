<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- JSTL Core 태그 사용 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- JSTL 포맷 태그 사용 -->
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!-- JSTL 함수 태그 사용 -->
<!DOCTYPE html>
<html lang="ko"> <!-- 문서 언어 설정 -->
<head>
    <meta charset="UTF-8"> <!-- 문자 인코딩 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> <!-- IE 호환 모드 -->
    <meta name="viewport" content="width=device-width, initial-scale=1"> <!-- 반응형 웹을 위한 뷰포트 설정 -->
    <title>Q&A</title> <!-- 페이지 제목 -->
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <%@ include file="/WEB-INF/views/include/top.jsp" %> <!-- 상단바 포함 -->
    <link rel="stylesheet" href="/css/style.css">
    <!--

        부트스트랩은 클래스명에 이름을 붙이면 적용이 됩니다.

        예) <div class="card-footer d-flex justify-content-end gap-2 bg-white px-4 py-3">
            └ <div class="card-footer (카드 컴포넌트 기본 클래스) d-flex (Flexbox 컨테이너로 설정)
            justify-content-end(Flexbox 오른쪽으로 정렬) gap-2(간격 2[8px]만큼 넓힘 bg-white(배경색 하얀색으로) px-4 (좌우패딩 24px씩) py-3(상하 패딩 16xp씩)">

            이런식으로 클래스명을 달면 부트스트랩내에 있는 속성들이 적용됩니다.
            어떻게 해야하는지 잘 모르겠으면 지피티또는 최예찬에게 말해주세요.
        -->
</head>
<body>
<!-- 사이드바 -->
<!-- 메인 콘텐츠 -->
<div class="content">
    <c:set var="activeMenu" value="notice"/> <!-- 사이드바.jsp에 가면 액티브메뉴가 있는데 거기에 있는 밸류로 변경하면 해당 메뉴를 클릭했을때 활성화 됩니다. -->
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>
    <div class="content-wrapper">
        <div>
            <div class="card-header bg-white border-bottom px-4 py-4 d-flex justify-content-between align-items-center">
                <div>
                    <h4 class="m-0 fw-bold fs-2">반갑다</h4>
                    <div class="text-muted mt-2">
                        <span>카테고리: [기술문의]</span> |
                        <span>작성자: 최**</span> |
                        <span>2025.07.18</span>
                    </div>
                </div>
            </div>

            <div class="card-body px-4 py-4" style="font-size: 16px; line-height: 1.8;">
                안녕하십니까 반갑습니다.안녕하십니까 반갑습니다...안녕하십니까 반갑습니다.안녕하십니까 반갑습니다...안녕하십니까 반갑습니다.안녕하십니까 반갑습니다...안녕하십니까 반갑습니다.안녕하십니까
                반갑습니다...안녕하십니까 반갑습니다.안녕하십니까 반갑습니다...
            </div>
            <!-- 버튼 -->
            <div class="card-footer d-flex justify-content-end gap-2 bg-white px-4 py-3">
                <a href="/qnaList" class="btn btn-secondary btn-sm">목록</a>
                <a href="/qnaEdit?id=${qna.id}" class="btn btn-outline-primary btn-sm">수정</a>
                <form action="/qnaDelete" method="post" onsubmit="return confirm('삭제하시겠습니까?')">
                    <input type="hidden" name="id" value="${qna.id}">
                    <button type="submit" class="btn btn-outline-danger btn-sm">삭제</button>
                </form>
            </div>
        </div>
    </div>
</div>


<!-- Bootstrap JS 번들 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>