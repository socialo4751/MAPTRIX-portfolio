package kr.or.ddit.community.review.vo;

import java.util.Date;

import lombok.Data;

/**
 * 창업 후기 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class CommReviewPostVO {
    private int postId; // 후기번호
    private String userId; // 회원고유번호
    private String catCodeId; // 카테고리 코드 ID
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private String isDeleted; // 삭제여부
    private int fileGroupNo; // 첨부파일분류일련번호
    private String writerName; //작성글 유저네임
    private String catCodeName; //카테고리 코드 네임

    private String previewContent; // getter/setter 추가
    
    private String thumbnailUrl; // 이 필드를 추가하세요.

}
