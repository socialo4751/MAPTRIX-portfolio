package kr.or.ddit.startup.mt.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

/**
 * 멘토링 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class SuMentPostVO {
    private int postId; // 게시글ID
    private String userId; // 회원고유번호
    private String catCodeId; // 카테고리 코드 ID
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 최초작성일시
    private Date updatedAt; // 최종수정일시
    private String isDeleted; // 삭제여부
    private long fileGroupNo; // 첨부파일분류일련번호
    private String linkUrl; // 신청페이지_링크
    private MultipartFile mainImageFile;
    private String thumbnailPath; // 썸네일 이미지 경로
    
    // 이전 / 다음 글 정보를 담기 위한 필드
    private long prevPostId;
    private String prevPostTitle;
    private long nextPostId;
    private String nextPostTitle;
  
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date deadline; // 신청마감일

    

 
    
    

}
