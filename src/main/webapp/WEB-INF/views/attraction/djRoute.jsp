<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 동선 기록 서비스</title>
    <style>
        /* 기본 HTML 요소 초기화 */
        body, html {
            margin: 0;
            padding: 0;
            height: 100%; /* 뷰포트 전체 높이 사용 */
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            overflow: hidden; /* 전체 페이지 스크롤바가 필요 없도록 */
        }

        /* 메인 컨테이너 - 사이드바와 지도 영역을 포함 */
        .main-container {
            display: flex;
            width: 100%;
            height: 100%;
        }

        /* 왼쪽 사이드바 스타일 */
        .sidebar {
            flex: 0 0 35%; /* 너비 35% 고정 */
            background-color: #ffffff;
            padding: 20px;
            box-shadow: 2px 0 8px rgba(0,0,0,0.1);
            overflow-y: auto; /* 내용이 길어지면 스크롤 */
            box-sizing: border-box; /* 패딩이 너비에 포함되도록 */
            display: flex;
            flex-direction: column; /* 내부 요소들을 세로로 정렬 */
        }

        .sidebar h2 {
            color: #333;
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 1.5em;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .sidebar .button-group {
            margin-bottom: 20px; /* 버튼 그룹 아래 여백 */
        }

        .sidebar .button-group button {
            display: block; /* 버튼을 세로로 정렬 */
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 10px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.2s ease;
            box-sizing: border-box;
        }

        .sidebar .button-group button:hover {
            background-color: #0056b3;
        }

        /* 동선 유형 선택 버튼 그룹 스타일 (수정됨) */
        .log-type-buttons {
            display: flex; /* 내부 버튼들을 가로로 정렬 */
            justify-content: space-between; /* 버튼들 사이에 균등한 공간 배분 */
            gap: 10px; /* 버튼들 사이의 간격 */
            margin-bottom: 20px; /* 아래쪽 여백 */
            padding-top: 10px;
            border-top: 1px dashed #eee; /* 구분선 */
            /* JavaScript로 display를 'none'/'flex' 토글 */
        }

        .log-type-buttons button {
            flex: 1; /* 3등분하여 공간을 균등하게 차지 */
            padding: 10px 5px; /* 패딩 조정 */
            margin: 0; /* flex 컨테이너에서 gap으로 간격 처리하므로 margin 0 */
            background-color: #6c757d; /* 회색 계열 */
            font-size: 0.9em; /* 폰트 사이즈 조정 */
        }

        .log-type-buttons button:hover {
            background-color: #5a6268;
        }

        .sidebar .log-list {
            /* margin-top: 30px; // 이전 위치의 margin-top */
            flex-grow: 1; /* 남은 공간을 차지하도록 */
        }

        .sidebar .log-list h3 {
            color: #555;
            margin-bottom: 15px;
            font-size: 1.2em;
            border-bottom: 1px dashed #eee;
            padding-bottom: 8px;
        }

        .sidebar .log-list ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar .log-list li {
            padding: 10px 0;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background-color 0.2s ease;
            color: #444;
        }

        .sidebar .log-list li:hover {
            background-color: #f8f8f8;
        }

        .sidebar .log-list li:last-child {
            border-bottom: none; /* 마지막 항목은 선 없음 */
        }

        /* 오른쪽 지도 영역 스타일 */
        .map-area {
            flex: 1; /* 남은 공간 모두 차지 (약 65%) */
            position: relative;
            background-color: #e0e0e0; /* 지도 로드 전 배경색 */
        }

        #vmap {
            width: 100%;
            height: 100%; /* 부모 .map-area의 높이를 꽉 채우도록 */
        }
    </style>

    <script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=C9665F19-0EDD-3D3A-9EE1-D48D1B2A5B0B&domain=http://192.168.145.40:5500"></script>
