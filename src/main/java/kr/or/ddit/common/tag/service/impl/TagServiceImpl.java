// =================== TagServiceImpl.java (구현체) ===================
package kr.or.ddit.common.tag.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import kr.or.ddit.common.tag.mapper.TagMapper;
import kr.or.ddit.common.tag.service.TagService;

@Service
public class TagServiceImpl implements TagService {

    @Autowired
    private TagMapper tagMapper;

    @Override
    @Transactional
    public void processTags(String entityType, String entityId, List<String> tagNames) {
        // 태그 목록이 비어있으면 아무것도 하지 않음
        if (CollectionUtils.isEmpty(tagNames)) {
            return;
        }

        for (String tagName : tagNames) {
            // 1. TAGS 테이블에 태그가 없으면 새로 등록
            tagMapper.upsertTag(tagName);

            // 2. TAGS_POST_CON 테이블에 게시물과 태그 연결
            Map<String, Object> params = new HashMap<>();
            params.put("entityType", entityType);
            params.put("entityId", entityId);
            params.put("tagName", tagName);
            tagMapper.insertPostTag(params);
        }
    }
}