// ShowDesignController.java
package kr.or.ddit.startup.show.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.service.ShowDesignService;
import kr.or.ddit.startup.show.vo.SuShowCommentVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/start-up/show")
public class ShowDesignController {

    @Autowired
    ShowDesignService showDesignService;

    @Autowired
    private FileService fileService;
        
    // 자랑게시판 게시물 목록 조회
    @LogEvent(eventType="VIEW", feature="SHOW") 
    @GetMapping
    public String showdesignList(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage, // ✔ page → currentPage
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String keyword,
            HttpServletRequest request,
            Model model
    ) {
        // --- 1) 이번 달 BEST 게시물 ---
        String currentMonth = java.time.LocalDate.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM"));
        java.util.List<SuShowPostVO> bestPosts = showDesignService.getBestPostsOfMonth(currentMonth);
        model.addAttribute("bestPosts", bestPosts);

        // --- 2) 페이징/검색 파라미터 셋업 ---
        final int size = 6; // 한 페이지 게시글 수

        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        int startRow = (currentPage - 1) * size + 1;
        int endRow = currentPage * size;
        paramMap.put("startRow", startRow);
        paramMap.put("endRow", endRow);

        // 검색 필터 정리(공백/빈값 → null)
        paramMap.put("searchType",
                (searchType == null || searchType.isBlank()) ? null : searchType.trim());

        if (keyword != null && !keyword.isBlank()) {
            // 컨트롤러에서 %를 붙이면 매퍼는 LIKE #{keyword} 로만 사용
            paramMap.put("keyword", "%" + keyword.trim() + "%");
        } else {
            paramMap.put("keyword", null);
        }

        // --- 3) 총건수/목록 조회 ---
        int total = showDesignService.selectTotalCount(paramMap);
        java.util.List<SuShowPostVO> postList =
                (total > 0) ? showDesignService.selectShowPostList(paramMap)
                        : java.util.Collections.emptyList();

        // --- 4) ArticlePage 구성(공지/멘토링과 동일패턴) ---
        ArticlePage<SuShowPostVO> articlePage =
                new ArticlePage<>(total, currentPage, size, postList,
                        (keyword == null ? "" : keyword.trim()));

        // 페이징 링크에 검색 파라미터 유지
        StringBuilder keep = new StringBuilder();
        if (searchType != null && !searchType.isBlank()) {
            keep.append("&searchType=").append(
                    java.net.URLEncoder.encode(searchType.trim(), java.nio.charset.StandardCharsets.UTF_8));
        }
        if (keyword != null && !keyword.isBlank()) {
            keep.append("&keyword=").append(
                    java.net.URLEncoder.encode(keyword.trim(), java.nio.charset.StandardCharsets.UTF_8));
        }

        String baseUrl = request.getRequestURI() + (keep.length() > 0 ? "?" + keep.substring(1) : "");
        articlePage.setUrl(baseUrl); // ✔ 내부에서 currentPage를 붙여 pagingArea 생성한다고 가정

        // --- 5) 모델 바인딩 ---
        model.addAttribute("postList", postList);   // 새로 추가
        model.addAttribute("posts", postList);      // JSP가 posts 이름도 기대하므로 함께 추가
        model.addAttribute("articlePage", articlePage);
        model.addAttribute("totalRecord", total);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        return "startup/show/showList";
    }


    // 자랑게시판 게시글 상세 보기
    @LogEvent(eventType="VIEW", feature="SHOW_DETAIL")
    @GetMapping("/detail/{postId}")
    public String showPostDetail(@PathVariable String postId, Model model, Authentication authentication) {
        SuShowPostVO post = showDesignService.getPostDetail(postId);

        List<SuShowCommentVO> commentList = showDesignService.getCommentList(postId);

        String userId = null;
        boolean isLiked = false;
        if (authentication != null && authentication.getPrincipal() instanceof CustomUser) {
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            UsersVO loginUser = customUser.getUsersVO();
            userId = loginUser.getUserId();
            isLiked = showDesignService.checkIfUserLiked(postId, userId);
        }

        model.addAttribute("post", post);
        model.addAttribute("isLiked", isLiked);
        model.addAttribute("userId", userId);
        model.addAttribute("commentList", commentList);

        return "startup/show/showDetail";
    }

    // 조회수 증가 전용 API 엔드포인트
    @ResponseBody
    @PostMapping("/view/{postId}")
    public ResponseEntity<Void> incrementViewCount(@PathVariable String postId) {
        showDesignService.incrementViewCount(postId);
        return ResponseEntity.ok().build();
    }

