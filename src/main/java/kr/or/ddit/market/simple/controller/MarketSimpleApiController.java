package kr.or.ddit.market.simple.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.admin.stats.market.aop.MarketLog;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.market.simple.dto.request.AiRequestDto;
import kr.or.ddit.market.simple.dto.request.BusinessAnalysisRequestDto;
import kr.or.ddit.market.simple.dto.request.HouseholdAnalysisRequestDto;
import kr.or.ddit.market.simple.dto.request.HousingAnalysisRequestDto;
import kr.or.ddit.market.simple.dto.request.PopulationAnalysisRequestDto;
import kr.or.ddit.market.simple.dto.response.BusinessAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HouseholdAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HousingAnalysisDto;
import kr.or.ddit.market.simple.dto.response.MarketSimpleAnalysisDto;
import kr.or.ddit.market.simple.dto.response.PopulationAnalysisDto;
import kr.or.ddit.market.simple.service.MarketSimpleService;
import kr.or.ddit.market.simple.vo.UserPreferenceVO;
import kr.or.ddit.user.my.dlhistory.service.UserDlHistoryService;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;
import lombok.extern.slf4j.Slf4j;

// 간단분석
// API용 경로는 /api로 구분
@RequestMapping("/api/market")
@Slf4j
@RestController
public class MarketSimpleApiController {

    @Autowired
    private MarketSimpleService marketService;
    
    // [삭제] GeminiService 의존성 제거
    
    // [추가] 의존성 주입
    @Autowired
    private FileService fileService;
    @Autowired
    private UserDlHistoryService userDlHistoryService;

    
    /**
     * JSP 페이지가 로드된 후, 초기 데이터를 가져가기 위해 호출하는 API
     * @return 구 목록(districts)과 업종 대분류(bizCodes)를 포함한 Map (JSON)
     */
    @GetMapping("/initial-data")
    public Map<String, Object> getInitialData(Principal principal) {
        Map<String, Object> initialData = new HashMap<>();
        initialData.put("districts", marketService.getDistrictList());
        initialData.put("bizCodes", marketService.getBizCodeList());
        // 사용자가 로그인 상태인지 확인
        if (principal != null) {
            String userId = principal.getName();
            log.info("로그인 사용자 확인: {}. 맞춤 설정 조회를 시작합니다.", userId);
            
            // 서비스 계층을 통해 사용자 맞춤 정보 조회
            UserPreferenceVO preferences = marketService.getUserPreferences(userId);
            
            // 조회된 정보가 있다면 응답 데이터에 추가
            if (preferences != null) {
                initialData.put("userPreferences", preferences);
                log.info("사용자 맞춤 설정 발견: {}", preferences);
            }
        }

        log.info("클라이언트에게 초기 데이터를 전송합니다.");
        return initialData;
    }

    /**
     * 부모 코드 ID를 받아 하위 업종 목록을 JSON으로 반환하는 API
     */
    @GetMapping("/biz-codes/{parentCodeId}")
    public List<CodeBizVO> getSubBizCodes(@PathVariable("parentCodeId") String parentCodeId) {
        log.info("API CALL: getSubBizCodes -> parentCodeId: {}", parentCodeId);
        return marketService.findSubCodeBizByParentId(parentCodeId);
    }

    /**
     * 특정 구(district)에 속한 행정동 목록을 조회하는 API
     */
    @GetMapping("/dongs/{districtId}")
    public List<CodeAdmDongVO> getDongsByDistrict(@PathVariable("districtId") int districtId) {
        log.info("API CALL: getDongsByDistrict -> districtId: {}", districtId);
        log.info("getDongsByDistrict -> marketService.selectAdmDongList(districtId) " + marketService.selectAdmDongList(districtId));
        
        return marketService.selectAdmDongList(districtId);
    }

    /**
     * 선택된 조건 기반으로 분석 데이터를 요청하고 결과를 반환하는 API
     */
    