</head>
<body>
    <div class="main-container">
        <div class="sidebar">
            <h2>내 동선 관리</h2>
            <div class="button-group">
                <!-- <button id="startLogBtn">내 동선 로그 기록 시작</button>
                <button id="stopLogBtn">로그 기록 중지</button> -->
                
                <button id="viewMyLogBtn">내 동선 로그 조회</button>
            </div>

            <div id="logTypeButtons" class="log-type-buttons" style="display: none;">
                <button id="unvisitedAreaBtn">가지 않은 상권/길</button>
                <button id="frequentAreaBtn">자주 가는 상권/길</button>
                <button id="recentLogBtn">최근 동선</button>
            </div>

            <div class="log-list">
                <h3>내 동선 기록</h3>
                <ul id="myLogList">
                    <li>2024-07-10 10:00 - 10:30 (예시)</li>
                    <li>2024-07-09 14:00 - 14:45 (예시)</li>
                </ul>
            </div>
        </div>

        <div class="map-area">
            <div id="vmap"></div>
        </div>
    </div>

    <script type="text/javascript">
        // 사용자님이 제공해주신 브이월드 지도 초기화 관련 JavaScript 코드를 그대로 유지합니다.
        const daejeonCityHallLonLat = [127.38489655389, 36.360043590621]; // 경도, 위도
        const daejeonCityHall3857 = ol.proj.transform(daejeonCityHallLonLat, 'EPSG:4326', 'EPSG:3857');

        vw.ol3.CameraPosition.center = daejeonCityHall3857;
        vw.ol3.CameraPosition.zoom = 14; 
        vw.ol3.CameraPosition.tilt = 0;
        vw.ol3.CameraPosition.heading = 0;

        vw.ol3.MapOptions = {
            basemapType: vw.ol3.BasemapType.GRAPHIC,
            controlDensity: vw.ol3.DensityType.EMPTY,
            interactionDensity: vw.ol3.DensityType.BASIC,
            controlsAutoArrange: true,
            homePosition: vw.ol3.CameraPosition,
            initPosition: vw.ol3.CameraPosition
        };

        var vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);

        // --- 여기에 동선 기록 및 조회 관련 JavaScript 함수 및 이벤트 리스너를 추가합니다. ---
        let locationLog = []; 
        let recordingInterval; 
        let currentPathLayer = null; 
        
        // 버튼 요소들을 가져옵니다.
        const startLogBtn = document.getElementById('startLogBtn');
        const stopLogBtn = document.getElementById('stopLogBtn');
        const viewMyLogBtn = document.getElementById('viewMyLogBtn');
        const logTypeButtonsDiv = document.getElementById('logTypeButtons'); // 하위 버튼 컨테이너
        const unvisitedAreaBtn = document.getElementById('unvisitedAreaBtn');
        const frequentAreaBtn = document.getElementById('frequentAreaBtn');
        const recentLogBtn = document.getElementById('recentLogBtn');
        const myLogList = document.getElementById('myLogList');

        // '내 동선 로그 기록 시작' 버튼 클릭 이벤트
        if (startLogBtn) {
            startLogBtn.addEventListener('click', () => {
                if (navigator.geolocation) {
                    locationLog = []; 
                    console.log('동선 기록 시작...');
                    recordingInterval = setInterval(() => {
                        navigator.geolocation.getCurrentPosition((position) => {
                            const { latitude, longitude } = position.coords;
                            const timestamp = new Date().toLocaleString();
                            locationLog.push({ timestamp, latitude, longitude });
                            console.log(`위치 기록: [${longitude}, ${latitude}] at ${timestamp}`);
                        }, (error) => {
                            console.error('위치 정보를 가져올 수 없습니다:', error.message);
                            clearInterval(recordingInterval);
                            recordingInterval = null;
                            alert('위치 정보를 가져오는 데 실패하여 기록을 중지합니다.');
                        });
                    }, 3000); 
                    alert('내 동선 기록을 시작합니다!');
                } else {
                    alert('이 브라우저는 위치 정보 기록을 지원하지 않습니다.');
                }
            });
        }

        // '로그 기록 중지' 버튼 클릭 이벤트
        if (stopLogBtn) {
            stopLogBtn.addEventListener('click', () => {
                if (recordingInterval) {
                    clearInterval(recordingInterval);
                    recordingInterval = null;
                    console.log('동선 기록 중지.');
                    alert(`내 동선 기록을 중지했습니다. 총 ${locationLog.length}개 지점이 기록되었습니다.`);
                    
                    if (locationLog.length > 0) {
                        const firstEntryTime = new Date(locationLog[0].timestamp);
                        const lastEntryTime = new Date(locationLog[locationLog.length - 1].timestamp);
                        const logEntryText = `${firstEntryTime.toLocaleDateString()} ${firstEntryTime.toLocaleTimeString()} - ${lastEntryTime.toLocaleTimeString()}`;

                        const logEntry = document.createElement('li');
                        logEntry.textContent = logEntryText;
                        logEntry.dataset.logData = JSON.stringify(locationLog); 
                        logEntry.addEventListener('click', () => displayLogOnMap(JSON.parse(logEntry.dataset.logData)));
                        myLogList.appendChild(logEntry);
                    }
                    locationLog = []; 
                } else {
                    alert('현재 기록 중인 동선이 없습니다.');
                }
            });
        }

        // '내 동선 로그 조회' 버튼 클릭 이벤트 (하위 버튼 토글)
        if (viewMyLogBtn && logTypeButtonsDiv) {
            viewMyLogBtn.addEventListener('click', () => {
                if (logTypeButtonsDiv.style.display === 'none') {
                    logTypeButtonsDiv.style.display = 'flex'; // 'flex'로 변경하여 3분할 가로 정렬
                    alert('조회할 동선 유형을 선택해주세요.');
                } else {
                    logTypeButtonsDiv.style.display = 'none'; 
                }
            });
        }

        // 새로 추가된 동선 유형 버튼들 이벤트 리스너
        if (unvisitedAreaBtn) {
            unvisitedAreaBtn.addEventListener('click', () => {
                alert('내가 가지 않은 상권영역/길을 조회합니다.');
            });
        }
        if (frequentAreaBtn) {
            frequentAreaBtn.addEventListener('click', () => {
                alert('내가 자주 가는 상권영역/길을 조회합니다.');
            });
        }
        if (recentLogBtn) {
            recentLogBtn.addEventListener('click', () => {
                alert('최근 동선을 조회합니다.');
            });
        }

        // 지도에 동선 표시 함수 (이전과 동일)
        function displayLogOnMap(logData) {
            if (!vmap) {
                console.error("지도가 초기화되지 않았습니다. vmap 객체를 찾을 수 없습니다.");
                alert('지도가 아직 로드되지 않았습니다. 잠시 후 다시 시도해주세요.');
                return;
            }

            if (currentPathLayer) {
                vmap.removeLayer(currentPathLayer);
                currentPathLayer = null;
            }

            if (logData && logData.length > 1) {
                const pathCoords = logData.map(point => 
                    ol.proj.transform([point.longitude, point.latitude], 'EPSG:4326', 'EPSG:3857')
                );

                const lineString = new ol.geom.LineString(pathCoords);
                const feature = new ol.Feature({
                    geometry: lineString
                });

                const style = new ol.style.Style({
                    stroke: new ol.style.Stroke({
                        color: 'rgba(255, 0, 0, 0.7)', // 빨간색 선
                        width: 4
                    })
                });
                feature.setStyle(style);

                const vectorSource = new ol.source.Vector({
                    features: [feature]
                });
                const vectorLayer = new ol.layer.Vector({
                    source: vectorSource
                });

                vmap.addLayer(vectorLayer);
                currentPathLayer = vectorLayer; 

                const extent = vectorSource.getExtent();
                if (extent[0] !== Infinity) { 
                    vmap.getView().fit(extent, {
                        size: vmap.getSize(),
                        padding: [50, 50, 50, 50], 
                        duration: 1000 
                    });
                } else {
                    console.warn("유효한 extent를 계산할 수 없어 지도를 맞출 수 없습니다.");
                }
                
                console.log('지도에 동선이 표시되었습니다.', logData);
            } else {
                alert('표시할 동선 데이터가 충분하지 않습니다 (최소 2개 지점 필요).');
                console.warn('동선 데이터가 부족합니다:', logData);
            }
        }
    </script>
</body>
</html>