package kr.or.ddit.community.review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication; // Authentication 임포트 추가
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.community.review.service.ReviewCommentService;
import kr.or.ddit.community.review.service.ReviewPostService;
import kr.or.ddit.community.review.vo.CommReviewCommentVO;
import kr.or.ddit.community.review.vo.CommReviewPostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

/**
 * ReviewPostController
 * 창업 소통 후기 게시판 및 댓글 관련 웹 요청을 처리하는 컨트롤러입니다.
 * 웹 페이지 렌더링과 RESTful API 호출을 혼합하여 구현됩니다.
 */
@Slf4j
@Controller
@RequestMapping("/comm/review")
public class ReviewPostController {

    private final ReviewPostService postService;
    private final ReviewCommentService commentService;

    @Autowired
    private FileService fileService;

    @Autowired
    private CodeService codeService;

    // 생성자 주입
    @Autowired
    public ReviewPostController(ReviewPostService postService, ReviewCommentService commentService) {
        this.postService = postService;
        this.commentService = commentService;
    }

    @LogEvent(eventType = "VIEW", feature = "REVIEW")
    @GetMapping
    public String list(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "catCodeId", required = false) String catCodeId,
            @RequestParam(value = "searchType", defaultValue = "SC101") String searchType,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model
    ) {
        log.info("list() 실행 - currentPage: {}, catCodeId: {}, searchType: {}, keyword: {}", currentPage, catCodeId, searchType, keyword);

        // 옵션 바인딩
        model.addAttribute("reviewTags", codeService.getCodeDetailList("REVIEWTAG"));
        model.addAttribute("searchTags", codeService.getCodeDetailList("SEARCHTAG"));

        // 조회 파라미터
        Map<String, Object> map = new HashMap<>();
        if (catCodeId != null && !catCodeId.isEmpty()) {
            map.put("catCodeId", catCodeId);
            model.addAttribute("selectedCatCodeId", catCodeId);
        }
        // 검색 값 정리
        String normSearchType = (searchType == null ? "SC101" : searchType.trim().toUpperCase());
        String normKeyword = (keyword == null ? "" : keyword.trim());
        map.put("searchType", normSearchType);
        if (!normKeyword.isEmpty()) map.put("keyword", normKeyword);

        int size = 12;
        int total = postService.getReviewPostCount(map);
        log.info("총 게시글 수: {}", total);

        int totalPages = (total + size - 1) / size;
        if (totalPages > 0 && currentPage > totalPages) currentPage = totalPages;
        if (currentPage < 1) currentPage = 1;

        int start = (currentPage - 1) * size + 1;
        int end = currentPage * size;
        map.put("startRow", start);
        map.put("endRow", end);
        log.info("currentPage: {}, startRow: {}, endRow: {}", currentPage, start, end);

        List<CommReviewPostVO> list = postService.getReviewPostList(map);

        // 미리보기 & 썸네일 추출
        for (CommReviewPostVO post : list) {
            String content = post.getContent();
            String cleanContent = content.replaceAll("(?i)<img[^>]*>", "");
            post.setPreviewContent(cleanContent);

            java.util.regex.Matcher m = java.util.regex.Pattern
                    .compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>", java.util.regex.Pattern.CASE_INSENSITIVE)
                    .matcher(content);
            if (m.find()) post.setThumbnailUrl(m.group(1));
        }

        // ★ ArticlePage에 keyword, searchType 전달 (유지)
        ArticlePage<CommReviewPostVO> page = new ArticlePage<>(total, currentPage, size, list, normKeyword, normSearchType);

        // ★ 중요: base URL에는 catCodeId만 (검색 파라미터 절대 넣지 말 것!)
        String baseUrl = "/comm/review"; 
        page.setUrl(baseUrl);
        log.info("ArticlePage URL: {}", page.getUrl());

        model.addAttribute("articlePage", page);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("searchType", normSearchType);
        model.addAttribute("keyword", normKeyword); // ★ 추가: 폼 값 유지

        return "comm/review/reviewList";
    }


    /**
     * 특정 게시글 ID로 게시글 상세 페이지를 조회합니다.
     * GET /comm/review/detail?postId=123
     *
     * @param postId 조회할 게시글 ID
     * @param model  뷰에 데이터를 전달하기 위한 Model 객체
     * @return 뷰 이름 (comm/review/reviewDetail)
     */
    @LogEvent(eventType = "VIEW", feature = "REVIEW_DETAIL")
    @GetMapping("/detail")
    public String reviewDetail(@RequestParam("postId") int postId, Model model) {
        log.info("reviewDetail() 실행 - postId: {}", postId);

        CommReviewPostVO postVO = postService.getPost(postId);
        if (postVO == null) {
            log.warn("게시글 ID {} 에 해당하는 게시글을 찾을 수 없습니다.", postId);
            // 게시글이 없을 경우 예외 처리 또는 에러 페이지로 리다이렉트
            return "redirect:/error"; // 예시
        }
        model.addAttribute("postVO", postVO);

        if (postVO.getFileGroupNo() != 0) {
            List<FileDetailVO> reviewFiles = fileService.getFileList(postVO.getFileGroupNo());
            model.addAttribute("reviewFiles", reviewFiles);
            log.info("게시글 ID {} 에 대한 첨부파일 {}개 조회됨.", postId, reviewFiles.size());
        }

        List<CommReviewCommentVO> commentList = commentService.getCommentsByPostId(postId);
        model.addAttribute("commentList", commentList);
        log.info("게시글 ID {} 에 대한 댓글 {}개 조회됨.", postId, commentList.size());

        return "comm/review/reviewDetail";
    }

    /**
     * 새로운 게시글 작성 페이지를 반환합니다.
     * GET /comm/review/form
     *
     * @return 뷰 이름 (comm/review/reviewInsert)
     */
    @GetMapping("/form")
    @PreAuthorize("isAuthenticated()") // 로그인된 사용자만 접근 가능
    public String showPostForm(Model model) {
        log.info("showPostForm() 실행");

        model.addAttribute("postVO", new CommReviewPostVO());
        model.addAttribute("mode", "create");

        // ▼ [수정] "RC101"을 그룹 ID인 "REVIEWTAG"로 변경
        List<CodeDetailVO> details = codeService.getCodeDetailList("REVIEWTAG");
        model.addAttribute("codeDetails", details);

        return "comm/review/reviewInsert";
    }


    /**
     * 새로운 게시글을 작성합니다.
     * POST /comm/review/create
     *
     * @param postVO         작성할 게시글 정보
     * @param attachments    첨부 파일
     * @param ra             리다이렉트 시 메시지 전달을 위한 RedirectAttributes
     * @param authentication Spring Security 인증 객체 (로그인 정보)
     * @return 리다이렉트 URL
     */
    @PostMapping("/create")
    @PreAuthorize("isAuthenticated()")
    public String createPost(
            CommReviewPostVO postVO,
            @RequestParam(value = "attachments", required = false) MultipartFile[] attachments,
            RedirectAttributes ra,
            Authentication authentication // Authentication 객체 주입
    ) {
        log.info("createPost() API 실행 시작, postVO: {}", postVO);

        try {
            // 로그인한 사용자 ID를 게시글 작성자로 설정
            CustomUser user = (CustomUser) authentication.getPrincipal();
            String userId = user.getUsername();
            postVO.setUserId(userId);

            long finalGroupNo = 0;
            if (attachments != null && attachments.length > 0 && !attachments[0].isEmpty()) {
                finalGroupNo = fileService.uploadFiles(
                        attachments,
                        "review_post_attachment",
                        postVO.getFileGroupNo() // 기존 파일 그룹 번호가 있다면 전달
                );
            } else if (postVO.getFileGroupNo() > 0) { // 파일은 없지만 기존 fileGroupNo가 유지되어야 할 경우
                finalGroupNo = postVO.getFileGroupNo();
            }

            if (finalGroupNo > 0) {
                postVO.setFileGroupNo((int) finalGroupNo);
            } else {
                postVO.setFileGroupNo(0); // 파일이 없는 경우 0으로 설정
            }


            boolean success = postService.createPost(postVO);

            if (success) {
                log.info("게시글이 성공적으로 작성되었습니다. PostId: {}", postVO.getPostId());
                ra.addFlashAttribute("msg", "게시글이 성공적으로 작성되었습니다.");
                return "redirect:/comm/review/detail?postId=" + postVO.getPostId(); // 상세 페이지로 이동
            } else {
                log.warn("게시글 작성에 실패했습니다. 서비스 계층에서 false 반환.");
                ra.addFlashAttribute("msg", "게시글 작성에 실패했습니다. 다시 시도해주세요.");
                return "redirect:/comm/review/form";
            }
        } catch (Exception e) {
            log.error("게시글 작성 중 예기치 않은 오류 발생: {}", e.getMessage(), e);
            ra.addFlashAttribute("msg", "게시글 작성 중 예기치 않은 오류가 발생했습니다.");
            return "redirect:/comm/review/form";
        }
    }

    /**
     * 게시글 수정 폼을 반환합니다.
     * GET /comm/review/updateForm?postId=123
     *
     * @param postId         수정할 게시글 ID
     * @param model          모델
     * @param authentication 인증 객체
     * @param ra             리다이렉트 어트리뷰트
     * @return 수정 폼 뷰 또는 리다이렉트
     */
    @GetMapping("/updateForm")
    @PreAuthorize("isAuthenticated()")
    public String showUpdatePostForm(@RequestParam("postId") int postId, Model model, Authentication authentication, RedirectAttributes ra) {
        log.info("showUpdatePostForm() 실행 - postId: {}", postId);

        CommReviewPostVO postVO = postService.getPost(postId);
        if (postVO == null) {
            ra.addFlashAttribute("msg", "게시글을 찾을 수 없습니다.");
            return "redirect:/comm/review";
        }

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();

        // 게시글 작성자 본인만 수정 폼 접근 가능
        if (!currentUserId.equals(postVO.getUserId())) {
            ra.addFlashAttribute("msg", "게시글 수정 권한이 없습니다.");
            return "redirect:/comm/review/detail?postId=" + postId;
        }

        model.addAttribute("postVO", postVO);
        model.addAttribute("mode", "update"); // 수정 모드임을 나타내는 "mode" 값을 추가

        // ▼ [수정] "RC101"을 그룹 ID인 "REVIEWTAG"로 변경
        List<CodeDetailVO> details = codeService.getCodeDetailList("REVIEWTAG");
        model.addAttribute("codeDetails", details);

        // 첨부파일 정보도 함께 전달 (수정 폼에서 기존 파일 표시용)
        if (postVO.getFileGroupNo() != 0) {
            List<FileDetailVO> existingFiles = fileService.getFileList(postVO.getFileGroupNo());
            model.addAttribute("existingFiles", existingFiles); // 'existingFiles' 이름으로 JSP에 전달
        }

        return "comm/review/reviewInsert"; // insert 폼을 재활용
    }


    @PostMapping("/update")
    @PreAuthorize("isAuthenticated()")
    public String updatePost(
            CommReviewPostVO postVO,
            @RequestParam(value = "attachments", required = false) MultipartFile[] attachments,
            @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
            RedirectAttributes ra,
            Authentication authentication
    ) {
        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();

        // 원본 포스트 및 기존 그룹 확인
        CommReviewPostVO existingPost = postService.getPost(postVO.getPostId());
        if (existingPost == null || !(currentUserId.equals(existingPost.getUserId())
                || authentication.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN")))) {
            ra.addFlashAttribute("msg", "게시글 수정 권한이 없거나 게시글을 찾을 수 없습니다.");
            return "redirect:/comm/review/detail?postId=" + postVO.getPostId();
        }

        long originalGroupNo = existingPost.getFileGroupNo();
        boolean hasNewAttachments =
                attachments != null && attachments.length > 0 && attachments[0] != null && !attachments[0].isEmpty();
        boolean editorGroupChanged = ckFileGroupNo > 0 && ckFileGroupNo != originalGroupNo;

        long finalFileGroupNo;
        if (hasNewAttachments) {
            // 첨부파일이 있다면,
            // 1) CKEditor가 새 그룹을 만들었으면 그 그룹(ckFileGroupNo)에 이어붙이고
            // 2) 아니면 0을 주어서 "완전히 새로운 그룹"을 생성한다.
            long base = editorGroupChanged ? ckFileGroupNo : 0;
            finalFileGroupNo = fileService.uploadFiles(attachments, "review_post_attachment", base);

            // CKEditor 이미지만 있고 첨부는 없는 케이스는 아래 else-if에서 처리
        } else if (editorGroupChanged) {
            // 첨부파일은 없지만 CKEditor에서 새 그룹이 생겼다면, 그 그룹을 최종 그룹으로 사용
            finalFileGroupNo = ckFileGroupNo;
        } else {
            // 파일 변화 없음 → 기존 그룹 유지
            finalFileGroupNo = originalGroupNo;
        }

        postVO.setFileGroupNo((int) finalFileGroupNo);
        postVO.setUserId(currentUserId);

        boolean success = postService.modifyPost(postVO);
        if (success) {
            // (선택) finalFileGroupNo != originalGroupNo이면 기존 그룹의 고아 파일 정리 로직 추가 가능
            ra.addFlashAttribute("msg", "게시글이 성공적으로 수정되었습니다.");
            return "redirect:/comm/review/detail?postId=" + postVO.getPostId();
        } else {
            ra.addFlashAttribute("msg", "게시글 수정에 실패했습니다. 다시 시도해주세요.");
            return "redirect:/comm/review/updateForm?postId=" + postVO.getPostId();
        }
    }


    /**
     * 특정 게시글을 삭제합니다. (논리적 삭제) (REST API 방식 유지)
     * DELETE /comm/review/delete (JSP에서 AJAX로 호출 시 사용)
     *
     * @param postId         삭제할 게시글 ID
     * @param authentication Spring Security 인증 객체
     * @return 성공 시 200 OK, 실패 시 403 Forbidden 또는 500 Internal Server Error
     */
    @DeleteMapping("/delete")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> deletePostAjax(@RequestParam("postId") int postId, Authentication authentication) {
        log.info("Executing deletePost() via DELETE (AJAX), postId: {}", postId);

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();

        CommReviewPostVO postVO = postService.getPost(postId);
        if (postVO == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("The post could not be found.");
        }

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (currentUserId.equals(postVO.getUserId()) || isAdmin) {

            boolean success = postService.removePost(postId); // Logical delete
            if (success) {
                return ResponseEntity.ok("The post has been successfully deleted.");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to delete the post.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You do not have permission to delete this post.");
        }
    }

    // --- 댓글 관련 API (JSON 응답) ---


    /**
     * 특정 게시글에 대한 모든 댓글 목록을 조회합니다. (API)
     * GET /comm/review/{postId}/comments
     *
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 VO 리스트
     */
    @GetMapping("/{postId}/comments")
    @ResponseBody
    public ResponseEntity<List<CommReviewCommentVO>> getCommentsByPostId(@PathVariable int postId) {
        log.info("getCommentsByPostId() API 실행, postId: {}", postId);
        List<CommReviewCommentVO> commentList = commentService.getCommentsByPostId(postId);
        if (commentList.isEmpty()) {
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        }
        return new ResponseEntity<>(commentList, HttpStatus.OK);
    }

    /**
     * 특정 게시글을 삭제합니다. (폼 제출 방식)
     *
     * @param postId         삭제할 게시글의 ID
     * @param fileGroupNo    게시글에 연결된 파일 그룹 번호
     * @param authentication Spring Security 인증 객체
     * @param ra             리다이렉트 시 메시지 전달용
     * @return 리다이렉트 URL
     */
    @PostMapping("/delete")
    @PreAuthorize("isAuthenticated()")
    public String deletePost(
            @RequestParam("postId") int postId,
            @RequestParam(name = "fileGroupNo", defaultValue = "0") int fileGroupNo,
            Authentication authentication,
            RedirectAttributes ra
    ) {
        log.info("POST 방식으로 deletePost() 실행, postId: {}", postId);

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();
        CommReviewPostVO postVO = postService.getPost(postId);

        if (postVO == null) {
            ra.addFlashAttribute("msg", "게시글을 찾을 수 없습니다.");
            return "redirect:/comm/review";
        }

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (currentUserId.equals(postVO.getUserId()) || isAdmin) {
            // ★ 연결된 모든 파일을 먼저 삭제

            boolean success = postService.removePost(postId); // 논리적 삭제
            if (success) {
                ra.addFlashAttribute("msg", "게시글이 성공적으로 삭제되었습니다.");
            } else {
                ra.addFlashAttribute("msg", "게시글 삭제에 실패했습니다.");
            }
            return "redirect:/comm/review";
        } else {
            ra.addFlashAttribute("msg", "게시글 삭제 권한이 없습니다.");
            return "redirect:/comm/review/detail?postId=" + postId;
        }
    }

    /**
     * 특정 게시글에 새로운 댓글을 작성합니다. (API)
     * POST /comm/review/comments/create
     *
     * @param commentVO      작성할 댓글 정보 (JSON 요청 본문)
     * @param authentication Spring Security 인증 객체
     * @return 성공 시 201 Created, 실패 시 400 Bad Request
     */
    @PostMapping("/comments/create")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> createComment(
            @RequestParam("postId") int postId, // <--- postId를 쿼리 파라미터로 받도록 추가
            @RequestBody CommReviewCommentVO commentVO,
            Authentication authentication) {
        log.info("createComment() API 실행, commentVO (초기): {}", commentVO); // 초기 commentVO 로그
        log.info("createComment() API 실행, 쿼리 파라미터 postId: {}", postId); // 쿼리 파라미터 postId 로그

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String userId = user.getUsername();
        commentVO.setUserId(userId); // 로그인한 사용자 ID 설정

        // ************************************************************
        // 이 부분이 핵심 수정 사항입니다. 쿼리 파라미터로 받은 postId를 VO에 설정
        commentVO.setPostId(postId);
        // ************************************************************

        log.info("createComment() API 실행, commentVO (최종): {}", commentVO); // 최종 commentVO 로그

        boolean success = commentService.createComment(commentVO);
        if (success) {
            return new ResponseEntity<>("댓글이 성공적으로 작성되었습니다.", HttpStatus.CREATED);
        } else {
            return new ResponseEntity<>("댓글 작성에 실패했습니다. 입력 값을 확인해주세요.", HttpStatus.BAD_REQUEST);
        }
    }

    /**
     * 특정 댓글을 수정합니다. (API)
     * PUT /comm/review/comments/update
     *
     * @param commentVO      수정할 댓글 정보 (JSON 요청 본문)
     * @param authentication Spring Security 인증 객체
     * @return 성공 시 200 OK, 실패 시 403 Forbidden 또는 500 Internal Server Error
     */
    @PutMapping("/comments/update")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> updateComment(@RequestBody CommReviewCommentVO commentVO, Authentication authentication) {
        log.info("updateComment() API 실행, commentVO: {}", commentVO);

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();

        CommReviewCommentVO existingComment = commentService.getCommentById(commentVO.getCommentId());
        if (existingComment == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("댓글을 찾을 수 없습니다.");
        }

        if (!currentUserId.equals(existingComment.getUserId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 수정 권한이 없습니다.");
        }

        existingComment.setContent(commentVO.getContent());
        boolean success = commentService.modifyComment(existingComment);
        if (success) {
            return ResponseEntity.ok("댓글이 성공적으로 수정되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 수정에 실패했습니다.");
        }
    }

    /**
     * 특정 댓글을 삭제합니다. (논리적 삭제) (API)
     * DELETE /comm/review/comments/delete
     *
     * @param commentId      삭제할 댓글 ID
     * @param authentication Spring Security 인증 객체
     * @return 성공 시 200 OK, 실패 시 403 Forbidden 또는 500 Internal Server Error
     */
    @DeleteMapping("/comments/delete")
    @ResponseBody
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<String> deleteComment(@RequestParam("commentId") int commentId, Authentication authentication) {
        log.info("deleteComment() API 실행, commentId: {}", commentId);

        CustomUser user = (CustomUser) authentication.getPrincipal();
        String currentUserId = user.getUsername();

        CommReviewCommentVO commentVO = commentService.getCommentById(commentId);
        if (commentVO == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("댓글을 찾을 수 없습니다.");
        }

        CommReviewPostVO postVO = postService.getPost(commentVO.getPostId());
        if (postVO == null) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("연관된 게시글을 찾을 수 없습니다.");
        }

        boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (currentUserId.equals(commentVO.getUserId()) || isAdmin || currentUserId.equals(postVO.getUserId())) {
            boolean success = commentService.removeComment(commentId);
            if (success) {
                return ResponseEntity.ok("댓글이 성공적으로 삭제되었습니다.");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("댓글 삭제에 실패했습니다.");
            }
        } else {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("댓글 삭제 권한이 없습니다.");
        }
    }
}