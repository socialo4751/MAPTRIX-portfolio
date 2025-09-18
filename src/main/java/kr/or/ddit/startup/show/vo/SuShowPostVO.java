package kr.or.ddit.startup.show.vo;

import java.util.Arrays;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import kr.or.ddit.common.file.vo.FileDetailVO;
import lombok.Data;

/**
 * 쇼룸 게시물 정보를 담기 위한 VO 클래스
 */
@Data
public class SuShowPostVO {
    private int postId; // 게시물 ID
    private String userId; // 회원고유번호
    private int designId; // 프로젝트 ID
    private String title; // 제목
    private String content; // 내용
    private int viewCount; // 조회수
    private int likeCount; // 좋아요 수
    private String isDeleted; // 게시물 삭제 여부 ('Y'/'N')
    private Date createdAt; // 최초작성일시
    private Date updatedAt; // 최종수정일시
    private String hashtags; // 해시태그 (쉼표로 구분된 문자열)
    private long fileGroupNo; // 첨부파일분류일련번호
    private String designName; // 원본 도면의 이름
    
    private List<FileDetailVO> fileDetailList; // 파일 리스트 필드
    
    // 썸네일 이미지 경로를 담기 위한 필드
    private String thumbnailPath;
    
    // [추가] 월간 좋아요 수를 담을 변수
    private int monthlyLikeCount;
    
    // 해시태그 문자열 리스트
    public List<String> getHashtagList() {
        if (this.hashtags == null || this.hashtags.trim().isEmpty()) {
            return Collections.emptyList(); // 해시태그가 없으면 빈 리스트 반환
        }
        // 쉼표(,)를 기준으로 문자열을 자르고, 각 태그의 양옆 공백을 제거한 후 리스트로 만듭니다.
        return Arrays.stream(this.hashtags.split(","))
                     .map(String::trim)
                     .collect(Collectors.toList());
    }
    
    public void setFileGroupNo(long fileGroupNo) {
        this.fileGroupNo = fileGroupNo;
    }
    
    public long getFileGroupNo() {
        return fileGroupNo;
    }

}

