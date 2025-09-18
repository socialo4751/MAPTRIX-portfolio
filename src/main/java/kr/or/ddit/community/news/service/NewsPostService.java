package kr.or.ddit.community.news.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.community.news.vo.CommNewsPostVO;

/**
 * 뉴스 게시판 관련 비즈니스 로직을 처리하는 서비스 인터페이스
 */
public interface NewsPostService {
	/**
     * 빅카인즈 API를 호출하여 뉴스 데이터를 가져옴
     * 이 메서드는 API 호출 로직을 캡슐화하며, 실제 데이터베이스 저장 로직은 별도로 처리됩니다.(saveBingkindsNews)에서 저장됨!!
     * @param keyword 검색 키워드
     * @return 빅카인즈 API로부터 받은 JSON 형태의 응답 문자열
     * @throws IOException API 통신 중 발생할 수 있는 입출력 예외
     */
    public String searchBigkindsNews(String keyword) throws IOException;
    
    /**
     * 빅카인즈 API에서 가져온 뉴스 데이터를 데이터베이스에 저장
     * @param newsList 저장할 CommNewsPostVO 객체 리스트
     * @return 저장된 뉴스 개수
     */
    public int saveBigkindsNews(List<CommNewsPostVO> newsList, Map<String, List<String>> newsTagsMap);
   
    /**
     * 조건에 맞는 전체 뉴스 게시글의 수를 조회
     * 페이징 처리를 위해 사용됩니다.
     * @param searchMap 검색 조건 (예: keyword, searchType, startDate, endDate)
     * @return 전체 뉴스 게시글 수
     */
    public int getTotalNewsCount(Map<String, Object> searchMap);

    /**
     * 조건에 맞는 뉴스 게시글 목록을 조회
     * 검색 조건 (startRow, endRow 포함)을 포함
     * @param searchMap 검색 조건 (예: keyword, searchType, startDate, endDate, startRow, endRow)
     * @return 뉴스 게시글 목록 (CommNewsPostVO 리스트)
     */
    public List<CommNewsPostVO> getNewsList(Map<String, Object> searchMap); // PaginationInfo 대신 Map으로 startRow, endRow 전달

    /**
     * 새로운 뉴스 게시글을 등록 
     * @param newsPostVO 등록할 뉴스 게시글 정보
     * @return 등록 성공 여부 (true: 성공, false: 실패)
     */
    public boolean insertNews(CommNewsPostVO newsPostVO);

    /**
     * 특정 뉴스 게시글의 상세 정보를 조회
     * 조회수 증가 로직을 포함 할 수 있음 
     * @param newsId 조회할 뉴스 게시글 ID
     * @return 조회된 뉴스 게시글 정보 (CommNewsPostVO), 없으면 null
     */
    public CommNewsPostVO getNewsDetail(int newsId);

    /**
     * 뉴스 게시글을 수정
     * @param newsPostVO 수정할 뉴스 게시글 정보
     * @return 수정 성공 여부 (true: 성공, false: 실패)
     */
    public boolean updateNews(CommNewsPostVO newsPostVO);

    /**
     * 뉴스 게시글을 삭제(논리적 삭제)
     * 'IS_DELETED' 컬럼 값을 'Y'로 변경
     * @param newsId 삭제할 뉴스 게시글 ID
     * @return 삭제 성공 여부 (true: 성공, false: 실패)
     */
    public boolean deleteNews(int newsId);

    /**
     * CKEditor를 통해 업로드된 이미지를 저장하고, 저장된 파일 정보를 반환합니다.
     * @param upload 업로드된 이미지 파일
     * @return 저장된 파일의 상세 정보 (FileDetailVO)
     */
    public FileDetailVO uploadImageForEditor(MultipartFile upload);
    
    CommNewsPostVO getNewsById(int newsId);
    boolean disconnectFileFromNews(int newsId);
}
