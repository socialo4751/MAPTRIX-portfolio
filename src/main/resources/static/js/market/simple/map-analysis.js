document.addEventListener('DOMContentLoaded', () => {
	
    // 지도 위 오른쪽 상단 버튼 이벤트 핸들러 추가

    const homeBtn = document.getElementById('homeBtn');
    const loginBtn = document.getElementById('loginBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    const guideBtn = document.getElementById('guideBtn');
    const myBtn = document.getElementById('myBtn');

    if (homeBtn) {
        homeBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/`; // 홈으로 이동
        });
    }

    if (loginBtn) {
        loginBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/login`; // 로그인 페이지로 이동
        });
    }

    if (logoutBtn) {
        logoutBtn.addEventListener('click', () => {
            // 숨겨진 로그아웃 폼을 찾아서 전송
            const logoutForm = document.getElementById('logoutForm');
            if (logoutForm) {
                logoutForm.submit();
            }
        });
    }
    
    if (guideBtn) {
        guideBtn.addEventListener('click', () => {
            // '이용안내' 버튼 클릭 시 쿠키와 상관없이 가이드를 처음부터 다시 시작
            
            // 1. 현재 스텝 카운터를 0으로 리셋
            currentStep = 0; 
            
            // 2. 가이드를 위해 리포트 창을 다시 열어줌
            reportSidebarForGuide.classList.add('active');
            
            // 3. 메인 모달 컨테이너를 다시 보이게 함
            usageGuideModal.classList.add('visible');
            
            // 4. 기존에 만들어둔 함수를 호출하여 첫 번째 스텝부터 보여줌
            showGuideStep(currentStep); 
        });
    }
	if (myBtn) {
        myBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/my/report`; // 마이페이지 - 리포트 주소로 이동
        });
    }
    // ==========================================================
	
	// ================== [추가] 초기화 버튼 이벤트 핸들러 ==================
	const resetButton = document.querySelector('.btn-reset');

	if (resetButton) {
	    resetButton.addEventListener('click', () => {
	        // 1. 사이드바에서 선택된 모든 항목(.active 클래스) 제거
	        document.querySelectorAll('.options-section a.active').forEach(link => {
	            link.classList.remove('active');
	        });

	        // 2. 열려있는 하위 목록(동, 업종 중분류) 닫기
	        $('.dong-list').slideUp(200);
	        $('.subcategory-list').slideUp(200);

	        // 3. 주소 검색창 비우기
	        document.getElementById('addressSearchInput').value = '';

	        // 4. 지도 초기 화면으로 이동 (대전 전체 뷰)
	        moveToLocation(null);

	        // 5. 분석 리포트 사이드바 닫기
	        const reportSidebar = document.getElementById('report-sidebar');
	        if (reportSidebar.classList.contains('active')) {
	            reportSidebar.classList.remove('active');
	            // 사이드바가 닫히는 애니메이션(0.4s) 후 지도 크기 재조정
	            setTimeout(() => vmap.updateSize(), 450);
	        }

	        // 6. 지도 위에 표시된 모든 차트 제거
	        clearAllCharts();
	    });
	}
	// ========================================================================
	
	
	// ================== 사용법 안내 모달 및 쿠키 처리 로직 ==================
    const setCookie = (name, value, days) => {
        let expires = "";
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "") + expires + "; path=/";
    };

    const getCookie = (name) => {
        const nameEQ = name + "=";
        const ca = document.cookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    };
	
	// 페이지 로딩 시 URL 파라미터를 먼저 확인합니다.
    const urlParams = new URLSearchParams(window.location.search);
    const queryFromUrl = urlParams.get('query');
	
    const usageGuideModal = document.getElementById('usageGuideModal');
    const guideSteps = document.querySelectorAll('.guide-step-content');
    const nextButtons = document.querySelectorAll('.guide-next-btn');
    const startButton = document.getElementById('startAnalysisBtn');
    const hideCheckbox = document.getElementById('hideGuideCheckbox');
    const reportSidebarForGuide = document.getElementById('report-sidebar'); // 가이드용 사이드바
	
	const hasGuide = !!(usageGuideModal && startButton && hideCheckbox && reportSidebarForGuide);
	
	////////////////////////////////////250820
	// ===== [전역 상태 & 유틸] =====
	window.__initialData = null;
	window.__userPreferences = null;
	window.__pendingQueryFromUrl = null;   // 홈 검색어(가이드 후 실행)
	window.__initialApplySource = null;    // 'search' | 'preferences'
	window.__initialApplied = false;       // 모달 1회만 노출

	// DOM 요소가 나올 때까지 대기
	const waitFor = (selector, within = document, timeout = 4000) => new Promise((resolve, reject) => {
	  const deadline = Date.now() + timeout;
	  (function poll() {
	    const el = (within || document).querySelector(selector);
	    if (el) return resolve(el);
	    if (Date.now() > deadline) return reject(new Error('waitFor timeout: ' + selector));
	    requestAnimationFrame(poll);
	  })();
	});

	// 자동선택 완료 안내 모달 생성/표시
	// 모달 DOM이 없으면 생성


	// 현재 활성 중분류 텍스트 가져오기(있으면)
	function getActiveBizText() {
	  const sub = document.querySelector('.business-type-options a.biz-link.sub-link.active');
	  if (sub) return sub.dataset.bizName || sub.textContent || '';
	  const main = document.querySelector('.business-type-options a.biz-link.active');
	  return main ? (main.dataset.bizName || main.textContent || '') : '';
	}
	
	// ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 08/27 함수 수정(정연우) ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼

	/**
	 * [최종 수정] view.jsp의 CSS를 사용하는 우리만의 모달 함수
	 * @param {object} opts - { regionText, bizText, by }
	 */
	const showSelectionModal = (opts) => {
	    const { regionText = '', bizText = '', by = 'preferences' } = (opts || {});
	    
	    // 정연우 추가
	    // '관심 정보 자동 선택' 모달이고, 로그인이 안 된 상태라면 함수를 즉시 종료
	    if (by === 'preferences' && !isUserLoggedIn) {
	        return;
	    }
	    
	    // 모달이 이미 있다면 중복 생성 방지
	    if (document.querySelector('.modal-overlay')) return;

	    // 상황에 맞는 제목과 내용 구성
	    const title = by === 'search' ? "검색결과 및 관심정보 반영" : "관심정보 자동 선택";
	    let messageBody = '';
	    if (by === 'search') {
	        messageBody += '• 검색하신 구역을 선택정보로 반영하였습니다.';
	        if(bizText) messageBody += `<br>• 관심 업종: ${bizText}`;
	    } else {
	        if (regionText) messageBody += `• 관심 구역: ${regionText}<br>`;
	        if (bizText) messageBody += `• 관심 업종: ${bizText}`;
	    }
	    
	    // 모달 HTML 구조 생성
	    const overlay = document.createElement('div');
	    overlay.className = 'modal-overlay';
	    
	    const modalContent = document.createElement('div');
	    modalContent.className = 'modal-content';
	    modalContent.innerHTML = `
	        <div class="modal-title">${title}</div>
	        <div class="modal-body">${messageBody}</div>
	        <button class="modal-button">확인</button>
	    `;
	    
	    // 화면에 추가
	    overlay.appendChild(modalContent);
	    document.body.appendChild(overlay);

	    // 닫기 기능 연결
	    const closeButton = modalContent.querySelector('.modal-button');
	    const closeModal = () => {
	        if (document.body.contains(overlay)) {
	            document.body.removeChild(overlay);
	        }

	        // ▼▼▼▼▼ [요청사항 수정] 모달이 닫힌 후 튜토리얼을 다시 시작합니다. ▼▼▼▼▼
	        // hasGuide 변수는 튜토리얼 관련 요소가 모두 있는지 확인합니다.
			if (hasGuide) {
			    // [수정] 튜토리얼 표시 조건 강화
			    // 1. 쿠키가 없고, 2. URL 검색어가 없고, 3. 로그인한 사용자(관심정보가 있는)가 아닐 때만 튜토리얼을 바로 시작
			    const shouldShowGuide = !getCookie('hideSimpleAnalysisGuide')
			                           && !window.__pendingQueryFromUrl
			                           && !window.__userPreferences; // <-- 이 조건 추가

			    if (shouldShowGuide) {
			        // 1. 이용안내를 보여줘야 할 때 (비로그인 첫 방문자)
			        usageGuideModal.classList.add('visible');
			        reportSidebarForGuide.classList.add('active');
			        showGuideStep(currentStep);
			    } else {
			        // 2. 이용안내를 건너뛸 때 (로그인 사용자, 재방문자, 검색 진입자)
			        //    관심정보 자동 선택/검색 결과 반영 로직이 이곳에서 처리됩니다.
			        applyInitialSelection();
			    }

			    // '다음' 버튼 기능
			    nextButtons.forEach(btn => btn.addEventListener('click', () => {
			        currentStep++;
			        if (currentStep < guideSteps.length) {
			            showGuideStep(currentStep);
			        }
			    }));

			    // '시작하기' 버튼 기능: 가이드를 닫고, (필요시) 자동 선택 실행
			    startButton.addEventListener('click', () => {
			        if (hideCheckbox.checked) setCookie('hideSimpleAnalysisGuide', 'true', 1);
			        usageGuideModal.classList.remove('visible');
			        reportSidebarForGuide.classList.remove('active');
			        
			        // [수정] 시작하기 버튼 클릭 시에는 항상 applyInitialSelection()을 호출하도록 변경
			        // 이렇게 하면 비로그인 사용자가 튜토리얼을 본 후에도 정상적으로 다음 단계 진행 가능
			        applyInitialSelection();
			    });
			} else {
			    // (가이드 기능이 없는 예외적인 경우) 바로 자동 선택 실행
			    applyInitialSelection();
			}
	        // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
	    };
	    closeButton.addEventListener('click', closeModal);
	    overlay.addEventListener('click', (e) => {
	        if (e.target === overlay) {
	            closeModal();
	        }
	    });
	};
	

	
    let currentStep = 0;

    const showGuideStep = (stepIndex) => {
        guideSteps.forEach((step, index) => {
            if (index === stepIndex) {
                step.style.display = 'block';
                // 약간의 딜레이 후 active 클래스 추가하여 transition 효과 발생
                setTimeout(() => step.classList.add('active'), 10);
            } else {
                step.classList.remove('active');
                // transition이 끝난 후 display: none으로 설정
                setTimeout(() => {
                    if (!step.classList.contains('active')) {
                         step.style.display = 'none';
                    }
                }, 300);
            }
        });
    };
	
	////////////////////////////////////250820 
	// 가이드가 열려있다면 '시작하기' 클릭 뒤 실행, 아니면 즉시 실행
	function runAfterGuideOrNow(cb) {
	  if (hasGuide && usageGuideModal.classList.contains('visible')) {
	    startButton.addEventListener('click', function once(){
	      startButton.removeEventListener('click', once);
	      setTimeout(cb, 150);
	    }, { once:true });
	  } else {
	    cb();
	  }
	}
	
	window.runAfterGuideOrNow = runAfterGuideOrNow;


    // ========================================================================
	
    // JavaScript 파일 시작 부분에 좌표계 정의 코드 추가
    proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

    //======================== 1. 지도 초기화 ========================
    const daejeonCityHallLonLat = [127.38489655389, 36.360043590621];
    const daejeonCityHall3857 = ol.proj.transform(daejeonCityHallLonLat, 'EPSG:4326', 'EPSG:3857');

    vw.ol3.CameraPosition.center = daejeonCityHall3857;
    vw.ol3.CameraPosition.zoom = 11;

    vw.ol3.MapOptions = {
        basemapType: vw.ol3.BasemapType.GRAPHIC,
        controlDensity: vw.ol3.DensityType.EMPTY,
        interactionDensity: vw.ol3.DensityType.BASIC,
        controlsAutoArrange: true,
        homePosition: vw.ol3.CameraPosition,
        initPosition: vw.ol3.CameraPosition
    };

    var vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);


    // ================== AI 분석에 사용할 데이터를 저장할 변수 ==================
    let cachedAnalysisData = null;
    let cachedSgisCodes = null;
    // =======================================================

    // ================== 차트 관리를 위한 변수 및 함수 추가 ==================
    let currentMapCharts = []; // 지도에 추가된 차트 오버레이를 관리할 배열

    // 지도에 표시된 모든 차트를 제거하는 함수
    function clearAllCharts() {
        currentMapCharts.forEach(chart => {
            try {
                vmap.removeOverlay(chart);
            } catch (e) {
                console.error("차트 제거 중 오류:", e);
            }
        });
        currentMapCharts = []; // 관리 배열 초기화
    }

    //======================== 2. 레이어 정의 및 추가 ========================

    // Style 함수 정의: 폴리곤과 텍스트 스타일을 함께 반환
    const styleFunction = (feature, resolution) => {

        // ✨ 해상도(줌 레벨)에 따라 폰트 크기 결정 (매우 크게 수정)
        let fontSize = 0;           // 기본값 0: 너무 축소하면 텍스트 숨김
        if (resolution < 10) {      // 줌 레벨 14 이상 (가장 확대)
            fontSize = 22;
        } else if (resolution < 20) { // 줌 레벨 13
            fontSize = 18;
        } else if (resolution < 40) { // 줌 레벨 12
            fontSize = 14;
        } else if (resolution < 80) { // 줌 레벨 11 (초기화면)
            fontSize = 12;
        }

        // 경계선 스타일
        const boundaryStyle = new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'rgba(255, 0, 0, 0.7)',
                width: 1.5
            }),
            fill: new ol.style.Fill({
                color: 'rgba(255, 0, 0, 0.05)'
            })
        });

        // fontSize가 0보다 클 때만 textStyle 생성
        if (fontSize > 0) {
            const textStyle = new ol.style.Style({
                text: new ol.style.Text({
                    font: `bold ${fontSize}px sans-serif`, // ✨ 결정된 fontSize 적용
                    text: feature.get('ADM_NM'),
                    fill: new ol.style.Fill({color: '#000000'}), // 검은색으로 더 선명하게
                    stroke: new ol.style.Stroke({color: '#FFFFFF', width: 4}) // ✨ 흰색 외곽선 다시 추가 및 두껍게
                })
            });
            return [boundaryStyle, textStyle];
        } else {
            // 너무 축소되었을 때는 경계선만 표시
            return boundaryStyle;
        }
    };

    let hangjeongdongLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
            url: `${contextPath}/data/hangjeongdong.geojson`,
            format: new ol.format.GeoJSON()
        }),
        style: styleFunction // ✨ 여기에 직접 정의한 스타일 함수를 연결
    });

    vmap.addLayer(hangjeongdongLayer);

    //======================== 3. 지도 제어 함수 정의 ========================
    const moveToLocation = (admCode) => {
        const vectorSource = hangjeongdongLayer.getSource();

        //줌 값
        if (!admCode) {
            vmap.getView().animate({
                center: daejeonCityHall3857,
                zoom: 11,
                duration: 1000
            });
            return; // '대전 전체'의 경우 여기서 함수 종료
        }

        const features = vectorSource.getFeatures();
        if (features.length === 0) {
            setTimeout(() => moveToLocation(admCode), 500);
            return;
        }

        let targetFeature = null;
        for (const feature of features) {
            if (feature.get('ADM_CD') === admCode) {
                targetFeature = feature;
                break;
            }
        }

        if (targetFeature) {
            const geometry = targetFeature.getGeometry();
            vmap.getView().fit(geometry.getExtent(), {
                padding: [50, 50, 50, 50],
                duration: 1500,
                maxZoom: 14
            });
        } else {
            // ✨ admCode가 있는데도 못 찾은 경우에만 경고 표시
            console.warn(`ADM_CD '${admCode}'에 해당하는 지역을 찾을 수 없습니다.`);
        }
    };
    // =======================================================================

    //======================== 주소 검색 및 지도 이동 기능 ========================
    // 이 코드를 moveToLocation 함수 정의 바로 다음에 추가하세요.

    // 1. 필요한 HTML 요소 선택
    const addressSearchInput = document.getElementById('addressSearchInput');
    const addressSearchButton = document.getElementById('addressSearchButton');

    // 2. V-World API 인증키 (vworldMapInit.js.do 스크립트에서 가져옴)
    const vworldApiKey = "B346494D-259D-3E0B-AFE4-6862A39827F8";

    /**
     * 행정구역 이름으로 사이드바의 지역 선택 메뉴를 찾아 활성화하는 함수
     * @param {string} districtName - '서구', '유성구' 등 구 이름
     * @param {string} dongName - '둔산동', '월평동' 등 동 이름
     */
    const updateSidebarSelection = (districtName, dongName) => {
        // 1. 모든 '구' 링크를 찾습니다.
        const districtLinks = document.querySelectorAll('#districtList > li > a.district-link');
        const targetDistrictLink = Array.from(districtLinks).find(link => link.dataset.districtName === districtName);

        if (!targetDistrictLink) {
            console.warn(`사이드바에서 '${districtName}'을 찾을 수 없습니다.`);
            return;
        }

        // 2. 해당 '구' 링크를 프로그래밍적으로 클릭하여 '동' 목록을 불러옵니다.
        // 이렇게 하면 기존에 만들어둔 동 목록 로딩 로직을 재사용할 수 있습니다.
        targetDistrictLink.click();

        // 3. '동' 목록이 비동기(fetch)로 로드되므로, 잠시 기다린 후 '동'을 선택합니다.
        setTimeout(() => {
            const dongListContainer = targetDistrictLink.nextElementSibling;
            const dongLinks = dongListContainer.querySelectorAll('a.dong-link');
            const targetDongLink = Array.from(dongLinks).find(link => link.dataset.dongName === dongName);

            if (targetDongLink) {
                // 4. 올바른 '동'을 찾았다면, 모든 지역(구, 동)의 활성화 스타일을 제거하고
                document.querySelectorAll('.location-options a').forEach(a => a.classList.remove('active'));
                // 5. 목표 '동' 링크에만 활성화 스타일을 적용합니다.
                targetDongLink.classList.add('active');
            } else {
                console.warn(`'${districtName}' 목록에서 '${dongName}'을 찾을 수 없습니다.`);
                // 동을 못 찾더라도 구는 선택된 상태로 둡니다.
                document.querySelectorAll('.location-options a').forEach(a => a.classList.remove('active'));
                targetDistrictLink.classList.add('active');
            }
        }, 500); // 0.5초 대기 (네트워크 상태에 따라 조절 가능)
    };

    /**
     * 입력된 주소를 V-World API로 검색하여 지도를 이동시키고,
     * 해당 위치의 사이드바 메뉴를 자동으로 선택하는 함수 (디버깅 버전)
     */
    const searchAddressAndMoveMap = () => {
        const address = addressSearchInput.value.trim();

        if (!address) {
            alert('검색할 주소를 입력해주세요.');
            return;
        }
		const daejeonBbox = "127.2,36.2,127.6,36.5";
        // --- 1단계: 주소로 좌표 검색 ---
        $.ajax({
            url: "https://api.vworld.kr/req/address?",
            type: "GET",
            dataType: "jsonp",
            // (이하 1단계 코드는 동일)
            data: {
                service: "address",
                request: "GetCoord",
                version: "2.0",
                crs: "EPSG:4326",
                type: "ROAD",
                address: "대전 "+address,
				bbox: daejeonBbox, // <--- [추가] 검색 범위를 대전으로 제한
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

                const coords3857 = ol.proj.transform([lon, lat], 'EPSG:4326', 'EPSG:3857');
                const view = vmap.getView();
                view.setCenter(coords3857);
                view.setZoom(17);

                // --- 2단계: 좌표로 주소 검색 (Reverse Geocoding) ---
                $.ajax({
                    url: "https://api.vworld.kr/req/address?",
                    type: "GET",
                    dataType: "jsonp",
                    data: {
                        service: "address",
                        request: "getAddress",
                        version: "2.0",
                        crs: "EPSG:4326",
                        type: "both",
                        point: `${lon},${lat}`,
                        format: "json",
                        key: vworldApiKey
                    },
                    success: function (addressResult) {
                        if (addressResult.response.status === "OK" && addressResult.response.result) {
                            const addressInfo = addressResult.response.result[0].structure;
                            const districtName = addressInfo.level2;
                            const dongName = addressInfo.level4L;

                            updateSidebarSelection(districtName, dongName);
							
							// (초기 1회) 홈 검색으로 진입한 경우 모달 표시
							if (window.__initialApplySource === 'search' && !window.__initialApplied) {
							  const regionText = [districtName, dongName].filter(Boolean).join(' ');
							  showSelectionModal({ regionText, bizText: getActiveBizText(), by: 'search' });
							  window.__initialApplied = true;
							}

                        } else {
                            console.warn("좌표에 해당하는 행정동 정보를 찾을 수 없습니다.");
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("행정동 정보 조회 중 오류 발생", error);
                    }
                });

            },
            error: function (xhr, status, error) {
                console.error("주소 검색 API 호출 중 오류 발생:", error);
                alert("주소 검색 중 오류가 발생했습니다. 네트워크 연결을 확인해주세요.");
            }
        });
    };
	
	// ===== [초기 자동선택] =====
	async function applyInitialSelection() {
	  if (window.__initialApplied) return; // 1회만 실행되도록 보장

	  const prefs = window.__userPreferences; // [수정] || {} 제거하여 null 가능성 유지
	  const pendingQuery = window.__pendingQueryFromUrl;

	  // (1) 홈 검색어 처리 (로그인 여부와 상관없이 실행)
	  if (pendingQuery) {
	    window.__initialApplySource = 'search';
	    addressSearchInput.value = pendingQuery;
	    searchAddressAndMoveMap(); // 이 함수가 완료되면 내부에서 모달이 호출됩니다.

	    // 로그인 상태라면 관심 업종도 추가로 적용
	    if (prefs && prefs.parentBizCodeId && prefs.bizCodeId) {
	      try { await selectBizByCodes(prefs.parentBizCodeId, prefs.bizCodeId); } 
	      catch(e) { console.warn('관심 업종 자동선택 실패', e); }
	    }
	    return; // 검색 모드에서는 여기서 종료
	  }

	  // (2) [핵심 수정] 관심정보 처리는 로그인 상태일 때만 실행 (prefs가 null이 아닐 때)
	  if (prefs) {
	      window.__initialApplySource = 'preferences';
	      if (prefs.districtId && prefs.admCode) {
	        try { await selectLocationByCodes(prefs.districtId, prefs.admCode); } 
	        catch(e) { console.warn('관심 구역 자동선택 실패', e); }
	      }
	      if (prefs.parentBizCodeId && prefs.bizCodeId) {
	        try { await selectBizByCodes(prefs.parentBizCodeId, prefs.bizCodeId); } 
	        catch(e) { console.warn('관심 업종 자동선택 실패', e); }
	      }

	      // 자동 선택이 모두 끝난 후, 모달 호출
	      if (!window.__initialApplied && window.__initialApplySource === 'preferences') {
	        const dongActive = document.querySelector('.location-options a.dong-link.active');
	        const distActive = document.querySelector('.location-options a.district-link.active');
	        const regionText = [
	          distActive?.dataset?.districtName,
	          dongActive?.dataset?.dongName
	        ].filter(Boolean).join(' ');
	        
	        showSelectionModal({ regionText, bizText: getActiveBizText(), by: 'preferences' });
	        window.__initialApplied = true;
	      }
	  }
	  // (로그인 안했고, 검색도 안했으면 아무것도 실행하지 않고 조용히 종료)
	}

	// ===== [코드 기반 선택] =====
	async function selectLocationByCodes(districtId, admCode) {
	  const distLink = document.querySelector(`.location-options a.district-link[data-district-id="${districtId}"]`);
	  if (!distLink) throw new Error('district-link not found');
	  distLink.click();

	  const dongUl = distLink.nextElementSibling; // .dong-list
	  await waitFor(`a.dong-link[data-adm-code="${admCode}"]`, dongUl);
	  dongUl.querySelector(`a.dong-link[data-adm-code="${admCode}"]`).click();
	}

	async function selectBizByCodes(parentBizCodeId, bizCodeId) {
	  const mainLink = document.querySelector(`.business-type-options a.biz-link[data-biz-id="${parentBizCodeId}"][data-biz-level="1"]`);
	  if (!mainLink) throw new Error('main biz-link not found');
	  mainLink.click();

	  const subUl = mainLink.nextElementSibling; // .subcategory-list
	  await waitFor(`a.biz-link.sub-link[data-biz-id="${bizCodeId}"]`, subUl);
	  subUl.querySelector(`a.biz-link.sub-link[data-biz-id="${bizCodeId}"]`).click();
	}


    // 6. 이벤트 리스너 연결
    // 검색 버튼 클릭 시 함수 실행
    addressSearchButton.addEventListener('click', searchAddressAndMoveMap);

    // 검색창에서 Enter 키를 눌렀을 때 함수 실행
    addressSearchInput.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
            searchAddressAndMoveMap();
        }
    });
	
	// URL 파라미터는 '가이드 종료 후' 실행을 위해 보류 250820 수정
	if (queryFromUrl) {
	  window.__pendingQueryFromUrl = decodeURIComponent(queryFromUrl);
	}
	// 250820 수정끝
    //======================================================================


    //사이드바 초기 세팅
    const optionsSection = document.getElementById('optionsSection');
    const districtListEl = document.getElementById('districtList');
    const bizCodeListEl = document.getElementById('bizCodeList');
    const analyzeButton = document.getElementById('analyzeButton');
    const reportSidebar = document.getElementById('report-sidebar');
    const closeReportButton = document.getElementById('closeReportButton');

    const fetchInitialData = async () => {
        try {
            const response = await fetch(`${contextPath}/api/market/initial-data`);
            if (!response.ok) throw new Error('서버에서 초기 데이터를 가져오지 못했습니다.');
            const data = await response.json();

			// ▼▼▼ 여기 추가 ▼▼▼
			window.__initialData = data;
			window.__userPreferences = data.userPreferences || null;
			// ▲▲▲ 여기까지 ▲▲▲			
			
            data.districts.forEach(d => {
                const li = document.createElement('li');
                const link = document.createElement('a');
                link.href = '#';
                link.className = 'district-link';
                link.dataset.districtId = d.districtId;
                link.dataset.admCode = d.districtAdmCode;
                link.dataset.districtName = d.districtName;
                link.textContent = d.districtName;
                const dongUl = document.createElement('ul');
                dongUl.className = 'dong-list';
                dongUl.style.display = 'none';  // 추가
                li.appendChild(link);
                li.appendChild(dongUl);
                districtListEl.appendChild(li);
            });

            //업종(대분류) 구분 초기 세팅
            bizCodeListEl.innerHTML = '';
            const mainBizCodes = data.bizCodes.filter(b => b.bizLevel === 1);
            mainBizCodes.forEach((biz, index) => {
                const li = document.createElement('li');
                const link = document.createElement('a');
                link.href = '#';
                link.className = 'biz-link';
                /*if (index === 0) {
                    link.classList.add('active');
                }*/
                link.dataset.bizId = biz.bizCodeId;
                link.dataset.bizLevel = biz.bizLevel;
                link.dataset.bizName = biz.bizName;
                link.textContent = biz.bizName;
                const subUl = document.createElement('ul');
                subUl.className = 'subcategory-list';
                subUl.style.display = 'none';
                li.appendChild(link);
                li.appendChild(subUl);
                bizCodeListEl.appendChild(li);
            });
			
			// ▼▼▼ 여기에 1단계에서 복사한 코드를 붙여넣으세요. ▼▼▼
			// [최종 수정] 이용안내 로직이 페이지 로딩의 모든 흐름을 제어합니다.
			if (hasGuide) {
			    // [수정] 튜토리얼 표시 여부를 URL 파라미터와 상관없이 쿠키 유무로만 결정합니다.
			    const shouldShowGuide = !getCookie('hideSimpleAnalysisGuide');

			    if (shouldShowGuide) {
			        // 1. 이용안내를 보여줘야 할 때 (첫 방문)
			        usageGuideModal.classList.add('visible');
			        reportSidebarForGuide.classList.add('active');
			        showGuideStep(currentStep);
			        // 자동 선택/검색 적용 로직은 '시작하기' 버튼 클릭 시 실행되므로 여기서는 호출하지 않습니다.
			    } else {
			        // 2. 이용안내를 건너뛸 때 (재방문): 바로 자동 선택/검색 적용 실행
			        applyInitialSelection();
			    }

			    // '다음' 버튼 기능 (기존과 동일)
			    nextButtons.forEach(btn => btn.addEventListener('click', () => {
			        currentStep++;
			        if (currentStep < guideSteps.length) {
			            showGuideStep(currentStep);
			        }
			    }));

			    // '시작하기' 버튼 기능: 가이드를 닫고, 자동 선택/검색 적용 실행 (기존과 동일)
			    startButton.addEventListener('click', () => {
			        if (hideCheckbox.checked) setCookie('hideSimpleAnalysisGuide', 'true', 1);
			        usageGuideModal.classList.remove('visible');
			        reportSidebarForGuide.classList.remove('active');
			        
                    // 튜토리얼이 끝난 후, URL 파라미터나 관심정보를 적용하는 함수를 호출합니다.
			        applyInitialSelection(); 
			    });
			} else {
			    // (가이드 기능이 없는 예외적인 경우) 바로 자동 선택 실행
			    applyInitialSelection();
			}
			// ▲▲▲ 여기까지 붙여넣기 ▲▲▲
			
        } catch (error) {
            console.error('초기 데이터 로딩 실패:', error);
            districtListEl.innerHTML = '<li>지역 목록 로딩 실패</li>';
            bizCodeListEl.innerHTML = '<li>업종 목록 로딩 실패</li>';
        }
    };

    optionsSection.addEventListener('click', async (e) => {
        const targetLink = e.target.closest('a');
        if (!targetLink) return;
        e.preventDefault();

        // 클릭된 링크의 종류에 따라 active 클래스를 다르게 관리
        if (targetLink.closest('.location-options')) {
            // '지역' 링크 클릭 시: 모든 지역 링크의 active를 제거 후, 클릭된 링크에만 추가
            document.querySelectorAll('.location-options a').forEach(a => a.classList.remove('active'));
            targetLink.classList.add('active');

            // ================== ✨ 2. 지도 이동 함수 호출 ✨ ==================
            moveToLocation(targetLink.dataset.admCode);
            // ===============================================================


        } else if (targetLink.closest('.business-type-options')) {
            // [수정된 부분] '업종' 링크 클릭 시: 모든 업종 링크의 active를 제거 후, 클릭된 링크에만 추가
            document.querySelectorAll('.business-type-options a').forEach(a => a.classList.remove('active'));
            targetLink.classList.add('active');

        } else if (targetLink.closest('.year-section')) {
            // '연도' 링크 클릭 시: 해당 섹션 내에서만 토글
            const parentUl = targetLink.closest('ul');
            parentUl.querySelectorAll(':scope > li > a').forEach(link => link.classList.remove('active'));
            targetLink.classList.add('active');
        }

        // 행정동(지역) 토글 (부드럽게 슬라이드)
        if (targetLink.classList.contains('district-link') && targetLink.dataset.districtId) {
            const districtId = targetLink.dataset.districtId;
            const dongListContainer = targetLink.nextElementSibling; // <ul class="dong-list">
            // 이미 열려 있으면 닫기
            if ($(dongListContainer).is(':visible')) {
                $(dongListContainer).stop(true).slideUp(200);
            } else {
                // **다른 동 리스트는 모두 닫고**
                $('.dong-list').not(dongListContainer).stop(true).slideUp(200);
                // fetch 후 채우고 열기
                try {
                    const res = await fetch(`${contextPath}/api/market/dongs/${districtId}`);
                    const dongs = await res.json();
                    dongListContainer.innerHTML = '';
                    if (Array.isArray(dongs) && dongs.length) {
                        dongs.forEach(dong => {
                            const li = document.createElement('li');
                            const a = document.createElement('a');
                            a.href = '#';
                            a.className = 'dong-link';
                            a.dataset.admCode = dong.admCode;
                            a.dataset.dongName = dong.admName;
                            a.textContent = dong.admName;
                            li.appendChild(a);
                            dongListContainer.appendChild(li);
                        });
                    } else {
                        dongListContainer.innerHTML = '<li>하위 동이 없습니다.</li>';
                    }
                } catch (err) {
                    console.error(err);
                    dongListContainer.innerHTML = '<li>로딩 실패</li>';
                }
                $(dongListContainer).stop(true).slideDown(200);
            }
        }


        // 업종(중분류) 토글 (부드럽게 슬라이드)
        if (targetLink.classList.contains('biz-link') && !targetLink.classList.contains('sub-link') && targetLink.dataset.bizLevel === '1') {
            const parentCodeId = targetLink.dataset.bizId;
            const subcategoryContainer = targetLink.nextElementSibling; // <ul class="subcategory-list">
            if ($(subcategoryContainer).is(':visible')) {
                $(subcategoryContainer).stop(true).slideUp(200);
            } else {
                // **다른 서브카테고리들은 모두 닫고**
                $('.subcategory-list').not(subcategoryContainer).stop(true).slideUp(200);

                try {
                    const res = await fetch(`${contextPath}/api/market/biz-codes/${parentCodeId}`);
                    const subs = await res.json();
                    subcategoryContainer.innerHTML = '';
                    if (Array.isArray(subs) && subs.length) {
                        subs.forEach(sub => {
                            const li = document.createElement('li');
                            const a = document.createElement('a');
                            a.href = '#';
                            a.classList.add('biz-link', 'sub-link');
                            a.dataset.bizId = sub.bizCodeId;
                            a.dataset.bizLevel = sub.bizLevel;
                            a.dataset.bizName = sub.bizName;
                            a.textContent = sub.bizName;
                            li.appendChild(a);
                            subcategoryContainer.appendChild(li);
                        });
                    } else {
                        subcategoryContainer.innerHTML = '<li>하위 카테고리가 없습니다.</li>';
                    }
                } catch (err) {
                    console.error(err);
                    subcategoryContainer.innerHTML = '<li>로딩 실패</li>';
                }
                $(subcategoryContainer).stop(true).slideDown(200);
            }
        }
    });

    /**
     * [수정] AI 분석 섹션의 UI 틀을 생성하는 범용 함수
     * @param {string} title - 섹션 제목 (예: '인구 통계 AI 간편분석')
     * @param {string} description - 섹션 설명
     * @param {string} resultId - 결과가 표시될 div의 고유 ID
     * @returns {HTMLElement} 생성된 섹션의 div 요소
     */
    const createAiAnalysisSection = (title, description, resultId, sectionId) => {
        const sectionWrapper = document.createElement('div');
        sectionWrapper.className = 'report-section ai-section-wrapper'; // 공통 클래스 추가
        
		// 파라미터로 받은 ID를 요소에 설정
	    if (sectionId) {
	        sectionWrapper.id = sectionId;
	    }
		
		sectionWrapper.innerHTML = `
	        <h5><i class="fas fa-robot"></i> ${title}</h5>
	        <p style="font-size:13px; color:#666;">${description}</p>
	        <div id="${resultId}" class="ai-result-box" style="padding:15px; background-color:#f8f9fa; border-radius: 5px; font-size: 14px; line-height: 1.6; min-height: 50px;">
	            <i class="fas fa-spinner fa-spin"></i> AI가 데이터를 분석하고 있습니다...
	        </div>
	    `;
        return sectionWrapper;
    };

    /**
     * [신규] AI 분석 결과를 포맷팅하는 헬퍼 함수
     * @param {object} result - AI로부터 받은 JSON 응답 객체
     * @returns {string} 화면에 표시될 포맷팅된 문자열
     */
    /**
     * [수정] 각 AI 분석 결과를 그에 맞는 형식으로 포맷팅하는 함수들
     */
        // 1. 인구 분석 결과 포맷팅
        // 기존 formatPopulationResult 대신에
    const formatPopulationResult = (result) => {
            const opportunities = Array.isArray(result.opportunities) ? result.opportunities : [];
            return `
    <table class="ai-result-table">
      <thead>
        <tr><th>항목</th><th>내용</th></tr>
      </thead>
      <tbody>
        <tr><td>핵심 요약</td><td>${result.summary || '요약 정보 없음'}</td></tr>
        <tr><td>주요 연령층</td><td>${result.mainAgeGroup || '정보 없음'}</td></tr>
        <tr><td>성별 특징</td><td>${result.genderRatioFeature || '정보 없음'}</td></tr>
        <tr><td>사업 기회 1</td><td>${opportunities[0] || '데이터 기반 기회 요인 없음'}</td></tr>
        <tr><td>사업 기회 2</td><td>${opportunities[1] || ''}</td></tr>
      </tbody>
    </table>`;
        };


    // 2. 가구 분석 결과 포맷팅 (예시)
    const formatHouseholdResult = (result) => {
        const opportunities = Array.isArray(result.opportunities) ? result.opportunities : [];
        return `
    <table class="ai-result-table">
      <thead>
        <tr><th>항목</th><th>내용</th></tr>
      </thead>
      <tbody>
        <tr><td>핵심 요약</td><td>${result.summary || '요약 정보 없음'}</td></tr>
        <tr><td>주요 가구 유형</td><td>${result.mainHouseholdType || '정보 없음'}</td></tr>
        <tr><td>가구원수 특징</td><td>${result.householdSizeFeature || '정보 없음'}</td></tr>
        <tr><td>사업 기회 1</td><td>${opportunities[0] || '데이터 기반 기회 요인 없음'}</td></tr>
        <tr><td>사업 기회 2</td><td>${opportunities[1] || ''}</td></tr>
      </tbody>
    </table>`;
    };

    // 3. 주택 분석 결과 포맷팅 (테이블 버전)
    const formatHousingResult = (result) => {
        const opportunities = Array.isArray(result.opportunities) ? result.opportunities : [];
        return `
    <table class="ai-result-table">
      <thead>
        <tr><th>항목</th><th>내용</th></tr>
      </thead>
      <tbody>
        <tr><td>핵심 요약</td><td>${result.summary || '요약 정보 없음'}</td></tr>
        <tr><td>주요 주택 유형</td><td>${result.mainHousingType || '정보 없음'}</td></tr>
        <tr><td>건축 연도 특징</td><td>${result.buildingAgeFeature || '정보 없음'}</td></tr>
        <tr><td>사업 기회 1</td><td>${opportunities[0] || '데이터 기반 기회 요인 없음'}</td></tr>
        <tr><td>사업 기회 2</td><td>${opportunities[1] || ''}</td></tr>
      </tbody>
    </table>`;
    };

    // 4. 사업체 분석 결과 포맷팅 (테이블 버전)
    const formatBusinessResult = (result) => {
        const opportunities = Array.isArray(result.opportunities) ? result.opportunities : [];
        return `
    <table class="ai-result-table">
      <thead>
        <tr><th>항목</th><th>내용</th></tr>
      </thead>
      <tbody>
        <tr><td>핵심 요약</td><td>${result.summary || '요약 정보 없음'}</td></tr>
        <tr><td>업종 밀집도</td><td>${result.densityFeature || '정보 없음'}</td></tr>
        <tr><td>종사자 규모</td><td>${result.employeeSizeFeature || '정보 없음'}</td></tr>
        <tr><td>사업 기회 1</td><td>${opportunities[0] || '데이터 기반 기회 요인 없음'}</td></tr>
        <tr><td>사업 기회 2</td><td>${opportunities[1] || ''}</td></tr>
      </tbody>
    </table>`;
    };


    /**
     * [수정] 모든 AI 분석 API를 동시에 호출하고 UI를 업데이트하는 메인 함수
     * @param {object} analysisData - 전체 통계 데이터 객체
     * @param {Array} sgisCodes - SGIS 코드 데이터
     */
    async function fetchAllAiAnalyses(analysisData, sgisCodes) {
        try {
            // 4개의 fetch 요청을 동시에 보냄
            const [
                populationRes,
                householdRes,
                housingRes,
                businessRes
            ] = await Promise.all([
                // 1. 인구 분석
                fetch(`${contextPath}/api/market/interpret/population`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({populationStats: analysisData.populationStats, sgisCodes})
                }),
                // 2. 가구 분석
                fetch(`${contextPath}/api/market/interpret/household`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({householdStats: analysisData.householdStats, sgisCodes})
                }),
                // 3. 주택 분석
                fetch(`${contextPath}/api/market/interpret/housing`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({housingStats: analysisData.housingStats, sgisCodes})
                }),
                // 4. 사업체/종사자 분석
                fetch(`${contextPath}/api/market/interpret/business`, {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({bizStats: analysisData.bizStats, empStats: analysisData.empStats, sgisCodes})
                })
            ]);

            // 각 응답을 JSON으로 변환
            const populationResult = await populationRes.json();
            const householdResult = await householdRes.json();
            const housingResult = await housingRes.json();
            const businessResult = await businessRes.json();

            // [수정] 각 결과에 맞는 포맷 함수로 UI 업데이트
            document.getElementById('ai-population-result').innerHTML = formatPopulationResult(populationResult);
            document.getElementById('ai-household-result').innerHTML = formatHouseholdResult(householdResult);
            document.getElementById('ai-housing-result').innerHTML = formatHousingResult(housingResult);
            document.getElementById('ai-business-result').innerHTML = formatBusinessResult(businessResult);

        } catch (error) {
            console.error("전체 AI 분석 중 오류 발생:", error);
            // 오류 발생 시 모든 AI 분석 영역에 에러 메시지 표시
            document.querySelectorAll('.ai-result-box').forEach(box => {
                box.style.color = 'red';
                box.innerHTML = 'AI 분석 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
            });
        }
    }

    //분석하기 클릭 시
    analyzeButton.addEventListener('click', async () => {
        // --- 1. 유효성 검사 및 파라미터 준비 (기존과 동일) ---
        const activeLocation = document.querySelector('.location-options a.active');
        const activeBiz = document.querySelector('.business-type-options a.active');
        const activeYear = document.querySelector('.year-section a.active');

        if (!activeLocation || !activeBiz || !activeYear) {
            alert('지역, 업종, 연도를 모두 선택해주세요.');
            return;
        }

        const parentDistrictLi = activeLocation.closest('.location-options > ul > li');
        const districtId = parentDistrictLi.querySelector('.district-link')?.dataset.districtId;

        if (activeLocation.textContent !== '대전광역시 전체' && !districtId) {
            alert('지역(구) 정보를 찾을 수 없습니다. 다시 선택해주세요.');
            return;
        }

        const params = new URLSearchParams({
            admCode: activeLocation.dataset.admCode,
            bizCodeId: activeBiz.dataset.bizId,
            bizLevel: activeBiz.dataset.bizLevel,
            year: activeYear.dataset.year,
            districtId: districtId || ''
        });

        // --- 2. 분석 시작 전, 이전 차트 모두 제거 ---
        clearAllCharts();

        try {
            const response = await fetch(`${contextPath}/api/market/analyze?${params.toString()}`);
            if (!response.ok) throw new Error(`서버 오류: ${response.status}`);
            const result = await response.json();

            // ======================= AI 분석에 필요한 데이터를 전역 변수에 캐싱(저장)  =======================

            cachedAnalysisData = result.analysisResult;
            cachedSgisCodes = result.sgisCodes;

            // =======================================================================


            // --- 3. 리포트 사이드바 내용 채우기 (기존과 동일) ---
            const locationInfo = result.locationNames;
            const analysisData = result.analysisResult;
            const sgisCodes = result.sgisCodes;

            if (locationInfo && locationInfo.DISTRICT_NAME) {
                document.getElementById('modalLocation').textContent = `${locationInfo.DISTRICT_NAME} ${locationInfo.ADM_NAME}`;
            } else {
                document.getElementById('modalLocation').textContent = activeLocation.textContent;
            }

            if (activeBiz.classList.contains('sub-link')) {
                const parentBizLink = activeBiz.closest('.subcategory-list').previousElementSibling;
                const mainBizName = parentBizLink ? parentBizLink.getAttribute('data-biz-name') : '';
                const subBizName = activeBiz.getAttribute('data-biz-name');
                document.getElementById('modalBiz').textContent = `${mainBizName} > ${subBizName}`;
            } else {
                document.getElementById('modalBiz').textContent = activeBiz.textContent;
            }
            document.getElementById('modalYear').textContent = activeYear.dataset.year;

            // ... (리포트 결과창 HTML 생성 로직은 기존과 동일)
            const analysisResultsContainer = document.getElementById('analysisResultsContainer');
            analysisResultsContainer.innerHTML = '';
            const sgisCodeMap = new Map();
            if (sgisCodes && Array.isArray(sgisCodes)) {
                for (const code of sgisCodes) {
                    sgisCodeMap.set(code.codeId, code.codeName);
                }
            }

            // ======================= 하이차트(Highcharts) 부분 =======================

            /**
             * 하이차트(Highcharts)로 연령대별 인구 통계 차트를 생성하는 함수
             * @param {Array} populationData - 인구 통계 원본 데이터
             * @param {Map} codeMap - SGIS 코드를 이름으로 변환하는 맵
             */
            const renderPopulationHighchart = (populationData, codeMap) => {
                const chartContainer = document.getElementById('populationChartContainer');
                if (!chartContainer) return;

                if (!populationData || !Array.isArray(populationData) || populationData.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">차트를 표시할 인구 데이터가 없습니다.</p>';
                    return;
                }

                // 1. 데이터 가공: 성별 연령대 데이터를 그룹화
                const ageGroups = {};
                populationData.forEach(item => {
                    const label = codeMap.get(item.sgisCode) || '';
                    // '세'가 포함되고 괄호가 없는 데이터만 연령대 데이터로 간주
                    if (label.includes('세') && !label.includes('(')) {
                        const value = parseInt(item.statsValue || 0);

                        if (label.includes('_남자')) {
                            const baseLabel = label.replace('_남자', '');
                            if (!ageGroups[baseLabel]) ageGroups[baseLabel] = {};
                            ageGroups[baseLabel].male = value;
                        } else if (label.includes('_여자')) {
                            const baseLabel = label.replace('_여자', '');
                            if (!ageGroups[baseLabel]) ageGroups[baseLabel] = {};
                            ageGroups[baseLabel].female = value;
                        }
                    }
                });

                // 2. Highcharts 형식으로 변환 및 정렬
                // 레이블을 파싱하여 정렬 키와 표시 이름을 생성하는 헬퍼 함수
                const parseAgeLabel = (label) => {
                    if (label.includes('~')) { // ex: "5세이상~9세이하"
                        const parts = label.replace(/세이상|세이하/g, '').split('~');
                        return {name: `${parts[0]}-${parts[1]}세`, sortKey: parseInt(parts[0])};
                    } else if (label.includes('이하')) { // ex: "4세이하"
                        const age = label.replace('세이하', '');
                        return {name: `0-${age}세`, sortKey: 0};
                    } else if (label.includes('이상')) { // ex: "100세이상"
                        const age = label.replace('세이상', '');
                        return {name: `${age}세 이상`, sortKey: parseInt(age)};
                    }
                    return null;
                };

                const sortedCategories = Object.keys(ageGroups)
                    .map(label => ({label, ...parseAgeLabel(label)}))
                    .filter(item => item.name) // 파싱 실패한 항목 제거
                    .sort((a, b) => a.sortKey - b.sortKey);

                const categories = sortedCategories.map(item => item.name);
                const maleData = sortedCategories.map(item => ageGroups[item.label]?.male || 0);
                const femaleData = sortedCategories.map(item => ageGroups[item.label]?.female || 0);

                if (categories.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">연령대별 인구 데이터가 없습니다.</p>';
                    return;
                }

                // 3. Highcharts 생성 (그룹 막대 차트)
                Highcharts.chart('populationChartContainer', {
                    chart: {type: 'bar'},
                    title: {text: '성별/연령대별 인구 분포', style: {fontSize: '16px', fontWeight: 'bold'}},
                    xAxis: {categories: categories, title: {text: null}, labels: {style: {fontSize: '12px'}}},
                    yAxis: {
                        min: 0,
                        title: {text: '인구 수 (명)', align: 'high'},
                        labels: {overflow: 'justify', style: {fontSize: '12px'}}
                    },
                    tooltip: {
                        headerFormat: '<b>{point.x}</b><br/>',
                        pointFormat: '<span style="color:{series.color}">●</span> {series.name}: <b>{point.y:,.0f} 명</b><br/>',
                        shared: true
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {
                                enabled: true,
                                format: '{point.y:,.0f}',
                                style: {
                                    fontSize: '10px',
                                    fontWeight: 'normal',
                                    textOutline: 'none'
                                }
                            }
                        }
                    },
                    legend: {
                        verticalAlign: 'top',
                        backgroundColor: '#FFFFFF',
                        reversed: true
                    },
                    credits: {enabled: false},
                    series: [{
                        name: '여자',
                        data: femaleData,
                        color: '#f15c80'
                    }, {
                        name: '남자',
                        data: maleData,
                        color: '#7cb5ec'
                    }]
                });
            };


            /**
             * [신규] 하이차트(Highcharts)로 가구 유형별 통계 차트를 생성하는 함수
             * @param {Array} householdData - 가구 통계 원본 데이터
             * @param {Map} codeMap - SGIS 코드를 이름으로 변환하는 맵
             */
            const renderHouseholdHighchart = (householdData, codeMap) => {
                const chartContainer = document.getElementById('householdChartContainer');
                if (!chartContainer) return;

                if (!householdData || householdData.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">차트를 표시할 가구 데이터가 없습니다.</p>';
                    return;
                }

                // 1. 데이터 가공: 파이 차트에 표시할 데이터만 필터링
                const targetLabels = ['1인가구', '1세대가구', '2세대가구', '3세대가구', '4세대가구', '비친족가구'];
                const chartData = householdData
                    .map(item => {
                        const label = codeMap.get(item.sgisCode) || '';
                        if (targetLabels.includes(label)) {
                            return {
                                name: label,
                                y: parseInt(item.statsValue || 0)
                            };
                        }
                        return null;
                    })
                    .filter(item => item && item.y > 0); // null이 아니고 값이 0보다 큰 데이터만 포함

                if (chartData.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">가구 유형 데이터가 없습니다.</p>';
                    return;
                }

                // 가장 큰 값을 가진 조각을 강조하기 위해 데이터 정렬
                chartData.sort((a, b) => b.y - a.y);
                if (chartData.length > 0) {
                    chartData[0].sliced = true;
                    chartData[0].selected = true;
                }

                // 2. Highcharts 파이 차트 생성
                Highcharts.chart('householdChartContainer', {
                    chart: {type: 'pie'},
                    title: {text: '가구 유형별 분포', style: {fontSize: '16px', fontWeight: 'bold'}},
                    tooltip: {pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b> ({point.y:,.0f} 가구)'},
                    accessibility: {point: {valueSuffix: '%'}},
                    plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                                style: {fontSize: '12px', fontWeight: 'normal', textOutline: 'none'}
                            },
                            showInLegend: true
                        }
                    },
                    credits: {enabled: false},
                    series: [{
                        name: '가구 수',
                        colorByPoint: true,
                        data: chartData
                    }]
                });
            };

            /**
             * [신규] 하이차트(Highcharts)로 건축 연도별 주택 통계 차트를 생성하는 함수
             * @param {Array} housingData - 주택 통계 원본 데이터
             * @param {Map} codeMap - SGIS 코드를 이름으로 변환하는 맵
             */
            const renderHousingHighchart = (housingData, codeMap) => {
                const chartContainer = document.getElementById('housingChartContainer');
                if (!chartContainer) return;

                if (!housingData || housingData.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">차트를 표시할 주택 데이터가 없습니다.</p>';
                    return;
                }

                // 1. 데이터 가공: 건축 연도 데이터만 필터링하고 정렬 키 생성
                const parseYearLabel = (label) => {
                    if (label.includes('~')) { // ex: "2000년~2004년"
                        return {name: label, sortKey: parseInt(label.split('~')[0])};
                    } else if (label.includes('이전')) { // ex: "1979년 이전"
                        return {name: label, sortKey: parseInt(label.replace('년 이전', ''))};
                    } else if (label.endsWith('년')) { // ex: "2011년"
                        return {name: label, sortKey: parseInt(label.replace('년', ''))};
                    }
                    return null; // 연도 데이터가 아닌 경우
                };

                const chartData = housingData
                    .map(item => {
                        const label = codeMap.get(item.sgisCode) || '';
                        const parsed = parseYearLabel(label);
                        if (parsed) {
                            return {...parsed, y: parseInt(item.statsValue || 0)};
                        }
                        return null;
                    })
                    .filter(item => item && item.y > 0) // 유효하고 값이 0보다 큰 데이터만
                    .sort((a, b) => a.sortKey - b.sortKey); // 연도순으로 정렬

                if (chartData.length === 0) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">건축 연도별 주택 데이터가 없습니다.</p>';
                    return;
                }

                // 2. Highcharts 막대 차트 생성
                Highcharts.chart('housingChartContainer', {
                    chart: {type: 'bar'},
                    title: {text: '건축 연도별 주택 분포', style: {fontSize: '16px', fontWeight: 'bold'}},
                    xAxis: {
                        categories: chartData.map(d => d.name),
                        title: {text: null},
                        labels: {style: {fontSize: '12px'}}
                    },
                    yAxis: {
                        min: 0,
                        title: {text: '주택 수 (호)', align: 'high'},
                        labels: {overflow: 'justify', style: {fontSize: '12px'}}
                    },
                    tooltip: {
                        headerFormat: '<b>{point.key}</b><br/>',
                        pointFormat: '주택 수: {point.y:,.0f} 호'
                    },
                    plotOptions: {
                        bar: {
                            dataLabels: {enabled: true, format: '{y:,.0f} 호'},
                            color: '#2b908f'
                        }
                    },
                    legend: {enabled: false},
                    credits: {enabled: false},
                    series: [{
                        name: '주택 수',
                        data: chartData
                    }]
                });
            };


            /**
             * [신규] 하이차트(Highcharts)로 지역별 평균 매출을 비교하는 차트를 생성하는 함수
             * @param {Array} dongAvgData - 선택 지역(동)의 신용카드 통계 데이터
             * @param {Object} guAvgData - 소속 지역(구)의 평균 매출 데이터
             */
            const renderCreditCardHighchart = (dongAvgData, guAvgData, totalAvgData) => {
                const chartContainer = document.getElementById('creditCardChartContainer');
                if (!chartContainer) return;

                if (!dongAvgData?.[0]?.avgPaymentAmount || !guAvgData?.AVG_PAYMENT || totalAvgData === undefined) {
                    chartContainer.innerHTML = '<p style="text-align:center; color:#888; padding: 20px;">매출 비교 데이터를 표시할 수 없습니다.</p>';
                    return;
                }

                const dongValue = parseInt(dongAvgData[0].avgPaymentAmount || 0);
                const guValue = parseInt(guAvgData.AVG_PAYMENT || 0);
                const totalValue = parseInt(totalAvgData || 0);

                const activeLocation = document.querySelector('.location-options a.active');
                const dongName = activeLocation.classList.contains('dong-link') ? activeLocation.dataset.dongName : '선택 지역';
                const districtName = activeLocation.closest('.location-options > ul > li').querySelector('.district-link')?.dataset.districtName || '소속 자치구';
                const totalName = '대전광역시'; // ✨ 전체 라벨

                Highcharts.chart('creditCardChartContainer', {
                    chart: {type: 'column'},
                    title: {text: '지역별 평균 매출 비교', style: {fontSize: '16px', fontWeight: 'bold'}},
                    xAxis: {
                        // ✨ 3. X축 카테고리에 '대전광역시' 추가
                        categories: [dongName, districtName, totalName],
                        crosshair: true,
                        labels: {style: {fontSize: '13px', fontWeight: 'bold'}}
                    },
                    yAxis: {
                        min: 0,
                        title: {text: '평균 매출 (천원)'}
                    },
                    tooltip: {
                        headerFormat: '<span style="font-size:12px">{point.key}</span><table>',
                        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                            '<td style="padding:0"><b>{point.y:,.0f} 천원</b></td></tr>',
                        footerFormat: '</table>',
                        shared: true,
                        useHTML: true
                    },
                    plotOptions: {
                        column: {
                            pointPadding: 0.2,
                            borderWidth: 0,
                            dataLabels: {enabled: true, format: '{point.y:,.0f}'}
                        }
                    },
                    legend: {enabled: false},
                    credits: {enabled: false},
                    series: [{
                        name: '평균 매출',
                        // ✨ 4. series 데이터에 전체 평균 객체 추가
                        data: [
                            {name: dongName, y: dongValue, color: '#f7a35c'},
                            {name: districtName, y: guValue, color: '#7cb5ec'},
                            {name: totalName, y: totalValue, color: '#90ed7d'} // 초록색 계열로 추가
                        ]
                    }]
                });
            };

            // ✨ 차트 객체들을 저장할 Map 생성
            const chartObjects = new Map();

            // (사업체수, 종사자수) 두 데이터를 받아 하나의 복합 차트를 생성하는 함수
            const createTwoBarChart = (bizData, empData, position, offset, size) => {
                if (!bizData?.[0] || !empData?.[0]) {
                    console.log('사업체 또는 종사자 데이터가 없어 차트를 생성할 수 없습니다.');
                    return;
                }

                const values = [
                    parseInt(bizData[0].statsValue || 0),
                    parseInt(empData[0].statsValue || 0)
                ];

                const styles = [
                    {
                        color: '#d26900',
                        label: '사업체 수',
                        legendLabel: '사업체 수\n(단위: 개)'
                    },
                    {
                        color: '#726056',
                        label: '종사자 수',
                        legendLabel: '종사자 수\n(단위: 명)'
                    }
                ];

                const barChart = new vw.ol3.chart.Bar(size);
                barChart.title = '사업체 / 종사자 관련 통계';
                barChart.values = values;
                barChart.styles = styles;

                const legend = new vw.ol3.chart.ChartLegend();
                legend.direction = 'vertical';
                legend.visible = true;
                barChart.legend = legend;
                barChart.showLabel = true;

                barChart.setPosition(position);
                barChart.setOffset(offset);
                barChart.draw();
				
				if (barChart.element_) {
			        barChart.element_.style.backgroundColor = 'rgba(255,255,255,0.9)';
			        barChart.element_.style.border = '1px solid #ccc';
			        barChart.element_.style.borderRadius = '4px';
			        barChart.element_.style.padding = '4px';
			    }
				
                vmap.addOverlay(barChart);
                currentMapCharts.push(barChart);
                return barChart;
            };

            // (인구) 총인구, 남자, 여자 복합 차트를 생성하는 함수
            const createPopulationChart = (populationData, sgisCodeMap, position, offset, size) => {
                // 1. 전체 인구 데이터에서 '총인구', '남자', '여자' 데이터를 각각 찾습니다.
                let totalPopData = null;
                let malePopData = null;
                let femalePopData = null;
                for (const item of populationData) {
                    const label = sgisCodeMap.get(item.sgisCode);
                    if (label === '총인구(남자)') {
                        malePopData = item;
                    }
                    if (label === '총인구(여자)') {
                        femalePopData = item;
                    }
                    if (label === '총인구') {
                        totalPopData = item;
                    }
                }

                // 2. 총인구/남자/여자 데이터를 values와 styles 배열로 구성합니다.
                const values = [
                    parseInt(malePopData.statsValue || 0),
                    parseInt(femalePopData.statsValue || 0),
                    parseInt(totalPopData.statsValue || 0)
                ];
                const styles = [
                    {
                        color: '#56B4E9', // 하늘색
                        label: '남자 인구',
                        legendLabel: '남자 인구'
                    },
                    {
                        color: '#E69F00', // 주황색
                        label: '여자 인구',
                        legendLabel: '여자 인구'
                    },
                    {
                        color: '#3a75c4', // 파란색
                        label: '총인구',
                        legendLabel: '총인구'
                    }
                ];

                // 3. 차트 객체를 생성하고 설정합니다.
                const barChart = new vw.ol3.chart.Bar(size);
                barChart.title = '인구 통계';
                barChart.values = values;
                barChart.styles = styles;

                const legend = new vw.ol3.chart.ChartLegend();
                legend.direction = 'vertical';
                legend.visible = true;
                barChart.legend = legend;
                barChart.showLabel = true;
                barChart.setPosition(position);
                barChart.setOffset(offset);
                barChart.draw();
                if (barChart.element_) {
                    // give the canvas/div a white, semi-opaque background + a light border
                    barChart.element_.style.backgroundColor = 'rgba(255,255,255,0.9)';
                    barChart.element_.style.border = '1px solid #ccc';
                    barChart.element_.style.borderRadius = '4px';
                    barChart.element_.style.padding = '4px';
                }
                vmap.addOverlay(barChart);
                currentMapCharts.push(barChart);
                return barChart;
            };

            // (가구) 세대별 가구 복합 차트를 생성하는 함수
            const createHouseholdChart = (householdData, sgisCodeMap, position, offset, size) => {
                // 1. 차트에 표시할 특정 통계 항목 목록을 정의합니다.
                const targetLabels = [
                    '1인가구',
                    '1세대가구',
                    '2세대가구',
                    '3세대가구',
                    '4세대가구 이상',
                    '총가구수'
                ];
                const foundData = {};

                // 2. 전체 가구 데이터에서 targetLabels에 해당하는 항목들만 찾아서 foundData 객체에 저장합니다.
                for (const item of householdData) {
                    const label = sgisCodeMap.get(item.sgisCode);
                    if (targetLabels.includes(label)) {
                        foundData[label] = item;
                    }
                }

                // 3. 핵심 수정: 데이터가 없으면 0으로 처리하여 항상 6개의 값을 생성합니다.
                const values = targetLabels.map(label => {
                    const dataItem = foundData[label]; // 해당 라벨의 데이터가 있는지 확인
                    return parseInt(dataItem ? dataItem.statsValue : 0); // 있으면 statsValue를, 없으면 0을 사용
                });

                const colors = ['#4477AA', '#EE6677', '#228833', '#CCBB44', '#66CCEE', '#AA3377'];
                const styles = targetLabels.map((label, index) => ({
                    color: colors[index],
                    label: label,
                    legendLabel: label
                }));

                // 4. 차트 객체를 생성하고 설정합니다.
                const barChart = new vw.ol3.chart.Bar(size);
                barChart.title = '세대별 가구 통계';
                barChart.values = values;
                barChart.styles = styles;

                const legend = new vw.ol3.chart.ChartLegend();
                legend.direction = 'vertical';
                legend.visible = true;
                barChart.legend = legend;
                barChart.showLabel = true;

                barChart.setPosition(position);
                barChart.setOffset(offset);
                barChart.draw();
				
				if (barChart.element_) {
			        barChart.element_.style.backgroundColor = 'rgba(255,255,255,0.9)';
			        barChart.element_.style.border = '1px solid #ccc';
			        barChart.element_.style.borderRadius = '4px';
			        barChart.element_.style.padding = '4px';
			    }
				
                vmap.addOverlay(barChart);
                currentMapCharts.push(barChart);
                return barChart;
            };

            // (주택) 유형별 주택 복합 차트를 생성하는 함수
            const createHousingChart = (housingData, sgisCodeMap, position, offset, size) => {
                // 1. 차트에 표시할 특정 통계 항목 목록을 정의합니다.
                const targetLabels = [
                    '단독주택',
                    '연립주택',
                    '다세대주택',
                    '아파트',
                    '총주택(거처)수'
                ];
                const foundData = {};

                // 2. 전체 주택 데이터에서 targetLabels에 해당하는 항목들만 찾습니다.
                for (const item of housingData) {
                    const label = sgisCodeMap.get(item.sgisCode);
                    // '다세대'와 '다세대주택'을 모두 처리하기 위한 예외처리
                    if (label === '다세대') {
                        foundData['다세대주택'] = item;
                    }
                    if (targetLabels.includes(label)) {
                        foundData[label] = item;
                    }
                }

                // 3. 데이터가 없으면 0으로 처리하여 항상 7개의 값을 생성합니다.
                const values = targetLabels.map(label => {
                    const dataItem = foundData[label];
                    return parseInt(dataItem ? dataItem.statsValue : 0);
                });

                const colors = ['#E69F00', '#56B4E9', '#009E73', '#F0E442', '#0072B2', '#D55E00', '#CC79A7'];
                const styles = targetLabels.map((label, index) => ({
                    color: colors[index],
                    label: label.replace('영업용 건물 내 주택', '기타주택'), // 이름이 길어서 축약
                    legendLabel: label.replace('영업용 건물 내 주택', '기타주택')
                }));

                // 4. 차트 객체를 생성하고 설정합니다.
                const barChart = new vw.ol3.chart.Bar(size);
                barChart.title = '주택 유형 통계';
                barChart.values = values;
                barChart.styles = styles;

                const legend = new vw.ol3.chart.ChartLegend();
                legend.direction = 'vertical';
                legend.visible = true;
                barChart.legend = legend;
                barChart.showLabel = true;

                barChart.setPosition(position);
                barChart.setOffset(offset);
                barChart.draw();
				
				if (barChart.element_) {
			        barChart.element_.style.backgroundColor = 'rgba(255,255,255,0.9)';
			        barChart.element_.style.border = '1px solid #ccc';
			        barChart.element_.style.borderRadius = '4px';
			        barChart.element_.style.padding = '4px';
			    }
				
                vmap.addOverlay(barChart);
                currentMapCharts.push(barChart);
                return barChart;
            };

            // (신용카드) 선택지역(동)과 소속지역(구)의 평균 매출을 비교하는 차트 생성 함수
            const createCreditCardChart = (dongAvgData, guAvgData, position, offset, size) => {
                // 1. 데이터 유효성을 검사합니다.
                if (!dongAvgData?.[0] || !guAvgData) {
                    console.log('신용카드 (동/구) 데이터가 부족하여 차트를 생성할 수 없습니다.');
                    return;
                }

                // 2. 동 평균 매출과 구 평균 매출 값을 가져옵니다.
                // (동 데이터는 avgPaymentAmount, 구 데이터는 AVG_PAYMENT로 키 이름이 다름에 유의)
                const dongValue = parseInt(dongAvgData[0].avgPaymentAmount || 0);
                const guValue = parseInt(guAvgData.AVG_PAYMENT || 0);

                const values = [dongValue, guValue];

                // 3. 범례 텍스트가 너무 길지 않도록 조정합니다.
                const styles = [
                    {
                        color: '#D55E00', // 주황색 계열
                        label: '행정동 평균',
                        legendLabel: '선택지역(동) 평균'
                    },
                    {
                        color: '#F0E442', // 노란색 계열
                        label: '구 평균',
                        legendLabel: '소속지역(구) 평균'
                    }
                ];

                // 4. 차트 객체를 생성하고 설정합니다.
                const barChart = new vw.ol3.chart.Bar(size);
                barChart.title = '평균 매출 비교 (천원)';
                barChart.values = values;
                barChart.styles = styles;

                const legend = new vw.ol3.chart.ChartLegend();
                legend.direction = 'vertical';
                legend.visible = true;
                barChart.legend = legend;
                barChart.showLabel = true;

                barChart.setPosition(position);
                barChart.setOffset(offset);
                barChart.draw();
				
				if (barChart.element_) {
			        barChart.element_.style.backgroundColor = 'rgba(255,255,255,0.9)';
			        barChart.element_.style.border = '1px solid #ccc';
			        barChart.element_.style.borderRadius = '4px';
			        barChart.element_.style.padding = '4px';
			    }
				
                vmap.addOverlay(barChart);
                currentMapCharts.push(barChart);
                return barChart;
            };


            const createSection = (title, data, valueKey, unit, chartKey) => { // chartKey 파라미터 추가
                let sectionHtml = '';
                if (data && Array.isArray(data) && data.length > 0) {
					// 수정: title을 기반으로 ID 생성 (공백 제거)
					const sectionId = `section-${title.replace(/\s+/g, '')}`; 
					sectionHtml += `<div id="${sectionId}" class="report-section">`;
					sectionHtml += `<h4 data-chart-key="${chartKey}" style="cursor: pointer;">${title}</h4><ul class="summary-list">`;
			        
                    if (chartKey === 'pop') {
                        // (이전과 동일) 인구 통계 로직
                        const desiredLabels = ['총인구', '인구밀도', '평균나이', '노령화지수'];
                        const unitMap = {
                            '총인구': '명',
							'인구밀도': '명/㎢',  // '인구 밀도'가 아니라 '인구밀도'일 가능성이 높아보여 함께 수정합니다.
						    '평균나이': '세',      // <--- '평균 연령'에서 '평균나이'로 수정
						    '노령화지수': '명/100명당' // <--- '노령화 지수'에서 '노령화지수'로 수정하고, 단위를 변경
                        };
                        const filteredAndSortedData = data
                            .filter(item => desiredLabels.includes(sgisCodeMap.get(item.sgisCode)))
                            .sort((a, b) => {
                                const labelA = sgisCodeMap.get(a.sgisCode);
                                const labelB = sgisCodeMap.get(b.sgisCode);
                                return desiredLabels.indexOf(labelA) - desiredLabels.indexOf(labelB);
                            });
                        for (const item of filteredAndSortedData) {
                            const label = sgisCodeMap.get(item.sgisCode);
                            const valueString = parseFloat(item[valueKey] || 0).toLocaleString('ko-KR', {maximumFractionDigits: 1});
                            const value = `${valueString} ${unitMap[label] || unit}`;
                            sectionHtml += `<li><span class="label">${label}</span><span class="value">${value}</span></li>`;
                        }

                    } else if (chartKey === 'household') {
                        // (이전과 동일) 가구 통계 로직
                        let totalHouseholds = null, avgMembers = null, singlePersonHouseholds = null;
                        for (const item of data) {
                            const label = sgisCodeMap.get(item.sgisCode);
                            if (label === '총가구수') totalHouseholds = item;
                            else if (label === '평균가구원수') avgMembers = item;
                            else if (label === '1인가구') singlePersonHouseholds = item;
                        }
                        if (totalHouseholds) {
                            const value = `${parseInt(totalHouseholds.statsValue || 0).toLocaleString()} 가구`;
                            sectionHtml += `<li><span class="label">총가구수</span><span class="value">${value}</span></li>`;
                        }
                        if (avgMembers) {
                            const value = `${parseFloat(avgMembers.statsValue || 0).toFixed(2)} 명`;
                            sectionHtml += `<li><span class="label">평균가구원수</span><span class="value">${value}</span></li>`;
                        }
                        if (totalHouseholds && singlePersonHouseholds) {
                            const totalVal = parseInt(totalHouseholds.statsValue || 0);
                            const singleVal = parseInt(singlePersonHouseholds.statsValue || 0);
                            if (totalVal > 0) {
                                const ratio = (singleVal / totalVal) * 100;
                                const value = `${ratio.toFixed(1)} %`;
                                sectionHtml += `<li><span class="label">1인가구비율</span><span class="value">${value}</span></li>`;
                            }
                        }

                        // ====================== ✨ 수정된 부분 시작 ✨ ======================
                    } else if (chartKey === 'housing') {
                        // 주택 통계 섹션을 위한 새로운 로직
                        let totalHouses = null, apartments = null;
                        const yearStats = []; // '년'이 포함된 건축 시기 통계
                        const areaStats = []; // '㎡'가 포함된 면적 통계

                        // 1. 원본 데이터에서 필요한 항목들을 분류
                        for (const item of data) {
                            const label = sgisCodeMap.get(item.sgisCode) || '';
                            if (label === '총주택(거처)수') totalHouses = item;
                            else if (label === '아파트') apartments = item;
                            else if (label.includes('년')) yearStats.push(item);
                            else if (label.includes('㎡')) areaStats.push(item);
                        }

                        // 2. 분류된 데이터를 가공하여 리포트 항목 생성
                        // 2-1. 총주택(거처)수
                        if (totalHouses) {
                            const value = `${parseInt(totalHouses.statsValue || 0).toLocaleString()} 호`;
                            sectionHtml += `<li><span class="label">총주택(거처)수</span><span class="value">${value}</span></li>`;
                        }

                        // 2-2. 아파트비율 계산 및 표시
                        if (totalHouses && apartments) {
                            const totalVal = parseInt(totalHouses.statsValue || 0);
                            const aptVal = parseInt(apartments.statsValue || 0);
                            if (totalVal > 0) {
                                const ratio = (aptVal / totalVal) * 100;
                                const value = `${ratio.toFixed(1)} %`;
                                sectionHtml += `<li><span class="label">아파트비율</span><span class="value">${value}</span></li>`;
                            }
                        }

                        // 2-3. 핵심주거면적 찾기 및 표시
                        if (areaStats.length > 0) {
                            // 면적 통계 데이터 중 가장 큰 값을 가진 항목을 찾음
                            const maxAreaStat = areaStats.reduce((max, item) =>
                                (parseInt(item.statsValue || 0) > parseInt(max.statsValue || 0)) ? item : max
                            );
                            const label = sgisCodeMap.get(maxAreaStat.sgisCode);
                            sectionHtml += `<li><span class="label">핵심주거면적</span><span class="value">${label}</span></li>`;
                        }

                        // 2-4. 주요 건축 시기 찾기 및 표시
                        if (yearStats.length > 0) {
                            // 건축년도 통계 데이터 중 가장 큰 값을 가진 항목을 찾음
                            const maxYearStat = yearStats.reduce((max, item) =>
                                (parseInt(item.statsValue || 0) > parseInt(max.statsValue || 0)) ? item : max
                            );
                            const label = sgisCodeMap.get(maxYearStat.sgisCode);
                            sectionHtml += `<li><span class="label">주요 건축 시기</span><span class="value">${label}</span></li>`;
                        }

                        // ======================= ✨ 수정된 부분 끝 ✨ =======================
                    } else {
                        // 그 외 다른 모든 통계는 기존 방식대로 표시
                        for (const item of data) {
                            const label = sgisCodeMap.get(item.sgisCode) || '기타';
                            const value = `${parseInt(item[valueKey] || 0).toLocaleString()} ${unit}`;
                            sectionHtml += `<li><span class="label">${label}</span><span class="value">${value}</span></li>`;
                        }
                    }

                    sectionHtml += `</ul>`;
                    // 각 통계에 맞는 차트 컨테이너 추가
                    if (chartKey === 'pop') {
                        sectionHtml += `<div id="populationChartContainer" class="highchart-container" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;"></div>`;
                    } else if (chartKey === 'household') {
                        sectionHtml += `<div id="householdChartContainer" class="highchart-container" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;"></div>`;
                    } else if (chartKey === 'housing') {
                        sectionHtml += `<div id="housingChartContainer" class="highchart-container" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;"></div>`;
                    }
                    sectionHtml += `
</div>`;
                }
                return sectionHtml;
            };

            let resultsHtml = '';
            // 1. 사업체/종사자 통계 + AI 분석
            resultsHtml += createSection('사업체 통계', analysisData.bizStats, 'statsValue', '개', 'biz');
            resultsHtml += createSection('종사자 통계', analysisData.empStats, 'statsValue', '명', 'biz'); // 차트는 사업체와 공유
			// 마지막 인자에 고유 ID('ai-section-business') 추가
			resultsHtml += createAiAnalysisSection('사업체/종사자 AI 간편분석', 'AI가 사업체/종사자 데이터를 기반으로 상권 특징과 기회 요인을 요약합니다.', 'ai-business-result', 'ai-section-business').outerHTML;


            // 2. 인구 통계 + AI 분석
            resultsHtml += createSection('인구 통계', analysisData.populationStats, 'statsValue', '명', 'pop');
			// 마지막 인자에 고유 ID('ai-section-population') 추가
			resultsHtml += createAiAnalysisSection('인구 통계 AI 간편분석', 'AI가 인구 데이터를 기반으로 상권 특징과 기회 요인을 요약합니다.', 'ai-population-result', 'ai-section-population').outerHTML;

            // 3. 가구 통계 + AI 분석
            resultsHtml += createSection('가구 통계', analysisData.householdStats, 'statsValue', '가구', 'household');
			// 마지막 인자에 고유 ID('ai-section-household') 추가
			resultsHtml += createAiAnalysisSection('가구 통계 AI 간편분석', 'AI가 가구 데이터를 기반으로 상권 특징과 기회 요인을 요약합니다.', 'ai-household-result', 'ai-section-household').outerHTML;

            // 4. 주택 통계 + AI 분석
            resultsHtml += createSection('주택 통계', analysisData.housingStats, 'statsValue', '호', 'housing');
			// 마지막 인자에 고유 ID('ai-section-housing') 추가
			resultsHtml += createAiAnalysisSection('주택 통계 AI 간편분석', 'AI가 주택 데이터를 기반으로 상권 특징과 기회 요인을 요약합니다.', 'ai-housing-result', 'ai-section-housing').outerHTML;

            // 5. 신용카드 통계 (AI 분석 없음)
            console.log('신용카드 구 평균 매출 : ', result.AvgPay);
            console.log('신용카드 대전광역시 평균 매출 : ', result.totalAvgPayment);

            const cardStats = analysisData.creditCardStats;
            if (cardStats && Array.isArray(cardStats) && cardStats.length > 0) {
                const dongAvgWon = parseInt(cardStats[0].avgPaymentAmount || 0) * 1000;
                const guAvgWon = parseInt(result.AvgPay.AVG_PAYMENT || 0) * 1000;
                const totalAvgWon = parseInt(result.totalAvgPayment || 0) * 1000;


                resultsHtml += `<div id="section-credit-card" class="report-section">
			                        <h4 data-chart-key="card" style="cursor:pointer;">신용카드 소비 통계</h4>
			                        <ul class="summary-list">
			                            <li>
			                                <span class="label">${locationInfo.ADM_NAME} 평균 결제 금액</span>
			                                <span class="value">${dongAvgWon.toLocaleString('ko-KR')} 원</span>
			                            </li>
			                            <li>
			                                <span class="label">${locationInfo.DISTRICT_NAME} 평균 결제 금액</span>
			                                <span class="value">${guAvgWon.toLocaleString('ko-KR')} 원</span>
			                            </li>
			                            <li>
			                                <span class="label">대전광역시 평균 결제 금액</span>
			                                <span class="value">${totalAvgWon.toLocaleString('ko-KR')} 원</span>
			                            </li>
			                        </ul>
			                        <div id="creditCardChartContainer" class="highchart-container" style="margin-top: 20px; border-top: 1px solid #eee; padding-top: 15px;"></div>
			                    </div>`;
            }
			
            // 생성된 HTML 문자열을 리포트 컨테이너에 한 번에 삽입
            analysisResultsContainer.innerHTML = resultsHtml;
			
			// 정보 요약 섹션에 ID 부여 (올바른 선택자 사용)
	        const summarySection = document.querySelector('#report-sidebar .report-body > .report-section:first-child');
	        if (summarySection) {
	            summarySection.id = 'section-summary';
	        }

	        // 최종 AI 리포트 섹션에 ID 부여
	        const aiSection = document.querySelector('.report-section.ai-section');
	        if (aiSection) {
	            aiSection.id = 'section-ai-report';
	        }
			
            // AI 분석 UI가 이미 HTML에 포함되었으므로, 기존의 placeholder 생성 및 삽입 로직은 삭제합니다.
            // --- 6. 모든 AI 분석 동시 실행 ---
            fetchAllAiAnalyses(analysisData, sgisCodes);

            // --- 5. AI 분석 UI 틀(placeholder) 생성 및 삽입 ---
            const aiContainer = document.createElement('div');
            aiContainer.style.marginTop = '20px';
            aiContainer.style.borderTop = '2px solid #007bff';


            // --- 6. 모든 AI 분석 동시 실행 ---
            fetchAllAiAnalyses(analysisData, sgisCodes);

            // 차트 렌더링 함수 호출
            renderPopulationHighchart(analysisData.populationStats, sgisCodeMap);
            renderHouseholdHighchart(analysisData.householdStats, sgisCodeMap);
            renderHousingHighchart(analysisData.housingStats, sgisCodeMap);
            renderCreditCardHighchart(analysisData.creditCardStats, result.AvgPay, result.totalAvgPayment);

            // ✨ --- 4. V-World 차트 생성 및 지도에 표시 ---
            // 차트를 표시할 위치 계산
            let chartPosition;
            const selectedAdmCode = activeLocation.dataset.admCode;
            if (selectedAdmCode) {
                const vectorSource = hangjeongdongLayer.getSource();
                const targetFeature = vectorSource.getFeatures().find(f => f.get('ADM_CD') === selectedAdmCode);
                if (targetFeature) {
                    const extent = targetFeature.getGeometry().getExtent();
                    chartPosition = ol.extent.getCenter(extent);
                } else {
                    chartPosition = daejeonCityHall3857; // 못찾으면 기본 위치
                }
            } else {
                chartPosition = daejeonCityHall3857; // '대전 전체' 선택 시 기본 위치
            }


            // 데이터로 실제 차트 생성
            if (chartPosition) {
                const bizChartSize = [280, 180];
                const popChartSize = [320, 180];
                const householdChartSize = [380, 180];
                const housingChartSize = [420, 180];
                const cardChartSize = [300, 180];
                const gap = 10;
                const totalWidth = bizChartSize[0] + popChartSize[0] + householdChartSize[0] + housingChartSize[0] + cardChartSize[0] + (gap * 4);
                const startX = -totalWidth / 2;
                const bizOffset = [startX + bizChartSize[0] / 2, 0];
                const popOffset = [startX + bizChartSize[0] + gap + popChartSize[0] / 2, 0];
                const householdOffset = [startX + bizChartSize[0] + gap + popChartSize[0] + gap + householdChartSize[0] / 2, 0];
                const housingOffset = [startX + bizChartSize[0] + gap + popChartSize[0] + gap + householdChartSize[0] + gap + housingChartSize[0] / 2, 0];
                const cardOffset = [startX + bizChartSize[0] + gap + popChartSize[0] + gap + householdChartSize[0] + gap + housingChartSize[0] + gap + cardChartSize[0] / 2, 0];

                // ✨ 3. 차트를 생성하고, 반환된 객체를 Map에 저장
                chartObjects.set('biz', () => createTwoBarChart(analysisData.bizStats, analysisData.empStats, chartPosition, bizOffset, bizChartSize));
                chartObjects.set('pop', () => createPopulationChart(analysisData.populationStats, sgisCodeMap, chartPosition, popOffset, popChartSize));
                chartObjects.set('household', () => createHouseholdChart(analysisData.householdStats, sgisCodeMap, chartPosition, householdOffset, householdChartSize));
                chartObjects.set('housing', () => createHousingChart(analysisData.housingStats, sgisCodeMap, chartPosition, housingOffset, housingChartSize));
                chartObjects.set('card', () => createCreditCardChart(analysisData.creditCardStats, result.AvgPay, chartPosition, cardOffset, cardChartSize));

            }

            // 4. 리포트 제목에 클릭 이벤트 리스너 추가
            analysisResultsContainer.addEventListener('click', (e) => {
                const h4 = e.target.closest('h4[data-chart-key]');
                if (!h4) return;

                const chartKey = h4.dataset.chartKey;

                // 해당 차트가 이미 생성되었는지 확인
                let targetChart = chartObjects.get(chartKey);

                if (typeof targetChart === 'function') {
                    // 아직 생성되지 않은 경우: 생성하고 다시 Map에 저장
                    const chartInstance = targetChart(); // chart 생성
                    chartObjects.set(chartKey, chartInstance);
                    targetChart = chartInstance;
                }

                if (targetChart && targetChart.element_) {
                    const chartElement = targetChart.element_;
                    chartElement.classList.add('chart-highlight');
                    setTimeout(() => {
                        chartElement.classList.remove('chart-highlight');
                    }, 1000);

                }
            });

            //--- 차트 생성 로직 종료 ---

            // 리포트 사이드바 표시
            reportSidebar.classList.add('active');
            setTimeout(() => {
                vmap.updateSize();
            }, 450);

        } catch (error) {
            console.error('분석 요청 실패:', error);
            alert('데이터를 분석하는 중 오류가 발생했습니다.');
        }
    });
    // =========================================================================


    // ======================= "AI 분석 실행하기" 버튼 이벤트 리스너 =======================
    const getAiReportButton = document.getElementById('getAiReportButton');
    const aiResultOutput = document.getElementById('aiResultOutput');

    getAiReportButton.addEventListener('click', async () => {
        // 1. 캐시된 데이터가 있는지 확인
        if (!cachedAnalysisData || !cachedSgisCodes) {
            alert('먼저 [분석하기]를 실행하여 상권 데이터를 조회해주세요.');
            return;
        }

        // 2. 로딩 상태 표시
        getAiReportButton.disabled = true;
        getAiReportButton.textContent = 'AI가 분석 중입니다...';
        aiResultOutput.textContent = '잠시만 기다려주세요. AI가 데이터를 분석하고 있습니다... 🧠';

        try {
            // 3. 서버에 AI 분석 요청 (POST 방식)
            const response = await fetch(`${contextPath}/api/market/interpret`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    analysisResult: cachedAnalysisData,
                    sgisCodes: cachedSgisCodes
                })
            });

            if (!response.ok) {
                throw new Error(`AI 분석 서버 오류: ${response.status}`);
            }

            const interpretation = await response.json();

            // 4. 결과 포맷팅 및 화면 표시
            if (interpretation && interpretation.summary) {
				// 추천 전략 항목을 <li> 태그로 변환 (내용이 있는 항목만)
			    const recommendationItems = interpretation.recommendations
			        ?.filter(r => r && r.trim() !== '') // 비어있지 않은 추천만 필터링
			        .map(r => `<li>- ${r}</li>`)
			        .join('') || '<li>데이터 기반 추천 전략이 없습니다.</li>';

			    // table HTML 구조를 생성
			    const formatted = `
			    <table class="ai-result-table">
			        <tbody>
			            <tr>
			                <th>요약</th>
			                <td>${interpretation.summary || '요약 정보 없음'}</td>
			            </tr>
			            <tr>
			                <th>기회 요인</th>
			                <td>${interpretation.opportunities || '기회 요인 정보 없음'}</td>
			            </tr>
			            <tr>
			                <th>위기 요인</th>
			                <td>${interpretation.threats || '위기 요인 정보 없음'}</td>
			            </tr>
			            <tr>
			                <th>추천 전략</th>
			                <td>
			                    <ul style="margin: 0; padding-left: 20px;">
			                        ${recommendationItems}
			                    </ul>
			                </td>
			            </tr>
			        </tbody>
			    </table>
			    `;

			    // innerText 대신 innerHTML을 사용하여 HTML 태그를 렌더링
			    aiResultOutput.innerHTML = formatted;
            } else {
                aiResultOutput.innerText = 'AI 분석 결과를 생성하지 못했습니다. 다시 시도해주세요.';
            }

        } catch (error) {
            console.error('AI 분석 요청 실패:', error);
            aiResultOutput.innerText = 'AI 분석 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        } finally {
            // 5. 버튼 상태 원복
            getAiReportButton.disabled = false;
            getAiReportButton.textContent = 'AI 분석 다시 실행하기';
        }
    });
    // =======================================================================

    // 닫기 버튼 이벤트 리스너 (기존과 동일)
    closeReportButton.addEventListener('click', () => {
        reportSidebar.classList.remove('active');
        // ✨ 리포트 창을 닫을 때, 지도에 표시된 차트도 함께 제거
        clearAllCharts();

        // ✨ 지도가 원래 크기로 돌아가므로 크기 업데이트
        setTimeout(() => {
            vmap.updateSize();
        }, 450);
    });
	
    fetchInitialData();
    // 페이지가 완전히 로드된 직후에 실행
    window.addEventListener('load', () => {
        const loader = document.getElementById('mapLoader');
        if (!loader) return;

        // 1초 뒤에 페이드아웃 클래스 추가
        setTimeout(() => {
            loader.classList.add('fade-out');
        }, 1000);

        // opacity 트랜지션이 끝나면 display:none 으로 완전 제거
        loader.addEventListener('transitionend', () => {
            loader.style.display = 'none';
        }, { once: true });
    });
	
	// ======================= "PDF 출력하기" 버튼 이벤트 리스너 (✨ 최종 수정 버전) =======================
	document.getElementById('printPdfButton').addEventListener('click', async () => {
	    const printButton = document.getElementById('printPdfButton');
	    printButton.disabled = true;
	    printButton.textContent = '리포트 생성 중...';

	    const { jsPDF } = window.jspdf;
	    const pdf = new jsPDF('p', 'mm', 'a4');

	    const pageWidth = 210;
	    const pageHeight = 297;
	    const margin = 15;
	    const footerHeight = 12;
	    const usableHeight = pageHeight - margin * 2 - footerHeight;
	    const contentWidth = pageWidth - margin * 2;

	    const captureAndAddPage = async (elements, startPage) => { // ✨ [수정] totalPages 파라미터 삭제
	        const captureContainer = document.createElement('div');
	        captureContainer.style.position = 'absolute';
	        captureContainer.style.left = '-9999px';
	        captureContainer.style.top = '0';
	        captureContainer.style.width = `${document.getElementById('report-sidebar').offsetWidth}px`;
	        captureContainer.style.backgroundColor = 'white';
	        captureContainer.style.padding = '20px';
	        captureContainer.style.boxSizing = 'border-box';

	        elements.forEach(el => {
	            if (el) captureContainer.appendChild(el.cloneNode(true));
	        });
	        document.body.appendChild(captureContainer);
	        
	        await new Promise(resolve => setTimeout(resolve, 500));

	        const canvas = await html2canvas(captureContainer, {
	            useCORS: true,
	            scale: 2,
	            backgroundColor: '#ffffff'
	        });

	        document.body.removeChild(captureContainer);

	        const imgWidth = contentWidth;
	        const imgHeight = (canvas.height * imgWidth) / canvas.width;

	        let position = 0;
	        let pageNumber = startPage;

	        while (position < imgHeight) {
	            const pageCanvas = document.createElement("canvas");
	            const pageCtx = pageCanvas.getContext("2d");
	            pageCanvas.width = canvas.width;
	            const sliceHeight = Math.min((usableHeight * canvas.width) / imgWidth, canvas.height - position);
	            pageCanvas.height = sliceHeight;
	            pageCtx.drawImage(canvas, 0, position, canvas.width, sliceHeight, 0, 0, canvas.width, sliceHeight);
	            
	            const pageImgData = pageCanvas.toDataURL("image/png");
	            const pageImgHeight = (sliceHeight * imgWidth) / canvas.width;

	            if (pageNumber > 1) pdf.addPage();
	            pdf.addImage(pageImgData, "PNG", margin, margin, imgWidth, pageImgHeight);

	            // ✨ [수정] 1단계: 여기서는 현재 페이지만 표시합니다.
	            pdf.setFontSize(10);
	            pdf.setTextColor(150);
	            pdf.text(`${pageNumber}`, pageWidth / 2, pageHeight - 8, { align: "center" });

	            position += sliceHeight;
	            pageNumber++;
	        }
	        return pageNumber - 1;
	    };

	    try {
	        const pageGroups = [
	            ['#section-summary', '#section-사업체통계', '#section-종사자통계', '#ai-section-business'],
	            ['#section-인구통계', '#ai-section-population'],
	            ['#section-가구통계', '#ai-section-household'],
	            ['#section-주택통계', '#ai-section-housing'],
	            ['#section-credit-card'],
	            ['#section-ai-report']
	        ];

	        // ✨ [수정] 1단계: 예측 없이 페이지를 먼저 생성합니다.
	        let currentPage = 1;
	        for (let i = 0; i < pageGroups.length; i++) {
	            printButton.textContent = `페이지 생성 중... (${i + 1}/${pageGroups.length})`;
	            const selectors = pageGroups[i];
	            const elementsToCapture = selectors.map(selector => document.querySelector(selector)).filter(el => el);
	            if (elementsToCapture.length > 0) {
	                currentPage = await captureAndAddPage(elementsToCapture, currentPage) + 1;
	            }
	        }

	        // ✨ [추가] 2단계: 실제 생성된 페이지 수를 기반으로 전체 쪽번호를 완성합니다.
	        const totalPages = pdf.internal.getNumberOfPages();
	        for (let i = 1; i <= totalPages; i++) {
	            pdf.setPage(i); // 각 페이지로 이동
	            const textWidth = pdf.getStringUnitWidth(`${i}`) * pdf.getFontSize() / pdf.internal.scaleFactor;
	            // 중앙에 위치한 현재 페이지 번호 바로 오른쪽에 '/ 총페이지' 를 추가
	            pdf.text(
	                ` / ${totalPages}`,
	                (pageWidth / 2) + (textWidth / 2) + 1,
	                pageHeight - 8
	            );
	        }

	        printButton.textContent = '서버에 저장 중...';

	        const pdfBlob = pdf.output('blob');
	        const locationText = document.getElementById('modalLocation').textContent;
	        const bizText = document.getElementById('modalBiz').textContent;
	        const yearText = document.getElementById('modalYear').textContent;
	        const historyTitle = `${locationText} (${bizText}) ${yearText}년 간단분석 리포트`;

	        const formData = new FormData();
	        const safeHistoryTitle = historyTitle.replace(/[\\/:*?"<>|]/g, '');
	        formData.append('reportFile', pdfBlob, `${safeHistoryTitle}.pdf`);
	        formData.append('historyTitle', historyTitle);
	        formData.append('historyType', 'SIMPLE_PDF');

	        const response = await fetch(`${contextPath}/api/market/report`, {
	            method: 'POST',
	            body: formData
	        });

	        if (response.ok) {
	            alert('리포트가 마이페이지에 성공적으로 저장되었습니다.');
	        } else {
	            const errorText = await response.text();
	            throw new Error(`서버 저장 실패: ${errorText}`);
	        }

	    } catch (err) {
	        console.error("리포트 저장 중 오류:", err);
	        alert("리포트를 저장하는 중 오류가 발생했습니다.");
	    } finally {
	        printButton.disabled = false;
	        printButton.textContent = 'PDF 출력하기(마이페이지 저장)';
	    }
	});
});



