<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="step" value="${sessionScope.SIGNUP_STEP}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/signupstyle.css">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">

    <style>
    
    	 /* [추가] gender-group 스타일 */
        .gender-group {
            display: flex;
            align-items: center;
            gap: 24px; /* 라디오 버튼 간격 */
        }
        .gender-group label {
            display: flex;
            align-items: center;
            cursor: pointer;
            font-weight: normal; /* 기본 라벨과 동일하게 */
        }
        .gender-group input[type="radio"] {
            margin-right: 8px;
        }
        
        .form-buttons {
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-top: 40px;
        }

        .btn-primary,
        .btn-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 48px;
            padding: 0 28px;
            font-size: 16px;
            font-weight: 500;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-primary {
            background-color: #00796b;
            color: #fff;
        }

        .btn-primary:hover {
            background-color: #00695c;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
            transform: translateY(-1px);
        }

        .btn-secondary {
            background-color: #e0e0e0;
            color: #333;
        }

        .btn-secondary:hover {
            background-color: #d5d5d5;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            transform: translateY(-1px);
        }

        .input-group button,
        .location-group button {
            height: 44px;
            padding: 0 16px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 4px;
            border: 1px solid #bbb;
            background-color: #f5f5f5;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .input-group button:hover,
        .location-group button:hover {
            background-color: #e0e0e0;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

<div class="container">
    <main>
        <div class="signup-header">
            <h2>회원가입</h2>
        </div>

        <ol class="steps">
    		<li class="active">STEP 01. 약관동의</li>
    		<li class="active">STEP 02. 정보 입력</li>
    		<li>STEP 03. 가입 완료</li>
    		<li>STEP 04. 사업자등록번호 등록 (선택)</li>
		</ol>

        <form id="signUpForm" action="<c:url value='/sign-up/form'/>" method="post">
            <h4>기본 정보</h4>

            <div class="form-group">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="birthDate">생년월일</label>
                <input type="date" id="birthDate" name="birthDate" required>
            </div>
            
            <div class="form-group">
                <label>성별</label>
                <div class="gender-group">
                    <label for="gender-m">
                        <input type="radio" id="gender-m" name="gender" value="M"> 남자
                    </label>
                    <label for="gender-f">
                        <input type="radio" id="gender-f" name="gender" value="F"> 여자
                    </label>
                </div>
            </div>
            
            <div class="form-group">
                <label for="userId">아이디</label>
                <div class="input-group">
                    <input type="text" id="userId" name="userId" required>
                    <button type="button" id="btnCheckId">중복 확인</button>
                </div>
                <p id="idCheckMessage" class="message"></p>
            </div>

            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>
                <p></p>
                <p class="help-text">* 영문, 숫자, 특수문자를 포함한 8자 이상의 비밀번호를 입력해주세요.</p>
            </div>
            <div class="form-group">
                <label for="password-confirm">비밀번호 확인</label>
                <input type="password" id="password-confirm" required>
                <p id="passwordCheckMessage" class="message"></p>
            </div>
            <div class="form-group">
                <label for="phoneNumber">휴대전화 번호</label>
                <input type="text" id="phoneNumber" name="phoneNumber" placeholder="'-' 없이 숫자만 입력" required>
            </div>
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="text" id="email" name="email" placeholder="example@example.com" required>
            </div>
            <div class="form-group">
                <label for="postcode">주소</label>
                <div>
                    <div class="location-group">
                        <input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly />
                        <button type="button" id="btnFindPostcode">우편번호 찾기</button>
                    </div>
                    <div class="address-detail-group">
                        <input type="text" id="address1" name="address1" placeholder="기본주소" readonly />
                        <input type="text" id="address2" name="address2" placeholder="상세주소" />
                    </div>
                </div>
            </div>

            <hr style="border: 1px solid #eee; margin: 30px 0;">

            <h4>선택 정보</h4>
            <div class="form-group">
                <label for="interest-region-district">관심 지역 <span class="optional">(선택)</span></label>
                <div class="location-group">
                    <select id="interest-region-district">
                        <option value="">자치구 선택</option>
                    </select>
                    <select id="interest-region-dong" name="userMyDistrictVOList[0].admCode">
                        <option value="">행정동 선택</option>
                    </select>
                </div>
            </div>


            <div class="form-group">
                <label for="interest-category-main">선호 업종</label>
                <div class="category-group">
                    <select id="interest-category-main">
                        <option value="">대분류 선택</option>
                    </select>
                    <select id="interest-category-sub" name="userMyBizVOList[0].bizCodeId">
                        <option value="">중분류 선택</option>
                    </select>
                </div>
            </div>

            <div class="form-buttons">
                <button type="button" class="btn-secondary" onclick="location.href='<c:url value='/sign-up/agree'/>'">이전</button>
                <button type="submit" class="btn-primary">가입하기</button>
            </div>
        </form>
    </main>
</div>

<script
        src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {

        // =======================================================================
        // [신규 추가] 관심 지역 (자치구/행정동) 선택 기능
        // =======================================================================

        // 사용할 DOM 요소
        const districtSelect = document.getElementById('interest-region-district');
        const dongSelect = document.getElementById('interest-region-dong');

        // 자치구/행정동 <option>을 채우는 헬퍼 함수
        const populateLocationSelect = (selectElement, options, valueKey, nameKey, defaultText) => {
            selectElement.innerHTML = ''; // 기존 옵션 초기화
            const defaultOption = document.createElement('option');
            defaultOption.value = "";
            defaultOption.textContent = defaultText;
            selectElement.appendChild(defaultOption);

            if (Array.isArray(options)) {
                options.forEach(item => {
                    const option = document.createElement('option');
                    option.value = item[valueKey];   // ex: item['districtId']
                    option.textContent = item[nameKey]; // ex: item['districtName']
                    selectElement.appendChild(option);
                });
            }
        };

        // 1. 페이지 로딩 시, 전체 자치구 목록 로드
        fetch('<c:url value="/sign-up/districts"/>')
            .then(response => response.json())
            .then(districts => {
                // (select요소, 데이터, option의 value가 될 키, option의 text가 될 키, 기본 텍스트)
                populateLocationSelect(districtSelect, districts, 'districtId', 'districtName', '자치구 선택');
            })
            .catch(error => console.error('자치구 목록 로드 오류:', error));


        // 2. 자치구를 선택했을 때, 해당 구에 속한 행정동 목록 로드
        districtSelect.addEventListener('change', function () {
            const selectedDistrictId = this.value;

            console.log("선택된 자치구 ID:", selectedDistrictId);

            // 자치구를 선택하지 않은 경우, 행정동 목록 초기화
            if (!selectedDistrictId) {
                populateLocationSelect(dongSelect, [], '', '', '행정동 선택');
                return;
            }

            // 선택된 자치구 ID를 포함하여 API 요청
            // 1. URL의 고정된 부분을 먼저 정의합니다.
            const baseUrl = `${contextPath}/sign-up/dongs/`;

            // 2. 단순 더하기(+) 연산으로 변수를 안전하게 붙여줍니다.
            const requestUrl = baseUrl + selectedDistrictId;

            // --- ▲▲▲▲▲ 여기까지가 최종 해결책입니다 ▲▲▲▲▲ ---

            console.log('최종 요청 URL:', requestUrl);

            fetch(requestUrl)
                .then(response => {
                    if (!response.ok) {
                        console.error('서버 응답 오류:', response.status, response.statusText);
                        throw new Error('서버 응답 오류');
                    }
                    return response.json();
                })
                .then(dongs => {
                    populateLocationSelect(dongSelect, dongs, 'admCode', 'admName', '행정동 선택');
                })
                .catch(error => {
                    console.error('행정동 목록 로드 오류:', error);
                });
        });
        // 사용할 DOM 요소
        const mainCategorySelect = document.getElementById('interest-category-main');
        const subCategorySelect = document.getElementById('interest-category-sub');

        // 옵션을 채우는 헬퍼 함수 (수정 없음)
        const populateSelectWithOptions = (selectElement, options, defaultText) => {
            selectElement.innerHTML = '';
            const defaultOption = document.createElement('option');
            defaultOption.value = "";
            defaultOption.textContent = defaultText;
            selectElement.appendChild(defaultOption);
            if (Array.isArray(options)) {
                options.forEach(item => {
                    const option = document.createElement('option');
                    option.value = item.bizCodeId;
                    option.textContent = item.bizName;
                    selectElement.appendChild(option);
                });
            }
        };

        // 대분류 로드 (수정 없음)
        fetch('<c:url value="/sign-up/categories/main"/>')
            .then(response => response.json())
            .then(categories => {
                populateSelectWithOptions(mainCategorySelect, categories, '대분류 선택');
            })
            .catch(error => console.error('대분류 로드 오류:', error));

        // =======================================================================
        // 2. 대분류 선택 시 중분류 목록 로드 (URL 생성 방식 수정)
        // =======================================================================
        mainCategorySelect.addEventListener('change', function () {
            const parentCodeId = this.value;

            if (!parentCodeId) {
                populateSelectWithOptions(subCategorySelect, [], '중분류 선택');
                return;
            }

            // [핵심 수정] URL 생성 방식을 안전한 문자열 더하기(+)로 변경
            const baseUrl = '<c:url value="/sign-up/categories/sub/"/>';
            const requestUrl = baseUrl + parentCodeId;

            console.log('최종 요청 URL:', requestUrl); // 디버깅용 로그

            fetch(requestUrl)
                .then(response => {
                    if (!response.ok) throw new Error('서버 응답 오류');
                    return response.json();
                })
                .then(categories => {
                    populateSelectWithOptions(subCategorySelect, categories, '중분류 선택');
                })
                .catch(error => {
                    console.error('중분류 로드 오류:', error);
                });
        });

        // --- 아이디 중복 확인, 비밀번호 확인 등 나머지 스크립트는 이전과 동일 ---
        const form = document.getElementById('signUpForm');
        const userIdInput = document.getElementById('userId');
        const btnCheckId = document.getElementById('btnCheckId');
        const idCheckMessage = document.getElementById('idCheckMessage');
        const passwordInput = document.getElementById('password');
        const passwordConfirmInput = document.getElementById('password-confirm');
        const passwordCheckMessage = document.getElementById('passwordCheckMessage');
        const btnFindPostcode = document.getElementById('btnFindPostcode');
        let isIdChecked = false;

        userIdInput.addEventListener('input', () => {
            isIdChecked = false;
            idCheckMessage.textContent = '';
        });
        // [핵심 1] JSP를 통해 서버의 기본 경로(Context Path)를 가져와 JS 변수에 저장
        const contextPath = "${pageContext.request.contextPath}";
        // =======================================================================
        // 아이디 중복 확인 (이 부분이 올바르게 수정되었는지 확인)
        // =======================================================================
        btnCheckId.addEventListener('click', () => {
            const userId = userIdInput.value;
            if (!userId) {
                alert('아이디를 입력해주세요.');
                return;
            }

            const baseUrl = `${contextPath}/sign-up/checkId`;

            // ★★★★★ 이 부분입니다! ★★★★★
            // JSP가 아닌 JavaScript 변수를 사용해서 URL을 만듭니다.
            const requestUrl = baseUrl + '?userId=' + encodeURIComponent(userId);

            console.log("아이디 중복 확인 요청 URL:", requestUrl);

            fetch(requestUrl)
                .then(res => {
                    if (!res.ok) throw new Error(`서버 응답 오류: ${res.status}`);
                    return res.json();
                })
                .then(isAvailable => {
                    idCheckMessage.textContent = isAvailable ? '사용 가능한 아이디입니다.' : '이미 사용 중인 아이디입니다.';
                    idCheckMessage.className = isAvailable ? 'message success' : 'message error';
                    isIdChecked = isAvailable;
                })
                .catch(err => {
                    console.error('아이디 중복 확인 중 오류 발생:', err);
                    alert('아이디 중복 확인 중 오류가 발생했습니다.');
                });
        });

        const checkPasswordMatch = () => {
            if (passwordInput.value && passwordConfirmInput.value) {
                const isMatch = passwordInput.value === passwordConfirmInput.value;
                passwordCheckMessage.textContent = isMatch ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.';
                passwordCheckMessage.className = isMatch ? 'message success' : 'message error';
            } else {
                passwordCheckMessage.textContent = '';
            }
        };
        passwordInput.addEventListener('keyup', checkPasswordMatch);
        passwordConfirmInput.addEventListener('keyup', checkPasswordMatch);

        form.addEventListener('submit', (e) => {
            if (!isIdChecked) {
                alert('아이디 중복 확인을 해주세요.');
                e.preventDefault();
                return;
            }
            if (passwordInput.value !== passwordConfirmInput.value) {
                alert('비밀번호가 일치하지 않습니다.');
                e.preventDefault();
                return;
            }
        });

        btnFindPostcode.addEventListener('click', () => {
            new daum.Postcode({
                oncomplete: (data) => {
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById('address1').value = data.address;
                    document.getElementById('address2').focus();
                }
            }).open();
        });
    });
</script>
</body>
</html>
