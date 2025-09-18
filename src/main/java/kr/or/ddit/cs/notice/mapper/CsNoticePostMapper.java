package kr.or.ddit.cs.notice.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.cs.notice.vo.CsNoticePostVO;

@Mapper
public interface CsNoticePostMapper {

    /** (기존) 전체 공지 조회 */
    List<CsNoticePostVO> selectAllNotices();

    /** (NEW) 페이징 처리된 공지 목록 조회 */
    List<CsNoticePostVO> selectNoticesByPage(Map<String, Object> map);

    /** (NEW) 페이징용 전체 건수 조회 */
    int selectNoticeCount(Map<String, Object> map);

    /** (기존) 단일 조회 */
    CsNoticePostVO selectNoticeById(@Param("postId") int postId);

    /** (기존) 등록 */
    int insertNotice(CsNoticePostVO notice);

    /** (기존) 수정 */
    int updateNotice(CsNoticePostVO notice);

    /** (기존) 조회수 증가 */
    void incrementViewCount(int postId);

    /** (기존) 카테고리별 조회 */
    List<CsNoticePostVO> selectNoticeByCategory(String catCodeId);

    List<Map<String, Object>> selectRecentNotices(@Param("limit") int limit);

    int deleteNotice(@Param("postId") int postId);
}
