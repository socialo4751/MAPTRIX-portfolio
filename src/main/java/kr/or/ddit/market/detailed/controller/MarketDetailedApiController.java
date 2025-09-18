package kr.or.ddit.market.detailed.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.admin.stats.market.aop.MarketLog;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.market.detailed.dto.request.ClusterGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GravityGridDataDto;
import kr.or.ddit.market.detailed.dto.request.GridAnalysisRequestDto;
import kr.or.ddit.market.detailed.dto.request.LogisticGridDataDto;
import kr.or.ddit.market.detailed.dto.response.ClusterAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GravityAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.GridAnalysisResponseDto;
import kr.or.ddit.market.detailed.dto.response.LogisticAnalysisResponseDto;
import kr.or.ddit.market.detailed.service.MarketDetailedService;
import kr.or.ddit.user.my.dlhistory.service.UserDlHistoryService;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;
import lombok.extern.slf4j.Slf4j;

// 상세분석
// API용 경로는 /api로 구분
@RequestMapping("/api/market/detailed")
@Slf4j
@RestController
public class MarketDetailedApiController {
	
	// [핵심 변경] GeminiService에 대한 의존성을 MarketDetailedService로 교체
	@Autowired
    private MarketDetailedService marketDetailedService;
	
	// PDF 저장을 위해 추가
    @Autowired
    private FileService fileService;
    
