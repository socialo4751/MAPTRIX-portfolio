<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>알림 내역</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

    <!-- Bootstrap 먼저 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- Icons / Styles -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mypagestyle.css">

    <!-- 페이지 전용 최소 패치 -->
    <style>
        /* 페이지 헤더 톤 통일 */
        .mypage-header h2 {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 6px 0;
            font-family: 'GongGothicMedium', sans-serif;
            color: #2c3e50;
            font-size: 30px;
        }

        .mypage-header p {
            margin: 0;
            color: #7f8c8d;
        }

        /* 카드 간격 */
        .card {
            border-radius: 12px;
            border: 1px solid #e9ecef;
        }

        .card-body {
            padding: 16px;
        }

        /* 검색폼 줄 간격 정리 */
        #searchForm .form-label {
            margin: 0;
            font-weight: 600;
            color: #2c3e50;
        }

        #searchForm .col-auto.separator {
            width: auto;
        }

        /* 테이블 톤/정렬 */
        .table thead th {
            background: #f8f9fa;
            font-weight: 600;
            border-bottom: 1px solid #e9ecef;
        }

        .table td, .table th {
            vertical-align: middle;
        }

        /* 메시지 칼럼 넘침 방지(긴 문장 줄임) */
        .td-message {
            max-width: 0;
        }

        .td-message > .text {
            display: block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* 안읽음 강조 */
        .read-N {
            font-weight: 700;
            color: #0d6efd;
        }

        .notification-item:hover {
            background: #f8f9fa;
        }

        /* 페이징을 카드 푸터 중앙 정렬 */
        .card-footer {
            background: #fff;
            border-top: 1px solid #e9ecef;
        }

        .card-footer nav {
            display: flex;
            justify-content: center;
        }
    </style>
    <%@ include file="/WEB-INF/views/include/top.jsp" %>
</head>

<body>
<div id="wrap">


    <div class="container">
        <!-- 사이드바 활성 탭 -->
        <c:set var="activeMenu" value="activity"/>   <!-- profile | report | activity | apply -->
        <c:set var="activeSub" value="alarm"/>
        <%@ include file="/WEB-INF/views/include/mySideBar.jsp" %>

        <main>
            <div class="mypage-header">
                <h2>알림 내역</h2>
                <p>최근에 받은 알림들을 확인하고 관리할 수 있습니다.</p>
            </div>

            <!-- 검색 영역 -->
            <div class="card mb-3">
                <div class="card-body">
                    <form id="searchForm" name="searchForm" method="get"
                          action="${pageContext.request.contextPath}/my/nt/history" class="row g-2 align-items-center">
                        <div class="col-auto">
                            <label for="startDate" class="form-label">조회 기간</label>
                        </div>
                        <div class="col-auto">
                            <input type="date" class="form-control" id="startDate" name="startDate"
                                   value="${startDate}">
                        </div>
                        <div class="col-auto separator">~</div>
                        <div class="col-auto">
                            <input type="date" class="form-control" id="endDate" name="endDate" value="${endDate}">
                        </div>
                        <div class="col-auto">
                            <button type="submit" class="btn btn-primary">검색</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 목록 -->
            <div class="card">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                            <tr>
                                <th style="width: 10%;" class="text-center">상태</th>
                                <th class="td-message">알림 내용</th>
                                <th style="width: 20%;" class="text-center">발생 시각</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${articlePage.content == null or empty articlePage.content}">
                                    <tr>
                                        <td colspan="3" class="text-center py-5">알림 내역이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="nt" items="${articlePage.content}">
                                        <tr class="notification-item">
                                            <td class="text-center">
                                                <c:if test="${nt.isRead == 'N'}">
                                                    <span class="badge bg-primary read-N">안읽음</span>
                                                </c:if>
                                                <c:if test="${nt.isRead == 'Y'}">
                                                    <span class="badge bg-secondary">읽음</span>
                                                </c:if>
                                            </td>
                                            <td class="td-message">
                                                <span class="text"><c:out value="${nt.message}"/></span>
                                            </td>
                                            <td class="text-center">
                                                <fmt:formatDate value="${nt.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- 페이징 -->
                <div class="card-footer">
                    <nav>
                        <ul class="pagination pagination-sm mb-0">
                            <c:out value="${articlePage.pagingArea}" escapeXml="false"/>
                        </ul>
                    </nav>
                </div>
            </div>
        </main>
    </div>

    <%@ include file="/WEB-INF/views/include/footer.jsp" %>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 페이징 링크에 검색 날짜 자동 부착(안전하게 URL 조립)
    document.addEventListener('DOMContentLoaded', function () {
        const startDate = document.getElementById('startDate')?.value || '';
        const endDate = document.getElementById('endDate')?.value || '';
        if (!startDate && !endDate) return;

        document.querySelectorAll('.pagination .page-link[href]').forEach(function (link) {
            try {
                const u = new URL(link.getAttribute('href'), window.location.origin);
                if (startDate) u.searchParams.set('startDate', startDate);
                if (endDate) u.searchParams.set('endDate', endDate);
                // 상대경로 유지
                link.setAttribute('href', u.pathname + (u.search ? u.search : ''));
            } catch (e) { /* 무시 */
            }
        });
    });
</script>
</body>
</html>
