package kr.or.ddit.common.code.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.code.vo.CodeGroupVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;

/**
 * 공통 코드(CODE_GROUP, CODE_DETAIL) 관련 DB 처리를 위한 공용 매퍼 인터페이스
 */
@Mapper
public interface CodeMapper {

    /**
     * 전체 공통 코드 그룹 목록을 조회합니다.
     * @return CodeGroupVO 리스트
     */
    public List<CodeGroupVO> getCodeGroupList();

    /**
     * 주어진 그룹 ID에 해당하는 활성화된(USE_YN='Y') 공통 상세 코드 목록을 조회합니다.
     * @param codeGroupId 조회할 그룹 ID
     * @return CodeDetailVO 리스트
     */
    public List<CodeDetailVO> getCodeDetailList(@Param("codeGroupId") String codeGroupId);
    
    List<CodeDistrictVO> getDistrictList();
}
