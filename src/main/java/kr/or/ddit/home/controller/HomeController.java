package kr.or.ddit.home.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

//스프링에게 이 클래스를 자바빈으로 등록해달라고 함
@Controller
public class HomeController {

    /*
     요청URI : /
     요청파라미터 :
     요청방식 : get
     */
    //골뱅이GetMapping("/") => 최신 방식
    @RequestMapping(value="/",method=RequestMethod.GET)
    public ModelAndView home() {

        //forwarding : jsp응답
		/*
		spring.mvc.view.prefix=/WEB-INF/views/
		spring.mvc.view.suffix=.jsp
		 */
        //ModelAndView 객체 생성 시 생성자에게 파라미터를 던지면
        // 뷰경로가 됨(/WEB-INF/views/home.jsp)

        return new ModelAndView("home");
    }



}