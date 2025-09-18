package kr.or.ddit.attraction.apply.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/attraction/apply-stamp")
public class StampApplyViewController {

	@Autowired
	StBizApplyService stBizApplyService;
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping
	public String applyStampView(Model model,
			@AuthenticationPrincipal CustomUser customUser) {
		
		StBizApplyVO param = new StBizApplyVO();
    	if (customUser == null) {
    		return "login";
		}else {
			param.setUserId(customUser.getUsersVO().getUserId());
			List<StBizApplyVO> list = stBizApplyService.stBizApplyList(param);
			
			if(list.size() > 0) {
				model.addAttribute("apply", false);
				model.addAttribute("applyList", list);
			}else {
				model.addAttribute("apply", true);
			}
			
			return "attraction/apply-stamp/applyForm";
		}
	}

	@GetMapping("/intro")
	public String intro() {
		return "attraction/apply-stamp/intro";
	}
	
	@GetMapping("/applyStoreList")
	public String apllyStoreList() {
		return "attraction/apply-stamp/applyStoreList";
	}

	@GetMapping("/policy")
	public String policy() {
		return "attraction/apply-stamp/policy";
	}

	@GetMapping("/privacy")
	public String privacy() {
		return "attraction/apply-stamp/privacy";

	}
}
