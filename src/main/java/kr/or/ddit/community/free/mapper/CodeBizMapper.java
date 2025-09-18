package kr.or.ddit.community.free.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.common.vo.code.CodeBizVO;

@Mapper
public interface CodeBizMapper {

    /**
     * 업종 코드(bizCodeId)로 해당 업종의 상세 정보(이름 등)를 조회합니다.
     * @param bizCodeId 조회할 업종 코드
     * @return 업종 코드 VO
     */
    CodeBizVO selectBizInfoByCode(String bizCodeId);
    
    /**
     * 모든 대분류 업종 목록을 조회합니다. (PARENT_CODE_ID가 NULL인 것들)
     * @return 대분류 업종 VO 리스트
     */
    List<CodeBizVO> selectMainCategories();

    /**
     * 특정 대분류(parentCodeId)에 속한 모든 중분류 업종 목록을 조회합니다.
     * @param parentCodeId 상위 대분류 코드
     * @return 중분류 업종 VO 리스트
     */
    List<CodeBizVO> selectSubCategoriesByParentCode(String parentCodeId);
}