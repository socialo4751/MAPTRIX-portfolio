<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>만족도 조사</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

    <%@ include file="/WEB-INF/views/include/top.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/csstyle.css">
</head>
<body>
<div class="container">
    <c:set var="activeMenu" value="survey"/>
    <%@ include file="/WEB-INF/views/include/csSideBar.jsp" %>

    <main>
        <div class="page-header">
            <h2 style="display: flex; align-items: center; gap: 8px; position: relative;">
                설문 조사
            </h2>
        </div>

        <div class="filter-bar mb-3" style="margin-top: -25px">


            <c:if test="${readOnly}">
                <div class="alert alert-info d-flex align-items-center gap-2 mb-3">
                    <span class="material-icons">lock</span>
                    이미 응답한 설문입니다. (읽기 전용)
                    <c:if test="${not empty submittedAt}">
                        &nbsp;| 제출일:
                        <fmt:formatDate value="${submittedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/cs/survey/submit"
                  method="post"
                  class="mt-4 px-2"
                  <c:if test="${not readOnly}">onsubmit="return validateSurvey();"</c:if>>
                <sec:csrfInput/>


                <input type="hidden" name="surveyId" value="${survey.surveyId}"/>

                <c:choose>
                    <c:when test="${not empty survey.questions}">

                        <c:choose>
                            <c:when test="${readOnly}">
                                <fieldset disabled="disabled">

                                    <c:forEach var="q" items="${survey.questions}">
                                        <div class="mb-4">
                                            <h5 style="margin-bottom: -10px;">${q.questionOrder}. ${q.questionText}</h5>
                                            <br>
                                            <c:forEach var="opt" items="${q.options}">
                                                <div class="form-check">
                                                    <input class="form-check-input"
                                                           type="radio"
                                                           name="question_${q.questionId}"
                                                           id="q${q.questionId}_o${opt.optionId}"
                                                           value="${opt.optionValue}"
                                                           <c:if test="${not empty selectedMap and selectedMap[q.questionId] eq opt.optionId}">checked</c:if>

                                                    />
                                                    <label class="form-check-label"
                                                           for="q${q.questionId}_o${opt.optionId}">
                                                            ${opt.optionText}
                                                    </label>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:forEach>
                                </fieldset>
                            </c:when>

                            <c:otherwise>

                                <c:forEach var="q" items="${survey.questions}">
                                    <div class="mb-4">
                                        <h5 style="margin-bottom: -10px;">${q.questionOrder}. ${q.questionText}</h5>
                                        <br>
                                        <c:forEach var="opt" items="${q.options}">
                                            <div class="form-check">
                                                <input class="form-check-input"
                                                       type="radio"
                                                       name="question_${q.questionId}"
                                                       id="q${q.questionId}_o${opt.optionId}"
                                                       value="${opt.optionValue}"
                                                       <c:if test="${not empty selectedMap and selectedMap[q.questionId] eq opt.optionId}">checked</c:if>
                                                />
                                                <label class="form-check-label"
                                                       for="q${q.questionId}_o${opt.optionId}">
                                                        ${opt.optionText}
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>


                        <c:if test="${not readOnly}">
                            <div class="text-center mt-4">
                                <button type="submit" class="btn btn-primary px-4">
                                    설문 제출
                                </button>
                            </div>
                        </c:if>
                    </c:when>

                    <c:otherwise>
                        <div class="alert alert-warning text-center">
                            설문 문항이 없습니다.
                        </div>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </main>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function validateSurvey() {
        const READ_ONLY = ${readOnly ? 'true' : 'false'};
        if (READ_ONLY) return false;

        const form = document.querySelector("form");
        const questionInputs = form.querySelectorAll("input[type='radio']");

        const nameMap = {};
        questionInputs.forEach(input => {
            const name = input.name;
            if (!nameMap[name]) nameMap[name] = [];
            nameMap[name].push(input);
        });

        for (let name in nameMap) {
            const isChecked = nameMap[name].some(input => input.checked);
            if (!isChecked) {
                alert("모든 문항에 응답해주세요.");
                return false;
            }
        }
        return true;
    }
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
</body>
</html>
