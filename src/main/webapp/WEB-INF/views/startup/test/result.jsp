<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <!-- 라이브러리 -->
    <!-- Chart.js (UMD 빌드) -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4"></script>
    <!-- html2canvas -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <!-- jsPDF -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

    <style>
        /* ✅ 폭 1200px 제한 컨테이너 */
        .page-container {
            width: 100%;
            max-width: 1200px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            padding: 0 24px 40px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, .04);
        }

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
            text-align: center;
        }

        /* 대표 이미지 */
        .result-image-container {
            margin: 12px auto 24px;
            max-width: 360px;
            text-align: center;
        }

        .result-image-container img {
            max-width: 100%;
            height: auto;
            display: block;
            margin: 0 auto;
        }

        /* 유형 설명 */
        .result-type-description {
            margin-bottom: 24px;
        }

        .result-type-description h2 {
            font-size: 40px;
            font-weight: bold;
            color: #333;
            margin: 0 0 20px;
            text-align: center;
        }

        .result-type-description p {
            font-size: 15px;
            line-height: 1.7;
            color: #555;
            background: #f9f9f9;
            padding: 20px;
            border-radius: 8px;
            border: 1px solid #eee;
        }

        /* 차트 + 점수판 영역 */
        .content-area {
            display: flex;
            flex-direction: column; /* ⛳ 세로 쌓기 */
            gap: 18px; /* 카드 간 간격 */
            margin: 18px 0 28px;
        }

        .chart-card, .score-card {
            background: #fff;
            border: 1px solid #eee;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .05);
            padding: 18px;
            width: 100%; /* ⛳ 한 줄 전체 너비 */
            flex: 0 0 auto; /* ⛳ 가로로 늘어나지 않게 */
        }

        .chart-container {
            height: 420px;
        }

        /* 점수판 */
        .score-board {
            display: flex;
            gap: 16px;
            justify-content: space-between;
            align-items: stretch;
            flex-wrap: wrap;
        }

        .score-item {
            flex: 1 1 180px;
            background: #f9fbff;
            border: 1px solid #e7eefc;
            border-radius: 10px;
            padding: 16px;
            text-align: center;
        }

        .score-item h4 {
            margin: 0 0 6px;
            color: #4a5568;
            font-size: 14px;
            font-weight: 700;
        }

        .score-item p {
            margin: 0;
            font-size: 22px;
            font-weight: 800;
            color: #007bff;
        }

        /* 사이트 유도 배너 */
        .site-cta-banner {
            background: #F9F7EF;
            padding: 24px;
            border-radius: 10px;
            margin-top: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, .06);
            text-align: center;
        }

        .site-cta-banner h3 {
            font-size: 20px;
            color: #000;
            margin: 0 0 10px;
            letter-spacing: .5px;
            font-weight: 800;
        }

        .site-cta-banner p {
            font-size: 15px;
            color: #6d4c41;
            line-height: 1.6;
            margin: 0;
        }

        .site-cta-button {
            display: inline-block;
            margin-top: 16px;
            background: #FFB366;
            color: #fff;
            padding: 12px 28px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 800;
            box-shadow: 0 4px 10px rgba(0, 0, 0, .2);
            transition: background .2s ease, transform .2s ease;
        }

        .site-cta-button:hover {
            background: #ef6c00;
            transform: translateY(-2px);
        }

        /* 버튼 영역 */
        .button-container {
            display: flex;
            gap: 12px;
            justify-content: center;
            align-items: center;
            margin-top: 24px;
        }

        .button-container a, .button-container button {
            display: inline-block;
            padding: 12px 28px;
            border-radius: 28px;
            text-decoration: none;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background .2s ease, transform .2s ease, box-shadow .2s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, .12);
        }

        .button-container a {
            background: #28a745;
            color: #fff;
        }

        .button-container a:hover {
            background: #218838;
            transform: translateY(-1px);
        }

        .button-container button {
            background: #dc3545;
            color: #fff;
            border: none;
        }

        .button-container button:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        /* 고지 문구 */
        .disclaimer-text {
            font-size: 13px;
            color: #777;
            text-align: center;
            margin: 18px auto 24px;
            max-width: 980px;
            line-height: 1.6;
        }

        .disclaimer-text .highlight-char {
            color: #e53935;
            font-weight: 800;
        }

        /* 인쇄/PDF 최적화 */
        .no-print {
        }

        @media print {
            .no-print,
            .progress-bar-container {
                display: none !important;
            }

            body {
                margin: 0 !important;
                padding: 0 !important;
            }

            .page-container {
                max-width: 100% !important;
                padding: 0 !important;
                margin: 0 auto !important;
                box-shadow: none !important;
                border-radius: 0 !important;
            }

            .result-title {
                margin: 16px 0 !important;
                font-size: 24px !important;
            }
        }

        @media (max-width: 768px) {
            .result-title {
                font-size: 26px;
            }
        }
    </style>
