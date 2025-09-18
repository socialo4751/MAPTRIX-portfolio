package kr.or.ddit.user.my.bizapply.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;

@Controller
@RequestMapping("/my/bizapply/status")
public class MyBizApplyController {
	
	@Autowired
	private StBizApplyService stBizApplyService; // 제공해주신 Service를 주입합니다.
	
    /**
     * 나의 상권 활성화 사업 신청 현황 페이지로 이동
     */
    @GetMapping
    public String myApplyStatus(Model model, Principal principal) {
        // 1. 현재 로그인한 사용자의 ID를 가져옵니다.
        String currentUserId = principal.getName();
        
        // 2. 서비스 메소드에 전달할 파라미터(VO)를 생성합니다.
        StBizApplyVO searchVO = new StBizApplyVO();
        searchVO.setUserId(currentUserId); // VO에 현재 사용자 ID를 설정합니다.
        
        // 3. Service의 stBizApplyList 메소드를 호출하여 신청 목록을 조회합니다.
        List<StBizApplyVO> myApplyList = stBizApplyService.stBizApplyList(searchVO);
        
        // 4. 조회된 목록을 View(JSP)에 전달하기 위해 model에 담습니다.
        model.addAttribute("myApplyList", myApplyList);
        
        // 5. 보여줄 JSP 페이지의 경로를 반환합니다.
        return "my/bizapply/myApplyStatus";
    }
}