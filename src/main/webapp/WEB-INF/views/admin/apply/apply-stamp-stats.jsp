<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>가맹신청 통계</title>
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
    	#dongStatsChart {
		    height: 350px !important;
		}
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>



<div id="wrapper">
    <%@ include file="/WEB-INF/views/include/adminSideBar.jsp" %>
    <div id="content">
        <div class="main-container">
            <!-- 제목 + 설명 -->
            <div class="admin-header mb-4" style="margin-top: 60px;">
                <h2>
                    <i class="bi bi-people-fill me-2"></i> 행정동별 가맹 통계
                </h2>
                <p class="mb-0 text-muted">가맹점 수가 많은 행정동 순으로 정렬된 목록입니다.</p>
            </div>
            <div class="table-responsive">
		        <table class="table table-bordered table-hover">
		            <thead class="table-light">
		                <tr>
		                    <th scope="col" class="text-center">순위</th>
		                    <th scope="col">행정동</th>
		                    <th scope="col" class="text-end">가맹점 수</th>
		                </tr>
		            </thead>
		            <tbody>
		                <c:choose>
		                    <c:when test="${not empty applyStatsList}">
		                        <c:forEach var="stats" items="${applyStatsList}" varStatus="loop" begin="0" end="2">
		                            <tr>
		                                <td class="text-center">${loop.count}</td>
		                                <td>
		                                    <strong><c:out value="${stats.DONG}"/></strong>
		                                </td>
		                                <td class="text-end">
		                                    <c:out value="${stats.COUNT}"/>개
		                                </td>
		                            </tr>
		                        </c:forEach>
		                    </c:when>
		                    <c:otherwise>
		                        <tr>
		                            <td colspan="3" class="text-center text-muted">통계 정보가 없습니다.</td>
		                        </tr>
		                    </c:otherwise>
		                </c:choose>
		            </tbody>
		        </table>
    		</div>
    		<div class="card my-4">
			    <div class="card-body">
			        <h5 class="card-title"><i class="bi bi-bar-chart"></i> 행정동별 가맹점 분포</h5>
			        <canvas id="dongStatsChart" style="height:150px;"></canvas>
			    </div>
			</div>
        </div>
    </div>
</div>
<script>
    // JSP 데이터를 JS 배열로 변환
    const dongLabels = [];
    const dongCounts = [];

    <c:forEach var="stats" items="${applyStatsList}">
        dongLabels.push("${stats.DONG}");
        dongCounts.push(${stats.COUNT});
    </c:forEach>
    
 	// 최대/최소 구하기
    const maxValue = Math.max(...dongCounts);
    const minValue = Math.min(...dongCounts);

    const barColors = dongCounts.map(value => {
   	  if (value === maxValue) {
   	    return "blue";   // 최댓값 → 파랑
   	  } else if (value === minValue) {
   	    return "red";    // 최솟값 → 빨강
   	  } else {
   	    return "green";  // 기본 → 초록
   	  }
   	});
    
    // 차트 그리기
    const ctx = document.getElementById("dongStatsChart").getContext("2d");
    new Chart(ctx, {
        type: "bar",   // 막대그래프
        data: {
            labels: dongLabels,
            datasets: [{
                label: "가맹점 수",
                data: dongCounts,
                backgroundColor: barColors,
                borderColor: "rgba(54, 162, 235, 1)",
                borderWidth: 1,
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { beginAtZero: true }
            },
            plugins: {
                legend: {
                    display: false, // 범례를 보이도록 설정
                    position: 'top', // 범례 위치를 위쪽으로 설정 (원하는 위치로 변경 가능)
                }
            }
        }
    });
</script>
</body>
</html>