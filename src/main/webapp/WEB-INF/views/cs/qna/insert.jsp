<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Q&A ${mode eq 'update' ? '수정' : '작성'}</title>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/csstyle.css">
    <style>
        .card-body {
			border: solid 1px #ccc;
            border-radius: 5px;
        }
    </style>
</head>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>
<div class="container">
    <c:set var="activeMenu" value="inquiry"/>
    <c:set var="activeSub" value="qna"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>
    <main>
        <!-- form 시작 -->
        <form
                action="${pageContext.request.contextPath}/cs/qna/${mode eq 'update' ? 'update' : 'insert'}"
                method="post" enctype="multipart/form-data">

            <c:if test="${mode eq 'update'}">
                <input type="hidden" name="quesId" value="${qna.quesId}"/>
            </c:if>

            <%-- ▼▼▼ 여기에 id="editorGroupNo" 속성을 추가해주세요 ▼▼▼ --%>
            <input type="hidden" name="fileGroupNo" id="editorGroupNo"
                   value="${not empty qna.fileGroupNo ? qna.fileGroupNo : 0}"/>

            <!-- [ADD] CKEditor 전용 임시 그룹 번호 (초기 0) -->
            <input type="hidden" name="ckFileGroupNo" id="ckFileGroupNo"
                   value="0"/>

            <div class="card-header bg-white border-bottom"
                 style="padding: 50px; background: linear-gradient(90deg, #0a3d62); border-radius: 5px;">
                <h4 class="m-0 text-white"
                    style="font-size: 40px; font-weight: bolder;">질의응답(Q&A)
                    ${mode eq 'update' ? '수정' : '작성'}</h4>
                <h5 class="m-0 text-white pt-4">
                    ※ 운영취지에 위반되는 게시물은 관리자에 의해 삭제될 수 있습니다.<br> <br> ※ 많은 분들이
                    문의하신 질문은 FAQ에 등록하였습니다.<br> <br> ※ 보다 정확한 답변을 원하실 경우
                    첨부파일을 등록해주세요.
                </h5>
            </div>

            <div class="card-body">

                <!-- 카테고리 및 제목 -->
                <div
                        class="filter-bar mb-3 d-flex flex-wrap align-items-center gap-2">
                    <%-- 수정 후: JSTL forEach를 사용한 동적 카테고리 생성 --%>
                    <select name="catCodeId" id="categorySelect"
                            class="form-select form-select-sm" style="width: 150px;">
                        <%-- 컨트롤러에서 받은 qnaTags 목록을 반복하여 option 태그를 생성 --%>
                        <c:forEach var="tag" items="${qnaTags}">
                            <option value="${tag.codeId}"
                                ${qna.catCodeId == tag.codeId ? 'selected' : ''}>
                                    ${tag.codeName}</option>
                        </c:forEach>
                    </select>

                    <div class="d-flex align-items-center gap-2 flex-grow-1"
                         style="min-width: 0;">
                        <input type="text" name="title"
                               class="form-control form-control-sm" placeholder="제목을 입력해주세요."
                               value="${fn:escapeXml(qna.title)}"/>
                        <div
                                class="form-check form-switch d-flex align-items-center ms-3"
                                style="white-space: nowrap;">
                            <!-- 서버에 전달되는 값 -->
                            <input type="hidden" name="publicYn" id="publicYnHidden"
                                   value="${qna.publicYn eq 'Y' ? 'Y' : 'N'}"/>

                            <!-- 체크박스는 name 없이 UI용 -->
                            <input type="checkbox" class="form-check-input"
                                   id="publicYnCheckbox" ${qna.publicYn eq 'N' ? 'checked' : ''}>

                            <label class="form-check-label mb-0 ms-2" for="publicYn"
                                   style="font-weight: bold; padding-top: 4px;">비공개</label>
                        </div>
                    </div>
                </div>

                <!-- 내용 -->
                <textarea id="editor" name="content" placeholder="내용을 입력해주세요.">
                    <c:out value="${qna.content}" escapeXml="false"/>
                </textarea>

                <%-- ★ [수정] 기존 첨부파일 (단순 정보 표시용으로 변경) --%>
                <c:if test="${mode eq 'update' and not empty files}">
                    <div class="mb-3 mt-4">
                        <label class="form-label fw-semibold">현재 첨부파일</label>
                        <div id="existing-files">
                            <c:forEach var="file" items="${files}">
                                <div>
                                        <%-- 체크박스 제거 --%>
                                    <i class="material-icons align-middle">attach_file</i> <a
                                        href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                                        class="text-decoration-none"> ${file.fileOriginalName} </a> <span
                                        class="text-muted small">(${file.fileFancysize})</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <%-- ★ [수정] 파일 업로드 UI --%>
                <div class="mb-3 mt-3">
                    <label for="fileInput"
                           class="form-label fw-semibold">${mode eq 'update' ? '새 첨부파일' : '첨부파일'}</label>
                    <input class="form-control" type="file" id="fileInput"
                           name="attachment" multiple/>
                    <%-- 다중 업로드 허용 --%>
                    <div class="form-text">
                        <c:if test="${mode eq 'update'}">
								<span class="text-primary">※ 새 파일을 첨부하면 기존 파일은 모두 새로운 파일로
									대체됩니다.</span>
                            <br>
                        </c:if>
                        여러 개의 파일을 선택할 수 있습니다.
                    </div>
                </div>

                <!-- 버튼 -->
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <button type="button" class="btn btn-secondary btn-sm"
                            onclick="history.back();">취소
                    </button>
                    <button type="submit" class="btn btn-success btn-sm">저장</button>
                </div>
            </div>
        </form>

    </main>
