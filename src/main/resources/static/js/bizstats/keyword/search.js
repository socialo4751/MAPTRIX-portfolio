let chart;

// 페이지가 처음 로드될 때 실행
document.addEventListener('DOMContentLoaded', function () {
    if (window.initialData && window.initialData.length > 0) {
        // 초기 데이터가 있으면 해당 데이터로 차트와 테이블을 그림
        initializePageWithData(window.initialKeyword, window.initialData);
    } else {
        // 없으면 빈 차트만 그림
        drawChart([]);
    }
});

// 초기화 및 데이터로 UI를 채우는 함수
function initializePageWithData(keyword, data) {
    document.getElementById('resultContainer').style.display = 'block';
    document.getElementById('searchedKeyword').textContent = `"${keyword}"`;
    document.getElementById('keywordInput').value = keyword;

    const seriesData = createSeriesData(data);
    drawChart(seriesData);
    updateRankingTable(data);
}

// 데이터를 Highcharts 시리즈 형식으로 변환하는 함수
function createSeriesData(data) {
    const rankColors = ['#ffb3ba', '#ffdfba', '#ffffba', '#baffc9', '#bae1ff', '#f1cbff', '#ffb3ba', '#ffdfba', '#ffffba', '#baffc9', '#bae1ff', '#f1cbff', '#ffb3ba', '#ffdfba', '#ffffba', '#baffc9', '#bae1ff', '#f1cbff', '#ffb3ba', '#ffdfba'];
    return data.map((item, index) => ({
        name: item.name, // 범례에 표시될 이름
        color: rankColors[index % rankColors.length],
        data: [{
            name: item.name,
            value: item.value,
            custom: item.custom
        }]
    }));
}

// 차트를 그리는 함수 (plotOptions 수정)
function drawChart(seriesData) {
    chart = Highcharts.chart('chart-container', {
        chart: { type: 'packedbubble' },
        title: { text: null },
        tooltip: {
            useHTML: true,
            pointFormat: '<b>{point.name}</b><br>총 검색량: {point.value:,}<br>PC: {point.custom.pc}<br>모바일: {point.custom.mobile}'
        },
        
		legend: {
            enabled: true,
            align: 'center',
            verticalAlign: 'bottom',
            layout: 'horizontal',
            y: 20
		},
        
		plotOptions: {
            packedbubble: {
                // 여러 시리즈를 한 곳에 모으기 위해 layoutAlgorithm 옵션을 제거 (Highcharts 기본값 사용)
                minSize: '35%',
                maxSize: '165%',
                dataLabels: {
                    enabled: true,
                    format: '{point.name}',
                    style: {
                        color: 'black',
                        textOutline: 'none',
                        fontWeight: 'bold',
                        fontSize: '14px'
                    }
                }
            }
        },
        series: seriesData,
        credits: { enabled: false }
    });
}

// '분석하기' 버튼 클릭 시 실행
async function startSearch(event) {
    event.preventDefault();
    const keyword = document.getElementById('keywordInput').value;
    if (!keyword) return;

    document.getElementById('searchBtn').disabled = true;
    if (chart) chart.showLoading('데이터 분석 중...');

    try {
        const response = await fetch(`/api/biz-stats/naver-keywords`, {
            method: 'POST',
            body: new URLSearchParams(new FormData(document.getElementById('searchForm')))
        });
        if (!response.ok) throw new Error(await response.text());
        
        const receivedData = await response.json();
        
        // 검색 결과로 UI 업데이트
        initializePageWithData(keyword, receivedData);
        /*chart.setTitle({ text: `"${keyword}" 연관 키워드 분석 (Top 20)` });*/

    } catch (error) {
        alert('데이터를 가져오는 데 실패했습니다: ' + error.message);
    } finally {
        if (chart) chart.hideLoading();
        document.getElementById('searchBtn').disabled = false;
    }
}

// 순위 테이블을 업데이트하는 함수
function updateRankingTable(data) {
    const tableBody = document.getElementById('ranking-body');
    tableBody.innerHTML = '';
    if (data.length === 0) {
        tableBody.innerHTML = '<tr><td colspan="3" style="text-align:center;">연관어 데이터가 없습니다.</td></tr>';
        return;
    }
    data.forEach((item, index) => {
        // ▼▼▼ 순위에 따라 클래스 이름을 동적으로 변경 ▼▼▼
        const rankClass = index < 5 ? 'rank' : 'rank-secondary'; // 5위까지는 'rank', 그 이하는 'rank-secondary'
        
        const row = `
		<tr>
		        <td class="rank">${index + 1}</td>
		        <td>
		            <span class="related-keyword" onclick="analyzeRelatedKeyword('${item.name}')">
		                ${item.name}
		            </span>
		        </td>
		        <td class="count">${item.value}</td>
		    </tr>
        `;
        // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
        tableBody.innerHTML += row;
    });
}
/**
 * 연관어 순위 목록에서 키워드를 클릭했을 때 실행되는 함수
 * @param {string} keyword - 클릭된 연관어
 */
function analyzeRelatedKeyword(keyword) {
    const keywordInput = document.getElementById('keywordInput');
    keywordInput.value = keyword;

    const searchForm = document.getElementById('searchForm');
    // 기존 submit() 대신 requestSubmit() 사용
    searchForm.requestSubmit();  
}

// 초기화 함수
function resetPage() {
    document.getElementById('searchForm').reset();
    document.getElementById('resultContainer').style.display = 'none';
    drawChart([]); // 차트 초기화
    document.getElementById('ranking-body').innerHTML = ''; // 테이블 초기화
}