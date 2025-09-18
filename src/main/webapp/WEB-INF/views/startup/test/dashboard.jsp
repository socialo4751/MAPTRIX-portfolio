<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>MAPTRIX</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- 프로젝트 공용 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/startupstyle.css"/>
    <link rel="icon" href="/favicon.ico" sizes="any">
    <link rel="icon" type="image/png" sizes="32x32" href="/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/favicons/favicon-16x16.png">
    <!-- 페이지 전용(폭 1200px 제한 + 배너/섹션) -->
    <style>
        /* ✅ 폭 1200px로 제한된 전용 컨테이너 */
        .page-container {
            width: 100%;
            max-width: 1200px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            padding: 0 24px 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .04);
        }

        /* 전역에서 min-width가 강제되면 주석 해제
        #wrap { min-width: 0 !important; }
        */
        main.content-wrapper {
            width: 100%;
        }

        .page-header {
            text-align: center;
            margin: 20px 0 6px; /* 위쪽 여백 + 제목과 문구 간격 */
        }

        .page-header h1,
        .page-header h2 {
            margin: 0;
            font-size: 32px;
            font-weight: 800;
            color: #0056b3;
        }

        .note-text {
            text-align: center;
            margin: 0 0 20px; /* 제목 바로 붙고, 아래는 띄움 */
            padding-bottom: 10px; /* 밑줄과 문구 사이 간격 */
            font-size: 15px;
            color: #666;
            border-bottom: 1px solid #eee;
        }

        .progress-bar-container {
            margin: 20px 0 30px; /* 문구와 간격, 아래쪽 여백 */
            display: flex;
            justify-content: center;
        }

        /* 히어로/배너 */
        .main-test-banner {
            background: #2e64fe;
            color: #fff;
            padding: 32px 28px;
            border-radius: 10px;
            margin-bottom: 32px;
            position: relative;
            display: flex;
            align-items: center;
            gap: 24px;
            overflow: hidden;
        }

        .main-test-banner::before {
            content: "";
            position: absolute;
            inset: 0;
            background: radial-gradient(1200px 400px at 80% -10%, rgba(255, 255, 255, .25), transparent 60%),
            linear-gradient(135deg, rgba(255, 255, 255, .08), transparent 60%);
            opacity: .35;
            z-index: 1;
        }

        .main-test-banner .content {
            position: relative;
            z-index: 2;
            flex: 1 1 auto;
        }

        .main-test-banner h3 {
            margin: 0 0 6px;
            font-size: 24px;
            font-weight: 700;
        }

        .main-test-banner p {
            margin: 8px 0 0;
            line-height: 1.6;
            font-size: 15px;
        }

        .main-test-banner .highlight {
            font-weight: 800;
            color: #ffd966;
        }

        .main-test-banner .illustration {
            position: relative;
            z-index: 2;
            width: 240px;
            flex: 0 0 240px;
        }

        .main-test-banner .illustration img {
            display: block;
            max-width: 100%;
            height: auto;
        }

        /* 본문 섹션 카드 */
        .section {
            background: #fff;
            padding: 24px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
            margin-bottom: 24px;
        }

        .section h4 {
            font-size: 20px;
            color: #0056b3;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin: 0 0 16px;
            font-weight: 700;
        }

        .section h5 {
            font-size: 16px;
            color: #007bff;
            margin: 18px 0 8px;
        }

        .section p, .section ul {
            font-size: 15px;
            line-height: 1.7;
            color: #555;
            margin: 0 0 10px;
        }

        .section ul {
            list-style: disc;
            padding-left: 18px;
        }

        .note-text {
            font-size: 13px;
            color: #777;
            text-align: center;
            margin: 20px 0 28px;
            line-height: 1.6;
        }

        /* CTA 버튼 */
        .start-test-button-container {
            text-align: center;
            margin-top: 8px;
        }

        .start-test-button {
            display: inline-block;
            background: #6a1b9a;
            color: #fff;
            text-decoration: none;
            padding: 14px 36px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            box-shadow: 0 4px 10px rgba(0, 0, 0, .2);
            transition: transform .2s ease, box-shadow .2s ease, background .2s;
        }

        .start-test-button:hover {
            background: #4a148c;
            transform: translateY(-2px);
            box-shadow: 0 8px 18px rgba(0, 0, 0, .28);
        }

        /* 반응형 보강 */
        @media (max-width: 992px) {
            .page-container {
                padding: 0 16px 32px;
            }

            .main-test-banner {
                flex-direction: column;
                text-align: left;
            }

            .main-test-banner .illustration {
                width: 60%;
                max-width: 300px;
            }
        }

        @media (max-width: 576px) {
            .main-test-banner {
                padding: 22px 18px;
            }

            .main-test-banner .illustration {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div id="wrap">
    <!-- 전역 상단 -->
    <jsp:include page="/WEB-INF/views/include/top.jsp"/>

    <!-- ✅ 폭 1200px 제한 컨테이너 -->
    <div class="page-container">
        <main role="main" class="content-wrapper">

            <!-- ===== 상단 헤더 (dashboard) ===== -->
            <div style="text-align:center; margin:20px 0 6px;">
                <h1 style="margin:0; font-size:32px; font-weight:800; color:#0056b3;">
                    창업 역량 테스트
                </h1>
            </div>

            <p style="text-align:center; margin:0 0 20px; padding-bottom:10px;
		          font-size:15px; color:#666; border-bottom:1px solid #eee;">
                진행 방법과 유의사항을 확인한 다음 테스트를 시작해보세요.
            </p>

            <!-- 진행바: 어떤 마크업이어도 가운데 정렬되게 래핑 -->
            <div>
                <div style="margin:20px 0 30px;">
                    <div style="display:flex; justify-content:center;">
                        <jsp:include page="/WEB-INF/views/startup/test/testProgressBar.jsp">
                            <jsp:param name="step" value="1"/>
                        </jsp:include>
                    </div>
                </div>
            </div>
            <!-- ===== /상단 헤더 ===== -->


            <!-- 히어로 배너 -->
            <section class="main-test-banner">
                <div class="content">
                    <h3>창업 역량 테스트란?</h3>
                    <p>
                        예비 창업자의 성장과 행동 특성을 진단하여 창업 준비 상태를 점수화해 알아보는 방법입니다.<br>
                        산출된 점수는 <span class="highlight">창업과정</span>과
                        <span class="highlight">사업운영과정</span>에서 발생할 수 있는 상황에 대한
                        <span class="highlight">대처 능력</span>을 스스로 점검하는 데 도움을 줍니다.
                    </p>
                    <p style="margin-top:8px;">창업 역량 테스트 개발 : (주)대덕인재개발원</p>
                </div>
                <div class="illustration">
                    <img src="${pageContext.request.contextPath}/images/startup/test/survey.PNG" alt="설문조사 일러스트"/>
                </div>
            </section>

            <!-- 섹션 1 -->
            <section class="section">
                <h4>1. 개발 목적</h4>

                <h5>① 개발 배경 및 필요성</h5>
                <p>
                    본 창업 역량 테스트는 예비창업자의 준비 상태를 객관적으로 진단하고, 성공적인 창업을 위한
                    정보를 제공하기 위해 개발되었습니다. <br>
                    창업 경험이 부족한 예비창업자는 무엇부터 준비해야 할지 막막함을 느끼기 쉽습니다.
                    이를 해소하고 체계적인 준비를 돕기 위해 체크리스트 기반의 진단 도구를 제공합니다.
                </p>

                <h5>② 진단 가능</h5>
                <ul>
                    <li><strong>시장 분석</strong> : 사업 아이템의 시장 적합성과 기회 탐색</li>
                    <li><strong>계획과 자금</strong> : 사업 계획의 구체성과 자금 조달 역량</li>
                    <li><strong>홍보와 고객</strong> : 고객 확보 및 마케팅 전략 수립 역량</li>
                    <li><strong>마음가짐</strong> : 실행력, 위기관리, 학습 의지 등 창업가 마인드</li>
                </ul>
            </section>

            <!-- 섹션 2 -->
            <section class="section">
                <h4>2. 진단 설계</h4>

                <h5>① 진단 항목 구성</h5>
                <p>
                    창업역량을 기반으로 <strong>시장 분석, 계획과 자금, 홍보와 고객, 마음가짐</strong>의 4개
                    영역으로 구성되며, 각 영역은 세부 질문으로 이루어져 있습니다.
                </p>

                <h5>② 진단 과정</h5>
                <p>
                    각 문항에 대해 현재 상태를 반영하여 응답하면, 시스템이 점수를 산출하고 영역별 강·약점을
                    분석해 제공합니다.
                </p>

                <h5>③ 평가 방법</h5>
                <p>
                    영역별 점수 조합을 통해 사용자를 7가지 창업 특성 유형으로 분류하여 시각적으로 제공합니다.
                    각 유형에는 강점과 보완 포인트에 대한 구체적 코멘트가 포함됩니다.
                </p>

                <h5>④ 영역별 핵심 진단 항목</h5>
                <ul>
                    <li>시장 분석 : 시장 이해, 경쟁 분석, 트렌드 파악, 기회 탐색</li>
                    <li>계획과 자금 : 사업 구체화, 재무 계획, 자금 조달, 위험 관리</li>
                    <li>홍보와 고객 : 마케팅 전략, 고객 관계, 브랜드 구축, 채널 활용</li>
                    <li>마음가짐 : 실행 의지, 긍정적 사고, 회복 탄력성, 자기 주도성</li>
                </ul>
            </section>

            <!-- 안내 문구 -->
            <p class="note-text">
                ※ 본 결과는 사용자의 응답을 기반으로 산출되며, 법적 효력을 갖는 유권해석이 아니므로
                법적 증빙자료로 사용할 수 없습니다.
            </p>

            <!-- CTA -->
            <div class="start-test-button-container">
                <a href="${pageContext.request.contextPath}/start-up/test/test" class="start-test-button">테스트 시작</a>
            </div>
        </main>
    </div>

    <!-- 전역 하단 -->
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</div>
</body>
</html>
