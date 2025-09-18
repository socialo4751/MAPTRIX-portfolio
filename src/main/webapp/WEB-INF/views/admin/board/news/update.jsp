<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>뉴스 수정</title>
    
    <script src="https://cdn.ckeditor.com/ckeditor5/41.4.2/classic/ckeditor.js"></script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminstyle.css">
    <style>
        .ck-editor__editable {
            min-height: 300px;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>

<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>
    <div id="content">
        <div class="main-container">
            <div class="admin-header mb-4">
                <h2>뉴스 수정</h2>
                <p>기존 뉴스를 편집하거나 네이버 뉴스 API를 통해 새 내용으로 갱신할 수 있습니다.</p>
            </div>

            <div class="panel">
                <h3>네이버 뉴스 API 검색</h3>
                <div class="d-flex gap-2 mb-3">
                    <input type="text" id="naver-search-keyword" class="form-control"
                           placeholder="검색할 뉴스 키워드를 입력하세요">
                    <button type="button" class="btn btn-success"
                            style="min-width: 80px;" onclick="searchNaverNews()">검색</button>
                </div>
                <div class="search-results-container">
                    <div id="naver-news-results" class="news-results-grid">
                        <div class="no-results-message">검색 키워드를 입력하고 검색 버튼을 클릭하세요.</div>
                    </div>
                </div>
                <div class="text-end mt-3">
                    <button type="button" class="btn btn-success"
                            onclick="autoFillManualForm()">선택된 뉴스 자동입력</button>
                </div>
            </div>

            <form id="manualNewsForm" action="/admin/news/update" method="POST"
                  class="mt-5" enctype="multipart/form-data">

                <input type="hidden" name="newsId" value="${newsPost.newsId}">

                <div class="mb-3">
                    <label for="manual-catCodeId" class="form-label">카테고리</label>
                    <select id="manual-catCodeId" name="catCodeId" class="form-select">
                        <option value="NW101" ${newsPost.catCodeId == 'NW101' ? 'selected' : ''}>정치</option>
                        <option value="NW102" ${newsPost.catCodeId == 'NW102' ? 'selected' : ''}>사회</option>
                        <option value="NW103" ${newsPost.catCodeId == 'NW103' ? 'selected' : ''}>경제</option>
                        <option value="NW104" ${newsPost.catCodeId == 'NW104' ? 'selected' : ''}>문화</option>
                        <option value="NW105" ${newsPost.catCodeId == 'NW105' ? 'selected' : ''}>기타</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="manual-title" class="form-label">제목</label>
                    <input type="text" id="manual-title" name="title" class="form-control"
                           value="${newsPost.title}" required>
                </div>
                
                <div class="mb-3">
                    <label for="manual-press" class="form-label">언론사</label>
                    <input type="text" id="manual-press" name="press" class="form-control"
                           value="${newsPost.press}" required>
                </div>
                <div class="mb-3">
                    <label for="manual-publishedAt" class="form-label">작성일 (YYYYMMDD)</label>
                    <input type="text" id="manual-publishedAt" name="publishedAt" class="form-control"
                           value="<fmt:formatDate value='${newsPost.publishedAt}' pattern='yyyyMMdd'/>" required>
                </div>
                <div class="mb-3">
                    <label for="manual-content" class="form-label">본문 내용</label>
                    <textarea id="manual-content" name="content" class="form-control">${newsPost.content}</textarea>
                </div>
                
                <input type="hidden" name="fileGroupNo" value="${newsPost.fileGroupNo}">
                <input type="hidden" name="apiNewsId" id="manual-apiNewsId" value="${newsPost.apiNewsId}">
                <input type="hidden" id="manual-linkUrl" name="linkUrl" value="${newsPost.linkUrl}">
                
                <div class="button-group">
                    <button type="button" class="btn btn-secondary" onclick="location.href='/admin/news/detail?newsId=${newsPost.newsId}';">취소</button>
                    <button type="submit" class="btn btn-primary">수정</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
'use strict';
let editor;

// ===================================================================
// [수정] form.js에 있던 MyUploadAdapter 클래스를 그대로 가져옵니다.
// ===================================================================
class MyUploadAdapter {
    constructor(loader) { this.loader = loader; }
    upload() {
        return this.loader.file.then(file => new Promise((resolve, reject) => {
            const formData = new FormData();
            formData.append('upload', file);

            // form.js와 동일하게, 기존에 사용하시던 이미지 업로드 컨트롤러 경로를 사용합니다.
            fetch('/comm/news/image/upload', { method: 'POST', body: formData })
                .then(response => response.ok ? response.json() : Promise.reject(response))
                .then(data => {
                    if (data.uploaded) {
                        // 수정 페이지에서는 fileGroupNo를 직접 다루지 않으므로 관련 로직은 제거합니다.
                        resolve({ default: data.url });
                    } else {
                        reject(data.error ? data.error.message : 'Unknown upload error');
                    }
                })
                .catch(error => { console.error('Upload failed', error); reject(error); });
        }));
    }
    abort() { }
}

// ===================================================================
// [수정] form.js와 동일한 방식으로 CKEditor를 초기화하고 어댑터를 적용합니다.
// ===================================================================
ClassicEditor
    .create(document.querySelector('#manual-content'), { language: 'ko' })
    .then(newEditor => {
        console.log('CKEditor가 성공적으로 초기화되었습니다.');
        editor = newEditor;
        // 직접 만든 MyUploadAdapter를 사용하도록 설정합니다.
        editor.plugins.get('FileRepository').createUploadAdapter = (loader) => new MyUploadAdapter(loader);
        console.log('Custom Upload Adapter가 적용되었습니다.');
    })
    .catch(error => console.error('CKEditor 초기화 중 오류가 발생했습니다:', error));

    
    let selectedNewsItemForManual = null;

    function initializeForUpdate() {
        // ===================================================================
        // [수정 2] JavaScript 오류를 발생시키는 원인입니다.
        // '.board-header' 라는 클래스가 이 페이지에 존재하지 않아 null 에러가 발생합니다.
        // 또한 이 코드는 제목을 바꾸는 역할인데, 이미 JSP에서 제목을 '뉴스 수정'으로
        // 잘 표시하고 있으므로 불필요하여 삭제합니다.
        // ===================================================================
        // document.querySelector('.board-header h2').textContent = '뉴스 수정';
    }

    // --- 나머지 JavaScript 함수 (getMediaName, cleanHtmlText 등)는 기존과 동일하게 유지 ---
	// 언론사명 매핑 함수 (기존과 동일)
	function getMediaName(url) {
		if (!url) return '알 수 없음';
		try {
			const urlObj = new URL(url);
			let hostname = urlObj.hostname.toLowerCase();
			const mediaMap = { 'chosun.com': '조선일보', 'joongang.co.kr': '중앙일보', 'donga.com': '동아일보', 'hani.co.kr': '한겨레', 'hankookilbo.com': '한국일보', 'seoul.co.kr': '서울신문', 'kyunghyang.com': '경향신문', 'kmib.co.kr': '국민일보', 'munhwa.com': '문화일보', 'segye.com': '세계일보', 'mk.co.kr': '매일경제', 'hankyung.com': '한국경제', 'sedaily.com': '서울경제', 'fnnews.com': '파이낸셜뉴스', 'asiae.co.kr': '아시아경제', 'heraldcorp.com': '헤럴드경제', 'edaily.co.kr': '이데일리', 'etnews.com': '전자신문', 'businesspost.co.kr': '비즈니스포스트', 'yonhapnews.co.kr': '연합뉴스', 'newsis.com': '뉴시스', 'kbs.co.kr': 'KBS', 'mbc.co.kr': 'MBC', 'sbs.co.kr': 'SBS', 'jtbc.co.kr': 'JTBC', 'tvchosun.com': 'TV조선', 'channel-a.com': '채널A', 'mbn.co.kr': 'MBN', 'ytn.co.kr': 'YTN', 'news.naver.com': '네이버뉴스', 'news.daum.net': '다음뉴스', 'nocutnews.co.kr': '노컷뉴스', 'ohmynews.com': '오마이뉴스', 'pressian.com': '프레시안', 'news1.kr': '뉴스1', 'newspim.com': '뉴스핌', 'cnbnews.com': 'CNB뉴스', 'goodmorningcc.com': '굿모닝충청', 'joongdo.co.kr': '중도일보' };
			for (const [domain, name] of Object.entries(mediaMap)) { if (hostname.includes(domain)) { return name; } }
			hostname = hostname.replace(/^(www\.|m\.|news\.)/, '');
			const parts = hostname.split('.');
			if (parts.length >= 2) {
				let mediaName = parts[0];
				if (mediaName === 'news' && parts.length > 1) { mediaName = parts[1]; }
				return mediaName.charAt(0).toUpperCase() + mediaName.slice(1);
			}
			return hostname;
		} catch (e) { console.warn("언론사 추출 실패:", url, e); return '알 수 없음'; }
	}

	function cleanHtmlText(htmlString) {
		if (!htmlString) return '';
		const tempDiv = document.createElement('div');
		tempDiv.innerHTML = htmlString;
		let text = tempDiv.textContent || tempDiv.innerText || '';
		text = text.replace(/&nbsp;/g, ' ');
		text = text.replace(/\s+/g, ' ');
		text = text.trim();
		return text;
	}

	async function searchNaverNews() {
		const keyword = document.getElementById('naver-search-keyword').value.trim();
		const resultsContainer = document.getElementById('naver-news-results');
		if (!keyword) { alert('검색할 키워드를 입력해주세요.'); document.getElementById('naver-search-keyword').focus(); return; }
		resultsContainer.innerHTML = '<div class="loading-message">뉴스 검색 중...</div>';
		try {
			const response = await fetch('/comm/news/searchNews', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: 'keyword=' + encodeURIComponent(keyword) });
			if (!response.ok) { const errorText = await response.text(); throw new Error(`서버 오류 (${response.status}): ${errorText}`); }
			const data = await response.json();
			renderSearchResults(data);
		} catch (error) { console.error('네이버 뉴스 검색 중 오류 발생:', error); resultsContainer.innerHTML = `<div class="no-results-message" style="color: red;">뉴스 검색에 실패했습니다.<br>오류: ${error.message}</div>`; }
	}

	function renderSearchResults(data) {
		const resultsContainer = document.getElementById('naver-news-results');
		resultsContainer.innerHTML = '';
		if (!data || !data.items || data.items.length === 0) { resultsContainer.innerHTML = '<div class="no-results-message">검색 결과가 없습니다.</div>'; return; }
		const sortedItems = data.items.sort((a, b) => { const dateA = new Date(a.pubDate); const dateB = new Date(b.pubDate); return dateB - dateA; });
		sortedItems.forEach((item, index) => {
			const title = cleanHtmlText(item.title);
			const description = cleanHtmlText(item.description);
			const press = getMediaName(item.link);
			let pubDateForInput = '';
			let pubDateFormattedForDisplay = '';
			try {
				const dateObj = new Date(item.pubDate);
				const year = dateObj.getFullYear();
				const month = String(dateObj.getMonth() + 1).padStart(2, '0');
				const day = String(dateObj.getDate()).padStart(2, '0');
				const hours = String(dateObj.getHours()).padStart(2, '0');
				const minutes = String(dateObj.getMinutes()).padStart(2, '0');
				pubDateForInput = `${year}${month}${day}`;
				pubDateFormattedForDisplay = `${year}-${month}-${day} ${hours}:${minutes}`;
			} catch (e) { console.warn("날짜 파싱 실패:", item.pubDate, e); pubDateForInput = ''; pubDateFormattedForDisplay = item.pubDate; }
			const cardDiv = document.createElement('div');
			cardDiv.className = 'news-card';
			cardDiv.innerHTML = '<input type="checkbox" name="selectedNews" data-index="' + index + '" onchange="handleNewsSelection(this)" class="news-checkbox">' + '<div class="news-content-wrapper">' + '<div class="news-meta">' + '<span class="news-press">' + press + '</span>' + '<span class="news-date">' + pubDateFormattedForDisplay + '</span>' + '</div>' + '<div class="news-title">' + title + '</div>' + '<div class="news-description">' + description + '</div>' + '<a href="' + item.link + '" target="_blank" rel="noopener noreferrer" class="news-link">원문 보기 →</a>' + '</div>';
			resultsContainer.appendChild(cardDiv);
			const checkbox = cardDiv.querySelector('input[type="checkbox"]');
			checkbox.dataset.newsItem = JSON.stringify({ ...item, cleanTitle: title, cleanDescription: description, parsedPress: press, parsedPubDateForInput: pubDateForInput });
		});
	}

	function handleNewsSelection(checkbox) {
		document.querySelectorAll('#naver-news-results input[name="selectedNews"]').forEach(cb => {
			if (cb !== checkbox) { cb.checked = false; cb.closest('.news-card').classList.remove('selected'); }
		});
		if (checkbox.checked) {
			checkbox.closest('.news-card').classList.add('selected');
			const item = JSON.parse(checkbox.dataset.newsItem);
			selectedNewsItemForManual = item;
		} else { checkbox.closest('.news-card').classList.remove('selected'); selectedNewsItemForManual = null; }
	}

	function autoFillManualForm() {
        if (!selectedNewsItemForManual) { alert('먼저 자동입력할 뉴스를 하나 선택해주세요.'); return; }
        const item = selectedNewsItemForManual;
        document.getElementById('manual-title').value = item.cleanTitle;
        document.getElementById('manual-press').value = item.parsedPress;
        if (editor) { editor.setData(item.cleanDescription); } else { document.getElementById('manual-content').value = item.cleanDescription; }
        document.getElementById('manual-linkUrl').value = item.link;
        document.getElementById('manual-apiNewsId').value = item.link;
        document.getElementById('manual-publishedAt').value = item.parsedPubDateForInput;
        document.getElementById('manual-catCodeId').value = 'NW105';
        alert('선택된 뉴스가 수정 양식에 자동 입력되었습니다. 내용을 확인하고 수정 버튼을 클릭해주세요.');
    }

    window.onload = function() {
        initializeForUpdate();
        document.getElementById('naver-search-keyword').addEventListener('keypress', function(e) { if (e.key === 'Enter') { searchNaverNews(); } });
        document.getElementById('manualNewsForm').addEventListener('submit', function(event) {
            const title = document.getElementById('manual-title').value.trim();
            const press = document.getElementById('manual-press').value.trim();
            // CKEditor의 최신 데이터를 textarea에 반영
            if(editor) {
                document.getElementById('manual-content').value = editor.getData();
            }
            const content = document.getElementById('manual-content').value.trim();
            const catCodeId = document.getElementById('manual-catCodeId').value;
            const publishedAt = document.getElementById('manual-publishedAt').value.trim();
            if (!title || !press || !content || !catCodeId || !publishedAt) {
                alert('카테고리, 제목, 언론사, 작성일, 본문 내용을 모두 입력해주세요.');
                event.preventDefault(); return false;
            }
            if (!/^\d{8}$/.test(publishedAt)) {
                alert('작성일은 YYYYMMDD 형식으로 입력해주세요. (예: 20230728)');
                event.preventDefault(); return false;
            }
            if (!confirm('수정하신 내용으로 뉴스를 업데이트하시겠습니까?')) {
                event.preventDefault(); return false;
            }
            return true;
        });
    };
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>