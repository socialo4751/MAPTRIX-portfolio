document.addEventListener('DOMContentLoaded', () => {
	
	// ======================== 1. 설정 정보 초기화 (map-detail-analysis.js 참조) ========================

    // 분석 설정 (데이터 소스 URL 정의)
    const ANALYSIS_CONFIG = {
        '다중회귀모형': {
            geojsonUrl: `${contextPath}/data/Daejeon_1K_with_results_re2.geojson`
        },
        '군집분석': {
            geojsonUrl: `${contextPath}/data/Daejeon_1K_with_clusters_results_re.geojson`
        },
        '로지스틱': {
            geojsonUrl: `${contextPath}/data/Daejeon_1K_with_logistic_results.geojson`
        },
        '중력모형': {
            geojsonUrl: `${contextPath}/data/Daejeon_1K_with_gravity_results.geojson`
        }
    };

    // 범례 구간 정보 (차트의 X축 구간(카테고리)으로 사용)
    const LEGEND_BREAKS = {
        '총사업체수': [0, 5, 11, 64, 566],
        '총인구': [0, 8, 33, 76, 344, 6788],
        '30~34세 남녀 인구 합': [0, 5, 15, 61, 1471],
        '1인가구 수': [0, 5, 13, 60, 866],
        '신축 주택 비율': [0.0, 0.011, 0.187],
        '도소매업체수': [0, 5, 76],
        '숙박음식업체수': [0, 3, 23],
		'정보통신업체수': [0, 5, 17, 185],  
        '건설업체수': [0, 5, 39, 908],         
        '교육서비스업체수': [0, 8, 46, 274],    
		'20~39세 인구 비율': [0.15, 0.25, 0.35, 0.5],
		'총 인구수': [0, 8, 33, 76, 344, 6788],
        '1인가구 비율': [0.0, 0.242, 0.352, 0.511],
        '총가구수': [0, 5, 13, 29, 146, 2944],
        '음식점 수': [0, 3, 46, 705],
        '도소매업체 수': [0, 5, 76],
		'전체 사업체 수': [0, 5, 11, 64, 566],       
        '서비스업 종사자 수': [0, 3, 18, 174, 1094],
        '도소매업 종사자 수': [0, 5, 42, 335],       
        '2000년 이후 주택 비율': [0.0, 0.03, 0.433, 0.809],
        'Gravity_Total': [86.47, 583.59, 12974.21],
        '인구 수': [45, 592, 6443, 12862],
        '공시지가': [20541, 61666, 247157, 685911]
    };
	
	// ✨ 엑셀 파일명 매핑 정보 추가
    const EXCEL_FILE_MAP = {
        'regression': 'regression_indicators.xlsx',
        'cluster': 'cluster_indicators.xlsx',
        'logistic': 'logistic_indicators.xlsx',
        'gravity': 'gravity_indicators.xlsx'
    };
	
    // ======================== 2. DOM 요소 및 이벤트 핸들러 ========================

    // 분석 모델 선택 메뉴
    const modelSelectButtons = document.querySelectorAll('.model-select-btn');
    const tableContainers = document.querySelectorAll('.analysis-table-container');
    
    // 모달 관련 요소
    const chartModal = document.getElementById('chartModal');
    const modalTitle = document.getElementById('modalTitle');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const chartContainer = document.getElementById('chartContainer');
    const variableNameCells = document.querySelectorAll('.variable-name');
	const downloadExcelBtn = document.getElementById('downloadExcelBtn');
	    
    // ✨ 새로 추가된 '공통 변수 설명 다운로드' 버튼에 대한 요소를 가져옵니다.
    const downloadGuideBtns = document.querySelectorAll('.btn-guide-download');

	// ✨ 페이지가 로드된 후 동적으로 생성된 .variable-name을 포함하여 이벤트 리스너 재설정
    function addChartClickEventListeners() {
        const variableNameCells = document.querySelectorAll('.variable-name');
        variableNameCells.forEach(cell => {
            // 기존 이벤트 리스너 제거 (중복 방지)
            cell.removeEventListener('click', handleVariableClick);
            // 새 이벤트 리스너 추가
            cell.addEventListener('click', handleVariableClick);
        });
    }

    function handleVariableClick(event) {
        const target = event.currentTarget;
        const model = target.dataset.model;
        const variable = target.dataset.variable;

        if (!model || !variable) {
            alert("차트를 생성할 수 없는 항목입니다.");
            return;
        }
        modalTitle.textContent = `[${model}] '${variable}' 데이터 분포`;
        chartModal.style.display = 'flex';
        chartContainer.innerHTML = '<div class="spinner"></div>';
        generateAndRenderChart(model, variable);
    }

    modelSelectButtons.forEach(button => {
        button.addEventListener('click', () => {
            const targetId = button.getAttribute('data-target');
            modelSelectButtons.forEach(btn => btn.classList.remove('active'));
            tableContainers.forEach(container => container.classList.remove('active'));
            button.classList.add('active');
            document.getElementById(targetId).classList.add('active');
			addChartClickEventListeners(); // 탭 전환 시 새로 표시된 테이블에 이벤트 리스너 다시 적용
        });
    });

    closeModalBtn.addEventListener('click', () => {
        chartModal.style.display = 'none';
        chartContainer.innerHTML = '';
    });
    chartModal.addEventListener('click', (event) => {
        if (event.target === chartModal) {
            chartModal.style.display = 'none';
            chartContainer.innerHTML = '';
        }
    });
	
	/**
     * ✨ 엑셀 다운로드 로그를 서버에 전송하는 함수
     * @param {string} indicatorName - 로그에 기록할 지표명 (다운로드 파일명)
     */
	async function logExcelDownload(indicatorName) {
	    try {
	        const response = await fetch(`${contextPath}/api/market/dashboard/excel-download-log`, {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            },
	            body: JSON.stringify({
	                indicatorName: indicatorName 
	            }),
	        });

            if (!response.ok) {
                // 서버에서 에러가 발생해도 다운로드는 진행되도록 처리
                console.error('엑셀 다운로드 로그 기록에 실패했습니다.', await response.text());
            }
        } catch (error) {
            console.error('로그 기록 중 네트워크 오류가 발생했습니다.', error);
        }
    }
	
	/**
     * ✨ 파일을 실제로 다운로드하는 함수
     * @param {string} filename - 다운로드할 파일의 전체 이름
     */
    function downloadFile(filename) {
        const fileUrl = `${contextPath}/data/excel/${filename}`;
        const link = document.createElement('a');
        link.href = fileUrl;
        link.setAttribute('download', filename);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    // ✨ '선택 지표 엑셀 다운로드' 버튼 이벤트 리스너 (수정)
    downloadExcelBtn.addEventListener('click', () => {
        const activeButton = document.querySelector('.model-select-btn.active');
        if (!activeButton) {
            alert('먼저 분석 모델을 선택해주세요.');
            return;
        }

        const modelId = activeButton.dataset.target;
        const filename = EXCEL_FILE_MAP[modelId];
        if (!filename) {
            alert('해당 모델에 대한 엑셀 파일을 찾을 수 없습니다.');
            return;
        }

        // 1. 로그 기록 함수 호출
        logExcelDownload(filename);
        
        // 2. 파일 다운로드 함수 호출
        downloadFile(filename);
    });
	
	// ✨ '공통 변수 설명 다운로드' 버튼 이벤트 리스너 (수정)
    downloadGuideBtns.forEach(button => {
        button.addEventListener('click', () => {
            const filename = '변수에 대한 설명.xlsx';
            
            // 1. 로그 기록 함수 호출
            logExcelDownload(filename);

            // 2. 파일 다운로드 함수 호출
            downloadFile(filename);
        });
    });
	
    // ======================== 3. 차트 생성 함수 ========================
    
	/**
	 * 데이터를 가져와 변수 유형에 따라 적절한 차트를 생성하고 렌더링하는 함수
	 * @param {string} modelName - 분석 모델명
	 * @param {string} variableName - 분석 변수명
	 */
	async function generateAndRenderChart(modelName, variableName) {
        try {
            const config = ANALYSIS_CONFIG[modelName];
            if (!config) throw new Error("해당 모델에 대한 설정 정보를 찾을 수 없습니다.");

            const response = await fetch(config.geojsonUrl);
            if (!response.ok) throw new Error(`데이터 로딩 실패 (상태: ${response.status})`);
            const geojsonData = await response.json();
            const features = geojsonData.features;

            let chartData, chartCategories, chartType = 'column', chartTitle = variableName;
            let seriesColors = ['#19a538']; // 기본 색상

            // ✨ 변수명에 따라 분기 처리 확장
            if (variableName === 'residual_total_business') {
                // --- 다중회귀모형 결과 ---
                chartTitle = '다중회귀모형 분석 결과';
                chartType = 'bar';
                chartCategories = ['예측보다 높은 지역 (성장 동력)', '예측보다 낮은 지역 (성장 잠재력)'];
                const seriesColors = ['rgba(255, 182, 193, 0.9)', 'rgba(173, 216, 230, 0.9)'];
                const counts = { '높음': 0, '낮음': 0 };
                features.forEach(f => (f.properties.residual_total_business > 0) ? counts['높음']++ : counts['낮음']++);
                chartData = [{name: '격자 수', data: [ {name: chartCategories[0], y: counts['높음'], color: seriesColors[0]}, {name: chartCategories[1], y: counts['낮음'], color: seriesColors[1]} ] }];

            } else if (variableName === 'cluster_result' || (modelName === '로지스틱' && variableName === 'cluster')) {
				// --- 군집분석 결과 (또는 로지스틱의 종속변수) ---                
                // --- 군집분석 결과 ---
                chartTitle = '군집 분포';
                chartType = 'bar';
                chartCategories = ['군집 0 (상업/인구 중심)', '군집 1 (주거/성장 잠재)'];
                const seriesColors = ['rgba(255, 182, 193, 0.9)', 'rgba(173, 216, 230, 0.9)'];
                const counts = { 0: 0, 1: 0 };
                features.forEach(f => counts[f.properties.cluster]++);
                chartData = [{name: '격자 수', data: [ {name: chartCategories[0], y: counts[0], color: seriesColors[0]}, {name: chartCategories[1], y: counts[1], color: seriesColors[1]} ] }];
                
            } else if (variableName === 'predicted_class') {
                // --- 로지스틱 분석 결과 ---
                chartTitle = '로지스틱분석 결과';
                chartType = 'bar';
                chartCategories = ['핵심 상권', '잠재 상권', '숨은 상권'];
                const seriesColors = ['rgba(255, 182, 193, 0.9)', 'rgba(173, 216, 230, 0.9)', 'rgba(255, 165, 0, 0.9)'];
                const counts = { '핵심 상권': 0, '잠재 상권': 0, '숨은 상권': 0 };
                features.forEach(f => {
                    const props = f.properties;
                    if (props['정답 여부'] === '오답') counts['숨은 상권']++;
                    else if (props.predicted_class === 0) counts['핵심 상권']++;
                    else if (props.predicted_class === 1) counts['잠재 상권']++;
                });
                chartData = [{name: '격자 수', data: chartCategories.map((cat, i) => ({name: cat, y: counts[cat], color: seriesColors[i]})) }];
            
            } else if (variableName === 'Gravity_Total') {
                // --- ✨ 중력모형 결과 추가 ✨ ---
                chartTitle = '상권 흡인력(Gravity Total)';
                chartType = 'bar';
                chartCategories = ['최상위 흡인력 (핵심)', '상위 흡인력 (유망)', '중위 흡인력 (보통)', '하위 흡인력 (배후)'];
                const seriesColors = ['rgba(255, 0, 0, 0.7)', 'rgba(255, 255, 0, 0.7)', 'rgba(144, 238, 144, 0.7)', 'rgba(211, 211, 211, 0.7)'];
                const breaks = LEGEND_BREAKS['Gravity_Total']; // [86.47, 583.59, 12974.21]
                const counts = { '최상위': 0, '상위': 0, '중위': 0, '하위': 0 };
                features.forEach(f => {
                    const value = f.properties.Gravity_Total || 0;
                    if (value <= breaks[0]) counts['하위']++;
                    else if (value <= breaks[1]) counts['중위']++;
                    else if (value <= breaks[2]) counts['상위']++;
                    else counts['최상위']++;
                });
                chartData = [{name: '격자 수', data: [
                    { name: chartCategories[0], y: counts['최상위'], color: seriesColors[0] },
                    { name: chartCategories[1], y: counts['상위'], color: seriesColors[1] },
                    { name: chartCategories[2], y: counts['중위'], color: seriesColors[2] },
                    { name: chartCategories[3], y: counts['하위'], color: seriesColors[3] }
                ]}];

            } else {
                // --- 기타 숫자형 변수 처리 (히스토그램) ---
                const breaks = LEGEND_BREAKS[variableName];
                if (!breaks) throw new Error("해당 변수의 범례 정보를 찾을 수 없습니다.");
                chartTitle = variableName; // 숫자형 변수는 원래 이름을 제목으로
                chartCategories = [];
                const counts = new Array(breaks.length + 1).fill(0);
                chartCategories.push(`~ ${breaks[0].toLocaleString()}`);
                for (let i = 0; i < breaks.length - 1; i++) chartCategories.push(`${breaks[i].toLocaleString()} ~ ${breaks[i+1].toLocaleString()}`);
                chartCategories.push(`${breaks[breaks.length - 1].toLocaleString()} ~`);
                features.forEach(f => {
                    const value = f.properties[variableName] || 0;
                    let found = false;
                    for (let i = 0; i < breaks.length; i++) {
                        if (value <= breaks[i]) { counts[i]++; found = true; break; }
                    }
                    if (!found) counts[counts.length - 1]++;
                });
                chartData = [{ name: '격자 수', data: counts, color: '#19a538' }];
            }
            
            renderChart(chartTitle, chartCategories, chartData, chartType);

        } catch (error) {
            console.error("차트 생성 중 오류 발생:", error);
            chartContainer.innerHTML = `<p style="color:red; text-align:center;">차트를 생성하는 중 오류가 발생했습니다.<br>${error.message}</p>`;
        }
    }

    /**
     * 최종 렌더링 함수
     */
    function renderChart(title, categories, seriesData, chartType) {
        const isBarChart = chartType === 'bar';
        Highcharts.chart('chartContainer', {
            chart: { type: chartType },
            title: { text: `'${title}' 분포 현황` },
            subtitle: { text: '유형별 격자(1km)의 개수' },
            xAxis: { categories: categories, title: { text: null } },
            yAxis: { min: 0, title: { text: '격자 개수' } },
            tooltip: {
                pointFormat: '격자 수: <b>{point.y} 개</b> ({point.percentage:.1f}%)',
            },
            plotOptions: {
                bar: { dataLabels: { enabled: true, format: '{point.y} 개' } },
                column: { pointPadding: 0.2, borderWidth: 0 }
            },
            series: seriesData,
            legend: { enabled: false },
            credits: { enabled: false }
        });
    }

    addChartClickEventListeners();
	
});