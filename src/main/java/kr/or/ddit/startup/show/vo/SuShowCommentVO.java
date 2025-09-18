package kr.or.ddit.startup.show.vo;

import java.util.Date;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

/**
 * 쇼룸 게시물 댓글 정보를 담기 위한 VO 클래스
 */
@Data
public class SuShowCommentVO {
    private int commentId; // 댓글 ID
    
    @NotNull(message = "게시물 ID는 필수입니다.")
    @Min(value = 1, message = "게시물 ID는 1 이상이어야 합니다.")
    private int postId; // 게시물 ID  

    private String userId; // 회원고유번호  
    
    @NotBlank(message = "댓글 내용은 필수입니다.")
    private String content; // 내용
    
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private Integer parentId; // 부모 댓글 ID
    private int depth; // 댓글 깊이 (레벨)
    private String isDeleted; // 삭제여부
    
    private int rootId; // 이 필드를 추가하세요
}