    // 자랑게시판 게시글 폼 insert
    @GetMapping("/insert")
    public String showdesignInsert(Authentication authentication, Model model) {
        if (authentication == null) return "redirect:/login";

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        UsersVO loginUser = customUser.getUsersVO();
        String userId = loginUser.getUserId();

        List<SuShowDesignVO> designList = showDesignService.getDesignsByUserId(userId);
        model.addAttribute("designList", designList);

        // JSP가 참조할 수 있도록 비어있는 post 객체를 모델에 추가
        model.addAttribute("post", new SuShowPostVO());
        // 목적지를 showInsert.jsp로 변경
        return "startup/show/showInsert";
    }

    // 게시글 등록
    @PostMapping("/insert")
    public String showdesignInsertPost(
            Authentication authentication,
            SuShowPostVO suShowPostVO,
            @RequestParam("newFiles") MultipartFile[] newFiles
    ) {

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        UsersVO loginUser = customUser.getUsersVO();
        suShowPostVO.setUserId(loginUser.getUserId());

        long fileGroupNo = fileService.uploadFiles(newFiles, "showDesign");

        suShowPostVO.setFileGroupNo(fileGroupNo);

        int res = showDesignService.insertShowPost(suShowPostVO);

        if (res > 0) {
            log.info("게시물 등록 성공. 생성된 postId: " + suShowPostVO.getPostId());
            return "redirect:/start-up/show";
        } else {
            log.error("게시물 등록 실패: " + suShowPostVO);
            return "redirect:/start-up/show/insert";
        }
    }

