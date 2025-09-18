package kr.or.ddit.cs.notice.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cs.notice.vo.CsNoticePostVO;

public interface CsNoticePostService {

    /** (기존) 전체 공지 조회 */
    List<CsNoticePostVO> getNoticeList();

    /** (NEW) 페이징 처리된 공지 목록 조회
     *  @param map : "catCodeId", "startRow", "endRow" 키 사용
     *  @return 공지 VO 리스트
     */
    List<CsNoticePostVO> getNoticeList(Map<String, Object> map);

    /** (NEW) 페이징 처리용 총 공지 개수 조회
     *  @param map : "catCodeId" 키 사용
     *  @return 전체 공지 건수
     */
    int getNoticeCount(Map<String, Object> map);

    /** (기존) 단일 공지 조회 */
    CsNoticePostVO getNotice(int postId);

    /** (기존) 신규 공지 등록 */
    void createNotice(CsNoticePostVO notice);

    /** (기존) 공지 수정 */
    int modifyNotice(CsNoticePostVO notice);

    /** (기존) 조회수 증가 */
    void increaseViewCount(int postId);

    /** (기존) 카테고리별 공지 조회 */
    List<CsNoticePostVO> getNoticeByCategory(String catCodeId);

    int delete(int postId);
}