    @Autowired
    private UserDlHistoryService userDlHistoryService;

	
	//(1) 상세분석 - (다중회귀) - 격자 ai 해석
    @MarketLog("DETAIL")
    @LogEvent(eventType="ACTION", feature="ANALYSIS_DETAILED")
    @PostMapping("/analyze-grid")
    public ResponseEntity<GridAnalysisResponseDto> analyzeGrid(@RequestBody GridAnalysisRequestDto requestDto) {
        log.info("Received grid analysis request for GID: {}", requestDto.getGid());
        try {
            // [핵심 변경] 호출 대상을 marketDetailedService로 변경
            GridAnalysisResponseDto analysisResult = marketDetailedService.analyzeGridByProperties(requestDto);
            return ResponseEntity.ok(analysisResult);
        } catch (Exception e) {
            log.error("Error during AI grid analysis for GID: {}", requestDto.getGid(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
	
	
	//(2) 상세분석 - (군집분석) - 격자 ai 해석
	@MarketLog("DETAIL")
	@LogEvent(eventType="ACTION", feature="ANALYSIS_DETAILED")
	@PostMapping("/analyze-cluster-grid")
    public ResponseEntity<ClusterAnalysisResponseDto> analyzeClusterGrid(@RequestBody ClusterGridDataDto requestDto) {
        log.info("Received cluster analysis request for GID: {}", requestDto.getGid());
        try {
            // [핵심 변경] 호출 대상을 marketDetailedService로 변경
            ClusterAnalysisResponseDto analysisResult = marketDetailedService.analyzeClusterGrid(requestDto);
            return ResponseEntity.ok(analysisResult);
        } catch (Exception e) {
            log.error("Error during AI cluster analysis for GID: {}", requestDto.getGid(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
	
	//(3) 상세분석 - (로지스틱분석) - 격자 ai 해석
	@MarketLog("DETAIL")
	@LogEvent(eventType="ACTION", feature="ANALYSIS_DETAILED")
	@PostMapping("/analyze-logistic-grid")
    public ResponseEntity<LogisticAnalysisResponseDto> analyzeLogisticGrid(@RequestBody LogisticGridDataDto requestDto) {
        log.info("Received logistic analysis request for GID: {}", requestDto.getGid());
        try {
            // [핵심 변경] 호출 대상을 marketDetailedService로 변경
            LogisticAnalysisResponseDto analysisResult = marketDetailedService.analyzeLogisticGrid(requestDto);
            return ResponseEntity.ok(analysisResult);
        } catch (Exception e) {
            log.error("Error during AI logistic analysis for GID: {}", requestDto.getGid(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
	
	//(4) 상세분석 - (중력모형) - 격자 ai 해석
	@MarketLog("DETAIL")
	@LogEvent(eventType="ACTION", feature="ANALYSIS_DETAILED")
	@PostMapping("/analyze-gravity-grid")
    public ResponseEntity<GravityAnalysisResponseDto> analyzeGravityGrid(@RequestBody GravityGridDataDto requestDto) {
        log.info("Received gravity model analysis request for GID: {}", requestDto.getGid());
        try {
            // [핵심 변경] 호출 대상을 marketDetailedService로 변경
            GravityAnalysisResponseDto analysisResult = marketDetailedService.analyzeGravityGrid(requestDto);
            return ResponseEntity.ok(analysisResult);
        } catch (Exception e) {
            log.error("Error during AI gravity model analysis for GID: {}", requestDto.getGid(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
	
	/**
     * [신규 추가] 상세분석 AI 리포트 PDF 저장
     * JavaScript에서 /api/market/detailed/report로 요청하는 것을 처리합니다.
     */
	@PostMapping("/report")
    @ResponseBody
    public ResponseEntity<String> saveDetailedAnalysisReport(
            @RequestParam("reportFile") MultipartFile reportFile,
            @RequestParam("historyTitle") String historyTitle,
            @RequestParam("historyType") String historyType,
            @RequestParam("analysisParams") String analysisParams,
            Principal principal) {
        
        try {
            // 1. 인증 확인
            if (principal == null) {
                log.warn("Unauthorized access attempt to save detailed analysis report");
                return ResponseEntity.status(401).body("UNAUTHORIZED");
            }
            
            // 2. 파일 유효성 검사
            if (reportFile.isEmpty()) {
                log.warn("Empty file uploaded by user: {}", principal.getName());
                return ResponseEntity.badRequest().body("INVALID_FILE");
            }
            
            if (!"application/pdf".equals(reportFile.getContentType())) {
                log.warn("Invalid file type uploaded by user: {}, contentType: {}", 
                    principal.getName(), reportFile.getContentType());
                return ResponseEntity.badRequest().body("INVALID_FILE_TYPE");
            }
            
            // 3. 파일 저장 (FileService 활용)
            long fileGroupNo = fileService.uploadFiles(new MultipartFile[]{reportFile}, "DETAILED_AI_REPORT");
            if (fileGroupNo <= 0) {
                log.error("File upload failed for user: {}", principal.getName());
                throw new RuntimeException("파일 저장에 실패했습니다.");
            }
            
            // 4. DB 이력 저장 (UserDlHistoryService 활용)
            UserDlHistoryVO historyVO = new UserDlHistoryVO();
            historyVO.setUserId(principal.getName());
            historyVO.setFileGroupNo(fileGroupNo);
            historyVO.setHistoryType(historyType); // AI_군집분석, AI_중력모형 등
            historyVO.setHistoryTitle(historyTitle);
            historyVO.setAnalysisParams(analysisParams);
            
            int result = userDlHistoryService.createHistory(historyVO);
            
            if (result > 0) {
                log.info("상세분석 AI 리포트 저장 성공 - 사용자: {}, 타입: {}, 파일크기: {}bytes", 
                    principal.getName(), historyType, reportFile.getSize());
                return ResponseEntity.ok("SUCCESS");
            } else {
                log.error("Database insert failed for user: {}", principal.getName());
                throw new RuntimeException("데이터베이스 저장에 실패했습니다.");
            }
            
        } catch (Exception e) {
            log.error("상세분석 PDF 리포트 저장 실패 - 사용자: {}, 오류: {}", 
                (principal != null ? principal.getName() : "unknown"), e.getMessage(), e);
            return ResponseEntity.internalServerError().body("SAVE_ERROR");
        }
    }
}
