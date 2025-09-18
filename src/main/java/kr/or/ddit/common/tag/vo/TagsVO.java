package kr.or.ddit.common.tag.vo;

import java.util.Date;

import lombok.Data;

/**
 * 태그 정보를 담기 위한 VO 클래스
 */
@Data
public class TagsVO {
    private String tagName; // 태그네임
    private Date updatedAt; // 최종수정일시
}
