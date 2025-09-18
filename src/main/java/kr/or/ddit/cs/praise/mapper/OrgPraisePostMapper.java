// 1) Mapper 인터페이스
package kr.or.ddit.cs.praise.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.intro.org.vo.OrgEmpVO;
import kr.or.ddit.cs.praise.vo.OrgPraisePostVO;

@Mapper
public interface OrgPraisePostMapper {
    List<OrgPraisePostVO> selectPraiseList(String empName);

    void insertPraise(OrgPraisePostVO vo);

    List<OrgEmpVO> selectAllEmployees();

    List<OrgPraisePostVO> selectPraisePage(Map<String, Object> params);

    int selectPraiseCount(String empName);

    int markPraiseAsDeleted(Long praiseId);

    List<OrgEmpVO> searchEmployeesByKeyword(Map<String, Object> params);
}