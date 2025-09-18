package kr.or.ddit.user.my.community.vo;

import java.util.Date;
import lombok.Data;

/**
 * 마이페이지 '내 활동 조회'를 위한 통합 VO
 * 여러 게시판의 게시글/댓글 정보를 공통 형식으로 담는 역할을 합니다.
 */
@Data
public class MyActivityVO {

    // 공통 정보
    private String activityType;  // "게시글" 또는 "댓글"
    private String boardType;     // "자유게시판", "후기게시판" 등 게시판 한글 이름
    private String title;         // 게시글 제목 또는 댓글 내용 미리보기
    private Date createdAt;       // 작성일

    // 이동을 위한 정보
    private String url;           // 최종적으로 이동할 상세 페이지 URL
    
    // 페이징 처리를 위한 rnum
    private int rnum;
}