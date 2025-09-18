//2023

$(document).ready(function(){
	//상단 select
	$('.wrap-select a').attr('title','클릭시 목록 열기');
	$('.select-list').slideUp();
	$('.wrap-select a').on('click',function(e){
		//e.preventDefault();
		var _this = $(this);

		if(_this.parent().hasClass('on')){
			_this.parent().removeClass('on')
			_this.siblings('.select-list').slideUp();
			_this.attr('title','클릭시 목록 열기');
		}else{
			$('.wrap-select').removeClass('on')
			$('.select-list').slideUp();
			$('.wrap-select a').attr('title','클릭시 목록 열기');
			_this.attr('title','클릭시 목록 닫기');
			
			_this.parent().addClass('on')
			_this.siblings('.select-list').slideDown();
		}
	});

	$(document).mouseup(function(e){
		if($('.wrap-select').has(e.target).length === 0){
			$('.wrap-select').removeClass('on')
			$('.select-list').slideUp();
			$('.wrap-select a').attr('title','클릭시 목록 열기');
		}
	});

	//서브 검색
	$('.sub-srh-btn').on('click',function(e){
		e.preventDefault();

		if($(this).hasClass('is-active')){
			$(this).removeClass('is-active');
			$('.wrap-sub .wrap-srh').hide();
		}else{
			$(this).addClass('is-active');
			$('.wrap-sub .wrap-srh').show();
		}
	});
});

//브라우저 크기 감지
var windowW;
var defaultW = 0;
$(window).on('load resize',function(){
	windowW = $(window).width();

	if(windowW < 767){
		if(defaultW != windowW){
			$('.sub-srh-btn').removeClass('is-active');
			$('.wrap-sub .wrap-srh').hide();
			defaultW = windowW;
		}
	}else{
		$('.wrap-sub .wrap-srh').show();
	}
});

