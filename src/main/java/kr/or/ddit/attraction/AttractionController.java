package kr.or.ddit.attraction;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


//사실상 무의미한 메소드들 아닌가 싶지만
// 메소드는 변경 안하기로 했으니 남겨둠.

@Controller
@RequestMapping("/attraction") // 기존 경로 유지
public class AttractionController {

	
	@GetMapping("/fes-info")
	public String fesInfo() {
		return "attraction/fesInfo";
	}
	
	@GetMapping("/store-lank")
	public String storeLank() {
		return "attraction/storeLank";
	}
	
	@GetMapping("/stamp-store")
	public String stampstore() {
		return "attraction/stampStore";
	}
}
