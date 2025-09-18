package kr.or.ddit.community.news.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.community.news.service.NewsPostService;
import kr.or.ddit.community.news.vo.CommNewsPostVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.Matcher;


@Slf4j
@Controller
@RequestMapping("/comm/news")
@RequiredArgsConstructor
public class NewsPostController {

  
    private final NewsPostService newsBoardService;
    private final CodeService codeService;
    private final FileService fileService;

    // 뉴스 목록 페이지
    @LogEvent(eventType="VIEW", feature="NEWS") 
    @GetMapping
    public String newsBoardList(
            @RequestParam(name="currentPage", defaultValue="1") int currentPage,
            @RequestParam(name="searchType", defaultValue="title_content") String searchType,
            @RequestParam(name="keyword", defaultValue="") String keyword,
            @RequestParam(name="startDate", required=false) String startDate,
            @RequestParam(name="endDate", required=false) String endDate,
            HttpServletRequest request,
            Model model
    ) {
        model.addAttribute("nsearchTags", codeService.getCodeDetailList("NSEARCHTAG"));
        model.addAttribute("newsTags", codeService.getCodeDetailList("NEWSTAG"));

        // --- 이하 기존 로직 그대로 ---
        int size = 12;
        Map<String,Object> searchMap = new HashMap<>();
        searchMap.put("searchType", searchType);
        searchMap.put("keyword", keyword);
        searchMap.put("currentPage", currentPage);
        searchMap.put("size", size);
        searchMap.put("startDate", startDate);
        searchMap.put("endDate", endDate);

        int totalCount = newsBoardService.getTotalNewsCount(searchMap);
        List<CommNewsPostVO> newsList = newsBoardService.getNewsList(searchMap);
        
        // ★★★ [핵심 로직] 본문(content)에서 첫 이미지(src)를 추출하여 thumbnailUrl에 저장 ★★★
        for (CommNewsPostVO news : newsList) {
            String htmlContent = news.getContent();
            if (htmlContent != null && !htmlContent.isEmpty()) {
                Pattern pattern = Pattern.compile("<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>");
                Matcher matcher = pattern.matcher(htmlContent);
                if (matcher.find()) {
                    news.setThumbnailUrl(matcher.group(1)); // 추출한 URL을 VO에 저장
                }
            }
        }

        String requestUri = request.getRequestURI();
        ArticlePage<CommNewsPostVO> articlePage =
                new ArticlePage<>(totalCount, currentPage, size, newsList, keyword);
        
        // ✅ 페이징 시 검색 상태 유지(선택)
        StringBuilder qs = new StringBuilder();
        if (!keyword.isEmpty())   qs.append("&keyword=").append(java.net.URLEncoder.encode(keyword, java.nio.charset.StandardCharsets.UTF_8));
        if (!searchType.isEmpty())qs.append("&searchType=").append(searchType);
        if (startDate != null && !startDate.isEmpty()) qs.append("&startDate=").append(startDate);
        if (endDate   != null && !endDate.isEmpty())   qs.append("&endDate=").append(endDate);
        articlePage.setUrl(requestUri + (qs.length()>0 ? "?"+qs.substring(1) : ""));

        model.addAttribute("articlePage", articlePage);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        return "comm/news/newsList";
    }

    // 뉴스 상세 페이지
    @LogEvent(eventType="VIEW", feature="NEWS_DETAIL")
    @GetMapping("/detail")
    public String newsBoardDetail(@RequestParam("newsId") int newsId, Model model) {
        log.info("뉴스 상세 조회 요청 - 뉴스 ID: {}", newsId);

        // ★★★ [수정] 데이터베이스에서 가져온 내용을 가공 없이 그대로 전달합니다. ★★★
        CommNewsPostVO newsPost = newsBoardService.getNewsDetail(newsId);
        model.addAttribute("newsPost", newsPost);

        return "comm/news/newsDetail";
    }

    // 뉴스 등록 폼 페이지
    @GetMapping("/form")
    public String newsBoardInsert() {
        return "comm/news/newsInsert";
    }

