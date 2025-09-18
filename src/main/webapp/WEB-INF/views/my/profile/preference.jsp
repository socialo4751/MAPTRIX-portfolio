<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>관심구역 & 관심업종 설정</title>

<!-- 공통 리소스 -->
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />

<!-- 마이페이지 공통 스타일 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/mypagestyle.css" />

<link rel="preload"
	href="https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff"
	as="font" type="font/woff" crossorigin>
<style>
@font-face {
	font-family: 'GongGothicMedium';
	src:
		url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_20-10@1.0/GongGothicMedium.woff')
		format('woff');
	font-weight: 700;
	font-style: normal;
}

body, html {
	font-family: 'Pretendard Variable', Pretendard, sans-serif;
	margin: 0;
	padding: 0;
}

h5 {
	font-family: 'GongGothicMedium', sans-serif;
}

/* ✅ 레이아웃 관련: container/aside/main은 mypagestyle.css 규칙을 사용하므로 여기선 건드리지 않음 */

/* 내부 카드/리스트 스타일 (기존 유지) */
.card-container {
	display: flex;
	justify-content: space-between;
	margin-top: 20px;
	gap: 20px;
}

.card-custom {
	width: 50%;
	border-radius: 0.5rem;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	border: none;
}

.card-header {
	background: linear-gradient(135deg, rgba(4, 26, 47, 0.87), #0a3d62);
	color: #fff;
	text-align: center;
	font-weight: bold;
	font-size: 1.5em;
	padding: 20px;
	border-top-left-radius: 0.5rem;
	border-top-right-radius: 0.5rem;
}

.card-header h5 {
	margin: 0;
	font-size: 1.8rem;
}

.card-custom.biz .card-header {
	background: linear-gradient(135deg, rgba(40, 167, 69, 0.87), #218838);
}

.card-body-content {
	min-height: 150px;
	padding: 20px;
}

.no-preference-message {
	color: #6c757d;
	text-align: center;
	padding-top: 50px;
	font-size: 1.2rem;
}

.list-group-item {
	display: flex;
	align-items: center;
	font-size: 1.1rem;
	padding: 12px 0;
	border-bottom: 1px dotted #ccc;
}

.list-group-item:last-child {
	border-bottom: none;
}

.card-footer {
	background-color: #f8f9fa;
	border-top: 1px solid #e9ecef;
	padding: 15px;
	text-align: center;
}

.btn-outline-primary, .btn-outline-success {
	font-family: 'Pretendard Variable', Pretendard, sans-serif;
	font-weight: bold;
	border-width: 2px;
	padding: 12px 30px;
	font-size: 1.05rem;
	border-radius: 5px;
}

.item-icon {
	color: #0a3d62;
	margin-right: 14px;
	font-size: 1.2em;
}

.item-icon.biz {
	color: #28a745;
}

.item-text {
	flex-grow: 1;
}

/* 모달 폼 */
.modal-body .row {
	align-items: center;
	margin-bottom: 16px;
}

.modal-body label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
	color: #495057;
}

.modal-body select.form-control {
	font-size: 1rem;
	height: calc(1.5em + .75rem + 2px);
}

.input-group-append .btn {
	height: 100%;
	padding: 0.375rem 0.75rem;
	font-size: 1.25rem;
	line-height: 1;
	display: flex;
	align-items: center;
	justify-content: center;
}

.modal-body h6 {
	margin-top: 12px;
	margin-bottom: 10px;
	font-weight: bold;
	color: #0a3d62;
}

.selected-list {
	list-style: none;
	padding: 0;
	border: 1px solid #ddd;
	border-radius: 6px;
	max-height: 220px;
	overflow-y: auto;
}

.selected-list li {
	padding: 10px 12px;
	border-bottom: 1px solid #eee;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.selected-list li:last-child {
	border-bottom: none;
}

/* 반응형 */
@media ( max-width : 992px) {
	.card-container {
		flex-direction: column;
	}
	.card-custom {
		width: 100%;
	}
}

/* 위치/폭 커스텀 */
#districtModal .modal-dialog {
	margin: 200px auto;
	max-width: 600px;
}

