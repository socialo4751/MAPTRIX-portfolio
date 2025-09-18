package kr.or.ddit.community.free.vo;

import java.util.Date;

import lombok.Data;

@Data
public class VirtualNicknameVO {
    private String userId;
    private Long roomId;
    private String virtualNickname;
    private Date createdAt;
}