package kr.or.ddit.intro.org.vo;

import lombok.Data;

/**
 * 직원 정보를 담기 위한 VO 클래스
 */
@Data
public class OrgEmpVO {
    private String empId;
    private int deptId;
    private String empPosition;
    private String empImage;
    private String empExt;

    private String empName;   // USERS.NAME
    private String deptName;  // ORG_DEPT.DEPT_NAME
    private String email;     // USERS.EMAIL
}
