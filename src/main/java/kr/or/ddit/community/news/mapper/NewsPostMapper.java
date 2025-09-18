package kr.or.ddit.community.news.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.community.news.vo.CommNewsPostVO;

@Mapper

public interface NewsPostMapper {
	public int insertNews(CommNewsPostVO news);

	public int selectTotalNewsCount(Map<String, Object> searchMap);

	public List<CommNewsPostVO> selectNewsList(Map<String, Object> searchMap);

	public int incrementViewCount(int newsId);

	public CommNewsPostVO selectNewsDetail(int newsId);

	public int updateNews(CommNewsPostVO newsPostVO);

	public int deleteNews(int newsId);

	public int insertNewsWithMap(Map<String, Object> paramMap);
	
	public CommNewsPostVO selectNewsById(int newsId);
	
	public int disconnectFileFromNews(int newsId);
}
