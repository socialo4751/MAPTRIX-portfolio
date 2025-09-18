package kr.or.ddit.intro.org.vo;

import lombok.Data;

/**
 * 부서 정보를 담기 위한 VO 클래스
 */
@Data
public class OrgDeptVO {
    private int deptId; // 부서ID
    private String deptName;
}
