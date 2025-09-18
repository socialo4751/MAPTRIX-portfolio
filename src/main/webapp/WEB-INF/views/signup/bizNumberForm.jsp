<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="step" value="${sessionScope.SIGNUP_STEP}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">

    <!-- 공통 회원가입 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/signupstyle.css"/>

    <style>
        /* STEP 04 전용 카드 스타일 */
        .form-container {
            background: #fff;
            padding: 40px 30px;
            margin-bottom: 30px;
        }

        .form-container h3 {
            font-size: 22px;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .description {
            text-align: center;
            color: #555;
            background: #f5f7fa;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        /* 입력 & 버튼 그룹 */
        .form-group {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 40px; /* 간격을 40px로 늘려 버튼 간격 확보 */
        }

        .form-group label {
            font-weight: bold;
            margin-bottom: 8px;
        }

        .input-group {
            display: flex;
            width: 100%;
            max-width: 450px;
        }

        .input-group input,
        .input-group button {
            height: 44px; /* 입력창과 버튼 높이 통일 */
        }

        .input-group input {
            flex: 1;
            padding: 0 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 16px;
            background: #f8f9fa;
            line-height: 1.2;
        }

        .input-group button {
            padding: 0 16px;
            border: 1px solid #00695c;
            background: #00695c;
            color: #fff;
            font-size: 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            line-height: 1;
        }

        .input-group button:hover:not(:disabled) {
            background: #00574b;
            transform: translateY(-1px);
        }

        .input-group button:disabled {
            background: #e0e0e0;
            color: #a0a0a0;
            cursor: not-allowed;
        }

        /* 인증 결과 메시지 */
        .verification-result {
            width: 100%;
            max-width: 450px;
            margin-top: 10px;
            font-size: 14px;
            font-weight: bold;
            text-align: center;  /* ← 중앙 정렬로 변경 */
        }

        .success-message {
            color: #00695c;
        }

        .error-message {
            color: #d32f2f;
        }

        /* 하단 버튼 그룹 */
        .form-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 60px; /* 간격을 60px로 늘려 충분한 여백 확보 */
        }

        .btn-primary, .btn-secondary {
            height: 44px; /* 버튼 높이 통일 */
            line-height: 44px;
            padding: 0 24px; /* 좌우 패딩만 남김 */
        }

        /* STEP 04 페이지 아래쪽 <style>에 추가 */
        .form-buttons .btn-primary,
        .form-buttons .btn-secondary {
            display: inline-flex !important;
            align-items: center !important;
            justify-content: center !important;
            height: 44px !important;
            padding: 0 24px !important;
            line-height: normal !important; /* 텍스트 줄맞춤용 */
        }
        .form-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .form-grid .form-group {
            flex: 1 1 45%; /* 두 개가 한 줄에 나열되도록 설정 */
            max-width: 450px;
        }
        /* 진위 확인 버튼 크기 줄이기 */
        .small-btn {
            width: 150px;
            height: 40px;
            padding: 0 12px;
            font-size: 15px;
            background: #00695c;
            color: #fff;
            border: 1px solid #00695c;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
        }

        .small-btn:hover:not(:disabled) {
            background: #00574b;
            transform: translateY(-1px);
        }

        .small-btn:disabled {
            background: #e0e0e0;
            color: #a0a0a0;
            cursor: not-allowed;
        }
        .input-group.justify-center {
            justify-content: center !important;
        }
    </style>
</head>
<body>
<div class="container">
    <main>
        <div class="signup-header"><h2>추가 정보 입력</h2></div>
        <ol class="steps">
            <li class="active">STEP 01. 약관동의</li>
            <li class="active">STEP 02. 정보 입력</li>
            <li class="active">STEP 03. 가입 완료</li>
            <li class="active">STEP 04. 사업자등록번호 등록 (선택)</li>
        </ol>

        <div class="form-container">
            <h3>사업자 정보 등록 (선택)</h3>
            <p class="description">
                사업자등록번호를 등록하시면, 사업자 회원에게 제공되는<br/>
                맞춤형 상권 분석 및 정부 지원사업 추천을 받으실 수 있습니다.
            </p>

            <!-- form 시작 -->
            <form action="<c:url value='/sign-up/biz'/>" method="post">
                <div class="form-grid">
                    <div class="form-group">
                        <label for="business-number">사업자등록번호</label>
                        <div class="input-group">
                            <input type="text" id="business-number" name="business_number" placeholder="'-' 없이 숫자만 입력" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="owner-name">대표자 성명</label>
                        <div class="input-group">
                            <input type="text" id="owner-name" name="owner_name" placeholder="대표자 성명을 입력하세요" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="company-name">상호명</label>
                        <div class="input-group">
                            <input type="text" id="company-name" name="company_name" placeholder="사업자등록증에 기재된 상호명을 입력하세요" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="bizPostcode">사업장 주소</label>
                        <div class="input-group">
                            <input type="text" id="bizPostcode" name="bizPostcode" placeholder="우편번호" readonly="readonly">
                            <button type="button" onclick="openBizPostcode()">우편번호 찾기</button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="bizAddress1">사업장 도로명주소</label>
                        <div class="input-group">
                            <input type="text" id="bizAddress1" name="bizAddress1" placeholder="도로명 주소" readonly="readonly">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="bizAddress2">사업장 상세주소</label>
                        <div class="input-group">
                            <input type="text" id="bizAddress2" name="bizAddress2" placeholder="상세 주소" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="start-date">개업일자</label>
                        <div class="input-group">
                            <input type="text" id="start-date" name="start_date" placeholder="8자리 숫자 입력 (예: 20230101)" />
                        </div>
                    </div>
                </div>

                <!-- 진위 확인 버튼 -->
                <div class="form-group" style="margin-top: 20px;">
                    <div class="input-group justify-center">
                        <button type="button" id="verify-btn" class="small-btn">진위 확인</button>
                    </div>
                    <div id="verification-result" class="verification-result"></div>
                </div>


                <!-- 버튼 -->
                <div class="form-buttons">
                    <c:url var="homeUrl" value="/" />
                    <button type="button" class="btn-secondary" onclick="location.href='${homeUrl}'">나중에 등록하기</button>
                    <button type="submit" class="btn-primary" disabled>등록 완료</button>
                </div>
            </form>

        </div>
    </main>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
	//Daum 주소 API 호출 함수 추가
	function openBizPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            var addr = ''; // 주소 변수
	            if (data.userSelectedType === 'R') { // 도로명 주소를 선택했을 경우
	                addr = data.roadAddress;
	            } else { // 지번 주소를 선택했을 경우
	                addr = data.jibunAddress;
	            }
	            document.getElementById("bizPostcode").value = data.zonecode;
	            document.getElementById("bizAddress1").value = addr;
	            document.getElementById("bizAddress2").focus();
	        }
	    }).open();
	}
	
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

            var decodedKey = "hB7FLCcjnhwesbk2GAR97ZcZPJxq0dOsrWAm2x5d77Ns38J7T/GV7ZC52ijJbE413/xdooIuCYAgT2S903Z1Lg=="; // 실제 사용 시에는 본인의 키를 사용하세요.
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

                        // [수정 1] 'disabled'를 'readonly'로 변경하여 폼 제출 시 데이터가 전송되도록 합니다.
                        // [수정 2] '#company-name'을 추가하여 상호명 필드도 함께 읽기 전용으로 만듭니다.
                        $("#business-number, #owner-name, #company-name, #start-date").prop("readonly", true);

                        $("#verify-btn").prop("disabled", true);

                        $("button[type='submit']").prop("disabled", false);
                    } else {
                        $("#verification-result")
                            .html('<span class="error-message">입력한 정보가 일치하지 않거나 유효하지 않은 사업자입니다.</span>');
                    }
                },
                error: function () {
                    $("#verification-result")
                        .html('<span class="error-message">진위 확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.</span>');
                }
            });
        });
    });
</script>
</body>
</html>
