<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>축제/관광 정보</title>
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
        flex-wrap: wrap; /* 작은 화면에서 요소들이 줄바꿈되도록 */
    }

    #category-filter, #date-filter {
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* 축제/관광 리스트 */
    .event-list {
        flex-grow: 1; /* 남은 공간을 채우도록 */
        overflow-y: auto;
    }

    .event-item {
        display: flex;
        align-items: center;
        padding: 15px 0;
        border-bottom: 1px solid #eee;
        cursor: pointer;
        transition: background-color 0.2s ease;
        position: relative;
    }

    .event-item:hover {
        background-color: #f9f9f9;
    }

    .event-img {
        width: 80px;
        height: 80px;
        border-radius: 8px;
        object-fit: cover;
        margin-right: 15px;
    }

    .event-info {
        flex-grow: 1;
    }

    .event-info h3 {
        margin: 0 0 5px 0;
        font-size: 1.1em;
        color: #333;
    }

    .event-info .type, .event-info .location, .event-info .date, .event-info .hours {
        font-size: 0.85em;
        color: #777;
        margin-bottom: 3px;
    }

    /* 축제/관광 상세 정보 */
    .event-detail {
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

    .event-detail.active {
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

    .event-detail p {
        font-size: 1em;
        color: #555;
        margin-bottom: 8px;
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
                <input type="text" id="search-input" placeholder="축제/관광 이름 검색">
                <div class="filters">
                    <select id="category-filter">
                        <option value="all">모든 분류</option>
                        <option value="festival">축제</option>
                        <option value="attraction">관광지</option>
                        </select>
                    <label for="date-filter">
                        <input type="date" id="date-filter"> 날짜 선택
                    </label>
                </div>
            </div>

            <div class="event-list" id="event-list">
                <div class="event-item" data-lat="36.3504" data-lng="127.3845" data-name="대전 국제 와인 페스티벌" data-type="festival" data-id="e1">
                    <img src="http://googleusercontent.com/image_collection/image_retrieval/17707946762127317020" alt="축제 이미지" class="event-img">
                    <div class="event-info">
                        <h3>대전 국제 와인 페스티벌</h3>
                        <p class="type">축제</p>
                        <p class="location">대전 컨벤션센터</p>
                        <p class="date">2025.09.01 - 2025.09.07</p>
                    </div>
                </div>
                <div class="event-item" data-lat="36.3550" data-lng="127.3900" data-name="엑스포 과학공원" data-type="attraction" data-id="e2">
                    <img src="http://googleusercontent.com/image_collection/image_retrieval/17707946762127317020" alt="관광지 이미지" class="event-img">
                    <div class="event-info">
                        <h3>엑스포 과학공원</h3>
                        <p class="type">관광지</p>
                        <p class="location">대전 유성구 대덕대로</p>
                        <p class="hours">매일 09:30 - 17:30</p>
                    </div>
                </div>
                </div>

            <div class="event-detail" id="event-detail">
                <button class="back-to-list-btn">← 목록으로</button>
                <img src="https://m.haeahn.com/upload/prjctmain/20221114112539966126.jpg" alt="축제/관광 상세 이미지" class="detail-img">
                <h2 id="detail-name">축제/관광 상세 이름</h2>
                <p id="detail-type" class="type">분류</p>
                <p id="detail-location" class="location">장소: 대전시 어딘가</p>
                <p id="detail-date" class="date">기간: 2025.07.01 - 2025.07.31</p>
                <p id="detail-phone">문의: 042-123-4567</p>
                <p id="detail-description">이곳은 대전의 멋진 축제/관광지입니다.</p>
                <button class="view-on-map-btn">지도에서 보기</button>
                </div>
        </div>

        <div class="right-section" id="map">
            </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
        const eventListDiv = document.getElementById('event-list');
        const eventDetailDiv = document.getElementById('event-detail');
        const backToListBtn = document.querySelector('.back-to-list-btn');
        const searchInput = document.getElementById('search-input');
        const categoryFilter = document.getElementById('category-filter');
        const dateFilter = document.getElementById('date-filter');

        let map = null; // 지도 객체
        let markers = []; // 마커 배열
        let infowindow = null; // 인포윈도우 객체 (하나만 사용하여 재활용)

        // 축제/관광 데이터를 저장할 배열 (API 호출 결과로 채워짐)
        let events = [];

        // 지도 초기화 함수
        function initMap() {
            if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
                console.error("카카오 지도 API가 로드되지 않았습니다. appkey를 확인해주세요.");
                return;
            }

            const initialLat = 36.3504; // 대전 시청 주변 중심 (예시)
            const initialLng = 127.3845;

            const mapContainer = document.getElementById('map');
            const mapOption = {
                center: new kakao.maps.LatLng(initialLat, initialLng),
                level: 7
            };

            map = new kakao.maps.Map(mapContainer, mapOption);
            infowindow = new kakao.maps.InfoWindow({zIndex:1});

            // 데이터 로드 및 초기 렌더링
            loadFestivalData();
        }

        // 축제/관광 데이터 로드 함수 (API 호출 예시)
        async function loadFestivalData() {
            // 실제 API 호출 시에는 여기에 fetch 또는 axios 등을 사용합니다.
            // 예시: const response = await fetch('YOUR_FESTIVAL_API_ENDPOINT');
            //       events = await response.json();

            // 현재는 더미 데이터 사용
            events = [
                { id: 'e1', name: '대전 국제 와인 페스티벌', type: 'festival', location: '대전 컨벤션센터', lat: 36.3731, lng: 127.3879, startDate: '2025-09-01', endDate: '2025-09-07', phone: '042-111-2222', description: '다양한 와인과 문화 행사를 즐길 수 있는 국제 축제입니다.',imgUrl: 'https://m.haeahn.com/upload/prjctmain/20221114112539966126.jpg'},
                { id: 'e2', name: '엑스포 과학공원', type: 'attraction', location: '대전 유성구 대덕대로', lat: 36.3750, lng: 127.3887, startDate: '상시', endDate: '상시', phone: '042-333-4444', description: '과학과 교육을 테마로 한 공원으로, 다양한 전시물과 체험 시설이 있습니다.',imgUrl: 'https://m.haeahn.com/upload/prjctmain/20221114112539966126.jpg'},
                { id: 'e3', name: '장태산 자연휴양림', type: 'attraction', location: '대전 서구 장안동', lat: 36.2230, lng: 127.3340, startDate: '상시', endDate: '상시', phone: '042-555-6666', description: '메타세콰이어 숲으로 유명한 아름다운 휴양림입니다. 스카이워크가 인기입니다.',imgUrl: 'https://m.haeahn.com/upload/prjctmain/20221114112539966126.jpg'},
                { id: 'e4', name: '유성 온천문화 축제', type: 'festival', location: '유성구 온천로 일대', lat: 36.3562, lng: 127.3448, startDate: '2025-05-10', endDate: '2025-05-12', phone: '042-777-8888', description: '따뜻한 온천수와 함께 다채로운 문화 공연을 즐길 수 있는 축제입니다.',imgUrl: 'https://thefestival.co.kr/upfile/img/2025/04/opensunday_1745857174.jpg'},
                { id: 'e5', name: '대청호 오백리길', type: 'attraction', location: '대전 대덕구 대청호반길', lat: 36.4380, lng: 127.4880, startDate: '상시', endDate: '상시', phone: '042-999-0000', description: '대청호를 따라 걷는 아름다운 산책길로, 자연을 만끽하기 좋습니다.',imgUrl: 'https://m.haeahn.com/upload/prjctmain/20221114112539966126.jpg'},
            ];
            
            filterAndRenderEvents(); // 데이터 로드 후 필터링 및 렌더링
        }

        // 마커 업데이트 함수
        function updateMarkers(filteredEvents) {
            markers.forEach(marker => marker.setMap(null));
            markers = [];

            filteredEvents.forEach(event => {
                const position = new kakao.maps.LatLng(event.lat, event.lng);

                // 마커 이미지 커스터마이징
                // 일반 축제/관광 마커 (예시: 파란색 핀)
                let imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 일반 마커 이미지
                let imageSize = new kakao.maps.Size(32, 32); 
                let imageOffset = new kakao.maps.Point(16, 32);

                // 축제인 경우 (예: 빨간색 핀 또는 다른 아이콘)
                if (event.type === 'festival') {
                    imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 축제 마커 이미지 (빨간색)
                    imageSize = new kakao.maps.Size(32, 32);
                    imageOffset = new kakao.maps.Point(16, 32);
                }
                // 관광지인 경우 (예: 파란색 핀)
                // else if (event.type === 'attraction') { ... }

                const markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, {
                    offset: imageOffset
                });

                const marker = new kakao.maps.Marker({
                    map: map,
                    position: position,
                    title: event.name,
                    image: markerImage
                });

                // 마커 클릭 시 인포윈도우 표시
                kakao.maps.event.addListener(marker, 'click', function() {
                    const iwContent = `<div style="padding:5px;font-size:12px;"><b>${event.name}</b><br>${event.type}<br>${event.location}<br><a href="#" onclick="displayEventDetail('${event.id}'); return false;" style="color:blue">상세보기</a></div>`;
                    infowindow.setContent(iwContent);
                    infowindow.open(map, marker);
                    map.setCenter(position);
                });
                markers.push(marker);
            });
        }

        // 축제/관광 리스트 렌더링 함수
        function renderEventList(filteredEvents) {
            eventListDiv.innerHTML = '';
            filteredEvents.forEach(event => {
                const eventItem = document.createElement('div');
                eventItem.classList.add('event-item');
                eventItem.dataset.id = event.id;
                eventItem.dataset.lat = event.lat;
                eventItem.dataset.lng = event.lng;
                eventItem.dataset.name = event.name;

                // 이미지는 공통 이미지 사용
                eventItem.innerHTML = `
                    <img src="${event.imgUrl}" alt="${event.name} 이미지" class="event-img">
                    <div class="event-info">
                        <h3>${event.name}</h3>
                        <p class="type">${event.type === 'festival' ? '축제' : '관광지'}</p>
                        <p class="location">${event.location}</p>
                        <p class="date">${event.type === 'festival' ? `기간: ${event.startDate} - ${event.endDate}` : `운영: ${event.startDate}`}</p>
                    </div>
                `;
                eventListDiv.appendChild(eventItem);
            });

            addEventItemListeners();
        }

        // 축제/관광 아이템 클릭 리스너
        function addEventItemListeners() {
            document.querySelectorAll('.event-item').forEach(item => {
                item.addEventListener('click', () => {
                    const eventId = item.dataset.id;
                    displayEventDetail(eventId);
                });
            });
        }

        // 상세 정보 표시 함수
        function displayEventDetail(eventId) {
            const event = events.find(e => e.id === eventId);
            if (event) {
                document.getElementById('detail-name').textContent = event.name;
                document.getElementById('detail-type').textContent = `분류: ${event.type === 'festival' ? '축제' : '관광지'}`;
                document.getElementById('detail-location').textContent = `장소: ${event.location}`;
                document.getElementById('detail-date').textContent = event.type === 'festival' ? `기간: ${event.startDate} - ${event.endDate}` : `운영: ${event.startDate}`;
                document.getElementById('detail-phone').textContent = `문의: ${event.phone}`;
                document.getElementById('detail-description').textContent = event.description;

                document.querySelector('.event-detail .detail-img').src = event.imgUrl; // 상세 이미지도 공통 이미지 사용

                eventListDiv.style.display = 'none';
                eventDetailDiv.classList.add('active');

                // 지도에서 해당 이벤트 위치로 이동
                const moveLatLon = new kakao.maps.LatLng(event.lat, event.lng);
                map.setCenter(moveLatLon);
                map.setLevel(3);
            }
        }

        // 필터링 로직
        function filterEvents() {
            const searchTerm = searchInput.value.toLowerCase();
            const selectedCategory = categoryFilter.value;
            const selectedDate = dateFilter.value; // 'YYYY-MM-DD' 형식

            return events.filter(event => {
                const matchesSearch = event.name.toLowerCase().includes(searchTerm) ||
                                    event.location.toLowerCase().includes(searchTerm);
                const matchesCategory = selectedCategory === 'all' || event.type.toLowerCase() === selectedCategory;

                let matchesDate = true;
                if (selectedDate) {
                    // '상시' 이벤트는 항상 포함
                    if (event.startDate === '상시' || event.endDate === '상시') {
                        matchesDate = true;
                    } else {
                        const filterDate = new Date(selectedDate);
                        const eventStartDate = new Date(event.startDate);
                        const eventEndDate = new Date(event.endDate);

                        // 필터 날짜가 이벤트 시작일과 종료일 사이에 있거나, 시작일과 동일하거나, 종료일과 동일한 경우
                        matchesDate = (filterDate >= eventStartDate && filterDate <= eventEndDate);
                    }
                }
                
                return matchesSearch && matchesCategory && matchesDate;
            });
        }

        // 필터 적용 후 리스트 및 마커 업데이트
        function filterAndRenderEvents() {
            const filtered = filterEvents();
            renderEventList(filtered);
            updateMarkers(filtered);
        }

        // 이벤트 리스너
        searchInput.addEventListener('input', filterAndRenderEvents);
        categoryFilter.addEventListener('change', filterAndRenderEvents);
        dateFilter.addEventListener('change', filterAndRenderEvents);

        backToListBtn.addEventListener('click', () => {
            eventDetailDiv.classList.remove('active');
            eventListDiv.style.display = 'block';
            filterAndRenderEvents();
        });

        // 지도에서 보기 버튼 클릭 시
        document.querySelector('.event-detail .view-on-map-btn').addEventListener('click', () => {
            const currentEventName = document.getElementById('detail-name').textContent;
            const currentEvent = events.find(e => e.name === currentEventName); // 이름으로 찾기, 더 정확한 id 사용 권장
            if (currentEvent) {
                const moveLatLon = new kakao.maps.LatLng(currentEvent.lat, currentEvent.lng);
                map.setCenter(moveLatLon);
                map.setLevel(3);
            }
        });

        // 전역 함수로 등록 (인포윈도우에서 호출하기 위함)
        window.displayEventDetail = displayEventDetail;

        // 초기 로드 시 지도 및 리스트 렌더링
        initMap();
    });
    </script>
</body>
</html>