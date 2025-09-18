// Highcharts 전역 옵션 설정 (어두운 테마)
Highcharts.setOptions({
    chart: {
        // ▼▼▼ 차트 배경을 투명하게 설정 ▼▼▼
        backgroundColor: 'transparent',
        style: {
            fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif'
        }
    },
    // ▼▼▼ 밝은 테마에 맞게 글자색 등 수정 ▼▼▼
    title: { style: { color: '#333333' } },
    legend: { itemStyle: { color: '#333333' } },
    xAxis: {
        labels: { style: { color: '#666666' } },
        lineColor: '#ccd6eb',
        tickColor: '#ccd6eb',
        title: { style: { color: '#666666' } }
    },
    yAxis: {
        labels: { style: { color: '#666666' } },
        gridLineColor: '#e6e6e6',
        title: { style: { color: '#666666' } }
    },
    credits: { enabled: false }
});


// 페이지가 로드되면 모든 차트 로드
document.addEventListener('DOMContentLoaded', function () {
	// 지도 초기화 함수를 호출하도록 변경
	initializeInteractiveMap();
	loadBizTrendChart();     // '3개년 현황' (chart2-container)
    loadSalesRangeChart();   // '매출액 규모' (chart3-container)
    loadStartCloseChart(); 	 // '창업 및 폐업 현황' (chart4-container)
});

// 지도 초기화 및 이벤트 리스너 설정 함수
function initializeInteractiveMap() {
    // Select Bar 엘리먼트를 찾아서 'change' 이벤트 리스너 추가
    const mapSelect = document.getElementById('map-data-select');
    if (mapSelect) { // 엘리먼트가 존재하는지 확인
        mapSelect.addEventListener('change', function() {
            updateMapData(this.value); // Select Bar의 선택된 값으로 지도 업데이트
        });
    }

    // 기본값으로 '자치구별 사업체 현황' 지도를 로드
    updateMapData('districtBusiness');
}


// 3개년 현황 (복합 차트) 로드 함수
async function loadBizTrendChart() {
    try {
        const response = await fetch(`${contextPath}/api/biz-stats/chart/biz-trend-stats`);
        const data = await response.json();

        const categories = data.map(item => item.baseYear + '년');
        const bizCountData = data.map(item => item.bizCount);
        const employeeCountData = data.map(item => item.employeeCount);
        const salesAmountData = data.map(item => item.salesAmount);

        Highcharts.chart('chart2-container', {
            title: { text: null },
            xAxis: [{ categories: categories }],
            yAxis: [
                { // Primary yAxis (왼쪽) - 사업체, 종사자
                    title: { text: '사업체 / 종사자 수' },
                    labels: { format: '{value:,.0f}' }
                }, 
                { // Secondary yAxis (오른쪽) - 매출액
                    title: { text: '매출액 (억원)' },
                    labels: { format: '{value:,.0f} 억' },
                    opposite: true
                }
            ],
            tooltip: { shared: true },
            legend: { align: 'center', verticalAlign: 'bottom' },
            plotOptions: {
                column: { dataLabels: { enabled: true, format: '{point.y:,.0f}' } },
                spline: { dataLabels: { enabled: true, format: '{point.y:,.0f}' } }
            },
            series: [
                { name: '사업체', type: 'column', yAxis: 0, data: bizCountData, color: '#4682B4' }, 
                { name: '종사자', type: 'column', yAxis: 0, data: employeeCountData, color: '#82ccdd' }, 
                { name: '매출액', type: 'spline', yAxis: 1, data: salesAmountData, color: '#f57c00', marker: { lineWidth: 2, lineColor: '#f57c00', fillColor: 'white' } }
            ]
        });
    } catch(error) {
        console.error("3개년 현황 차트 로딩 실패:", error);
    }
}