    // 뉴스 등록 처리 (폼 제출)
	/*
	 * @PostMapping("/insert") public String insertNews(@ModelAttribute
	 * CommNewsPostVO newsPostVO, RedirectAttributes ra) {
	 * log.info("뉴스 등록 처리 요청 - 제목: {}", newsPostVO.getTitle());
	 * 
	 * Authentication authentication =
	 * SecurityContextHolder.getContext().getAuthentication(); String
	 * loggedInAdminId = null;
	 * 
	 * // --- 핵심 디버깅을 위한 로그 추가 시작 ---
	 * log.info("Spring Security Authentication 객체: {}", authentication); if
	 * (authentication != null) {
	 * log.info("Spring Security Authentication.isAuthenticated(): {}",
	 * authentication.isAuthenticated());
	 * log.info("Spring Security Authentication.getPrincipal(): {}",
	 * authentication.getPrincipal());
	 * log.info("Spring Security Authentication.getAuthorities(): {}",
	 * authentication.getAuthorities()); } // --- 핵심 디버깅을 위한 로그 추가 끝 ---
	 * 
	 * if (authentication != null && authentication.isAuthenticated()) {
	 * loggedInAdminId = authentication.getName(); // 현재 로그인된 사용자(관리자)의 ID // 만약
	 * loggedInAdminId가 실제로 사용하려는 ADMIN_ID가 아니라면, // CustomUserDetails와 같은 커스텀
	 * UserDetails 객체를 사용하는 경우 여기서 추가 로직 필요 // 예: if (authentication.getPrincipal()
	 * instanceof CustomUserDetails) { // CustomUserDetails userDetails =
	 * (CustomUserDetails) authentication.getPrincipal(); // loggedInAdminId =
	 * userDetails.getAdminId(); // }
	 * 
	 * // --- 이 로그가 가장 중요합니다. 이 시점의 loggedInAdminId 값을 확인하세요. ---
	 * log.info("뉴스 폼 등록: 설정될 ADMIN_ID (loggedInAdminId): {}", loggedInAdminId); //
	 * ---
	 * 
	 * newsPostVO.setAdminId(loggedInAdminId); // CommNewsPostVO에 ADMIN_ID 설정
	 * 
	 * } else { // 로그인 정보가 없거나 인증되지 않은 경우
	 * log.error("뉴스 폼 등록: 인증된 사용자(ADMIN_ID) 정보를 찾을 수 없습니다. 로그인 상태를 확인하세요.");
	 * ra.addFlashAttribute("errorMessage",
	 * "관리자 정보가 없어 뉴스를 등록할 수 없습니다. 다시 로그인해주세요."); return "redirect:/login"; // 예시:
	 * 로그인 페이지로 리다이렉트 (실제 경로 확인 필요) }
	 * 
	 * // 서비스 계층으로 데이터 전달 boolean result = newsBoardService.insertNews(newsPostVO);
	 * // 이 라인에서 ORA-01400 발생
	 * 
	 * if (result) { ra.addFlashAttribute("message", "뉴스 게시글이 성공적으로 등록되었습니다!");
	 * return "redirect:/comm/news"; // 뉴스 목록 페이지로 리다이렉트 } else {
	 * ra.addFlashAttribute("error", "뉴스 게시글 등록에 실패했습니다."); return
	 * "redirect:/comm/news/form"; // 뉴스 등록 폼으로 다시 이동 (GET 매핑 경로) }
	 * 
	 * }
	 */

    // 뉴스 수정 폼 페이지 (기존 데이터 로드)
    @GetMapping("/update")
    public String newsBoardUpdate(@RequestParam("newsId") int newsId, Model model) {
        log.info("뉴스 수정 폼 요청 - 뉴스 ID: {}", newsId);

        CommNewsPostVO newsPost = newsBoardService.getNewsDetail(newsId);
        model.addAttribute("newsPost", newsPost);

        return "comm/news/newsUpdate";
    }

    // 뉴스 수정 처리 (폼 제출)
    @PostMapping("/updateNews")
    public String updateNews(@ModelAttribute CommNewsPostVO newsPostVO, RedirectAttributes ra) {
        log.info("뉴스 수정 처리 요청 - 뉴스 ID: {}, 제목: {}", newsPostVO.getNewsId(), newsPostVO.getTitle());

        boolean result = newsBoardService.updateNews(newsPostVO);

        if (result) {
            ra.addFlashAttribute("message", "뉴스 게시글이 성공적으로 수정되었습니다!");
            return "redirect:/comm/news/detail?newsId=" + newsPostVO.getNewsId();
        } else {
            ra.addFlashAttribute("error", "뉴스 게시글 수정에 실패했습니다.");
            return "redirect:/comm/news/newsUpdate?newsId=" + newsPostVO.getNewsId();
        }
    }