//gnb
$(window).on('load resize', function(){	
	//$("#wrap").css({"height":"auto"});
	var view_w = window.innerWidth;
	var layerGnb = $('.layer-gnb');
	var gnbCurt = $('.gnb-current');
	var gnbType = gnbCurt.attr('class');
	var gnb = $('#gnb li a');
	var depthCont = $('.depth-cont');

	//초기화
	$('html').removeClass('noScroll');
	layerGnb.removeClass('on');
	$('#gnb').off();
	gnbCurt.off();
	$('#gnb ul li a').off().removeClass('is-on, on');
	depthCont.off().removeAttr('style');
	$('.menu-btn').off();

	// for Tab, Mobile
	if(view_w < 1201){
		//Tab, Mobile 초기화
		depthCont.css('display','none');
		$('#gnb .depth2 [class*="depth"]').css('display','none');
		$('.depth2-type02 > li').removeClass('is-active');

		if(gnb.siblings('ul').length || depthCont){
			gnb.siblings('ul').prev('a').addClass('has-sub');
			depthCont.prev('a').addClass('has-sub');
		}

		$('.menu-btn').on('click',function(e){
			e.preventDefault();

			$('html').addClass('noScroll');
			layerGnb.addClass('on');
			$('.sub-srh-btn').removeClass('is-active');
			$('.wrap-sub .wrap-srh').hide();
		});

		$('.menu-close').on('click',function(e){
			e.preventDefault();

			$('html').removeClass('noScroll');
			layerGnb.removeClass('on');
			menuClose();
		});

		function menuClose(){
			$('html').removeClass('noScroll');
			layerGnb.removeClass('on');
			$('#gnb .depth1 a').removeClass('on');
			depthCont.css('display','none');
			$('#gnb .depth2 [class*="depth"]').slideUp();
		}

		layerGnb.on('click',function(e){
			var target = $(e.target);
			if(! target.closest('.layer-gnb .wrap-cnt').length){
				menuClose();
			}
		});

		gnb.on('click',function(e){
			var _this = $(this);

			if(_this.hasClass('has-sub')){
				e.preventDefault();
			}
			
			if(_this.hasClass('on')){
				if(_this.siblings('.depth-cont').length){
					_this.removeClass('on').siblings('.depth-cont').slideUp().children('[class*="depth"]').find('[class*="depth"]').slideUp();
				}
				else{
					_this.removeClass('on').parent().parent('[class*="depth"]').find('[class*="depth"]').slideUp();
				}
			}else{
				_this.parent().parent().find('a').removeClass('on');
				if(_this.siblings('.depth-cont').length){
					_this.removeClass('on').parent().parent('[class*="depth"]').find('.depth-cont').slideUp().children('[class*="depth"]').find('[class*="depth"]').slideUp();
					_this.addClass('on').siblings('.depth-cont').slideDown();
				}
				else{
					_this.removeClass('on').parent().parent('[class*="depth"]').find('[class*="depth"]').slideUp();
					_this.addClass('on').siblings('[class*="depth"]').slideDown();
				}
			}
		});
	}

	// for PC
	else{

		//PC 초기화
		$('#gnb ul ul').removeAttr('style');
		$('.depth2-type02 > li:eq(0)').addClass('is-active');

		//메뉴 형태
		if(gnbCurt){
			if(gnbType.match('type_all')){
				allType();
			}else{
				oneType();
			}
		}
		//모든 메뉴 슬라이드다운
		function allType(){
			var gnbH = gnb.height();

			//메뉴 높이 비교
			var menuH;

			function menuWidth(){
				menuH = 0;
				$('#gnb .depth1 > li .depth-cont').each(function(){
					if(menuH < $(this).innerHeight()){
						menuH = $(this).innerHeight();
					}
				});
			}

			clearTimeout(timer);
			var timer = setTimeout(function(){
				menuWidth();
			}, 200);

			function menuSlideUp(){
				gnbCurt.removeClass('on');
				gnb.removeClass('is-on');
				gnb.parent('li').find('.depth-cont').css('display','none');
				gnbCurt.removeClass('on').css({'height':gnbH});
			}

			gnb.on({
				'mouseover focus' : function(){
					$(this).parent('li').siblings().children('a').removeClass('is-on')
					gnbCurt.addClass('on');
					$(this).addClass('is-on');
					gnb.parent('li').find('.depth-cont').stop().slideDown(300);
					gnbCurt.addClass('on').css({'height':menuH + 140});
				}
			});

			$('#gnb ul ul li:last-child a').on({
				'focusout' : function(){
					$(this).removeClass('is-on');
				}
			});

			$('#gnb .depth1 li:last-child ul li:last-child a').on({
				'focusout' : function(){
					menuSlideUp();
				}
			});

			$('#gnb .depth1 li:first-child > a').on({
				'keydown' : function(e){
					if (e.shiftKey && e.keyCode == 9) {
						menuSlideUp();
					}
				}
			});
	
			gnbCurt.on({
				'mouseleave' : function(){
					menuSlideUp();
				}
			});
		}

		function oneType(){
			if($('#gnb ul ul').length){
				$('#gnb ul ul').prev('a').addClass('has-sub');
			}
	
			$('#gnb ul li a').on({
				'focus' : function(){
					if($(this).parent().parent().hasClass('depth1')){
						$('.depth-cont').stop().slideUp(100);
						$('#gnb ul li a').removeClass('is-on');
					}
					$(this).parent().siblings().children('a').removeClass('is-on');
					$(this).addClass('is-on');
					$(this).siblings('.depth-cont').stop().slideDown();
					$('.wrap-header').addClass('on');
				},
				'keydown' : function(e){
					if (e.shiftKey && e.keyCode == 9) {
						$(this).removeClass('is-on');
						$(this).siblings('.depth-cont').stop().slideUp(100);
						$('.wrap-header').removeClass('on');
					}
				}
			});

			$('.depth1 li').last().children('a').on({
				'focusout' : function(){
					$('.depth-cont').stop().slideUp(100);
					$('.depth1 li a').removeClass('is-on');
					$('.wrap-header').removeClass('on');
				}
			});

			$('#gnb ul > li a').on({
				'mouseover' : function(){
					$(this).parent().siblings().children('a').removeClass('is-on');
					$(this).addClass('is-on');
					$('.wrap-header').addClass('on');

					if($(this).parent().parent().hasClass('depth3')){
						$(this).parent().parent().parent().siblings().children('a').removeClass('is-on');
						$(this).parent().parent().prev('a').addClass('is-on');
					}

					if($(this).parent().parent().hasClass('depth1')){
						$('.depth-cont').stop().slideUp(100);
						$('#gnb ul ul li a').removeClass('is-on');
					}
					$(this).siblings('.depth-cont').stop().slideDown();
				},
			});

			$('#gnb').on({
				'mouseleave' : function(){
					$('.depth-cont').stop().slideUp(100);
					$('#gnb ul li a').removeClass('is-on');
					$('#gnb .depth2').removeClass('is-active');
					$('.wrap-header').removeClass('on');
				}
			});
		}
	}
});

