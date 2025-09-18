<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="step" value="${sessionScope.SIGNUP_STEP}"/>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MAPTRIX</title>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <link rel="stylesheet" href="/css/signupstyle.css">

    <style>
        .form-buttons {
            display: flex;
            justify-content: center;
            margin-top: 40px;
        }

        .btn-primary, .btn-secondary {
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

        .terms-container {
            margin-top: 30px;
        }

        .terms-box {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 20px;
            margin-bottom: 20px;
            background: #f9f9f9;
        }

        .terms-box h3 {
            margin-top: 0;
            margin-bottom: 10px;
            color: #333;
        }

        .terms-content {
            max-height: 160px;
            overflow-y: auto;
            font-size: 14px;
            line-height: 1.6;
            background: #fff;
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 4px;
        }

        .agreement-check {
            display: flex;
            gap: 20px;
            align-items: center;
            padding-left: 5px;
        }

        .all-agree-box {
            display: flex;
            align-items: center;
            padding: 10px;
            border: 2px solid #00796b;
            background: #e8f5f3;
            margin-bottom: 20px;
            border-radius: 6px;
        }

        .all-agree-box input[type="checkbox"] {
            transform: scale(1.3);
            margin-right: 12px;
        }

        .steps {
            margin-bottom: 20px;
        }

        .signup-header p {
            font-size: 16px;
            color: #444;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <main>
        <div class="signup-header"><h2>회원가입</h2></div>

        <ol class="steps" style="justify-content: center;">
            <ol class="steps" style="justify-content: center;">
    			<li class="active">STEP 01. 약관동의</li>
    			<li>STEP 02. 정보 입력</li>
    			<li>STEP 03. 가입 완료</li>
    			<li>STEP 04. 사업자등록번호 등록 (선택)</li>
			</ol>
        </ol>

        <div class="signup-header">
            <p>회원가입 시, '이용약관'과 '개인정보 수집·이용'에 대한 동의가 필요합니다.</p>
        </div>

        <!-- ✅ 폼 시작 -->
        <form id="agreeForm" action="<c:url value='/sign-up/agree'/>" method="post">
            <div class="terms-container">
                <!-- 이용약관 (필수) -->
                <div class="terms-box">
                    <h3>이용약관 동의 (필수)</h3>
                    <div class="terms-content">
						본 약관은 귀하가 당사 서비스를 이용함에 있어 지켜야 할 권리와 의무, 책임 사항을 규정함을 목적으로 합니다.<br> 
						이 약관은 회원가입 시점부터 효력이 발생하며, 회사는 합리적인 사유가 있을 경우 관련 법령을 위반하지 않는 범위 내에서 본 약관을 개정할 수 있습니다.<br> 
						
						회원은 서비스를 정상적으로 이용하기 위하여 계정을 생성해야 하며, 본 약관에서 정한 의무를 성실히 준수해야 합니다. 
						회사는 서비스 제공과 관련하여 수집한 회원의 정보를 적법하게 활용하며, 안정적인 서비스 제공을 위해 노력합니다. 
						다만 천재지변, 시스템 장애 등 불가항력적인 사유로 인한 서비스 중단에 대해서는 책임을 지지 않습니다.<br> 
						
						또한, 회원은 서비스 내에서 불법적이거나 타인의 권리를 침해하는 행위를 해서는 안 되며, 이를 위반할 경우 서비스 이용이 제한되거나 법적 조치를 받을 수 있습니다.<br>	 
						회사는 회원의 서비스 이용 기록, 게시물 등을 관리할 권리를 가지며, 관련 법령에 따라 필요한 경우 해당 자료를 열람·제공할 수 있습니다. 

                    </div>
                    <div class="agreement-check">
                        <input type="radio" id="agree-terms-yes" name="agreeTerms" value="Y">
                        <label for="agree-terms-yes">동의합니다.</label>
                        <input type="radio" id="agree-terms-no" name="agreeTerms" value="N" checked>
                        <label for="agree-terms-no">동의하지 않습니다.</label>
                    </div>
                </div>

                <!-- 개인정보 수집·이용 (필수) -->
                <div class="terms-box">
                    <h3>개인정보 수집·이용 동의 (필수)</h3>
                    <div class="terms-content">
						회사는 서비스 제공을 위하여 아래와 같은 범위에서 개인정보를 수집·이용합니다.<br>
						수집 항목에는 성명, 생년월일, 휴대전화번호, 이메일 주소, 로그인 ID 및 비밀번호 등이 포함될 수 있으며, 서비스 이용 과정에서 IP 주소, 접속 기록, 쿠키, 이용 로그 등도 자동으로 생성·수집될 수 있습니다.<br> 
						
						수집된 개인정보는 회원 식별, 서비스 제공 및 상담·문의 응대, 계약 이행, 고지사항 전달, 불법·부정 이용 방지, 고객 맞춤형 서비스 제공 등을 위하여 사용됩니다.<br> 
						또한 서비스 품질 향상 및 신규 서비스 개발을 위한 분석 자료로도 활용됩니다.<br> 
						
						회사는 원칙적으로 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않으며, 법령에 따른 요구가 있는 경우에 한해 제한적으로 제공될 수 있습니다.<br> 
						이용자는 개인정보 제공에 동의하지 않을 권리가 있으며, 다만 동의하지 않을 경우 서비스 제공에 제약이 있을 수 있습니다.<br> 
						수집된 개인정보는 서비스 탈퇴 후 일정 기간 보관 의무가 있는 경우를 제외하고 지체 없이 파기됩니다.<br> 
                    </div>
                    <div class="agreement-check">
                        <input type="radio" id="agree-privacy-yes" name="agreePrivacy" value="Y">
                        <label for="agree-privacy-yes">동의합니다.</label>
                        <input type="radio" id="agree-privacy-no" name="agreePrivacy" value="N" checked>
                        <label for="agree-privacy-no">동의하지 않습니다.</label>
                    </div>
                </div>

                <!-- 마케팅 정보 수신 (선택) -->
                <div class="terms-box">
                    <h3>홍보 및 마케팅 목적 동의 (선택)</h3>
                    <div class="terms-content">
						회사는 이벤트 안내, 신규 서비스 출시, 맞춤형 광고 및 혜택 제공을 위하여 귀하의 개인정보(연락처, 이메일, 서비스 이용 기록 등)를 활용할 수 있습니다. 
						이러한 마케팅 목적의 정보는 이메일, 문자메시지, 앱 알림 등을 통해 제공될 수 있습니다. 
						
						동의하실 경우 회원은 다양한 할인 혜택, 프로모션, 맞춤형 추천 서비스를 받아보실 수 있습니다. 
						마케팅 수신 동의 여부와 관계없이 기본적인 서비스 이용에는 제한이 없으며, 회원은 언제든지 마케팅 수신 거부를 요청할 수 있습니다. 
						
						또한, 회사는 보다 나은 서비스 제공을 위해 통계적 분석, 이용자 성향 분석 등을 수행할 수 있으며, 이 과정에서 개인을 직접 식별할 수 없는 형태로 데이터가 가공·활용될 수 있습니다. 
                    </div>
                    <div class="agreement-check">
                        <input type="radio" id="agree-marketing-yes" name="agreeMarketing" value="Y">
                        <label for="agree-marketing-yes">동의합니다.</label>
                        <input type="radio" id="agree-marketing-no" name="agreeMarketing" value="N" checked>
                        <label for="agree-marketing-no">동의하지 않습니다.</label>
                    </div>
                </div>
                <!-- 전체 동의 -->
                <div class="all-agree-box">
                    <input type="checkbox" id="all-agree">
                    <label for="all-agree">모든 약관 내용에 확인하고 전체 동의합니다. (선택항목 포함)</label>
                </div>
                <div class="form-buttons">
                    <button type="submit" class="btn-primary">다음</button>
                </div>


            </div>
        </form>
        <!-- ✅ 폼 끝 -->
    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const allAgree = document.getElementById('all-agree');
        const requiredYes = [
            document.getElementById('agree-terms-yes'),
            document.getElementById('agree-privacy-yes')
        ];
        const requiredNo = [
            document.getElementById('agree-terms-no'),
            document.getElementById('agree-privacy-no')
        ];
        const optionalYes = document.getElementById('agree-marketing-yes');
        const optionalNo = document.getElementById('agree-marketing-no');

        // 전체동의 클릭 시 하위 항목 동기화
        allAgree.addEventListener('change', () => {
            const check = allAgree.checked;
            requiredYes.forEach(r => r.checked = check);
            requiredNo.forEach(r => r.checked = !check);
            optionalYes.checked = check;
            optionalNo.checked = !check;
        });

        // 제출 시 필수항목 검증
        document.getElementById('agreeForm').addEventListener('submit', (e) => {
            const termsOk = document.getElementById('agree-terms-yes').checked;
            const privacyOk = document.getElementById('agree-privacy-yes').checked;

            if (!termsOk || !privacyOk) {
                alert('필수 약관에 동의해야 다음 단계로 진행할 수 있습니다.');
                e.preventDefault();
            }
        });
    });
</script>

</body>
</html>
