package kr.or.ddit.cs.notice.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.cs.notice.mapper.CsNoticePostMapper;
import kr.or.ddit.cs.notice.service.CsNoticePostService;
import kr.or.ddit.cs.notice.vo.CsNoticePostVO;

@Service
public class CsNoticePostServiceImpl implements CsNoticePostService {

    private final CsNoticePostMapper noticeMapper;

    @Autowired
    public CsNoticePostServiceImpl(CsNoticePostMapper noticeMapper) {
        this.noticeMapper = noticeMapper;
    }

    /**
     * 전체 공지 조회
     */
    @Override
    public List<CsNoticePostVO> getNoticeList() {
        return noticeMapper.selectAllNotices();
    }

    /**
     * 페이징된 공지 목록 조회
     */
    @Override
    public List<CsNoticePostVO> getNoticeList(Map<String, Object> map) {
        return noticeMapper.selectNoticesByPage(map);
    }

    /**
     * 페이징용 전체 공지 건수 조회
     */
    @Override
    public int getNoticeCount(Map<String, Object> map) {
        return noticeMapper.selectNoticeCount(map);
    }

    /**
     * 단일 공지 조회
     */
    @Override
    public CsNoticePostVO getNotice(int postId) {
        return noticeMapper.selectNoticeById(postId);
    }

    /**
     * 신규 공지 등록
     */
    @Override
    public void createNotice(CsNoticePostVO notice) {
        noticeMapper.insertNotice(notice);
    }

    /**
     * 공지 수정
     */
    @Override
    public int modifyNotice(CsNoticePostVO notice) {
        return noticeMapper.updateNotice(notice);
    }

    /**
     * 조회수 증가
     */
    @Override
    public void increaseViewCount(int postId) {
        noticeMapper.incrementViewCount(postId);
    }

    /**
     * 카테고리별 공지 조회
     */
    @Override
    public List<CsNoticePostVO> getNoticeByCategory(String catCodeId) {
        return noticeMapper.selectNoticeByCategory(catCodeId);
    }

    @Override
    public int delete(int postId) {
        return noticeMapper.deleteNotice(postId);
    }
}
