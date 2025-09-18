package kr.or.ddit.user.my.nthistory.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.user.my.nthistory.mapper.MyNtHistoryMapper;
import kr.or.ddit.user.my.nthistory.service.MyNtHistoryService;
import kr.or.ddit.user.my.nthistory.vo.MyNtHistoryVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyNtHistoryServiceImpl implements MyNtHistoryService {

    private final MyNtHistoryMapper myNtHistoryMapper;

    @Override
    public ArticlePage<UserNotifiedVO> getMyNotificationHistory(MyNtHistoryVO myNtHistoryVO) {
        // 1. 검색 조건에 맞는 전체 알림 개수 조회
        int total = myNtHistoryMapper.selectTotalCount(myNtHistoryVO);

        // 2. 한 페이지에 보여줄 개수(10개) 설정
        int size = 10;

        // 3. 페이징을 위한 startRow, endRow 계산
        int currentPage = myNtHistoryVO.getCurrentPage();
        int startRow = (currentPage - 1) * size + 1;
        int endRow = currentPage * size;
        
        // 4. 계산된 페이징 정보를 MyNtHistoryVO에 설정
        myNtHistoryVO.setStartRow(startRow);
        myNtHistoryVO.setEndRow(endRow);
        myNtHistoryVO.setSize(size);

        // 5. 조건에 맞는 목록(10개) 조회
        List<UserNotifiedVO> content = myNtHistoryMapper.selectNotificationList(myNtHistoryVO);
        
        // 6. ArticlePage 객체 생성 (올바른 생성자 사용)
        // 검색어가 없으므로 빈 문자열로 설정
        String keyword = (myNtHistoryVO.getKeyword() != null) ? myNtHistoryVO.getKeyword() : "";
        String searchType = (myNtHistoryVO.getSearchType() != null) ? myNtHistoryVO.getSearchType() : "";
        
        ArticlePage<UserNotifiedVO> articlePage = new ArticlePage<>(
            total, 
            currentPage, 
            size, 
            content, 
            keyword,
            searchType
        );

        // 7. 완성된 ArticlePage 객체 반환
        return articlePage;
    }
}