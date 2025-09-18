package kr.or.ddit.community.free.vo;

import java.util.Date;

import lombok.Data;

/**
 * 자유게시판 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class CommFreePostVO {
    private int postId; // 게시글번호
    private String userId; // 회원고유번호
    private String catCodeId; // 업종 중분류 ID
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 작성일시
    private Date updatedAt; // 최종 수정일시
    private String isDeleted; // 삭제여부
    private int fileGroupNo; // 첨부파일분류일련번호
    private String writerName;//작성자 이름
    private String catCodeName; //카테고리 코드 네임
	private String bizCodeId; //업종별 카테고리
	private String bizName;//CAT_CODE_ID = BIZ_CODE_ID
	private int rnum; // 화면에 보여줄 카테고리 별 내 글 번호
}
