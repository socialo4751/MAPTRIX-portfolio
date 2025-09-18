package kr.or.ddit.user.my.dlhistory.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.user.my.dlhistory.mapper.UserDlHistoryMapper;
import kr.or.ddit.user.my.dlhistory.service.UserDlHistoryService;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserDlHistoryServiceImpl implements UserDlHistoryService {

    private final UserDlHistoryMapper userDlHistoryMapper;

    /**
     * [수정] 특정 사용자의 이력 목록을 조건에 맞게 페이징 처리하여 조회합니다.
     */
    @Override
    public ArticlePage<UserDlHistoryVO> getHistoryListByUserId(String userId, int currentPage, String filterType, String keyword) {
        // 1. 검색 조건과 사용자 ID를 Map에 담습니다.
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("userId", userId);
        paramMap.put("filterType", filterType);
        paramMap.put("keyword", keyword);

        // 2. Mapper를 호출하여 조건에 맞는 전체 이력 수를 가져옵니다.
        int total = userDlHistoryMapper.selectTotalCountByUserId(paramMap);

        int size = 10;

        // 3. 페이징 데이터를 추가하여 목록 조회용 파라미터 맵을 완성합니다.
        paramMap.put("startRow", (currentPage - 1) * size + 1);
        paramMap.put("endRow", currentPage * size);

        // 4. Mapper를 호출하여 현재 페이지에 해당하는 목록 데이터를 가져옵니다.
        List<UserDlHistoryVO> content = userDlHistoryMapper.selectHistoryListByUserId(paramMap);

        // 5. ArticlePage 객체를 생성하여 반환합니다. 검색어도 전달하여 페이징 URL에 포함되도록 합니다.
        // 페이징 URL 생성 시 쿼리 스트링을 직접 만들어 전달할 수 있습니다.
        ArticlePage<UserDlHistoryVO> articlePage = new ArticlePage<>(total, currentPage, size, content, keyword, filterType);
        articlePage.setUrl("/my/report"); // base URL 설정

        return articlePage;
    }
    

    /**
     * {@inheritDoc}
     */
    @Override
    public int createHistory(UserDlHistoryVO userDlHistoryVO) {
        return userDlHistoryMapper.insertHistory(userDlHistoryVO);
    }
    
    @Override
    public UserDlHistoryVO getHistoryByFileGroupNo(Long fileGroupNo) {
        return userDlHistoryMapper.getHistoryByFileGroupNo(fileGroupNo);
    }
    
    /**
     * {@inheritDoc}
     */
    @Override
    public UserDlHistoryVO getHistoryById(Long historyId) {
        return userDlHistoryMapper.getHistoryById(historyId);
    }
}
