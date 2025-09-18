package kr.or.ddit.cs.qna.vo;

import java.util.Date;

import lombok.Data;

/**
 * Q&A 게시글 정보를 담기 위한 VO 클래스
 */
@Data
public class CsQnaPostVO {
    private int quesId; // 문의ID
    private String userId; // 회원고유번호
    private String catCodeId; // 카테고리 코드 ID
    private String catCodeName;// (추가) 카테고리명
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private Date createdAt; // 최초 작성일시
    private Date updatedAt; // 최종 수정일시
    private String isDeleted; // 삭제여부
    private int fileGroupNo; // 첨부파일분류일련번호
    private String publicYn;    // ← 추가 ('Y' or 'N')

    private String writerName;
    private String answered; // 'Y' or 'N'

    // 답변 관련
    private Integer ansId;
    private String answerContent;
    private Date answeredAt;

    public String getMaskedWriterName() {
        if (writerName == null || writerName.isEmpty()) return null;

        int len = writerName.length();

        if (len == 1) {
            return "*";
        } else if (len == 2) {
            return writerName.charAt(0) + "*";
        } else {
            int maskLen = len - 2;
            StringBuilder masked = new StringBuilder();
            masked.append(writerName.charAt(0));
            for (int i = 0; i < maskLen; i++) {
                masked.append("*");
            }
            masked.append(writerName.charAt(len - 1));
            return masked.toString();
        }
    }


}
