package kr.or.ddit.user.my.community.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.community.free.service.FreeCommentService;
import kr.or.ddit.community.free.service.FreePostService;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import kr.or.ddit.user.my.community.service.MypageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/my/free")
@RequiredArgsConstructor
//페이지가 열린 후 자바스크립트가 필요한 api만 처리하는 서버 컨트롤러 
public class MypageRestController { 
    
	private final FreePostService freePostService;
	private final MypageService mypageService;
	private final FreeCommentService freeCommentService;
	private final FileService fileService;
	    
    
    /**
     * [AJAX] 로그인 사용자의 게시글 및 댓글 통계 조회
     */
    @GetMapping("/statistics")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<Map<String, Integer>> getMyStatistics(Principal principal) {
        String userId = principal.getName();
        log.info("getMyStatistics 요청: userId={}", userId);

        try {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);

            int postCount = mypageService.getPostCount(params);
            int commentCount = mypageService.getCommentCount(params);
            int totalCount = postCount + commentCount;

            Map<String, Integer> statistics = new HashMap<>();
            statistics.put("postCount", postCount);
            statistics.put("commentCount", commentCount);
            statistics.put("totalCount", totalCount);

            return ResponseEntity.ok(statistics);
        } catch (Exception e) {
            log.error("통계 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new HashMap<>());
        }
    }

