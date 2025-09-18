package kr.or.ddit.startup.test.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.startup.test.service.TestService;
import kr.or.ddit.startup.test.vo.Test2QuestionsVO;
import kr.or.ddit.startup.test.vo.Test3OptionsVO;
import lombok.extern.slf4j.Slf4j;




@Slf4j
@Controller
@RequestMapping("/start-up/test")
public class SuTestController {

	@Autowired
	TestService testService;

	@GetMapping
	public String testMain() {
		return "startup/test/dashboard";
	}

	// "/test" 주소로 GET 요청이 오면 이 메소드가 실행됨
	@GetMapping("/test")
	public String testStart(Model model) {

		// 1. Service에게 질문과 보기 데이터 묶음을 요청한다.
		Map<Test2QuestionsVO, List<Test3OptionsVO>> questionMap = testService.getTestQuestionsWithOptions();

		// 2. Service에게 받은 데이터를 "questionMap"이라는 이름으로 Model에 담는다.
		model.addAttribute("questionMap", questionMap);

		// 3. Model에 담긴 데이터를 사용할 수 있는 test.jsp 화면을 보여준다.
		return "startup/test/test";
	}

	// ⭐답안 제출을 처리하는 PostMapping 메소드
	@PostMapping("/submit")
	public String testSubmit(@RequestParam Map<String, String> submittedAnswers, Model model) {

		// Service로부터 결과 Map을 받아옵니다. (반환 타입이 Object로 변경됨)
		Map<String, Object> resultMap = testService.calculateAndGetResult(submittedAnswers);

		// Model에 결과 타입과 설명을 담습니다.
		model.addAttribute("resultType", resultMap.get("type"));
		model.addAttribute("resultDesc", resultMap.get("desc"));
		model.addAttribute("imagePath", resultMap.get("imagePath"));

		// ⭐️ [추가] Model에 각 영역의 점수를 담습니다.
		model.addAttribute("marketScore", resultMap.get("marketScore"));
		model.addAttribute("planScore", resultMap.get("planScore"));
		model.addAttribute("prScore", resultMap.get("prScore"));
		model.addAttribute("mindsetScore", resultMap.get("mindsetScore"));

		return "startup/test/result";
	}

}