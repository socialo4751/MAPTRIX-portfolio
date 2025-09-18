<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>가맹점 신청</title>

    <!-- Site-wide includes -->

    <!-- Bootstrap helpers -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="/css/csstyle.css">

    <style>
    	.btn-map {
        background-color: #ff6b35;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 12px;
        transition: background-color 0.3s ease;
        white-space: nowrap;
    }

    .btn-map:hover {
        background-color: #e55a2b;
    }

    .btn-map i {
        margin-right: 5px;
    }
	/* ✅ 추가: 지도 모달 스타일 */
    .map-modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.4);
    }

    .map-modal-content {
        background: #fff;
        margin: 10% auto;
        padding: 20px;
        border-radius: 8px;
        width: 80%;
        max-width: 600px;
    }

    .map-modal-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .map-close {
        cursor: pointer;
        font-size: 24px;
        font-weight: bold;
    }

    #map {
        width: 100%;
        height: 400px;
        margin-top: 10px;
    }

    .close-btn {
        background: none;
        border: none;
        color: white;
        font-size: 24px;
        cursor: pointer;
        padding: 0;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: background-color 0.3s ease;
    }

    .close-btn:hover {
        background-color: rgba(255, 255, 255, 0.2);
    }

    .map-container {
        width: 100%;
        height: 400px;
    }

    .map-info {
        padding: 20px;
        background-color: #f8f9fa;
        border-top: 1px solid #e9ecef;
    }

    .map-info h4 {
        margin: 0 0 10px 0;
        color: #2c3e50;
        font-size: 1.1em;
    }

    .map-info p {
        margin: 5px 0;
        color: #5a6c7d;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .map-info i {
        color: #3498db;
        width: 16px;
    }

    @media (max-width: 768px) {
        .map-modal-content {
            width: 95%;
            margin: 20px auto;
        }

        .map-container {
            height: 300px;
        }

        .address-container {
            flex-direction: column;
            align-items: stretch;
        }
    }
    
    
    
    
        .page-header h2 {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 6px 0 12px 0;
        }

        .help-text {
            color: #6c757d;
        }

        .card-soft {
            border: 1px solid #eee;
        }

        #map {
            width: 100%;
            height: 380px;
            border-radius: 8px;
        }

        .form-label .req {
            color: #d63384;
            font-weight: 700;
            margin-left: 4px;
        }

        .btn-wide {
            min-width: 140px;
        }
    </style>

    <!-- Kakao Maps & Daum Postcode -->
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cd7fce736650d9ad005b3ff7bd12af63&libraries=services"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>
<div class="container">
    <c:set var="activeMenu" value="stamp"/>
    <c:set var="activeSub" value="merchant"/>
    <%@ include file="/WEB-INF/views/include/stSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2><span class="material-icons" style="font-size:28px;">storefront</span> 가맹점 신청</h2>
            <p class="help-text mb-0">스탬프 포인트를 오프라인에서 사용할 수 있도록 가맹 절차를 신청합니다.</p>
        </div>


