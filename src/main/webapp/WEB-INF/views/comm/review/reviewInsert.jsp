<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>창업 후기 ${mode eq 'update' ? '수정' : '작성'}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/csstyle.css"/>
</head>
<%@ include file="/WEB-INF/views/include/top.jsp" %>
<body>
<div class="container">
    <c:set var="activeMenu" value="review"/>
    <%@ include file="/WEB-INF/views/include/commSideBar.jsp" %>
    <main>
        <form id="reviewForm"
              action="${pageContext.request.contextPath}/comm/review/${mode eq 'update' ? 'update' : 'create'}"
              method="post" enctype="multipart/form-data">

            <c:if test="${mode eq 'update'}">
                <input type="hidden" name="postId" value="${postVO.postId}"/>
            </c:if>

            <%-- 기존 파일 그룹 번호를 전달하는 필드 --%>
            <input type="hidden" name="fileGroupNo" id="fileGroupNo"
                   value="${not empty postVO.fileGroupNo ? postVO.fileGroupNo : 0}"/>

            <%-- ▼▼▼ CKEditor가 생성한 파일 그룹 번호를 저장할 새 hidden input ▼▼▼ --%>
            <!-- [ADD] CKEditor가 새로 만든 그룹 번호를 보관할 전용 필드 -->
            <input type="hidden" name="ckFileGroupNo" id="ckFileGroupNo"
                   value="0"/>
            <!-- 헤더 -->
            <div class="card-header bg-white border-bottom"
                 style="padding: 50px; background: linear-gradient(90deg, #0a3d62); border-radius: 5px; margin-bottom: 15px;">
                <h4 class="m-0 text-white"
                    style="font-size: 40px; font-weight: bolder;">창업 후기 ${mode eq 'update' ? '수정' : '작성'}
                </h4>
                <h5 class="m-0 text-white pt-4">생생한 창업 이야기를 공유해주세요!</h5>
            </div>

            <!-- 본문 -->
            <div class="card-body">
                <!-- 카테고리 및 제목 -->
                <div
                        class="filter-bar mb-3 d-flex flex-wrap align-items-center gap-2">
                    <%-- 수정 후: JSTL forEach를 사용한 동적 카테고리 생성 --%>
                    <select name="catCodeId" id="catCodeId" class="form-select form-select-sm" style="width:150px;"
                            required>
                        <option value="" selected disabled>카테고리 선택</option>
                        <c:forEach var="tag" items="${codeDetails}">
                            <option value="${tag.codeId}" ${postVO.catCodeId == tag.codeId ? 'selected' : ''}>${tag.codeName}</option>
                        </c:forEach>
                    </select>

                    <div class="d-flex align-items-center gap-2 flex-grow-1"
                         style="min-width: 0;">
                        <input type="text" name="title"
                               class="form-control form-control-sm" placeholder="제목을 입력해주세요."
                               value="${fn:escapeXml(postVO.title)}"/>
                    </div>
                </div>

                <!-- 내용 -->
                <textarea id="editor" name="content" placeholder="내용을 입력해주세요.">
                    <c:out value="${postVO.content}" escapeXml="false"/>
                </textarea>

                <%-- ★ [수정] 기존 첨부파일 (단순 정보 표시용으로 변경) --%>
                <c:if test="${mode eq 'update' and not empty existingFiles}">
                    <div class="mb-3 mt-4">
                        <label class="form-label fw-semibold">현재 첨부파일</label>
                        <div id="existing-files-list">
                            <c:forEach var="file" items="${existingFiles}">
                                <div>
                                        <%-- 체크박스 제거 --%>
                                    <i class="material-icons align-middle">attach_file</i> <a
                                        href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}">
                                        ${file.fileOriginalName} </a> <span
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
                           name="attachments" multiple/>
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
                    <button type="submit" class="btn btn-success btn-sm">${mode eq 'update' ? '수정' : '등록'}</button>
                </div>
            </div>
        </form>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<!-- Bootstrap, CKEditor -->
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script
        src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>
<script>
    const uploadUrl = '${pageContext.request.contextPath}/image/upload';

    ClassicEditor
        .create(document.querySelector('#editor'), {
            simpleUpload: {
                uploadUrl: uploadUrl
            }
        })
        .then(editor => {
            editor.plugins.get('FileRepository').createUploadAdapter = loader => {
                return {
                    upload() {
                        return loader.file
                            .then(file => {
                                const data = new FormData();
                                data.append('upload', file);
                                // ★[중요] CKEditor 이미지 업로드 시에는 기존 fileGroupNo를 기준으로 요청합니다.
                                const hiddenCkVal = parseInt(document.getElementById('ckFileGroupNo').value || '0', 10);
                                const sendGroupNo = window.__ckEditorGroupNo || hiddenCkVal || 0;
                                data.append('editorGroupNo', sendGroupNo);

                                return fetch(uploadUrl, {method: 'POST', body: data})
                                    .then(res => res.json())
                                    .then(json => {
                                        window.__ckEditorGroupNo = json.groupNo;
                                        document.getElementById('ckFileGroupNo').value = json.groupNo;

                                        // ★ 폼 제출 시 게시글이 '새 그룹'을 바라보도록 동기화 (이 줄이 핵심)
                                        document.getElementById('fileGroupNo').value = json.groupNo;

                                        return {default: json.url};
                                    });
                            });
                    }
                };
            };
        });


    // 플래시 메시지 alert
    var msg = "${msg}";
    if (msg) alert(msg);
</script>
</body>
</html>
