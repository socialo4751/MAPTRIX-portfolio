<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- 크게 화면은 2개, 가맹신청과 지도위의 엔터테인먼트 서비스. -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관심 가게</title>
    <style>
        body {
    margin: 0;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f0f2f5;
}

.container {
    display: flex;
    height: 100vh; /* 뷰포트 높이 전체 사용 */
    overflow: hidden;
}

.left-section {
    width: 35%; /* 왼쪽 섹션 너비 */
    background-color: #fff;
    padding: 20px;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    overflow-y: auto; /* 내용이 넘칠 경우 스크롤 */
    position: relative; /* 상세 정보 오버레이를 위한 기준점 */
}

.right-section {
    width: 65%; /* 오른쪽 섹션 너비 */
    background-color: #e0e0e0;
}

/* 검색 및 필터 영역 */
.search-filter-area {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
}

#search-input {
    width: calc(100% - 20px);
    padding: 10px;
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

.filters {
    display: flex;
    gap: 10px;
    align-items: center;
}

#category-filter {
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 5px;
}

#favorite-toggle {
    margin-right: 5px;
}

/* 가게 리스트 */
.store-list {
    flex-grow: 1; /* 남은 공간을 채우도록 */
    overflow-y: auto;
}

.store-item {
    display: flex;
    align-items: center;
    padding: 15px 0;
    border-bottom: 1px solid #eee;
    cursor: pointer;
    transition: background-color 0.2s ease;
    position: relative;
}

.store-item:hover {
    background-color: #f9f9f9;
}

.store-img {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    object-fit: cover;
    margin-right: 15px;
}

.store-info {
    flex-grow: 1;
}

.store-info h3 {
    margin: 0 0 5px 0;
    font-size: 1.1em;
    color: #333;
}

.store-info .category, .store-info .address {
    font-size: 0.85em;
    color: #777;
    margin-bottom: 3px;
}

.store-info .rating {
    font-size: 0.9em;
    color: #f7a23c;
}

.favorite-btn {
    background: none;
    border: none;
    font-size: 1.5em;
    cursor: pointer;
    color: #ccc; /* 비활성 상태 */
    transition: color 0.2s ease;
    padding: 5px;
}

.favorite-btn.favorite {
    color: #ff6b6b; /* 활성 상태 (관심 가게) */
}

/* 가게 상세 정보 */
.store-detail {
    display: none; /* 초기에는 숨김 */
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: #fff;
    padding: 20px;
    box-sizing: border-box;
    overflow-y: auto;
    z-index: 10; /* 리스트 위에 표시 */
}

.store-detail.active {
    display: block;
}

.back-to-list-btn {
    background-color: #007bff;
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    margin-bottom: 20px;
    font-size: 0.9em;
}

.detail-img {
    width: 100%;
    max-height: 250px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 15px;
}

#detail-name {
    font-size: 1.8em;
    margin-bottom: 10px;
    color: #222;
}

.store-detail p {
    font-size: 1em;
    color: #555;
    margin-bottom: 8px;
}

.store-detail .large-fav-btn {
    font-size: 2em;
    margin-right: 10px;
}

.view-on-map-btn {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 15px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 0.9em;
    margin-top: 10px;
}

/* 카카오 지도 기본 스타일 */
#map {
    width: 100%;
    height: 100%;
}
    </style>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cd7fce736650d9ad005b3ff7bd12af63"></script>
