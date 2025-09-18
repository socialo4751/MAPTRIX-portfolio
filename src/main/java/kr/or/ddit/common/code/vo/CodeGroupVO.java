package kr.or.ddit.common.code.vo;

import lombok.Data;

/**
 * 공통 코드 그룹 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeGroupVO {
    private String codeGroupId; // 공통분류코드
    private String codeGroupName; // 분류코드명
}