</div>

<!-- Bootstrap JS, CKEditor -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script
        src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>
<script>
    const uploadUrl = '${pageContext.request.contextPath}/image/upload';

    // CK 업로드 그룹 캐시(해당 폼 세션 동안 재사용)
    let ckGroupCache = 0;

    ClassicEditor.create(document.querySelector('#editor'), {
        simpleUpload: {uploadUrl: uploadUrl}
    }).then(editor => {
        editor.plugins.get('FileRepository').createUploadAdapter = loader => {
            return {
                upload() {
                    return loader.file.then(file => {
                        const data = new FormData();
                        data.append('upload', file);

                        // ★ 기존 fileGroupNo(=editorGroupNo)로 보내지 말 것!
                        //    ck 전용 그룹 번호(있으면 재사용, 없으면 0 → 서버가 새 그룹 생성)
                        const hiddenCk = parseInt(document.getElementById('ckFileGroupNo').value || '0', 10);
                        const sendGroupNo = ckGroupCache || hiddenCk || 0;
                        data.append('editorGroupNo', sendGroupNo);

                        return fetch(uploadUrl, {method: 'POST', body: data})
                            .then(res => res.json())
                            .then(json => {
                                // 서버가 배정한 새 그룹 번호 동기화
                                ckGroupCache = json.groupNo;
                                document.getElementById('ckFileGroupNo').value = json.groupNo;

                                // ★ 폼의 fileGroupNo도 새 그룹으로 교체 → 저장 시 이전 detail은 자연히 안 보임
                                document.getElementById('editorGroupNo').value = json.groupNo;

                                return {default: json.url};
                            });
                    });
                }
            };
        };
    });
</script>
<script>
    const checkbox = document.getElementById('publicYnCheckbox');
    const hidden = document.getElementById('publicYnHidden');

    checkbox.addEventListener('change', function () {
        hidden.value = this.checked ? 'N' : 'Y';
    });

    // ✅ 폼이 처음 로드될 때도 값 확실히 설정
    window.addEventListener('DOMContentLoaded', function () {
        hidden.value = checkbox.checked ? 'N' : 'Y';
    });
</script>


</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>
