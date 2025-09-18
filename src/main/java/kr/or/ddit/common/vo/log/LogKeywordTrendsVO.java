package kr.or.ddit.common.vo.log;

import java.util.Date;

import lombok.Data;

/**
 * 키워드 트렌드 분석 로그 정보를 담기 위한 VO 클래스
 */
@Data
public class LogKeywordTrendsVO {
    private int logId; // 로그 ID
    private String userId; // 회원고유번호
    private String keyword; // 분석 키워드
    private String relatedKeyword; // 분석된 연관 키워드
    private Integer searchVolume; // 키워드 검색량
    private String sourceApi; // 데이터 출처 API
    private Date createdAt; // 데이터 생성(저장) 일시
}