// 매출액 규모 차트를 로드하는 함수
async function loadSalesRangeChart() {
    try {
        const response = await fetch(`${contextPath}/api/biz-stats/chart/sales-range-stats`);
        const data = await response.json();

        // Highcharts 데이터 형식에 맞게 가공
        const categories = data.map(item => item.salesRange);
        const totalBizData = data.map(item => item.totalBizCount);
        const smallbizData = data.map(item => item.smallbizCount);
        const commonBizData = data.map(item => item.commonBizCount);

        Highcharts.chart('chart3-container', {
            chart: {
                type: 'column' // 막대 그래프
            },
            title: {
                text: null // 패널 제목을 사용하므로 차트 제목은 비움
            },
            xAxis: {
                categories: categories,
                crosshair: true
            },
            yAxis: {
                min: 0,
                title: {
                    text: '사업체 수 (단위: 개)'
                }
            },
            tooltip: {
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:,.0f} 개</b></td></tr>',
                footerFormat: '</table>',
                shared: true,
                useHTML: true
            },
            plotOptions: {
                column: {
                    pointPadding: 0.2,
                    borderWidth: 0,
                    dataLabels: { // 막대 위에 값 표시
                        enabled: true,
                        format: '{point.y:,.0f}', // 천단위 쉼표
                        style: {
                            fontSize: '10px',
                            fontWeight: 'normal'
                        }
                    }
                }
            },
            legend: {
                align: 'center',
                verticalAlign: 'bottom'
            },
            series: [{
                name: '사업체',
                data: totalBizData,
                color: '#FFC107' // 노란색 계열
            }, {
                name: '소상공인',
                data: smallbizData,
                color: '#2196F3' // 파란색 계열
            }, {
                name: '생활밀접업종',
                data: commonBizData,
                color: '#F44336' // 빨간색 계열
            }]
        });

    } catch (error) {
        console.error("매출액 규모 차트 로딩 실패:", error);
    }
}

// 창업/폐업 이중 축 차트를 로드하는 메인 함수
async function loadStartCloseChart() {
    try {
        const response = await fetch('/api/biz-stats/chart/open-close'); // 컨트롤러 주소 확인 필요
        const data = await response.json();

        // Highcharts 데이터 형식에 맞게 가공
        const categories = data.map(item => item.districtName);
        const startupCounts = data.map(item => item.startupCount);
        const closureCounts = data.map(item => item.closureCount);
        const startupRates = data.map(item => item.startupRate);
        const closureRates = data.map(item => item.closureRate);

        Highcharts.chart('chart4-container', {
            chart: { zoomType: 'xy' },
            title: { text: null },
            xAxis: [{ categories: categories }],
            yAxis: [
                { // 첫 번째 Y축 (왼쪽, 막대그래프용)
                    title: { text: '사업체 수 (개)' }
                }, 
                { // 두 번째 Y축 (오른쪽, 점선그래프용)
                    title: { text: '비율 (%)' },
                    opposite: true // 축을 오른쪽에 표시
                }
            ],
            tooltip: { shared: true }, // 여러 데이터를 한 툴팁에 표시
            legend: { align: 'center', verticalAlign: 'bottom' },
            series: [
                {
                    name: '창업 수',
                    type: 'column', // 막대그래프
                    yAxis: 0, // 첫 번째 Y축 사용
                    data: startupCounts,
                    color: '#87CEFA'
                }, {
                    name: '폐업 수',
                    type: 'column',
                    yAxis: 0,
                    data: closureCounts,
                    color: '#FFB6C1'
                }, {
                    name: '창업률',
                    type: 'spline', // 곡선 그래프
                    yAxis: 1, // 두 번째 Y축 사용
                    data: startupRates,
                    color: '#4682B4'
                }, {
                    name: '폐업률',
                    type: 'spline',
                    yAxis: 1,
                    data: closureRates,
                    dashStyle: 'shortdot', // 점선 스타일
                    color: '#DC143C'
                }
            ]
        });

    } catch (error) {
        console.error("창업/폐업 차트 로딩 실패:", error);
    }
}

