package kr.or.ddit.attraction.apply.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.attraction.point.service.PointService;
import kr.or.ddit.attraction.stamp.vo.StCardVO;
import kr.or.ddit.attraction.stamp.vo.StStampVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/attraction")
public class StampApplyController {

    @Autowired
    private StBizApplyService stBizApplyService;
    
    /**
     * 가맹점 셀렉
     * 내 신청내역만
     */
    @GetMapping("/apply-list")
    public List<StBizApplyVO> myApplyList(StBizApplyVO info, @AuthenticationPrincipal CustomUser customUser) {
    	
		/*
		 * List<StBizApplyVO> resultMap = null; if (customUser == null) { return
		 * resultMap; }
		 */
    	
    	//내 아이디정보 set
    	info.setStatus("승인");
    	
    	List<StBizApplyVO> list = stBizApplyService.stBizApplyList(info);
    	
    	return list;
    }
    
    /**
     * 스탬프가맹점 폼 인서트
     */
    @PostMapping("/insert-apply-form")
    public Map<String, Object> insertApply(@RequestBody StBizApplyVO info, @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> resultMap = new HashMap<>();
		
		if (customUser == null) {
			resultMap.put("msg", "로그인을 해주세요");
		    resultMap.put("status", false);
			return resultMap;
		}
	    
		try {
            String userId = customUser.getUsersVO().getUserId();
            info.setUserId(userId);
            
//             서비스 계층으로 데이터 전달
            int row = stBizApplyService.insertStBizApply(info);
            
            if(row > 0) {
            	resultMap.put("msg", "신청이 성공적으로 접수되었습니다.");
                resultMap.put("status", true);
            }else {
            	resultMap.put("msg", "신청 중 오류");
                resultMap.put("status", false);
            }

        } catch (Exception e) {
            log.error("가맹점 신청 중 오류 발생: {}", e.getMessage());
            resultMap.put("msg", "신청 처리 중 오류가 발생했습니다.");
            resultMap.put("status", false);
        }

        return resultMap;
    }
}
