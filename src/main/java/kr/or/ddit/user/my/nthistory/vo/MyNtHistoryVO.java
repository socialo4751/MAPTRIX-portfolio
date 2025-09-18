package kr.or.ddit.user.my.nthistory.vo;

import lombok.Data;

/**
 * 마이페이지 알림 내역 조회의 검색 및 페이징 처리를 위한 VO
 */
@Data
public class MyNtHistoryVO {

    // 검색 조건
    private String userId;      // 사용자 ID
    private String startDate;   // 검색 시작일 (yyyy-MM-dd)
    private String endDate;     // 검색 종료일 (yyyy-MM-dd)
    private String keyword;    // 검색어
    private String searchType; // 검색 타입

    // 페이징 처리 관련
    private int currentPage = 1; // 현재 페이지 번호 (기본값 1)
    private int size;            // ArticlePage에서 사용될 목록 개수
    private int startRow;        // 쿼리에서 사용할 시작 행 번호
    private int endRow;          // 쿼리에서 사용할 종료 행 번호

    // ArticlePage에서 페이징 HTML 생성을 위해 추가될 수 있음
    // 예: private String url;
}