    // 게시글 삭제
    @PostMapping("/delete/{postId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deletePost(
            @PathVariable String postId,
            Authentication authentication) {
    	
        Map<String, Object> response = new HashMap<>();

        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String userId = customUser.getUsersVO().getUserId();

        try {
            int result = showDesignService.deletePost(postId, userId);
            if (result > 0) {
                response.put("success", true);
                response.put("message", "게시물이 삭제되었습니다.");
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("success", false);
                response.put("message", "게시물을 삭제할 권한이 없거나, 이미 삭제된 게시물입니다.");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            log.error("게시물 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류로 인해 삭제에 실패했습니다.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 게시글 수정 폼
    @GetMapping("/update/{postId}")
    public String showUpdateForm(@PathVariable String postId, Model model, Authentication authentication) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            return "redirect:/login";
        }

        SuShowPostVO post = showDesignService.getPostDetail(postId);
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String currentUserId = customUser.getUsersVO().getUserId();

        if (post == null || !post.getUserId().equals(currentUserId)) {
            return "redirect:/error/403";
        }

        model.addAttribute("post", post);

        // 수정 폼에도 designList를 추가 (누락되었던 부분)
        List<SuShowDesignVO> designList = showDesignService.getDesignsByUserId(currentUserId);
        model.addAttribute("designList", designList);

        // 목적지를 showUpdate.jsp로 변경
        return "startup/show/showUpdate";
    }

    // 게시글 수정 처리
    @PostMapping("/update")
    public String updatePost(
            SuShowPostVO suShowPostVO,
            @RequestParam(name = "deleteFileSns", required = false) List<Integer> deleteFileSns,
            @RequestParam(name = "newFiles", required = false) MultipartFile[] newFiles,
            Authentication authentication) {

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        suShowPostVO.setUserId(customUser.getUsersVO().getUserId());

        showDesignService.updatePost(suShowPostVO, deleteFileSns, newFiles);

        return "redirect:/start-up/show/detail/" + suShowPostVO.getPostId();
    }

    // 좋아요/좋아요 취소 AJAX 요청 처리
    @PostMapping("/like/{postId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> toggleLike(@PathVariable String postId, Authentication authentication) {
        Map<String, Object> resMap = new HashMap<>();
        String userId = null;

        // 1. 로그인 여부 확인
        if (authentication != null && authentication.getPrincipal() instanceof CustomUser) {
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            UsersVO loginUser = customUser.getUsersVO();
            userId = loginUser.getUserId();
        }

        if (userId == null || userId.isEmpty()) {
            resMap.put("success", false);
            resMap.put("message", "로그인이 필요한 서비스입니다.");
            resMap.put("redirect", "/login");
            return new ResponseEntity<>(resMap, HttpStatus.UNAUTHORIZED);
        }

        try {
            // 2. 좋아요 상태 토글 및 DB 업데이트
            boolean isLikedNow = showDesignService.toggleLikeStatus(postId, userId);

            resMap.put("success", true);
            resMap.put("isLiked", isLikedNow);
            resMap.put("likeCount", showDesignService.getLikeCount(postId));
            resMap.put("message", isLikedNow ? "좋아요가 반영되었습니다." : "좋아요가 취소되었습니다.");
            return new ResponseEntity<>(resMap, HttpStatus.OK);
        } catch (Exception e) {
            log.error("좋아요 처리 중 오류 발생: " + e.getMessage(), e);
            resMap.put("success", false);
            resMap.put("message", "좋아요 처리 중 오류가 발생했습니다.");
            return new ResponseEntity<>(resMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 등록 처리
    @PostMapping("/comment/insert")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertComment(
            @Valid @RequestBody SuShowCommentVO suShowCommentVO,
            Authentication authentication) {

        Map<String, Object> resMap = new HashMap<>();
        String userId = null;

        // 1. 로그인 여부 및 사용자 ID 설정
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            resMap.put("success", false);
            resMap.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(resMap, HttpStatus.UNAUTHORIZED);
        }

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        UsersVO loginUser = customUser.getUsersVO();
        userId = loginUser.getUserId();
        suShowCommentVO.setUserId(userId);

        // 2. parentId와 depth 설정 (대댓글이 아닌 경우)
        if (suShowCommentVO.getParentId() != null) {
            // 부모 댓글의 depth를 조회하여 +1 함
            Integer parentDepth = showDesignService.getCommentDepth(suShowCommentVO.getParentId());
            if (parentDepth != null) {
                suShowCommentVO.setDepth(parentDepth + 1);
            } else {
                // 부모 댓글을 찾을 수 없으면 기본 depth 0으로 설정 (방어 로직)
                suShowCommentVO.setDepth(0);
                suShowCommentVO.setParentId(null);
            }
        } else {
            suShowCommentVO.setDepth(0); // 최상위 댓글인 경우 depth 0
        }

        try {
            int res = showDesignService.insertComment(suShowCommentVO);
            if (res > 0) {
                resMap.put("success", true);
                resMap.put("message", "댓글이 성공적으로 등록되었습니다.");
                resMap.put("commentId", suShowCommentVO.getCommentId());
                return new ResponseEntity<>(resMap, HttpStatus.OK);
            } else {
                resMap.put("success", false);
                resMap.put("message", "댓글 등록에 실패했습니다.");
                return new ResponseEntity<>(resMap, HttpStatus.INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("댓글 등록 중 오류 발생: " + e.getMessage(), e);
            resMap.put("success", false);
            resMap.put("message", "댓글 등록 중 서버 오류가 발생했습니다.");
            return new ResponseEntity<>(resMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 수정 처리
    @PostMapping("/comment/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateComment(
            @RequestBody SuShowCommentVO suShowCommentVO,
            Authentication authentication) {

        Map<String, Object> resMap = new HashMap<>();
        String userId = null;

        // 1. 로그인 여부 확인
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            resMap.put("success", false);
            resMap.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(resMap, HttpStatus.UNAUTHORIZED);
        }

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        UsersVO loginUser = customUser.getUsersVO();
        userId = loginUser.getUserId();
        suShowCommentVO.setUserId(userId);

        log.info("댓글 수정 요청 - commentId: {}, 요청 사용자: {}", suShowCommentVO.getCommentId(), userId);

        try {
            int res = showDesignService.updateComment(suShowCommentVO);
            if (res > 0) {
                resMap.put("success", true);
                resMap.put("message", "댓글이 성공적으로 수정되었습니다.");
                return new ResponseEntity<>(resMap, HttpStatus.OK);
            } else {
                resMap.put("success", false);
                resMap.put("message", "댓글 수정 권한이 없거나, 댓글을 찾을 수 없습니다.");
                return new ResponseEntity<>(resMap, HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            log.error("댓글 수정 중 오류 발생: " + e.getMessage(), e);
            resMap.put("success", false);
            resMap.put("message", "댓글 수정 중 서버 오류가 발생했습니다.");
            return new ResponseEntity<>(resMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 댓글 삭제 처리 (논리적 삭제)
    @DeleteMapping("/comment/{commentId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteComment(
            @PathVariable int commentId,
            Authentication authentication) {

        Map<String, Object> resMap = new HashMap<>();
        String userId = null;

        // 1. 로그인 여부 확인
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            resMap.put("success", false);
            resMap.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(resMap, HttpStatus.UNAUTHORIZED);
        }
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        UsersVO loginUser = customUser.getUsersVO();
        userId = loginUser.getUserId();

        log.info("댓글 삭제 요청 - commentId: {}, 요청 사용자: {}", commentId, userId);

        try {
            int res = showDesignService.deleteComment(commentId, userId);
            if (res > 0) {
                resMap.put("success", true);
                resMap.put("message", "댓글이 성공적으로 삭제되었습니다.");
                return new ResponseEntity<>(resMap, HttpStatus.OK);
            } else {
                resMap.put("success", false);
                resMap.put("message", "댓글 삭제 권한이 없거나, 댓글을 찾을 수 없습니다.");
                return new ResponseEntity<>(resMap, HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            log.error("댓글 삭제 중 오류 발생: " + e.getMessage(), e);
            resMap.put("success", false);
            resMap.put("message", "댓글 삭제 중 서버 오류가 발생했습니다.");
            return new ResponseEntity<>(resMap, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}