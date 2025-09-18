<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>대전광역시 - 일류 경제도시 대전</title>
<!-- <link rel="shortcut icon" type="image/x-icon" href="/images/drh/layout/common/favicon.ico"> -->
<script type="text/javascript" src="/js_leejieun/jquery-1.11.3.min.js"></script>

<script type="text/javascript"
	src="/js_leejieun/common.js?1753161785238"></script>
<link rel="stylesheet" type="text/css"
	href="/css_leejieun/common.css?1753161785238">
<link rel="stylesheet" type="text/css"
	href="/css_leejieun/layout.css?1753161785238">

<!-- <link href="/images/drh/layout/common/favicon.ico" type="image/x-icon" rel="icon"> -->
</head>

<!-- //skip -->
<div id="wrap" class="wrap-main">

	<!-- 공식배너 -->
	<!-- <div class="header-nuri">
        <div class="inner">
            <p>이 누리집은 대한민국 공식 전자정부 누리집입니다.</p>
        </div>
    </div> -->
	<!-- //공식배너 -->


	<!-- header : s -->
	<style>
body, html {
	margin: 0;
	padding: 0;
	font-family: 'Pretendard Variable', Pretendard, sans-serif;
}
</style>
	<header class="wrap-header">
		<div class="header-top">
			<div class="today-info"></div>
			<ul class="user-menu">
				<li>
					<a href="${frontendUrl}/stampMap">스탬프 투어</a>
				</li>
				<sec:authorize access="isAuthenticated()">
					<%-- 로그인한 사용자에게만 보임 --%>
					<li><a> 환영합니다, <%-- principal(CustomUser) 객체 안의 usersVO를 통해 '이름'을 표시합니다. --%>
							<strong><sec:authentication
									property="principal.usersVO.name" /></strong>님!
					</a></li>
					<%-- 권한에 따라 다른 내용 표시 (이하 동일) --%>
					<li><a href="/logout"><i>로그아웃</i></a></li>
				</sec:authorize>
				<sec:authorize access="isAnonymous()">
					<%-- 로그인하지 않은 사용자에게만 보임 --%>
					<li>
						<!-- <p>로그인이 필요합니다.</p> --> <a href="/login"><i>로그인</i></a>
					</li>
					<li><a href="/sign-up/agree"><i>회원가입</i></a></li>
				</sec:authorize>

				<sec:authorize access="hasRole('ADMIN')">
					<%-- 'ADMIN' 권한을 가진 사용자에게만 보임 --%>
					<li>
						<!-- <p style="color: red;">당신은 관리자입니다. 관리자 메뉴에 접근할 수 있습니다.</p> [cite: 3] -->
						<a href="/admin">관리자 대시보드</a>
					</li>
				</sec:authorize>


				<!-- <li>
                    <div class="wrap-select select-sns">
                        <a href="javascript:;" title="클릭시 목록 열기"><i>SNS</i></a>
                        <ul class="select-list" style="">
                            <li><a href="https://www.youtube.com/channel/UCzIgmDjE0lFDu2IhEF_ewOA" target="_blank" title="클릭시 목록 열기" class="icon-youtube"><i>유튜브</i></a></li>
                            <li><a href="https://blog.naver.com/storydaejeon" target="_blank" title="클릭시 목록 열기" class="icon-blog"><i>네이버 블로그</i></a></li>
                            <li><a href="https://www.facebook.com/daejeonstory" target="_blank" title="클릭시 목록 열기" class="icon-facebook"><i>페이스북</i></a></li>
                            <li><a href="https://www.instagram.com/daejeon_official/" target="_blank" title="클릭시 목록 열기" class="icon-instagram"><i>인스타그램</i></a></li>
                            <li><a href="https://pf.kakao.com/_NkUIK" target="_blank" title="클릭시 목록 열기" class="icon-kakao"><i>카카오 채널</i></a></li>
                            <li><a href="https://twitter.com/i/flow/login?redirect_after_login=%2Fdreamdaejeon" target="_blank" title="클릭시 목록 열기" class="icon-twitter"><i>엑스</i></a></li>
                            <li><a href="https://band.us/band/63004733" target="_blank" title="클릭시 목록 열기" class="icon-band"><i>네이버 밴드</i></a></li>
                        </ul>
                    </div>
                </li> -->
				<!-- <li class="sitemap"><a><i>사이트맵</i></a></li> -->
			</ul>
		</div>
		<div id="header" class="gnb-current">
			<h1 id="logo">
				<a href="/"><i>대전광역시</i></a>
			</h1>
			<!-- gnb -->
			<div class="layer-gnb">
				<div class="wrap-cnt">
					<div class="mo-top hidePc">
						<ul class="mo-user-menu">
							<li><a
								href="https://www.daejeon.go.kr/integ/integMemberLogin.do?siteCd=DRH"><i>로그인</i></a>
							</li>
							<li><a href="/integ/registerMember/integMemberJoinClause.do"><i>회원가입</i></a></li>
						</ul>
						<div class="top-menu">
							<a
								href="https://www.daejeon.go.kr/drh/info/sitemap.do?menuSeq=1506"
								class="sitemap-link"><i>사이트맵</i></a>
							<div class="wrap-select select-lang">
								<a href="javascript:;" title="클릭시 목록 열기"><i>Language</i></a>
								<ul class="select-list" style="display: none;">
									<li><a href="https://www.daejeon.go.kr/english/index.do"
										target="_blank" title="클릭시 목록 열기"><i>EN</i></a></li>
									<li><a href="https://www.daejeon.go.kr/japanese/index.do"
										target="_blank" title="클릭시 목록 열기"><i>JP</i></a></li>
									<li><a href="https://www.daejeon.go.kr/chinese/index.do"
										target="_blank" title="클릭시 목록 열기"><i>CH</i></a></li>
								</ul>
							</div>
						</div>
					</div>

					<!-- <ul class="list-sns">
                        <li><a href="https://www.youtube.com/channel/UCzIgmDjE0lFDu2IhEF_ewOA" target="_blank" class="sns-youtube" title="새창"><i>유튜브</i></a></li>
                        <li><a href="https://blog.naver.com/storydaejeon" target="_blank" class="sns-blog" title="새창"><i>네이버 블로그</i></a></li>
                        <li><a href="https://www.facebook.com/daejeonstory" target="_blank" class="sns-facebook" title="새창"><i>페이스북</i></a></li>
                        <li><a href="https://www.instagram.com/daejeon_official/" target="_blank" class="sns-instagram" title="새창"><i>인스타그램</i></a></li>
                        <li><a href="https://pf.kakao.com/_NkUIK" target="_blank" class="sns-kakao" title="새창"><i>카카오 채널</i></a></li>
                        <li><a href="https://twitter.com/i/flow/login?redirect_after_login=%2Fdreamdaejeon" target="_blank" class="sns-twitter" title="새창"><i>엑스</i></a></li>
                        <li><a href="https://band.us/band/63004733" target="_blank" class="sns-band" title="새창"><i>네이버 밴드</i></a></li>
                    </ul> -->
					<nav id="gnb">
						<ul class="depth1">
							<li class="ver-01"><a href="/market/simple"
								class=""><i>상권분석</i></a>
								<div class="depth-cont" id="snb01" style="display: none;">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>상권분석
										</strong>
									</div>
									<ul class="depth2">
										<li><a class="has-sub"><i>상권 분석</i></a>
											<ul class="depth3">
												<li><a href="/market/simple"><i>간단 분석</i></a></li>
												<li><a href="/market/detailed"><i>상세 분석</i></a></li>
												<li><a href="/market/indicators"><i>분석 지표 모아보기</i></a></li>

											</ul></li>
										<li><a class="has-sub"><i>상권 통계</i></a>
											<ul class="depth3">
												<li><a href="/biz-stats/chart"><i>상권 통계</i></a></li>
												<li><a href="/biz-stats/keyword"><i>SNS키워드 분석</i></a></li>
												<li><a href="/biz-stats/franchises"><i>프랜차이즈 지도(임시)</i></a></li>
											</ul></li>

									</ul>
								</div></li>

							<li class="ver-02"><a href="/attraction/apply-stamp/intro" class=""><i>지역특화 정보</i></a>
								<div class="depth-cont" id="snb02"
									style="display: none; height: 566px; padding-top: 0px; margin-top: 0px; padding-bottom: 0px; margin-bottom: 0px;">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>지역특화
										</strong>
									</div>
									<ul class="depth2">
										<li><a href="/attraction" class="has-sub"><i>지역특화정보검색</i></a>
											<ul class="depth3">
												<li><a href="${frontendUrl}/stampMap"><i>지역특화맵</i></a></li>
											</ul></li>
										<li><a href="/attraction/stamp" class="has-sub">스탬프
												투어</i>
										</a>
											<ul class="depth3">
												<li><a href="/attraction/apply-stamp/intro"><i>스탬프 소개</i></a></li>
												<li><a href="/attraction/apply-stamp"><i>스탬프 가맹
															신청 (사업자)</i></a></li>
											</ul></li>
									</ul>
								</div></li>

							<li class="ver-03"><a href="/start-up/main" class=""><i>창업 지원</i></a>
								<div class="depth-cont" id="snb03"
									style="display: none; height: 735px; padding-top: 0px; margin-top: 0px; padding-bottom: 0px; margin-bottom: 0px;">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>창업 지원
										</strong>
									</div>
									<ul class="depth2">

										<li><a href="/start-up/main" class="has-sub"><i>창업 지원 및 컨설팅</i></a>
											<ul class="depth3">
												<li><a href="/start-up/test"><i>창업 역량 테스트</i></a></li>
												<li><a href="/start-up/mt"><i>멘토링 신청</i></a></li>
											</ul></li>

										<li><a href="/start-up/design/main" class="has-sub"><i>내 가게
											만들기</i></a>
											<ul class="depth3">

												<li><a href="${frontendUrl}/Simulator"><i>2D/3D 도면 설계</i></a></li>
												<li><a href="/start-up/show"><i>도면 공유 게시판</i></a></li>
											</ul></li>
									</ul>
								</div></li>
							<li class="ver-04"><a href="/comm/entry" class=""><i>커뮤니티</i></a>
								<div class="depth-cont" id="snb04" style="">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span> 커뮤니티
										</strong>
									</div>
									<ul class="depth2">
										<li><a href="/comm/board" class="has-sub"><i>업종별 게시판 & 채팅</i></a>
											<ul class="depth3">
												<li><a href="/comm/entry"><i>입장하기</i></a></li>
											</ul></li>
										<li><a href="/comm/news" class="has-sub"><i>창업 관련 소식</i></a>
											<ul class="depth3">
												<li><a href="/comm/news"><i>상권 뉴스 모아보기</i></a></li>
												<li><a href="/comm/review"><i>창업 후기 공유</i></a></li>
											</ul></li>
									</ul>
								</div></li>

							<li class="ver-05"><a href="/cs/notice"
								class=""><i>고객센터</i></a>
								<div class="depth-cont" id="snb05"
									style="display: none; height: 769px; padding-top: 0px; margin-top: 0px; padding-bottom: 0px; margin-bottom: 0px;">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>고객센터
										</strong>
									</div>
									<ul class="depth2">
										<li><a href="/cs/notice" class="has-sub"><i>공지사항
													/ Q&A</i></a>
											<ul class="depth3">
												<li><a href="/cs/notice"><i>공지사항</i></a></li>
												<li><a href="/cs/qna"><i>Q&A</i></a></li>

												<li><a href="/cs/freqna"><i>자주
															묻는 질문</i></a></li>

											</ul></li>
										<li><a href="/cs" class="has-sub"><i>만족도 조사</i></a>
											<ul class="depth3">
												<li><a href="/cs/praise"><i>칭찬 게시판</i></a></li>
												<li><a href="/cs/survey"><i>설문 조사</i></a></li>


											</ul></li>
										<li><a href="/cs/org" class="has-sub"><i>조직도</i></a>
											<ul class="depth3">
												<li><a href="/cs/org"><i>조직도</i></a></li>

											</ul></li>
									</ul>
								</div></li>
							<li class="ver-06">
							<a href="/my/profile" class=""><i>마이페이지</i></a>
								<div class="depth-cont" id="snb06" style="">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>마이페이지
										</strong>
									</div>
									<ul class="depth2">
										<li><a href="/my/profile" class="has-sub"><i>나의 정보</i></a>
											<ul class="depth3">
												<li><a href="/my/profile"><i>회원정보 수정</i></a></li>
												<li><a href="/my/profile/biznum"><i>사업자등록번호
															등록</i></a></li>
												<li><a href="/my/profile/district"><i>관심구역
															선택</i></a></li>
												<li><a href="/my/profile/bizcode"><i>관심업종
															선택</i></a></li>
												<li><a href="/my/profile/del"><i>회원
															탈퇴</i></a></li>
											</ul></li>

										<li><a href="/my/market" class="has-sub"><i>상권 분석
													리포트</i></a>
											<ul class="depth3">
												<li><a href="/drh/DrhContentsHtmlView.do?menuSeq=6708"><i>나의
															리포트 조회 및 다운로드</i></a></li>
											</ul>
										</li>
										<li><a href="/my/stamp" class="has-sub"><i>활동 내역
													조회</i></a>
											<ul class="depth3">
												<li><a href="/my/post"><i>게시판
															활동 내역</i></a></li>
												<li><a href="/my/notice"><i>알림
															내역 조회</i></a></li>
											</ul></li>

										<li><a href="/my/stamp" class="has-sub"><i>신청 현황
													조회</i></a>
											<ul class="depth3">
												<li><a href="/my/stampbiz"><i>스탬프
															가맹신청 현황</i></a></li>
												<li><a href="/my/openapi"><i>OPEN
															API 신청 현황 및 다운로드</i></a></li>
											</ul></li>
									</ul>
								</div></li>

							<li class="ver-07"><a href="/openapi" class=""><i>OPEN API</i></a>
								<div class="depth-cont" id="snb07"
									style="display: none; height: 370px; padding-top: 0px; margin-top: 0px; padding-bottom: 0px; margin-bottom: 0px;">
									<div class="depth-tit">
										<strong> <span>일류 경제도시 대전</span>OPEN API 서비스
										</strong>
									</div>
									<ul class="depth2">

										<li><a class="has-sub"><i>오픈 API</i></a>
											<ul class="depth3">
												<li><a href="/openapi/intro"><i>서비스 소개</i></a></li>
												<li><a href="/openapi"><i>API 활용 신청</i></a></li>
											</ul>
										</li>

									</ul>
								</div></li>
						</ul>
					</nav>
					<a href="javascript:;" class="menu-close hidePc"><i>닫기</i></a>
				</div>
			</div>
			<!-- //gnb -->
			<!-- 모바일 검색 -->
			<a href="javascript:;" class="sub-srh-btn"><i>통합검색</i></a>
			<!-- //모바일 검색 -->
			<a href="#menu" class="menu-btn"><i>메뉴</i></a>
		</div>
	</header>

	<!-- container -->
	<section class="wrap-container">
		<!-- 여기안에 컨텐츠가 들어갑니다. -->