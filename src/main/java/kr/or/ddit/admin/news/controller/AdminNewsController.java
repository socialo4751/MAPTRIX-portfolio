package kr.or.ddit.admin.news.controller;

// --- 필요한 클래스 Import ---
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.community.news.service.NewsPostService;
import kr.or.ddit.community.news.vo.CommNewsPostVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Slf4j // ★ 로그 사용을 위해 추가
@Controller
@RequestMapping("/admin/news")
public class AdminNewsController {

    private static final int PAGE_SIZE = 10;
    private final NewsPostService newsBoardService;
    private final CodeService codeService;
    private final FileService fileService; // ★ FileService 주입

   
    @Autowired
    public AdminNewsController(NewsPostService newsBoardService, CodeService codeService, FileService fileService) {
        this.newsBoardService = newsBoardService;
        this.codeService = codeService;
        this.fileService = fileService;
    }

    // 1) 뉴스 목록
    @GetMapping
    public String listNews(
            @RequestParam(defaultValue = "1") int currentPage,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "title_content") String searchType,
            @RequestParam(required = false) String keyword,
            Model model
    ) {
        model.addAttribute("nsearchTags", codeService.getCodeDetailList("NSEARCHTAG"));
        model.addAttribute("newsTags", codeService.getCodeDetailList("NEWSTAG"));

        Map<String, Object> params = new HashMap<>();
        params.put("startDate", startDate);
        params.put("endDate", endDate);
        params.put("searchType", searchType);
        params.put("keyword", keyword == null ? "" : keyword);
        int startRow = (currentPage - 1) * PAGE_SIZE + 1;
        int endRow = currentPage * PAGE_SIZE;
        params.put("startRow", startRow);
        params.put("endRow", endRow);

        int total = newsBoardService.getTotalNewsCount(params);
        List<CommNewsPostVO> content = newsBoardService.getNewsList(params);

        ArticlePage<CommNewsPostVO> articlePage =
                new ArticlePage<>(total, currentPage, PAGE_SIZE, content, keyword);

     
        StringBuilder url = new StringBuilder("/admin/news?");
        if (startDate != null && !startDate.isEmpty()) url.append("startDate=").append(startDate).append("&");
        if (endDate != null && !endDate.isEmpty()) url.append("endDate=").append(endDate).append("&");
        if (searchType != null && !searchType.isEmpty()) url.append("searchType=").append(searchType).append("&");
        if (keyword != null && !keyword.isEmpty()) {
            url.append("keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8)).append("&");
        }
        articlePage.setUrl(url.toString());

        model.addAttribute("articlePage", articlePage);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);

        return "admin/board/news/list";
    }

    // 2) 뉴스 상세
    @GetMapping("/detail")
    public String detailNews(@RequestParam("newsId") int newsId, Model model) {
        CommNewsPostVO newsPost = newsBoardService.getNewsDetail(newsId);
        model.addAttribute("newsPost", newsPost);
        return "admin/board/news/detail";
    }

    // 3) 뉴스 등록 폼
    @GetMapping("/form")
    public String insertForm(Model model) {
        model.addAttribute("newsPost", new CommNewsPostVO());
        return "admin/board/news/form";
    }

  
    /**
     * [수정] 뉴스 등록 처리
     */
    @PostMapping("/insert")
    public String insertNews(
            @ModelAttribute CommNewsPostVO newsPost,
            RedirectAttributes ra
    ) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            ra.addFlashAttribute("errorMessage", "로그인 후 다시 시도해주세요.");
            return "redirect:/login";
        }
        newsPost.setAdminId(authentication.getName());

        try {
            // ========================= [디버깅 로그 추가] =========================
            // 1. CKEditor에서 전송된 원본 content 내용을 확인합니다.
            log.info("### [1] CKEditor에서 받은 원본 content: {}", newsPost.getContent());

            String thumbnailUrl = extractFirstImageUrl(newsPost.getContent());
            
            // 2. 이미지 URL 추출 결과를 확인합니다. (null인지, 경로가 맞는지)
            log.info("### [2] 추출된 썸네일 URL: {}", thumbnailUrl);
            // =====================================================================
            
            newsPost.setThumbnailUrl(thumbnailUrl);
            boolean result = newsBoardService.insertNews(newsPost);

            if (result) {
                ra.addFlashAttribute("message", "뉴스가 성공적으로 등록되었습니다.");
                return "redirect:/admin/news";
            } else {
                ra.addFlashAttribute("errorMessage", "뉴스 등록에 실패했습니다.");
                return "redirect:/admin/news/form";
            }
        } catch (Exception e) {
            log.error("뉴스 등록 중 오류 발생", e);
            ra.addFlashAttribute("errorMessage", "처리 중 오류가 발생했습니다.");
            return "redirect:/admin/news/form";
        }
    }

 
    @GetMapping("/update")
    public String updateForm(@RequestParam("newsId") int newsId, Model model) {
        CommNewsPostVO newsPost = newsBoardService.getNewsDetail(newsId);
        model.addAttribute("newsPost", newsPost);
        
        // 기존 썸네일 파일 정보 조회
        if (newsPost.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(newsPost.getFileGroupNo());
            if (files != null && !files.isEmpty()) {
                model.addAttribute("existingThumbnail", files.get(0));
            }
        }
        return "admin/board/news/update";
    }

  
    /**
     * [수정] 뉴스 수정 처리
     */
    @PostMapping("/update")
    public String updateNews(
            @ModelAttribute CommNewsPostVO newsPost,
            // @RequestParam(value = "thumbnailFile", required = false) MultipartFile thumbnailFile, // 더 이상 사용하지 않음
            // @RequestParam(value = "deleteThumbnail", defaultValue = "false") boolean deleteThumbnail, // 더 이상 사용하지 않음
            RedirectAttributes ra
    ) {
        try {
            // [수정된 로직 1]
            // 수정된 본문 내용(content)에서 첫 번째 이미지 URL을 다시 추출하여 thumbnailUrl 필드에 저장
            // 본문에 이미지가 없다면 thumbnailUrl은 null이 됩니다.
            String thumbnailUrl = extractFirstImageUrl(newsPost.getContent());
            newsPost.setThumbnailUrl(thumbnailUrl);

            // [주석 처리] 기존의 별도 썸네일 파일 관리 로직은 사용하지 않음
            /*
            int fileGroupNo = newsPost.getFileGroupNo();
            if (deleteThumbnail && fileGroupNo > 0) {
                fileGroupNo = 0;
            }
            if (thumbnailFile != null && !thumbnailFile.isEmpty()) {
                fileGroupNo = (int) fileService.uploadFiles(new MultipartFile[]{thumbnailFile}, "news_thumbnail", 0);
            }
            newsPost.setFileGroupNo(fileGroupNo);
            */

            newsBoardService.updateNews(newsPost);
            
            ra.addFlashAttribute("message", "뉴스가 성공적으로 수정되었습니다.");
            return "redirect:/admin/news/detail?newsId=" + newsPost.getNewsId();
        } catch (Exception e) {
            log.error("뉴스 수정 중 오류 발생", e);
            ra.addFlashAttribute("errorMessage", "처리 중 오류가 발생했습니다.");
            return "redirect:/admin/news/update?newsId=" + newsPost.getNewsId();
        }
    }

    
    @PostMapping("/delete")
    public String deleteNews(@RequestParam("newsId") int newsId, RedirectAttributes ra) {
        log.info("뉴스 삭제 요청 시작 - ID: {}", newsId);
        try {
            // ★★★★★ [수정] 1. 파일 삭제 대신, 게시글과 파일의 '연결'을 끊습니다. ★★★★★
            newsBoardService.disconnectFileFromNews(newsId);

            // 2. 뉴스 게시글을 논리적 삭제합니다.
            boolean result = newsBoardService.deleteNews(newsId);
            if (result) {
                log.info("뉴스(ID: {}) 논리적 삭제 성공.", newsId);
                ra.addFlashAttribute("message", "뉴스가 성공적으로 삭제되었습니다.");
            } else {
                log.warn("뉴스(ID: {}) 논리적 삭제 실패.", newsId);
                ra.addFlashAttribute("errorMessage", "뉴스 삭제에 실패했습니다.");
            }
        } catch (Exception e) {
            log.error("뉴스(ID: {}) 삭제 중 심각한 오류 발생", newsId, e);
            ra.addFlashAttribute("errorMessage", "처리 중 서버 오류가 발생했습니다.");
        }
        return "redirect:/admin/news";
    }
    
    /**
     * [추가] HTML 본문에서 첫 번째 이미지 URL을 추출하는 헬퍼(helper) 메소드
     * @param htmlContent 본문 HTML 내용
     * @return 추출된 src 값 또는 null
     */
    private String extractFirstImageUrl(String htmlContent) {
        if (htmlContent == null || htmlContent.isEmpty()) {
            return null;
        }
        // 정규 표현식을 사용하여 첫 번째 img 태그의 src 속성 값 추출
        Pattern pattern = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
        Matcher matcher = pattern.matcher(htmlContent);
        if (matcher.find()) {
            return matcher.group(1); // 첫 번째로 매칭된 그룹(src 값) 반환
        }
        return null;
    }
    // =================================================================================
    // [추가] CKEditor 이미지 업로드 처리를 위한 메소드
    // 이 메소드를 AdminNewsController 안에 추가합니다.
    // =================================================================================
    @PostMapping("/image/upload")
    @ResponseBody // 데이터를 View가 아닌 Response Body에 직접 쓰도록 설정 (JSON 반환)
    public ResponseEntity<Map<String, Object>> uploadEditorImage(
            @RequestParam("upload") MultipartFile upload) {

        // CKEditor는 'upload'라는 이름으로 파일을 보냅니다.
        if (upload == null || upload.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }

        log.info("CKEditor 이미지 업로드 요청 (in AdminNewsController): {}", upload.getOriginalFilename());

        try {
            // 기존 FileService의 에디터 이미지 저장 메소드를 호출합니다.
            FileDetailVO savedFile = fileService.saveEditorImage(upload, 0L);

            // CKEditor가 요구하는 JSON 형식에 맞춰 응답 데이터를 구성합니다.
            Map<String, Object> response = new HashMap<>();
            response.put("uploaded", 1);
            response.put("fileName", savedFile.getFileOriginalName());
            response.put("url", savedFile.getFileSaveLocate()); 

            log.info("CKEditor 이미지 업로드 완료, URL: {}", savedFile.getFileSaveLocate());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("CKEditor 이미지 업로드 중 오류 발생", e);
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("uploaded", 0);
            Map<String, String> error = new HashMap<>();
            error.put("message", "이미지 업로드에 실패했습니다: " + e.getMessage());
            errorResponse.put("error", error);
            return ResponseEntity.internalServerError().body(errorResponse);
        }
    }
}