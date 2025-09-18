<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>내 가게정보 등록</title>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypagestyle.css"/>

    <style>
        /* ... (기존 스타일 유지) ... */
        .biz-info-list .info-line {
            display: flex;
            align-items: center;
            gap: 18px;
            margin-bottom: 14px;
        }

        .biz-info-list .info-line i {
            width: 26px;
            text-align: center;
            font-size: 1.2em;
            color: #3498db;
        }

        .biz-info-empty {
            text-align: center;
            padding: 38px 10px;
            color: #555;
        }

        .form-row-gap .form-group {
            margin-bottom: 16px;
        }

        .form-actions {
            text-align: right;
            margin-top: 18px;
        }

        .alert-box {
            margin-bottom: 20px;
            padding: 14px 16px;
            border-radius: 6px;
        }

        .alert-success {
            background: #e9f7ef;
            border: 1px solid #d4efdf;
            color: #1e8449;
        }

        .alert-danger {
            background: #fdedec;
            border: 1px solid #f5b7b1;
            color: #c0392b;
        }

        /* 추가된 스타일 */
        .verification-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .verification-group input {
            flex-grow: 1;
        }

        .btn-verify {
            width: 120px;
            height: 38px;
            border-radius: 4px;
            background-color: #3498db;
            color: #fff;
            border: none;
            cursor: pointer;
        }

        .btn-verify:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        .verification-result {
            margin-top: 8px;
            font-size: 0.9em;
            text-align: right;
        }

        .success-message {
            color: #1e8449;
        }

        .error-message {
            color: #c0392b;
        }

        /* 지도 관련 스타일 */
        .address-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .address-info {
            flex: 1;
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
    </style>

    <style>
        /* ===== BizForm scoped ===== */
        #bizFormSection .card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 6px 22px rgba(17, 24, 39, .06);
            padding: 20px;
        }

        #bizFormSection h3 {
            margin: 0 0 10px 0;
        }

        #bizFormSection .form-grid {
            display: grid;
            grid-template-columns:1fr 1fr;
            gap: 16px 18px;
        }

        @media (max-width: 900px) {
            #bizFormSection .form-grid {
                grid-template-columns:1fr;
            }
        }

        #bizFormSection .form-group label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        #bizFormSection .input-group input {
            width: 100%;
            height: 44px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 10px 12px;
            outline: none;
            transition: .2s border-color, .2s box-shadow, .2s background;
            background: #fff;
        }

        #bizFormSection .input-group input:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, .15);
        }

        #bizFormSection .input-hint {
            color: #6b7280;
            font-size: .85rem;
            margin-top: 6px;
        }

        #bizFormSection input[readonly] {
            background: #f3f4f6;
            color: #4b5563;
        }

        #bizFormSection .verify-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-top: 8px;
        }

        #bizFormSection .small-btn {
            height: 40px;
            min-width: 110px;
            padding: 0 12px;
            border-radius: 10px;
            border: 1px solid #3498db;
            background: #3498db;
            color: #fff;
            cursor: pointer;
        }

        #bizFormSection .small-btn:disabled {
            background: #cbd5e1;
            border-color: #cbd5e1;
            cursor: not-allowed;
        }

        #bizFormSection .verification-result {
            text-align: right;
            font-size: .92rem;
            min-height: 22px;
        }

        #bizFormSection .success-message {
            color: #1e8449;
        }

        #bizFormSection .error-message {
            color: #c0392b;
        }

        #bizFormSection .form-buttons {
            display: flex;
            gap: 8px;
            justify-content: flex-end;
            margin-top: 18px;
            flex-wrap: wrap;
        }

        /* ===== 주소 입력 행 레이아웃 ===== */
        .addr-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .addr-row .zip {
            width: 140px; /* 우편번호 칸 고정폭 */
        }

        .addr-row .addr {
            flex: 1; /* 주소는 가변폭 */
            min-width: 220px;
        }

        .addr-row .addr-detail {
            width: 100%;
        }

        /* ===== 우편번호 버튼 스타일 ===== */
        .btn-zip {
            height: 44px;
            min-width: 150px;
            padding: 0 14px;
            border-radius: 10px;
            border: 1px solid #3498db;
            background: linear-gradient(135deg, #3498db, #2779bd);
            color: #fff;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            cursor: pointer;
            transition: transform .06s ease, box-shadow .2s ease, background .2s ease;
            white-space: nowrap;
        }

        .btn-zip i {
            font-size: 1rem;
        }

        .btn-zip:hover {
            background: linear-gradient(135deg, #2f89d6, #246eab);
            box-shadow: 0 6px 18px rgba(52, 152, 219, .28);
        }

        .btn-zip:active {
            transform: translateY(1px);
        }

        .btn-zip:focus {
            outline: none;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, .18);
        }

        /* 반응형: 좁은 화면에서 세로 스택 */
        @media (max-width: 900px) {
            .addr-row {
                flex-direction: column;
                align-items: stretch;
            }

            .addr-row .zip {
                width: 100%;
            }

            .btn-zip {
                width: 100%;
            }
        }

        /* 우편번호 입력 + 버튼 한 줄 배치 */
        .zip-inline {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .zip-inline .zip-input {
            flex: 1; /* 입력칸이 가변폭으로 넓어지게 */
            height: 44px; /* 폼의 다른 인풋과 높이 매칭 */
        }

        @media (max-width: 900px) {
            .zip-inline {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-zip {
                width: 100%;
            }
        }

        /* ===== 폼 하단 버튼 커스텀 ===== */
        .form-buttons .btn-cancel {
            height: 46px;
            min-width: 120px;
            border-radius: 10px;
            border: 1px solid #9ca3af; /* 회색 */
            background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
            color: #374151;
            font-weight: 600;
            cursor: pointer;
            transition: transform .06s ease, box-shadow .2s ease;
        }

        .form-buttons .btn-cancel:hover {
            background: linear-gradient(135deg, #e5e7eb, #d1d5db);
            box-shadow: 0 4px 12px rgba(107, 114, 128, .25);
        }

        .form-buttons .btn-save {
            height: 46px;
            min-width: 120px;
            border-radius: 10px;
            border: 1px solid #2563eb;
            background: linear-gradient(135deg, #3498db, #2779bd);
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            transition: transform .06s ease, box-shadow .2s ease;
        }

        .form-buttons .btn-save:hover {
            background: linear-gradient(135deg, #2f89d6, #246eab);
            box-shadow: 0 6px 18px rgba(52, 152, 219, .28);
        }

        .form-buttons .btn-save:disabled {
            background: #cbd5e1;
            border-color: #cbd5e1;
            cursor: not-allowed;
            box-shadow: none;
        }
        
        /* 새로운 지도 컨테이너 스타일 */
		.map-container-inline {
		    width: 100%;
		    height: 300px;
		    margin-top: 10px;
		    border-radius: 8px;
		    overflow: hidden;
		    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
		}

    </style>
</head>
<div class="container">
    <c:set var="activeMenu" value="profile"/>   <!-- profile | report | activity | apply -->
    <c:set var="activeSub" value="biz"/>
    <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>

    <main>
        <div class="mypage-header">
            <h2 style="display:flex; align-items:center; gap:8px; position:relative;">
                내 가게 등록
            </h2>
            <p>사업자등록번호를 입력하여 내 가게를 등록 할 수 있습니다.</p>
            <c:if test="${not empty errorMessage}">
                <div class="alert-box alert-danger"><i class="fas fa-exclamation-triangle"></i> ${errorMessage}</div>
            </c:if>
            <c:if test="${not empty successMessage}">
                <div class="alert-box alert-success"><i class="fas fa-check-circle"></i> ${successMessage}</div>
            </c:if>
        </div>

        <div class="user-info-section" id="bizInfoSection">
            <c:choose>
                <c:when test="${not empty loginUser.usersBizIdVO.bizNumber}">
                    <h3>등록된 사업자 정보</h3>
                    <div class="biz-info-list" style="margin-top:10px;">
                        <div class="info-line">
                            <i class="fas fa-id-card-alt"></i>
                            <div class="info-item" style="margin:0;">
                                <label>사업자등록번호</label>
                                <span>${loginUser.usersBizIdVO.bizNumber}</span>
                            </div>
                        </div>
                        <div class="info-line">
                            <i class="fas fa-building"></i>
                            <div class="info-item" style="margin:0;">
                                <label>회사명</label>
                                <span>${loginUser.usersBizIdVO.companyName}</span>
                            </div>
                        </div>
                        <div class="info-line">
						    <i class="fas fa-map-marker-alt"></i>
						    <div class="info-item" style="margin:0;">
						        <label>사업장주소</label>
						        <span>${loginUser.usersBizIdVO.bizAddress1} ${loginUser.usersBizIdVO.bizAddress2}</span>
						    </div>
						</div>
						
                        <div class="info-line">
                            <i class="fas fa-calendar-alt"></i>
                            <div class="info-item" style="margin:0;">
                                <label>개업일자</label>
                                <span>${loginUser.usersBizIdVO.startDate}</span>
                            </div>
                        </div>
						<c:if test="${not empty loginUser.usersBizIdVO.bizAddress1}">
						    <div class="map-wrapper">
						        <div id="map-inline" class="map-container-inline"></div>
						    </div>
						    <script>
						        document.addEventListener('DOMContentLoaded', function() {
						            // 페이지 로드 후 바로 지도 초기화 함수 호출
						            initializeMap(
						                '${loginUser.usersBizIdVO.bizAddress1} ${loginUser.usersBizIdVO.bizAddress2}',
						                '${loginUser.usersBizIdVO.companyName}'
						            );
						        });
						    </script>
						</c:if>
                    </div>

                    <div class="action-buttons" style="margin-top:24px;">
                        <button type="button" class="btn-edit" onclick="showRegistrationForm()">
                            <i class="fas fa-edit"></i> 변경하기
                        </button>
                    </div>
                </c:when>

                <c:otherwise>
                    <h3>사업자 정보</h3>
                    <div class="biz-info-empty">
                        사업자 등록 정보가 없습니다.<br/>사업자 정보를 등록하시면 더 많은 서비스를 이용할 수 있습니다.
                    </div>
                    <div class="action-buttons">
                        <button type="button" class="btn-edit" onclick="showRegistrationForm()">
                            <i class="fas fa-edit"></i> 등록하기
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="user-info-section" id="bizFormSection" style="display:none;">
            <h3>사업자 등록/변경</h3>
            <form id="biz-form" action="${pageContext.request.contextPath}/my/profile/biznum/signup" method="post"
                  novalidate>
                <div class="form-grid">

                    <!-- 사업자등록번호 -->
                    <div class="form-group">
                        <label for="business-number">사업자등록번호</label>
                        <div class="input-group">
                            <input type="text" id="business-number" name="bizNumber"
                                   inputmode="numeric" maxlength="10"
                                   placeholder="'-' 없이 숫자 10자리"
                                   value="${loginUser.usersBizIdVO.bizNumber}"/>
                        </div>
                        <div class="input-hint">예: 1234567890 (10자리)</div>
                    </div>

                    <!-- 대표자 성명 -->
                    <div class="form-group">
                        <label for="owner-name">대표자 성명</label>
                        <div class="input-group">
                            <input type="text" id="owner-name" name="name"
                                   placeholder="대표자 성명"
                                   value="${loginUser.name}"/>
                        </div>
                    </div>

                    <!-- 상호명 -->
                    <div class="form-group">
                        <label for="company-name">상호명</label>
                        <div class="input-group">
                            <input type="text" id="company-name" name="companyName"
                                   placeholder="사업자등록증 상 상호"
                                   value="${loginUser.usersBizIdVO.companyName}"/>
                        </div>
                        <div class="input-hint">진위확인에는 사용되지 않지만 저장 시 함께 반영됩니다.</div>
                    </div>

                    <!-- 개업일자 -->
                    <div class="form-group">
                        <label for="start-date">개업일자</label>
                        <div class="input-group">
                            <input type="text" id="start-date" name="startDate"
                                   inputmode="numeric" maxlength="8"
                                   placeholder="YYYYMMDD (예: 20230101)"
                                   value="${loginUser.usersBizIdVO.startDate}"/>
                        </div>
                    </div>

                    <!-- 진위 확인 (왼쪽 칸), 오른쪽은 비움 -->
                    <div class="form-group">
                        <div class="verify-row">
                            <button type="button" id="verify-btn" class="btn-zip">
                                <i class="fas fa-shield-check"></i> 진위 확인
                            </button>
                            <div id="verification-result" class="verification-result" aria-live="polite"></div>
                        </div>
                    </div>
                    <div class="empty-cell"></div>

                    <!-- 다음 줄: 사업장 주소 | 사업장 상세주소 -->
                    <div class="form-group">
                        <label for="bizAddress1">사업장 주소</label>
                        <div class="input-group">
                            <input type="text" id="bizAddress1" name="bizAddress1" class="form-control"
                                   placeholder="도로명/지번 주소" readonly="readonly">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="bizAddress2">사업장 상세주소</label>
                        <div class="input-group">
                            <!-- ✅ name 오타 수정: name="bizAddress2" -->
                            <input type="text" id="bizAddress2" name="bizAddress2" class="form-control"
                                   placeholder="동/호, 층수 등 상세주소 입력">
                        </div>
                    </div>

                    <!-- 다음 줄: 우편번호(왼쪽 칸만) -->
                    <div class="form-group zip-stack">
                        <label for="bizPostcode">우편번호</label>
                        <div class="input-group">
                            <input type="text" id="bizPostcode" name="bizPostcode" class="form-control"
                                   placeholder="우편번호" readonly="readonly">
                        </div>


                    </div>
                    <div class="form-group">
                        <label>ㅤ</label>
                        <button type="button" class="btn-zip" onclick="openBizPostcode()">
                            우편번호 찾기
                        </button>
                    </div>
                    <div class="empty-cell"></div>
                </div>


                <div class="form-buttons">
                    <c:url var="homeUrl" value="/"/>
                    <button type="button" class="btn-cancel" onclick="hideRegistrationForm()">
                        취소
                    </button>
                    <button type="submit" class="btn-save" id="save-btn" disabled>
                        저장
                    </button>
                </div>

            </form>
        </div>
    </main>
</div>

<!-- 지도 모달 -->
<div id="mapModal" class="map-modal">
    <div class="map-modal-content">
        <div class="map-modal-header">
            <button type="button" class="close-btn" onclick="closeMapModal()">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <div id="map" class="map-container"></div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&libraries=services"></script>

<script>
    let map = null;
    let geocoder = null;

    function openBizPostcode() {
        new daum.Postcode({
            oncomplete: function (data) {
                var addr = '';
                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }
                document.getElementById("bizPostcode").value = data.zonecode;
                document.getElementById("bizAddress1").value = addr;
                document.getElementById("bizAddress2").focus();
            }
        }).open();
    }

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

    // ESC 키 핸들러
    function handleEscKey(event) {
        if (event.key === 'Escape') {
            closeMapModal();
        }
    }

    // 지도 초기화
    function initializeMap(address, companyName) {
        const mapContainer = document.getElementById('map-inline');

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

                // 인포윈도우 생성
                const infowindow = new kakao.maps.InfoWindow({
                    content: `
                        <div style="padding:10px; text-align:center; min-width:200px; white-space:nowrap;">
                            <strong style="color:#2c3e50;">${loginUser.usersBizIdVO.bizAddress1}</strong><br/>
                            <small style="color:#7f8c8d;">${address}</small>
                        </div>
                    `,
                    removable: false
                });

                // 인포윈도우를 마커 위에 표시
                infowindow.open(map, marker);

                // 지도 중심을 마커 위치로 이동
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

    // 툴팁
    (function () {
        const helpIcon = document.getElementById('help-icon');
        const tooltip = document.getElementById('tooltip-box');
        if (helpIcon && tooltip) {
            const show = () => tooltip.style.display = 'block';
            const hide = () => tooltip.style.display = 'none';
            helpIcon.addEventListener('mouseenter', show);
            helpIcon.addEventListener('mouseleave', hide);
            tooltip.addEventListener('mouseenter', show);
            tooltip.addEventListener('mouseleave', hide);
        }
    })();

    // 폼 토글
    function showRegistrationForm() {
        document.getElementById('bizInfoSection').style.display = 'none';
        document.getElementById('bizFormSection').style.display = 'block';
    }

    function hideRegistrationForm() {
        document.getElementById('bizFormSection').style.display = 'none';
        document.getElementById('bizInfoSection').style.display = 'block';
    }

    // ⭐⭐⭐ 진위 확인 로직 ⭐⭐⭐
    $(function () {
        // '진위 확인' 버튼 클릭 시 실행
        $("#verify-btn").on("click", function () {
            var b_no = $("#business-number").val().trim();
            var p_nm = $("#owner-name").val().trim();
            var start_dt = $("#start-date").val().trim();

            if (!b_no || !p_nm || !start_dt) {
                $("#verification-result")
                    .html('<span class="error-message">사업자등록번호, 대표자 성명, 개업일자를 모두 입력해주세요.</span>');
                return;
            }

            var decodedKey = "hB7FLCcjnhwesbk2GAR97ZcZPJxq0dOsrWAm2x5d77Ns38J7T/GV7ZC52ijJbE413/xdooIuCYAgT2S903Z1Lg==";
            var apiUrl = "https://api.odcloud.kr/api/nts-businessman/v1/validate?serviceKey="
                + encodeURIComponent(decodedKey);
            var payload = {
                "businesses": [
                    {
                        "b_no": b_no,
                        "start_dt": start_dt,
                        "p_nm": p_nm
                    }
                ]
            };
            $("#verification-result").empty();

            $.ajax({
                url: apiUrl,
                type: "POST",
                data: JSON.stringify(payload),
                contentType: "application/json",
                dataType: "json",
                success: function (res) {
                    if (res.data && res.data[0] && res.data[0].valid === '01') {
                        $("#verification-result")
                            .html('<span class="success-message">확인 완료! 국세청에 등록된 정보와 일치합니다.</span>');

                        // 입력 필드를 읽기 전용으로 설정
                        $("#business-number, #owner-name, #company-name, #start-date").prop("readonly", true);

                        // 진위 확인 버튼 비활성화, 저장 버튼 활성화
                        $("#verify-btn").prop("disabled", true);
                        $("#save-btn").prop("disabled", false);
                    } else {
                        $("#verification-result")
                            .html('<span class="error-message">입력한 정보가 일치하지 않거나 유효하지 않은 사업자입니다.</span>');
                        $("#save-btn").prop("disabled", true);
                    }
                },
                error: function () {
                    $("#verification-result")
                        .html('<span class="error-message">진위 확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</span>');
                    $("#save-btn").prop("disabled", true);
                }
            });
        });
    });
</script>

<%-- 공통 하단 --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>