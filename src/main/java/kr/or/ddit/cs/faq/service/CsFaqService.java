package kr.or.ddit.cs.faq.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cs.faq.vo.CsFaqVO;

public interface CsFaqService {
    List<CsFaqVO> getFaqList();

    List<CsFaqVO> getPagedFaqList(Map<String, Object> paramMap);

    int getFaqCount(Map<String, Object> paramMap);

    CsFaqVO getFaqById(int faqId);

    int createFaq(CsFaqVO vo);

    int updateFaq(CsFaqVO vo);

    int deleteFaq(int faqId);
}
