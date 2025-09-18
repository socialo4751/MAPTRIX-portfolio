package kr.or.ddit.user.my.community.vo;

import java.util.Date;
import lombok.Data;

/**
 * 마이페이지 내 활동 내역을 통합적으로 관리하기 위한 VO 클래스
 */
@Data
public class MyActivityVO2 {
    private String activityType; // 'post' or 'comment'
    private String boardType;    // '칭찬게시판', 'Q&A', '창업후기'
    private int postId;          // 원본 게시글 ID (칭찬, QnA, 후기 등)
    private int commentId;       // 댓글 ID (댓글인 경우)
    private String title;        // 제목 (게시글) 또는 원본 게시글 제목 (댓글)
    private String content;      // 내용 (모달창 표시용)
    private Date createdAt;      // 작성일
    private String postUrl;      // 게시글 상세 페이지로 이동할 URL
}