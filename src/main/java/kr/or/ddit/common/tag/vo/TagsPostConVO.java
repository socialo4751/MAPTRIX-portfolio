package kr.or.ddit.common.tag.vo;

import java.util.Date;

import lombok.Data;

/**
 * 게시물과 태그의 관계 정보를 담기 위한 VO 클래스
 */
@Data
public class TagsPostConVO {
    private String entityType; // 테이블 명
    private String entityId; // 테이블 PK ID
    private String tagName; // 태그네임
    private Date createdAt; // 등록일시
}
