package kr.or.ddit.market.simple.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;
import kr.or.ddit.common.vo.stats.StatsBizLargeVO;
import kr.or.ddit.common.vo.stats.StatsCreditCardVO;
import kr.or.ddit.common.vo.stats.StatsEmpLargeVO;
import kr.or.ddit.common.vo.stats.StatsHouseholdVO;
import kr.or.ddit.common.vo.stats.StatsHousingVO;
import kr.or.ddit.common.vo.stats.StatsPopulationVO;
import kr.or.ddit.market.simple.vo.UserPreferenceVO;

@Mapper
public interface MarketMapper {
	
    // 1. 시군구 VO를 불러온다.
	public List<CodeDistrictVO> getDistrictList();
    
	// 2. 업종 대분류 VO를 불러온다.
	public List<CodeBizVO> getBizCodeList();
	
	// 3. 업종 중분류 VO를 불러온다.
	public List<CodeBizVO> findSubCodeBizByParentId(@Param("parentCodeId") String parentCodeId);
	
	// 4. 행정도 VO를 불러온다.
	public List<CodeAdmDongVO> selectAdmDongList(int districtId);
	
	// 5. 분석 결과 조회
	/**
	 * 사업체 통계를 조회합니다. (대/중분류 동적 처리)
	 */
	public List<StatsBizLargeVO> getBusinessStats(Map<String, Object> params);

	/**
	 * 종사자 통계를 조회합니다. (대/중분류 동적 처리)
	 */
	public List<StatsEmpLargeVO> getEmployeeStats(Map<String, Object> params);

	/**
	 * 신용카드(매출) 통계를 조회합니다.
	 */
	public List<StatsCreditCardVO> getCreditCardStats(Map<String, Object> params);

	/**
	 * 가구 통계를 조회합니다.
	 */
	public List<StatsHouseholdVO> getHouseholdStats(Map<String, Object> params);

	/**
	 * 주택 통계를 조회합니다.
	 */
	public List<StatsHousingVO> getHousingStats(Map<String, Object> params);

	/**
	 * 인구 통계를 조회합니다.
	 */
	public List<StatsPopulationVO> getPopulationStats(Map<String, Object> params);
		
	// 6. 행정동 코드로 동이름과 구이름을 조회
	public Map<String, Object> selectLocationNames(String admCode);
	
	// 7. 분석결과 해석 관련 마스터코드 디테일 조회
	public List<CodeDetailVO> getSgisCodeDetailList();
	
	// 8. 분석결과 신용카드 구 단위 평균 매출 조회
	public Map<String, Object> getAvgPaymentByDistrict(Map<String, Object> params);
	
	// 9. 전체 신용카드 소비 평균 조회
    public int getTotalAvgPayment();
    
    public UserPreferenceVO selectUserPreferences(String userId);
	
}