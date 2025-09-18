// 2) Service 인터페이스
package kr.or.ddit.cs.praise.service;

import java.util.List;

import kr.or.ddit.intro.org.vo.OrgEmpVO;
import kr.or.ddit.cs.praise.vo.OrgPraisePostVO;

public interface OrgPraiseService {

    // 기존 메서드
    List<OrgPraisePostVO> getPraiseList(String empName);

    void addPraise(OrgPraisePostVO vo);

    List<OrgEmpVO> getEmployeeList();

    // 페이징용 메서드 추가
    int getPraiseCount(String empName);

    List<OrgPraisePostVO> getPraisePage(String empName, int start, int size);

    int markPraiseAsDeleted(Long praiseId);

    List<OrgEmpVO> searchEmployees(String keyword, int limit);
}