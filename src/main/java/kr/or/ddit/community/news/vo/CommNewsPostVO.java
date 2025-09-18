package kr.or.ddit.community.news.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

/**
 * 뉴스 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class CommNewsPostVO {
    private int newsId; // 뉴스번호
    private String adminId; // 관리자ID
    private String writerName; // 작성자 이름 (USERS.NAME)
    private String catCodeId; // 카테고리 코드 ID
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private String isDeleted; // 삭제여부
    private int fileGroupNo; // 첨부파일분류일련번호
    private String press; // 언론사
    private String apiNewsId; // 원본뉴스ID
    @DateTimeFormat(pattern = "yyyyMMdd")
    private Date publishedAt; // 원본뉴스작성일
    private String linkUrl; // 원본링크
    private String thumbnailUrl; // 썸네일URL
   
   
  
}
