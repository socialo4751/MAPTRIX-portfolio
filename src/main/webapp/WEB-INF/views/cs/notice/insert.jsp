<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>공지사항 ${mode=='update' ? '수정' : '작성'}</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/csstyle.css">
	
</head>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
<body>
	<div class="container">
		<c:set var="activeMenu" value="notice" />
		<%@ include file="/WEB-INF/views/include/csSideBar.jsp"%>

		<main>
			<div class="card mb-4">

				<div class="card-header bg-white border-bottom"
					style="padding: 50px; background: linear-gradient(90deg, #0a3d62); border-radius: 5px;">
					<h4 class="m-0 text-white"
						style="font-size: 40px; font-weight: bolder;">공지사항
						${mode=='update' ? '수정' : '작성'}</h4>
					<h5 class="m-0 text-white pt-4">※ 관리자 규정에 맞게 작성하여주세요.</h5>
				</div>

				<%-- ▼▼▼ 폼 태그에 삭제 버튼을 위한 id 추가 ▼▼▼ --%>
				<form id="noticeForm"
					action="${pageContext.request.contextPath}/cs/notice/${mode=='update' ? 'update' : 'insert'}"
					method="post" enctype="multipart/form-data">
					<div class="card-body">

						<%-- 수정 모드일 때 필요한 숨겨진 필드들 --%>
						<c:if test="${mode=='update'}">
							<input type="hidden" name="postId" value="${notice.postId}" />
						</c:if>

						<!-- 기존 파일 그룹 번호 -->
						<input type="hidden" name="fileGroupNo" id="fileGroupNo"
							value="${not empty notice.fileGroupNo ? notice.fileGroupNo : 0}" />

						<!-- [ADD] CKEditor 전용 임시 그룹 번호 (초기 0) -->
						<input type="hidden" name="ckFileGroupNo" id="ckFileGroupNo"
							value="0" />

						<div
							class="filter-bar mb-3 d-flex flex-wrap align-items-center gap-2">
							<select name="catCodeId" class="form-select form-select-sm"
								style="width: 150px;">
								<c:forEach var="code" items="${categoryList}">
									<option value="${code.codeId}"
										${notice.catCodeId == code.codeId ? 'selected' : ''}>
										${code.codeName}</option>
								</c:forEach>
							</select>
							<div class="d-flex align-items-center gap-2 flex-grow-1"
								style="min-width: 0;">
								<div style="flex: 1 1 auto; min-width: 0;">
									<input type="text" name="title"
										class="form-control form-control-sm"
										style="height: 38px; width: 100%;" placeholder="제목을 입력해주세요."
										value="${fn:escapeXml(notice.title)}" />
								</div>
							</div>
						</div>

						<textarea id="editor" name="content" placeholder="내용을 입력해주세요"><c:out
								value="${notice.content}" escapeXml="false" /></textarea>

						<%-- ★ [수정] 기존 첨부파일 (단순 정보 표시용으로 변경) --%>
						<c:if test="${mode=='update' and not empty files}">
							<div class="mb-3 mt-3">
								<label class="form-label fw-semibold">현재 첨부파일</label>
								<div id="existing-files">
									<c:forEach var="file" items="${files}">
										<div>
											<%-- 체크박스 제거 --%>
											<i class="material-icons align-middle"
												style="font-size: 1.1rem;">attach_file</i> <a
												href="${pageContext.request.contextPath}/download?fileName=${fn:replace(file.fileSaveLocate, '/media/', '')}"
												class="text-decoration-none"> ${file.fileOriginalName} </a>
											<span class="text-muted small">(${file.fileFancysize})</span>
										</div>
									</c:forEach>
								</div>
							</div>
						</c:if>

						<%-- ★ [수정] 신규 파일 업로드 --%>
						<div class="mb-3">
							<label for="fileInput" class="form-label fw-semibold">${mode eq 'update' ? '새 첨부파일' : '첨부파일'}</label>
							<input class="form-control" type="file" id="fileInput"
								name="attachment" style="width: 50%;" multiple />
							<div class="form-text">
								<c:if test="${mode eq 'update'}">
									<span class="text-primary">※ 새 파일을 첨부하면 기존 파일은 모두 새로운
										파일로 대체됩니다.</span>
									<br>
								</c:if>
								여러 개의 파일을 선택할 수 있습니다.
							</div>
						</div>

						<div class="d-flex justify-content-end gap-2">
							<button type="button" class="btn btn-secondary btn-sm"
								onclick="history.back()">취소</button>
							<button type="submit" class="btn btn-success btn-sm">저장</button>
						</div>

					</div>
				</form>

			</div>
		</main>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.ckeditor.com/ckeditor5/31.1.0/classic/ckeditor.js"></script>

<script>
  const uploadUrl = '${pageContext.request.contextPath}/image/upload';

  // CK 업로드 그룹 캐시(해당 폼 세션 동안 재사용)
  let ckNoticeGroupCache = 0;

  ClassicEditor.create(document.querySelector('#editor'), {
    simpleUpload: { uploadUrl: uploadUrl }
  }).then(editor => {
    editor.plugins.get('FileRepository').createUploadAdapter = loader => {
      return {
        upload() {
          return loader.file.then(file => {
            const data = new FormData();
            data.append('upload', file);

            // ★ 기존 fileGroupNo로 보내지 말고,
            //    ck 전용 그룹 번호(있으면 재사용, 없으면 0 → 서버가 새 그룹 생성)
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
                document.getElementById('fileGroupNo').value = json.groupNo;

                return { default: json.url };
              });
          });
        }
      };
    };
  });
</script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</html>