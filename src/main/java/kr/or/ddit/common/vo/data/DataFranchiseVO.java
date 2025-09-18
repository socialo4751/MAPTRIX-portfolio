package kr.or.ddit.common.vo.data;

import lombok.Data;

/**
 * 프랜차이즈 정보를 담기 위한 VO 클래스
 */
@Data
public class DataFranchiseVO {
    /**
     * 프랜차이즈 ID
     */
    private int franchiseId;
    /**
     * 프랜차이즈명
     */
    private String franchiseName;
}