    /** 
     * [AJAX] 특정 업종의 게시글 목록과 페이징 정보를 조회(bizCodeId가 없음)
     */
    @GetMapping("/posts")
    @PreAuthorize("isAuthenticated()") // ⭐⭐ 추가된 부분 ⭐⭐
    public ResponseEntity<ArticlePage<CommFreePostVO>> getPostsList(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            Principal principal ) {

    	String userId = principal.getName();
    	log.info("getPostsList->로그인 userId : " + userId);
    	
        log.info("getPostList 요청: bizCodeId={}, currentPage={}, size={}, keyword={}", null, currentPage, size, keyword);
        try {
            int total = mypageService.getPostCountByBizCode(userId, keyword);
            List<CommFreePostVO> content = mypageService.getPostsByBizCode(userId, currentPage, size, keyword);
            ArticlePage<CommFreePostVO> page = new ArticlePage<>(total, currentPage, size, content, keyword);
            String url = String.format("/comm/free/%s", null);
            page.setUrl(url);

            return ResponseEntity.ok(page);
        } catch (Exception e) {
            log.error("게시글 목록 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                    .body(new ArticlePage<>(0, currentPage, size, null, keyword));
        }
    }
    
    /**
     * ⭐⭐ [AJAX] 로그인 사용자의 게시글 또는 댓글 목록 조회 (수정됨) ⭐⭐
     * `boardAndChat.jsp`에서 '게시글', '댓글' 링크 클릭 시 호출되는 API입니다.
     */
    @GetMapping("/activities")
    @PreAuthorize("isAuthenticated()")
    @ResponseBody
    public ResponseEntity<ArticlePage<?>> getMyActivities(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String type,
            // ⭐⭐ 검색 파라미터 추가 ⭐⭐
            @RequestParam(required = false) String searchType,
            @RequestParam(required = false) String searchKeyword,
            Principal principal) {

        String userId = principal.getName();
        log.info("getMyActivities 요청: userId={}, currentPage={}, size={}, type={}, searchType={}, searchKeyword={}", 
                 userId, currentPage, size, type, searchType, searchKeyword);

        try {
            // ⭐⭐ 검색 조건 맵 생성 ⭐⭐
            Map<String, Object> searchParams = new HashMap<>();
            searchParams.put("userId", userId);
            searchParams.put("currentPage", currentPage);
            searchParams.put("size", size);
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                searchParams.put("searchType", searchType != null ? searchType : "all");
                searchParams.put("searchKeyword", searchKeyword.trim());
            }

            if ("comments".equals(type)) {
                // ⭐ 댓글만 조회하는 경우 (검색 적용) ⭐
                int totalComments = mypageService.getCommentCount(searchParams);
                List<CommFreeCommentVO> commentList = mypageService.getMyComments(searchParams);

                ArticlePage<CommFreeCommentVO> commentPage = new ArticlePage<>(totalComments, currentPage, size, commentList, null);
                commentPage.setUrl("/api/my/free/activities?type=comments");
                return ResponseEntity.ok(commentPage);

            } else if ("posts".equals(type)) {
                // ⭐ 게시글만 조회하는 경우 (검색 적용) ⭐
                int totalPosts = mypageService.getPostCount(searchParams);
                List<CommFreePostVO> postList = mypageService.getMyPosts(searchParams);

                ArticlePage<CommFreePostVO> postPage = new ArticlePage<>(totalPosts, currentPage, size, postList, null);
                postPage.setUrl("/api/my/free/activities?type=posts");
                return ResponseEntity.ok(postPage);
                
            } else {
                // ⭐⭐ 'all' 또는 type이 없을 때: 게시글과 댓글을 합쳐서 반환 (검색 적용) ⭐⭐
                
                // ⭐⭐ 검색이 있을 경우와 없을 경우 분기 처리 ⭐⭐
                if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                    // 검색이 있는 경우: 통합 검색 결과 조회
                    int totalAll = mypageService.getAllActivitiesCount(searchParams);
                    List<Object> allActivities = mypageService.getAllActivitiesWithSearch(searchParams);
                    
                    ArticlePage<Object> allPage = new ArticlePage<>(totalAll, currentPage, size, allActivities, null);
                    allPage.setUrl("/api/my/free/activities?type=all");
                    return ResponseEntity.ok(allPage);
                    
                } else {
                    // 검색이 없는 경우: 기존 로직 유지
                    int totalPosts = mypageService.getPostCount(searchParams);
                    int totalComments = mypageService.getCommentCount(searchParams);
                    int totalAll = totalPosts + totalComments;

                    // 게시글과 댓글을 모두 가져와서 통합 리스트 생성
                    List<Object> allActivities = new ArrayList<>();

                    Map<String, Object> allParams = new HashMap<>(searchParams);
                    allParams.put("currentPage", 1);
                    allParams.put("size", Math.max(totalPosts, totalComments)); // 충분한 크기로 설정

                    List<CommFreePostVO> postList = mypageService.getMyPosts(allParams);
                    List<CommFreeCommentVO> commentList = mypageService.getMyComments(allParams);

                    // 게시글과 댓글을 시간순으로 정렬하여 통합
                    allActivities.addAll(postList);
                    allActivities.addAll(commentList);

                    // ⭐⭐ 시간순 정렬 (최신순) ⭐⭐
                    allActivities.sort((a, b) -> {
                        Date dateA = getCreatedDate(a);
                        Date dateB = getCreatedDate(b);
                        return dateB.compareTo(dateA); // 내림차순 정렬
                    });

                    // 페이징 처리를 위해 전체 리스트에서 해당 페이지만 추출
                    int startIndex = (currentPage - 1) * size;
                    int endIndex = Math.min(startIndex + size, allActivities.size());

                    List<Object> pagedActivities = allActivities.subList(startIndex, endIndex);

                    ArticlePage<Object> allPage = new ArticlePage<>(totalAll, currentPage, size, pagedActivities, null);
                    allPage.setUrl("/api/my/free/activities?type=all");
                    return ResponseEntity.ok(allPage);
                }
            }
        } catch (Exception e) {
            log.error("내 활동 목록 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ArticlePage<>(0, currentPage, size, null, null));
        }
    }

    // ⭐⭐ 생성일자 추출 헬퍼 메서드 추가 ⭐⭐
    private Date getCreatedDate(Object obj) {
        if (obj instanceof CommFreePostVO) {
            return ((CommFreePostVO) obj).getCreatedAt();
        } else if (obj instanceof CommFreeCommentVO) {
            return ((CommFreeCommentVO) obj).getCreatedAt();
        }
        return new Date(); // 기본값
    }

