package kr.or.ddit.community.review.vo;

import java.util.Date;

import lombok.Data;

/**
 * 창업 후기 댓글 정보를 담기 위한 VO 클래스
 */
@Data
public class CommReviewCommentVO {
    private int commentId; // 창업후기댓글번호
    private int postId; // 후기번호
    private String userId; // 회원고유번호
    private String content; // 내용
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private Integer parentId; // 부모 댓글 ID
    private int depth; // 댓글 깊이 (레벨)
    private String isDeleted; // 삭제여부
    private String writerName; //작성자 이름

}
