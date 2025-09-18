package kr.or.ddit.common.vo.user;

import java.util.Date;

import lombok.Data;

@Data
public class UserMyBizVO {
    private String userId; // 회원고유번호
    private String bizCodeId; // 업종 중분류
    private Date createdAt; // 생성일시
    private String bizName; // 이 필드를 추가합니다.
}