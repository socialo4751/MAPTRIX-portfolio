// src/main/java/kr/or/ddit/cs/org/vo/DeptDetailResponse.java
package kr.or.ddit.intro.org.vo;

import java.util.List;
import lombok.Data;

@Data
public class DeptDetailResponse {
    private Integer deptId;
    private String deptName;
    private List<OrgEmpVO> employees;
}