    /**
     * [AJAX] 특정 게시글의 상세 내용 조회
     */
    @GetMapping("/posts/{postId}")
    public ResponseEntity<Map<String, Object>> getPostDetail(
            @PathVariable int postId,
            Principal principal,
            Authentication authentication) {
        log.info("getPostDetail 요청: postId={}", postId);
        Map<String, Object> response = new HashMap<>();
        try {
            CommFreePostVO post = freePostService.getPostByIdWithViewCount(postId);
            if (post == null) {
                log.warn("게시글을 찾을 수 없음: postId={}", postId);
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
            }
            List<CommFreeCommentVO> comments = freeCommentService.getCommentsByPostId(postId);

            String currentUserId = (principal != null) ? principal.getName() : null;
            String userRole = null;
            
            if (authentication != null && authentication.getPrincipal() instanceof UsersVO) {
                UsersVO usersVO = (UsersVO) authentication.getPrincipal();
                if (!usersVO.getUsersAuthVOList().isEmpty()) {
                    userRole = usersVO.getUsersAuthVOList().get(0).getAuth();
                }
            }

            response.put("post", post);
            response.put("comments", comments);
            response.put("currentUserId", currentUserId);
            response.put("currentUserRole", userRole);

            log.info("응답에 추가된 현재 로그인 사용자 ID: {}, 역할: {}", currentUserId, userRole);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("게시글 상세 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    /**
     * [AJAX] 새 게시글 작성
     */
    @PostMapping("/posts")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> createPost(
        @ModelAttribute CommFreePostVO commFreePostVO,
        @RequestParam(value = "attachments", required = false) MultipartFile[] attachments,
        Principal principal
    ) {
        log.info("createPost 요청 수신: title={}, bizCodeId={}", 
                commFreePostVO.getTitle(), commFreePostVO.getBizCodeId());
        Map<String, String> response = new HashMap<>();
        try {
            String userId = principal.getName();
            commFreePostVO.setUserId(userId);
            log.info("게시글 작성에 사용할 userId: {}", userId);
            log.info("컨트롤러에서 받은 VO: {}", commFreePostVO);

            freePostService.createPost(commFreePostVO, attachments);

            response.put("message", "게시글이 성공적으로 작성되었습니다.");
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("게시글 작성 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "게시글 작성 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PutMapping(value = "/posts/{postId}", consumes = MediaType.APPLICATION_JSON_VALUE)
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> updatePostJson(
            @PathVariable int postId,
            @RequestBody CommFreePostVO postVO,   // ✅ JSON 매핑
            Principal principal
    ) {
    	log.info("updatePost(JSON) 요청 수신: postId={}, title={}", postId, postVO.getTitle());
        Map<String, String> response = new HashMap<>();
        try {
            postVO.setPostId(postId);
            postVO.setUserId(principal.getName());

            freePostService.updatePost(postVO, null); // 파일 없음
            response.put("message", "게시글이 성공적으로 수정되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalAccessException e) {
            log.error("권한 없음: {}", e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류", e);
            response.put("message", "게시글 수정 중 오류: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * [AJAX] 게시글 삭제
     */
    @DeleteMapping("/posts/{postId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> deletePost(
            @PathVariable int postId,
            Principal principal,
            Authentication authentication
    ) {
        log.info("deletePost 요청 수신: postId={}", postId);
        Map<String, String> response = new HashMap<>();
        try {
            String currentUserId = principal.getName();
            String userRole = null;
            if (authentication.getPrincipal() instanceof UsersVO) {
                UsersVO usersVO = (UsersVO) authentication.getPrincipal();
                if (!usersVO.getUsersAuthVOList().isEmpty()) {
                    userRole = usersVO.getUsersAuthVOList().get(0).getAuth();
                }
            }
            freePostService.deletePost(postId, currentUserId, userRole);

            response.put("message", "게시글이 성공적으로 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalAccessException e) {
            log.error("게시글 삭제 권한 없음: {}", e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            log.error("게시글 삭제 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "게시글 삭제 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * [AJAX] 댓글 작성
     */
    @PostMapping("/posts/{postId}/comments")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> createComment(
            @PathVariable int postId,
            @ModelAttribute CommFreeCommentVO commentVO,
            Principal principal
    ) {
        log.info("createComment 요청 수신: postId={}, commentContent={}", postId, commentVO.getContent());
        Map<String, String> response = new HashMap<>();
        try {
            String userId = principal.getName();
            commentVO.setPostId(postId);
            commentVO.setUserId(userId);

            freeCommentService.createComment(commentVO);

            response.put("message", "댓글이 성공적으로 작성되었습니다.");
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            log.error("댓글 작성 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "댓글 작성 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * [AJAX] 댓글 수정
     */
    @PutMapping("/comments/{commentId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> updateComment(
            @PathVariable int commentId,
            @ModelAttribute CommFreeCommentVO commentVO,
            Principal principal
    ) {
        log.info("updateComment 요청 수신: commentId={}, commentContent={}", commentId, commentVO.getContent());
        Map<String, String> response = new HashMap<>();
        try {
            String currentUserId = principal.getName();
            commentVO.setCommentId(commentId);
            commentVO.setUserId(currentUserId);

            freeCommentService.updateComment(commentVO, currentUserId);

            response.put("message", "댓글이 성공적으로 수정되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalAccessException e) {
            log.error("댓글 수정 권한 없음: {}", e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            log.error("댓글 수정 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "댓글 수정 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * [AJAX] 댓글 삭제
     */
    @DeleteMapping("/comments/{commentId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> deleteComment(
            @PathVariable int commentId,
            Principal principal,
            Authentication authentication
    ) {
        log.info("deleteComment 요청 수신: commentId={}", commentId);
        Map<String, String> response = new HashMap<>();
        try {
            String currentUserId = principal.getName();
            String userRole = null;
            if (authentication.getPrincipal() instanceof UsersVO) {
                UsersVO usersVO = (UsersVO) authentication.getPrincipal();
                if (!usersVO.getUsersAuthVOList().isEmpty()) {
                    userRole = usersVO.getUsersAuthVOList().get(0).getAuth();
                }
            }
            freeCommentService.deleteComment(commentId, currentUserId, userRole);

            response.put("message", "댓글이 성공적으로 삭제되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalAccessException e) {
            log.error("댓글 삭제 권한 없음: {}", e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            log.error("댓글 삭제 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "댓글 삭제 중 오류가 발생했습니다: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * CKEditor 이미지 업로드 처리
     */
    @PostMapping(value = "/images/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, Object>> uploadFromCkeditor(
            @RequestParam("upload") MultipartFile upload,
            @RequestParam(value = "groupNo", required = false) Long groupNo) {

        if (upload == null || upload.isEmpty()) {
            return ResponseEntity.badRequest()
                    .body(Map.of("error", Map.of("message", "빈 파일")));
        }

        FileDetailVO saved = fileService.saveEditorImage(upload, groupNo);
        String absoluteUrl = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path(saved.getFileSaveLocate())
                .toUriString();

        return ResponseEntity.ok(Map.of(
                "url", absoluteUrl,
                "fileGroupNo", saved.getFileGroupNo()
        ));
    }
    
    /**
     * 첨부파일 목록 조회
     */
    @GetMapping("/files")
    public ResponseEntity<List<FileDetailVO>> getFiles(@RequestParam("groupNo") long groupNo) {
        List<FileDetailVO> list = fileService.getFileList(groupNo);
        return ResponseEntity.ok(list);
    }
}