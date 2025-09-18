<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대전 스탬프 현황</title>
    <style>
        /* 기본 스타일 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f7f6;
            color: #333;
        }

        .container {
            max-width: 900px;
            margin: 20px auto;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
        }

        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.2em;
            font-weight: 700;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background-color: #e8f5e9; /* Light green */
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card h2 {
            color: #2e7d32; /* Dark green */
            font-size: 1.2em;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .stat-card p {
            font-size: 2.5em;
            font-weight: bold;
            color: #388e3c; /* Medium green */
            margin: 0;
        }

        .progress-bar-container {
            background-color: #e0e0e0;
            border-radius: 5px;
            height: 25px;
            overflow: hidden;
            margin-top: 15px;
        }

        .progress-bar {
            height: 100%;
            background-color: #4caf50; /* Green */
            width: 0%; /* JavaScript will update this */
            border-radius: 5px;
            text-align: center;
            color: white;
            line-height: 25px;
            font-weight: bold;
            transition: width 0.5s ease-in-out;
        }

        .section-title {
            color: #2c3e50;
            font-size: 1.8em;
            margin-top: 40px;
            margin-bottom: 20px;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            font-weight: 600;
        }

        .store-list ul {
            list-style: none;
            padding: 0;
        }

        .store-list li {
            background-color: #f9f9f9;
            border: 1px solid #eee;
            padding: 15px 20px;
            margin-bottom: 10px;
            border-radius: 8px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 1.1em;
        }

        .store-list li strong {
            color: #333;
        }

        .store-list li span {
            color: #777;
            font-size: 0.9em;
        }

        /* 보상 및 포인트 섹션 스타일 */
        .reward-section {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px; /* 버튼과 포인트 칸 사이 간격 */
            margin-top: 40px;
            margin-bottom: 40px;
            flex-wrap: wrap; /* 작은 화면에서 줄바꿈 */
        }

        .reward-button {
            display: inline-flex;
            align-items: center;
            padding: 15px 30px;
            background-color: #ff9800; /* Orange for a cute look */
            color: white;
            border: none;
            border-radius: 30px; /* More rounded for cuteness */
            font-size: 1.5em;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 6px 15px rgba(255, 152, 0, 0.3);
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            text-decoration: none;
        }

        .reward-button:hover {
            background-color: #fb8c00; /* Slightly darker orange */
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 152, 0, 0.4);
        }

        .reward-button:active {
            transform: translateY(0);
            box-shadow: 0 4px 10px rgba(255, 152, 0, 0.2);
        }

        .reward-button img {
            width: 30px;
            height: 30px;
            margin-right: 10px;
            vertical-align: middle;
        }

        .point-display {
            display: flex;
            background-color: #fff9c4; /* Light yellow for points */
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            text-align: center;
            min-width: 150px; /* 최소 너비 지정 */
        }

        .point-display h2 {
            color: #fbc02d; /* Darker yellow */
            font-size: 1.2em;
            margin-bottom: 5px;
            font-weight: 600;
        }

        .point-display p {
            font-size: 2.2em;
            font-weight: bold;
            color: #f9a825; /* Medium yellow */
            margin: 0;
        }

        /* 반응형 디자인 */
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .stat-card {
                padding: 20px;
            }
            .stat-card p {
                font-size: 2em;
            }
            h1 {
                font-size: 1.8em;
            }
            .section-title {
                font-size: 1.5em;
            }
            .reward-section {
                flex-direction: column; /* 세로로 정렬 */
                gap: 15px;
            }
            .reward-button {
                font-size: 1.2em;
                padding: 12px 25px;
                width: 80%; /* 모바일에서 버튼 너비 조정 */
            }
            .reward-button img {
                width: 25px;
                height: 25px;
            }
            .point-display {
                width: 80%; /* 모바일에서 포인트 칸 너비 조정 */
                padding: 12px 20px;
            }
            .point-display p {
                font-size: 1.8em;
            }
        }
    </style>
