package kr.or.ddit.common.vo.code;

import lombok.Data;

/**
 * 업종 코드 정보를 담기 위한 VO 클래스
 */
@Data
public class CodeBizVO {
    private String bizCodeId; // 업종 코드 ID
    private String bizName; // 업종명
    private Integer bizLevel; // 계층 레벨
    private String parentCodeId; // 부모 업종 코드 ID
}
