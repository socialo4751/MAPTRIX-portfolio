package kr.or.ddit.cs.notice.vo;

import java.util.Date;

import lombok.Data;

/**
 * 공지사항 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class CsNoticePostVO {
    private int postId; // 공지사항ID
    private String adminId; // 관리자 ID
    private String catCodeId; // 카테고리 코드 ID
    private String catCodeName;    // 카테고리 코드 이름
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private Integer fileGroupNo; // 첨부파일분류일련번호
    
    private String writerName;

    private String delYn;   // 삭제여부 'N'|'Y'
}