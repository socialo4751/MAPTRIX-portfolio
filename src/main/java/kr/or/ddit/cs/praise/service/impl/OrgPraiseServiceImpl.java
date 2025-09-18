// 3) ServiceImpl
package kr.or.ddit.cs.praise.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.intro.org.mapper.OrgEmpMapper;
import kr.or.ddit.intro.org.vo.OrgEmpVO;
import kr.or.ddit.cs.praise.mapper.OrgPraisePostMapper;
import kr.or.ddit.cs.praise.service.OrgPraiseService;
import kr.or.ddit.cs.praise.vo.OrgPraisePostVO;

@Service
public class OrgPraiseServiceImpl implements OrgPraiseService {

    private final OrgPraisePostMapper praiseMapper;
    private final OrgEmpMapper empMapper;

    @Autowired
    public OrgPraiseServiceImpl(
            OrgPraisePostMapper praiseMapper,
            OrgEmpMapper empMapper
    ) {
        this.praiseMapper = praiseMapper;
        this.empMapper = empMapper;
    }

    @Override
    public List<OrgPraisePostVO> getPraiseList(String empName) {
        return praiseMapper.selectPraiseList(empName);
    }

    @Override
    @Transactional
    public void addPraise(OrgPraisePostVO vo) {
        praiseMapper.insertPraise(vo);
    }

    @Override
    public List<OrgEmpVO> getEmployeeList() {
        // 여기서 empMapper를 써야 합니다
        return empMapper.selectAllEmployees();
    }

    @Override
    public int getPraiseCount(String empName) {
        return praiseMapper.selectPraiseCount(empName);
    }

    @Override
    public List<OrgPraisePostVO> getPraisePage(String empName, int start, int size) {
        Map<String, Object> params = new HashMap<>();
        params.put("empName", empName);
        params.put("start", start);
        params.put("size", size);
        return praiseMapper.selectPraisePage(params);
    }

    @Override
    public int markPraiseAsDeleted(Long praiseId) {
        return praiseMapper.markPraiseAsDeleted(praiseId);
    }

    @Override
    public List<OrgEmpVO> searchEmployees(String keyword, int limit) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("limit", limit <= 0 ? 20 : limit);
        return praiseMapper.searchEmployeesByKeyword(params);
    }

}

