document.addEventListener('DOMContentLoaded', () => {
    proj4.defs("EPSG:5179", "+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

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

    const vmap = new vw.ol3.Map("vmap", vw.ol3.MapOptions);
    const spinner = document.getElementById('loadingSpinner');

    const layers = {};
    const features = {};

    const franchiseColorMap = {
        '스타벅스': '#1e3932',
        '빽다방': '#ffcc00',
        '도미노피자': '#007bff',
        '서브웨이': '#00a651',
        '맥도날드': '#dc3545',
    };

    const updateAndShowSidebar = (name) => {
        const currentFeatures = features[name];
        if (!currentFeatures || currentFeatures.length === 0) {
            resultsList.innerHTML = '<li>데이터를 불러오는 중입니다...</li>';
            return;
        }

        spinner.style.display = 'none';

        const stores = currentFeatures.map(f => ({
            name: f.get('매장명'),
            address: f.get('주소'),
            phone: f.get('전화번호'),
            brand: f.get('brand'),
            coordinate: f.getGeometry().clone().getCoordinates()
        }));

        subSidebarTitle.textContent = `${name} 검색 결과 (${stores.length}개)`;
        resultsList.innerHTML = '';

        stores.forEach((store, idx) => {
            const li = document.createElement('li');
            li.innerHTML = `
                <div class="store-name">${store.name}</div>
                <div class="store-address">${store.address}</div>
                <div class="store-phone">${store.phone}</div>
            `;
            li.dataset.index = idx;
            li.style.cursor = 'pointer';
            resultsList.appendChild(li);

            li.addEventListener('click', () => {
                const coordinate = store.coordinate;
                console.log("\uD83D\uDCCD 클릭한 매장 좌표:", coordinate);

                vmap.getView().setCenter(coordinate);
                vmap.getView().setZoom(17);

                const html = `
                    <div class="popup-content-box">
                        <div class="popup-title">${store.brand} - ${store.name}</div>
                        <div class="popup-row"><span class="popup-label">주소:</span><span class="popup-value">${store.address}</span></div>
                        <div class="popup-row"><span class="popup-label">전화:</span><span class="popup-value">${store.phone}</span></div>
                    </div>`;
                popupContent.innerHTML = html;
                overlay.setPosition(coordinate);
            });
            // 원클릭 시 내부적으로 한 번 더 클릭(= 총 두 번) 되도록 복제
            li.addEventListener('click', (e) => {
                // 사용자 실제 클릭일 때만 복제 (프로그램이 쏜 클릭은 무시)
                if (!e.isTrusted) return;

                // 너무 붙어서 실행되면 동일 프레임으로 취급될 수 있어 살짝 지연
                setTimeout(() => {
                    li.dispatchEvent(
                        new MouseEvent('click', {
                            bubbles: true,
                            cancelable: true,
                            // detail을 2로 줘서 "연속 클릭" 느낌을 강화 (선택)
                            detail: (e.detail || 1) + 1
                        })
                    );
                }, 60); // 40~120ms 안에서 환경에 맞게 조절 가능
            });

        });

        subSidebar.classList.add('visible');
    };

    const makeLayer = (name, url, color) => {
        const layer = new ol.layer.Vector({
            source: new ol.source.Vector({
                url: url,
                format: new ol.format.GeoJSON({
                    dataProjection: 'EPSG:4326',
                    featureProjection: 'EPSG:3857'
                })
            }),
            visible: false,
            style: new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 10,
                    fill: new ol.style.Fill({color: color}),
                    stroke: new ol.style.Stroke({color: '#fff', width: 2})
                })
            })
        });

        vmap.addLayer(layer);

        layer.getSource().on('change', () => {
            if (layer.getSource().getState() === 'ready') {
                features[name] = layer.getSource().getFeatures();
                console.log(`✅ ${name} 매장 로드 완료 (${features[name].length}개)`);

                if (layer.getVisible()) {
                    updateAndShowSidebar(name);
                }
            }
        });

        layers[name] = layer;
    };

    makeLayer('스타벅스', '/data/starbucks.geojson', franchiseColorMap['스타벅스']);
    makeLayer('빽다방', '/data/paikdabang.geojson', franchiseColorMap['빽다방']);
    makeLayer('도미노피자', '/data/dominopizza.geojson', franchiseColorMap['도미노피자']);
    makeLayer('서브웨이', '/data/subway.geojson', franchiseColorMap['서브웨이']);
    makeLayer('맥도날드', '/data/mcdonald.geojson', franchiseColorMap['맥도날드']);

    const popupElement = document.getElementById('popup');
    const popupContent = document.getElementById('popup-content');
    const overlay = new ol.Overlay({
        element: popupElement,
        autoPan: true,
        autoPanAnimation: {duration: 250}
    });
    vmap.addOverlay(overlay);

    vmap.on('singleclick', function (evt) {
        vmap.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
            const name = feature.get('매장명');
            const address = feature.get('주소');
            const phone = feature.get('전화번호');
            const brand = feature.get('brand');

            if (!name || !address) return;

            const html = `
            <div class="popup-content-box">
                <div class="popup-title">${brand} - ${name}</div>
                <div class="popup-row"><span class="popup-label">주소:</span><span class="popup-value">${address}</span></div>
                <div class="popup-row"><span class="popup-label">전화:</span><span class="popup-value">${phone}</span></div>
            </div>`;

            popupContent.innerHTML = html;
            overlay.setPosition(evt.coordinate);
            return true;
        });
    });

    const franchiseButtons = document.querySelectorAll('.franchise-btn');
    const subSidebar = document.getElementById('subSidebar');
    const subSidebarTitle = document.getElementById('subSidebarTitle');
    const resultsList = document.getElementById('resultsList');

    franchiseButtons.forEach(button => {
        button.addEventListener('click', () => {
            const franchiseName = button.getAttribute('data-franchise');
            const isActive = button.classList.toggle('active');
            const brandColor = franchiseColorMap[franchiseName];

            layers[franchiseName].setVisible(isActive);

            if (isActive) {
                button.style.backgroundColor = brandColor;
                button.style.color = '#fff';
                spinner.style.display = 'block';
                updateAndShowSidebar(franchiseName);
            } else {
                button.style.backgroundColor = '';
                button.style.color = '';
                subSidebar.classList.remove('visible');
            }
        });
    });

    const closeSubSidebarBtn = document.getElementById('closeSubSidebar');
    closeSubSidebarBtn.addEventListener('click', () => {
        subSidebar.classList.remove('visible');
    });
    // 지도 위 오른쪽 상단 버튼들
    const homeBtn = document.getElementById('homeBtn');
    const logoutBtn = document.getElementById('logoutBtn');
    const myBtn = document.getElementById('myBtn');
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
            if (logoutForm) {
                logoutForm.submit();
            }
        });
    }
    if (myBtn) {
        myBtn.addEventListener('click', () => {
            window.location.href = `${contextPath}/my/report`; // 마이페이지 - 리포트 주소로 이동
        });
    }
});