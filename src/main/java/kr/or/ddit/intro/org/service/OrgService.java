package kr.or.ddit.intro.org.service;

import kr.or.ddit.intro.org.vo.DeptDetailResponse;
import kr.or.ddit.intro.org.vo.OrgEmpVO;

import java.util.List;

public interface OrgService {
    List<OrgEmpVO> getAllEmployees();

    List<OrgEmpVO> getEmployeesByDept(int deptId); // ★

    String getDeptName(int deptId);                // ★

    DeptDetailResponse getDeptDetail(Integer deptId);

    List<OrgEmpVO> searchEmployees(Integer deptId, String keyword);

    int countEmployees(Integer deptId, String keyword);

    List<OrgEmpVO> searchEmployeesPaged(Integer deptId, String keyword, int startRow, int endRow);

}
