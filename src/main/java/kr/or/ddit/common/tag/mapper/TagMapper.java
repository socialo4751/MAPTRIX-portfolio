package kr.or.ddit.common.tag.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 태그(TAGS, TAGS_POST_CON) 관련 DB 처리를 위한 공용 매퍼 인터페이스
 */
@Mapper
public interface TagMapper {

    /**
     * TAGS 테이블에 태그가 없으면 INSERT합니다. (UPSERT)
     * @param tagName 등록할 태그 이름
     * @return 성공 시 1
     */
    public int upsertTag(@Param("tagName") String tagName);

    /**
     * TAGS_POST_CON 테이블에 게시물과 태그의 연결 정보를 저장합니다.
     * @param params Map containing entityType, entityId, tagName
     * @return 성공 시 1
     */
    public int insertPostTag(Map<String, Object> params);
}
