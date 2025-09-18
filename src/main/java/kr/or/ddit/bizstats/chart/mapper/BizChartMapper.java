package kr.or.ddit.bizstats.chart.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.stats.StatsBizStartCloseVO;
import kr.or.ddit.common.vo.stats.StatsBizStartCommonVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSalesrangeVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSmallbizVO;
import kr.or.ddit.common.vo.stats.StatsBizStartTrendVO;
import kr.or.ddit.common.vo.stats.StatsBizStartVO;

@Mapper
public interface BizChartMapper {
    /**
     * 자치구별 창업 및 폐업 통계 전체 목록 조회
     * @return 통계 VO 리스트
     */
    public List<StatsBizStartCloseVO> selectBizStartClose();
    
    /**
     * 자치구별 사업체 현황 목록 조회
     * @return 사업체 현황 VO 리스트
     */
    public List<StatsBizStartVO> selectDistrictBusiness();
    /**
     * 자치구별 생활밀접업종 기본 현황 목록 조회
     * @return 생활밀접업종 현황 VO 리스트
     */
    public List<StatsBizStartCommonVO> selectBizStartCommon();

    /**
     * 자치구별 소상공인 사업체 수 현황 목록을 조회
     * @return 소상공인 사업체 현황 VO 리스트
     */
    public List<StatsBizStartSmallbizVO> selectSmallbizStats();
    /**
     * 매출액 규모별 사업체 수 현황 목록을 조회
     * @return 매출액 규모별 사업체 현황 VO 리스트
     */
    public List<StatsBizStartSalesrangeVO> selectSalesRangeStats();
    /**
     * 연도별 사업체/종사자/매출액 추이 현황 목록을 조회
     * @return 연도별 추이 현황 VO 리스트
     */
    public List<StatsBizStartTrendVO> selectBizTrendStats();
    
}