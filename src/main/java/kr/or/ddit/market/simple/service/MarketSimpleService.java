package kr.or.ddit.market.simple.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.market.simple.dto.response.BusinessAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HouseholdAnalysisDto;
import kr.or.ddit.market.simple.dto.response.HousingAnalysisDto;
import kr.or.ddit.market.simple.dto.response.MarketSimpleAnalysisDto;
import kr.or.ddit.market.simple.dto.response.PopulationAnalysisDto;
import kr.or.ddit.market.simple.vo.UserPreferenceVO;

/**
 * 사용자 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 */
public interface MarketSimpleService {
	
	/*  간단분석  */
	// 1. 시군구 VO를 불러온다.
	public List<CodeDistrictVO> getDistrictList();
	
	// 2. 업종 대분류 VO를 불러온다.
	public List<CodeBizVO> getBizCodeList();
	
	// 3. 업종 중분류 VO를 불러온다.
	public List<CodeBizVO> findSubCodeBizByParentId(String parentCodeId);
	
	// 4. 행정도 VO를 불러온다.
	public List<CodeAdmDongVO> selectAdmDongList(int districtId);
	
	// 5. 분석 결과 조회
    public Map<String, Object> getAnalysisReport(Map<String, Object> params);
    
    // 6. 행정동 코드로 동이름과 구이름을 조회
    public Map<String, Object> selectLocationNames(String admCode);
    
    // 7. 분석결과 해석 관련 마스터코드 디테일 조회
    public List<CodeDetailVO> getSgisCodeDetailList();
    
    // 8. 분석결과 신용카드 구 단위 평균 매출 조회
    public Map<String, Object> getAvgPaymentByDistrict(String admCode, String year);
    
    // 9. 전체 신용카드 소비 평균 조회
    public int getTotalAvgPayment();
    
    // 10. AI 해석 메서드 추가 (2025-08-10 장세진, 구조 리팩토링 변경점)
    MarketSimpleAnalysisDto interpretMarketAnalysis(Map<String, Object> analysisResult, List<CodeDetailVO> sgisCodes);
    PopulationAnalysisDto interpretPopulationData(List<Map<String, Object>> populationStats, List<CodeDetailVO> sgisCodes);
    HouseholdAnalysisDto interpretHouseholdData(List<Map<String, Object>> householdStats, List<CodeDetailVO> sgisCodes);
    HousingAnalysisDto interpretHousingData(List<Map<String, Object>> housingStats, List<CodeDetailVO> sgisCodes);
    BusinessAnalysisDto interpretBusinessData(List<Map<String, Object>> bizStats, List<Map<String, Object>> empStats, List<CodeDetailVO> sgisCodes);
    
    /**
     * [신규] 사용자의 관심지역/업종 설정을 조회하는 메서드
     * @param userId 사용자 ID
     * @return 사용자의 설정 정보를 담은 VO
     */
    public UserPreferenceVO getUserPreferences(String userId);
}
