package kr.or.ddit.startup.mt.controller;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.startup.mt.service.MentoringService;
import kr.or.ddit.startup.mt.vo.SuMentPostVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/start-up/mt")
public class MentoringController {

    @Autowired
    MentoringService mentoringService;

    @Autowired(required = false)
    CodeService codeService;

// 멘토링 게시글 list 조회 및 페이징 처리
@GetMapping
public String mentoringList(
        @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
        @RequestParam(required = false) String searchType,   // 분류
        @RequestParam(required = false) String statusType,   // 접수 여부
        @RequestParam(required = false) String searchWord,   // 폼에서 직접 올 때
        @RequestParam(required = false) String keyword,      // ArticlePage 링크로 넘어올 때
        HttpServletRequest request,
        Model model
) {
    // 필터 드롭다운
    model.addAttribute("categoryList", codeService.getCodeDetailList("MENTORTAG"));  // 
    model.addAttribute("statusList",   codeService.getCodeDetailList("MTAPPLYTAG")); // 

    final int size = 6;

    // 파라미터 정리
    String _searchType = (searchType != null && !searchType.isBlank()) ? searchType.trim() : null;
    String _statusType = (statusType != null && !statusType.isBlank()) ? statusType.trim() : null;

    // ✅ keyword 우선, 없으면 searchWord 사용
    String rawWord = (keyword != null && !keyword.isBlank())
            ? keyword.trim()
            : (searchWord != null && !searchWord.isBlank() ? searchWord.trim() : null);

    // 페이징 범위
    int startRow = (currentPage - 1) * size + 1;
    int endRow   = currentPage * size;

    // 조회 파라미터
    Map<String, Object> paramMap = new HashMap<>();
    paramMap.put("startRow", startRow);
    paramMap.put("endRow", endRow);
    paramMap.put("searchType", _searchType);
    paramMap.put("statusType", _statusType);
    // ✅ %는 매퍼에서 붙이므로 여기서는 원문 그대로
    paramMap.put("searchWord", rawWord);

    // 총건수/목록
    int total = mentoringService.selectTotalCount(paramMap);
    List<SuMentPostVO> list = (total > 0)
            ? mentoringService.selectMentoringPostList(paramMap)
            : java.util.Collections.emptyList();

    // ✅ ArticlePage: keyword(=rawWord), searchType 전달
    ArticlePage<SuMentPostVO> articlePage =
            new ArticlePage<>(total, currentPage, size, list,
                    (rawWord == null ? "" : rawWord),
                    (_searchType == null ? "" : _searchType)); // ArticlePage는 searchType/keyword를 링크에 붙임.  

    // ✅ baseUrl에는 statusType만 보존 (searchType/keyword는 ArticlePage가 처리)
    String baseUrl = request.getRequestURI()
            + (_statusType != null ? ("?statusType=" + java.net.URLEncoder.encode(_statusType, java.nio.charset.StandardCharsets.UTF_8)) : "");
    articlePage.setUrl(baseUrl); // 내부에서 currentPage 등 링크 생성. 

    // 모델
    model.addAttribute("articlePage", articlePage);
    model.addAttribute("totalRecord", total);
    model.addAttribute("searchType", _searchType);
    model.addAttribute("statusType", _statusType);
    model.addAttribute("searchWord", rawWord); // 폼 값 유지용

    return "startup/mt/menList";
}


    // 멘토링 게시물 상세보기 및 이전/다음 게시물 정보 조회
    @GetMapping("/{mentoringId}")
    public String mentoringDetail(@PathVariable long mentoringId, Model model,
                                  HttpServletRequest request,
                                  HttpServletResponse response) {

        // --- 조회수 중복 방지 로직 (쿠키 사용) ---
        Cookie[] cookies = request.getCookies();
        boolean isViewed = false;
        String cookieName = "postView";
        String cookieValue = "";

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals(cookieName)) {
                    cookieValue = cookie.getValue();
                    // "postView" 쿠키의 값에 "/게시물ID/" 형태가 포함되어 있는지 확인
                    if (cookieValue.contains("/" + mentoringId + "/")) {
                        isViewed = true;
                        break;
                    }
                }
            }
        }

        // 이 게시물을 처음 본 경우
        if (!isViewed) {
            // 1. 조회수 증가 서비스 호출
            mentoringService.increaseViewCount(mentoringId);

            // 2. 쿠키에 현재 게시물 ID 추가하여 응답에 담기
            Cookie newCookie = new Cookie(cookieName, cookieValue + "/" + mentoringId + "/");
            newCookie.setPath("/"); // 쿠키가 사이트 전체에서 유효하도록 설정
            newCookie.setMaxAge(60 * 60 * 24); // 쿠키 유효기간: 24시간
            response.addCookie(newCookie);
        }
        // --- 조회수 로직 끝 ---

        // 기존 게시물 정보 조회 로직
        SuMentPostVO post = mentoringService.retrieveMentoringPost(mentoringId);
        SuMentPostVO prevPost = mentoringService.selectPrevPost(mentoringId);
        SuMentPostVO nextPost = mentoringService.selectNextPost(mentoringId);

        model.addAttribute("post", post);
        model.addAttribute("prevPost", prevPost); // 이전 글 
        model.addAttribute("nextPost", nextPost); // 다음 글

        return "startup/mt/menDetail";
    }

    // 멘토링 form 
    @GetMapping("/form")
    public String mentoringInsertForm() {
        return "startup/mt/menInsert";
    }

    // 멘토링 insert
    @PostMapping
    public String mentoringInsert(@ModelAttribute SuMentPostVO post, RedirectAttributes redirectAttributes) {
        post.setUserId("admin@test.com");

        // [수정] Service의 createMentoringPost가 저장된 post의 ID를 반환하도록 설계
        int result = mentoringService.createMentoringPost(post);

        if (result > 0) {
            // 성공 시, insert된 post의 ID를 가져와서 redirect 경로에 사용
            // SuMentPostVO에 selectKey로 postId가 채워져 있어야 함
            redirectAttributes.addFlashAttribute("message", "게시글이 성공적으로 등록되었습니다.");
            return "redirect:/start-up/mt/" + post.getPostId();
        } else {
            // 실패 처리
            redirectAttributes.addFlashAttribute("errorMessage", "게시글 등록에 실패했습니다.");
            return "redirect:/start-up/mt/form";
        }
    }
}