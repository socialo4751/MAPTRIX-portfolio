package kr.or.ddit.admin.apply.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.attraction.apply.controller.StampApplyController;
import kr.or.ddit.attraction.apply.service.StBizApplyService;
import kr.or.ddit.attraction.apply.vo.StBizApplyVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin/apply")
@PreAuthorize("hasRole('ADMIN')")
public class AdminApplyController {

    @Autowired
    private StBizApplyService stBizApplyService;
    
    /**
     * 관리자스탬프가맹점 셀렉
     * 모든 가맹요청을 조회
     */
    @GetMapping("/manage-apply-list")
    public List<StBizApplyVO> manageApplyList(StBizApplyVO info, @AuthenticationPrincipal CustomUser customUser) {
    	
    	List<StBizApplyVO> resultMap = null;
    	if (customUser == null) {
			return resultMap;
		}
    	
    	List<StBizApplyVO> list = stBizApplyService.stBizApplyList(info);
    	
    	return list;
    }
    
    /**
     * 스탬프가맹점 폼 업데이트
     */
    @PostMapping("/manage-update-apply")
    public Map<String, Object> manageUpdateApply(@RequestBody StBizApplyVO info, @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> resultMap = new HashMap<>();
		
		if (customUser == null) {
			resultMap.put("msg", "로그인을 해주세요");
		    resultMap.put("status", false);
			return resultMap;
		}
	    
		try {
			info.setStatus("승인");
			
            // 서비스 계층으로 데이터 전달
            int row = stBizApplyService.updateStBizApply(info);
            
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
        
        log.info("insertApplyForm => info :" + info); 

        return resultMap;
    }
	
}