</head>
<body>
    <div class="container">
        <div class="left-section">
            <div class="search-filter-area">
                <input type="text" id="search-input" placeholder="가게 이름, 카테고리 검색">
                <div class="filters">
                    <select id="category-filter">
                        <option value="all">모든 카테고리</option>
                        <option value="cafe">카페</option>
                        <option value="restaurant">음식점</option>
                        </select>
                    <label for="favorite-toggle">
                        <input type="checkbox" id="favorite-toggle"> 관심 가게만
                    </label>
                    <label for="myLoadStore-toggle">
                        <input type="checkbox" id="myLoadStore-toggle"> 내가 지나온 가게
                    </label>
                    <span id="route-toggle-area" style="display:none; margin-left:10px;">
                        <label for="route-toggle">
                            <input type="checkbox" id="route-toggle"> 동선 표시
                        </label>
                    </span>
                </div>
            </div>

            <div class="store-list" id="store-list">
                <div class="store-item" data-lat="36.3504" data-lng="127.3845" data-name="가게1" data-is-favorite="false" data-id="s1">
                    <img src="http://googleusercontent.com/image_collection/image_retrieval/9316516207996276628" alt="가게 이미지" class="store-img">
                    <div class="store-info">
                        <h3>가게1</h3>
                        <p class="category">카페</p>
                        <p class="address">대전 서구 둔산동 123-45</p>
                        <div class="rating">⭐️ 4.5 (120)</div>
                    </div>
                    <button class="favorite-btn">❤️</button>
                </div>
                <div class="store-item" data-lat="36.3550" data-lng="127.3900" data-name="가게2" data-is-favorite="true" data-id="s2">
                    <img src="http://googleusercontent.com/image_collection/image_retrieval/9316516207996276628" alt="가게 이미지" class="store-img">
                    <div class="store-info">
                        <h3>가게2</h3>
                        <p class="category">음식점</p>
                        <p class="address">대전 유성구 봉명동 678-90</p>
                        <div class="rating">⭐️ 4.8 (250)</div>
                    </div>
                    <button class="favorite-btn favorite">❤️</button>
                </div>
            </div>

            <div class="store-detail" id="store-detail">
                <button class="back-to-list-btn">← 목록으로</button>
                <img src="http://googleusercontent.com/image_collection/image_retrieval/9316516207996276628" alt="가게 상세 이미지" class="detail-img">
                <h2 id="detail-name">가게 상세 이름</h2>
                <p id="detail-category" class="category">카테고리</p>
                <p id="detail-address" class="address">주소</p>
                <p id="detail-phone">전화번호: 042-123-4567</p>
                <p id="detail-hours">영업시간: 매일 10:00 - 22:00</p>
                <p id="detail-description">이 가게는 맛있는 커피와 편안한 분위기를 제공합니다.</p>
                <button class="favorite-btn large-fav-btn">❤️ 관심 가게</button>
                <button class="view-on-map-btn">지도에서 보기</button>
            </div>

            <div class="popular-store-list" id="popular-store-list" style="margin-top:30px;">
                <h3 style="margin-bottom:10px;">🔥 인기가게 리스트</h3>
                <div class="store-item" data-id="s1" data-lat="36.3504" data-lng="127.3845" data-name="가게1" data-is-favorite="false">
                    <img src="https://via.placeholder.com/80" alt="가게1 이미지" class="store-img">
                    <div class="store-info">
                        <h3>가게1</h3>
                        <p class="category">카페</p>
                        <p class="address">대전 서구 둔산동 123-45</p>
                        <div class="rating">⭐️ 4.5 (120)</div>
                    </div>
                    <button class="favorite-btn " data-id="s1">❤️</button>
                </div>
                <div class="store-item" data-id="s1" data-lat="36.3504" data-lng="127.3845" data-name="가게1" data-is-favorite="false">
                    <img src="https://via.placeholder.com/80" alt="가게1 이미지" class="store-img">
                    <div class="store-info">
                        <h3>가게1</h3>
                        <p class="category">카페</p>
                        <p class="address">대전 서구 둔산동 123-45</p>
                        <div class="rating">⭐️ 4.5 (120)</div>
                    </div>
                    <button class="favorite-btn " data-id="s1">❤️</button>
                </div>
            </div>
        </div>

        <div class="right-section" id="map">
            </div>
    </div>

    <script >
    document.addEventListener('DOMContentLoaded', () => {
        const storeList = document.getElementById('store-list');
        const storeDetail = document.getElementById('store-detail');
        const backToListBtn = document.querySelector('.back-to-list-btn');
        const searchInput = document.getElementById('search-input');
        const categoryFilter = document.getElementById('category-filter');
        const favoriteToggle = document.getElementById('favorite-toggle');
        const myLoadStoreToggle = document.getElementById('myLoadStore-toggle');
        const routeToggleArea = document.getElementById('route-toggle-area');
        const routeToggle = document.getElementById('route-toggle');

        let map = null; // 지도 객체
        let markers = []; // 마커 배열
        let infowindow = null; // 인포윈도우 객체 (하나만 사용하여 재활용)

        // 더미 데이터 (실제로는 서버에서 데이터를 가져옵니다)
        const stores = [
            { id: 's1', name: '가게1', category: '카페', address: '대전 서구 둔산동 123-45', lat: 36.3504, lng: 127.3845, rating: 4.5, reviews: 120, isFavorite: false, isMyLoadStore:true, phone: '042-111-2222', hours: '매일 10:00 - 22:00', description: '맛있는 커피와 편안한 분위기를 제공합니다.' },
            { id: 's2', name: '가게2', category: '음식점', address: '대전 유성구 봉명동 678-90', lat: 36.3550, lng: 127.3900, rating: 4.8, reviews: 250, isFavorite: true, isMyLoadStore:true, phone: '042-333-4444', hours: '매일 11:00 - 21:00', description: '다양한 한식 메뉴를 맛볼 수 있습니다.' },
            { id: 's3', name: '빵집A', category: '카페', address: '대전 중구 선화동 10-20', lat: 36.3260, lng: 127.4200, rating: 4.2, reviews: 80, isFavorite: false, isMyLoadStore:true, phone: '042-555-6666', hours: '화-일 09:00 - 20:00', description: '갓 구운 빵과 신선한 음료가 있는 베이커리 카페.' },
            { id: 's4', name: '고기맛집B', category: '음식점', address: '대전 동구 가양동 300-10', lat: 36.3520, lng: 127.4350, rating: 4.7, reviews: 300, isFavorite: true, isMyLoadStore:false, phone: '042-777-8888', hours: '매일 17:00 - 23:00', description: '신선한 고기와 푸짐한 한 상차림.' },
            { id: 's5', name: '스터디카페C', category: '카페', address: '대전 서구 갈마동 50-60', lat: 36.3530, lng: 127.3750, rating: 4.0, reviews: 60, isFavorite: false, isMyLoadStore:false, phone: '042-999-0000', hours: '24시간', description: '집중하기 좋은 조용한 스터디 공간.' },
            // 더 많은 가게 데이터...
        ];

        // 지도 초기화 함수
        function initMap() {
            // 카카오 지도 API가 로드되었는지 확인
            if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
                console.error("카카오 지도 API가 로드되지 않았습니다. appkey를 확인해주세요.");
                return;
            }

            // 대전 시청 주변을 중심으로 설정 (예시)
            const initialLat = 36.3504;
            const initialLng = 127.3845;

            const mapContainer = document.getElementById('map'); // 지도를 표시할 div
            const mapOption = {
                center: new kakao.maps.LatLng(initialLat, initialLng), // 지도의 중심좌표
                level: 7 // 지도의 확대 레벨
            };

            map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성

            // 인포윈도우 초기화 (하나의 객체를 재활용)
            infowindow = new kakao.maps.InfoWindow({zIndex:1});

            updateMarkers(stores); // 초기 마커 표시
        }

        // 마커 업데이트 함수
        function updateMarkers(filteredStores) {
            // 기존 마커 제거
            markers.forEach(marker => marker.setMap(null));
            markers = [];

            filteredStores.forEach(store => {
                const position = new kakao.maps.LatLng(store.lat, store.lng);

                // 마커 이미지 커스터마이징 (선택 사항)
                let imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 기본 마커
                let imageSize = new kakao.maps.Size(24, 35);
                let imageOffset = new kakao.maps.Point(12, 35);

                if (store.isFavorite) {
                    // 관심 가게일 경우 별 모양 마커 사용
                    imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png';
                    imageSize = new kakao.maps.Size(30, 30); // 별 모양 마커 크기 조정
                    imageOffset = new kakao.maps.Point(15, 30); // 별 모양 마커 오프셋 조정
                }
                
                const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, {
                    offset: imageOffset // 마커 이미지의 좌표와 지도 중심좌표를 일치시키기 위한 오프셋
                });

                const marker = new kakao.maps.Marker({
                    map: map,
                    position: position,
                    title: store.name,
                    image: markerImage // 마커 이미지 설정
                });

                // 마커 클릭 시 인포윈도우 표시
                kakao.maps.event.addListener(marker, 'click', function() {
                    const iwContent = `<div style="padding:5px;font-size:12px;"><b>${store.name}</b><br>${store.category}<br>⭐ ${store.rating}<br><a href="#" onclick="displayStoreDetail('${store.id}'); return false;" style="color:blue">상세보기</a></div>`;
                    infowindow.setContent(iwContent);
                    infowindow.open(map, marker);

                    // 지도 중심을 클릭된 마커로 이동
                    map.setCenter(position);
                });
                markers.push(marker);
            });
        }

        // 가게 리스트 렌더링 함수
        function renderStoreList(filteredStores) {
            storeList.innerHTML = ''; // 기존 리스트 비우기
            filteredStores.forEach(store => {
                const storeItem = document.createElement('div');
                storeItem.classList.add('store-item');
                storeItem.dataset.id = store.id;
                storeItem.dataset.lat = store.lat;
                storeItem.dataset.lng = store.lng;
                storeItem.dataset.name = store.name;
                storeItem.dataset.isFavorite = store.isFavorite;

                storeItem.innerHTML = `
                    <img src="https://via.placeholder.com/80" alt="${store.name} 이미지" class="store-img">
                    <div class="store-info">
                        <h3>${store.name}</h3>
                        <p class="category">${store.category}</p>
                        <p class="address">${store.address}</p>
                        <div class="rating">⭐️ ${store.rating} (${store.reviews})</div>
                    </div>
                    <button class="favorite-btn ${store.isFavorite ? 'favorite' : ''}" data-id="${store.id}">❤️</button>
                `;
                storeList.appendChild(storeItem);
            });

            // 이벤트 리스너 재할당 (동적으로 생성되므로)
            addStoreItemListeners();
            addFavoriteButtonListeners();
        }

        // 가게 아이템 클릭 리스너
        function addStoreItemListeners() {
            document.querySelectorAll('.store-item').forEach(item => {
                item.addEventListener('click', (e) => {
                    // 즐겨찾기 버튼 클릭은 제외
                    if (!e.target.closest('.favorite-btn')) {
                        const storeId = item.dataset.id;
                        displayStoreDetail(storeId);
                    }
                });
            });
        }

        // 즐겨찾기 버튼 클릭 리스너
        function addFavoriteButtonListeners() {
            document.querySelectorAll('.favorite-btn').forEach(button => {
                button.addEventListener('click', (e) => {
                    e.stopPropagation(); // 부모 요소(store-item)의 클릭 이벤트 전파 방지
                    const storeId = button.dataset.id;
                    const store = stores.find(s => s.id === storeId);
                    if (store) {
                        store.isFavorite = !store.isFavorite; // 상태 토글
                        button.classList.toggle('favorite', store.isFavorite); // 클래스 토글
                        // 상세 페이지의 즐겨찾기 버튼도 업데이트
                        const detailFavBtn = document.querySelector('.store-detail .large-fav-btn');
                        if (detailFavBtn) {
                            detailFavBtn.classList.toggle('favorite', store.isFavorite);
                        }
                        // 필터링된 상태에서 다시 렌더링 (관심 가게만 보기 필터가 켜져있을 경우)
                        filterAndRenderStores();
                        updateMarkers(filterStores()); // 마커도 업데이트
                    }
                });
            });
        }

        // 상세 정보 표시 함수
        function displayStoreDetail(storeId) {
            const store = stores.find(s => s.id === storeId);
            if (store) {
                document.getElementById('detail-name').textContent = store.name;
                document.getElementById('detail-category').textContent = store.category;
                document.getElementById('detail-address').textContent = store.address;
                document.getElementById('detail-phone').textContent = `전화번호: ${store.phone}`;
                document.getElementById('detail-hours').textContent = `영업시간: ${store.hours}`;
                document.getElementById('detail-description').textContent = store.description;

                const detailFavBtn = document.querySelector('.store-detail .large-fav-btn');
                detailFavBtn.dataset.id = store.id; // 상세 페이지 버튼에도 id 설정
                detailFavBtn.classList.toggle('favorite', store.isFavorite); // 즐겨찾기 상태 반영

                document.querySelector('.store-detail .detail-img').src = `https://via.placeholder.com/300x200?text=${store.name.replace(/ /g, '+')}`;

                storeList.style.display = 'none'; // 리스트 숨김
                storeDetail.classList.add('active'); // 상세 정보 표시

                // 지도에서 해당 가게로 이동
                const moveLatLon = new kakao.maps.LatLng(store.lat, store.lng);
                map.setCenter(moveLatLon);
                map.setLevel(3); // 좀 더 확대해서 보여줌 (확대 레벨은 지도마다 다름)
            }
        }

        // 필터링 로직
        function filterStores() {
            const searchTerm = searchInput.value.toLowerCase();
            //const selectedCategory = categoryFilter.value;
            const showFavoritesOnly = favoriteToggle.checked;
            const showMyLoadStoreToggle = myLoadStoreToggle.checked;

            return stores.filter(store => {
                const matchesSearch = store.name.toLowerCase().includes(searchTerm) ||
                                    store.category.toLowerCase().includes(searchTerm);
                //const matchesCategory = selectedCategory === 'all' || store.category.toLowerCase() === selectedCategory;
                const matchesFavorite = !showFavoritesOnly || store.isFavorite;
                const matchesLoadStore = !showMyLoadStoreToggle || store.isMyLoadStore; // 내 동선 가게 필터링

                return matchesSearch && matchesLoadStore && matchesFavorite;
            });
        }

        // 필터 적용 후 리스트 및 마커 업데이트
        function filterAndRenderStores() {
            const filtered = filterStores();
            renderStoreList(filtered);
            updateMarkers(filtered);
        }

        // 이벤트 리스너
        searchInput.addEventListener('input', filterAndRenderStores);
        categoryFilter.addEventListener('change', filterAndRenderStores);
        favoriteToggle.addEventListener('change', filterAndRenderStores);
        myLoadStoreToggle.addEventListener('change', filterAndRenderStores);

        backToListBtn.addEventListener('click', () => {
            storeDetail.classList.remove('active'); // 상세 정보 숨김
            storeList.style.display = 'block'; // 리스트 표시
            filterAndRenderStores(); // 필터 적용된 리스트 다시 보여주기
            // 리스트로 돌아갈 때 지도를 다시 초기화하거나, 전체 마커를 보여줄 수 있습니다.
            // 여기서는 다시 필터된 가게들만 마커로 표시합니다.
        });

        // 지도에서 보기 버튼 클릭 시
        document.querySelector('.store-detail .view-on-map-btn').addEventListener('click', () => {
            const currentStoreId = document.querySelector('.store-detail .large-fav-btn').dataset.id;
            const currentStore = stores.find(s => s.id === currentStoreId);
            if (currentStore) {
                const moveLatLon = new kakao.maps.LatLng(currentStore.lat, currentStore.lng);
                map.setCenter(moveLatLon);
                map.setLevel(3); // 좀 더 확대해서 보여줌
            }
        });

        // 전역 함수로 등록 (인포윈도우에서 호출하기 위함)
        window.displayStoreDetail = displayStoreDetail;

        myLoadStoreToggle.addEventListener('change', () => {
            if (myLoadStoreToggle.checked) {
                routeToggleArea.style.display = 'inline-block';
            } else {
                routeToggleArea.style.display = 'none';
                routeToggle.checked = false;
                // 동선 표시 해제 시 동선 라인도 지도에서 제거 (추가 구현 필요)
            }
        });

        // 동선 표시 체크 시 동선 라인 표시 (예시)
        routeToggle.addEventListener('change', () => {
            if (routeToggle.checked) {
                // 동선 표시 함수 호출 (구현 필요)
                showRouteOnMap();
            } else {
                // 동선 숨김 함수 호출 (구현 필요)
                hideRouteOnMap();
            }
        });

        // 동선 표시 함수 예시 (실제 구현 필요)
        function showRouteOnMap() {
            // 내가 지나온 가게들의 좌표를 연결하여 지도에 polyline 등으로 표시
            // 예시: stores.filter(s => s.isMyLoadStore)로 좌표 배열 추출
        }

        function hideRouteOnMap() {
            // 지도에서 polyline 등 동선 라인 제거
        }

        // 초기 로드 시 지도 및 리스트 렌더링
        initMap();
        renderStoreList(stores); // 모든 가게를 일단 표시
    });
    </script>
</body>
</html>