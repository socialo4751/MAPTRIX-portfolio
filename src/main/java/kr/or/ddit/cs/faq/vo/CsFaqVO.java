package kr.or.ddit.cs.faq.vo;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CsFaqVO {
    private int faqId;

    @NotBlank(message = "제목을 입력해 주세요.")
    private String title;

    @NotBlank(message = "내용을 입력해 주세요.")
    private String content;

    private String catCodeId;
    private String catCodeName;

    private Integer fileGroupNo;  // 첨부/에디터 이미지 그룹번호
    private String delYn; // 'N' 기본, 삭제 시 'Y'
}