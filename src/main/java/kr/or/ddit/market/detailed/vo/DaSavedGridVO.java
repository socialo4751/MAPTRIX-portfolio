package kr.or.ddit.market.detailed.vo;

import java.util.Date;

import lombok.Data;

/**
 * 사용자가 저장한 격자 정보를 담기 위한 VO 클래스
 */
@Data
public class DaSavedGridVO {
    private int savedGridId; // 저장격자ID
    private String gridId; // 격자ID
    private String userId; // 사용자ID
    private Date createdAt; // 저장일시
    private String memo; // 사용자메모
}
