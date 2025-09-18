package kr.or.ddit.common.file.vo;

import java.util.Date;

import lombok.Data;

/**
 * 첨부파일 그룹 정보를 담기 위한 VO 클래스
 */
@Data
public class FileGroupVO {
    private long fileGroupNo; // 첨부파일분류일련번호
    private Date fileRegdate; // 최초등록일시
}
