// src/main/resources/static/js/news/form.js 파일의 내용

// 전역 변수 선언
let selectedNewsItemForManual = null;
let manualContentEditor;

// CKEditor 이미지 업로드 처리를 위한 Custom Upload Adapter 클래스 정의
class MyUploadAdapter {
    constructor(loader) { this.loader = loader; }
    upload() {
        return this.loader.file.then(file => new Promise((resolve, reject) => {
            const formData = new FormData();
            formData.append('upload', file);
            fetch('/comm/news/image/upload', { method: 'POST', body: formData })
                .then(response => response.ok ? response.json() : Promise.reject(response))
                .then(data => {
                    if (data.uploaded) {
                        const fileGroupNoInput = document.getElementById('fileGroupNo');
                        if (fileGroupNoInput.value === '0' || fileGroupNoInput.value === '') {
                            fileGroupNoInput.value = data.fileGroupNo;
                            console.log('FileGroupNo가 설정되었습니다:', data.fileGroupNo);
                        }
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

// 페이지 로드 시 실행 (JSP의 window.onload와 동일)
document.addEventListener('DOMContentLoaded', function() {
    ClassicEditor.create(document.querySelector('#manual-content'), { language: 'ko' })
        .then(editor => {
            console.log('CKEditor가 성공적으로 초기화되었습니다.');
            manualContentEditor = editor;
            editor.plugins.get('FileRepository').createUploadAdapter = (loader) => new MyUploadAdapter(loader);
            console.log('Custom Upload Adapter가 적용되었습니다.');
        })
        .catch(error => console.error('CKEditor 초기화 중 오류가 발생했습니다:', error));

    document.getElementById('naver-search-keyword').addEventListener('keypress', (e) => {
        if (e.key === 'Enter') searchNaverNews();
    });

    document.getElementById('manualNewsForm').addEventListener('submit', (event) => {
        if (!manualContentEditor) {
            alert("에디터가 아직 로딩 중입니다. 잠시 후 다시 시도해주세요.");
            event.preventDefault(); return;
        }
        const content = manualContentEditor.getData();
        if (!content || content.trim() === '') {
            alert('본문 내용을 입력해주세요.');
            event.preventDefault(); return;
        }
        const title = document.getElementById('manual-title').value.trim();
        const press = document.getElementById('manual-press').value.trim();
        const publishedAt = document.getElementById('manual-publishedAt').value.trim();
        if (!title || !press || !publishedAt) {
            alert('제목, 언론사, 작성일을 모두 입력해주세요.');
            event.preventDefault(); return;
        }
        if (!/^\d{8}$/.test(publishedAt)) {
            alert('작성일은 YYYYMMDD 형식으로 입력해주세요. (예: 20230728)');
            event.preventDefault(); return;
        }
        if (!confirm('입력하신 내용으로 뉴스를 등록하시겠습니까?')) {
            event.preventDefault();
        }
    });
});

function autoFillManualForm() {
    if (!selectedNewsItemForManual) { alert('먼저 자동입력할 뉴스를 하나 선택해주세요.'); return; }
    const item = selectedNewsItemForManual;
    document.getElementById('manual-title').value = item.cleanTitle;
    document.getElementById('manual-press').value = item.parsedPress;
    document.getElementById('manual-linkUrl').value = item.link;
    document.getElementById('manual-apiNewsId').value = item.link;
    document.getElementById('manual-publishedAt').value = item.parsedPubDateForInput;
    document.getElementById('manual-catCodeId').value = 'NW105';
    if (manualContentEditor) manualContentEditor.setData(item.cleanDescription);
    else document.getElementById('manual-content').value = item.cleanDescription;
    alert('선택된 뉴스가 수동 등록 양식에 자동 입력되었습니다.');
}

async function searchNaverNews() {
    const keyword = document.getElementById('naver-search-keyword').value.trim();
    const resultsContainer = document.getElementById('naver-news-results');
    if (!keyword) {
        alert('검색할 키워드를 입력해주세요.');
        document.getElementById('naver-search-keyword').focus();
        return;
    }
    resultsContainer.innerHTML = '<div class="loading-message">뉴스 검색 중...</div>';
    try {
        const response = await fetch('/comm/news/searchNews', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'keyword=' + encodeURIComponent(keyword)
        });
        if (!response.ok) throw new Error('서버 오류 ' + response.status);
        const data = await response.json();
        renderSearchResults(data);
    } catch (error) {
        console.error('네이버 뉴스 검색 중 오류 발생:', error);
        resultsContainer.innerHTML = `<div class="no-results-message" style="color: red;">뉴스 검색에 실패했습니다.</div>`;
    }
}

function renderSearchResults(data) {
    const resultsContainer = document.getElementById('naver-news-results');
    resultsContainer.innerHTML = '';
    if (!data || !data.items || data.items.length === 0) {
        resultsContainer.innerHTML = '<div class="no-results-message">검색 결과가 없습니다.</div>';
        return;
    }
    const sortedItems = data.items.sort((a, b) => new Date(b.pubDate) - new Date(a.pubDate));
    sortedItems.forEach(item => {
        const title = cleanHtmlText(item.title);
        const description = cleanHtmlText(item.description);
        const press = getMediaName(item.link);
        let pubDateForInput = '', pubDateFormattedForDisplay = '';
        try {
            const d = new Date(item.pubDate);
            const pad = (n) => String(n).padStart(2, '0');
            pubDateForInput = `${d.getFullYear()}${pad(d.getMonth() + 1)}${pad(d.getDate())}`;
            pubDateFormattedForDisplay = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}`;
        } catch (e) { pubDateFormattedForDisplay = item.pubDate; }
        const cardDiv = document.createElement('div');
        cardDiv.className = 'news-card';
        cardDiv.innerHTML = `<input type="checkbox" name="selectedNews" onchange="handleNewsSelection(this)" class="news-checkbox"><div class="news-content-wrapper"><div class="news-meta"><span class="news-press">${press}</span><span class="news-date">${pubDateFormattedForDisplay}</span></div><div class="news-title">${title}</div><div class="news-description">${description}</div><a href="${item.link}" target="_blank" rel="noopener noreferrer" class="news-link">원문 보기 →</a></div>`;
        resultsContainer.appendChild(cardDiv);
        if (cardDiv.querySelector('input[type="checkbox"]')) {
            cardDiv.querySelector('input[type="checkbox"]').dataset.newsItem = JSON.stringify({ ...item, cleanTitle: title, cleanDescription: description, parsedPress: press, parsedPubDateForInput: pubDateForInput });
        }
    });
}

function handleNewsSelection(checkbox) {
    document.querySelectorAll('#naver-news-results input[name="selectedNews"]').forEach(cb => {
        if (cb !== checkbox) {
            cb.checked = false;
            cb.closest('.news-card').classList.remove('selected');
        }
    });
    if (checkbox.checked) {
        checkbox.closest('.news-card').classList.add('selected');
        selectedNewsItemForManual = JSON.parse(checkbox.dataset.newsItem);
    } else {
        checkbox.closest('.news-card').classList.remove('selected');
        selectedNewsItemForManual = null;
    }
}

function cleanHtmlText(htmlString) {
    if (!htmlString) return '';
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlString;
    let text = tempDiv.textContent || tempDiv.innerText || '';
    return text.replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim();
}

function getMediaName(url) {
    if (!url) return '알 수 없음';
    try {
        const urlObj = new URL(url); let hostname = urlObj.hostname.toLowerCase();
        const mediaMap = { 'chosun.com':'조선일보', 'joongang.co.kr':'중앙일보', 'donga.com':'동아일보', 'hani.co.kr':'한겨레', 'hankookilbo.com':'한국일보', 'seoul.co.kr':'서울신문', 'kyunghyang.com':'경향신문', 'kmib.co.kr':'국민일보', 'munhwa.com':'문화일보', 'segye.com':'세계일보', 'mk.co.kr':'매일경제', 'hankyung.com':'한국경제', 'sedaily.com':'서울경제', 'fnnews.com':'파이낸셜뉴스', 'asiae.co.kr':'아시아경제', 'heraldcorp.com':'헤럴드경제', 'edaily.co.kr':'이데일리', 'etnews.com':'전자신문', 'businesspost.co.kr':'비즈니스포스트', 'yonhapnews.co.kr':'연합뉴스', 'newsis.com':'뉴시스', 'kbs.co.kr':'KBS', 'mbc.co.kr':'MBC', 'sbs.co.kr':'SBS', 'jtbc.co.kr':'JTBC', 'tvchosun.com':'TV조선', 'channel-a.com':'채널A', 'mbn.co.kr':'MBN', 'ytn.co.kr':'YTN', 'news.naver.com':'네이버뉴스', 'news.daum.net':'다음뉴스', 'nocutnews.co.kr':'노컷뉴스', 'ohmynews.com':'오마이뉴스', 'pressian.com':'프레시안', 'news1.kr':'뉴스1', 'newspim.com':'뉴스핌' };
        for (const [domain, name] of Object.entries(mediaMap)) { if (hostname.includes(domain)) return name; }
        hostname = hostname.replace(/^(www\.|m\.|news\.)/, '');
        const parts = hostname.split('.');
        if (parts.length >= 2) { let mediaName = parts[0]; if (mediaName === 'news' && parts.length > 1) mediaName = parts[1]; return mediaName.charAt(0).toUpperCase() + mediaName.slice(1); }
        return hostname;
    } catch (e) { console.warn("언론사 추출 실패:", url, e); return '알 수 없음'; }
}