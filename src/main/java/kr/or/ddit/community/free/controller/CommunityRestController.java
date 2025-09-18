package kr.or.ddit.community.free.controller;

import java.security.Principal;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.community.free.service.FreeCommentService;
import kr.or.ddit.community.free.service.FreePostService;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/comm/free")
@RequiredArgsConstructor
//페이지에 입장한 후에 게시글이나 댓글 데이터를 비동기로 주고받는 api 역할의 서버 컨트롤러 
public class CommunityRestController { 
    
    private final FreePostService freePostService;
    private final FreeCommentService freeCommentService;
    private final FileService fileService;

    /**
     * [AJAX] 특정 업종의 게시글 목록과 페이징 정보를 조회
     */
    @GetMapping("/{bizCodeId}/posts")
    public ResponseEntity<ArticlePage<CommFreePostVO>> getPostList(
            @PathVariable String bizCodeId,
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword) {

        log.info("getPostList 요청: bizCodeId={}, currentPage={}, size={}, keyword={}", bizCodeId, currentPage, size, keyword);
        try {
            int total = freePostService.getPostCountByBizCode(bizCodeId, keyword);
            List<CommFreePostVO> content = freePostService.getPostsByBizCode(bizCodeId, currentPage, size, keyword);
            ArticlePage<CommFreePostVO> page = new ArticlePage<>(total, currentPage, size, content, keyword);
            String url = String.format("/comm/free/%s", bizCodeId);
            page.setUrl(url);

            return ResponseEntity.ok(page);
        } catch (Exception e) {
            log.error("게시글 목록 조회 중 오류 발생: {}", e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                    .body(new ArticlePage<>(0, currentPage, size, null, keyword));
        }
    }

    /**
     * [AJAX] 특정 게시글의 상세 내용 조회
     */
    @LogEvent(eventType="VIEW", feature="FREE_DETAIL")
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

    /**
     * [AJAX] 게시글 수정
     */
    @PutMapping("/posts/{postId}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Map<String, String>> updatePost(
            @PathVariable int postId,
            @ModelAttribute CommFreePostVO postVO,
            @RequestParam(value = "attachments", required = false) MultipartFile[] attachments,
            Principal principal
    ) {
        log.info("updatePost 요청 수신: postId={}, title={}", postId, postVO.getTitle());
        Map<String, String> response = new HashMap<>();
        try {
            String currentUserId = principal.getName();
            postVO.setPostId(postId);
            postVO.setUserId(currentUserId);

            freePostService.updatePost(postVO, attachments);

            response.put("message", "게시글이 성공적으로 수정되었습니다.");
            return ResponseEntity.ok(response);
        } catch (IllegalAccessException e) {
            log.error("게시글 수정 권한 없음: {}", e.getMessage());
            response.put("message", e.getMessage());
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        } catch (Exception e) {
            log.error("게시글 수정 중 오류 발생: {}", e.getMessage(), e);
            response.put("message", "게시글 수정 중 오류가 발생했습니다: " + e.getMessage());
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
    
    @GetMapping("/latest")
    public ResponseEntity<CommFreePostVO> getLatestFreePost() {
    	 log.info("API 요청 수신: /api/comm/free/latest");
        CommFreePostVO latestPost = freePostService.getLatestFreePost();
        
        // 게시글이 없을 경우를 대비하여 null 체크 후 응답
        if (latestPost == null) {
            // 내용 없음(204 No Content) 또는 빈 객체를 보낼 수 있습니다.
            return ResponseEntity.noContent().build();
        }
        
        return ResponseEntity.ok(latestPost);
    }
}