<c:choose>
	<c:when test="${apply}">
		<div class="row g-1">
            <!-- Left: Form -->
            <div class="col-lg-7">
        <div class="card card-soft">
            <div class="card-body">
                <form id="applyForm" class="vstack gap-3">
                    <div class="row align-items-center">
                        <label for="applyStoreName" class="col-sm-3 col-form-label">상호명<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input class="form-control" id="applyStoreName"
                                   placeholder="예: 혜림네일" required>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <label for="adminBizName" class="col-sm-3 col-form-label">업종<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input class="form-control" id="adminBizName"
                                   placeholder="예: 식당 / 카페" required>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <label for="userId" class="col-sm-3 col-form-label">신청자 ID<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="userId"
                                   value="<sec:authentication property='principal.username'/>" readonly
                                   required>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <label for="adminContact" class="col-sm-3 col-form-label">연락처<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="adminContact"
                                   placeholder="예: 010-1234-5678" required>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <label for="adminEmail" class="col-sm-3 col-form-label">이메일<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input type="email" class="form-control" id="adminEmail"
                                   placeholder="예: user@example.com" required>
                        </div>
                    </div>
                    
                    <hr>

                    <div class="row align-items-end">
                        <label for="postcode" class="col-sm-3 col-form-label">우편번호<span class="req">*</span></label>
                        <div class="col-sm-6">
                            <input type="text" class="form-control" id="postcode" placeholder="-" readonly required>
                        </div>
                        <div class="col-sm-3">
                            <button type="button" class="btn btn-outline-secondary w-100" id="btnPostcode">
                                찾기
                            </button>
                        </div>
                    </div>

                    <div class="row align-items-center">
                        <label for="address" class="col-sm-3 col-form-label">주소<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="address" placeholder="사업장 주소를 입력하세요." readonly required>
                        </div>
                    </div>
                    <input type="hidden" class="form-control" id="jibunAddress">

                    <div class="row align-items-center">
                        <label for="detailAddress" class="col-sm-3 col-form-label">상세 주소<span class="req">*</span></label>
                        <div class="col-sm-9">
                            <input type="text" class="form-control" id="detailAddress"
                                   placeholder="상세 주소를 입력하세요" required>
                        </div>
                    </div>

                    <input type="hidden" id="lat">
                    <input type="hidden" id="lng">

                    <div class="row">
                        <label for="memo" class="col-sm-3 col-form-label">메모</label>
                        <div class="col-sm-9">
                             <textarea class="form-control" id="memo" rows="3"
                                          placeholder="추가 요청사항을 입력하세요"></textarea>
                        </div>
                    </div>

                    <div class="d-flex gap-2 justify-content-end">
                        <button type="reset" class="btn btn-outline-secondary">초기화</button>
                        <button type="submit" class="btn btn-primary btn-wide">신청하기</button>
                    </div>

                    <div id="successMessage" class="mt-2" style="display:none;"></div>
                </form>
            </div>
        </div>
    </div>
            
            <!-- Right: Map preview -->
            <div class="col-lg-5">
                <div class="card card-soft" style="height:100%">
                    <div class="card-body">
                        <h6 class="mb-2" style="margin-top:50px">위치 미리보기</h6>
                        <div id="map"></div>
                        <p class="help-text mt-2 mb-0">상세 주소 입력 후 자동으로 좌표를 탐색해 지도를 이동합니다.</p>
                    </div>
                </div>
            </div>
		</c:when>
	<c:otherwise>
		<table class="table table-bordered table-hover align-middle text-center">
			<thead class="table-light">
							<tr>
					<td colspan="7">이미 신청된 가맹점이 있습니다.</td>
				</tr>
				<tr>
					<th>요청ID</th>
					<th>상호명</th>
					<th>이메일</th>
					<th>메모</th>
					<th>전화번호</th>
					<th>상태</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="user" items="${applyList}">
				<tr>
					<td>${user.applyId}</td>
					<td>${user.applyStoreName}
						<button type="button" class="btn-map"
							onclick="openMapModal('${user.address1}', '${user.applyStoreName}')">
							지도보기
						</button>
					</td>
					<td>${user.userId}</td>
					<td>${user.memo}</td>
					<td>${user.adminContact}</td>
						<c:choose>
							<c:when
								test="${user.status eq '처리중'}">
								<span class="status-suspended text-warning"> <i
									class="bi bi-pause-circle-fill"></i> 처리중
								</span>
							</c:when>
							<c:when
								test="${user.status eq '승인'}">
								<span class="status-active text-success"> <i
									class="bi bi-check-circle-fill"></i> 승인
								</span>
							</c:when>
						</c:choose>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</c:otherwise>
</c:choose>


	<!-- 지도 모달 -->
	<div id="mapModal" class="map-modal">
	    <div class="map-modal-content">
	        <div class="map-modal-header">
	            <h3><i class="fas fa-map-marker-alt"></i> 사업장 위치</h3>
	            <button type="button" class="close-btn" onclick="closeMapModal()">
	                <i class="fas fa-times"></i>
	            </button>
	        </div>
	        <div id="map" class="map-container"></div>
	        <div class="map-info">
	            <h4 id="mapCompanyName"></h4>
	            <p><i class="fas fa-map-marker-alt"></i> <span id="mapAddress"></span></p>
	        </div>
	    </div>
	</div>

        </div>
    </main>
</div>

