package kr.or.ddit.bizstats.chart.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.bizstats.chart.mapper.BizChartMapper;
import kr.or.ddit.bizstats.chart.service.BizChartService;
import kr.or.ddit.common.vo.stats.StatsBizStartCloseVO;
import kr.or.ddit.common.vo.stats.StatsBizStartCommonVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSalesrangeVO;
import kr.or.ddit.common.vo.stats.StatsBizStartSmallbizVO;
import kr.or.ddit.common.vo.stats.StatsBizStartTrendVO;
import kr.or.ddit.common.vo.stats.StatsBizStartVO;

@Service
public class BizChartServiceImpl implements BizChartService {

    @Autowired
    private BizChartMapper bizChartMapper;

    @Override
    public List<StatsBizStartCloseVO> selectBizStartClose() {
        return bizChartMapper.selectBizStartClose();
    }
    
    /**
     * 자치구별 사업체 현황 목록을 조회
     * @return 사업체 현황 VO 리스트
     */
    @Override
    public List<StatsBizStartVO> selectDistrictBusiness() {
        return bizChartMapper.selectDistrictBusiness();
    }
    
    /**
     * 자치구별 생활밀접업종 기본 현황 목록을 조회
     * @return 생활밀접업종 현황 VO 리스트
     */
    @Override
    public List<StatsBizStartCommonVO> selectBizStartCommon() {
        return bizChartMapper.selectBizStartCommon();
    }
    /**
     * 자치구별 소상공인 사업체 수 현황 목록을 조회
     */
    @Override
    public List<StatsBizStartSmallbizVO> selectSmallbizStats() {
        return bizChartMapper.selectSmallbizStats();
    }
    /**
     * 매출액 규모별 사업체 수 현황 목록을 조회
     */
    @Override
    public List<StatsBizStartSalesrangeVO> selectSalesRangeStats() {
        return bizChartMapper.selectSalesRangeStats();
    }
    /**
     * 연도별 사업체/종사자/매출액 추이 현황 목록을 조회
     */
    @Override
    public List<StatsBizStartTrendVO> selectBizTrendStats() {
        return bizChartMapper.selectBizTrendStats();
    }
    
    
}