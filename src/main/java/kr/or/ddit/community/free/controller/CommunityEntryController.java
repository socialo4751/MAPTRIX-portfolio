package kr.or.ddit.community.free.controller;

import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.community.free.service.CodeBizService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/comm")
@RequiredArgsConstructor
//커뮤니티의 입장하기 전 어떤 커뮤니티에 갈지 선택하는 컨트롤러
public class CommunityEntryController {

    private final CodeBizService codeBizService;

    /**
     * 커뮤니티 입장(선택) 페이지를 보여주는 메서드
     */
    @GetMapping("/entry")
    public String showCommunityEntryPage(Model model) {
        List<CodeBizVO> mainCategories = codeBizService.getAllMainCategories();
        model.addAttribute("mainCategories", mainCategories);
        return "comm/entry"; // entry.jsp를 보여줌
    }
    
    /**
     * [AJAX] 선택된 대분류에 속한 중분류 목록을 반환하는 API
     */
    @GetMapping("/sub-categories/{parentCodeId}")
    @ResponseBody
    public ResponseEntity<List<CodeBizVO>> getSubCategories(@PathVariable String parentCodeId) {
        List<CodeBizVO> subCategories = codeBizService.getSubCategoriesByParentCode(parentCodeId);
        return ResponseEntity.ok(subCategories);
    }
}