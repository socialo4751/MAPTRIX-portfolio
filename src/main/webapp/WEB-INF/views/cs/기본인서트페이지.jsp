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
    <!-- 사용자 정의 스타일 -->
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
<!-- 메인 콘텐츠 -->
<div class="content">
    <c:set var="activeMenu" value="notice"/> <!-- 사이드바.jsp에 가면 액티브메뉴가 있는데 거기에 있는 밸류로 변경하면 해당 메뉴를 클릭했을때 활성화 됩니다. -->
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>
    <div class="content-wrapper">
        <div> <!-- 카드 컨테이너 -->
            <div class="card-header bg-white border-bottom"
                 style="padding: 50px; background: linear-gradient(90deg, #198754); border-radius: 5px; margin-bottom: 15px;">
                <h4 class="m-0 text-white" style="font-size: 40px; font-weight: bolder;">공지사항 작성</h4><h5
                    class="m-0 text-white" style="padding-top: 40px;">
                ※ 관리자 규정에 맞게 작성하여주세요.
            </h5>
            </div>
            <div class="card-body">

                <!-- 필터 영역 -->
                <div class="filter-bar mb-3 d-flex flex-wrap align-items-center gap-2">
                    <select class="form-select form-select-sm" style="width: 150px;">
                        <option value="">전체</option>
                        <option value="general">일반</option>
                        <option value="tech">이벤트</option>
                        <option value="account">공지</option>
                        <option value="etc">기타</option>
                    </select>
                    <div class="d-flex align-items-center gap-2 flex-grow-1" style="min-width: 0;">
                        <div style="flex: 1 1 auto; min-width: 0;">
                            <input type="text" class="form-control form-control-sm" style="height: 38px; width: 100%;"
                                   placeholder="제목을 입력해주세요.">
                        </div>
                    </div>
                </div>
                <textarea id="editor" name="content" placeholder="내용을 입력해주세요."></textarea>
                <div class="mb-3 ">
                    <label for="fileInput" class="form-label fw-semibold">첨부파일</label>
                    <div class="d-flex align-items-center gap-2">
                        <input class="form-control" type="file" id="fileInput" name="attachment" style="width: 50%;">
                        <div class="ms-auto d-flex gap-2">
                            <button class="btn btn-secondary btn-sm" style="height: 38px; width: 80px;">취소</button>
                            <button class="btn btn-success btn-sm" style="height: 38px; width: 80px;">저장</button>
                        </div>
                    </div>
                    <div class="form-text">파일은 최대 1개까지 업로드 가능합니다. (예: 이미지, PDF 등)</div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- ✅ 2. Bootstrap, Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<!-- ✅ CKEditor 5 CDN -->
<script src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>

<script>
    ClassicEditor
        .create(document.querySelector('#editor'))
        .catch(error => {
            console.error(error);
        });
</script>
</body>
</html>