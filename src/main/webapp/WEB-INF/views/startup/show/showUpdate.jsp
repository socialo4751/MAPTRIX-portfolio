<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>게시물 수정</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <!-- 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>

    <style>
        /* ========= 등록 페이지와 동일 스코프: .post-form-card ========= */

        /* 카드 래핑 */
        .post-form-card {
            max-width: 840px;
            margin: 40px auto;
            border-radius: 12px;
        }

        .post-form-card .card-body {
            padding: 32px;
        }

        /* 헤더 */
        .post-form-card .page-title {
            font-size: 1.75rem;
            color: #333;
            margin: 0 0 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #007bff;
            font-weight: 700;
        }

        /* 폼 공통 */
        .post-form-card .form-group {
            margin-bottom: 20px;
        }

        .post-form-card .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            color: #555;
        }

        .post-form-card .form-group input[type="text"],
        .post-form-card .form-group textarea,
        .post-form-card .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 1rem;
            box-sizing: border-box;
        }

        .post-form-card .form-group textarea {
            min-height: 200px;
            resize: vertical;
        }

        /* 안내 */
        .post-form-card .min-max-info {
            font-size: .85rem;
            color: #777;
            margin-top: 4px;
            display: block;
        }

        .post-form-card .asterisk-red {
            color: #dc3545;
            font-weight: 700;
        }

        .post-form-card .image-count-info {
            font-size: .9rem;
            color: #555;
            margin-left: 5px;
            font-weight: 400;
        }

        /* 파일 입력 숨김 */
        .post-form-card .hidden-file-input {
            display: none;
        }

        /* 미리보기 */
        .post-form-card .image-preview-area {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
            min-height: 120px;
            border: 1px dashed #ccc;
            border-radius: 6px;
            padding: 10px;
            justify-content: center;
            align-items: center;
            background: #fcfcfc;
        }

        .post-form-card .image-slot,
        .post-form-card .add-image-slot {
            position: relative;
            width: 120px;
            height: 120px;
            border: 2px solid #eee;
            border-radius: 6px;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #f0f0f0;
            flex-shrink: 0;
            color: #aaa;
            font-size: .9em;
            text-align: center;
            cursor: grab;
        }

        .post-form-card .image-slot img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* 삭제 버튼 */
        .post-form-card .remove-image-btn {
            position: absolute;
            top: 6px;
            right: 6px;
            background: rgba(0, 0, 0, .6);
            color: #fff;
            border: none;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: .8em;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            z-index: 10;
        }

        .post-form-card .remove-image-btn:hover {
            background: rgba(0, 0, 0, .8);
        }

        /* 썸네일 강조 */
        .post-form-card .image-slot.is-thumbnail {
            border: 2px solid #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, .5);
        }

        .post-form-card .thumbnail-indicator {
            position: absolute;
            bottom: 6px;
            left: 6px;
            background: rgba(0, 123, 255, .85);
            color: #fff;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: .75em;
            font-weight: 700;
            white-space: nowrap;
        }

        /* + 버튼 */
        .post-form-card .add-image-slot {
            cursor: pointer;
            background: #e9ecef;
            border: 2px dashed #ced4da;
            font-size: 3em;
            color: #6c757d;
        }

        .post-form-card .add-image-slot:hover {
            background: #dee2e6;
            border-color: #adb5bd;
        }

        /* 버튼 그룹 */
        .post-form-card .button-group {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 24px;
        }

        .post-form-card .btn-submit {
            background: #007bff;
            color: #fff;
        }

        .post-form-card .btn-submit:hover {
            background: #0056b3;
        }

        .post-form-card .btn-cancel {
            background: #6c757d;
            color: #fff;
        }

        .post-form-card .btn-cancel:hover {
            background: #5a6268;
        }

        /* Sortable 유령 */
        .post-form-card .sortable-ghost {
            opacity: .6;
            border: 2px dashed #007bff;
        }

        /* 기존 파일 삭제 표시(선택 시) */
        .post-form-card .image-slot.existing-file.selected-for-delete {
            border-color: #dc3545;
            opacity: .7;
        }

        .post-form-card .image-slot.existing-file.selected-for-delete::before {
            content: "\f00d";
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            font-size: 3em;
            color: rgba(220, 53, 69, .85);
            background: rgba(255, 255, 255, .6);
            border-radius: 50%;
            padding: 10px;
            z-index: 5;
            pointer-events: none;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<main class="container-xxl py-4">
    <section class="post-form-card card custom-shadow">
        <div class="card-body">
            <h1 class="page-title">게시물 수정</h1>

            <form id="postForm" action="<c:url value='/start-up/show/update'/>" method="post"
                  enctype="multipart/form-data">
                <!-- 필수 hidden -->
                <input type="hidden" name="postId" value="${post.postId}"/>
                <input type="hidden" name="fileGroupNo" value="${post.fileGroupNo}"/>

                <!-- 제목 -->
                <div class="form-group">
                    <label for="postTitle">제목</label>
                    <input type="text" id="postTitle" name="title" value="${post.title}" required>
                </div>

                <!-- 내용 -->
                <div class="form-group">
                    <label for="postContent">내용</label>
                    <textarea id="postContent" name="content" required>${post.content}</textarea>
                </div>

                <!-- 디자인 선택 -->
                <div class="form-group">
                    <label for="designId">디자인 선택</label>
                    <select id="designId" name="designId" required>
                        <option value="">-- 선택 --</option>
                        <c:forEach var="design" items="${designList}">
                            <option value="${design.designId}" ${design.designId eq post.designId ? 'selected' : ''}>${design.designName}</option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">
            <span class="min-max-info">
              <span class="asterisk-red">※</span> 자랑게시판 게시글은 2D 시뮬레이터에서 저장한 디자인 파일 하나를 반드시 등록해야 합니다.<br>
              &nbsp;&nbsp;게시글 수정을 위해 필요 시
              <a href="#" onclick="alert('2D 시뮬레이터 페이지로 이동합니다.'); return false;">2D 시뮬레이터에서 디자인을 저장</a>해주세요.
            </span>
                    </small>
                </div>

                <!-- 이미지 첨부 -->
                <div class="form-group">
                    <label>이미지 첨부 <span id="imageCountDisplay" class="image-count-info">( 0/5 )</span></label>
                    <span class="min-max-info"><span class="asterisk-red">※</span> 최소 1개, 최대 5개 첨부 가능</span>

                    <!-- 숨김 input -->
                    <input type="file" id="newFiles" name="newFiles" accept="image/*" multiple
                           class="hidden-file-input">
                    <!-- 통합 미리보기 -->
                    <div id="imagesPreviewContainer" class="image-preview-area"></div>
                </div>

                <!-- 해시태그 -->
                <div class="form-group">
                    <label for="postHashtags">해시태그</label>
                    <input type="text" id="postHashtags" name="hashtags" placeholder="#까페, #10평대, #모던인테리어 (쉼표로 구분)"
                           value="${post.hashtags}">
                    <small class="form-text text-muted">
                        <span class="min-max-info"><span
                                class="asterisk-red">※</span> 해시태그는 쉼표( , )로 구분하여 입력해주세요.</span>
                    </small>
                </div>

                <!-- 버튼 -->
                <div class="button-group">
                    <c:url var="cancelUrl" value="/start-up/show/detail/${post.postId}"/>
                    <button type="button" class="btn btn-cancel" onclick="location.href='${cancelUrl}'">취소</button>
                    <button type="submit" class="btn btn-submit">수정 완료</button>
                </div>
            </form>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script>
    (function () {
        const fileInput = document.getElementById('newFiles');          // 새 파일 input
        const previewContainer = document.getElementById('imagesPreviewContainer');
        const imageCountDisplay = document.getElementById('imageCountDisplay');
        const MAX_IMAGES = 5;

        // 통합 상태: 기존 + 신규
        // { isNew:boolean, file?:File, fileSn?:number, filePath?:string, isDeleted?:boolean }
        let selectedFiles = [];

        // 초기 로드: 기존 파일 주입
        document.addEventListener('DOMContentLoaded', () => {
            <c:forEach items="${post.fileDetailList}" var="file">
            selectedFiles.push({
                isNew: false,
                fileSn: parseInt("${file.fileSn}"),
                filePath: '<c:url value="${file.fileSaveLocate}"/>',
                isDeleted: false
            });
            </c:forEach>
            renderImagePreviews();
            updateImageCountDisplay();
        });

        // '+' 클릭 → 파일선택
        previewContainer.addEventListener('click', (e) => {
            if (e.target.closest('.add-image-slot')) fileInput.click();
        });

        // 파일 선택
        fileInput.addEventListener('change', () => {
            const newly = Array.from(fileInput.files);
            let added = 0;

            newly.forEach(newFile => {
                const dup = selectedFiles.some(f => f.isNew && f.file.name === newFile.name && f.file.size === newFile.size);
                const validCount = selectedFiles.filter(f => !f.isDeleted).length;
                if (!dup) {
                    if (validCount < MAX_IMAGES) {
                        selectedFiles.push({isNew: true, file: newFile, isDeleted: false});
                        added++;
                    } else {
                        alert('최대 ' + MAX_IMAGES + '개까지만 이미지를 첨부할 수 있습니다. (기존+신규 포함)');
                        return;
                    }
                }
            });

            if (added > 0) updateAndRender();
            else if (newly.length > 0) alert('추가할 수 있는 새 파일이 없거나 모두 중복입니다.');

            fileInput.value = ''; // 동일 파일 재선택 허용
        });

        // 새 파일만 input에 반영 (제출 직전 호출)
        function updateFileInput() {
            const dt = new DataTransfer();
            selectedFiles.filter(f => f.isNew && !f.isDeleted).forEach(f => dt.items.add(f.file));
            fileInput.files = dt.files;
        }

        function updateAndRender() {
            renderImagePreviews();
            updateImageCountDisplay();
        }

        function updateImageCountDisplay() {
            const count = selectedFiles.filter(f => !f.isDeleted).length;
            imageCountDisplay.textContent = "( " + count + " / " + MAX_IMAGES + " )";
        }

        // 미리보기 렌더
        async function renderImagePreviews() {
            previewContainer.innerHTML = '';

            const visible = selectedFiles.filter(f => !f.isDeleted);
            const slots = await Promise.all(visible.map((item, visibleIndex) => new Promise((resolve) => {
                const slot = document.createElement('div');
                slot.className = 'image-slot';
                if (!item.isNew) {
                    slot.classList.add('existing-file');
                    slot.dataset.fileSn = item.fileSn;
                }

                const img = document.createElement('img');
                img.alt = 'Image Preview';

                const removeBtn = document.createElement('button');
                removeBtn.className = 'remove-image-btn';
                removeBtn.type = 'button';
                removeBtn.innerHTML = '<i class="fas fa-times"></i>';

                // 클릭 시 해당 '보이는' 인덱스를 기준으로 삭제 처리
                removeBtn.addEventListener('click', () => {
                    const target = visible[visibleIndex];
                    const idx = selectedFiles.indexOf(target);
                    if (idx > -1) {
                        if (selectedFiles[idx].isNew) selectedFiles.splice(idx, 1);
                        else selectedFiles[idx].isDeleted = true;
                        updateAndRender();
                    }
                });

                if (item.isNew) {
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        img.src = e.target.result;
                        slot.appendChild(img);
                        slot.appendChild(removeBtn);
                        resolve(slot);
                    };
                    reader.readAsDataURL(item.file);
                } else {
                    img.src = item.filePath;
                    slot.appendChild(img);
                    slot.appendChild(removeBtn);
                    resolve(slot);
                }
            })));

            slots.forEach(slot => previewContainer.appendChild(slot));

            // + 버튼
            if (selectedFiles.filter(f => !f.isDeleted).length < MAX_IMAGES) {
                const addSlot = document.createElement('div');
                addSlot.className = 'add-image-slot';
                addSlot.innerHTML = '<i class="fas fa-plus"></i>';
                addSlot.style.cursor = 'pointer';
                previewContainer.appendChild(addSlot);
            } else if (selectedFiles.filter(f => !f.isDeleted).length === 0) {
                previewContainer.innerHTML = '<p class="file-status-message">이미지를 선택해주세요 (드래그앤드롭으로 순서 변경)</p>';
            }

            updateThumbnailIndicator();
        }

        // 썸네일 배지: 첫 슬롯
        function updateThumbnailIndicator() {
            Array.from(previewContainer.children).forEach(child => {
                child.classList.remove('is-thumbnail');
                const badge = child.querySelector('.thumbnail-indicator');
                if (badge) badge.remove();
            });
            const first = previewContainer.querySelector('.image-slot');
            if (first) {
                first.classList.add('is-thumbnail');
                const badge = document.createElement('span');
                badge.className = 'thumbnail-indicator';
                badge.textContent = '썸네일';
                first.appendChild(badge);
            }
        }

        // 정렬 (삭제되지 않은 항목들만 대상으로 순서 변경)
        new Sortable(previewContainer, {
            animation: 150, ghostClass: 'sortable-ghost', draggable: '.image-slot',
            onEnd: (e) => {
                if (e.oldIndex === e.newIndex) return;

                const visible = selectedFiles.filter(f => !f.isDeleted);
                const [moved] = visible.splice(e.oldIndex, 1);
                visible.splice(e.newIndex, 0, moved);

                const rebuilt = [];
                let vIdx = 0;
                selectedFiles.forEach(item => {
                    if (item.isDeleted) rebuilt.push(item);
                    else rebuilt.push(visible[vIdx++]);
                });
                selectedFiles = rebuilt;
                updateAndRender();
            }
        });

        // 제출
        document.getElementById('postForm').addEventListener('submit', (e) => {
            // 삭제 대상 SN hidden 주입
            const deleteFileSnsInput = document.createElement('input');
            deleteFileSnsInput.type = 'hidden';
            deleteFileSnsInput.name = 'deleteFileSns';
            deleteFileSnsInput.value = selectedFiles.filter(f => f.isDeleted && !f.isNew).map(f => f.fileSn).join(',');
            e.target.appendChild(deleteFileSnsInput);

            // 새 파일 반영
            updateFileInput();

            // 밸리데이션
            const finalCount = selectedFiles.filter(f => !f.isDeleted).length;
            if (document.getElementById('postTitle').value.trim() === '') {
                alert('제목을 입력해주세요.');
                e.preventDefault();
                return;
            }
            if (document.getElementById('postContent').value.trim() === '') {
                alert('내용을 입력해주세요.');
                e.preventDefault();
                return;
            }
            if (document.getElementById('designId').value === '') {
                alert('디자인을 선택해주세요.');
                e.preventDefault();
                return;
            }
            if (finalCount === 0) {
                alert('이미지를 최소 1개 이상 첨부해주세요.');
                e.preventDefault();
                return;
            }
            if (document.getElementById('postHashtags').value.trim() === '') {
                alert('해시태그를 입력해주세요.');
                e.preventDefault();
                return;
            }
        });
    })();
</script>
</body>
</html>
