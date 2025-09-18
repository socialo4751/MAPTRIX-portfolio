package kr.or.ddit.cs.faq.service.impl;

import kr.or.ddit.cs.faq.mapper.CsFaqMapper;
import kr.or.ddit.cs.faq.service.CsFaqService;
import kr.or.ddit.cs.faq.vo.CsFaqVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class CsFaqServiceImpl implements CsFaqService {

    private final CsFaqMapper csFaqMapper;

    @Autowired
    public CsFaqServiceImpl(CsFaqMapper csFaqMapper) {
        this.csFaqMapper = csFaqMapper;
    }

    @Override
    public List<CsFaqVO> getFaqList() {
        return csFaqMapper.selectFaqList();
    }

    @Override
    public List<CsFaqVO> getPagedFaqList(Map<String, Object> paramMap) {
        return csFaqMapper.selectPagedFaqList(paramMap);
    }

    @Override
    public int getFaqCount(Map<String, Object> paramMap) {
        return csFaqMapper.selectFaqCount(paramMap);
    }

    @Override
    public CsFaqVO getFaqById(int faqId) {
        return csFaqMapper.selectFaqById(faqId);
    }

    @Override
    public int createFaq(CsFaqVO vo) {
        return csFaqMapper.insertFaq(vo);
    }

    @Override
    public int updateFaq(CsFaqVO vo) {
        return csFaqMapper.updateFaq(vo);
    }

    @Override
    public int deleteFaq(int faqId) {            // 물리 삭제 X
        return csFaqMapper.deleteFaq(faqId);     // ← 위에서 UPDATE로 바뀜
    }
}