<script>
    (function () {
        // Kakao map init
        var map, marker, geocoder;
        var lat = 36.3504, lng = 127.3845; // 대전 시청 근처 기본값

        function initMap() {
            var container = document.getElementById('map');
            if (!container || !window.kakao || !kakao.maps) return;

            var options = {center: new kakao.maps.LatLng(lat, lng), level: 4};
            map = new kakao.maps.Map(container, options);
            marker = new kakao.maps.Marker({position: new kakao.maps.LatLng(lat, lng)});
            marker.setMap(map);
            geocoder = new kakao.maps.services.Geocoder();
        }

        function updateMap(newLat, newLng) {
            lat = newLat;
            lng = newLng;
            var pos = new kakao.maps.LatLng(lat, lng);
            map.setCenter(pos);
            marker.setPosition(pos);
            document.getElementById('lat').value = lat;
            document.getElementById('lng').value = lng;
        }

        // Postcode
        document.getElementById('btnPostcode').addEventListener('click', function () {
            new daum.Postcode({
                oncomplete: function (data) {
                    document.getElementById('postcode').value = data.zonecode || '';
                    document.getElementById('address').value = data.roadAddress || data.address || '';
                    
                    document.getElementById('jibunAddress').value = data.jibunAddress || '지번주소 없음';
                    document.getElementById('detailAddress').focus();
                }
            }).open();
        });

        // Geocode when detail address changes
        document.getElementById('detailAddress').addEventListener('blur', function () {
            var a1 = document.getElementById('address').value || '';
            var a2 = document.getElementById('detailAddress').value || '';
            var full = (a1 + ' ' + a2).trim();
            if (!full || !geocoder) return;
            geocoder.addressSearch(full, function (result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    updateMap(parseFloat(result[0].y), parseFloat(result[0].x));
                }
            });
        });

        // Submit
        document.getElementById('applyForm').addEventListener('submit', function (e) {
            e.preventDefault();
            
            // 폼 필드에서 모든 값 수집
            const userId = document.getElementById('userId').value.trim();
            const adminContact = document.getElementById('adminContact').value.trim();
            const applyStoreName = document.getElementById('applyStoreName').value.trim();
            const adminBizName = document.getElementById('adminBizName').value.trim();
            const adminEmail = document.getElementById('adminEmail').value.trim();
            
            // 우편번호와 주소 관련 필드 추가
            const postcode = document.getElementById('postcode').value.trim();
            const address = document.getElementById('address').value.trim();
            const jibunAddress = document.getElementById('jibunAddress').value.trim();
            const detailAddress = document.getElementById('detailAddress').value.trim();
            
            
            const memo = document.getElementById('memo').value.trim();
            
            
            const payload = {
                    userId: userId,
                    adminContact: adminContact,
                    applyStoreName: applyStoreName,
                    adminBizName: adminBizName,
                    adminEmail: adminEmail,
                    postcode: postcode,           // 우편번호 추가
                    address1: address,            // 도로명 주소
                    address2: detailAddress,      // 상세 주소
                    jibunAddress: jibunAddress,   // 지번 주소 추가
                    lat: lat,
                    lon: lng,
                    memo: memo
                };

            fetch('/attraction/insert-apply-form', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(payload)
            })
                .then(r => r.json())
                .then(data => {
                    var msg = document.getElementById('successMessage');
                    if (data && data.status) {
                        msg.textContent = data.msg || '신청이 접수되었습니다.';
                        msg.style.color = 'green';
                        msg.style.display = 'block';
                        setTimeout(function () {
                            window.location.href = '/my/bizapply/status';
                        }, 1200);
                    } else {
                        msg.textContent = (data && data.msg) || '신청 처리에 실패했습니다.';
                        msg.style.color = 'red';
                        msg.style.display = 'block';
                    }
                })
                .catch(err => {
                    var msg = document.getElementById('successMessage');
                    msg.textContent = '신청 처리 중 오류가 발생했습니다.';
                    msg.style.color = 'red';
                    msg.style.display = 'block';
                });
        });

        // Initialize after DOM
        if (document.readyState !== 'loading') initMap();
        else document.addEventListener('DOMContentLoaded', initMap);
    })();
    
 // 지도 모달 열기
    function openMapModal(address, companyName) {
        if (!address || address.trim() === '') {
            alert('주소 정보가 없습니다.');
            return;
        }

        document.getElementById('mapModal').style.display = 'block';
        document.getElementById('mapCompanyName').textContent = companyName || '회사명 없음';
        document.getElementById('mapAddress').textContent = address;

        // 모달이 열린 후 잠시 기다렸다가 지도 초기화
        setTimeout(() => {
            initializeMap(address, companyName);
        }, 100);

        // ESC 키로 모달 닫기
        document.addEventListener('keydown', handleEscKey);

        // body 스크롤 막기
        document.body.style.overflow = 'hidden';
    }
    
    // 지도 모달 닫기
    function closeMapModal() {
        document.getElementById('mapModal').style.display = 'none';
        document.removeEventListener('keydown', handleEscKey);

        // body 스크롤 복원
        document.body.style.overflow = '';

        // 지도 객체 정리
        if (map) {
            map = null;
        }
    }
    
    // 지도 초기화
    function initializeMap(address, companyName) {
        const mapContainer = document.getElementById('map');

        // 카카오 맵 API가 로드되지 않았을 경우 처리
        if (typeof kakao === 'undefined' || typeof kakao.maps === 'undefined') {
            alert('지도 서비스를 불러올 수 없습니다. 잠시 후 다시 시도해주세요.');
            return;
        }

        // 지오코더 객체 생성
        geocoder = new kakao.maps.services.Geocoder();

        // 주소로 좌표 검색
        geocoder.addressSearch(address, function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
                const coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                // 지도 옵션
                const mapOption = {
                    center: coords,
                    level: 3 // 지도 확대 레벨
                };

                // 지도 생성
                map = new kakao.maps.Map(mapContainer, mapOption);

                // 마커 생성
                const marker = new kakao.maps.Marker({
                    position: coords,
                    map: map
                });

                map.setCenter(coords);

            } else {
                alert('주소를 찾을 수 없습니다. 정확한 주소를 확인해주세요.');
                closeMapModal();
            }
        });
    }

    // 모달 외부 클릭 시 닫기
    document.getElementById('mapModal').addEventListener('click', function (event) {
        if (event.target === this) {
            closeMapModal();
        }
    });
    
 // ESC 키 핸들러
    function handleEscKey(event) {
        if (event.key === 'Escape') {
            closeMapModal();
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
