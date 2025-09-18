package kr.or.ddit.community.free.service.impl;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.community.free.mapper.CodeBizMapper;
import kr.or.ddit.community.free.service.CodeBizService;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CodeBizServiceImpl implements CodeBizService {
	
	private final CodeBizMapper codeBizMapper;

	@Override
	public CodeBizVO getBizInfoByCode(String bizCodeId) {
		// TODO Auto-generated method stub
		return codeBizMapper.selectBizInfoByCode(bizCodeId);
	}
	
    @Override
    public List<CodeBizVO> getAllMainCategories() {
        return codeBizMapper.selectMainCategories();
    }

    @Override
    public List<CodeBizVO> getSubCategoriesByParentCode(String parentCodeId) {
        return codeBizMapper.selectSubCategoriesByParentCode(parentCodeId);
    }
}
