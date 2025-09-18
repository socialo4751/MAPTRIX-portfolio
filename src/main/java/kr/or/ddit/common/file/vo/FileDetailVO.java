package kr.or.ddit.common.file.vo;

import java.util.Date;

import lombok.Data;

/**
 * 첨부파일 상세 정보를 담기 위한 VO 클래스
 */
@Data
public class FileDetailVO {
    private int fileSn; // 첨부파일상세일련번호
    private long fileGroupNo; // 첨부파일분류일련번호
    private String fileOriginalName; // 원본파일명
    private String fileSaveName; // 저장파일명
    private String fileSaveLocate; // 저장파일위치
    private long fileSize; // 파일크기 (바이트)
    private String fileExt; // 파일확장자
    private String fileMime; // 파일 MIME 타입
    private String fileFancysize; // 표시용 파일 크기
    private Date fileSaveDate; // 파일저장일시
    private int fileDowncount; // 다운로드 수
    private String fileRole; // 파일역할
}
