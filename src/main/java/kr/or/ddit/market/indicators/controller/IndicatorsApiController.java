package kr.or.ddit.market.indicators.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.user.my.dlhistory.service.UserDlHistoryService;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/api/market/dashboard")
@Slf4j
@RestController
@RequiredArgsConstructor
public class IndicatorsApiController {
	
	@Value("${file.upload-dir}")
    private String uploadDir;
    
    private final UserDlHistoryService userDlHistoryService;
    
    /**
     * 엑셀 다운로드 로그를 user_dl_history 테이블에 저장하는 API
     * @param requestBody 다운로드한 파일명 정보가 담긴 Map
     * @param principal 현재 로그인한 사용자 정보
     * @return 성공/실패 응답
     */
    @PostMapping("/excel-download-log")
    public ResponseEntity<?> logExcelDownload(
            @RequestBody Map<String, String> requestBody, 
            Principal principal) {
        
        try {
            // 1. 로그인 여부 확인
            if (principal == null) {
                log.warn("엑셀 다운로드 로그 저장 시도 - 비로그인 사용자");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("error", "로그인이 필요합니다."));
            }
            
            String userId = principal.getName();
            String indicatorName = requestBody.get("indicatorName");
            
            // 2. 필수 파라미터 검증
            if (indicatorName == null || indicatorName.trim().isEmpty()) {
                log.warn("엑셀 다운로드 로그 저장 실패 - 파일명 누락, 사용자: {}", userId);
                return ResponseEntity.badRequest()
                    .body(Map.of("error", "파일명이 누락되었습니다."));
            }
            
            // 3. historyType 결정 (파일명에 따라 분류)
            String historyType = "INDICATOR_EXCEL";
            String historyTitle;
            
            if (indicatorName.contains("regression")) {
                historyTitle = "다중회귀모형 분석 지표 엑셀";
            } else if (indicatorName.contains("cluster")) {
                historyTitle = "군집분석 지표 엑셀";
            } else if (indicatorName.contains("logistic")) {
                historyTitle = "로지스틱 분석 지표 엑셀";
            } else if (indicatorName.contains("gravity")) {
                historyTitle = "중력모델 분석 지표 엑셀";
            } else if (indicatorName.contains("변수에 대한 설명")) {
                historyTitle = "변수 설명서 엑셀";
            } else {
                historyTitle = "상권 지표 엑셀 - " + indicatorName;
            }
            
            // 4. 실제 파일 경로 확인
            String excelFilePath = "/data/excel/" + indicatorName;
            Path actualFilePath = Paths.get(uploadDir + "/../src/main/resources/static" + excelFilePath);
            File excelFile = actualFilePath.toFile();
            
            if (!excelFile.exists()) {
                log.warn("엑셀 파일이 존재하지 않습니다: {}", actualFilePath);
                // 파일이 없어도 로그는 저장하되 경고만 기록
            }
            
            // 5. 분석 파라미터 JSON 생성 (다운로드한 파일 정보 포함)
            String analysisParams = String.format(
                "{\"downloadedFile\":\"%s\",\"fileSize\":%d,\"downloadPath\":\"%s\"}", 
                indicatorName,
                excelFile.exists() ? excelFile.length() : 0,
                excelFilePath
            );
            
            // 6. UserDlHistoryVO 객체 생성 및 설정
            UserDlHistoryVO historyVO = new UserDlHistoryVO();
            historyVO.setUserId(userId);
            historyVO.setHistoryType(historyType);
            historyVO.setHistoryTitle(historyTitle);
            historyVO.setAnalysisParams(analysisParams);
            historyVO.setFileGroupNo(0L); // 엑셀 파일은 별도 파일 그룹 관리하지 않음
            
            // 7. 데이터베이스에 저장
            int result = userDlHistoryService.createHistory(historyVO);
            
            if (result > 0) {
                log.info("엑셀 다운로드 로그 저장 성공 - 사용자: {}, 파일: {}", userId, indicatorName);
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "다운로드 이력이 저장되었습니다.",
                    "historyId", historyVO.getHistoryId()
                ));
            } else {
                log.error("엑셀 다운로드 로그 저장 실패 - 데이터베이스 오류, 사용자: {}", userId);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("error", "다운로드 이력 저장에 실패했습니다."));
            }
            
        } catch (Exception e) {
            log.error("엑셀 다운로드 로그 저장 중 예외 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("error", "서버 오류가 발생했습니다: " + e.getMessage()));
        }
    }
    
    /**
     * 마이페이지에서 엑셀 파일을 다시 다운로드할 수 있도록 하는 API
     * @param requestBody 다운로드 이력 ID
     * @param principal 현재 로그인한 사용자 정보
     * @param response HTTP 응답 객체
     */
    @PostMapping("/re-download-excel")
    public void reDownloadExcel(
            @RequestBody Map<String, Object> requestBody,
            Principal principal, 
            HttpServletResponse response) {
        
        try {
            if (principal == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }
            
            Long historyId = Long.valueOf(requestBody.get("historyId").toString());
            
            // 1. 히스토리 정보 조회 및 권한 확인
            // TODO: getHistoryByFileGroupNo(historyId) -> getHistoryById(historyId)로 변경
            UserDlHistoryVO history = userDlHistoryService.getHistoryById(historyId);
            
            if (history == null || !history.getUserId().equals(principal.getName())) {
                log.warn("권한 없는 엑셀 재다운로드 시도 - 사용자: {}, historyId: {}", 
                    principal.getName(), historyId);
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            
         // 2. analysisParams에서 파일 정보 추출
            String analysisParams = history.getAnalysisParams();
            String downloadedFile = extractValueFromJson(analysisParams, "downloadedFile");
            String downloadPath = extractValueFromJson(analysisParams, "downloadPath");
            
            if (downloadedFile == null || downloadPath == null) {
                log.error("엑셀 재다운로드 실패 - 파일 정보 없음, historyId: {}", historyId);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // 3. 실제 파일 경로 구성 (수정된 부분)
            // downloadPath는 "/data/excel/..." 형태로 이미 정적 리소스 경로를 포함하고 있습니다.
            // 따라서 uploadDir과 불필요한 경로를 합치지 않고, downloadPath를 기반으로만 경로를 구성합니다.
            Path actualFilePath = Paths.get("src/main/resources/static" + downloadPath);
            File file = actualFilePath.toFile();
            
            if (!file.exists() || !file.isFile()) {
                log.error("엑셀 재다운로드 실패 - 파일 없음: {}", actualFilePath);
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // 4. 다운로드 응답 설정
            String encodedFileName = URLEncoder.encode(downloadedFile, "UTF-8").replaceAll("\\+", "%20");
            
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"" + downloadedFile + "\"; filename*=UTF-8''" + encodedFileName);
            
            // 5. 파일 스트리밍
            try (FileInputStream fis = new FileInputStream(file);
                 OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[8192];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                }
                os.flush();
            }
            
            log.info("엑셀 재다운로드 성공 - 사용자: {}, 파일: {}", 
                principal.getName(), downloadedFile);
            
        } catch (IOException e) {
            log.error("엑셀 재다운로드 중 IO 오류 발생", e);
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        } catch (Exception e) {
            log.error("엑셀 재다운로드 중 예외 발생", e);
            if (!response.isCommitted()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
    
    /**
     * 간단한 JSON 문자열에서 값을 추출하는 헬퍼 메소드
     */
    private String extractValueFromJson(String json, String key) {
        if (json == null || key == null) return null;
        
        String searchKey = "\"" + key + "\":\"";
        int startIndex = json.indexOf(searchKey);
        if (startIndex == -1) return null;
        
        startIndex += searchKey.length();
        int endIndex = json.indexOf("\"", startIndex);
        if (endIndex == -1) return null;
        
        return json.substring(startIndex, endIndex);
    }
}