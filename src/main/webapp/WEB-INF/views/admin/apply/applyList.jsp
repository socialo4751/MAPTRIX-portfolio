<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>가맹신청 목록 관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
            rel="stylesheet"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"/>
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/adminstyle.css"/>
    <style>
    	.admin-header h2 { font-weight: 800; }
        .admin-header p { margin: 0; color: #6c757d; }
        .table thead th { text-align: center; vertical-align: middle; }
        .chip-btn { border-radius: 9999px; --bs-btn-padding-y: .25rem; --bs-btn-padding-x: .6rem; --bs-btn-font-size: .8rem; font-weight: 600; letter-spacing: -.2px; }
        .chip-badge { font-size: .75rem; font-weight: 600; background-color: var(--bs-gray-100); border: 1px solid rgba(0, 0, 0, .08); margin-left: .4rem; }
        .chips { gap: .375rem; }
        .chip-btn.btn-outline-secondary { color: #212529 !important; border-color: #cfd4da; background-color: #fff; }
        .chip-btn.btn-outline-secondary:hover { color: #000 !important; background-color: #f8f9fa; border-color: #adb5bd; }
        .btn.btn-secondary .chip-badge { background-color: rgba(255, 255, 255, .18); color: #fff; border-color: transparent; }
        .btn.btn-outline-secondary .chip-badge { background-color: #f1f3f5; color: #495057; border-color: #e9ecef; }
    
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

        /* 상호명 셀 전용 레이아웃 */
        .store-cell {
            text-align: left;
        }

        /* 테이블의 text-center 덮어쓰기 */
        .store-cell .cell-inner {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .store-cell .store-name {
            flex: 1 1 auto;
            min-width: 0;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .store-cell .btn-map {
            flex: 0 0 auto;
        }

        /* 버튼은 고정 폭/오른
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>
<body>



<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>

    <div id="content">
        <div class="main-container">
            <!-- 제목 + 설명 -->
            <div class="admin-header mb-4" style="margin-top: 60px;">
                <h2>
                    <i class="bi bi-people-fill me-2"></i> 가맹 신청 목록
                </h2>
                <p class="mb-0 text-muted">가맹점 요청을 확인하고 상태를 관리할 수 있습니다.</p>
            </div>
            <!-- 🔍 검색창: 왼쪽 정렬 -->
            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 my-4">
            	<c:url var="urlAll" value="/admin/apply"><c:if test="${not empty searchKeyword}"><c:param name="searchKeyword" value="${not empty searchKeyword ? searchKeyword : keyword}"/></c:if></c:url>
                <c:url var="urlPending" value="/admin/apply"><c:param name="searchType" value="처리중"/><c:if test="${not empty searchKeyword}"><c:param name="searchKeyword" value="${searchKeyword}"/></c:if></c:url>
                <c:url var="urlApproved" value="/admin/apply"><c:param name="searchType" value="승인"/><c:if test="${not empty searchKeyword}"><c:param name="searchKeyword" value="${searchKeyword}"/></c:if></c:url>
                <c:url var="urlRejected" value="/admin/apply"><c:param name="searchType" value="반려"/><c:if test="${not empty searchKeyword}"><c:param name="searchKeyword" value="${searchKeyword}"/></c:if></c:url>

                <div class="d-flex align-items-center flex-wrap chips">
                    <a href="${urlAll}" class="btn chip-btn ${empty searchType ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        전체 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.TOTAL_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlPending}" class="btn chip-btn ${searchType == '처리중' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        처리중 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.PENDING_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlApproved}" class="btn chip-btn ${searchType == '승인' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        승인 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.APPROVED_COUNT}" default="0"/>건</span>
                    </a>
                    <a href="${urlRejected}" class="btn chip-btn ${searchType == '반려' ? 'btn-secondary text-white' : 'btn-outline-secondary'} btn-sm">
                        반려 <span class="badge rounded-pill chip-badge"><c:out value="${statusSummary.REJECTED_COUNT}" default="0"/>건</span>
                    </a>
                </div>

                <form action="/admin/apply" method="get" class="d-flex align-items-center ms-auto flex-wrap gap-1">
                    <input type="hidden" name="searchType" value="${searchType}">
                    <div class="input-group input-group-sm" style="width: 280px;">
                        <input type="text" name="searchKeyword" class="form-control" placeholder="신청자ID, 연락처, 이메일 등" value="${searchKeyword}">
                        <button type="submit" class="btn btn-primary" title="검색"><i class="bi bi-search"></i></button>
                    </div>
                </form>
            </div>
<%--             <div class="mb-4">
                <form action="/admin/apply" method="get"
                      class="row g-2 align-items-center">
                    <div class="col-auto">
                        <input type="text" name="searchKeyword"
                               class="form-control form-control-sm"
                               placeholder="ID, 이름, 이메일, 전화번호 검색" value="${searchKeyword}"
                               style="width: 250px;"/>
                    </div>
                    <div class="col-auto">
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-search"></i> 검색
                        </button>
                    </div>
                </form>
            </div> --%>

            <!-- 메시지 출력 -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <!-- 회원 목록 테이블 -->
            <div class="table-responsive">
                <table
                        class="table table-bordered table-hover align-middle text-center">
                    <thead class="table-light">
                    <tr>
                        <th>요청ID</th>
                        <th>상호명</th>
                        <th>이메일</th>
                        <th>메모</th>
                        <th>전화번호</th>
                        <!-- <th>가입일</th> -->
                        <th>상태</th>
                        <th>관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty articlePage.content and pageContext.request.userPrincipal.principal.usersVO.deptId == 302}">
                            <c:forEach var="user" items="${articlePage.content}">
                                <tr>
                                    <td>${user.applyId}</td>
                                    <td class="store-cell text-start">
                                        <div class="cell-inner">
                                            <span class="store-name">${user.applyStoreName}</span>
                                            <button type="button" class="btn-map"
                                                    onclick="openMapModal('${user.address1}', '${user.applyStoreName}')">
                                                지도보기
                                            </button>
                                        </div>
                                    </td>
                                    <td>${user.userId}</td>
                                    <td>${user.memo}</td>
                                    <td>${user.adminContact}</td>
                                        <%-- <td><fmt:formatDate value="${user.applicatedAt}"
                                                pattern="yyyy-MM-dd HH:mm" /></td> --%>
                                    <td>
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
                                        </c:choose></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status eq '처리중'}">
                                                <button class="btn btn-sm btn-outline-primary"
                                                        data-apply-id="${user.applyId}"
                                                        data-apply-store-name="${user.applyStoreName}"
                                                        data-address1="${user.address1}"
                                                        data-address2="${user.address2}"
                                                        data-jibun-address="${user.jibunAddress}"
                                                        data-postcode="${user.postcode}"
                                                        data-admin-biz-name="${user.adminBizName}"
                                                        data-lat="${user.lat}"
                                                        data-lon="${user.lon}"
                                                        onclick="sendUserStatusUpdate(this)">
                                                    승인
                                                </button>
                                            </c:when>
                                            <c:when test="${user.status eq '승인'}">
                                                승인완료
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="7">가맹사업팀만 작업 할 수 있습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
            <c:if test="${not empty articlePage.content and pageContext.request.userPrincipal.principal.usersVO.deptId == 302}">
	            <div class="pagination-container mt-4 text-center">
	                <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
	            </div>
			</c:if>
        </div>
    </div>
</div>

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

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cd7fce736650d9ad005b3ff7bd12af63&libraries=services"></script>
<script>
    // 요청 상태 변경 요청을 보내는 함수
    function sendUserStatusUpdate(button) {
        console.log(button.dataset.jibunAddress);
        console.log(button.dataset.postcode);
        console.log(button.dataset.adminBizName);

        const user = {
            applyId: button.dataset.applyId,
            applyStoreName: button.dataset.applyStoreName,
            address1: button.dataset.address1,
            address2: button.dataset.address2,
            lat: button.dataset.lat,
            lon: button.dataset.lon,
            jibunAddress: button.dataset.jibunAddress,
            postcode: button.dataset.postcode,
            adminBizName: button.dataset.adminBizName,
        };

        console.log(button.dataset.jibunAddress);

        $.ajax({
            url: '/admin/apply/manage-update-apply',
            method: 'POST',
            contentType: 'application/json', // 데이터를 JSON 형태로 전송
            data: JSON.stringify(user), // 재구성된 user 객체 전송
            success: function (response) {
                if (response.status) {
                    alert(response.msg);
                    location.reload();
                } else {
                    alert('상태 변경 실패: '
                        + response.msg);
                }
            },
            error: function (xhr, status, error) {
                alert('상태 변경 중 오류가 발생했습니다: '
                    + xhr.responseText);
            }
        });
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

    // ESC 키 핸들러
    function handleEscKey(event) {
        if (event.key === 'Escape') {
            closeMapModal();
        }
    }
</script>
</body>
</html>