</head>
<body>
<div id="wrap">
    <!-- 전역 상단 -->
    <jsp:include page="/WEB-INF/views/include/top.jsp"/>

    <!-- ✅ 페이지 컨테이너 (1200px 제한) -->
    <div class="page-container">

        <!-- ===== 상단 헤더 (result) ===== -->
        <div style="text-align:center; margin:52px 0 6px;">
            <h1 style="margin:0; font-size:32px; font-weight:800; color:#0056b3;">
                창업 역량 테스트 결과
            </h1>
        </div>

        <p style="text-align:center; margin:0 0 20px; padding-bottom:10px;
	          font-size:15px; color:#666; border-bottom:1px solid #eee;">
            당신의 창업 역량 결과를 한눈에 확인하세요.
        </p>

        <div>
            <div style="margin:20px 0 30px;">
                <div style="display:flex; justify-content:center;">
                    <jsp:include page="/WEB-INF/views/startup/test/testProgressBar.jsp">
                        <jsp:param name="step" value="3"/>
                    </jsp:include>
                </div>
            </div>
        </div>
        <!-- ===== /상단 헤더 ===== -->

        <!-- 대표 이미지 -->
        <div class="result-image-container">
            <img src="${imagePath}" alt="${resultType} 대표 이미지">
        </div>

        <!-- 유형 설명 -->
        <div class="result-type-description">
            <h2>${resultType}</h2>
            <p>${resultDesc}</p>
        </div>

        <!-- 차트 + 점수판 -->
        <div class="content-area">
            <section class="chart-card">
                <div class="chart-container">
                    <canvas id="myRadarChart"></canvas>
                </div>
            </section>

            <section class="score-card">
                <div class="score-board">
                    <div class="score-item">
                        <h4>시장 분석</h4>
                        <p>${marketScore}점</p>
                    </div>
                    <div class="score-item">
                        <h4>계획과 자금</h4>
                        <p>${planScore}점</p>
                    </div>
                    <div class="score-item">
                        <h4>홍보와 고객</h4>
                        <p>${prScore}점</p>
                    </div>
                    <div class="score-item">
                        <h4>마음가짐</h4>
                        <p>${mindsetScore}점</p>
                    </div>
                </div>
            </section>
        </div>

        <!-- 사이트 유도 배너 -->
        <div class="site-cta-banner">
            <h3>더 깊이 있는 통찰이 필요하신가요?</h3>
            <p>
                이 창업 체크리스트는 당신의 성공적인 시작을 돕는 첫걸음입니다. MAPTRIX에서 제공하는
                창업 교육, 멘토링, 지원 사업 정보를 적극 활용해 보세요.
            </p>
            <!-- 필요 시 이동 링크 추가 -->
            <!-- <a href="${pageContext.request.contextPath}/somewhere" class="site-cta-button">자세히 보기</a> -->
        </div>

        <p class="disclaimer-text">
            <span class="highlight-char">※</span> 본 결과는 고객이 선택한 근거를 기준으로 산출되었으며,
            법적 효력을 갖는 유권해석이 아니므로 법적 증빙자료로 사용할 수 없습니다.
        </p>

        <div class="button-container no-print">
            <a href="${pageContext.request.contextPath}/start-up/test">테스트 다시하기</a>
            <button id="downloadPdfBtn">PDF로 저장</button>
        </div>
    </div>

    <!-- 전역 하단 -->
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</div>

<script>
    /* ===== 점수 데이터 / 차트 생성 (그대로) ===== */
    const marketScore = ${marketScore};
    const planScore = ${planScore};
    const prScore = ${prScore};
    const mindsetScore = ${mindsetScore};

    const labels = ['시장 분석', '계획과 자금', '홍보와 고객', '마음가짐'];
    const data = {
        labels,
        datasets: [{
            label: '당신의 창업 역량 점수',
            data: [marketScore, planScore, prScore, mindsetScore],
            fill: true,
            backgroundColor: 'rgba(25, 118, 210, 0.18)',
            borderColor: 'rgb(25, 118, 210)',
            pointBackgroundColor: 'rgb(25, 118, 210)',
            pointBorderColor: '#fff',
            pointHoverBackgroundColor: '#fff',
            pointHoverBorderColor: 'rgb(25, 118, 210)'
        }]
    };
    const config = {
        type: 'radar',
        data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            elements: {line: {borderWidth: 3}},
            scales: {
                r: {
                    angleLines: {display: true},
                    grid: {color: 'rgba(0,0,0,0.08)'},
                    pointLabels: {font: {size: 13}, color: '#333'},
                    suggestedMin: 0, suggestedMax: 10,
                    ticks: {stepSize: 2, beginAtZero: true, display: false}
                }
            },
            plugins: {
                legend: {display: true, position: 'top', labels: {font: {size: 13}}},
                title: {display: true, text: '창업 역량 자가진단 결과', font: {size: 18}, color: '#0056b3'}
            }
        }
    };
    const ctx = document.getElementById('myRadarChart').getContext('2d');
    new Chart(ctx, config);

    /* ===== PDF 저장: 한 장에 꽉 채우기 ===== */
    document.getElementById('downloadPdfBtn').addEventListener('click', async function () {
        const element = document.querySelector('.page-container');

        const canvas = await html2canvas(element, {
            scale: 2,
            backgroundColor: "#fff",
            useCORS: true,
            ignoreElements: (el) => {
                if (el.closest && (el.closest('.button-container') || el.closest('.progress-bar-container'))) {
                    return true;
                }
                return false;
            }
        });
        const imgData = canvas.toDataURL('image/jpeg', 0.98);

        const {jsPDF} = window.jspdf;
        const pdf = new jsPDF('p', 'mm', 'a4');

        const pageWidth = pdf.internal.pageSize.getWidth();
        const pageHeight = pdf.internal.pageSize.getHeight();

        const margin = 10;
        let imgW = pageWidth - margin * 2;
        let imgH = (canvas.height * imgW) / canvas.width;
        if (imgH > pageHeight - margin * 2) {
            const ratio = (pageHeight - margin * 2) / imgH;
            imgW = imgW * ratio;
            imgH = pageHeight - margin * 2;
        }
        const x = (pageWidth - imgW) / 2;
        const y = (pageHeight - imgH) / 2;

        pdf.addImage(imgData, 'JPEG', x, y, imgW, imgH);
        pdf.save('창업역량진단결과.pdf');
    });
</script>
</body>
</html>
