package kr.or.ddit.community.free.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.common.vo.code.CodeBizVO;

public interface CodeBizService {

	CodeBizVO getBizInfoByCode(String bizCodeId);

	List<CodeBizVO> getAllMainCategories();

	List<CodeBizVO> getSubCategoriesByParentCode(String parentCodeId);

}