#bizModal .modal-dialog {
	margin: 200px auto;
	max-width: 600px;
}
</style>
<%@ include file="/WEB-INF/views/include/top.jsp"%>
</head>
<body>


	<!-- ✅ 공통 레이아웃: container(플렉스) 안에 사이드바 + main -->
	<div class="container">
		<c:set var="activeMenu" value="profile" />
		<!-- profile | report | activity | apply -->
		<c:set var="activeSub" value="preference" />
		<%@ include file="/WEB-INF/views/include/mySideBar.jsp"%>

		<main>
			<div class="mypage-header">
				<h2
					style="display: flex; align-items: center; gap: 8px; position: relative;">
					관심구역 & 관심업종</h2>
				<p>관심 지역과 관심 업종을 추가/삭제하여 맞춤 정보를 받아보세요.</p>
			</div>
			<div class="card-container">
				<!-- 관심 지역 카드 -->
				<div class="card card-custom">
					<div class="card-header">
						<h5>관심 지역</h5>
					</div>
					<div class="card-body card-body-content">
						<c:choose>
							<c:when test="${not empty user.codeAdmDongVOList}">
								<ul class="list-group list-group-flush" id="currentDistrictList">
									<c:forEach var="dong" items="${user.codeAdmDongVOList}">
										<li class="list-group-item" data-adm-code="${dong.admCode}">
											<i class="fas fa-map-marker-alt item-icon"></i> <span
											class="item-text"><c:out value="${dong.admName}" /></span>
										</li>
									</c:forEach>
								</ul>
							</c:when>
							<c:otherwise>
								<p class="no-preference-message">선호하는 지역이 없습니다.</p>
								<ul class="list-group list-group-flush d-none"
									id="currentDistrictList"></ul>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="card-footer">
						<button type="button" class="btn btn-outline-primary"
							onclick="openDistrictModal()">관심 지역 변경</button>
					</div>
				</div>

				<!-- 관심 업종 카드 -->
				<div class="card card-custom biz">
					<div class="card-header">
						<h5>관심 업종</h5>
					</div>
					<div class="card-body card-body-content">
						<c:choose>
							<c:when test="${not empty user.userMyBizVOList}">
								<ul class="list-group list-group-flush" id="currentBizList">
									<c:forEach var="biz" items="${user.userMyBizVOList}">
										<li class="list-group-item" data-biz-code="${biz.bizCodeId}">
											<i class="fas fa-briefcase item-icon biz"></i> <span
											class="item-text"><c:out value="${biz.bizName}" /></span>
										</li>
									</c:forEach>
								</ul>
							</c:when>
							<c:otherwise>
								<p class="no-preference-message">선호하는 업종이 없습니다.</p>
								<ul class="list-group list-group-flush d-none"
									id="currentBizList"></ul>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="card-footer">
						<button type="button" class="btn btn-outline-success"
							onclick="openBizModal()">관심 업종 변경</button>
					</div>
				</div>
			</div>
		</main>
	</div>

	<!-- 관심 지역 모달 -->
	<div class="modal fade" id="districtModal" tabindex="-1"
		aria-labelledby="districtModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="districtModalLabel">관심 지역 설정</h5>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-6">
							<label for="districtSelect">자치구 선택</label> <select
								class="form-control" id="districtSelect">
								<option value="">자치구 선택</option>
							</select>
						</div>
						<div class="col-md-6">
							<label for="dongSelect">행정동 선택</label> <select
								class="form-control" id="dongSelect" disabled>
								<option value="">행정동 선택</option>
							</select>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						onclick="$('#districtModal').modal('hide')">닫기</button>
					<button type="button" class="btn btn-primary"
						onclick="saveDistricts()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 관심 업종 모달 -->
	<div class="modal fade" id="bizModal" tabindex="-1"
		aria-labelledby="bizModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="bizModalLabel">관심 업종 설정</h5>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-md-6">
							<label for="mainCategorySelect">대분류 선택</label> <select
								class="form-control" id="mainCategorySelect">
								<option value="">대분류 선택</option>
							</select>
						</div>
						<div class="col-md-6">
							<label for="subCategorySelect">중분류 선택</label> <select
								class="form-control" id="subCategorySelect" disabled>
								<option value="">중분류 선택</option>
							</select>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						onclick="$('#bizModal').modal('hide')">닫기</button>
					<button type="button" class="btn btn-success" onclick="saveBizs()">저장</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 스크립트 -->
	<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    $(document).ready(function() {
        // 페이지가 준비되면, 모달을 열기 전에 미리 데이터를 불러올 필요는 없습니다.
        // 모달을 열 때마다 최신 데이터를 불러오는 것이 더 좋습니다.
    });

    /* ---------- 지역 관련 로직 (단일 선택) ---------- */
    function openDistrictModal() {
        loadDistricts(); // 모달 열 때 자치구 목록 로드
        $("#dongSelect").empty().append('<option value="">행정동 선택</option>').prop('disabled', true);
        $('#districtModal').modal('show');
    }

    function loadDistricts() {
        $.get("${pageContext.request.contextPath}/my/profile/preference/districts", function(data) {
            const districtSelect = $("#districtSelect");
            districtSelect.empty().append('<option value="">자치구 선택</option>');
            data.forEach(function(district) {
                districtSelect.append('<option value="' + district.districtId + '">' + district.districtName + '</option>');
            });
        });
    }

    $("#districtSelect").change(function() {
        const districtId = $(this).val();
        const dongSelect = $("#dongSelect");
        dongSelect.empty().append('<option value="">행정동 선택</option>').prop('disabled', true);
        if (districtId) {
            $.get("${pageContext.request.contextPath}/my/profile/preference/dongs/" + districtId, function(data) {
                dongSelect.prop('disabled', false);
                data.forEach(function(dong) {
                    dongSelect.append('<option value="' + dong.admCode + '">' + dong.admName + '</option>');
                });
            });
        }
    });

    function saveDistricts() {
        const selectedAdmCode = $("#dongSelect").val();
        if (!selectedAdmCode) {
            if (!confirm("선택된 지역이 없습니다. 관심 지역을 삭제(초기화)하시겠습니까?")) return;
        }
        const dataToSend = { admCode: selectedAdmCode };

        $.ajax({
            url: "${pageContext.request.contextPath}/my/profile/preference/districts/update",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(dataToSend),
            success: function(response) {
                alert(response);
                $('#districtModal').modal('hide');
                location.reload();
            },
            error: function(xhr) {
                alert("업데이트 실패: " + xhr.responseText);
            }
        });
    }

    /* ---------- 업종 관련 로직 (단일 선택) ---------- */
    function openBizModal() {
        loadMainCategories(); // 모달 열 때 대분류 목록 로드
        $("#subCategorySelect").empty().append('<option value="">중분류 선택</option>').prop('disabled', true);
        $('#bizModal').modal('show');
    }

    function loadMainCategories() {
        $.get("${pageContext.request.contextPath}/my/profile/preference/categories/main", function(data) {
            const mainSelect = $("#mainCategorySelect");
            mainSelect.empty().append('<option value="">대분류 선택</option>');
            data.forEach(function(category) {
                mainSelect.append('<option value="' + category.bizCodeId + '">' + category.bizName + '</option>');
            });
        });
    }

    $("#mainCategorySelect").change(function() {
        const parentCodeId = $(this).val();
        const subSelect = $("#subCategorySelect");
        subSelect.empty().append('<option value="">중분류 선택</option>').prop('disabled', true);
        if (parentCodeId) {
            $.get("${pageContext.request.contextPath}/my/profile/preference/categories/sub/" + parentCodeId, function(data) {
                subSelect.prop('disabled', false);
                data.forEach(function(category) {
                    subSelect.append('<option value="' + category.bizCodeId + '">' + category.bizName + '</option>');
                });
            });
        }
    });

    function saveBizs() {
        const selectedBizCode = $("#subCategorySelect").val();
        if (!selectedBizCode) {
            if (!confirm("선택된 업종이 없습니다. 관심 업종을 삭제(초기화)하시겠습니까?")) return;
        }
        const dataToSend = { bizCodeId: selectedBizCode };

        $.ajax({
            // ★★★★★★★★★★★★ [오타 수정 완료!] ★★★★★★★★★★★★
            url: "${pageContext.request.contextPath}/my/profile/preference/bizs/update",
            // ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(dataToSend),
            success: function(response) {
                alert(response);
                $('#bizModal').modal('hide');
                location.reload();
            },
            error: function(xhr) {
                alert("업데이트 실패: " + xhr.responseText);
            }
        });
    }
</script>


	<%@ include file="/WEB-INF/views/include/footer.jsp"%>
</body>
</html>
