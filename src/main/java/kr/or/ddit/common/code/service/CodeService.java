// =================== CodeService.java (인터페이스) ===================
package kr.or.ddit.common.code.service;

import java.util.List;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.code.vo.CodeGroupVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;

public interface CodeService {

    /**
     * 전체 공통 코드 그룹 목록을 조회합니다.
     * @return CodeGroupVO 리스트
     */
    public List<CodeGroupVO> getCodeGroupList();

    /**
     * 주어진 그룹 ID에 해당하는 활성화된 공통 상세 코드 목록을 조회합니다.
     * @param codeGroupId 조회할 그룹 ID
     * @return CodeDetailVO 리스트
     */
    public List<CodeDetailVO> getCodeDetailList(String codeGroupId);
    
    public List<CodeDistrictVO> getDistrictList();
}