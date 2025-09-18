package kr.or.ddit.common.vo.log;

import java.util.Date;

import lombok.Data;

/**
 * 프랜차이즈 검색 로그 정보를 담기 위한 VO 클래스
 */
@Data
public class LogFranchiseSearchVO {
    private int logId; // 로그 ID
    private String userId; // 사용자ID
    private int franchiseId; // 프랜차이즈 ID
    private Date searchedAt; // 검색일시
}