    // 뉴스 삭제 처리 (논리적 삭제)
    // POST 요청을 처리하며, "/deleteNews" 경로에 매핑됩니다.
    @PostMapping("/delete")
    public String deleteNews(@RequestParam("newsId") int newsId, RedirectAttributes ra) {
        // 로그를 통해 뉴스 삭제 요청이 들어왔음을 기록합니다.
        log.info("뉴스 삭제 처리 요청 - 뉴스 ID: {}", newsId);

        // newsBoardService를 통해 뉴스 삭제 로직을 호출하고 결과를 받습니다.
        boolean result = newsBoardService.deleteNews(newsId);

        // 삭제 결과에 따라 다른 메시지를 RedirectAttributes에 추가하고 리다이렉트합니다.
        if (result) {
            // 삭제 성공 시, 성공 메시지를 flash attribute로 추가합니다.
            ra.addFlashAttribute("message", "뉴스 게시글이 성공적으로 삭제되었습니다.");
            // 뉴스 목록 페이지로 리다이렉트합니다.
            return "redirect:/comm/news";
        } else {
            // 삭제 실패 시, 에러 메시지를 flash attribute로 추가합니다.
            ra.addFlashAttribute("error", "뉴스 게시글 삭제에 실패했습니다.");
            // 뉴스 목록 페이지로 다시 리다이렉트하거나, 필요에 따라 다른 페이지로 이동할 수 있습니다.
            // 여기서는 삭제 실패 시에도 목록으로 돌아가도록 설정했습니다.
            return "redirect:/comm/news"; // 또는 "redirect:/comm/detail?newsId=" + newsId; (상세 페이지로 돌아가려면)
        }
    }

    // 네이버 뉴스 검색 API 호출 메서드 (서비스 계층으로 위임)
    @PostMapping("/searchNews")
    @ResponseBody
    public String searchNews(@RequestParam("keyword") String keyword) throws IOException {
        log.info("AJAX 뉴스 검색 요청 - 키워드: {}", keyword);
        String apiResponse = newsBoardService.searchBigkindsNews(keyword);
        log.info("AJAX 뉴스 검색 응답 수신 - 키워드: {}", keyword);
        return apiResponse;
    }

