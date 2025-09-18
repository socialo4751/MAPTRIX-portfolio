package kr.or.ddit.intro.org.mapper;

import kr.or.ddit.intro.org.vo.OrgEmpVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OrgEmpMapper {
    List<OrgEmpVO> selectOrgEmpList();

    List<OrgEmpVO> selectAllEmployees();

    String selectDeptName(@Param("deptId") int deptId);  // ★

    List<OrgEmpVO> selectEmployeesByDept(@Param("deptId") int deptId);  // ★

    // ★ 추가
    List<OrgEmpVO> searchEmployees(@Param("deptId") Integer deptId,
                                   @Param("keyword") String keyword);

    int countEmployees(@Param("deptId") Integer deptId,
                       @Param("keyword") String keyword);

    List<OrgEmpVO> searchEmployeesPaged(@Param("deptId") Integer deptId,
                                        @Param("keyword") String keyword,
                                        @Param("startRow") int startRow,
                                        @Param("endRow") int endRow);

}