    @GetMapping("/analyze")
    public Map<String, Object> analyzeData(
            @RequestParam("admCode") String admCode,
            @RequestParam("bizCodeId") String bizCodeId,
            @RequestParam("bizLevel") int bizLevel,
            @RequestParam("year") String year,
            @RequestParam("districtId") int districtId) {

        log.info("API CALL: analyzeData >> admCode: {}, bizCodeId: {}, bizLevel: {}, year: {}, districtId: {}",
                admCode, bizCodeId, bizLevel, year, districtId);

        Map<String, Object> params = new HashMap<>();
        params.put("admCode", admCode);
        params.put("bizCodeId", bizCodeId);
        params.put("bizLevel", bizLevel);
        params.put("year", year);
        params.put("districtId", districtId);
        
        //8개의 데이터 테이블 조회 결과
        Map<String, Object> analysisResult = marketService.getAnalysisReport(params);
        
        // AI 분석 및 로깅을 위해 원본 파라미터를 analysisResult 맵에 추가합니다.
        analysisResult.put("admCode", admCode);
        analysisResult.put("bizCodeId", bizCodeId);
        analysisResult.put("year", year);

        // 6. 행정동 코드로 동이름과 구이름을 조회
        Map<String, Object> locationNames = marketService.selectLocationNames(admCode);
        
        // 7. 분석결과 해석 관련 마스터코드 디테일 조회
        List<CodeDetailVO> sgisCodes = marketService.getSgisCodeDetailList();
        
        // 8. 분석결과 신용카드 구 단위 평균 매출 조회
        Map<String, Object> AvgPay = marketService.getAvgPaymentByDistrict(admCode, year);
        
        // 9. 전체 신용카드 소비 평균 조회
        int totalAvgPayment = marketService.getTotalAvgPayment();
        
        Map<String, Object> responseData = new HashMap<>();
        responseData.put("status", "success");
        responseData.put("analysisResult", analysisResult);
        responseData.put("locationNames", locationNames);
        responseData.put("sgisCodes", sgisCodes);
        responseData.put("AvgPay", AvgPay);
        responseData.put("totalAvgPayment", totalAvgPayment);
        
        return responseData;
    }
    
