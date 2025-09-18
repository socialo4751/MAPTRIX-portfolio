package kr.or.ddit.user.my.dlhistory.mapper;

import java.util.List;
import java.util.Map; // Map을 파라미터로 받기 위해 import

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.user.my.dlhistory.vo.UserDlHistoryVO;

@Mapper
public interface UserDlHistoryMapper {

    /**
     * 새로운 다운로드 또는 분석 이력을 데이터베이스에 삽입합니다.
     */
    public int insertHistory(UserDlHistoryVO userDlHistoryVO);

    /**
     * [수정] 특정 사용자의 전체 이력 개수를 조건(필터, 검색어)에 따라 조회합니다.
     * @param map 'userId', 'filterType', 'keyword' 키를 포함하는 맵
     * @return 조건에 맞는 전체 이력 수
     */
    public int selectTotalCountByUserId(Map<String, Object> map);

    /**
     * [수정] 특정 사용자의 이력 목록을 조건과 페이징에 맞게 조회합니다.
     * @param map 'userId', 'startRow', 'endRow', 'filterType', 'keyword' 키를 포함하는 맵
     * @return 페이징 처리된 이력 목록
     */
    public List<UserDlHistoryVO> selectHistoryListByUserId(Map<String, Object> map);
    
    /**
     * 파일 그룹 번호로 다운로드 이력 단일 건을 조회합니다.
     * @param fileGroupNo 파일 그룹 번호
     * @return 조회된 UserDlHistoryVO 객체
     */
    UserDlHistoryVO getHistoryByFileGroupNo(Long fileGroupNo);
    
    /**
     * 히스토리 ID를 통해 다운로드 이력 정보를 가져옵니다.
     * @param historyId 히스토리 ID
     * @return UserDlHistoryVO 객체 또는 null
     */
    UserDlHistoryVO getHistoryById(Long historyId);
}
