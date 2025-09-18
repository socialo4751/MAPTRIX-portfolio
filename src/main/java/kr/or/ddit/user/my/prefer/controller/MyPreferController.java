package kr.or.ddit.user.my.prefer.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.user.UserMyBizVO;
import kr.or.ddit.common.vo.user.UserMyDistrictVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.UserService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/profile/preference")
public class MyPreferController {
	
	@Autowired
	private UserService userService;
	
	/**
	 * 관심구역 및 관심업종 설정 페이지를 로드합니다.
	 * 로그인한 사용자의 관심 지역 및 업종 정보를 모델에 담아 뷰로 전달합니다.
	 */
	@GetMapping
    public String preference(Model model) {
        log.info("myPage/preference() 실행 - preference 페이지 로드 시작");
        
        // Spring Security에서 현재 로그인한 사용자 정보(Authentication) 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName(); // 사용자의 ID를 가져옴
        
        // userId를 이용해 UsersVO 정보 전체(관심 지역, 관심 업종 포함)를 조회
        // 이 때, userService.selectByUserId() 메서드가 JOIN 쿼리를 통해
        // codeAdmDongVOList와 codeBizVOList를 모두 가져와야 합니다.
        UsersVO user = userService.findByUserId(userId);
        
        model.addAttribute("user", user);

        // JSP 경로 반환
        return "my/profile/preference";
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
	

	/**
	 * [수정] 사용자의 관심 지역을 단일 항목으로 업데이트합니다.
	 */
	@PostMapping("/districts/update")
	@ResponseBody
	public ResponseEntity<String> updateMyDistrict(@RequestBody UserMyDistrictVO district) { // ★ List<> 제거
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String userId = authentication.getName();
	    
	    log.info("updateMyDistrict() 실행 - userId: {}, district: {}", userId, district);
	    
	    try {
	        // ★ 수정된 서비스 메서드 호출
	        userService.updateMyDistrict(userId, district);
	        return new ResponseEntity<>("관심 지역이 성공적으로 업데이트되었습니다.", HttpStatus.OK);
	    } catch (Exception e) {
	        log.error("관심 지역 업데이트 실패", e);
	        return new ResponseEntity<>("관심 지역 업데이트에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	/**
	 * [수정] 사용자의 관심 업종을 단일 항목으로 업데이트합니다.
	 */
	@PostMapping("/bizs/update")
	@ResponseBody
	public ResponseEntity<String> updateMyBiz(@RequestBody UserMyBizVO biz) { // ★ List<> 제거
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    String userId = authentication.getName();
	    
	    log.info("updateMyBiz() 실행 - userId: {}, biz: {}", userId, biz);
	    
	    try {
	        // ★ 수정된 서비스 메서드 호출
	        userService.updateMyBiz(userId, biz);
	        return new ResponseEntity<>("관심 업종이 성공적으로 업데이트되었습니다.", HttpStatus.OK);
	    } catch (Exception e) {
	        log.error("관심 업종 업데이트 실패", e);
	        return new ResponseEntity<>("관심 업종 업데이트에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}
	
}