    /**
     * AI 시장 분석 해석을 요청하는 API
     * 2025-08-15 AOP 로그 INSERT (세진)
     */
    @MarketLog("SIMPLE")
    @PostMapping("/interpret")
    public ResponseEntity<MarketSimpleAnalysisDto> getAiInterpretation(@RequestBody AiRequestDto requestDto) {
        log.info("API CALL: getAiInterpretation >> AI 분석 요청 받음");
        
        try {
            // AI 분석 요청을 MarketSimpleService에 위임
            MarketSimpleAnalysisDto result = marketService.interpretMarketAnalysis(
                requestDto.getAnalysisResult(),
                requestDto.getSgisCodes()
            );
            // 성공 시, 결과와 함께 HTTP 200 OK 상태를 반환합니다.
            return ResponseEntity.ok(result);

        } catch (Exception e) {
            log.error("AI 간단분석 리포트 생성 중 오류 발생", e);
            // 실패 시, HTTP 500 Internal Server Error 상태를 반환합니다.
            // 로깅 Aspect는 이 2xx가 아닌 상태 코드를 보고 "FAIL"로 기록합니다.
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * 인구 통계 데이터에 대한 AI 분석을 요청하는 API
     */
    @PostMapping("/interpret/population")
    public PopulationAnalysisDto getPopulationAiInterpretation(@RequestBody PopulationAnalysisRequestDto requestDto) {
        log.info("API CALL: getPopulationAiInterpretation >> AI 인구 분석 요청 받음");
        
        // [변경] AI 분석 요청을 MarketSimpleService에 위임
        return marketService.interpretPopulationData(
            requestDto.getPopulationStats(),
            requestDto.getSgisCodes()
        );
    }
    
    /**
     * [신규] 가구 통계 데이터에 대한 AI 분석을 요청하는 API
     */
    @PostMapping("/interpret/household")
    public HouseholdAnalysisDto getHouseholdAiInterpretation(@RequestBody HouseholdAnalysisRequestDto requestDto) {
        log.info("API CALL: getHouseholdAiInterpretation >> AI 가구 분석 요청 받음");
        
        // [변경] AI 분석 요청을 MarketSimpleService에 위임
        return marketService.interpretHouseholdData(
            requestDto.getHouseholdStats(),
            requestDto.getSgisCodes()
        );
    }
    
    /**
     * [수정] 주택 통계 데이터에 대한 AI 분석을 요청하는 API
     */
    @PostMapping("/interpret/housing")
    public HousingAnalysisDto interpretHousing(@RequestBody HousingAnalysisRequestDto requestDto) {
        log.info("API CALL: interpretHousing >> AI 주택 분석 요청 받음");
        
        // [변경] AI 분석 요청을 MarketSimpleService에 위임
        return marketService.interpretHousingData(
            requestDto.getHousingStats(), 
            requestDto.getSgisCodes()
        );
    }
    
    /**
     * [신규] 사업체/종사자 통계 데이터에 대한 AI 분석을 요청하는 API
     */
    @PostMapping("/interpret/business")
    public BusinessAnalysisDto interpretBusiness(@RequestBody BusinessAnalysisRequestDto requestDto) {
        log.info("API CALL: interpretBusiness >> AI 사업체/종사자 분석 요청 받음");
        
        // [변경] AI 분석 요청을 MarketSimpleService에 위임
        return marketService.interpretBusinessData(
            requestDto.getBizStats(),
            requestDto.getEmpStats(),
            requestDto.getSgisCodes()
        );
    }
    
    /**
     * [신규] 간단분석 리포트 파일과 메타데이터를 받아 이력을 저장하는 API
     * @param reportFile 클라이언트에서 생성하여 전송한 PDF 파일
     * @param historyTitle 저장될 이력의 제목
     * @param historyType 이력의 종류 (여기서는 'SIMPLE_PDF')
     * @param principal 현재 로그인한 사용자 정보
     * @return 처리 결과
     */
    @PostMapping("/report")
    public ResponseEntity<String> saveSimpleReport(
            @RequestParam("reportFile") MultipartFile reportFile,
            @RequestParam("historyTitle") String historyTitle,
            @RequestParam("historyType") String historyType,
            Principal principal) {

        log.info("API CALL: saveSimpleReport >> Title: {}", historyTitle);

        try {
            // 1. FileService를 사용하여 첨부된 파일을 서버에 저장하고, 파일 그룹 번호를 반환받습니다.
            long fileGroupNo = fileService.uploadFiles(new MultipartFile[]{reportFile}, "REPORT_FILE");
            if (fileGroupNo <= 0) {
                throw new RuntimeException("파일 저장에 실패했습니다.");
            }

            // 2. DB에 저장할 UserDlHistoryVO 객체를 생성하고 데이터를 설정합니다.
            UserDlHistoryVO historyVO = new UserDlHistoryVO();
            historyVO.setUserId(principal.getName());
            historyVO.setFileGroupNo(fileGroupNo);
            historyVO.setHistoryType(historyType);
            historyVO.setHistoryTitle(historyTitle);
            historyVO.setAnalysisParams("{}"); // 간단 분석은 파라미터가 없으므로 빈 JSON 객체 저장

            // 3. 서비스 계층을 통해 이력 정보를 DB에 최종 저장합니다.
            userDlHistoryService.createHistory(historyVO);

            // 4. 성공 응답을 반환합니다.
            return ResponseEntity.ok("SUCCESS");

        } catch (Exception e) {
            log.error("간단분석 리포트 저장 중 오류 발생", e);
            return ResponseEntity.internalServerError().body("서버 오류로 인해 리포트 저장에 실패했습니다.");
        }
    }
}
