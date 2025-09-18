document.addEventListener('DOMContentLoaded', () => {
	
	// 좌표계 정의
	proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");
	
	//======================== 1. 설정 및 변수 초기화 ========================
	
	// ======================== 동적 오버레이 범례 제어 함수 ========================
	const overlayLegend = document.getElementById('overlayLegend');
	const overlayLegendContainer = document.getElementById('overlayLegendContainer'); // 컨테이너도 변수로 선언

	/**
	 * 오버레이 범례 컨테이너의 표시 여부를 업데이트하는 함수
	 * 범례 항목이 하나라도 있으면 보이고, 없으면 숨깁니다.
	 */
	function updateOverlayLegendVisibility() {
	    // overlayLegend(내용) div에 자식 요소(범례 항목)가 있는지 확인
	    if (overlayLegend.children.length > 0) {
	        overlayLegendContainer.style.display = 'block'; // 항목이 있으면 보이기
	    } else {
	        overlayLegendContainer.style.display = 'none';  // 항목이 없으면 숨기기
	    }
	}

	/**
	 * 오버레이 범례 영역에 항목을 추가하는 함수
	 * @param {string} id - 제거 시 사용할 고유 ID (예: 'hjd', 'franchise_스타벅스')
	 * @param {string|null} color - 범례 색상. null이면 색상 상자 없이 텍스트만 표시
	 * @param {string} label - 범례 항목 텍스트
	 */
	function addOverlayLegendItem(id, color, label) {
	    // 이미 해당 ID의 범례가 있다면 중복 추가 방지
	    if (document.getElementById(id)) return;

	    const legendItem = document.createElement('div');
	    legendItem.id = id;
	    legendItem.className = 'legend-item';

	    let colorBoxHtml = '';
	    // color 값이 있을 경우에만 색상 상자를 추가
	    if (color) {
	        // 행정동 경계선은 특별히 border로 처리
	        const style = (id === 'hjd') 
	            ? `border: 2px solid ${color}; background-color: transparent;`
	            : `background-color: ${color};`;
	        colorBoxHtml = `<span class="legend-color-box" style="${style}"></span>`;
	    }
	    
	    legendItem.innerHTML = `${colorBoxHtml}<span>${label}</span>`;
	    overlayLegend.appendChild(legendItem);
		updateOverlayLegendVisibility(); // 함수 호출 추가
	}

	/**
	 * 오버레이 범례 영역에서 특정 항목을 ID로 찾아 제거하는 함수
	 * @param {string} id - 제거할 범례 항목의 고유 ID
	 */
	function removeOverlayLegendItem(id) {
	    const legendItem = document.getElementById(id);
	    if (legendItem) {
	        overlayLegend.removeChild(legendItem);
	    }
		updateOverlayLegendVisibility(); // 함수 호출 추가
	}
	
	// 분석 설정에 군집분석용 변수 레이어들 추가
	const ANALYSIS_CONFIG = {
	    '다중회귀모형': {
	        geojsonUrl: `${contextPath}/data/Daejeon_1K_with_results_re2.geojson`,
	        layers: [
	            { value: 'residual_total_business', label: '다중회귀모형분석 결과' }, { value: '총사업체수', label: '총사업체수' },
	            { value: '총인구', label: '총인구' }, { value: '30~34세 남녀 인구 합', label: '30~34세 인구' },
	            { value: '1인가구 수', label: '1인가구 수' }, { value: '신축 주택 비율', label: '신축 주택 비율' },
	            { value: '도소매업체수', label: '도소매업체수' }, { value: '숙박음식업체수', label: '숙박 및 음식업체수' },
	            { value: '정보통신업체수', label: '정보통신업체수' }, { value: '건설업체수', label: '건설업체수' },
	            { value: '교육서비스업체수', label: '교육서비스업체수' }
	        ]
	    },
	    '군집분석': {
	        geojsonUrl: `${contextPath}/data/Daejeon_1K_with_clusters_results_re.geojson`,
	        layers: [
	            { value: 'cluster_result', label: '군집분석 결과' },
				{ value: '20~39세 인구 비율', label: '20~39세 인구 비율' },
				{ value: '총 인구수', label: '총 인구수' },
				{ value: '1인가구 비율', label: '1인가구 비율' },
				{ value: '총가구수', label: '총가구수' },
				{ value: '음식점 수', label: '음식점 수' },
				{ value: '도소매업체 수', label: '도소매업체 수' },
				{ value: '전체 사업체 수', label: '전체 사업체 수' },
				{ value: '서비스업 종사자 수', label: '서비스업 종사자 수' },
				{ value: '도소매업 종사자 수', label: '도소매업 종사자 수' },
				{ value: '2000년 이후 주택 비율', label: '2000년 이후 주택 비율' }
	        ]
	    },
		'로지스틱': { // 로지스틱 분석 설정
	        geojsonUrl: `${contextPath}/data/Daejeon_1K_with_logistic_results.geojson`,
	        layers: [
	            { value: 'predicted_class', label: '로지스틱분석 결과' },
	            { value: '총 인구수', label: '총 인구수' },
	            { value: '음식점 수', label: '음식점 수' },
	            { value: '서비스업 종사자 수', label: '서비스업 종사자 수' }
	        ]
	    },
		'중력모형': { // 중력모형 분석 추가
            geojsonUrl: `${contextPath}/data/Daejeon_1K_with_gravity_results.geojson`,
            layers: [
                { value: 'Gravity_Total', label: '중력모형분석 결과' },
                { value: '인구 수', label: '인구 수' },
                { value: '공시지가', label: '공시지가' }
            ]
        }
	};
	
	// 분석 모델 이름 객체 추가
	const ANALYSIS_MODEL_NAMES = {
	    '다중회귀모형': '다중회귀모형 분석',
	    '군집분석': 'K-Means 군집분석',
	    '로지스틱': '로지스틱 회귀분석',
	    '중력모형': '중력모형 분석'
	};
	
	// 프랜차이즈 설정
    const FRANCHISE_CONFIG = {
        '스타벅스': { url: `${contextPath}/data/starbucks.geojson`, color: '#1e3932' },
        '빽다방': { url: `${contextPath}/data/paikdabang.geojson`, color: '#ffcc00' },
        '맥도날드': { url: `${contextPath}/data/mcdonald.geojson`, color: '#dc3545' },
        '도미노피자': { url: `${contextPath}/data/dominopizza.geojson`, color: '#007bff' },
        '서브웨이': { url: `${contextPath}/data/subway.geojson`, color: '#00a651' }
    };
	
	// 산업별 사업체/종사자 수 레이어 설정
	const BIZ_CONFIG = {
	    '도매 및 소매업': {
	        geojsonUrl: `${contextPath}/data/Daejeon_adm_biz_emp_info.geojson`,
	        bizCountKey: 'cp_bnu_007',
	        empCountKey: 'cp_bem_007',
	        offsetY: -60
	    },
	    '숙박 및 음식점업': {
	        geojsonUrl: `${contextPath}/data/Daejeon_adm_biz_emp_info.geojson`,
	        bizCountKey: 'cp_bnu_009',
	        empCountKey: 'cp_bem_009',
	        offsetY: -40
	    },
	    '금융 및 보험업': {
	        geojsonUrl: `${contextPath}/data/Daejeon_adm_biz_emp_info.geojson`,
	        bizCountKey: 'cp_bnu_011',
	        empCountKey: 'cp_bem_011',
	        offsetY: -20
	    },
	    '교육 서비스업': {
	        geojsonUrl: `${contextPath}/data/Daejeon_adm_biz_emp_info.geojson`,
	        bizCountKey: 'cp_bnu_016',
	        empCountKey: 'cp_bem_016',
	        offsetY: 0
	    },
	};
	
	const COLORS_5_CLASS_ORANGE = ['rgba(254, 237, 222, 0.7)', 'rgba(253, 209, 162, 0.7)', 'rgba(253, 174, 107, 0.7)', 'rgba(244, 109, 67, 0.7)', 'rgba(215, 48, 39, 0.7)'];
	const COLORS_7_CLASS_ORANGE = ['rgba(255, 245, 235, 0.7)', 'rgba(254, 224, 182, 0.7)', 'rgba(253, 190, 133, 0.7)', 'rgba(253, 141, 60, 0.7)', 'rgba(241, 105, 19, 0.7)', 'rgba(217, 72, 1, 0.7)', 'rgba(166, 54, 3, 0.7)'];
	
	// 중력모형 분석을 위한 4단계 색상 정의
	const COLORS_4_CLASS_GRAVITY = ['rgba(211, 211, 211, 0.7)', 'rgba(144, 238, 144, 0.7)', 'rgba(255, 255, 0, 0.7)', 'rgba(255, 0, 0, 0.7)']; // 연한 회색, 연한 연두, 연한 노랑, 연한 빨강

	
	// 최소 4구간을 보장하는 백분위수 기반 범례 값으로 전체 업데이트
	const LEGEND_BREAKS = {
		// 다중회귀
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
		// 군집분석 & 로지스틱 공통
		'20~39세 인구 비율': [0.0, 0.1042, 0.2109, 0.3037],
		'총 인구수': [0, 8, 33, 76, 344, 6788],
		'1인가구 비율': [0.0, 0.242, 0.352, 0.511],
		'총가구수': [0, 5, 13, 29, 146, 2944],
		'음식점 수': [0, 3, 46, 705],
		'도소매업체 수': [0, 5, 76],
		'전체 사업체 수': [0, 5, 11, 64, 566],
		'서비스업 종사자 수': [0, 3, 18, 174, 1094],
		'도소매업 종사자 수': [0, 5, 42, 335],
		'2000년 이후 주택 비율': [0.0, 0.03, 0.433, 0.809],
		// 중력모형 분석 변수 범례 추가 (데이터 분석 기반 Quantile 값)
       	'Gravity_Total': [86.47, 583.59, 12974.21], // 25%, 50%, 75% 백분위수
       	'인구 수': [45, 592, 6443, 12862], // 20, 40, 60, 80% 백분위수 (5구간)
       	'공시지가': [20541, 61666, 247157, 685911] // 20, 40, 60, 80% 백분위수 (5구간)
	};

	const daejeonCityHallLonLat = [127.38489655389, 36.360043590621];
	const daejeonCityHall3857 = ol.proj.transform(daejeonCityHallLonLat, 'EPSG:4326', 'EPSG:3857');
	vw.ol3.CameraPosition.center = daejeonCityHall3857;
	vw.ol3.CameraPosition.zoom = 11;
	vw.ol3.MapOptions = {
	    basemapType: vw.ol3.BasemapType.GRAPHIC, controlDensity: vw.ol3.DensityType.EMPTY,
	    interactionDensity: vw.ol3.DensityType.BASIC, controlsAutoArrange: true,
	    homePosition: vw.ol3.CameraPosition, initPosition: vw.ol3.CameraPosition
	};
	var vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);
	
	
	// 모달 제목을 만드는 재사용 가능한 함수
	// baseText: "격자", "AI 상세 분석" 등 제목 앞부분에 들어갈 텍스트
	// properties: gid와 행정동 정보가 담긴 지도 피처의 속성 객체
	const createModalTitle = (mainTitle, properties) => {
	    let subTitleHtml = '';
	    // 1순위 행정동 정보가 있으면 부제목을 만듭니다.
	    if (properties['1rank_AD_1']) {
	        subTitleHtml = `<br><span class="modal-subtitle">― 주요 행정동: ${properties['1rank_AD_1']} (${properties['1rank_perc']}%)`;
	        // 2순위 정보가 있으면 덧붙입니다.
	        if (properties['2rank_AD_1']) {
	            subTitleHtml += `, ${properties['2rank_AD_1']} (${properties['2rank_perc']}%)`;
	        }
	        subTitleHtml += `</span>`;
	    }
	    // 메인 제목과 부제목 HTML을 합쳐서 반환합니다.
	    return mainTitle + subTitleHtml;
	};
	// ======================== 쿠키 및 단계별 안내 모달 처리 ========================
	function setCookie(name, value, days) {
        let expires = "";
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "") + expires + "; path=/";
    }

    function getCookie(name) {
        const nameEQ = name + "=";
        const ca = document.cookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    // 안내 모달 및 사이드바 DOM 요소
    const usageModalStep1 = document.getElementById('usageModalStep1');
    const usageModalStep2 = document.getElementById('usageModalStep2');
    const usageModalStep3 = document.getElementById('usageModalStep3');
    const usageModalStep4 = document.getElementById('usageModalStep4'); // Step 4 모달 추가
    const confirmModalStep1 = document.getElementById('confirmModalStep1');
    const confirmModalStep2 = document.getElementById('confirmModalStep2');
    const confirmModalStep3 = document.getElementById('confirmModalStep3');
    const confirmModalStep4 = document.getElementById('confirmModalStep4'); // Step 4 버튼 추가
    const hideModalCheckbox = document.getElementById('hideModalCheckbox');
    
    const layerSidebarForGuide = document.getElementById('layerSidebar');
    const reportSidebarForGuide = document.getElementById('reportSidebar');

    // 페이지 로드 시 쿠키 확인
    const hideModalCookie = getCookie('hideUsageModal');
    if (!hideModalCookie) {
        // 가이드 시작 전, 관련 사이드바들을 먼저 연다.
        layerSidebarForGuide.classList.add('visible');
        reportSidebarForGuide.classList.add('active');
        vmap.updateSize();

        // 첫 번째(Step 1) 모달 표시
        usageModalStep1.classList.add('visible');
    }

    // Step 1 모달 '다음' 버튼 클릭 이벤트
    confirmModalStep1.addEventListener('click', () => {
		usageModalStep1.classList.remove('visible'); // ✨ 수정
	    usageModalStep2.classList.add('visible');    // ✨ 수정
    });
    
    // Step 2 모달 '다음' 버튼 클릭 이벤트
    confirmModalStep2.addEventListener('click', () => {
		usageModalStep2.classList.remove('visible'); // ✨ 수정
	    usageModalStep3.classList.add('visible');    // ✨ 수정
    });

    // Step 3 모달 '다음' 버튼 클릭 이벤트
    confirmModalStep3.addEventListener('click', () => {
		usageModalStep3.classList.remove('visible'); // ✨ 수정
	    usageModalStep4.classList.add('visible');    // ✨ 수정
    });

    // Step 4 모달 '시작하기!' 버튼 클릭 이벤트
    confirmModalStep4.addEventListener('click', () => {
        if (hideModalCheckbox.checked) {
            setCookie('hideUsageModal', 'true', 1);
        }
        usageModalStep4.classList.remove('visible'); // ✨ 수정

        // 가이드 종료 후, 관련 사이드바들을 모두 닫는다.
        layerSidebarForGuide.classList.remove('visible');
        reportSidebarForGuide.classList.remove('active');
    });
	// ======================== 쿠키 및 단계별 안내 모달 처리 끝 ========================
	
	const gridLayers = {};
	let activeGridLayer = null;
	let hjdLayer = null; // 행정동 레이어 변수 추가
    const franchiseLayers = {}; // [신규] 프랜차이즈 레이어 저장 객체
	let popupOverlay = null; // [신규] 팝업 오버레이 변수
	const bizLayers = {}; // [신규] 산업별 레이어 저장 객체
	const bizButtons = document.querySelectorAll('.biz-btn');
	
	// ======================== 주소 검색 및 지도 이동 기능 ========================
	const addAddressSearchFunctionality = () => {
	    // 1. 필요한 HTML 요소 선택
	    const addressSearchInput = document.getElementById('addressSearchInput');
	    const addressSearchButton = document.getElementById('addressSearchButton');

	    // 2. V-World API 인증키
	    const vworldApiKey = "B346494D-259D-3E0B-AFE4-6862A39827F8"; // V-World API 키

	    /**
	     * 입력된 주소를 V-World API로 검색하여 지도를 이동시키는 함수
	     */
	    const searchAddressAndMoveMap = () => {
	        const address = addressSearchInput.value.trim();
	        if (!address) {
	            alert('검색할 주소를 입력해주세요.');
	            return;
	        }

	        $.ajax({
	            url: "https://api.vworld.kr/req/address?",
	            type: "GET",
	            dataType: "jsonp",
	            data: {
	                service: "address",
	                request: "GetCoord",
	                version: "2.0",
	                crs: "EPSG:4326", // WGS84 좌표계
	                type: "ROAD",    // 도로명 주소 우선
	                address: address,
	                format: "json",
	                errorformat: "json",
	                key: vworldApiKey
	            },
	            success: function (result) {
	                if (result.response.status !== "OK") {
	                    alert(`주소를 찾을 수 없습니다: ${result.response.error.text}`);
	                    return;
	                }

	                const point = result.response.result.point;
	                const lon = parseFloat(point.x);
	                const lat = parseFloat(point.y);

	                // 검색된 좌표(EPSG:4326)를 지도 좌표계(EPSG:3857)로 변환
	                const coords3857 = ol.proj.transform([lon, lat], 'EPSG:4326', 'EPSG:3857');
	                
	                // 지도 뷰를 가져와서 중앙 위치와 줌 레벨을 변경
	                const view = vmap.getView();
					view.setCenter(coords3857);
	                view.setZoom(17);

	            },
	            error: function (xhr, status, error) {
	                console.error("주소 검색 API 호출 중 오류 발생:", error);
	                alert("주소 검색 중 오류가 발생했습니다. 네트워크 연결을 확인해주세요.");
	            }
	        });
	    };

	    // 3. 이벤트 리스너 연결
	    // 검색 버튼 클릭 시 함수 실행
	    addressSearchButton.addEventListener('click', searchAddressAndMoveMap);

	    // 검색창에서 Enter 키를 눌렀을 때 함수 실행
	    addressSearchInput.addEventListener('keydown', (e) => {
	        if (e.key === 'Enter') {
	            searchAddressAndMoveMap();
	        }
	    });
	};
	//======================== 2. DOM 요소 및 이벤트 핸들러 ========================
    const analysisButtons = document.querySelectorAll('.analysis-btn');
    const analyzeBtn = document.getElementById('analyzeBtn');
    const backBtn = document.getElementById('backBtn');
    const layerSidebar = document.getElementById('layerSidebar');
    const layerList = document.getElementById('layerList');
    const showReportBtn = document.getElementById('showReportBtn');
    const reportSidebar = document.getElementById('reportSidebar');
    const closeReportBtn = document.getElementById('closeReportBtn');
    const reportBody = document.getElementById('reportBody');
	const toggleHjdLayerBtn = document.getElementById('toggleHjdLayerBtn'); // 버튼 요소 가져오기
	const analysisLegendContainer = document.getElementById('analysisLegendContainer'); //범례 관련
	const analysisLegend = document.getElementById('analysisLegend');  //범례 관련
	// 지도 위 오른쪽 상단 버튼들
	const homeBtn = document.getElementById('homeBtn');
	const logoutBtn = document.getElementById('logoutBtn');
	const guideBtn = document.getElementById('guideBtn');
	const myBtn = document.getElementById('myBtn');
	
	// AI 분석 실패 시 출력멘트
	const AI_ERROR_MESSAGE = "AI 서버와 통신 중 오류가 발생했습니다.<br>잠시 후 다시 시도해 주세요.";
	
	// 지도 위 오른쪽 상단 버튼 이벤트 핸들러
	if (homeBtn) {
        homeBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/`; // 홈으로 이동
        });
    }

	if (logoutBtn) {
	    logoutBtn.addEventListener('click', () => {
	        // JSP에 있는 로그아웃 폼을 찾아 submit 합니다.
	        const logoutForm = document.getElementById('logoutForm');
	        if(logoutForm) {
	            logoutForm.submit();
	        }
	    });
	}
	if (guideBtn) {
		guideBtn.addEventListener('click', () => {
		    // '이용안내' 버튼 클릭 시 쿠키와 상관없이 가이드 모달을 처음부터 다시 시작
		    
		    // 가이드에 필요한 사이드바들을 다시 연다.
		    layerSidebarForGuide.classList.add('visible');
		    reportSidebarForGuide.classList.add('active');
		    vmap.updateSize();
	
		    // 첫 번째 스텝 모달을 표시하고 나머지는 숨김 처리
			usageModalStep1.classList.add('visible');    // ✨ 수정
		    usageModalStep2.classList.remove('visible'); // ✨ 수정
		    usageModalStep3.classList.remove('visible'); // ✨ 수정
		    usageModalStep4.classList.remove('visible'); // ✨ 수정
		});
	}
	if (myBtn) {
        myBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/my/report`; // 마이페이지 - 리포트 주소로 이동
        });
    }
		
	// 행정동 경계 레이어 토글 버튼 이벤트 핸들러 (수정된 전체 코드)
	toggleHjdLayerBtn.addEventListener('click', () => {
		const isActive = toggleHjdLayerBtn.classList.toggle('active');
	    // 1. 레이어가 아직 생성되지 않았다면(첫 클릭)
	    if (!hjdLayer) {
	        // 행정동 GeoJSON 소스 생성
	        const hjdSource = new ol.source.Vector({
	            url: `${contextPath}/data/hangjeongdong.geojson`,
	            format: new ol.format.GeoJSON()
	        });
	        
	        // 스타일을 동적으로 생성하는 '함수'로 변경
	        const hjdStyleFunction = function(feature) {
	            // 현재 지도의 줌 레벨 가져오기
	            const zoom = vmap.getView().getZoom();
	            
	            // 줌 레벨에 따른 폰트 크기 계산 (선형 보간)
	            const minZoom = 11; // 최소 폰트 크기를 적용할 줌 레벨
	            const maxZoom = 16; // 최대 폰트 크기를 적용할 줌 레벨
	            const minFont = 11; // 최소 폰트 크기
	            const maxFont = 30; // 최대 폰트 크기
	            
	            // 현재 줌 레벨이 min/max 범위를 벗어나지 않도록 고정
	            const clampedZoom = Math.max(minZoom, Math.min(zoom, maxZoom));
	            
	            // 폰트 크기 계산
	            let fontSize = minFont + (maxFont - minFont) * ((clampedZoom - minZoom) / (maxZoom - minZoom));
	            
	            // 경계선 스타일
	            const boundaryStyle = new ol.style.Style({
	                stroke: new ol.style.Stroke({
	                    color: 'rgba(0, 0, 0, 1.0)', // 완전한 검은색 (불투명도 100%)
	                    width: 1.5
	                }),
	                fill: new ol.style.Fill({
	                    color: 'rgba(255, 255, 255, 0.0)'
	                })
	            });

	            // 텍스트 라벨 스타일
	            const textStyle = new ol.style.Style({
	                text: new ol.style.Text({
	                    text: feature.get('ADM_NM'), // 'ADM_NM' 속성값으로 텍스트 설정
	                    font: `bold ${fontSize}px 'Malgun Gothic', sans-serif`,
	                    fill: new ol.style.Fill({ color: '#222' }),
	                    stroke: new ol.style.Stroke({ color: 'white', width: 3 })
	                })
	            });

	            // 경계선과 텍스트 스타일을 모두 반환
	            return [boundaryStyle, textStyle];
	        };

	        // 벡터 레이어 생성 및 변수에 할당
	        hjdLayer = new ol.layer.Vector({
	            source: hjdSource,
	            style: hjdStyleFunction, // 스타일 '객체'가 아닌 '함수'를 할당
	            declutter: true, // 줌 레벨에 따라 라벨이 겹치지 않도록 설정
				zIndex: 1
	        });

			vmap.addLayer(hjdLayer);
	    }

	    hjdLayer.setVisible(isActive);

	    if (isActive) {
	        addOverlayLegendItem('hjd', 'black', '행정동 경계');
	    } else {
	        removeOverlayLegendItem('hjd');
	    }
	});
	
    analysisButtons.forEach(button => {
        button.addEventListener('click', () => {
            analysisButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        });
    });

   analyzeBtn.addEventListener('click', () => {
		// 새로운 분석 시작 시, 리포트 사이드바를 닫습니다.
	    reportSidebar.classList.remove('active');
		
        const activeAnalysisBtn = document.querySelector('.analysis-btn.active');
        if (!activeAnalysisBtn) {
            alert("분석 유형을 선택해주세요.");
            return;
        }
        
		// 버튼의 텍스트 대신 data-analysis-type 속성 값을 사용합니다.
		const analysisType = activeAnalysisBtn.dataset.analysisType;
        
        Object.values(gridLayers).forEach(layer => layer.setVisible(false));
        
        if (gridLayers[analysisType]) {
            activeGridLayer = gridLayers[analysisType];
            activeGridLayer.setVisible(true);
        } else {
            const config = ANALYSIS_CONFIG[analysisType];
            const geojsonSource = new ol.source.Vector({
                url: config.geojsonUrl,
                format: new ol.format.GeoJSON()
            });
            
            activeGridLayer = new ol.layer.Vector({ source: geojsonSource, zIndex: 2 });
            gridLayers[analysisType] = activeGridLayer;
            vmap.addLayer(activeGridLayer);
            
			geojsonSource.on('featuresloadend', () => updateMapStyle());

		}

		layerSidebar.classList.add('visible');
		updateLayerList();
		updateMapStyle();
    	updateLegend(); // [추가] 범례를 업데이트하고 보이게 함

	});
    
	//'뒤로가기' 버튼 클릭 시
    backBtn.addEventListener('click', () => { 
		layerSidebar.classList.remove('visible');
		// [추가] 범례 컨테이너를 숨기고 내용을 초기화
	    analysisLegendContainer.style.display = 'none';
	    analysisLegend.innerHTML = '';
	});
	
    showReportBtn.addEventListener('click', () => {
        reportSidebar.classList.add('active');
        generateReportContent();
        vmap.updateSize();
    });
    closeReportBtn.addEventListener('click', () => { reportSidebar.classList.remove('active'); });
	
	//3. '데이터 레이어' 선택 시
    layerList.addEventListener('change', (event) => {
        if (event.target.name === 'layer-select') {
			updateMapStyle();
	        generateReportContent();
			// [추가] 레이어 변경 시 범례 업데이트
	        updateLegend(); 
        }
    });
	
    // ================================ 격자 ai 해석 내용 추가 ====================================

    // AI 분석용 모달 관련 요소 및 이벤트 핸들러
    const aiAnalysisModal = document.getElementById('aiAnalysisModal');
    const closeAiModalBtn = document.getElementById('closeAiModal');
    const aiModalTitle = document.getElementById('aiModalTitle');
    const aiModalBody = document.getElementById('aiModalBody');

    // AI 모달 닫기 버튼 이벤트
	// AI 모달 닫기 버튼 이벤트
	closeAiModalBtn.addEventListener('click', () => {
	    aiAnalysisModal.classList.remove('visible');
	});

	// 모달 바깥 영역 클릭 시 닫기
	aiAnalysisModal.addEventListener('click', (event) => {
	    // modal-content 내부가 아닌, 배경(modal-container)을 클릭했을 때만 닫히도록 수정
	    if (event.target === aiAnalysisModal) {
	        aiAnalysisModal.classList.remove('visible');
	    }
	});

    // 지도 클릭 시 AI 분석 모달 호출 이벤트 핸들러
	vmap.on('singleclick', function(evt) {
	    // 1순위: 프랜차이즈 포인트를 클릭했는지 확인
	    const franchiseFeature = vmap.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
	        if (Object.values(franchiseLayers).includes(layer)) {
	            return feature;
	        }
	    });

	    if (franchiseFeature) {
	        // 클릭된 것이 프랜차이즈 포인트일 경우 -> 팝업을 띄우고 모든 동작 종료
	        const coordinate = evt.coordinate;
	        const props = franchiseFeature.getProperties();
	        const storeName = props['매장명'] || '정보 없음';
	        const address = props['주소'] || '정보 없음';
	        const phone = props['전화번호'] || '정보 없음';
	        const brand = props['brand'] || '프랜차이즈';

	        const content = document.getElementById('popup-content');
	        content.innerHTML = `
	            <div class="popup-title">${brand} - ${storeName}</div>
	            <div class="popup-content">
	              <p><strong>주소:</strong> ${address}</p>
	              <p><strong>전화번호:</strong> ${phone}</p>
	            </div>
	        `;
	        popupOverlay.setPosition(coordinate);
	        return; // 여기서 함수 실행을 완전히 종료
	    }

	    // 프랜차이즈 포인트가 아니라면, 열려있던 팝업은 닫는다.
	    popupOverlay.setPosition(undefined);

	    // 2순위: 격자 분석이 활성화된 상태인지 확인
	    const activeAnalysisBtn = document.querySelector('.analysis-btn.active');
	    if (!activeAnalysisBtn || !activeGridLayer) {
	        return; // 분석 모드가 아니면 여기서 조용히 종료
	    }

		// 3순위: 프랜차이즈 또는 산업 레이어가 활성화된 상태인지 확인 (수정)
	    const isAnyFranchiseActive = Object.values(franchiseLayers).some(layer => layer.getVisible());
	    const isAnyBizActive = isAnyBizLayerActive();
	    
	    if (isAnyFranchiseActive || isAnyBizActive) {
	        // 활성화된 상태에서 격자를 클릭했는지 확인
	        const gridFeature = vmap.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
	            return feature;
	        }, {
	            layerFilter: function(layer) { return layer === activeGridLayer; }
	        });

	        if (gridFeature) {
	            alert("상권 및 산업 레이어를 모두 꺼야 격자 AI 분석이 가능합니다."); // 경고 메시지 수정
	        }
	        return; // 레이어가 켜져있으면 AI 분석 로직은 더 이상 실행하지 않음
	    }
	    
	    // 4순위: 모든 조건을 통과했으면, 격자를 찾아 AI 모달을 띄움 (기존 AI 분석 로직)
	    const gridFeatureForAI = vmap.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
	        return feature;
	    }, {
	        layerFilter: function(layer) { return layer === activeGridLayer; }
	    });

	    if (gridFeatureForAI) {
	        const properties = gridFeatureForAI.getProperties();
			const analysisType = activeAnalysisBtn.dataset.analysisType;
	        // ================== 분석 유형에 따른 분기 처리 ==================
			if (analysisType === '다중회귀모형') {
				const gid = properties.gid;
				if (!gid) return;

				// 동적 제목 설정 (수정됨)
		        const mainTitle = `격자 [${gid}] AI 분석`;
		        aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);


				aiModalBody.innerHTML = `
					<p>'${gid}' 격자에 대한 AI 상세 분석을 요청하시겠습니까?</p>
					<p><small>분석에는 약간의 시간이 소요될 수 있습니다.</small></p>
					<button id="requestAiBtn" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 16px;">분석 요청하기</button>
				`;
				aiAnalysisModal.classList.add('visible');

				document.getElementById('requestAiBtn').addEventListener('click', () => {
					handleRegressionAnalysisRequest(properties, analysisType);
				});

			} else if (analysisType === '군집분석') {
				const gid = properties.gid;
				if (gid === undefined || properties.cluster === undefined) return;
				
				// 동적 제목 설정 (수정됨)
		        const mainTitle = `격자 [${gid}] AI 군집 분석`;
		        aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);


				aiModalBody.innerHTML = `
					<p>이 격자는 <strong>'군집 ${properties.cluster}'</strong>에 속합니다.</p>
					   <p>AI 상세 분석을 요청하시겠습니까?</p>
					<p><small>분석에는 약간의 시간이 소요될 수 있습니다.</small></p>
					<button id="requestClusterAiBtn" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 16px;">분석 요청하기</button>
				`;
				aiAnalysisModal.classList.add('visible');

				document.getElementById('requestClusterAiBtn').onclick = () => {
					handleClusterAnalysisRequest(properties, analysisType);
				};
			} else if (analysisType === '로지스틱') {
				const gid = properties.gid;
				if (gid === undefined) return;
				
				// AI 분석 요청 모달 표시 (수정됨)
		        const mainTitle = `격자 [${gid}] AI 로지스틱 분석`;
		        aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);
				
				aiModalBody.innerHTML = `
					<p>'${gid}' 격자에 대한 AI 상세 분석을 요청하시겠습니까?</p>
					<p><small>모델이 이 격자를 왜 이렇게 예측했는지에 대한 심층 분석을 제공합니다.</small></p>
					<button id="requestLogisticAiBtn" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 16px;">분석 요청하기</button>
				`;
				aiAnalysisModal.classList.add('visible');

				// 버튼에 이벤트 리스너 추가
				document.getElementById('requestLogisticAiBtn').onclick = () => {
					handleLogisticAnalysisRequest(properties, analysisType);
				};
			} else if (analysisType === '중력모형') {
				const gid = properties.gid;
				if (gid === undefined) return;
				
				// AI 분석 요청 모달 표시 (수정됨)
		        const mainTitle = `격자 [${gid}] AI 중력모델 분석`;
		        aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);
		        
				
				aiModalBody.innerHTML = `
					<p>'${gid}' 격자에 대한 AI 상세 분석을 요청하시겠습니까?</p>
					<p><small>이 격자의 상권 흡인력에 대한 심층 분석을 제공합니다.</small></p>
					<button id="requestGravityAiBtn" class="btn btn-primary" style="width: 100%; padding: 10px; font-size: 16px;">분석 요청하기</button>
				`;
				aiAnalysisModal.classList.add('visible');

				// 버튼에 이벤트 리스너 추가
				document.getElementById('requestGravityAiBtn').onclick = () => {
					handleGravityAnalysisRequest(properties, analysisType);
				};
			}
	    }
	});
	
	//======================== 3. 동적 기능 함수들 ========================
	
	
	
	// 범례를 동적으로 생성하고 업데이트하는 함수
	function updateLegend() {
	    // 범례 컨테이너 초기화
	    analysisLegend.innerHTML = '';

	    const selectedRadio = layerList.querySelector('input[name="layer-select"]:checked');
	    if (!selectedRadio) {
	        analysisLegendContainer.style.display = 'none';
	        return;
	    }

	    analysisLegendContainer.style.display = 'block';
	    const selectedProperty = selectedRadio.value;
	    let legendHTML = '';

	    // 범례 생성을 위한 헬퍼 함수
	    const createLegendItem = (color, label) => `
	        <div class="legend-item">
	            <span class="legend-color-box" style="background-color:${color};"></span>
	            <span>${label}</span>
	        </div>`;

	    switch (selectedProperty) {
	        case 'residual_total_business':
	            legendHTML += createLegendItem('rgba(255, 182, 193, 0.7)', "예측보다 높은 지역 (성장 동력 존재)");
	            legendHTML += createLegendItem('rgba(10, 61, 98, 0.7)', "예측보다 낮은 지역 (성장 잠재력)");
	            break;

	        case 'cluster_result':
	            legendHTML += createLegendItem('rgba(255, 182, 193, 0.7)', "군집 0 (상업/인구 중심)");
	            legendHTML += createLegendItem('rgba(10, 61, 98, 0.7)', "군집 1 (주거/성장 잠재)");
	            break;
	            
	        case 'predicted_class':
	            legendHTML += createLegendItem('rgba(255, 182, 193, 0.7)', "핵심 상권 (예측=정답)");
	            legendHTML += createLegendItem('rgba(10, 61, 98, 0.7)', "잠재 상권 (예측=정답)");
	            legendHTML += createLegendItem('rgba(255, 165, 0, 0.7)', "숨은 상권 (예측=오답)");
	            break;
	        
	        case 'Gravity_Total':
	            const gravityColors = COLORS_4_CLASS_GRAVITY;
	            legendHTML += createLegendItem(gravityColors[3], "최상위 흡인력 (핵심 상권)");
	            legendHTML += createLegendItem(gravityColors[2], "상위 흡인력 (유망 상권)");
	            legendHTML += createLegendItem(gravityColors[1], "중위 흡인력 (보통 상권)");
	            legendHTML += createLegendItem(gravityColors[0], "하위 흡인력 (배후 지역)");
	            break;

	        default:
	            // 숫자 기반의 일반적인 범례 생성
	            const breaks = LEGEND_BREAKS[selectedProperty];
	            if (breaks) {
	                const colors = breaks.length > 5 ? COLORS_7_CLASS_ORANGE : COLORS_5_CLASS_ORANGE;
	                
	                // 첫번째 구간
	                legendHTML += createLegendItem(colors[0], `~ ${breaks[0].toLocaleString()}`);
	                
	                // 중간 구간
	                for (let i = 0; i < breaks.length - 1; i++) {
	                    legendHTML += createLegendItem(colors[i+1], `${(breaks[i]).toLocaleString()} ~ ${breaks[i+1].toLocaleString()}`);
	                }

	                // 마지막 구간
	                legendHTML += createLegendItem(colors[breaks.length], `${(breaks[breaks.length - 1]).toLocaleString()} ~`);
	            }
	            break;
	    }

	    analysisLegend.innerHTML = legendHTML;
	}
	
	/**
	 * AI 분석 결과를 이미지와 같은 테이블 형식으로 생성하는 함수
	 * @param {Array<Object>} reportData - {항목: '...', 내용: '...'} 형태의 객체 배열
	 * @returns {string} 생성된 테이블 HTML 문자열
	 */
	const createAiReportTable = (reportData) => {
	    // 테이블 시작
	    let tableHtml = '<table class="ai-analysis-table">';
	    
	    // 배열의 각 항목을 순회하며 테이블 행(row)을 만듭니다.
	    reportData.forEach(item => {
	        // 내용이 없으면 'no-data' 클래스 추가 및 기본 텍스트 설정
	        const content = item.내용 || '정보 없음';
	        const contentClass = item.내용 ? '' : 'class="no-data"';

	        tableHtml += `
	            <tr>
	                <th>${item.항목}</th>
	                <td ${contentClass}>${content.replace(/\n/g, '<br>')}</td>
	            </tr>
	        `;
	    });

	    // 테이블 종료
	    tableHtml += '</table>';

	    return tableHtml;
	};
	
	// 중력모델 분석 AI 요청을 처리하는 새 함수 추가
	function handleGravityAnalysisRequest(properties, analysisType) {
	    aiModalBody.innerHTML = '<div class="spinner"></div><p style="text-align:center;">AI가 중력모델을 기반으로 상권 흡인력을 분석 중입니다...</p>';

	    // 서버로 보낼 payload 생성 (Java DTO 필드명과 일치)
	    const payload = {
	        'gid': properties.gid,
	        'Gravity_Total': properties.Gravity_Total,
	        '인구 수': properties['인구 수'],
	        '공시지가': properties.공시지가,
			// 이 부분이 추가
	        'rank1AdmName': properties['1rank_AD_1'],
	        'rank1Perc': properties['1rank_perc'],
	        'rank2AdmName': properties['2rank_AD_1'],
	        'rank2Perc': properties['2rank_perc']
	    };

	    // 서버 API 호출
	    fetch(`${contextPath}/api/market/detailed/analyze-gravity-grid`, {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/json' },
	        body: JSON.stringify(payload),
	    })
	    .then(response => {
	        if (!response.ok) { throw new Error('서버 분석 중 오류 발생'); }
	        return response.json();
	    })
		.then(data => {
		    // 1. 제목 생성
		    const mainTitle = `AI 중력모델 상세 분석: [${properties.gid}]`;
		    aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);

		    // 2. 테이블로 표시할 데이터 구성
			const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);

	        // 2. AI 분석 리포트 테이블 생성
	        const reportData = [
	            { 항목: '핵심 요약', 내용: data.gridSummary },
	            { 항목: '상세 분석', 내용: data.analysisReason },
	            { 항목: '사업 기회', 내용: data.potential }
	        ];
	        const reportHtml = createAiReportTable(reportData);

	        // 3. 최종 HTML 조합
	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;

		    // 4. PDF 저장 버튼 관련 로직 (이 부분은 그대로 둡니다)
		    const modalFooter = document.getElementById('aiModalFooter');
		    const printBtn = document.getElementById('printPdfButton');
		    
		    modalFooter.style.display = 'block';
		    printBtn.disabled = false;
		    printBtn.textContent = 'PDF로 저장 (마이페이지)';

		    printBtn.onclick = () => {
		        handlePdfSaveAndUpload('중력모형', properties, data.analysisTitle);
		    };
		})
		.catch(error => {
		    console.error('AI Gravity Model Analysis Error:', error);
			const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);
		    const errorReportData = [
		        { 항목: '핵심 요약', 내용: AI_ERROR_MESSAGE },
		        { 항목: '상세 분석', 내용: '' },
		        { 항목: '사업 기회', 내용: '' }
		    ];
			const reportHtml = createAiReportTable(errorReportData);

	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;
	        document.getElementById('aiModalFooter').style.display = 'none';
		});
	}
	
	// 로지스틱 분석 AI 요청 처리 함수
	function handleLogisticAnalysisRequest(properties, analysisType) {
	    aiModalBody.innerHTML = '<div class="spinner"></div><p style="text-align:center;">AI가 로지스틱 회귀 모델을 기반으로 분석 중입니다...</p>';

	    // 서버로 보낼 payload 생성 (DTO와 필드명 일치)
	    const payload = {
	        'gid': properties.gid,
	        'cluster': properties.cluster,
	        '총 인구수': properties['총 인구수'],
	        '음식점 수': properties['음식점 수'],
	        '서비스업 종사자 수': properties['서비스업 종사자 수'],
	        'predicted_prob': properties.predicted_prob,
	        'predicted_class': properties.predicted_class,
	        '정답 여부': properties['정답 여부'],
			// 이 부분이 추가
	        'rank1AdmName': properties['1rank_AD_1'],
	        'rank1Perc': properties['1rank_perc'],
	        'rank2AdmName': properties['2rank_AD_1'],
	        'rank2Perc': properties['2rank_perc']
	    };

	    // 서버 API 호출
	    fetch(`${contextPath}/api/market/detailed/analyze-logistic-grid`, {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/json' },
	        body: JSON.stringify(payload),
	    })
	    .then(response => {
	        if (!response.ok) { throw new Error('서버 분석 중 오류 발생'); }
	        return response.json();
	    })
		.then(data => {
		    // 1. 제목 생성
		    const mainTitle = `AI 로지스틱 상세 분석: [${properties.gid}]`;
		    aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);

		    // 2. 테이블로 표시할 데이터 구성
			const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);

	        // 2. AI 분석 리포트 테이블 생성
	        const reportData = [
	            { 항목: '핵심 요약', 내용: data.gridSummary },
	            { 항목: '분석 근거', 내용: data.analysisReason },
	            { 항목: '사업 기회', 내용: data.potential }
	        ];
	        const reportHtml = createAiReportTable(reportData);

	        // 3. 최종 HTML 조합
	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;

		    // 4. PDF 저장 버튼 관련 로직 (이 부분은 그대로 둡니다)
		    const modalFooter = document.getElementById('aiModalFooter');
		    const printBtn = document.getElementById('printPdfButton');
		    
		    modalFooter.style.display = 'block';
		    printBtn.disabled = false;
		    printBtn.textContent = 'PDF로 저장 (마이페이지)';

		    printBtn.onclick = () => {
		        handlePdfSaveAndUpload('로지스틱', properties, data.analysisTitle);
		    };
		})
		.catch(error => {
		    console.error('AI Logistic Analysis Error:', error);
			const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);
			
		    const errorReportData = [
		        { 항목: '핵심 요약', 내용: AI_ERROR_MESSAGE },
		        { 항목: '분석 근거', 내용: '' },
		        { 항목: '사업 기회', 내용: '' }
		    ];
			const reportHtml = createAiReportTable(errorReportData);

	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;
	        document.getElementById('aiModalFooter').style.display = 'none';
		});
	}
	
	// 군집 분석 AI 요청 처리 함수
	function handleClusterAnalysisRequest(properties, analysisType) {
	        aiModalBody.innerHTML = '<div class="spinner"></div><p style="text-align:center;">AI가 군집 특성을 분석하고 있습니다...</p>';
	        
	        // 서버로 보낼 Payload를 격자 정보만 담도록 수정합니다.
	        const requestPayload = {
	            gid: properties.gid,
	            clusterId: properties.cluster,
		        rank1AdmName: properties['1rank_AD_1'],
		        rank1Perc: properties['1rank_perc'],
		        rank2AdmName: properties['2rank_AD_1'],
		        rank2Perc: properties['2rank_perc'],
	            variables: {
					'20~39세 인구 비율': properties['20~39세 인구 비율'],
	                '총 인구수': properties['총 인구수'],
	                '1인가구 비율': properties['1인가구 비율'],
	                '총가구수': properties['총가구수'],
	                '음식점 수': properties['음식점 수'],
	                '도소매업체 수': properties['도소매업체 수'],
	                '전체 사업체 수': properties['전체 사업체 수'],
	                '서비스업 종사자 수': properties['서비스업 종사자 수'],
	                '도소매업 종사자 수': properties['도소매업 종사자 수'],
	                '2000년 이후 주택 비율': properties['2000년 이후 주택 비율']
	            }
	        };

	        // 군집분석 서버 API 호출
		    fetch(`${contextPath}/api/market/detailed/analyze-cluster-grid`, {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
		        body: JSON.stringify(requestPayload),
		    })
		    .then(response => {
		        if (!response.ok) { throw new Error('서버 분석 중 오류 발생'); }
		        return response.json();
		    })
			.then(data => {
			    // 1. 제목 생성
			    const mainTitle = `AI 군집 상세 분석: [${properties.gid}]`;
			    aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);

			    // 2. 테이블로 표시할 데이터 구성
				const targetData = [
		            { 항목: '격자 ID', 내용: properties.gid },
		            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
		            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
		            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
		        ];
		        const targetDataHtml = createAiReportTable(targetData);

		        const characteristics = data.gridClusterAnalysis.characteristics.map(item => `• ${item}`).join('\n');
		        const reportData = [
		            { 항목: '핵심 요약', 내용: data.gridClusterAnalysis.title },
		            { 항목: '주요 특징', 내용: characteristics },
		            { 항목: '사업 기회', 내용: data.gridSpecificPotential }
		        ];
		        const reportHtml = createAiReportTable(reportData);

		        aiModalBody.innerHTML = `
		            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
		            ${targetDataHtml}
		            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
		            ${reportHtml}
		        `;
			    
			    // 4. PDF 저장 버튼 관련 로직 (이 부분은 그대로 둡니다)
			    const modalFooter = document.getElementById('aiModalFooter');
			    const printBtn = document.getElementById('printPdfButton');
			    
			    modalFooter.style.display = 'block';
			    printBtn.disabled = false;
			    printBtn.textContent = 'PDF로 저장 (마이페이지)';

			    printBtn.onclick = () => {
			        handlePdfSaveAndUpload('군집분석', properties, data.gridClusterAnalysis.title);
			    };
			})
			.catch(error => {
			    console.error('AI Cluster Analysis Error:', error);

				const targetData = [
		            { 항목: '격자 ID', 내용: properties.gid },
		            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
		            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
		            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
		        ];
		        const targetDataHtml = createAiReportTable(targetData);
				
				const errorReportData = [
			        { 항목: '핵심 요약', 내용: AI_ERROR_MESSAGE },
			        { 항목: '주요 특징', 내용: '' },
			        { 항목: '사업 기회', 내용: '' }
			    ];
				
		        const reportHtml = createAiReportTable(errorReportData);
		        aiModalBody.innerHTML = `
		            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
		            ${targetDataHtml}
		            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
		            ${reportHtml}
		        `;
		        document.getElementById('aiModalFooter').style.display = 'none';
			});
	    }
	
	
	// 다중회귀 분석 AI 요청 처리 함수
	function handleRegressionAnalysisRequest(properties, analysisType) {
	    // 로딩 스피너 표시
	    aiModalBody.innerHTML = '<div class="spinner"></div><p style="text-align:center;">AI가 격자를 분석하고 있습니다...</p>';

	    const payload = {
	        'gid': properties.gid,
			'1rank_AD_1': properties['1rank_AD_1'],
	        '1rank_perc': properties['1rank_perc'],
	        '2rank_AD_1': properties['2rank_AD_1'],
	        '2rank_perc': properties['2rank_perc'],
	        '총사업체수': properties['총사업체수'],
	        '총인구': properties['총인구'],
	        '30~34세 남녀 인구 합': properties['30~34세 남녀 인구 합'],
	        '1인가구 수': properties['1인가구 수'],
	        '신축 주택 비율': properties['신축 주택 비율'],
	        '도소매업체수': properties['도소매업체수'],
	        '숙박음식업체수': properties['숙박음식업체수'],
	        '정보통신업체수': properties['정보통신업체수'],
	        '건설업체수': properties['건설업체수'],
	        '교육서비스업체수': properties['교육서비스업체수'],
	        'predicted_total_business': properties.predicted_total_business,
	        'residual_total_business': properties.residual_total_business
	    };

	    // 서버로 분석 요청
	    fetch(`${contextPath}/api/market/detailed/analyze-grid`, {
	        method: 'POST',
	        headers: {
	            'Content-Type': 'application/json',
	        },
	        body: JSON.stringify(payload),
	    })
	    .then(response => {
	        if (!response.ok) {
	            throw new Error('서버에서 분석 중 오류가 발생했습니다.');
	        }
	        return response.json();
	    })
		.then(data => {
		    // 1. 제목 생성
		    const mainTitle = `AI 다중회귀 상세 분석: [${properties.gid}]`;
		    aiModalTitle.innerHTML = createModalTitle(mainTitle, properties);
			
			// 1. 분석 대상 데이터 테이블 생성
	        const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);
			
		    // 2. 테이블로 표시할 데이터 구성
		    const reportData = [
		        { 항목: '핵심 요약', 내용: data.summaryContent },
		        { 항목: '상세 분석', 내용: data.analysisDetails },
		        { 항목: '사업 기회', 내용: data.potential }
		    ];

		    const reportHtml = createAiReportTable(reportData);
			
			// 3. 최종 HTML 조합
	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;
			
		    // 4. PDF 저장 버튼 관련 로직 (이 부분은 그대로 둡니다)
		    const modalFooter = document.getElementById('aiModalFooter');
		    const printBtn = document.getElementById('printPdfButton');
		    
		    modalFooter.style.display = 'block';
		    printBtn.disabled = false;
		    printBtn.textContent = 'PDF로 저장 (마이페이지)';

		    printBtn.onclick = () => {
		        handlePdfSaveAndUpload('다중회귀모형', properties, data.summaryTitle || '다중회귀 분석 리포트');
		    };
		})
		.catch(error => {
		    console.error('AI Analysis Error:', error);

			const targetData = [
	            { 항목: '격자 ID', 내용: properties.gid },
	            { 항목: '분석 모델', 내용: ANALYSIS_MODEL_NAMES[analysisType] },
	            { 항목: '주요 행정동 1', 내용: properties['1rank_AD_1'] ? `${properties['1rank_AD_1']} (${properties['1rank_perc']}%)` : '정보 없음' },
	            { 항목: '주요 행정동 2', 내용: properties['2rank_AD_1'] ? `${properties['2rank_AD_1']} (${properties['2rank_perc']}%)` : '정보 없음' }
	        ];
	        const targetDataHtml = createAiReportTable(targetData);

			const errorReportData = [
		        { 항목: '핵심 요약', 내용: AI_ERROR_MESSAGE },
		        { 항목: '상세 분석', 내용: '' },
		        { 항목: '사업 기회', 내용: '' }
		    ];
			
	        const reportHtml = createAiReportTable(errorReportData);

	        aiModalBody.innerHTML = `
	            <h4 class="ai-modal-section-title">분석 대상 데이터</h4>
	            ${targetDataHtml}
	            <h4 class="ai-modal-section-title">AI 분석 리포트</h4>
	            ${reportHtml}
	        `;
	        document.getElementById('aiModalFooter').style.display = 'none';
		});
	}
	
		
	function updateLayerList() {
        const activeAnalysisBtn = document.querySelector('.analysis-btn.active');
        if (!activeAnalysisBtn) return;
        
        const analysisType = activeAnalysisBtn.dataset.analysisType;
        const config = ANALYSIS_CONFIG[analysisType];
        
        layerList.innerHTML = '';
        config.layers.forEach((layer, index) => {
            const li = document.createElement('li');
            li.className = 'layer-item';
            li.innerHTML = `<label for="layerRadio${index}">${layer.label}</label> <input type="radio" id="layerRadio${index}" name="layer-select" value="${layer.value}" ${index === 0 ? 'checked' : ''}>`;
            layerList.appendChild(li);
        });
    }
    
	function updateMapStyle() {
        if (!activeGridLayer) return;
        const selectedRadio = layerList.querySelector('input[name="layer-select"]:checked');
        if (!selectedRadio) return;

        const selectedProperty = selectedRadio.value;
        let styleFunction;

        if (selectedProperty === 'cluster_result') {
            styleFunction = (feature) => {
                const clusterId = feature.get('cluster');
                const fillColor = clusterId === 0 ? 'rgba(255, 182, 193, 0.7)' : 'rgba(10, 61, 98, 0.7)'; 
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({
						 color: 'rgba(0, 0, 0, 0.9)', 
						 width: 1 
					 }),
                    fill: new ol.style.Fill({ color: fillColor })
                });
            };
        } 
        else if (selectedProperty === 'residual_total_business') {
            styleFunction = (feature) => {
                const residual = feature.get(selectedProperty);
                const fillColor = residual > 0 ? 'rgba(255, 182, 193, 0.7)' : 'rgba(10, 61, 98, 0.7)';
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'rgba(0, 0, 0, 0.5)', width: 1 }),
                    fill: new ol.style.Fill({ color: fillColor })
                });
            };
        }
		else if (selectedProperty === 'predicted_class') { // 로지스틱 분석 결과에 대한 스타일링 함수
            styleFunction = (feature) => {
                const isCorrect = feature.get('정답 여부');
                const predictedClass = feature.get('predicted_class');
                let fillColor = 'rgba(255, 255, 255, 0.1)'; // 기본값 (혹시 모를 오류 대비)

                if (isCorrect === '오답') {
                    fillColor = 'rgba(255, 165, 0, 0.7)'; // 주황색
                } else if (isCorrect === '정답') {
                    if (predictedClass === 0) {
                        fillColor = 'rgba(255, 182, 193, 0.7)'; // 연한 핑크
                    } else if (predictedClass === 1) {
                        fillColor = 'rgba(10, 61, 98, 0.7)'; // 연한 하늘색
                    }
                }
                
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'rgba(0, 0, 0, 0.5)', width: 1 }),
                    fill: new ol.style.Fill({ color: fillColor })
                });
            };
        }
		else if (selectedProperty === 'Gravity_Total') { // 중력모형 분석 결과('Gravity_Total')를 위한 스타일 함수 추가
            const breaks = LEGEND_BREAKS[selectedProperty]; // [86.47, 583.59, 12974.21]
            const colors = COLORS_4_CLASS_GRAVITY;
            styleFunction = (feature) => {
                const value = feature.get(selectedProperty) || 0;
                let fillColor;
                if (value <= breaks[0]) fillColor = colors[0]; // 하위 (회색)
                else if (value <= breaks[1]) fillColor = colors[1]; // 중위 (연두)
                else if (value <= breaks[2]) fillColor = colors[2]; // 상위 (노랑)
                else fillColor = colors[3]; // 최상위 (빨강)
                
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'rgba(0, 0, 0, 0.5)', width: 1 }),
                    fill: new ol.style.Fill({ color: fillColor })
                });
            };
        }
        else {
			// 원래의 안정적인 if/else 로직으로 복원
            const breaks = LEGEND_BREAKS[selectedProperty];
            if (!breaks) return; 

            const colors = breaks.length > 5 ? COLORS_7_CLASS_ORANGE : COLORS_5_CLASS_ORANGE;
            styleFunction = (feature) => {
                const value = Math.max(0, feature.get(selectedProperty) || 0);
                let fillColor;

                if (breaks.length > 5) { // 7단계 범례 로직
                    if (value <= breaks[0]) fillColor = colors[0];
                    else if (value <= breaks[1]) fillColor = colors[1];
                    else if (value <= breaks[2]) fillColor = colors[2];
                    else if (value <= breaks[3]) fillColor = colors[3];
                    else if (value <= breaks[4]) fillColor = colors[4];
                    else if (value <= breaks[5]) fillColor = colors[5];
                    else fillColor = colors[6];
                } else { // 5단계 범례 로직
                    if (value <= breaks[0]) fillColor = colors[0];
                    else if (value <= breaks[1]) fillColor = colors[1];
                    else if (value <= breaks[2]) fillColor = colors[2];
                    else if (value <= breaks[3]) fillColor = colors[3];
                    else fillColor = colors[4];
                }
                
                return new ol.style.Style({
                    stroke: new ol.style.Stroke({ color: 'rgba(0, 0, 0, 0.5)', width: 1 }),
                    fill: new ol.style.Fill({ color: fillColor })
                });
            };
        }
        activeGridLayer.setStyle(styleFunction);
    }
	
	// ======================== [신규] PCA 차트 생성 함수 ========================
	/**
	 * Highcharts를 사용하여 PCA 스캐터플롯을 그립니다.
	 * @param {Array} features - OpenLayers 벡터 레이어의 피처 배열
	 */
	function drawPcaChart(features) {
	    // 클러스터별로 데이터를 담을 배열 초기화
	    const cluster0Data = [];
	    const cluster1Data = [];

	    // 각 피처를 순회하며 PC1, PC2, 클러스터 값을 추출
	    features.forEach(feature => {
	        const properties = feature.getProperties();
	        const pc1 = properties.PC1;
	        const pc2 = properties.PC2;
	        const cluster = properties.cluster;

	        // 데이터 포인트 객체 생성 {x, y, gid}
	        const dataPoint = {
	            x: pc1,
	            y: pc2,
	            gid: properties.gid // 툴팁에 gid를 표시하기 위해 추가
	        };

	        // 클러스터 값에 따라 해당 배열에 데이터 추가
	        if (cluster === 0) {
	            cluster0Data.push(dataPoint);
	        } else if (cluster === 1) {
	            cluster1Data.push(dataPoint);
	        }
	    });

	    // Highcharts 생성
	    Highcharts.chart('pcaChartContainer', {
	        chart: {
	            type: 'scatter',
	            zoomType: 'xy' // x, y 축으로 줌 가능하도록 설정
	        },
	        title: {
	            text: '주성분 분석(PCA) 결과 시각화'
	        },
	        subtitle: {
	            text: '각 점은 하나의 격자(1km)를 나타냅니다.'
	        },
	        xAxis: {
	            title: {
	                enabled: true,
	                text: '주성분 1 (PC1)'
	            },
	            startOnTick: true,
	            endOnTick: true,
	            showLastLabel: true
	        },
	        yAxis: {
	            title: {
	                text: '주성분 2 (PC2)'
	            }
	        },
			legend: {
	            layout: 'horizontal',  // 범례 항목을 수평으로 나열
	            align: 'right',        // 컨테이너의 오른쪽에 정렬
	            verticalAlign: 'top'   // 컨테이너의 상단에 정렬
	        },
	        plotOptions: {
	            scatter: {
	                marker: {
	                    radius: 5,
	                    states: {
	                        hover: {
	                            enabled: true,
	                            lineColor: 'rgb(100,100,100)'
	                        }
	                    }
	                },
	                states: {
	                    hover: {
	                        marker: {
	                            enabled: false
	                        }
	                    }
	                },
	                tooltip: {
	                    headerFormat: '<b>격자: {point.point.gid}</b><br>',
	                    pointFormat: 'PC1: {point.x:.2f}, PC2: {point.y:.2f}'
	                }
	            }
	        },
	        series: [{
	            name: '군집 0',
	            color: 'rgba(255, 182, 193, 0.7)', // 핑크색
	            data: cluster0Data
	        }, {
	            name: '군집 1',
	            color: 'rgba(10, 61, 98, 0.7)', // 하늘색
	            data: cluster1Data
	        }]
	    });
	}
	
	// ======================== [수정] 리포트 생성 함수 ========================
	function generateReportContent() {
	    const activeAnalysisBtn = document.querySelector('.analysis-btn.active');
	    const pcaChartContainer = document.getElementById('pcaChartContainer');
	    if (!activeAnalysisBtn) {
	        reportBody.innerHTML = '<p>해석할 분석 결과를 선택해주세요.</p>';
	        return;
	    }
	    
	    const analysisType = activeAnalysisBtn.dataset.analysisType;

	    // ✨ 군집분석일 경우, 차트 생성 및 컨테이너 표시
	    if (analysisType === '군집분석' && activeGridLayer) {
	        pcaChartContainer.style.display = 'block'; // 차트 컨테이너 보이기
	        const features = activeGridLayer.getSource().getFeatures();
	        if (features.length > 0) {
	            drawPcaChart(features); // 차트 그리기 함수 호출
	        }
	    } else {
	        pcaChartContainer.style.display = 'none'; // 다른 분석일 경우 숨기기
	    }


	    const selectedRadio = layerList.querySelector('input[name="layer-select"]:checked');
	    if (!selectedRadio) {
	        reportBody.innerHTML = '<p>해석할 분석 결과를 선택해주세요.</p>';
	        return;
	    }
	    const selectedProperty = selectedRadio.value;
	    const selectedLabel = layerList.querySelector(`label[for="${selectedRadio.id}"]`).textContent;
	    
		// ✨ [수정된 핵심 로직]
	    // '군집분석'이면서 '군집분석 결과'가 선택되었을 때만 차트를 표시합니다.
	    if (analysisType === '군집분석' && selectedProperty === 'cluster_result' && activeGridLayer) {
	        pcaChartContainer.style.display = 'block'; // 차트 컨테이너 보이기
	        const features = activeGridLayer.getSource().getFeatures();
	        if (features.length > 0) {
	            drawPcaChart(features); // 차트 그리기 함수 호출
	        }
	    } else {
	        pcaChartContainer.style.display = 'none'; // 그 외 모든 경우에는 차트 숨기기
	    }
		
	    let reportHTML = '';

		// ✨ 모든 case에 대한 설명을 복원
	    switch(selectedProperty) {
			// 중력모형 분석 리포트 케이스 추가
            case 'Gravity_Total':
                reportHTML = `
                    <div class="report-section">
                        <h4>🤷‍♀️ 중력모형이란? (분석 이야기)</h4>
                        <p>물리학의 만유인력 법칙처럼, <strong>"더 큰 상권은 더 많은 사람을 끌어당기고, 거리가 멀어질수록 그 힘은 약해진다"</strong>는 원리를 상권 분석에 적용한 모델입니다.</p>
                        <p>각 지역의 매력도(인구, 공시지가 등)와 지역 간의 거리를 종합하여, 특정 지역이 주변으로부터 사람들을 얼마나 강력하게 끌어당기는지 '상권 흡인력'을 과학적으로 계산합니다.</p>
                    </div>
                    <hr>
                    <div class="report-section">
                        <h4>🎨 지도로 보는 우리 동네 상권의 힘!</h4>
                        <p>지도 위의 색상은 각 지역의 <strong>'상권 흡인력 점수(Gravity_Total)'</strong> 등급을 나타냅니다. 점수가 높을수록 주변의 유동인구를 강력하게 끌어들이는 중심지임을 의미합니다.</p>
                        <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:rgba(255, 0, 0, 0.7); vertical-align:middle; margin-right:5px;"></span>빨간색 지역 (최상위)</strong><br>주변 상권의 유동인구를 가장 강력하게 끌어들이는 <strong>핵심 상권</strong>입니다. 신규 창업 시 가장 먼저 고려해야 할 '핫플레이스'입니다.</p>
                        <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:rgba(255, 255, 0, 0.7); vertical-align:middle; margin-right:5px;"></span>노란색 지역 (상위)</strong><br>잠재력이 높고 활성화된 <strong>유망 상권</strong>입니다. 합리적인 비용으로 높은 효과를 기대할 수 있는 매력적인 곳입니다.</p>
                        <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:rgba(144, 238, 144, 0.7); vertical-align:middle; margin-right:5px;"></span>연두색 지역 (중위)</strong><br>주변에 영향을 받지만, 자체적인 흡인력도 어느 정도 갖춘 <strong>보통 상권</strong> 지역입니다. 특정 고객층을 대상으로 하는 업종에 적합할 수 있습니다.</p>
                        <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:rgba(211, 211, 211, 0.7); vertical-align:middle; margin-right:5px;"></span>회색 지역 (하위)</strong><br>주로 주변 상권으로 인구가 유출되는 <strong>배후 주거지 또는 비활성 지역</strong>입니다. 이 지역의 고객들이 어느 상권으로 향하는지 파악하여 마케팅 전략을 세우는 데 활용할 수 있습니다.</p>
                    </div>`;
                break;
            case '인구 수':
                reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석 (중력모형)</h4><p>인구는 상권의 가장 기본적인 '질량'입니다. 인구가 많은 지역은 그 자체로 큰 잠재 수요를 가지며, 주변 지역을 끌어당기는 힘의 원천이 됩니다.</p><p>이 지도는 <strong>상권의 배후 수요 크기</strong>를 보여줍니다. 색상이 진할수록 거주 인구가 많아, 안정적인 고객 기반을 확보하기 유리한 지역임을 의미합니다.</p></div>`;
                break;
            case '공시지가':
                reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석 (중력모형)</h4><p>공시지가는 토지의 경제적 가치를 나타내며, <strong>상권의 현재 '가치'와 '활력'</strong>을 보여주는 중요한 지표입니다.</p><p>공시지가가 높은 지역은 이미 상업적으로 매우 활성화되어 있고, 많은 사람이 찾는다는 강력한 증거입니다. 중력 모델에서 이 값은 해당 지역이 사람들을 끌어당기는 '매력도'에 큰 영향을 미칩니다.</p></div>`;
                break;
			// --- 로지스틱 분석 리포트 ---
			case 'predicted_class':
	            reportHTML = `
	                <div class="report-section">
	                    <h4>🤷‍♀️ 우리 동네 상권, 발달했을까? (분석 이야기)</h4>
	                    <p>"이 동네는 상권이 활발하다", "여긴 좀 조용하다" 우리 모두 어렴풋이 느끼고 있죠. 저희는 이 느낌을 데이터로 확인해보고 싶었습니다.</p>
	                    <p>먼저 군집분석이라는 기술로 전국의 지역들을 비슷한 특징끼리 묶어 <strong>'상권 발달 지역(그룹 0)'</strong>과 '상권 성장 잠재 지역(그룹 1)' 두 그룹으로 나누었습니다.</p>
	                    <p>그다음, "대체 두 그룹은 '왜' 다른 걸까?" 라는 질문에 답하기 위해 로지스틱 회귀분석을 사용했습니다. 이 분석은 어떤 조건(인구수, 음식점 수 등)이 주어졌을 때, 특정 지역이 '발달 지역'에 속할지 '잠재 지역'에 속할지 그 가능성(확률)을 예측하고 원인을 설명해주는 아주 똑똑한 분석 방법입니다.</p>
	                </div>
	                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
	                <div class="report-section">
	                    <h4>📊 분석 결과, 한눈에 살펴보기</h4>
	                    <p>분석 결과를 보면 어떤 요인이 상권 발달에 중요한지 알 수 있습니다.</p>
	                    <table style="width:100%; border-collapse: collapse; margin-top:10px; font-size: 14px;">
	                        <thead style="background-color:#f2f2f2;">
	                            <tr>
	                                <th style="padding:8px; border:1px solid #ddd; text-align:left;">요인 (Variable)</th>
	                                <th style="padding:8px; border:1px solid #ddd; text-align:left;">영향력 (Coef.)</th>
	                                <th style="padding:8px; border:1px solid #ddd; text-align:left;">설명</th>
	                            </tr>
	                        </thead>
	                        <tbody>
	                            <tr>
	                                <td style="padding:8px; border:1px solid #ddd;">총 인구수</td>
	                                <td style="padding:8px; border:1px solid #ddd;">-0.0003</td>
	                                <td style="padding:8px; border:1px solid #ddd;">많을수록 '상권 발달 지역(0)'일 확률이 높아져요.</td>
	                            </tr>
	                            <tr>
	                                <td style="padding:8px; border:1px solid #ddd;">음식점 수</td>
	                                <td style="padding:8px; border:1px solid #ddd;">-0.0461</td>
	                                <td style="padding:8px; border:1px solid #ddd;">많을수록 '상권 발달 지역(0)'일 확률이 높아져요.</td>
	                            </tr>
	                            <tr>
	                                <td style="padding:8px; border:1px solid #ddd;">서비스업 종사자 수</td>
	                                <td style="padding:8px; border:1px solid #ddd;">-0.0010</td>
	                                <td style="padding:8px; border:1px solid #ddd;">많을수록 '상권 발달 지역(0)'일 확률이 높아져요.</td>
	                            </tr>
	                        </tbody>
	                    </table>
	                    <p style="margin-top:15px;"><strong>쉽게 말해,</strong> 모델은 "인구, 음식점, 서비스업 종사자 수가 많으면 상권 발달 지역이야!" 라고 이야기하고 있습니다. 영향력(Coef.)의 숫자가 마이너스(-)인 이유는 '잠재 지역(1)'이 될 확률을 낮춘다는 의미인데, 반대로 생각하면 '발달 지역(0)'이 될 확률을 높인다는 뜻이죠!</p>
	                </div>
	                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
	                <div class="report-section">
	                    <h4>🎨 지도로 보는 우리 동네 성격 파악하기</h4>
	                    <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:#ffb6c1; vertical-align:middle; margin-right:5px;"></span>분홍색 지역: 확실한 핵심 상권</strong><br>실제 그룹: 발달 지역(0) / 모델 예측: 발달 지역(0)<br>누가 봐도 번화한 동네입니다. 인구도 많고, 맛집도 즐비하죠. 모델도 "여긴 확실한 발달 지역이네!"라고 정확히 예측한 곳들입니다.</p>
	                    <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:#0a3d62; vertical-align:middle; margin-right:5px;"></span>파란색 지역: 성장이 기대되는 잠재 상권</strong><br>실제 그룹: 잠재 지역(1) / 모델 예측: 잠재 지역(1)<br>아직은 조용하지만, 그래서 새로운 기회가 있는 동네입니다. 모델도 이러한 특징을 정확히 파악하여 '성장 잠재 지역'으로 분류했습니다. 창업이나 새로운 투자를 고려하기 좋은 곳이죠.</p>
	                    <p><strong><span style="display:inline-block; width:14px; height:14px; background-color:darkorange; vertical-align:middle; margin-right:5px;"></span>주황색 지역: 독특한 매력의 숨은 상권</strong><br>실제 그룹과 모델 예측이 다른 곳<br>이 지역들이야말로 숨겨진 보석입니다! 모델이 헷갈렸다는 건, 다른 곳에 없는 독특한 특징이 있다는 뜻이거든요.<br>
	                    <small><strong>예시 1:</strong> 실제론 '발달 지역'인데 모델이 '잠재 지역'으로 예측했다? → 인구수에 비해 음식점이 적은 '오피스 상권'이나 '학원가'일 수 있습니다.</small><br>
	                    <small><strong>예시 2:</strong> 실제론 '잠재 지역'인데 모델이 '발달 지역'으로 예측했다? → 최근 인구가 급증한 '신축 아파트 단지'처럼, 사람은 많은데 아직 상권이 따라가지 못한 '떠오르는 상권'일 수 있습니다.</small></p>
	                </div>
	                <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0;">
	                <div class="report-section">
	                    <h4>🔬 조금 더 깊게: 통계 전문가처럼 살펴보기</h4>
	                    <p><strong>P>|z| (p-value, 유의확률)</strong><br>이 값은 <strong>'이 변수가 얼마나 의미 있는가?'</strong>를 알려주는 신뢰도 점수입니다. 보통 0.05보다 작으면 "통계적으로 유의미하다" 즉, "믿을 만한 변수다!"라고 말합니다.<br>분석 결과, <strong>총 인구수(0.0003), 음식점 수(0.0000), 서비스업 종사자 수(0.0046)</strong> 모두 0.05보다 훨씬 작습니다. 이는 세 가지 요인 모두 상권을 구분하는 데 매우 중요하고 확실한 영향을 미친다는 것을 통계적으로 증명합니다.</p>
	                    <p><strong>Pseudo R-squared (유사 R-제곱)</strong><br>이 값은 <strong>'그래서 이 모델이 얼마나 설명을 잘하는데?'</strong>를 나타내는 설명력 점수입니다. 0부터 1까지의 값을 가지며, 1에 가까울수록 완벽한 모델입니다.<br>분석 결과, 이 값은 <strong>0.886</strong> 입니다. 이는 우리가 사용한 단 3개의 변수(인구, 음식점, 서비스업 종사자)만으로도 상권이 '발달' 또는 '잠재' 지역으로 나뉘는 이유의 <strong>88.6%를 설명</strong>할 수 있다는 의미입니다. 굉장히 높은 수치로, 이 모델이 상권의 특성을 매우 정확하게 파악하고 있다는 것을 보여줍니다.</p>
	                </div>`;
	            break;
	        // 로지스틱 분석 관점에서의 변수별 리포트 ---
	        case '총 인구수':
	            reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석 (로지스틱 분석)</h4><p>군집분석에서 '총 인구수'는 단순히 지역을 나누는 여러 특징 중 하나였지만, 로지스틱 분석에서는 <strong>상권 발달 여부를 예측하는 핵심적인 '예측 변수'</strong>로 그 의미가 강화됩니다.</p><p>우리 모델은 <strong>총 인구수가 많을수록 해당 지역이 '상권 발달 지역(0)'일 확률이 통계적으로 유의미하게 높아진다</strong>는 사실을 발견했습니다. 즉, 인구는 상권의 활력을 지탱하는 가장 근본적인 조건임을 예측 모델을 통해 증명한 것입니다.</p></div>`;
	            break;
	        case '음식점 수':
	            reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석 (로지스틱 분석)</h4><p>군집분석이 단순히 음식점 수가 비슷한 지역끼리 묶었다면, 로지스틱 분석은 <strong>'음식점 수'가 '상권 발달 지역(0)'을 예측하는 강력한 단서</strong>임을 보여줍니다.</p><p>모델의 분석 결과, 음식점 수가 많다는 것은 해당 지역을 '상권 발달 지역'으로 예측하게 만드는 매우 중요한 요인입니다. 이는 단순히 가게가 많다는 것을 넘어, <strong>활발한 상업 활동과 유동 인구를 증명하는 지표</strong>로 작용합니다.</p></div>`;
	            break;
	        case '서비스업 종사자 수':
	            reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석 (로지스틱 분석)</h4><p>로지스틱 분석 모델에서 '서비스업 종사자 수'는 <strong>상권의 성격을 규정하고 미래를 예측하는 중요한 변수</strong>입니다.</p><p>이 수치가 높을수록 모델은 해당 지역을 '상권 발달 지역(0)'으로 예측할 확률이 높아집니다. 이는 서비스업 종사자 수가 <strong>단순한 인구 지표를 넘어, 지역 내 고용 규모와 경제 활동의 집중도를 보여주는 핵심 지표</strong>임을 의미합니다.</p></div>`;
	            break;
			case 'cluster_result':
                reportHTML = `
                    <div class="report-section">
                        <h4>🧩 군집(Cluster) 분석, 어떻게 읽어야 할까요?</h4>
                        <p>군집분석은 비슷한 특성을 가진 지역들을 그룹으로 묶어주는 AI 기법입니다. 수많은 변수들을 종합하여 각 지역의 '성격'을 정의하고, 이를 통해 도시 전체를 몇 개의 대표적인 유형으로 나누어 볼 수 있습니다.</p>
                        <p>이 지도는 대전시 전체를 <strong>2개의 주요 그룹(군집)</strong>으로 분류한 결과입니다. 각 색상은 서로 다른 특성을 가진 지역 그룹을 나타냅니다.</p>
                    </div>
                    <div class="report-section">
                        <h4>🎨 색상으로 지역의 성격 파악하기</h4>
						<p><strong><span style="color: #ffb6c1;">■ 핑크색 지역 (군집 0)</span></strong><br>이 지역들은 주로 어떤 특성(예: '높은 상업 활력도와 젊은 인구 밀집')을 공유하는 그룹일 수 있습니다. 이 군집의 구체적인 특성은 변수별 평균값을 비교(레이더 차트 등)하여 더 깊이 파악할 수 있습니다.</p>
						<p><strong><span style="color: #0a3d62;">■ 파란색 지역 (군집 1)</span></strong><br>이 지역들은 핑크색 지역과는 다른 특성(예: '안정된 주거지역 및 가족 단위 인구 중심')을 공유하는 그룹일 가능성이 높습니다. 마케팅 전략이나 정책 수립 시, 각 군집의 특성에 맞는 접근 방식이 필요합니다.</p>
                    </div>
					<hr>
					<div class="report-section">
						<h4>📊 주성분 분석(PCA) 차트 심층 분석</h4>
						<p>PCA 차트는 각 지역의 복잡한 특성(인구, 상업, 주택 등)을 <strong>두 가지 핵심 요인(PC1, PC2)으로 압축</strong>하여 2차원 평면에 시각화한 것입니다. 이를 통해 우리는 각 군집의 내부적인 특징과 상호 관계를 더 깊이 이해할 수 있습니다.</p>
						<ul>
							<li style="margin-bottom: 10px;">
								<strong>➡️ PC1 (가로축): '상업 및 인구 규모'</strong><br>
								차트의 오른쪽으로 갈수록 인구, 총사업체, 종사자 수가 많은 <strong>'도시의 활력'</strong>이 높은 지역입니다. 반대로 왼쪽은 상대적으로 조용한 지역입니다.
							</li>
							<li>
								<strong>⬆️ PC2 (세로축): '젊은 주거 특성'</strong><br>
								차트의 위쪽으로 갈수록 <strong>'20~39세 인구 비율', '1인 가구 비율', '신축 주택 비율'</strong>이 높은, 즉 젊고 새로운 주거 특성이 강한 지역입니다.
							</li>
						</ul>
						<br>
						<p><strong>차트가 우리에게 알려주는 것:</strong></p>
						<p><strong>핑크색(군집 0)</strong>은 대부분 차트 오른쪽에 모여있어, 예상대로 '상업 및 인구 규모'가 크다는 것을 재확인할 수 있습니다. 반면, <strong>파란색(군집 1)</strong>은 왼쪽에 넓게 퍼져있는데, 이는 '주거 및 성장 잠재 지역'이 매우 다양한 성격을 가지고 있음을 의미합니다. 특히, 파란색 점들이 위아래로 길게 퍼져있는 모습은 <strong>같은 잠재 지역이라도 신축 아파트가 많은 젊은 동네와 오래된 주택이 많은 조용한 동네로 나뉜다</strong>는 중요한 사실을 알려줍니다.</p>
					</div>`;
                break;
			case 'residual_total_business':
	            reportHTML = `
					<div class="report-section">
	                    <h4>해석 결과 요약</h4>
	                    <p><strong>1. 모델 전체 성능: 매우 뛰어난 설명력 ✅</strong></p>
	                    <p><strong>R-squared (결정계수): 0.991</strong><br>
	                    이 모델이 '총사업체수' 변동 원인의 <strong>99.1%</strong>를 설명한다는 의미입니다. 1에 가까울수록 설명력이 높은데, 0.991은 모델이 데이터를 매우 잘 설명하고 있음을 뜻합니다. 생성된 회귀 모델은 겉으로 보기에 신뢰도가 매우 높습니다.</p>
	                </div>
	                <div class="report-section">
	                    <p><strong>2. 각 변수별 영향력: 어떤 변수가 중요할까? 🔍</strong></p>
	                    <p>각 변수가 총사업체수에 얼마나 의미 있는 영향을 주는지 <strong>P>|t| (유의확률)</strong> 값으로 알 수 있습니다. 이 값이 <strong>0.05보다 작을수록</strong> 해당 변수가 사업체 수에 미치는 영향이 크고 중요하다고 해석할 수 있습니다.</p>
	                    <p><strong>✅ 유의미한 영향을 주는 변수들 (p < 0.05)</strong><br>
	                    1인가구 수, 도소매업체수, 숙박음식업체수, 정보통신업체수, 건설업체수, 교육서비스업체수</p>
	                    <p><strong>❌ 유의미한 영향이 없는 변수들 (p > 0.05)</strong><br>
	                    총인구, 30~34세 남녀 인구 합, 신축 주택 비율</p>
	                </div>
	                <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">
	                <div class="report-section">
	                    <h4>📊 잔차(Residual) 지도, 어떻게 읽어야 할까요?</h4>
	                    <p>위 분석 결과를 바탕으로, AI 모델의 <strong>'예상'과 '현실'의 차이</strong>를 보여주는 '오차 지도'입니다. 이를 통해 우리는 데이터만으로는 알 수 없는 각 지역의 숨겨진 성장 잠재력을 발견할 수 있습니다.</p>
	                    <p><strong>'잔차'란?</strong><br>AI가 여러 조건을 보고 "이곳엔 사업체가 100개 있겠군!"이라고 예측했는데, 실제 120개가 있다면 '+20'이 잔차입니다. 즉, <strong>모델의 예상을 벗어난 '의외성'의 크기</strong>입니다.</p>
	                </div>
	                <div class="report-section">
	                    <h4>🎨 색상으로 숨은 기회 찾기</h4>
	                    <p><strong><span style="color: #ffb6c1;">■ 핑크색 지역</span> (예측보다 잘나가는 '숨은 꿀단지' 🍯)</strong><br>AI의 예측보다 <strong>실제 사업체가 훨씬 많은 지역</strong>입니다. 데이터만으로는 설명되지 않는 특별한 성장 동력(예: 떠오르는 핫플레이스, 지역 문화)이 있을 가능성이 높습니다.</p>
	                    <p><strong><span style="color: #0a3d62;">■ 파란색 지역</span> (잠재력을 품은 '기회의 땅' 💎)</strong><br>데이터상 좋은 조건을 갖췄지만, <strong>예상보다 실제 사업체 수가 적은 지역</strong>입니다. 이 지역의 성장을 가로막는 요인만 해결된다면 <strong>미래 성장 잠재력이 매우 높은 곳</strong>입니다.</p>
	                </div>`;
	            break;
			
			// --- 군집분석 개별 변수 리포트 ---
			case '1인가구_비율':
				reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석</h4><p>1인 가구의 비율은 현대 소비 시장의 중요한 트렌드를 보여줍니다. 이 비율이 높은 지역은 편의점, 소형가전, 배달 음식 등 <strong>1인 라이프스타일에 맞는 업종</strong>의 수요가 높을 가능성이 큽니다. 젊은 직장인이나 대학가 주변에서 높게 나타나는 경향이 있습니다.</p></div>`;
				break;
			case '음식점_수':
				reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석</h4><p>음식점의 밀집도는 해당 지역의 <strong>유동인구와 상업 활동의 활발함</strong>을 나타내는 직접적인 지표입니다. 음식점 수가 많은 곳은 일반적으로 오피스 상권이거나, 약속 장소로 인기 있는 중심지일 가능성이 높습니다. 외식업 창업 시 가장 기본적으로 고려해야 할 데이터입니다.</p></div>`;
				break;
			case '전체_사업체수':
				reportHTML = `<div class="report-section"><h4>📊 ${selectedLabel} 지도 해석</h4><p>전체 사업체의 수는 그 지역의 <strong>경제 활동 규모</strong>를 종합적으로 보여줍니다. 이 값이 높은 지역은 다양한 업종이 공존하는 복합 상권이거나, 산업단지, 오피스 밀집 지역일 수 있습니다. 지역의 전반적인 경제 활력을 파악하는 데 사용됩니다.</p></div>`;
				break;	
				
	        case '총사업체수':
	            reportHTML = `
	                <div class="report-section">
	                    <h4>📊 ${selectedLabel} 지도 해석</h4>
	                    <p>이 지도는 각 격자별 <strong>실제 총사업체 수</strong>의 분포를 보여줍니다. 색상이 진할수록 해당 지역에 더 많은 사업체가 밀집해 있음을 의미합니다.</p>
	                    <p>주로 도심이나 상업 중심지에서 높은 값을 보이며, 이를 통해 대전시의 주요 상권 활성화 지역을 직관적으로 파악할 수 있습니다.</p>
	                </div>`;
	            break;
	        case '총인구':
	             reportHTML = `
	                <div class="report-section">
	                    <h4>📊 ${selectedLabel} 지도 해석</h4>
	                    <p>이 지도는 각 격자별 <strong>총인구 수</strong>의 분포를 보여줍니다. 색상이 진할수록 해당 지역에 더 많은 인구가 거주하고 있음을 의미합니다.</p>
	                    <p>인구 밀집 지역은 잠재적인 소비력이 높은 곳으로, 다양한 업종의 배후 수요를 파악하는 데 중요한 기초 자료가 됩니다.</p>
	                </div>`;
	            break;
	        default:
	             reportHTML = `
	                <div class="report-section">
	                    <h4>📊 ${selectedLabel} 지도 해석</h4>
	                    <p>이 지도는 각 격자별 <strong>${selectedLabel}</strong> 데이터의 분포를 보여줍니다. 색상이 진할수록 해당 변수의 값이 높음을 의미합니다.</p>
	                    <p>이 분포를 통해 지역별 특성을 파악하고, 다른 데이터와 비교하여 상권에 미치는 영향을 분석해볼 수 있습니다.</p>
	                </div>`;
	            break;
	    }
	    reportBody.innerHTML = reportHTML;
	}
	
	// ======================== [신규] 프랜차이즈 관련 함수 ========================
    /**
     * 프랜차이즈 레이어를 생성하고 지도에 추가하는 함수
     */
    function initializeFranchiseLayers() {
        Object.keys(FRANCHISE_CONFIG).forEach(name => {
            const config = FRANCHISE_CONFIG[name];
            const franchiseSource = new ol.source.Vector({
                url: config.url,
                format: new ol.format.GeoJSON()
            });

            const franchiseLayer = new ol.layer.Vector({
                source: franchiseSource,
                style: new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 7,
                        fill: new ol.style.Fill({ color: config.color }),
                        stroke: new ol.style.Stroke({ color: '#fff', width: 2 })
                    })
                }),
                visible: false, // 처음에는 보이지 않도록 설정
                zIndex: 3 // 격자 레이어보다 위에 오도록 z-index 설정
            });

            franchiseLayers[name] = franchiseLayer;
            vmap.addLayer(franchiseLayer);
        });
    }

    /**
     * 프랜차이즈 팝업 오버레이를 초기화하는 함수
     */
    function initializePopup() {
        const container = document.getElementById('popup');
        const content = document.getElementById('popup-content');
        const closer = document.getElementById('popup-closer');

        popupOverlay = new ol.Overlay({
            element: container,
            autoPan: true,
            autoPanAnimation: {
                duration: 250
            },
			positioning: 'bottom-center', // [추가] 팝업의 기준점을 아래쪽 중앙으로 설정
		    offset: [0, -15]              // [추가] 포인트로부터 15px 위로 띄움
        });
        vmap.addOverlay(popupOverlay);
		
		// [핵심] 'X' 버튼 (closer)을 클릭했을 때의 동작입니다.
        closer.onclick = () => {
            popupOverlay.setPosition(undefined); // 팝업의 위치를 초기화하여 숨깁니다.
            closer.blur(); // 버튼의 포커스를 제거합니다.
            return false;
        };
    }

    /**
     * 프랜차이즈 버튼에 이벤트 리스너를 추가하는 함수
     */
	function addFranchiseButtonListeners() {
	    const franchiseButtons = document.querySelectorAll('.franchise-btn');
	    franchiseButtons.forEach(button => {
	        button.addEventListener('click', () => {
	            const franchiseName = button.dataset.franchise;
	            const layer = franchiseLayers[franchiseName];
	            if (!layer) return;

	            const isActive = button.classList.toggle('active');
	            layer.setVisible(isActive);
	            
	            // [삭제] if (isActive && hoverInteraction) { ... } 부분 삭제

	            const config = FRANCHISE_CONFIG[franchiseName];
	            if (isActive) {
	                button.style.backgroundColor = config.color;
	                button.style.color = '#fff';
	                addOverlayLegendItem('franchise_' + franchiseName, config.color, franchiseName);
	            } else {
	                button.style.backgroundColor = '';
	                button.style.color = '';
	                popupOverlay.setPosition(undefined);
	                removeOverlayLegendItem('franchise_' + franchiseName);
	            }
				if (activeGridLayer) {
	                activeGridLayer.getSource().changed();
	            }
	            // ▼▼▼ [수정] 함수 마지막에 호버 상태 업데이트 함수를 호출합니다. ▼▼▼
	            updateHoverInteractionState();
	        });
	    });
	}
	// ======================== [신규] PDF 생성 및 이력 저장 함수 (수정본) ========================
	/**
	 * AI 분석 결과 모달의 내용을 PDF로 변환하고, 서버에 업로드하여 이력을 저장합니다.
	 * (스크롤이 있는 긴 내용도 모두 캡처하여 PDF에 포함하도록 수정됨)
	 * @param {string} analysisType - 분석 유형 (예: '군집분석', '중력모형')
	 * @param {object} properties - 클릭된 격자의 속성 데이터
	 * @param {string} reportTitle - AI가 생성한 리포트의 메인 제목 (이력 제목으로 사용)
	 */
	async function handlePdfSaveAndUpload(analysisType, properties, reportTitle) {
	    const printBtn = document.getElementById('printPdfButton');
	    const modalBody = document.getElementById('aiModalBody');

	    // 버튼 비활성화 및 텍스트 변경
	    printBtn.disabled = true;
	    printBtn.textContent = 'PDF 생성 및 저장 중...';

	    // PDF 생성 전 스크롤을 최상단으로 이동
	    modalBody.scrollTop = 0;

	    try {
	        // ========================= ▼▼▼ 핵심 수정 부분 ▼▼▼ =========================

	        // 1. 스크롤하며 보이는 부분을 모두 캡처하는 로직
	        const scale = 3; // 선명한 결과물을 위한 해상도 배율
	        const canvasParts = [];
	        const totalHeight = modalBody.scrollHeight;
	        const viewportHeight = modalBody.clientHeight;
	        let capturedHeight = 0;

	        while (capturedHeight < totalHeight) {
	            modalBody.scrollTop = capturedHeight;
	            // 스크롤 후 컨텐츠가 렌더링될 시간을 줍니다.
	            await new Promise(resolve => setTimeout(resolve, 200));

	            const canvasPart = await html2canvas(modalBody, {
	                scale: scale,
	                useCORS: true,
	                scrollY: -capturedHeight, // 현재 스크롤 위치를 기준으로 캡처
	                width: modalBody.clientWidth,
	                height: viewportHeight
	            });
	            canvasParts.push(canvasPart);
	            capturedHeight += viewportHeight;
	        }

	        // 2. 캡처된 캔버스 조각들을 하나의 긴 캔버스로 병합
	        const masterCanvas = document.createElement('canvas');
	        const masterCtx = masterCanvas.getContext('2d');

	        // 마스터 캔버스의 너비는 첫 번째 조각의 너비와 동일
	        masterCanvas.width = canvasParts[0].width;
	        // 마스터 캔버스의 높이는 원본의 전체 스크롤 높이에 배율을 적용한 값
	        masterCanvas.height = totalHeight * scale;

	        let pasteY = 0;
	        for (const partCanvas of canvasParts) {
	            // 마지막 조각이 잘리지 않도록 실제 남은 높이만큼만 잘라서 붙입니다.
	            const remainingHeight = (totalHeight * scale) - pasteY;
	            const clippedHeight = Math.min(partCanvas.height, remainingHeight);

	            if (clippedHeight > 0) {
	                masterCtx.drawImage(
	                    partCanvas,
	                    0, 0, // 소스 캔버스의 (0, 0) 위치에서
	                    partCanvas.width, clippedHeight, // 이만큼의 크기를 잘라내어
	                    0, pasteY, // 마스터 캔버스의 (0, pasteY) 위치에
	                    partCanvas.width, clippedHeight // 동일한 크기로 붙여넣습니다.
	                );
	                pasteY += clippedHeight;
	            }
	        }
	        
	        // ========================= ▲▲▲ 핵심 수정 부분 ▲▲▲ =========================


	        // 3. 병합된 마스터 캔버스를 사용하여 PDF 페이지 생성 (기존 로직 활용)
	        const { jsPDF } = window.jspdf;
	        const pdf = new jsPDF('p', 'mm', 'a4');

	        const margin = 15;
	        const a4Width = 210;
	        const a4Height = 297;

	        const pdfImgWidth = a4Width - margin * 2;
	        const pdfImgHeight = (masterCanvas.height * pdfImgWidth) / masterCanvas.width;
	        const imgData = masterCanvas.toDataURL('image/png', 1.0);

	        let heightLeft = pdfImgHeight;
	        let position = margin;

	        pdf.addImage(imgData, 'PNG', margin, position, pdfImgWidth, pdfImgHeight);
	        heightLeft -= (a4Height - margin * 2);

	        while (heightLeft > 0) {
	            pdf.addPage();
	            position = heightLeft - pdfImgHeight + margin;
	            pdf.addImage(imgData, 'PNG', margin, position, pdfImgWidth, pdfImgHeight);
	            heightLeft -= (a4Height - margin * 2);
	        }

	        // 4. PDF를 서버에 업로드
	        const pdfBlob = pdf.output('blob');
	        const pdfFile = new File([pdfBlob], `AI상세분석_${properties.gid}.pdf`, { type: 'application/pdf' });

	        const formData = new FormData();
	        formData.append('reportFile', pdfFile);
	        formData.append('historyTitle', reportTitle);
	        formData.append('historyType', `AI_${analysisType.toUpperCase()}`);

	        const cleanProperties = {
	            gid: properties.gid || null,
	            analysisType: analysisType,
	            timestamp: new Date().toISOString()
	        };
	        formData.append('analysisParams', JSON.stringify(cleanProperties));

	        const response = await fetch(`${contextPath}/api/market/detailed/report`, {
	            method: 'POST',
	            body: formData
	        });

	        if (!response.ok) throw new Error(`서버 응답 오류: ${response.statusText}`);

	        const result = await response.text();
	        if (result === 'SUCCESS') {
	            alert('AI 분석 리포트가 마이페이지에 성공적으로 저장되었습니다.');
	            printBtn.textContent = '성공적으로 저장됨';
	            // 성공 후에는 버튼을 다시 활성화하지 않아 중복 저장을 방지
	        } else {
	            throw new Error('서버에서 저장을 실패했습니다.');
	        }

	    } catch (error) {
	        console.error('PDF 저장 및 업로드 실패:', error);
	        alert('PDF 저장 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
	        printBtn.textContent = '저장 실패';
	        // 실패 시 2초 후 버튼을 다시 활성화
	        setTimeout(() => {
	            printBtn.disabled = false;
	            printBtn.textContent = 'PDF로 저장 (마이페이지)';
	        }, 2000);
	    }
	}

	
	// ======================================== 산업별 관련 함수들 ========================================
	/**
	 * 활성화된 산업 레이어가 있는지 확인하는 함수
	 * @returns {boolean} 활성화된 레이어가 하나라도 있으면 true, 아니면 false
	 */
	function isAnyBizLayerActive() {
	    return Object.values(bizLayers).some(layer => layer.getVisible());
	}
	
	// [신규] 산업별 레이어 생성 함수
	function initializeBizLayers() {
	    Object.keys(BIZ_CONFIG).forEach(name => {
	        const config = BIZ_CONFIG[name];
	        const bizSource = new ol.source.Vector({
	            url: config.geojsonUrl,
	            format: new ol.format.GeoJSON()
	        });
	        const bizLayer = new ol.layer.Vector({
	            source: bizSource,
	            style: (feature) => {
					const admNm = feature.get('ADM_NM');
	                const bizCount = feature.get(config.bizCountKey);
	                const empCount = feature.get(config.empCountKey);
	                const text = `${admNm} | ${name} | 사업체수: ${bizCount}개, 종사자수: ${empCount}명`;
	                return new ol.style.Style({
	                    text: new ol.style.Text({
	                        text: text,
	                        font: '14px sans-serif',
	                        fill: new ol.style.Fill({ color: '#0a3d62' }), // 텍스트 색상 변경
	                        stroke: new ol.style.Stroke({ color: '#fff', width: 3 }), // 외곽선 두께 변경
	                        offsetY: config.offsetY // BIZ_CONFIG에서 정의한 수직 위치 오프셋 적용
	                    }),
	                    stroke: new ol.style.Stroke({
	                        color: 'rgba(0,0,0,0)',
	                        width: 0
	                    }),
	                    fill: new ol.style.Fill({
	                        color: 'rgba(0,0,0,0)'
	                    })
	                });
	            },
	            visible: false, // 처음에는 보이지 않도록 설정
	            zIndex: 4 // 프랜차이즈 레이어보다 위에 오도록 z-index 설정
	        });
	        bizLayers[name] = bizLayer;
	        vmap.addLayer(bizLayer);
	    });
	}
	
	// [신규] 산업별 버튼에 이벤트 리스너를 추가하는 함수
	function addBizButtonListeners() {
	    bizButtons.forEach(button => {
	        button.addEventListener('click', () => {
	            const bizType = button.dataset.bizType;
	            const layer = bizLayers[bizType];
	            if (!layer) return;

	            const isActive = button.classList.toggle('active');
	            layer.setVisible(isActive);

	            // [삭제] if (isActive && hoverInteraction) { ... } 부분 삭제

	            if (isActive) {
	                if (hjdLayer && !hjdLayer.getVisible()) {
	                    toggleHjdLayerBtn.click();
	                }
	                button.style.backgroundColor = '#0a3d62';
	                button.style.color = '#fff';
	                addOverlayLegendItem('biz_' + bizType, null, bizType);
	            } else {
	                button.style.backgroundColor = '';
	                button.style.color = '';
	                removeOverlayLegendItem('biz_' + bizType);
	            }
				if (activeGridLayer) {
	                activeGridLayer.getSource().changed();
	            }
	            // ▼▼▼ [수정] 함수 마지막에 호버 상태 업데이트 함수를 호출합니다. ▼▼▼
	            updateHoverInteractionState();
	        });
	    });
	}
	
    //======================== 4. 지도 사이즈 갱신 (찌그러짐 방지) ========================
    [layerSidebar, reportSidebar].forEach(sidebar => {
        sidebar.addEventListener('transitionend', () => {
            vmap.updateSize();
        });
    });
	
	// 프랜차이즈 레이어가 활성화되어 있는지 확인하는 헬퍼(도우미) 함수를 추가
	/**
	 * 활성화된 프랜차イズ 레이어가 있는지 확인하는 함수
	 * @returns {boolean} 활성화된 레이어가 하나라도 있으면 true, 아니면 false
	 */
	function isAnyFranchiseLayerActive() {
	    return Object.values(franchiseLayers).some(layer => layer.getVisible());
	}

	/**
	 * 활성화된 산업 레이어가 있는지 확인하는 함수
	 * @returns {boolean} 활성화된 레이어가 하나라도 있으면 true, 아니면 false
	 */
	function isAnyBizLayerActive() {
	    return Object.values(bizLayers).some(layer => layer.getVisible());
	}
	
	// ======================== [신규] 격자 호버(Hover) 기능 추가 ========================
	let hoverInteraction = null; // [수정] 함수 바깥에서 변수를 선언합니다.
	
	/**
	 * [신규] 지도 위 오버레이(프랜차이즈, 산업) 버튼 상태에 따라
	 * 격자 호버 상호작용을 켜거나 끄는 함수
	 */
	function updateHoverInteractionState() {
	    // hoverInteraction 객체가 아직 생성되지 않았다면 함수를 종료합니다.
	    if (!hoverInteraction) return;

	    // 프랜차이즈 또는 산업 버튼 중 하나라도 활성화되어 있는지 확인합니다.
	    const isOverlayActive = isAnyFranchiseLayerActive() || isAnyBizLayerActive();
	    
	    // vmap에 등록된 모든 상호작용 목록을 가져옵니다.
	    const interactions = vmap.getInteractions().getArray();
	    // 현재 hoverInteraction이 지도에 추가된 상태인지 확인합니다.
	    const isInteractionOnMap = interactions.includes(hoverInteraction);

	    if (isOverlayActive) {
	        // 오버레이가 활성화 상태인 경우 (호버 기능을 꺼야 함)
	        if (isInteractionOnMap) {
	            // ▼▼▼ 핵심 수정 파트 ▼▼▼
	            // 1. 현재 선택(호버)된 피처가 있다면 스타일을 원래대로 되돌립니다. (가장 중요)
	            hoverInteraction.getFeatures().clear();
	            
	            // 2. 그 다음, 호버 기능 자체를 지도에서 완전히 제거합니다.
	            vmap.removeInteraction(hoverInteraction);
	            // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
	        }
	    } else {
	        // 오버레이가 모두 비활성화 상태인 경우 (호버 기능을 켜야 함)
	        if (!isInteractionOnMap) {
	            // 호버 기능이 지도에서 제거된 상태일 경우에만 다시 추가합니다.
	            vmap.addInteraction(hoverInteraction);
	        }
	    }
	}
	
	const addGridHoverInteraction = () => {
	    hoverInteraction = new ol.interaction.Select({
	        condition: ol.events.condition.pointerMove,
	        layers: function(layer) {
	            return layer === activeGridLayer;
	        },
	        // ▼▼▼ 이 style 함수 전체를 아래 내용으로 교체해주세요 ▼▼▼
	        style: function(feature) {
	            // 1. 프랜차이즈나 산업 버튼이 켜져있는지 먼저 확인합니다.
	            const isOverlayActive = isAnyFranchiseLayerActive() || isAnyBizLayerActive();

	            // 2. 만약 켜져 있다면, null을 반환하여 아무 스타일도 적용하지 않습니다.
	            //    이렇게 하면 호버가 되어도 투명하게 처리됩니다.
	            if (isOverlayActive) {
	                return null;
	            }

	            // 3. (버튼이 모두 꺼져있을 경우) 기존의 호버 스타일을 정상적으로 적용합니다.
	            const styleFunction = activeGridLayer.getStyle();
	            if (!styleFunction) return null;

	            const originalStyle = styleFunction(feature);

	            const hoverBorderStyle = new ol.style.Style({
	                stroke: new ol.style.Stroke({
	                    color: 'rgba(0, 0, 0, 1)',
	                    width: 3
	                }),
	                zIndex: 10
	            });

	            const hoverTextStyle = new ol.style.Style({
	                text: new ol.style.Text({
	                    text: feature.get('gid') ? feature.get('gid').toString() : '',
	                    font: 'bold 16px "Pretendard Variable", Pretendard, sans-serif',
	                    fill: new ol.style.Fill({ color: '#ffffff' }),
	                    stroke: new ol.style.Stroke({ color: '#000000', width: 3 }),
	                }),
	                zIndex: 11
	            });
	            
	            return [].concat(originalStyle, hoverBorderStyle, hoverTextStyle);
	        }
	        // ▲▲▲ 여기까지 교체 ▲▲▲
	    });

	    vmap.addInteraction(hoverInteraction);
	};
	
	// 호버 적용 함수 호출
	addGridHoverInteraction(); 
	// 주소 검색 기능 초기화 함수 호출
    addAddressSearchFunctionality();
	// [신규] 프랜차이즈 기능 초기화 함수 호출
    initializeFranchiseLayers();
    initializePopup();
    addFranchiseButtonListeners();
	// [추가된 부분] 산업별 레이어 및 버튼 이벤트 초기화 함수 호출
    initializeBizLayers();
    addBizButtonListeners();
});