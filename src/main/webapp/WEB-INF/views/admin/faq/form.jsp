<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>FAQ ${mode == 'update' ? '수정' : '등록'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">

            <!-- 헤더 -->
            <div class="admin-header mb-4">
                <h2><i class="bi bi-question-circle-fill me-2"></i> FAQ ${mode == 'update' ? '수정' : '등록'}</h2>
                <p>※ 관리자 규정에 맞게 작성해 주세요.</p>
            </div>

            <!-- 작성 폼 -->
            <form id="faqForm"
                  class="border rounded p-4 bg-white"
                  action="${pageContext.request.contextPath}/admin/faq/${mode == 'update' ? 'update' : 'insert'}"
                  method="post"
                  enctype="multipart/form-data"> <!-- ★ 첨부/이미지 필수 -->


                <c:if test="${mode == 'update'}">
                    <input type="hidden" name="faqId" value="${faq.faqId}"/>
                </c:if>

                <!-- ★ 파일그룹 번호 (본문 이미지/첨부 묶음용) -->
                <input type="hidden" id="editorGroupNo" name="fileGroupNo"
                       value="${not empty faq.fileGroupNo ? faq.fileGroupNo : 0}"/>
                <input type="hidden" id="ckFileGroupNo" name="ckFileGroupNo" value="0"/>

                <!-- 카테고리 + 제목 -->
                <div class="row mb-3">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">카테고리</label>
                        <select name="catCodeId" class="form-select form-select-sm" required>
                            <c:forEach var="c" items="${codeDetails}">
                                <option value="${c.codeId}"
                                        <c:if test="${not empty faq.catCodeId && faq.catCodeId == c.codeId}">selected</c:if>>
                                        ${c.codeName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-9">
                        <label class="form-label fw-semibold">제목</label>
                        <input type="text"
                               name="title"
                               class="form-control form-control-sm"
                               placeholder="제목을 입력해주세요"
                               value="${fn:escapeXml(faq.title)}"
                               required/>
                    </div>
                </div>

                <!-- 본문 -->
                <div class="mb-3" style="max-width: 100%;">
                    <label class="form-label fw-semibold">내용</label>
                    <textarea id="editor" name="content" rows="10" class="form-control" required>
                        ${fn:escapeXml(faq.content)}
                    </textarea>
                </div>

                <!-- (수정 모드일 때) 기존 첨부 표시 (옵션) -->
                <c:if test="${mode == 'update' && not empty files}">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">기존 첨부파일</label>
                        <ul class="list-unstyled mb-0">
                            <c:forEach var="file" items="${files}" varStatus="s">
                                <li class="mb-1">
                                    <i class="bi bi-paperclip me-1 text-secondary"></i>
                                    <a href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
                                       class="text-decoration-none">
                                        붙임${s.index + 1}. ${file.fileOriginalName}
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <!-- 버튼 -->
                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="history.back()">
                        <i class="bi bi-x-circle"></i> 취소
                    </button>
                    <button type="submit" class="btn btn-success btn-sm">
                        <i class="bi bi-save"></i> 저장
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Script -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>
<script>
    // CKEditor 업로드 엔드포인트 (공지와 동일하게 사용)
    const uploadUrl = '${pageContext.request.contextPath}/image/upload';
    let ckGroupCache = 0;

    ClassicEditor.create(document.querySelector('#editor'), {
        simpleUpload: {uploadUrl} // 기본 업로드 플러그인 활성화
    }).then(editor => {
        // 서버에 editorGroupNo도 같이 보내기 위해 업로드 어댑터 커스터마이즈
        editor.plugins.get('FileRepository').createUploadAdapter = loader => ({
            upload() {
                return loader.file.then(file => {
                    const data = new FormData();
                    data.append('upload', file);

                    // CK 전용 그룹 번호(없으면 0 → 서버가 새 그룹 발급)
                    const hiddenCk = parseInt(document.getElementById('ckFileGroupNo').value || '0', 10);
                    const sendGroupNo = ckGroupCache || hiddenCk || 0;
                    data.append('editorGroupNo', sendGroupNo);

                    return fetch(uploadUrl, {method: 'POST', body: data})
                        .then(res => res.json())
                        .then(json => {
                            // 서버가 부여한 그룹번호 동기화
                            ckGroupCache = json.groupNo;
                            document.getElementById('ckFileGroupNo').value = json.groupNo;
                            // 본문 이미지가 하나라도 있으면 그 그룹을 최종 fileGroupNo로 사용
                            document.getElementById('editorGroupNo').value = json.groupNo;
                            return {default: json.url};
                        });
                });
            }
        });
    }).catch(console.error);
</script>

<style>
    #editor {
        min-height: 400px;
    }

    .ck-editor__editable_inline {
        min-height: 400px;
        width: 100% !important;
    }
</style>
</body>
</html>
