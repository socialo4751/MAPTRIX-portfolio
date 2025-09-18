<%-- 파일 위치: src/main/webapp/WEB-INF/views/gemini/analysisHardcodedTest.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>AI 상권 분석 리포트</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome CDN (아이콘) -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    
    <style>
        /* 이 페이지에만 필요한 간단한 스타일 (로더) */
        .loader { 
            border: 4px solid #f3f3f3; 
            /* [핵심 수정] 로더 색상을 녹색 테마로 변경 */
            border-top: 4px solid #1cc88a; 
            border-radius: 50%; 
            width: 40px; 
            height: 40px; 
            animation: spin 1s linear infinite; 
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        th { text-align: left; background-color: #f9fafb; }
    </style>
</head>
<body class="bg-gray-100 flex flex-col items-center min-h-screen p-4">

    <div class="w-full max-w-4xl bg-white rounded-2xl shadow-xl p-8">
        
        <div class="text-center mb-8">
            <%-- [핵심 수정] 제목 텍스트 색상을 공통 스타일의 녹색 계열로 변경 --%>
            <h1 class="text-4xl font-bold text-emerald-600 mb-2">AI 상권 분석 리포트</h1>
            <p class="text-lg text-gray-500 mb-6">
                '다바1234' 격자에 대한 AI 기반 심층 분석
            </p>
            <%-- [핵심 수정] 버튼 배경색을 공통 스타일의 녹색 계열로 변경 --%>
            <button id="runButton" class="bg-emerald-600 text-white font-bold py-3 px-8 rounded-lg hover:bg-emerald-700 transition-transform transform hover:scale-105 text-lg shadow-md">
                <i class="fas fa-brain me-2"></i>분석 리포트 생성
            </button>
        </div>

        <!-- 로딩 및 에러 표시 영역 -->
        <div id="loader" class="flex justify-center items-center py-5 hidden">
            <div class="loader"></div>
        </div>
        <div id="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg relative hidden" role="alert"></div>
        
        <!-- 결과 영역 -->
        <div id="resultArea" class="space-y-8 hidden">
            <!-- 1. 원본 데이터 표시 영역 -->
            <div id="inputDataSection">
                <h2 class="text-2xl font-semibold text-gray-700 mb-3"><i class="fas fa-database mr-2 text-gray-400"></i>분석 대상 데이터</h2>
                <div class="border rounded-lg overflow-hidden">
                    <table id="inputDataTable" class="w-full text-base"></table>
                </div>
            </div>
            <!-- 2. AI 분석 결과 표시 영역 -->
            <div id="analysisResultSection">
                <h2 class="text-2xl font-semibold text-gray-700 mb-3"><i class="fas fa-brain mr-2 text-gray-400"></i>AI 분석 리포트</h2>
                <div class="border rounded-lg overflow-hidden">
                    <table id="analysisTable" class="w-full text-base"></table>
                </div>
            </div>
        </div>
    </div>

<script>
document.getElementById('runButton').addEventListener('click', async function() {
    const loader = document.getElementById('loader');
    const errorDisplay = document.getElementById('error');
    const resultArea = document.getElementById('resultArea');

    // UI 초기화 (Tailwind 클래스에 맞게 수정)
    errorDisplay.classList.add('hidden');
    resultArea.classList.add('hidden');
    loader.classList.remove('hidden');

    try {
        const response = await fetch('/analysis/run-hardcoded', { method: 'POST' });

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || '서버 응답 오류 (HTTP ' + response.status + ')');
        }

        const responseData = await response.json();
        
        createInputDataTable(responseData.inputData);
        createAnalysisTable(responseData.analysisData);
        
        resultArea.classList.remove('hidden');

    } catch (err) {
        console.error('Error:', err);
        errorDisplay.textContent = '오류 발생: ' + err.message;
        errorDisplay.classList.remove('hidden');
    } finally {
        loader.classList.add('hidden');
    }
});

//[핵심 수정] 원본 데이터 표 생성 함수에 분석 모델 정보를 추가합니다.
function createInputDataTable(data) {
    const tableBody = document.createElement('tbody');
    
    // [수정] JSON key 이름에 주의 (pvalue는 소문자)
    const tableContent = [
        { title: '격자 ID', value: data.gridId },
        { title: '분석 모델', value: data.analysisModel + ' (' + data.independentVar + ' → ' + data.dependentVar + ')' },
        { title: 'p-value', value: data.pvalue },
        { title: '주요 행정동 1', value: data.dong1Name + ' (' + data.dong1Ratio + '%)' },
        { title: '주요 행정동 2', value: data.dong2Name + ' (' + data.dong2Ratio + '%)' }
    ];

    tableContent.forEach(function(item) {
        const row = document.createElement('tr');
        row.className = 'border-b';
        row.innerHTML = 
            '<th class="w-1/3 p-4 font-bold text-gray-700">' + item.title + '</th>' +
            '<td class="w-2/3 p-4 text-gray-800">' + item.value + '</td>';
        tableBody.appendChild(row);
    });

    const table = document.getElementById('inputDataTable');
    table.innerHTML = '';
    table.appendChild(tableBody);
}

// AI 분석 결과를 표로 만드는 함수
function createAnalysisTable(data) {
    const table = document.getElementById('analysisTable');
    if (!data || !data.summary) {
        table.innerHTML = '<tr><td colspan="2" class="text-center p-4">AI 분석 결과를 생성하지 못했습니다.</td></tr>';
        return;
    }
    
    const tableBody = document.createElement('tbody');
    const recommendationsHtml = (data.recommendations || []).map(function(rec) {
        // 추천 전략 아이콘 색상을 녹색 계열로 변경
        return '<li class="flex items-start"><i class="fas fa-check text-emerald-500 mr-2 mt-1"></i><span>' + rec + '</span></li>';
    }).join('');

    const tableContent = [
        { title: '핵심 요약', content: data.summary, icon: 'fa-file-alt' },
        { title: '종합 위험도', content: data.riskLevel, icon: 'fa-shield-halved' },
        { title: '긍정적 신호', content: data.positiveSignal, icon: 'fa-thumbs-up' },
        { title: '부정적 신호', content: data.negativeSignal, icon: 'fa-thumbs-down' },
        { title: '추천 전략', content: '<ul class="list-none space-y-2">' + recommendationsHtml + '</ul>', icon: 'fa-lightbulb' }
    ];

    tableContent.forEach(function(item) {
        const row = document.createElement('tr');
        row.className = 'border-b';
        row.innerHTML = 
            '<th class="w-1/4 p-4 font-bold text-gray-700 align-top">' +
                '<div class="flex items-center"><i class="fas ' + item.icon + ' w-5 mr-3 text-gray-400"></i>' + item.title + '</div>' +
            '</th>' +
            '<td class="w-3/4 p-4 text-gray-800">' + item.content + '</td>';
        tableBody.appendChild(row);
    });
    
    table.innerHTML = '';
    table.appendChild(tableBody);
}
</script>
</body>
</html>
