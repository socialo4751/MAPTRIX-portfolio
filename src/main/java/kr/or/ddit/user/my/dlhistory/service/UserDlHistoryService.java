package kr.or.ddit.user.my.dlhistory.service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;

/**
 * 사용자 다운로드/분석 이력 관리를 위한 서비스 인터페이스입니다.
 * <p>
 * Controller와 Mapper 사이에서 비즈니스 로직을 처리하는 역할을 정의합니다.
 *
 * @author Gemini
 * @since 2025. 08. 08.
 */
public interface UserDlHistoryService {

	/**
     * [수정] 특정 사용자의 다운로드/분석 이력 목록을 조건에 맞게 페이징 처리하여 조회합니다.
     *
     * @param userId      이력을 조회할 사용자의 ID
     * @param currentPage 조회할 페이지 번호
     * @param filterType  필터링할 이력 타입 ('simple', 'detail', 'excel')
     * @param keyword     검색할 제목 키워드
     * @return 페이징 정보와 조건에 맞는 이력 목록이 담긴 ArticlePage 객체
     */
    ArticlePage<UserDlHistoryVO> getHistoryListByUserId(String userId, int currentPage, String filterType, String keyword);

    /**
     * 새로운 다운로드 또는 분석 이력을 생성(DB에 삽입)합니다.
     *
     * @param userDlHistoryVO 저장할 이력 정보가 담긴 VO 객체
     * @return 성공적으로 삽입된 행의 수 (일반적으로 1)
     */
    int createHistory(UserDlHistoryVO userDlHistoryVO);
    
    /**
     * 파일 그룹 번호를 통해 다운로드 이력 정보를 가져옵니다.
     * @param fileGroupNo 파일 그룹 번호
     * @return UserDlHistoryVO 객체 또는 null
     */
    UserDlHistoryVO getHistoryByFileGroupNo(Long fileGroupNo);
    
    /**
     * 히스토리 ID를 통해 다운로드 이력 정보를 가져옵니다.
     * @param historyId 히스토리 ID
     * @return UserDlHistoryVO 객체 또는 null
     */
    UserDlHistoryVO getHistoryById(Long historyId);
}
