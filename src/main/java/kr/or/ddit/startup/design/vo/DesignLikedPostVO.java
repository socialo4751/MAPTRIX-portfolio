package kr.or.ddit.startup.design.vo;

import lombok.Data;

@Data
public class DesignLikedPostVO {
    private int postId;         // 포스트 ID
    private String title;       // 포스트 제목
    private String creatorId;   // 포스트를 작성한 원작자 ID
    private String screenshotUrl; // 포스트의 썸네일 이미지 경로
}