    // AJAX를 통해 가져온 뉴스 데이터를 DB에 저장하는 메서드
    @PostMapping("/saveNewsFromApi")
    @ResponseBody
    public Map<String, Object> saveNewsFromApi(@RequestBody String apiResponseJson) {
        log.info("API로부터 받은 뉴스 데이터 DB 저장 요청 (JSON 수신)");
        Map<String, Object> response = new HashMap<>();
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            JsonNode rootNode = objectMapper.readTree(apiResponseJson);

            List<CommNewsPostVO> newsList = new ArrayList<>();
            Map<String, List<String>> newsTagsMap = new HashMap<>();

            JsonNode itemsNode = rootNode.path("items");
            if (itemsNode.isArray()) {
                // API 뉴스 저장 시 사용될 ADMIN_ID를 미리 결정합니다.
                String adminIdForApiNews = null;
                Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
                if (authentication != null && authentication.isAuthenticated()) {
                    adminIdForApiNews = authentication.getName();
                    log.debug("API 뉴스 저장: 로그인된 ADMIN_ID 사용: {}", adminIdForApiNews);
                } else {
                    // 로그인되지 않은 상태이거나 인증되지 않은 경우
                    // FIXME: 이 부분을 적절한 시스템 관리자 ID로 변경하거나, 아예 오류를 발생시켜야 합니다.
                    // 현재 SYSTEM_ADMIN이 DB에 없다면 이 부분이 다시 ORA-01400의 원인이 될 수 있습니다.
                    adminIdForApiNews = "SYSTEM_ADMIN"; // 예시: 시스템 계정 ID
                    log.warn("API 뉴스 저장: 인증된 관리자 ID를 찾을 수 없습니다. '{}'으로 설정합니다.", adminIdForApiNews);
                }

                for (JsonNode articleNode : (ArrayNode) itemsNode) {
                    CommNewsPostVO news = new CommNewsPostVO();
                    news.setTitle(articleNode.path("title").asText());
                    news.setContent(articleNode.path("content").asText());
                    news.setPress(articleNode.path("press").asText());
                    news.setApiNewsId(articleNode.path("apiNewsId").asText());
                    news.setLinkUrl(articleNode.path("linkUrl").asText());

                    // 결정된 ADMIN_ID를 각 뉴스 객체에 설정
                    news.setAdminId(adminIdForApiNews); // <--- 여기가 중요!

                    if (articleNode.has("publishedAt")) {
                        String publishedAtStr = articleNode.path("publishedAt").asText();
                        try {
                            SimpleDateFormat apiDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
                            news.setPublishedAt(apiDateFormat.parse(publishedAtStr));
                        } catch (java.text.ParseException e) {
                            log.warn("PUBLISHED_AT 문자열 파싱 실패 (API): " + publishedAtStr, e);
                            news.setPublishedAt(null);
                        }
                    } else {
                        news.setPublishedAt(null);
                    }

                    newsList.add(news);

                    if (articleNode.has("tags") && articleNode.get("tags").isArray()) {
                        List<String> tags = new ArrayList<>();
                        for (JsonNode tagNode : (ArrayNode) articleNode.get("tags")) {
                            tags.add(tagNode.asText());
                        }
                        if (news.getApiNewsId() != null && !news.getApiNewsId().isEmpty()) {
                            newsTagsMap.put(news.getApiNewsId(), tags);
                        } else {
                            log.warn("API 뉴스 ID가 없어 태그 맵에 추가할 수 없습니다. 뉴스: {}", news.getTitle());
                        }
                    }
                }
            } else {
                log.warn("API 응답 JSON에 'items' 배열이 없거나 형식이 올바르지 않습니다.");
                response.put("success", false);
                response.put("message", "API 응답 형식이 올바르지 않습니다.");
                return response;
            }

            int savedCount = newsBoardService.saveBigkindsNews(newsList, newsTagsMap);

            response.put("success", true);
            response.put("message", savedCount + "건의 뉴스가 성공적으로 저장되었습니다.");
            response.put("savedCount", savedCount);

        } catch (Exception e) {
            log.error("API 뉴스 데이터 저장 중 오류 발생: {}", e.getMessage(), e);
            response.put("success", false);
            response.put("message", "뉴스 데이터 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
        return response;
    }
    
    /**
     * CKEditor에서 이미지 업로드 시 처리할 엔드포인트
     * @param upload CKEditor에서 'upload'라는 이름으로 보내는 MultipartFile
     * @return      CKEditor가 요구하는 JSON 형식의 응답 (e.g., {"uploaded": 1, "url": "..."})
     */
    @PostMapping("/image/upload")
    @ResponseBody
    public Map<String, Object> uploadImageFromEditor(@RequestParam("upload") MultipartFile upload) {
        log.info("CKEditor 이미지 업로드 요청 수신: {}", upload.getOriginalFilename());

        Map<String, Object> response = new HashMap<>();

        // 업로드된 파일이 비어있는지 확인
        if (upload == null || upload.isEmpty()) {
            response.put("uploaded", 0);
            Map<String, String> error = new HashMap<>();
            error.put("message", "업로드할 파일이 없습니다.");
            response.put("error", error);
            return response;
        }

        try {
            // FileService를 호출하여 파일을 저장합니다.
            // 게시글 등록 전이므로, 아직 파일 그룹 번호(fileGroupNo)는 없습니다.
            // saveEditorImage 메서드가 새로운 파일 그룹을 생성하고 파일을 저장할 것입니다.
        	  FileDetailVO fileDetail = newsBoardService.uploadImageForEditor(upload);

            // CKEditor가 성공 응답으로 인식하는 JSON 형식 생성
            response.put("uploaded", 1);
            response.put("fileName", fileDetail.getFileOriginalName());
            response.put("url", fileDetail.getFileSaveLocate()); // 파일이 웹에서 접근 가능한 URL
            response.put("fileGroupNo", fileDetail.getFileGroupNo()); 
            return response;

        } catch (Exception e) {
            log.error("CKEditor 이미지 업로드 실패", e);

            // CKEditor가 실패 응답으로 인식하는 JSON 형식 생성
            response.put("uploaded", 0);
            Map<String, String> error = new HashMap<>();
            error.put("message", "파일 업로드 중 오류가 발생했습니다: " + e.getMessage());
            response.put("error", error);
            return response;
        }
    }
}