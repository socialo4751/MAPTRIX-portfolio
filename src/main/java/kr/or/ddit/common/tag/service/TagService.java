// =================== TagService.java (인터페이스) ===================
package kr.or.ddit.common.tag.service;

import java.util.List;

public interface TagService {

    /**
     * 게시물과 관련된 태그 목록을 처리합니다.
     * 1. 각 태그를 TAGS 테이블에 UPSERT합니다.
     * 2. 각 태그를 TAGS_POST_CON 테이블을 통해 게시물과 연결합니다.
     *
     * @param entityType 게시물의 종류 (예: "COMM_FREE_POST", "COMM_REVIEW_POST")
     * @param entityId   게시물의 PK 값
     * @param tagNames   사용자가 입력한 태그 이름 리스트
     */
    void processTags(String entityType, String entityId, List<String> tagNames);
}