$(window).on('load resize',function(){
	var view_w = window.innerWidth;

	if(view_w > 1200){
		//분야별정보
		$('.depth2-type02 > li > a').on({
			'mouseover focus' : function(){
				$('.depth2-type02 > li').removeClass('is-active');
				$(this).parent().addClass('is-active');
			}
		});
	}
});

//lnb
$(function(){
	var lnbUI = {
		click : function (target, speed) {
			var _self = this,
				$target = $(target);
			_self.speed = speed || 300;

			$target.each(function(){
				if(findChildren($(this))) {
				return; }

			$(this).addClass('no-depth');
			});

			function findChildren(obj) {
				return obj.find('> ul').length > 0;
			}

			$target.on('click','a', function(e){
				e.stopPropagation();
				var $this = $(this),
					$depthTarget = $this.next(),
					$siblings = $this.parent().siblings();

				//$this.parent('li').find('ul li').removeClass('active');
				$siblings.removeClass('is-on');
				$siblings.find('ul').slideUp(250);

				if($depthTarget.css('display') == 'none') {
					_self.activeOn($this);
					$depthTarget.slideDown(_self.speed);
					$siblings.find('li').removeClass('is-');
				} else {
					$depthTarget.slideUp(_self.speed); _self.activeOff($this);
				}
			});

			$('.lnb li.is-on > ul').show();

			$('.lnb li.is-on').addClass('is-current');

			// $('.wrap-lnb').on('mouseleave',function(){
			// 	$('.lnb li').removeClass('is-on').find('ul').hide();
			// 	$('.lnb li.is-current').addClass('is-on').find('>ul').show();
			// });
		},
		activeOff : function($target) {
			$target.parent().removeClass('is-on');
		},
		activeOn : function($target) {
			$target.parent().addClass('is-on')
		}
	};
	// Call lnbUI
	$(function(){
		lnbUI.click('.lnb li', 300)
	});
});


//foot site
$(function(){
	var obj = $('.org-site > li');
	var btn = $('.org-site > li > a');
	var box_btn = $('.link-box');
	var box_btn_close = $('.link-box > a');

	function hideSite(){
		obj.removeClass('on');
		$('.footer-org').removeClass('on');
	}

	btn.on('click',function(e){
		e.preventDefault();
		hideSite();

		if($(this).siblings('.link-box').is(':hidden')){
			hideSite();

			$(this).parent().addClass('on');
			$(this).siblings('.link-box').show();
			$('.footer-org').addClass('on');
		}else{
			hideSite();
			box_btn.hide();
		}
	});

	$(document).mouseup(function(e){
		if(obj.has(e.target).length === 0){
			hideSite();
			box_btn.hide();
		}
	});

	box_btn_close.on('click',function(e){
		e.preventDefault();
		hideSite();
		box_btn.hide();
	});
});

