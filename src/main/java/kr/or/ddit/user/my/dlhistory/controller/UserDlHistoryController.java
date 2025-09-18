package kr.or.ddit.user.my.dlhistory.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.security.Principal;
import java.util.List;
// 🟢 추가된 import
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value; // 🟢 추가된 import
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.user.my.dlhistory.service.UserDlHistoryService;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/report")
@RequiredArgsConstructor
public class UserDlHistoryController {
    
    // 🟢 application.properties에 정의된 파일 업로드 경로를 주입받음
    @Value("${file.upload-dir}")
    private String uploadDir;

    private final UserDlHistoryService userDlHistoryService;
    private final FileService fileService;

    // [수정] GetMapping 메소드 수정
    @GetMapping
    public String getHistoryList(Authentication authentication, Model model,
                                 @RequestParam(value = "page", defaultValue = "1") int currentPage,
                                 @RequestParam(value = "filterType", required = false) String filterType,
                                 @RequestParam(value = "keyword", required = false) String keyword) {
        
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/login";
        }
        String userId = authentication.getName();

        // 1. Service 호출 시 filterType과 keyword 전달
        ArticlePage<UserDlHistoryVO> articlePage = userDlHistoryService.getHistoryListByUserId(userId, currentPage, filterType, keyword);
        
        // 2. 페이징 URL에 필터와 검색어 파라미터를 포함시키기
        String url = "/my/report";
        String query = "";
        if (filterType != null && !filterType.isEmpty()) {
            query += "&filterType=" + filterType;
        }
        if (keyword != null && !keyword.isEmpty()) {
            try {
                query += "&keyword=" + URLEncoder.encode(keyword, "UTF-8");
            } catch (Exception e) {
                // 예외 처리
            }
        }
        
        if (!query.isEmpty()) {
            // 맨 앞의 '&'를 '?'로 변경
            url += "?" + query.substring(1); 
        }
        articlePage.setUrl(url);

        model.addAttribute("articlePage", articlePage);
        
        // 3. 현재 필터와 검색어 값을 다시 View로 전달하여 상태 유지
        model.addAttribute("filterType", filterType);
        model.addAttribute("keyword", keyword);


        return "my/report/historyList";
    }

    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<String> saveHistory(
            @RequestParam("reportFile") MultipartFile reportFile,
            @RequestParam("historyTitle") String historyTitle,
            @RequestParam("historyType") String historyType,
            @RequestParam(value = "analysisParams", required = false, defaultValue = "{}") String analysisParams,
            Principal principal) {
        try {
            long fileGroupNo = fileService.uploadFiles(new MultipartFile[]{reportFile}, "REPORT_FILE");
            if (fileGroupNo <= 0) {
                throw new RuntimeException("파일 저장에 실패했습니다.");
            }
            UserDlHistoryVO historyVO = new UserDlHistoryVO();
            historyVO.setUserId(principal.getName());
            historyVO.setFileGroupNo(fileGroupNo);
            historyVO.setHistoryType(historyType);
            historyVO.setHistoryTitle(historyTitle);
            historyVO.setAnalysisParams(analysisParams);

            userDlHistoryService.createHistory(historyVO);

            return ResponseEntity.ok("SUCCESS");

        } catch (Exception e) {
            log.error("이력 저장 중 오류 발생", e);
            return ResponseEntity.internalServerError().body("이력 저장 중 오류가 발생했습니다: " + e.getMessage());
        }
    }

    @GetMapping("/download/{fileGroupNo}")
    public void downloadFile(@PathVariable("fileGroupNo") Long fileGroupNo, 
                           HttpServletResponse response, 
                           Principal principal) {
        
        try {
            if (principal == null) {
                log.warn("Unauthorized download attempt for fileGroupNo: {}", fileGroupNo);
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            UserDlHistoryVO historyVO = userDlHistoryService.getHistoryByFileGroupNo(fileGroupNo);
            if (historyVO == null || !historyVO.getUserId().equals(principal.getName())) {
                log.warn("Unauthorized access attempt by user: {} for fileGroupNo: {}", 
                    principal.getName(), fileGroupNo);
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            List<FileDetailVO> fileList = fileService.getFileList(fileGroupNo);
            if (fileList == null || fileList.isEmpty()) {
                log.error("File not found for fileGroupNo: {}", fileGroupNo);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            FileDetailVO fileDetail = fileList.get(0);
            String webPath = fileDetail.getFileSaveLocate();
            String relativePath = webPath.substring(7);
            
            // 🟢 수정된 부분: Path.of를 사용하여 OS에 독립적인 경로 생성
            Path actualFilePath = Paths.get(uploadDir, relativePath);
            File file = actualFilePath.toFile();
            
            if (!file.exists() || !file.isFile()) {
                log.error("Physical file not found: {}", actualFilePath);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            String fileName = fileDetail.getFileOriginalName();
            String encodedFileName = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            
            String contentType = fileDetail.getFileMime();
            if (contentType == null || contentType.isEmpty()) {
                contentType = "application/octet-stream";
                if (fileName.toLowerCase().endsWith(".pdf")) {
                    contentType = "application/pdf";
                } else if (fileName.toLowerCase().endsWith(".xlsx")) {
                    contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                } else if (fileName.toLowerCase().endsWith(".xls")) {
                    contentType = "application/vnd.ms-excel";
                }
            }
            
            response.setContentType(contentType);
            response.setContentLength((int) fileDetail.getFileSize());
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + fileName + "\"; filename*=UTF-8''" + encodedFileName);

            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }

            log.info("File download completed - User: {}, FileGroupNo: {}, FileName: {}", 
                principal.getName(), fileGroupNo, fileName);

        } catch (IOException e) {
            log.error("File download error for fileGroupNo: {}, user: {}", 
                fileGroupNo, (principal != null ? principal.getName() : "unknown"), e);
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("Unexpected error during file download for fileGroupNo: {}, user: {}", 
                fileGroupNo, (principal != null ? principal.getName() : "unknown"), e);
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
}