package kr.or.ddit.user.my.dlhistory.vo;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사용자 다운로드/분석 이력(USER_DL_HISTORY) 테이블에 대한 VO 클래스입니다.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDlHistoryVO {

    /**
     * 히스토리 ID (PK)
     */
    private long historyId;

    /**
     * 사용자 ID (FK)
     */
    private String userId;

    /**
     * 이력 구분자 ('SIMPLE_PDF', 'DETAIL_PDF', 'INDICATOR_EXCEL')
     */
    private String historyType;

    /**
     * 이력 제목 (마이페이지에 표시될 제목)
     */
    private String historyTitle;

    /**
     * 분석 조건 (상세 분석 시 사용될 JSON 형태의 파라미터)
     */
    private String analysisParams;

    /**
     * 생성일시
     */
    private Date createdAt;

    /**
     * 첨부파일 그룹 번호 (FK)
     */
    private long fileGroupNo;
}