</head>
<body>
    
                <div id="myStampCardOverlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(44,62,80,0.18); z-index:1000;">
                    <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:#f1f8e9; border-radius:18px; box-shadow:0 8px 32px rgba(0,0,0,0.18); padding:38px 32px; min-width:320px; max-width:90vw; max-height:80vh; overflow:hidden;">
                        <button id="closeStampCardOverlay" style="position:absolute; top:18px; right:18px; background:none; border:none; font-size:1.8em; color:#388e3c; cursor:pointer;">×</button>
                        <h2 style="margin-top:0; color:#388e3c; text-align:center;">내 스탬프 카드 목록</h2>
                        
                        <!-- 📌 스크롤 가능한 영역 -->
                        <div id="stampCardList" style="
                            margin-top:24px;
                            display:grid;
                            grid-template-columns: repeat(3, 1fr);
                            gap:16px;
                            overflow-y:auto;
                            max-height:55vh;
                            padding-right:8px;
                        ">
                            <!-- 예시 이미지 -->
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <img src="example1.jpg" style="width:300px; height:auto; border-radius:8px; object-fit:cover;" />
                            <!-- 무한 이미지 추가 가능 -->
                        </div>
                    </div>
                </div>

    <div class="container">
        <h1>나의 대전 스탬프 대시보드</h1>

        <div class="stats-grid">
            <div class="stat-card">
                <h2>대전 스탬프 수집률</h2>
                <p id="totalStampPercentage">0%</p>
                <div class="progress-bar-container">
                    <div class="progress-bar" style="width: 0%;" id="progressBar"></div>
                </div>
            </div>

            <div class="stat-card">
                <h2>오늘 모은 스탬프</h2>
                <p id="todayStampCount">2개</p>
                <button id="myStampCardBtn" style="margin-top:15px; padding:8px 18px; border-radius:20px; background:#4caf50; color:#fff; border:none; font-size:1em; cursor:pointer;">
                    내 스탬프 카드
                </button>
            </div>

            <div class="stat-card">
                <h2>오늘 이동 거리</h2>
                <p id="todayDistance">0 km</p>
            </div>
        </div>

        <div class="reward-section">
            <button class="reward-button" onclick="handleReward()">
                ✨ 보상받기
            </button>
            <div class="point-display">
                <h2>내 포인트</h2>
                <p id="myPoints">0 P</p>
            </div>
        </div>

        <h2 class="section-title">최근 방문 가게 리스트</h2>
        <div class="store-list">
            <ul id="visitedStoreList">
                <li>
                    <strong>커피명가 대전점</strong>
                    <span>2025-07-15 10:30 AM</span>
                </li>
                <li>
                    <strong>베이커리 아뜰리에</strong>
                    <span>2025-07-14 03:15 PM</span>
                </li>
                <li>
                    <strong>동네분식 하우스</strong>
                    <span>2025-07-14 12:00 PM</span>
                </li>
            </ul>
        </div>
    </div>

    <script>
