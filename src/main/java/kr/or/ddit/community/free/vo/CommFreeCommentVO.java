package kr.or.ddit.community.free.vo;

import java.util.Date;

import lombok.Data;

/**
 * 자유게시판 댓글 정보를 담기 위한 VO 클래스
 */
@Data
public class CommFreeCommentVO {
    private int commentId; // 댓글번호
    private int postId; // 게시글번호
    private int postId2; // 게시글번호(백업)
    private String userId; // 회원고유번호
    private String content; // 내용
    private Date createdAt; // 댓글
    private Date updatedAt; // 최종 수정일시
    private Integer parentId; // 부모 댓글 ID
    private Integer depth; // 댓글 깊이 (레벨)
    private String isDeleted; // 삭제여부
    private String writerName;
    private String bizName;//CAT_CODE_ID = BIZ_CODE_ID
    private int rnum;
}