// 지도 데이터를 동적으로 업데이트하는 메인 함수
async function updateMapData(mapType) {
    const mapContainer = document.getElementById('map-container');
    const summaryContainer = document.querySelector('.map-summary');
    
    if (!mapContainer || !summaryContainer) {
        console.error("필수 컨테이너 요소를 찾을 수 없습니다.");
        return;
    }

    mapContainer.innerHTML = `<div id="map-legend"></div><div id="map-hover-effect"></div>`;
    mapContainer.classList.remove('loaded');

    const hoverEffect = document.getElementById('map-hover-effect');

    let apiUrl, dataKeyForCount, dataKeyForRate, legendHtml, colorFunction;

	if (mapType === 'districtBusiness') {
        apiUrl = `${contextPath}/api/biz-stats/chart/district-business`;
        dataKeyForCount = 'activeCount';
        dataKeyForRate = 'shareRate';
        
        colorFunction = getColorForBusinessCount;
        legendHtml = `
            <h4>범례 (총 사업체 수, 단위: 개)</h4>
            <ul>
                <li><span class="color-box" style="background-color: #0a3d62;"></span>45,000 이상</li>
                <li><span class="color-box" style="background-color: #3c6382;"></span>35,000 ~ 45,000</li>
                <li><span class="color-box" style="background-color: #82ccdd;"></span>25,000 ~ 35,000</li>
                <li><span class="color-box" style="background-color: #f1f2f6;"></span>25,000 미만</li>
            </ul>`;
            
        summaryContainer.classList.add('hidden');

    } else if (mapType === 'smallbizStats') { // ▼▼▼ [추가된 부분] '소상공인' 옵션 처리 ▼▼▼
        apiUrl = `${contextPath}/api/biz-stats/chart/smallbiz-stats`;
        dataKeyForCount = 'bizCount';
        dataKeyForRate = 'shareRate';
        
        colorFunction = getColorForSmallbizCount; // 새로운 색상 함수 사용
        legendHtml = `
            <h4>범례 (소상공인 수, 단위: 개)</h4>
            <ul>
			<li><span class="color-box" style="background-color: #0a3d62;"></span>45,000 이상</li>
            <li><span class="color-box" style="background-color: #3c6382;"></span>30,000 ~ 45,000</li>
            <li><span class="color-box" style="background-color: #82ccdd;"></span>25,000 ~ 30,000</li>
            <li><span class="color-box" style="background-color: #f1f2f6;"></span>25,000 미만</li>
            </ul>`;
            
        summaryContainer.classList.add('hidden');
        
    } else { // commonBusiness
        apiUrl = `${contextPath}/api/biz-stats/chart/biz-common-stats`;
        dataKeyForCount = 'avgSalesAmount';
        dataKeyForRate = 'avgOperatingPeriod';
        
        colorFunction = () => '#0a3d62';
		legendHtml = `[단위: 평균 매출액(억원), 평균영업기간(년)]`;

        summaryContainer.classList.add('hidden');
    }

	try {
        const [svgResponse, dataResponse] = await Promise.all([
            fetch(`${contextPath}/data/svg/Daejeon_sigungu.svg`),
            fetch(apiUrl)
        ]);

        if (!svgResponse.ok) throw new Error('SVG 파일 로딩 실패');
        if (!dataResponse.ok) throw new Error('데이터 로딩 실패');

        const svgText = await svgResponse.text();
        const data = await dataResponse.json();
        
        mapContainer.insertAdjacentHTML('afterbegin', svgText);
        
        const legend = document.getElementById('map-legend');
        legend.innerHTML = legendHtml;
        
        if (mapType === 'commonBusiness') {
            const totalData = data.find(d => d.districtName === '대전시');
            if (totalData) {
                document.getElementById('summary-total-biz').innerHTML = `${totalData.businessCount.toLocaleString()} <small>(개)</small>`;
                document.getElementById('summary-total-emp').innerHTML = `${totalData.employeeCount.toLocaleString()} <small>(명)</small>`;
                document.getElementById('summary-total-sales').innerHTML = `${totalData.salesAmount.toLocaleString()} <small>(억원)</small>`;
                summaryContainer.classList.remove('hidden');
            }
        }
        
        const districtData = data.filter(d => d.districtName !== '대전시');
        const dataMap = new Map(districtData.map(d => [d.districtName, d]));

        const svg = mapContainer.querySelector('svg');
        const g = mapContainer.querySelector('g[inkscape\\:label*="Daejeon_sigungu"]');
		g.setAttribute('transform', 'translate(-400, 0)'); 
        const paths = g.querySelectorAll('path');
        const districtOrder = ['동구', '중구', '서구', '유성구', '대덕구'];
        
        const svgRect = svg.getBoundingClientRect();
        const viewBox = svg.viewBox.baseVal;
        const scaleX = svgRect.width / viewBox.width;
        const scaleY = svgRect.height / viewBox.height;

        paths.forEach((path, index) => {
            if (index < districtOrder.length) {
                const districtName = districtOrder[index];
                const districtInfo = dataMap.get(districtName);

                if (districtInfo) {
                    const count = districtInfo[dataKeyForCount];
                    const rate = districtInfo[dataKeyForRate];

                    path.style.fill = colorFunction(count);

                    const bbox = path.getBBox();
                    const centerX_svg = bbox.x + bbox.width / 2;
                    const centerY_svg = bbox.y + bbox.height / 2;
                    
                    const x_offset = 60;
                    const y_offset = 70;

                    const labelGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
                    labelGroup.classList.add('map-label');
                    const textName = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                    textName.setAttribute('x', centerX_svg + x_offset);
                    textName.setAttribute('y', (centerY_svg - 75) + y_offset);
                    textName.textContent = districtName;

                    const textValueContainer = document.createElementNS('http://www.w3.org/2000/svg', 'text');
                    textValueContainer.setAttribute('x', centerX_svg + x_offset);
                    textValueContainer.setAttribute('y', (centerY_svg + 5) + y_offset);
                    textValueContainer.classList.add('value');
                    
                    const tspanCount = document.createElementNS('http://www.w3.org/2000/svg', 'tspan');
                    const tspanRate = document.createElementNS('http://www.w3.org/2000/svg', 'tspan');
                    tspanRate.setAttribute('x', centerX_svg + x_offset);
                    tspanRate.setAttribute('dy', '1.2em');
                    
                    // ▼▼▼ [수정] 텍스트 표시 로직 수정 ▼▼▼
                    if (mapType === 'districtBusiness' || mapType === 'smallbizStats') {
                        tspanCount.textContent = count.toLocaleString() + '개';
                        tspanRate.textContent = `(${rate}%)`;
                    } else { // commonBusiness
                        tspanCount.textContent = count.toLocaleString() + '억원';
                        tspanRate.textContent = `(평균 ${rate}년)`;
                    }

                    textValueContainer.appendChild(tspanCount);
                    textValueContainer.appendChild(tspanRate);
                    labelGroup.appendChild(textName);
                    labelGroup.appendChild(textValueContainer);
                    g.appendChild(labelGroup);
                    
                    path.addEventListener('mouseover', () => {
                        const centerX_px = (centerX_svg - viewBox.x) * scaleX;
                        const centerY_px = (centerY_svg - viewBox.y) * scaleY;
                        hoverEffect.style.left = `${centerX_px}px`;
                        hoverEffect.style.top = `${centerY_px}px`;
                        hoverEffect.style.display = 'flex';
                    });
                    
                    path.addEventListener('mouseout', () => {
                        hoverEffect.style.display = 'none';
                    });
                }
            }
        });
        
        mapContainer.classList.add('loaded');

    } catch (error) {
		console.error("지도 차트 로딩 실패:", error);
        mapContainer.innerHTML = '<p style="text-align:center; padding-top: 20px;">차트를 불러오는 중 오류가 발생했습니다.</p>';
        mapContainer.classList.add('loaded');
    }
}

// 총 사업체 수에 따라 색상을 반환하는 함수
function getColorForBusinessCount(count) {
    if (count >= 45000) return '#0a3d62';
    if (count >= 35000) return '#3c6382';
    if (count >= 25000) return '#82ccdd';
    return '#f1f2f6';
}

// 소상공인 사업체 수에 따라 색상을 반환하는 함수
function getColorForSmallbizCount(count) {
	if (count >= 45000) return '#0a3d62';
    if (count >= 30000) return '#3c6382';
    if (count >= 25000) return '#82ccdd';
    return '#f1f2f6';                   // 가장 밝은 주황
}
