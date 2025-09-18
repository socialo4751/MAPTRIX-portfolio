package kr.or.ddit.user.signup.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.user.UsersBizIdVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.UserService;
import kr.or.ddit.user.signup.step.SignUpStep;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 회원가입 전체 프로세스를 관리하는 컨트롤러
 */

@Slf4j
@Controller
@RequestMapping("/sign-up")
@RequiredArgsConstructor
public class SignUpController {

	private final UserService userService;
	private final PasswordEncoder passwordEncoder;

	// ================== 페이지 이동 (GET) ==================

	/** 1. 약관 동의 페이지 */
	@GetMapping("/agree")
	public String showAgreeForm() {
		return "signup/agree"; // "views/signUp/agree.jsp"
	}

	/** 2. 정보 입력 페이지 */
	@GetMapping("/form")
	public String showSignUpForm() {
		return "signup/form"; // "views/signUp/form.jsp"
	}

	/** 3. 가입 완료 페이지 */
	@GetMapping("/complete")
	public String showSignUpComplete() {
		return "signup/complete"; // "views/signUp/complete.jsp"
	}

	/** 4. 사업자 정보 등록 페이지 (선택) */
	@GetMapping("/biz")
	public String showBizNumberForm() {
		return "signup/bizNumberForm"; // "views/signUp/bizNumberForm.jsp"
	}

	// ================== 프로세스 처리 (POST) ==================

	/** 1 -> 2. 약관 동의 후 정보 입력 페이지로 이동 */
	// 실제로는 약관 동의 여부를 세션 등에 저장할 수 있음
	@PostMapping("/agree")
	public String processAgree(HttpSession session) {
		session.setAttribute("SIGNUP_STEP", SignUpStep.AGREE);
		return "redirect:/sign-up/form";
	}

	/** 2 -> 3. 정보 입력 후 가입 처리 */

	@PostMapping("/form")
	public String processSignUpForm(@Valid @ModelAttribute UsersVO usersVO, BindingResult bindingResult,
			RedirectAttributes redirectAttributes, HttpSession session) {

		if (bindingResult.hasErrors()) {
			// 에러 메시지를 폼으로 다시 내려보내기
			return "signup/form"; // JSP 경로
		}

		// 비밀번호 암호화
		usersVO.setPassword(passwordEncoder.encode(usersVO.getPassword()));

		// 저장
		userService.signUpUser(usersVO);

		redirectAttributes.addFlashAttribute("userName", usersVO.getName());
		session.setAttribute("SIGNUP_STEP", SignUpStep.COMPLETE);
		
		//
		session.setAttribute("loginUser", usersVO);
		
		return "redirect:/sign-up/complete";
	}

    /** 4. 사업자 정보 등록 처리 */
	// SignUpController.java

