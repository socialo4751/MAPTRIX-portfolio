package kr.or.ddit.startup.design.vo;

import java.util.Date;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 쇼룸 디자인 정보를 담기 위한 VO 클래스
 */
@Data
public class SuShowDesignVO {
    private int designId; // 디자인 ID
    private String userId; // 회원고유번호
    @NotBlank(message = "디자인 이름은 필수입니다.")
    private String designName; // 디자인 명
    private String designData; // 2D_도면_데이터
    private Date createdAt; // 최초 생성일시
    private String isDeleted; // 삭제 여부
    private long fileGroupNo; // 첨부파일분류일련번호
    private Double areaSqm; // 계
    
    // (추가) 썸네일 이미지 경로를 담을 필드
    private String screenshotUrl;
}
