package kr.or.ddit.startup.test.vo;

import lombok.Data;

/**
 * 창업 테스트 섹션 정보를 담기 위한 VO 클래스
 */
@Data
public class Test1SectionsVO {
    private int sectionId; // 섹션 ID
    private int testId; // 테스트 ID
    private String sectionName; // 섹션명
    private Integer sectionOrder; // 섹션_순서
}