	/** 4. 사업자 정보 등록 처리 */
	@PostMapping("/biz")
	public String processBizNumber(
	        @RequestParam("business_number") String businessNumber, 
	        @RequestParam("company_name") String companyName,
	        @RequestParam("start_date") String startDate,
	        @RequestParam("bizPostcode") String bizPostcode, // ▼▼▼▼▼ 추가된 파라미터 ▼▼▼▼▼
	        @RequestParam("bizAddress1") String bizAddress1, // ▼▼▼▼▼ 추가된 파라미터 ▼▼▼▼▼
	        @RequestParam("bizAddress2") String bizAddress2, // ▼▼▼▼▼ 추가된 파라미터 ▼▼▼▼▼
	        HttpSession session,
	        RedirectAttributes redirectAttributes
	) {
	    UsersVO loginUser = (UsersVO) session.getAttribute("loginUser");

	    if (loginUser == null) {
	        log.warn("세션에 로그인 정보가 없어 사업자 정보를 등록할 수 없습니다.");
	        redirectAttributes.addFlashAttribute("error", "로그인 정보가 유효하지 않습니다.");
	        return "redirect:/login"; 
	    }

	    UsersBizIdVO bizVO = new UsersBizIdVO();
	    bizVO.setBizNumber(businessNumber.replaceAll("-", ""));
	    bizVO.setUserId(loginUser.getUserId());
	    bizVO.setCompanyName(companyName);
	    bizVO.setStartDate(startDate);
	    bizVO.setBizPostcode(bizPostcode); // ▼▼▼▼▼ 추가된 필드 설정 ▼▼▼▼▼
	    bizVO.setBizAddress1(bizAddress1); // ▼▼▼▼▼ 추가된 필드 설정 ▼▼▼▼▼
	    bizVO.setBizAddress2(bizAddress2); // ▼▼▼▼▼ 추가된 필드 설정 ▼▼▼▼▼

	    // 서비스 호출
	    int result = userService.registerBusinessNumber(bizVO);

	    if (result > 0) {
	        redirectAttributes.addFlashAttribute("message", "사업자 정보가 성공적으로 등록되었습니다.");
	    } else {
	        redirectAttributes.addFlashAttribute("error", "사업자 정보 등록에 실패했습니다.");
	    }
	    
	    session.removeAttribute("loginUser");
	    session.removeAttribute("SIGNUP_STEP"); 

	    return "redirect:/";
	}

	// ================== AJAX 통신 (데이터 제공) ==================

	/** 아이디 중복 확인 */
	@GetMapping("/checkId")
	@ResponseBody
	public ResponseEntity<Boolean> checkUserId(@RequestParam("userId") String userId) {
		boolean isAvailable = userService.isUserIdAvailable(userId);

		log.info("isAvailable : " + isAvailable);

		return new ResponseEntity<>(isAvailable, HttpStatus.OK);
	}

	/** 업종 대분류 목록 조회 */

	// ResponseEntity는 어떤 종류의 데이터든(List, String, boolean 등) 담을 수 있고,
	// 그 데이터가 어떤 상태(성공, 실패 등)로 보내지는지까지 함께 포장해서 HTTP 표준에 맞게 응답하는 매우 중요한 도구.
	// 자바 객체(List<CodeBizVO>)를 JSON 문자열로 변환하는 것은
	// 스프링에 내장된 Jackson이라는 라이브러리가 자동으로 처리한다.

	@GetMapping("/categories/main")
	@ResponseBody
	public ResponseEntity<List<CodeBizVO>> getMainCategories() {
		List<CodeBizVO> mainCategories = userService.getMainBizCategories();
		return new ResponseEntity<>(mainCategories, HttpStatus.OK);
	}

	/** 업종 중분류 목록 조회 */
	@GetMapping("/categories/sub/{parentCodeId}")
	@ResponseBody
	public ResponseEntity<List<CodeBizVO>> getSubCategories(@PathVariable("parentCodeId") String parentCodeId) {
		List<CodeBizVO> subCategories = userService.getSubBizCategories(parentCodeId);
		return new ResponseEntity<>(subCategories, HttpStatus.OK);
	}
	
	/**
	 * 전체 자치구 목록을 조회합니다. (AJAX용)
	 */
	@GetMapping("/districts")
	@ResponseBody
	public ResponseEntity<List<CodeDistrictVO>> getDistricts() {
		List<CodeDistrictVO> districtList = userService.getAllDistricts();
		return new ResponseEntity<>(districtList, HttpStatus.OK);
	}

	/**
	 * 특정 자치구에 속한 행정동 목록을 조회합니다. (AJAX용)
	 * @param districtId URL 경로에서 추출한 자치구 ID
	 */
	@GetMapping("/dongs/{districtId}")
	@ResponseBody
	public ResponseEntity<List<CodeAdmDongVO>> getDongs(@PathVariable("districtId") int districtId) {
		List<CodeAdmDongVO> dongList = userService.getDongsByDistrict(districtId);
		return new ResponseEntity<>(dongList, HttpStatus.OK);
	}
}
