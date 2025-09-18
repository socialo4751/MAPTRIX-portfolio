<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>공지사항 ${mode == 'update' ? '수정' : '등록'}</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet" />
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/adminstyle.css">
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<div id="wrapper">
		<%@ include file="/WEB-INF/views/include/adminSideBar.jsp"%>

		<div id="content">
			<div class="main-container">

				<!-- ✅ 페이지 헤더 -->
				<div class="admin-header mb-4">
					<h2>
						<i class="bi bi-megaphone-fill me-2"></i> 공지사항 ${mode == 'update' ? '수정' : '등록'}
					</h2>
					<p>※ 관리자 규정에 맞게 작성하여주세요.</p>
				</div>

				<!-- ✅ 작성 폼 -->
				<form id="noticeForm"
					action="${pageContext.request.contextPath}/admin/notice/${mode == 'update' ? 'update' : 'insert'}"
					method="post" enctype="multipart/form-data"
					class="border rounded p-4 bg-white">

					<c:if test="${mode == 'update'}">
						<input type="hidden" name="postId" value="${notice.postId}" />
					</c:if>

					<!-- 기존 파일 그룹 번호 (그대로 유지) -->
					<input type="hidden" id="editorGroupNo" name="fileGroupNo"
						value="${not empty notice.fileGroupNo ? notice.fileGroupNo : 0}" />

					<!-- [ADD] CKEditor 전용 임시 그룹 번호 (초기 0) -->
					<input type="hidden" name="ckFileGroupNo" id="ckFileGroupNo"
						value="0" />

					<!-- 카테고리 + 제목 -->
					<div class="row mb-3">
						<div class="col-md-3">
							<label class="form-label fw-semibold">카테고리</label> <select
								name="catCodeId" class="form-select form-select-sm" required>
								<c:forEach var="c" items="${codeDetails}">
									<option value="${c.codeId}"
										<c:if test="${not empty notice.catCodeId && notice.catCodeId == c.codeId}">selected</c:if>>
										${c.codeName}</option>
								</c:forEach>
							</select>

						</div>
						<div class="col-md-9">
							<label class="form-label fw-semibold">제목</label> <input
								type="text" name="title" class="form-control form-control-sm"
								placeholder="제목을 입력해주세요" value="${fn:escapeXml(notice.title)}" />
						</div>
					</div>

					<!-- 본문 -->
					<div class="mb-3" style="max-width: 100%;">
						<label class="form-label fw-semibold">내용</label>
						<textarea id="editor" name="content" rows="10"
							class="form-control">${fn:escapeXml(notice.content)}</textarea>
					</div>

					<%-- ★ [수정] 기존 첨부파일 삭제 UI --%>
					<c:if test="${mode == 'update' && not empty files}">
						<div class="mb-3">
							<label class="form-label fw-semibold">기존 첨부파일 (삭제할 파일을
								체크하세요)</label>
							<div id="existing-files">
								<c:forEach var="file" items="${files}">
									<div class="form-check">
										<input class="form-check-input" type="checkbox"
											name="deletedFileSns" value="${file.fileSn}"
											id="delFile_${file.fileSn}"> <label
											class="form-check-label" for="delFile_${file.fileSn}">
											<i class="bi bi-paperclip me-1 text-secondary"></i> <a
											href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
											class="text-decoration-none">${file.fileOriginalName}</a> <span
											class="text-muted small">(${file.fileFancysize})</span>
										</label>
									</div>
								</c:forEach>
							</div>
						</div>
					</c:if>

					<%-- ★ [수정] 신규 파일 다중 업로드 --%>
					<div class="mb-3">
						<label class="form-label fw-semibold">첨부파일</label> <input
							type="file" name="attachment"
							class="form-control form-control-sm" style="max-width: 50%;"
							multiple>
						<%-- multiple 속성 추가 --%>
						<div class="form-text">여러 개의 파일을 선택할 수 있습니다. (Ctrl 키를 누르고
							선택)</div>
					</div>

					<!-- 버튼 -->
					<div class="d-flex justify-content-end gap-2">
						<button type="button" class="btn btn-secondary btn-sm"
							onclick="history.back()">
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
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>
<script>
  const uploadUrl = '${pageContext.request.contextPath}/image/upload';

  // CK 업로드 그룹 캐시(해당 폼 세션에서 재사용)
  let ckNoticeGroupCache = 0;

  ClassicEditor.create(document.querySelector('#editor'), {
    simpleUpload: { uploadUrl }
  }).then(editor => {
    editor.plugins.get('FileRepository').createUploadAdapter = loader => {
      return {
        upload() {
          return loader.file.then(file => {
            const data = new FormData();
            data.append('upload', file);

            // ★ 기존 fileGroupNo로 보내지 말고 CK 전용 그룹을 사용(없으면 0 → 서버가 새 그룹 생성)
            const hiddenCk = parseInt(document.getElementById('ckFileGroupNo').value || '0', 10);
            const sendGroupNo = ckNoticeGroupCache || hiddenCk || 0;
            data.append('editorGroupNo', sendGroupNo);

            return fetch(uploadUrl, { method: 'POST', body: data })
              .then(res => res.json())
              .then(json => {
                // 서버가 배정한 새 그룹 번호 동기화
                ckNoticeGroupCache = json.groupNo;
                document.getElementById('ckFileGroupNo').value = json.groupNo;

                // ★ 폼의 fileGroupNo도 새 그룹으로 교체 → 저장 후 기존 detail은 자연히 안 보임
                document.getElementById('editorGroupNo').value = json.groupNo;

                return { default: json.url };
              });
          });
        }
      };
    };
  });
</script>

	<style>
#editor {
	min-height: 400px;
}

.ck-editor__editable_inline {
	min-height: 400px;
	width: 100% !important; /* 👉 최대 너비로 확장 */
}
</style>
</body>
</html>
