package kr.or.ddit.intro.org.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.intro.org.mapper.OrgEmpMapper;
import kr.or.ddit.intro.org.service.OrgService;
import kr.or.ddit.intro.org.vo.DeptDetailResponse;
import kr.or.ddit.intro.org.vo.OrgEmpVO;

@Service
public class OrgServiceImpl implements OrgService {

    @Autowired
    private OrgEmpMapper orgEmpMapper;

    @Override
    public List<OrgEmpVO> getAllEmployees() {
        return orgEmpMapper.selectOrgEmpList();
    }

    @Override
    public List<OrgEmpVO> getEmployeesByDept(int deptId) {
        return orgEmpMapper.selectEmployeesByDept(deptId); // ★
    }

    @Override
    public String getDeptName(int deptId) {
        return orgEmpMapper.selectDeptName(deptId);        // ★
    }

    @Override
    public DeptDetailResponse getDeptDetail(Integer deptId) {
        DeptDetailResponse dto = new DeptDetailResponse();
        dto.setDeptId(deptId);
        dto.setDeptName(orgEmpMapper.selectDeptName(deptId));
        dto.setEmployees(orgEmpMapper.selectEmployeesByDept(deptId));
        return dto;
    }

    @Override
    public List<OrgEmpVO> searchEmployees(Integer deptId, String keyword) {
        // Mapper에서 검색 쿼리 실행
        return orgEmpMapper.searchEmployees(deptId, keyword);
    }

    @Override
    public int countEmployees(Integer deptId, String keyword) {
        return orgEmpMapper.countEmployees(deptId, keyword);
    }

    @Override
    public List<OrgEmpVO> searchEmployeesPaged(Integer deptId, String keyword, int startRow, int endRow) {
        return orgEmpMapper.searchEmployeesPaged(deptId, keyword, startRow, endRow);
    }

}