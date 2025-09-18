<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>맵트릭스 가맹점</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/csstyle.css">

    <style>
    .ol-info-window {
	    background-color: #fff; /* 배경색을 흰색으로 변경 */
	    color: #333; /* 글씨색을 진한 회색으로 변경 */
	    border-radius: 8px; /* 테두리를 둥글게 */
	    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 그림자 효과 추가 */
	    padding: 10px; /* 내부 여백 추가 */
	    font-size: 14px; /* 글씨 크기 약간 키우기 */
	    white-space: nowrap; /* 내용이 한 줄로 표시되도록 */
	}
    
      .store-locator-container {
      		max-height: 500px;
            display: flex;
            gap: 20px;
            flex-grow: 1;
            height: 100%;
        }

        .store-list-container {
            flex: 1;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
        }

        #map-container {
            flex: 2;
            border: 1px solid #ccc;
        }

        #store-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        #store-list li {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        #store-list li:hover {
            background-color: #f9f9f9;
        }

        #store-list li.active {
            background-color: #e0e0e0;
            font-weight: bold;
        }

        .total-count-message {
            padding: 15px;
            background-color: #e6e6fa;
            color: #001f3f;
            font-size: 1.2em;
            font-weight: bold;
            text-align: center;
            border-radius: 10px;
            margin-top: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .total-count-message span {
            color: #ff6347;
        }
    </style>
</head>
<body>

    <div class="container">
	    <c:set var="activeMenu" value="stamp"/>
	    <c:set var="activeSub" value="applyStoreList"/>
		<%@ include file="/WEB-INF/views/include/stSideBar.jsp" %>
        <main>

	        <div class="page-header">
	            <h2><span class="material-icons" style="font-size:28px;">storefront</span>맵트릭스 가맹점</h2>
	            <p class="help-text mb-0">맵트릭스와 함께하는 가맹점들 입니다.</p>
	        </div>
            <div class="store-locator-container">
                <div class="store-list-container">

                    <ul id="store-list">
                        </ul>
                </div>
                <div id="map-container">
                    </div>
            </div>
            <div class="total-count-message">
                <p>총 <span id="store-count">0</span>개의 가맹점이 맵트릭스와 함께합니다.</p>
            </div>
        </main>
    </div>
    <script type="text/javascript" src="https://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=C9665F19-0EDD-3D3A-9EE1-D48D1B2A5B0B"></script>

    <script>
        // 가맹점 데이터
        // Vworld API는 기본적으로 'EPSG:4326'(경위도) 좌표계를 사용합니다.
        // stores 배열은 더 이상 하드코딩하지 않습니다.
        let stores = [];
        let map;
        let markers = [];
        let infoWindows = [];
        
        // VWorld 스크립트 로드 완료 시 자동으로 호출되는 함수
        function initializeMapAndStoreList() {
            // 서버에서 가맹점 데이터를 먼저 가져옵니다.
            const params = new URLSearchParams({
	            lon: 127.38489655389,
	            lat: 36.360043590621,
	            applyStatus: '승인'
            });

            fetch(`/attraction/apply-list`)
                .then(response => response.json())
                .then(data => {
                    // 서버로부터 받은 데이터를 stores 변수에 할당합니다.
                    stores = data;
                    console.log("서버에서 받은 가맹점 데이터:", stores);

                    // 데이터가 성공적으로 로드된 후에 지도와 목록을 초기화합니다.
                    initMap();
                    createStoreList();
                    map.updateSize();
                })
                .catch(error => {
                    console.error('가맹점 데이터를 가져오는 데 실패했습니다:', error);
                });
        }
        
        // Vworld 지도를 초기화하는 함수
        function initMap() {
          	const daejeonCityHallLonLat = [127.38489655389, 36.360043590621];
            const daejeonCityHall3857 = window.ol.proj.transform(daejeonCityHallLonLat, 'EPSG:4326', 'EPSG:3857');

            window.vw.ol3.CameraPosition.center = daejeonCityHall3857;
            window.vw.ol3.CameraPosition.zoom = 12; // 초기 줌 레벨 설정
            window.vw.ol3.CameraPosition.tilt = 0;
            window.vw.ol3.CameraPosition.heading = 0;

            window.vw.ol3.MapOptions = {
              basemapType: window.vw.ol3.BasemapType.GRAPHIC,
              controlDensity: window.vw.ol3.DensityType.EMPTY,
              interactionDensity: window.vw.ol3.DensityType.BASIC,
              controlsAutoArrange: true,
              homePosition: window.vw.ol3.CameraPosition,
              initPosition: window.vw.ol3.CameraPosition,
            };

            map = new window.vw.ol3.Map("map-container", window.vw.ol3.MapOptions);
            
         // Map이 준비되면 바로 실행
            stores.forEach((store, index) => {
                const position = ol.proj.fromLonLat([store.lon, store.lat], 'EPSG:3857');

                const markerFeature = new ol.Feature({
                    geometry: new ol.geom.Point(position)
                });

                const markerStyle = new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 7,
                        fill: new ol.style.Fill({ color: 'red' }),
                        stroke: new ol.style.Stroke({ color: 'white', width: 2 })
                    })
                });

                markerFeature.setStyle(markerStyle);

                const markerSource = new ol.source.Vector({ features: [markerFeature] });
                const markerLayer = new ol.layer.Vector({ source: markerSource });

                map.addLayer(markerLayer);
                markers.push(markerFeature);

                const infoWindow = document.createElement('div');
                infoWindow.className = 'ol-info-window';
                infoWindow.innerHTML = `<div style="padding:5px;font-size:12px;">\${store.applyStoreName}</div>`;

                document.getElementById('map-container').appendChild(infoWindow);
                
                const overlay = new ol.Overlay({
                    element: infoWindow,
                    position: position,
                    positioning: 'bottom-center',
                    offset: [0, -10],
                    stopEvent: false
                });

                map.addOverlay(overlay);
                overlay.setPosition(undefined); // 초기 숨김
                infoWindows.push(overlay);

                map.on('click', function(evt) {
                    const feature = map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
                        return feature;
                    });
                    if (feature === markerFeature) {
                        infoWindows.forEach(iw => iw.setPosition(undefined));
                        overlay.setPosition(position);
                    }
                });
            });
        }

        // 가맹점 목록을 HTML로 생성
        function createStoreList() {
            const storeListEl = document.getElementById('store-list');
            storeListEl.innerHTML = '';

            stores.forEach((store, index) => {
                const listItem = document.createElement('li');
                listItem.textContent = store.applyStoreName;
                listItem.dataset.index = index;

                listItem.addEventListener('click', () => {
                    document.querySelectorAll('#store-list li').forEach(li => {
                        li.classList.remove('active');
                    });
                    listItem.classList.add('active');

                    infoWindows.forEach(iw => iw.setPosition(undefined));

                    const currentLocation3857 = window.ol.proj.transform([store.lon, store.lat], 'EPSG:4326', 'EPSG:3857');
                    map.getView().setCenter(currentLocation3857);

                    infoWindows.forEach(iw => iw.setPosition(undefined)); // 다른 정보창 숨기기
                    infoWindows[index].setPosition(currentLocation3857); // 통일된 좌표계로 위치 지정
                    console.log(infoWindows[index]);
                });
                storeListEl.appendChild(listItem);
            });

            document.getElementById('store-count').textContent = stores.length;
        }
        
        document.addEventListener('DOMContentLoaded', () => {
        	if (window.proj4) {
				window.proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");
			    window.ol.proj.setProj4(window.proj4);
			  }
        	
            if (typeof ol !== 'undefined') {
            	initializeMapAndStoreList();
            } else {
                console.error("OpenLayers (ol) 라이브러리가 정의되지 않았습니다. VWorld 스크립트 로드 실패.");
            }
        });
    </script>
</body>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</html>