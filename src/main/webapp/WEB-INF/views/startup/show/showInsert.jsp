<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 게시물 등록</title>

    <!-- 부트스트랩 & 아이콘 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <!-- Font Awesome (한 번만) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <!-- 공통 CSS (프로젝트 전역) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>

    <style>
        /* ========= 페이지 전용: 범위를 .post-form-card 하위로 한정 ========= */

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
            margin: 0 0 20px 0;
            padding-bottom: 12px;
            border-bottom: 2px solid #007bff;
            font-weight: 700;
        }

        /* 폼 그룹 간격 */
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

        /* 안내 문구 */
        .post-form-card .min-max-info {
            font-size: 0.85rem;
            color: #777;
            margin-top: 4px;
            display: block;
        }
        .post-form-card .asterisk-red {
            color: #dc3545;
            font-weight: 700;
        }
        .post-form-card .image-count-info {
            font-size: 0.9rem;
            color: #555;
            margin-left: 5px;
            font-weight: 400;
        }

        /* 파일 입력 숨김 */
        .post-form-card .hidden-file-input { display: none; }

        /* 미리보기 영역 */
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
            background-color: #fcfcfc;
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
            background-color: #f0f0f0;
            flex-shrink: 0;
            color: #aaa;
            font-size: 0.9em;
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
            background-color: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            border-radius: 50%;
            width: 22px;
            height: 22px;
            font-size: 0.8em;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            z-index: 10;
        }
        .post-form-card .remove-image-btn:hover {
            background-color: rgba(0, 0, 0, 0.8);
        }

        /* 썸네일 강조 */
        .post-form-card .image-slot.is-thumbnail {
            border: 2px solid #007bff;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.5);
        }
        .post-form-card .thumbnail-indicator {
            position: absolute;
            bottom: 6px;
            left: 6px;
            background-color: rgba(0, 123, 255, 0.85);
            color: white;
            padding: 3px 8px;
            border-radius: 5px;
            font-size: 0.75em;
            font-weight: 700;
            white-space: nowrap;
        }

        /* + 버튼 */
        .post-form-card .add-image-slot {
            cursor: pointer;
            background-color: #e9ecef;
            border: 2px dashed #ced4da;
            font-size: 3em;
            color: #6c757d;
        }
        .post-form-card .add-image-slot:hover {
            background-color: #dee2e6;
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
            background-color: #007bff;
            color: #fff;
        }
        .post-form-card .btn-submit:hover {
            background-color: #0056b3;
        }
        .post-form-card .btn-cancel {
            background-color: #6c757d;
            color: #fff;
        }
        .post-form-card .btn-cancel:hover {
            background-color: #5a6268;
        }

        /* Sortable 드래그시 유령 요소 */
        .post-form-card .sortable-ghost {
            opacity: .6;
            border: 2px dashed #007bff;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top.jsp" %>

<main class="container-xxl py-4">
    <section class="post-form-card card custom-shadow">
        <div class="card-body">
            <h1 class="page-title">게시물 등록</h1>

            <form id="postForm" action="<c:url value='/start-up/show/insert'/>" method="post" enctype="multipart/form-data">
                <!-- 제목 -->
                <div class="form-group">
                    <label for="postTitle">제목</label>
                    <input type="text" id="postTitle" name="title" placeholder="제목을 입력하세요" required>
                </div>

                <!-- 내용 -->
                <div class="form-group">
                    <label for="postContent">내용</label>
                    <textarea id="postContent" name="content" placeholder="내용을 입력하세요" required></textarea>
                </div>

                <!-- 디자인 선택 -->
                <div class="form-group">
                    <label for="designId">디자인 선택</label>
                    <select id="designId" name="designId" required>
                        <option value="">-- 선택 --</option>
                        <c:forEach var="design" items="${designList}">
                            <option value="${design.designId}">${design.designName}</option>
                        </c:forEach>
                    </select>
                    <small class="form-text text-muted">
                        <span class="min-max-info">
                            <span class="asterisk-red">※</span>
                            자랑게시판 게시글은 2D 시뮬레이터에서 저장한 디자인 파일 하나를 반드시 등록해야 합니다.<br>
                            &nbsp;&nbsp;게시글 작성을 위해 먼저
							<a href="${pageContext.request.scheme}://${pageContext.request.serverName}:5173/simulator"
							   target="_blank" rel="noopener">
							  2D 시뮬레이터에서 디자인을 생성하고 저장</a>해주세요.
                        </span>
                    </small>
                </div>

                <!-- 이미지 첨부 -->
                <div class="form-group">
                    <label>
                        이미지 첨부 <span id="imageCountDisplay" class="image-count-info">(0/5)</span>
                    </label>
                    <span class="min-max-info">
                        <span class="asterisk-red">※</span> 최소 1개, 최대 5개 첨부 가능
                    </span>
                    <input type="file" id="newFiles" name="newFiles" accept="image/*" multiple class="hidden-file-input">
                    <div id="imagesPreviewContainer" class="image-preview-area"></div>
                </div>

                <!-- 해시태그 -->
                <div class="form-group">
                    <label for="postHashtags">해시태그</label>
                    <input type="text" id="postHashtags" name="hashtags" placeholder="까페, 10평대, 모던인테리어" required>
                    <span class="min-max-info">
                        <span class="asterisk-red">※</span> 해시태그는 쉼표( , )로 구분하여 입력해주세요.
                    </span>
                </div>

                <!-- 버튼 -->
                <div class="button-group">
                    <button type="submit" class="btn btn-submit">등록</button>
                    <button type="button" class="btn btn-cancel" onclick="location.href='<c:url value='/start-up/show'/>'">취소</button>
                </div>
            </form>
        </div>
    </section>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<!-- SortableJS -->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script>
    (function () {
        const fileInput = document.getElementById('newFiles');
        const previewContainer = document.getElementById('imagesPreviewContainer');
        const imageCountDisplay = document.getElementById('imageCountDisplay');
        const MAX_IMAGES = 5;
        let selectedFiles = [];

        document.addEventListener('DOMContentLoaded', () => {
            renderImagePreviews();
            updateImageCountDisplay();
        });

        // '+' 슬롯 클릭 → 파일 선택
        previewContainer.addEventListener('click', (e) => {
            if (e.target.closest('.add-image-slot')) fileInput.click();
        });

        // 파일 선택
        fileInput.addEventListener('change', () => {
            const newlySelectedFiles = Array.from(fileInput.files);
            let filesAddedCount = 0;

            newlySelectedFiles.forEach(newFile => {
                const isDuplicate = selectedFiles.some(existingFile =>
                    existingFile && existingFile.name === newFile.name && existingFile.size === newFile.size
                );
                if (!isDuplicate) {
                    if (selectedFiles.length < MAX_IMAGES) {
                        selectedFiles.push(newFile);
                        filesAddedCount++;
                    } else {
                        alert('최대 ' + MAX_IMAGES + '개까지만 이미지를 첨부할 수 있습니다.');
                        return;
                    }
                }
            });

            if (filesAddedCount > 0) {
                updateAndRender();
            } else if (newlySelectedFiles.length > 0) {
                alert('선택된 파일 중 추가할 수 있는 파일이 없거나 모든 파일이 중복됩니다.');
            }
            fileInput.value = ''; // 동일 파일 재선택 허용
        });

        function updateFileInput() {
            const dt = new DataTransfer();
            selectedFiles.forEach(f => dt.items.add(f));
            fileInput.files = dt.files;
        }

        function updateAndRender() {
            updateFileInput();
            renderImagePreviews();
            updateImageCountDisplay();
        }

        function updateImageCountDisplay() {
            imageCountDisplay.textContent = "( " + selectedFiles.length + " / " + MAX_IMAGES + " )";
        }

        async function renderImagePreviews() {
            previewContainer.innerHTML = '';

            const loadedSlotsPromises = selectedFiles.map((file, index) => {
                return new Promise((resolve) => {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        const slot = document.createElement('div');
                        slot.className = 'image-slot';
                        slot.dataset.index = index;

                        const img = document.createElement('img');
                        img.src = e.target.result;
                        img.alt = "Image Preview";

                        const removeBtn = document.createElement('button');
                        removeBtn.className = 'remove-image-btn';
                        removeBtn.type = 'button';
                        removeBtn.dataset.index = index;
                        removeBtn.innerHTML = '<i class="fas fa-times"></i>';

                        slot.appendChild(img);
                        slot.appendChild(removeBtn);
                        resolve(slot);
                    };
                    reader.readAsDataURL(file);
                });
            });

            const loadedSlots = await Promise.all(loadedSlotsPromises);
            loadedSlots.forEach(slot => previewContainer.appendChild(slot));

            // + 버튼
            if (selectedFiles.length < MAX_IMAGES) {
                const addSlot = document.createElement('div');
                addSlot.className = 'add-image-slot';
                addSlot.innerHTML = '<i class="fas fa-plus"></i>';
                addSlot.style.cursor = 'pointer';
                previewContainer.appendChild(addSlot);
            }

            updateThumbnailIndicator();
        }

        function updateThumbnailIndicator() {
            Array.from(previewContainer.children).forEach(child => {
                child.classList.remove('is-thumbnail');
                const existingBadge = child.querySelector('.thumbnail-indicator');
                if (existingBadge) existingBadge.remove();
            });

            const firstImageSlot = previewContainer.querySelector('.image-slot');
            if (firstImageSlot) {
                firstImageSlot.classList.add('is-thumbnail');
                const badge = document.createElement('span');
                badge.className = 'thumbnail-indicator';
                badge.textContent = '썸네일';
                firstImageSlot.appendChild(badge);
            }
        }

        // 삭제
        previewContainer.addEventListener('click', (e) => {
            const removeBtn = e.target.closest('.remove-image-btn');
            if (!removeBtn) return;

            const indexToRemove = parseInt(removeBtn.dataset.index, 10);
            if (indexToRemove > -1 && indexToRemove < selectedFiles.length) {
                selectedFiles.splice(indexToRemove, 1);
                updateAndRender();
            }
        });

        // 정렬
        new Sortable(previewContainer, {
            animation: 150,
            ghostClass: 'sortable-ghost',
            draggable: '.image-slot',
            onEnd: (e) => {
                if (e.oldIndex === e.newIndex) return;
                const [movedItem] = selectedFiles.splice(e.oldIndex, 1);
                selectedFiles.splice(e.newIndex, 0, movedItem);
                updateAndRender();
            }
        });

        // 제출
        document.getElementById('postForm').addEventListener('submit', async (e) => {
            e.preventDefault();

            if (document.getElementById('postTitle').value.trim() === '') {
                alert('제목을 입력해주세요.'); return;
            }
            if (document.getElementById('postContent').value.trim() === '') {
                alert('내용을 입력해주세요.'); return;
            }
            if (document.getElementById('designId').value === '') {
                alert('디자인을 선택해주세요.'); return;
            }
            if (selectedFiles.length === 0) {
                alert('이미지를 최소 1개 이상 첨부해주세요.'); return;
            }
            if (document.getElementById('postHashtags').value.trim() === '') {
                alert('해시태그를 입력해주세요.'); return;
            }

            const form = e.target;
            const formData = new FormData();
            formData.append('title', form.elements['title'].value);
            formData.append('content', form.elements['content'].value);
            formData.append('designId', form.elements['designId'].value);
            formData.append('hashtags', form.elements['hashtags'].value);
            selectedFiles.forEach(file => formData.append('newFiles', file));

            try {
                const response = await fetch(form.action, { method: 'POST', body: formData });
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    const result = await response.json();
                    alert(result.message || "오류가 발생했습니다.");
                }
            } catch (error) {
                console.error('Error:', error);
                alert("폼 제출 중 오류가 발생했습니다.");
            }
        });
    })();
</script>
</body>
</html>
