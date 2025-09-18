package kr.or.ddit.cs.praise.vo;

import java.util.Date;

import lombok.Data;

/**
 * 칭찬 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class OrgPraisePostVO {
    private Long praiseId;
    private String userId;
    private String empId;
    private String title;
    private String content;
    private Date createdAt;
    private String isDeleted;

    private String userName;   // USERS.NAME
    private String empName;    // USERS.NAME for empId

    public String getMaskedUserName() {
        if (userName == null || userName.isEmpty()) return null;

        int len = userName.length();
        if (len == 1) {
            return "*";
        } else if (len == 2) {
            return userName.charAt(0) + "*";
        } else {
            return userName.charAt(0) + "*".repeat(len - 2) + userName.charAt(len - 1);
        }
    }

}
