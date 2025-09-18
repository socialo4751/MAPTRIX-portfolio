// =================== CodeServiceImpl.java (구현체) ===================
package kr.or.ddit.common.code.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.code.mapper.CodeMapper;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.code.vo.CodeGroupVO;
import kr.or.ddit.common.vo.code.CodeDistrictVO;

@Service
public class CodeServiceImpl implements CodeService {

    @Autowired
    private CodeMapper codeMapper;

    @Override
    public List<CodeGroupVO> getCodeGroupList() {
        return codeMapper.getCodeGroupList();
    }

    @Override
    public List<CodeDetailVO> getCodeDetailList(String codeGroupId) {
        return codeMapper.getCodeDetailList(codeGroupId);
    }
    
    @Override
    public List<CodeDistrictVO> getDistrictList() {
        return codeMapper.getDistrictList();
    }
}