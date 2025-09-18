package kr.or.ddit.cs.qna.vo;

import java.util.Date;

import lombok.Data;

/**
 * Q&A 답변 정보를 담기 위한 VO 클래스
 */
@Data
public class CsQnaAnswerVO {
    private int ansId; // 답변ID
    private int quesId; // 문의ID
    private String adminId; // 관리자고유번호
    private String content; // 답변 내용
    private Date answeredAt; // 답변 등록 일시
    private int fileGroupNo; // 첨부파일분류일련번호
}