const myStampCardBtn = document.getElementById('myStampCardBtn');
const myStampCardOverlay = document.getElementById('myStampCardOverlay');
const closeStampCardOverlay = document.getElementById('closeStampCardOverlay');
const stampCardList = document.getElementById('stampCardList');

        // 현재 포인트 값을 저장할 변수 (초기값 설정)
        let currentPoints = 0; // 시작 포인트는 0으로 설정

        // 페이지 로드 시 초기 포인트 값 표시
        document.getElementById('myPoints').textContent = `${currentPoints} P`;

        // 실제 데이터는 서버에서 가져오거나 사용자의 활동에 따라 동적으로 업데이트되어야 합니다.
        // 여기서는 예시 데이터를 사용합니다.

        // 1. 대전 내 스탬프 수집률 (예시: 100개 중 30개 수집)
        const totalStampsInDaejeon = 100; // 대전 전체 스탬프 개수
        const myCollectedStamps = 30; // 내가 모은 스탬프 개수
        const percentage = (myCollectedStamps / totalStampsInDaejeon * 100).toFixed(0); // 소수점 제거

        document.getElementById('totalStampPercentage').textContent = `${percentage}%`;
        document.getElementById('progressBar').style.width = `${percentage}%`;
        document.getElementById('progressBar').textContent = `${percentage}%`;


        // 2. 오늘 모은 스탬프 개수 (예시)
        const stampsToday = 2;
        document.getElementById('todayStampCount').textContent = `${stampsToday}개`;

        // 3. 오늘 이동 거리 (예시)
        const distanceToday = 5.3; // km 단위
        document.getElementById('todayDistance').textContent = `${distanceToday} km`;

        // 4. 내가 지나온 가게 리스트 (예시 데이터 - 실제는 서버에서 가져옴)
        const visitedStores = [
            { name: "빵집 궁동점", time: "2025-07-15 11:45 AM" },
            { name: "파스타 연구소", time: "2025-07-15 01:20 PM" },
            { name: "대전 서점", time: "2025-07-15 02:50 PM" },
            { name: "대전역 카페", time: "2025-07-14 09:00 AM" }
        ];

        const storeListElement = document.getElementById('visitedStoreList');
        // 예시로 넣어둔 목록을 지우고 동적으로 추가
        storeListElement.innerHTML = ''; // 기존 목록 초기화

        visitedStores.forEach(store => {
            const listItem = document.createElement('li');
            listItem.innerHTML = `
                <strong>${store.name}</strong>
                <span>${store.time}</span>
            `;
            storeListElement.appendChild(listItem);
        });

        // 보상받기 버튼 클릭 시 실행될 함수
        function handleReward() {
            const pointsEarned = 10; // 보상으로 얻을 포인트 (예시)
            currentPoints += pointsEarned; // 현재 포인트에 추가

            document.getElementById('myPoints').textContent = `${currentPoints} P`; // 포인트 업데이트

            alert(`${pointsEarned} P를 획득하셨습니다! 총 ${currentPoints} P!`);
            // 여기에 실제 보상 로직 (예: 스탬프 초기화, 쿠폰 발급 등)을 추가할 수 있습니다.
        }


        // 예시 스탬프 카드 데이터
        const myStampCards = [
            { name: "커피명가 대전점", stamps: 5, total: 10 },
            { name: "베이커리 아뜰리에", stamps: 3, total: 8 },
            { name: "동네분식 하우스", stamps: 7, total: 12 }
        ];

        // 버튼 클릭 시 오버레이 팝업 열기
        myStampCardBtn.addEventListener('click', () => {
            // 카드 목록 동적 생성
            // stampCardList.innerHTML = '';
            // myStampCards.forEach(card => {
            //     const cardDiv = document.createElement('div');
            //     cardDiv.style = "background:#fff; border-radius:12px; box-shadow:0 2px 8px rgba(0,0,0,0.07); padding:18px 22px; margin-bottom:16px; display:flex; justify-content:space-between; align-items:center;";
            //     cardDiv.innerHTML = `
            //         <div>
            //             <strong style="font-size:1.15em;">${card.name}</strong>
            //             <div style="color:#388e3c; font-size:1em; margin-top:6px;">${card.stamps} / ${card.total} 스탬프</div>
            //         </div>
            //         <div style="font-size:1.5em; color:#4caf50;">${'★'.repeat(card.stamps)}${'☆'.repeat(card.total-card.stamps)}</div>
            //     `;
            //     stampCardList.appendChild(cardDiv);
            // });
             myStampCardOverlay.style.display = 'block';
        });

        // 닫기 버튼 클릭 시 오버레이 닫기
        closeStampCardOverlay.addEventListener('click', () => {
            myStampCardOverlay.style.display = 'none';
        });

        // 오버레이 바깥 클릭 시 닫기
        myStampCardOverlay.addEventListener('click', (e) => {
            if (e.target === myStampCardOverlay) {
                myStampCardOverlay.style.display = 'none';
            }
        });

    </script>
</body>
</html>