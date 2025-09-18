package kr.or.ddit.cs.faq.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.cs.faq.vo.CsFaqVO;

import java.util.List;
import java.util.Map;


@Mapper
public interface CsFaqMapper {
    List<CsFaqVO> selectFaqList();

    List<CsFaqVO> selectPagedFaqList(Map<String, Object> map);

    int selectFaqCount(Map<String, Object> map);

    CsFaqVO selectFaqById(int faqId);

    int insertFaq(CsFaqVO vo);

    int updateFaq(CsFaqVO vo);

    int deleteFaq(int faqId);
}
