package kr.or.ddit.admin.mt.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.startup.mt.service.MentoringService;
import kr.or.ddit.startup.mt.vo.SuMentPostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/admin/mentoring")
public class AdminMentoringController {

    @Autowired
    MentoringService mentoringService;

    @Autowired(required = false)
    CodeService codeService;
    
    @Autowired
    FileService fileService;

    // ✅ 목록
    @GetMapping
    public String mentoringList(
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String statusType,
            @RequestParam(required = false) String searchWord,
            Model model
    ) {
        // [기존 코드] '분류' 목록을 가져옵니다.
        List<CodeDetailVO> categoryList = codeService.getCodeDetailList("MENTORTAG");
        model.addAttribute("categoryList", categoryList);

        // [추가] ▼ '접수 상태' 목록을 DB에서 가져와 모델에 추가합니다.
        List<CodeDetailVO> statusList = codeService.getCodeDetailList("MTAPPLYTAG");
        model.addAttribute("statusList", statusList);

        int screenSize = 6;
        int blockSize = 5;

        int startRow = (currentPage * screenSize) - (screenSize - 1);
        int endRow = currentPage * screenSize;

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("endRow", endRow);
        paramMap.put("searchType", searchType);
        paramMap.put("statusType", statusType);

        if (searchWord != null && !searchWord.isEmpty()) {
            paramMap.put("searchWord", "%" + searchWord + "%");
        }

        int totalRecord = mentoringService.selectTotalCount(paramMap);
        List<SuMentPostVO> postList = mentoringService.selectMentoringPostList(paramMap);

        int totalPage = (int) Math.ceil((double) totalRecord / screenSize);
        int startPage = ((currentPage - 1) / blockSize) * blockSize + 1;
        int endPage = Math.min(startPage + blockSize - 1, totalPage);

        model.addAttribute("postList", postList);
        model.addAttribute("totalRecord", totalRecord);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("blockSize", blockSize);
        model.addAttribute("searchType", searchType);
        model.addAttribute("statusType", statusType);
        model.addAttribute("searchWord", searchWord);

        return "admin/board/mentoring/list";
    }

    // ✅ 상세보기
    @GetMapping("/{mentoringId}")
    public String mentoringDetail(@PathVariable long mentoringId, Model model,
                                  HttpServletRequest request,
                                  HttpServletResponse response) {

        // 쿠키로 조회수 중복 방지
        Cookie[] cookies = request.getCookies();
        boolean isViewed = false;
        String cookieName = "postView";
        String cookieValue = "";

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(cookieName)) {
                    cookieValue = cookie.getValue();
                    if (cookieValue.contains("/" + mentoringId + "/")) {
                        isViewed = true;
                        break;
                    }
                }
            }
        }

        if (!isViewed) {
            mentoringService.increaseViewCount(mentoringId);
            Cookie newCookie = new Cookie(cookieName, cookieValue + "/" + mentoringId + "/");
            newCookie.setPath("/");
            newCookie.setMaxAge(60 * 60 * 24);
            response.addCookie(newCookie);
        }

        SuMentPostVO post = mentoringService.retrieveMentoringPost(mentoringId);
        SuMentPostVO prevPost = mentoringService.selectPrevPost(mentoringId);
        SuMentPostVO nextPost = mentoringService.selectNextPost(mentoringId);

        model.addAttribute("post", post);
        model.addAttribute("prevPost", prevPost);
        model.addAttribute("nextPost", nextPost);

        return "admin/board/mentoring/detail";
    }

    // ✅ 등록 폼
    @GetMapping("/form")
    public String mentoringInsertForm(Model model) { // Model 파라미터 추가
        // "MENTORTAG" 그룹의 코드 목록을 조회합니다.
        List<CodeDetailVO> categoryList = codeService.getCodeDetailList("MENTORTAG");
        // 조회된 목록을 "categoryList"라는 이름으로 모델에 담아 JSP로 전달합니다.
        model.addAttribute("categoryList", categoryList);
        
        return "admin/board/mentoring/form";
    }

    // ✅ 등록 처리
    @PostMapping
    public String mentoringInsert(@ModelAttribute SuMentPostVO post,
                                  RedirectAttributes redirectAttributes) {

        // 로그인한 사용자 정보에서 아이디 추출
        CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        post.setUserId(user.getUsername());

        int result = mentoringService.createMentoringPost(post);

        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");
            return "redirect:/admin/mentoring/" + post.getPostId();
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 등록에 실패했습니다.");
            return "redirect:/admin/mentoring/form";
        }
    }
    
    // ✅ 수정 폼 로딩
    @GetMapping("/updateForm")
    public String mentoringUpdateForm(@RequestParam("postId") long postId, Model model) {
        SuMentPostVO post = mentoringService.retrieveMentoringPost(postId);
        model.addAttribute("post", post);
        List<CodeDetailVO> categoryList = codeService.getCodeDetailList("MENTORTAG");
        model.addAttribute("categoryList", categoryList);
        return "admin/board/mentoring/update";
    }
    
    // ✅ 수정 처리
    @PostMapping("/update")
    public String mentoringUpdate(@ModelAttribute SuMentPostVO post,
                                  RedirectAttributes redirectAttributes) {
        // postId는 폼 데이터로 넘어옴
        int result = mentoringService.modifyMentoringPost(post);
        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "게시글이 성공적으로 수정되었습니다.");
            return "redirect:/admin/mentoring/" + post.getPostId();
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 수정에 실패했습니다.");
            return "redirect:/admin/mentoring/updateForm?postId=" + post.getPostId();
        }
    }
    
    // ✅ 삭제 처리
    @PostMapping("/delete")
    public String mentoringDelete(@RequestParam("postId") long postId, RedirectAttributes redirectAttributes) {
        int result = mentoringService.removeMentoringPost(postId);
        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "게시글이 성공적으로 삭제되었습니다.");
            return "redirect:/admin/mentoring";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 삭제에 실패했습니다.");
            return "redirect:/admin/mentoring/" + postId;
        }
    }
}
