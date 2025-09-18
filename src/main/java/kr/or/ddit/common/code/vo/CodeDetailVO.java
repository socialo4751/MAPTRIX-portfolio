package kr.or.ddit.common.code.vo;

import lombok.Data;

/**
 * 공통 상세 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeDetailVO {
    private String codeId; // 상세코드ID
    private String codeGroupId; // 분류코드ID
    private String codeName; // 상세코드명
    private String useYn; // 사용여부
}