//swiper
function slider(swiperName, loop, pagination, view, margin, speed, direction) {
    //swiper가 1개 이상일떄 해당 js 실행	
    if ($('.swiper-box').length >= 1) {
        var swiperBox = $(swiperName).closest('.swiper-box');
        var stopBtn = swiperBox.find('.swiper-stop');
        var str = swiperBox.find('.swiper-stop i').text();
        var stopTxt = str.replace('정지', '');
        var toucNum = 1;

        //슬라이드 등록 개수가 1개일때 navi삭제 및 터치슬라이드 기능 삭제
        swiperBox.each(function(i) {
            if ($(this).find('.swiper-wrapper .swiper-slide').length == 1) {
                $(this).find('.swiper-navi,.swiper-prev,.swiper-next,.swiper-stop,.swiper-pagination').hide();
                $(this).find('.swiper-slide-duplicate').remove();

                toucNum = 0;
            }
        });

        //swiper.js
        var swiper = new Swiper(swiperName,{
            loop: loop,
            observer: true,
            observeParents: true,
            slidesPerView: 'auto',
            direction: direction,
            loopAdditionalSlides: 1,
            touchRatio: toucNum,
            touchEventsTarget: 'wrapper',
            autoplay: {
                delay: speed,
            },
            pagination: {
                el: swiperBox.find('.swiper-pagination'),
                type: pagination,
                clickable: true,
                renderFraction: function(currentClass, totalClass, index) {
                    return '<span class="' + currentClass + '"></span>' + '<span class="slidestr">/</span>' + '<span class="' + totalClass + '"></span>';
                },
                renderBullet: function(index, className) {
                    return '<a href="#none" class="' + className + '">' + (index + 1) + "</a>";
                },
            },
            navigation: {
                nextEl: swiperBox.find('.swiper-next'),
                prevEl: swiperBox.find('.swiper-prev'),
            },
            on: {
                slideChange: function() {
                    pagNum();
                },
                slidePrevTransitionStart: function() {
                    oneSlider();
                },
                slideNextTransitionStart: function() {
                    oneSlider();
                }
            },
        });

        //슬라이드 focusin했을때 정지, focusout했을때 재생
        if (swiperBox.find('.swiper-stop').css('display') != 'none') {
            $(swiperName).find('.swiper-slide a').focusin(function() {
                $(this).closest('.swiper-box').find('.swiper-stop').addClass('on').find('i').text(stopTxt + '재생');
                swiper.autoplay.stop();
            });

            $(swiperName).find('.swiper-slide a').focusout(function() {
                $(this).closest('.swiper-box').find('.swiper-stop').removeClass('on').find('i').text(stopTxt + '정지');
                swiper.autoplay.start();
            });
        }

        //슬라이드 보여지는 개수 : view, 간격 : margin
        $(swiperName).closest('.swiper-box').attr({
            "data-view": view,
            "data-margin": margin
        });

        //보여지는 슬라이드 개수가 1개일떄 현재 슬라이드만 focus
        function oneSlider() {
            var dataView = $(swiperName).closest('.swiper-box').attr('data-view')
            if (dataView == 1) {
                swiperBox.find('.swiper-slide a').attr('tabindex', '-1');
                swiperBox.find('.swiper-slide-active a').attr('tabindex', '0');
            }
        }

        oneSlider();

        //예) 등록된 슬라이드 개수가 10개면 10까지만 focus
        $(window).on('resize load', function() {
            setTimeout(function() {
                var dataView = $(swiperName).closest('.swiper-box').attr('data-view') - 2

                if ($(swiperName).closest('.swiper-box').attr('data-view') >= 2) {
                    $(swiperName).find('.swiper-slide a').focusin(function() {
                        var slideIndex = $(this).parents('.swiper-slide').attr('data-swiper-slide-index');
                        var slideLoop = slideIndex++;
                        var PagTxt = swiperBox.find('[class*="swiper-pagination"]').last().text();
                        var PagNum = PagTxt - dataView;

                        if (slideIndex < PagNum) {
                            swiper.slideToLoop(slideLoop, 300, true);
                        }
                    });
                }
            }, 300)
        });

        //페이징 숫자가 2자리일경우 앞에 0삭제
        function pagNum() {
            var totalNum = swiperBox.find('.swiper-pagination-total').text();
            var currentNum = swiperBox.find('.swiper-pagination-current').text();
            var total = swiperBox.find('.swiper-pagination-total').prev('.t-num');
            var current = swiperBox.find('.swiper-pagination-current').prev('.c-num');

            (totalNum >= 10) ? total.hide() : total.show();

            (currentNum >= 10) ? current.hide() : current.show();
        }

        pagNum();

        //stop버튼을 클릭했을떄 정지 및 재생
        stopBtn.on({
            click: function() {
                var _this = $(this);
                if (_this.hasClass('on')) {
                    _this.removeClass('on').find('i').text(stopTxt + '정지');
                    swiper.autoplay.start();
                } else {
                    _this.addClass('on').find('i').text(stopTxt + '재생');
                    swiper.autoplay.stop();
                }
            }
        });

        //다음 이전 버튼을 클릭했을떄 슬라이드 정지
        swiperBox.find('[role="button"]').on({
            click: function() {
                $(this).closest('.swiper-box').find('.swiper-stop').addClass('on').find('i').text(stopTxt + '재생')
                swiper.autoplay.stop();
            }
        });

        //stop버튼이 없을때 자동 슬라이드 기능 삭제
        if (swiperBox.find('.swiper-stop').css('display') === 'none') {
            swiperBox.find('.swiper-next').on({
                click: function() {
                    $(this).closest('.swiper-box').find('.swiper-stop').addClass('on').find('i').text(stopTxt + '재생');
                    swiper.autoplay.stop();
                }
            });
            swiperBox.find('.swiper-next').click();
        }

        $('.swiper-slide-duplicate a').attr('tabindex', '-1');

    }
}