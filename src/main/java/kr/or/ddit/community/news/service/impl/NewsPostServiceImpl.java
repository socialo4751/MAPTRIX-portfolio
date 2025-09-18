package kr.or.ddit.community.news.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.tag.mapper.TagMapper;
import kr.or.ddit.common.util.NaverNewsApiUtil;
import kr.or.ddit.community.news.mapper.NewsPostMapper;
import kr.or.ddit.community.news.service.NewsPostService;
import kr.or.ddit.community.news.vo.CommNewsPostVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 뉴스 게시판 관련 비즈니스 로직을 처리하는 서비스 구현체
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class NewsPostServiceImpl implements NewsPostService {
    	// Client Secret : kfvSIpg27Q
		// Client ID : 4qQPKYHXBA87CUDwzxjO
	
	
	  
	    private final NewsPostMapper newsBoardMapper;
	    private final NaverNewsApiUtil naverNewsApiUtil;
	    private final TagMapper tagMapper; //Tag 관련 데이터베이스 작업을 처리하는 매퍼
	    private final FileService fileService;
	    /**
	     * 빅카인즈 API를 호출하여 뉴스 데이터를 가져옵니다.
	     * @param keyword 검색 키워드
	     * @return 빅카인즈 API로부터 받은 JSON 형태의 응답 문자열
	     */
	    @Override //사용자가 검색어를 입력하면 유틸이(bigkindsApiUtil.fetchNewsFromBigkinds(keyword))이 api에 요청 보내서 뉴스를 받아옴 
	    public String searchBigkindsNews(String keyword) {
	        log.info("뉴스 검색 시작 - 키워드: {}", keyword);
	        try {
	            String result = naverNewsApiUtil.fetchNewsFromBigkinds(keyword);
	            log.info("뉴스 검색 완료 - 키워드: {}", keyword);
	            return result; //성공하면 결과를 보여줘!
	        } catch (Exception e) {
	            log.error("API 호출 실패 - 키워드: {}, 오류: {}", keyword, e.getMessage(), e);//실패하면 에러 메시지를 출력해줘!
	            throw new RuntimeException("뉴스 검색 중 오류가 발생했습니다: " + e.getMessage(), e);
	            //runtimexception을 쓰는 이유는 유연성(checked exception은 반드시 trycatch나 throws로 처리해야되는데 얘는 컴파일 오류 안나서 괜찮다)
	            //쉽게 말해서 걍 간단한 로직처리?라고 생각. 컴파일오류가 아니니까 계속 프로그램은 작동하되 개발자에게 오류가 발생한것을 알려주는 정도?! 가벼운 오류잡기
	        }
	    }

	    /**
	     * 빅카인즈 API에서 가져온 뉴스 데이터를 데이터베이스에 저장(리스트로 저장)
	     * @param newsList 저장할 CommNewsPostVO 객체 리스트
	     * @return 저장된 뉴스 개수
	     */
	    @Override
	    @Transactional // 트랜잭션 관리
	    public int saveBigkindsNews(List<CommNewsPostVO> newsList, Map<String, List<String>> newsTagsMap) {
	        log.info("뉴스 데이터 저장 시작 - 대상 건수: {}", newsList.size());

	        String currentAdminId = null;
	        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

	        if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
	            currentAdminId = authentication.getName();
	            log.debug("현재 로그인한 관리자 ID: {}", currentAdminId);
	        } else {
	            currentAdminId = "admin@test.com"; // 로그인 정보 없을 시 기본값
	            log.warn("뉴스 수동 등록 시도 중 로그인된 관리자 정보를 찾을 수 없습니다. ADMIN_ID를 '{}'로 설정합니다.", currentAdminId);
	        }

	        int savedCount = 0;
	        // SimpleDateFormat은 스레드 안전하지 않으므로, 루프 안에서 매번 생성하거나 ThreadLocal을 사용해야 합니다.
	        // 여기서는 매번 생성하는 방식으로 안전하게 처리합니다.
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	        for (CommNewsPostVO news : newsList) {
	            // CommNewsPostVO에 직접 기본값 설정 (매퍼에 Map으로 넘기기 전)
	            news.setIsDeleted("N");
	            news.setViewCount(0);
	            news.setAdminId(currentAdminId);

	            if (news.getCatCodeId() == null || news.getCatCodeId().trim().isEmpty()) {
	                news.setCatCodeId("ETC"); // 카테고리 코드 ID가 없으면 'ETC'로 설정
	            }

	            // 1. 매퍼에 전달할 Map 생성 및 CommNewsPostVO 필드 값 추가
	            Map<String, Object> paramMap = new HashMap<>();

	            // **필수 필드 NULL/빈 문자열 검사 및 기본값 설정**
	            // ADMIN_ID
	            paramMap.put("adminId", news.getAdminId());
	            // CAT_CODE_ID
	            paramMap.put("catCodeId", news.getCatCodeId());

	            // TITLE (기존 로직 유지 및 개선)
	            String newsTitle = news.getTitle();
	            if (newsTitle == null || newsTitle.trim().isEmpty()) {
	                log.warn("🚨 경고: API News ID [{}] - 제목이 비어있거나 NULL입니다. 기본 제목을 설정합니다.", news.getApiNewsId());
	                newsTitle = "[제목 없음]";
	            }
	            paramMap.put("title", newsTitle);
	            log.debug("뉴스 VO에서 가져온 제목: [{}], Map에 담긴 제목: [{}]", news.getTitle(), paramMap.get("title"));

	            // **CONTENT (수정 핵심: NULL/빈 문자열 검사 및 기본값 설정 추가)**
	            String newsContent = news.getContent();
	            if (newsContent == null || newsContent.trim().isEmpty()) {
	                log.warn("🚨 경고: API News ID [{}] - 내용이 비어있거나 NULL입니다. 기본 내용을 설정합니다.", news.getApiNewsId());
	                newsContent = "[내용 없음]"; // CONTENT에 대한 기본값 설정
	            }
	            paramMap.put("content", newsContent);
	            log.debug("뉴스 VO에서 가져온 내용: [{}], Map에 담긴 내용: [{}]", news.getContent(), paramMap.get("content"));

	            // PRESS (NULL/빈 문자열 검사 및 기본값 설정 추가)
	            String newsPress = news.getPress();
	            if (newsPress == null || newsPress.trim().isEmpty()) {
	                log.warn("🚨 경고: API News ID [{}] - 언론사 정보가 비어있거나 NULL입니다. 기본값 '미상'을 설정합니다.", news.getApiNewsId());
	                newsPress = "미상";
	            }
	            paramMap.put("press", newsPress);
	            log.debug("뉴스 VO에서 가져온 언론사: [{}], Map에 담긴 언론사: [{}]", news.getPress(), paramMap.get("press"));


	            // API_NEWS_ID (NULL/빈 문자열 검사 및 기본값 설정 추가, 필요에 따라)
	            String apiNewsId = news.getApiNewsId();
	            if (apiNewsId == null || apiNewsId.trim().isEmpty()) {
	                log.warn("🚨 경고: API News ID가 비어있거나 NULL입니다. 기본값 'UNKNOWN_API_ID'을 설정합니다.", news.getApiNewsId());
	                apiNewsId = "UNKNOWN_API_ID"; // 또는 다른 적절한 기본값
	            }
	            paramMap.put("apiNewsId", apiNewsId);
	            log.debug("뉴스 VO에서 가져온 API News ID: [{}], Map에 담긴 API News ID: [{}]", news.getApiNewsId(), paramMap.get("apiNewsId"));


	            // LINK_URL (NULL/빈 문자열 검사 및 기본값 설정 추가, 필요에 따라)
	            String linkUrl = news.getLinkUrl();
	            if (linkUrl == null || linkUrl.trim().isEmpty()) {
	                log.warn("🚨 경고: API News ID [{}] - 링크 URL이 비어있거나 NULL입니다. 기본값 '링크없음'을 설정합니다.", news.getApiNewsId());
	                linkUrl = "링크없음"; // 또는 적절한 기본 URL
	            }
	            paramMap.put("linkUrl", linkUrl);
	            log.debug("뉴스 VO에서 가져온 링크 URL: [{}], Map에 담긴 링크 URL: [{}]", news.getLinkUrl(), paramMap.get("linkUrl"));


	            // THUMBNAIL_URL (NULL/빈 문자열 검사 및 기본값 설정 추가, 필요에 따라)
	            String thumbnailUrl = news.getThumbnailUrl();
	            if (thumbnailUrl == null || thumbnailUrl.trim().isEmpty()) {
	                 log.debug("API News ID [{}] - 썸네일 URL이 비어있거나 NULL입니다. 기본값을 설정하지 않습니다(NULL 허용).", news.getApiNewsId());
	                 // 썸네일은 필수 필드가 아닐 수 있으므로, NULL을 허용하거나 적절한 기본 이미지 URL을 설정합니다.
	                 // 여기서는 NULL을 그대로 전달하여 DB에서 NULL이 되도록 둡니다.
	            }
	            paramMap.put("thumbnailUrl", thumbnailUrl);
	            log.debug("뉴스 VO에서 가져온 썸네일 URL: [{}], Map에 담긴 썸네일 URL: [{}]", news.getThumbnailUrl(), paramMap.get("thumbnailUrl"));


	            // 기타 필드
	            paramMap.put("viewCount", news.getViewCount());
	            paramMap.put("isDeleted", news.getIsDeleted());
	            paramMap.put("fileGroupNo", news.getFileGroupNo()); // 파일 그룹 번호는 보통 0 또는 NULL 허용


	            // PUBLISHED_AT 필드를 "YYYY-MM-DD" 형식의 String으로 포맷팅하여 Map에 추가
	            Date publishedAtDate = news.getPublishedAt();
	            if (publishedAtDate != null) {
	                String formattedPublishedAt = sdf.format(publishedAtDate);
	                paramMap.put("publishedAtFormatted", formattedPublishedAt);
	                log.debug("Formatted PUBLISHED_AT sent to DB (via Map): [{}]", formattedPublishedAt);
	            } else {
	                paramMap.put("publishedAtFormatted", null); // Date가 null이면 Map에도 null 전달
	                log.debug("PUBLISHED_AT 값이 null입니다. DB로 null을 전달합니다. (DB SYSDATE 적용)");
	            }

	            try {
	                // MyBatis 매퍼의 insertNewsWithMap 메서드 호출
	                // 이 호출에서 <selectKey>에 의해 newsId가 paramMap에 채워집니다.
	                savedCount += newsBoardMapper.insertNewsWithMap(paramMap);

	                // <selectKey>로 생성된 newsId를 Map에서 가져와 VO 객체에 다시 설정
	                int newNewsId = (int) paramMap.get("newsId");
	                news.setNewsId(newNewsId);

	                // 태그 저장 로직: newsTagsMap에서 태그 정보를 가져와 처리
	                List<String> tags = newsTagsMap.get(news.getApiNewsId());
	                if (tags != null && !tags.isEmpty()) {
	                    for (String tagName : tags) {
	                        tagMapper.upsertTag(tagName); // TAGS 테이블에 태그가 없으면 추가

	                        // TAGS_POST_CON 테이블에 연결 정보 저장
	                        Map<String, Object> tagConMap = new HashMap<>();
	                        tagConMap.put("entityType", "COMM_NEWS_POST");
	                        tagConMap.put("entityId", String.valueOf(newNewsId)); // 새로 생성된 뉴스 ID 사용
	                        tagConMap.put("tagName", tagName);
	                        tagMapper.insertPostTag(tagConMap);
	                    }
	                }
	            } catch (Exception e) {
	                log.error("🚨 심각: API 뉴스 ID [{}] 데이터 저장 중 오류 발생: {}", news.getApiNewsId(), e.getMessage(), e);
	                // 오류가 발생하면 현재 뉴스 건은 실패로 간주하고,
	                // 다음 뉴스를 처리하거나 전체 트랜잭션을 롤백할지 결정해야 합니다.
	                // 현재 @Transactional이 적용되어 있으므로, 예외를 다시 던지면 롤백됩니다.
	                throw new RuntimeException("뉴스 데이터 저장 실패: " + e.getMessage(), e); // 런타임 예외로 래핑하여 트랜잭션 롤백 유도
	            }
	        }

	        log.info("뉴스 데이터 저장 완료 - 성공 건수: {}/{}", savedCount, newsList.size());
	        return savedCount;
	    }
	
	    /**
	     * 조건에 맞는 전체 뉴스 게시글의 수를 조회합니다.
	     * @param searchMap 검색 조건
	     * @return 전체 뉴스 게시글 수
	     */
	    @Override
	    public int getTotalNewsCount(Map<String, Object> searchMap) {
	        log.debug("뉴스 전체 개수 조회 - 검색조건: {}", searchMap); //검색조건에 대해 알려줌 
	        return newsBoardMapper.selectTotalNewsCount(searchMap); //전체 몇개인지 알려줌->이건 페이징 처리를 위해 필요하고 아래 getNewsList는 화면에 출력된 뉴스목록을 위한 메서드
	    }

	    /**
	     * 조건에 맞는 뉴스 게시글 목록을 조회합니다.
	     * @param searchMap 검색 조건 (currentPage, size 포함)
	     * @return 뉴스 게시글 목록
	     */
	    @Override
	    public List<CommNewsPostVO> getNewsList(Map<String, Object> searchMap) {
	        log.debug("뉴스 목록 조회 - 검색조건: {}", searchMap);
	        
	        // Controller에서 받은 currentPage와 size로 startRow, endRow 계산
	        Integer currentPage = (Integer) searchMap.get("currentPage");
	        Integer size = (Integer) searchMap.get("size");
	        
	        if (currentPage != null && size != null) {
	            // startRow, endRow 계산
	            int startRow = (currentPage - 1) * size + 1;
	            int endRow = currentPage * size;
	            
	            // 계산된 값을 searchMap에 추가
	            searchMap.put("startRow", startRow);
	            searchMap.put("endRow", endRow);
	            
	            // 디버깅용 로그
	            log.debug("페이징 계산 - currentPage: {}, size: {}, startRow: {}, endRow: {}", 
	                      currentPage, size, startRow, endRow);
	        } else {
	            log.warn("currentPage 또는 size가 null입니다. currentPage: {}, size: {}", currentPage, size);
	        }
	        
	        // MyBatis 호출
	        List<CommNewsPostVO> newsList = newsBoardMapper.selectNewsList(searchMap);
	        log.debug("실제 조회된 뉴스 개수: {}", newsList.size());
	        
	        return newsList;
	    }

	    /**
	     * 새로운 뉴스 게시글을 등록합니다.
	     * @param newsPostVO 등록할 뉴스 게시글 정보
	     * @return 등록 성공 여부
	     */
	    @Override
	    @Transactional
	    public boolean insertNews(CommNewsPostVO newsPostVO) { //등록실패여부를 확인하게 위해 boolean을 사용 ->이게 성공하면 1이 됨 
	        log.info("뉴스 게시글 등록 - 제목: {}", newsPostVO.getTitle());
	    
	        // 기본값 설정
	        newsPostVO.setIsDeleted("N"); //삭제되지 않은 게시물이라는것을 표시(소프트 삭제로 인해 db에는 데이터가 잇는 상태지만 삭제한것처럼 보이게 하려고 사용)
	        newsPostVO.setViewCount(0); //조회수 세기(등록할땐 조회수가 0) 
	        if (newsPostVO.getFileGroupNo()<= 0) {   //사용자가 filegroup에서 선택을 안하거나 폼에서 값 전송에 실패하면 null이 들어옴 등 여러이유
	            newsPostVO.setFileGroupNo(0); //0으로 처리하는이유는 없을 경우 0이 되고 있을 경우 1부터 증가하는 구조로 설정하는게 관례.
	        }
	        
	        boolean result = newsBoardMapper.insertNews(newsPostVO) > 0; //등록에 성공하면 값이 1로 되고 이를 0보다 크게해서 성공여부 판단 
	        log.info("뉴스 게시글 등록 {} - 제목: {}", result ? "성공" : "실패", newsPostVO.getTitle()); //삼항연산자로 처리 
	        return result; //결과값 돌려주기 
	    }

	    /**
	     * 특정 뉴스 게시글의 상세 정보를 조회합니다.
	     * 조회수 증가 로직을 포함합니다.
	     * @param newsId 조회할 뉴스 게시글 ID
	     * @return 조회된 뉴스 게시글 정보
	     */
	    @Override
	    @Transactional
	    public CommNewsPostVO getNewsDetail(int newsId) {
	        log.debug("뉴스 상세 조회 - ID: {}", newsId); //newsId가 {}안에 삽입 
	        
	        // 조회수 증가
	        newsBoardMapper.incrementViewCount(newsId); // 뉴스 id를 이용해서 조회수를 증가하라고 mapper에 전달
	        return newsBoardMapper.selectNewsDetail(newsId); //news 글 내용을 가져오는 작업(newsId)에 해당하는 정보를 가져옴 
	    }

	    /**
	     * 뉴스 게시글을 수정합니다.
	     * @param newsPostVO 수정할 뉴스 게시글 정보
	     * @return 수정 성공 여부
	     */
	    @Override
	    @Transactional
	    public boolean updateNews(CommNewsPostVO newsPostVO) { //수정할 뉴스 글 정보를 담은 객체를 처리
	        log.info("뉴스 게시글 수정 - ID: {}, 제목: {}", newsPostVO.getNewsId(), newsPostVO.getTitle()); //각각 newsId와 title을 로그에 찍어줌 
	        
	        boolean result = newsBoardMapper.updateNews(newsPostVO) > 0; //업데이트에 성공하면 1로 찍혀서 수정된 행이 하나 이상이면 성공 실패여부 판단 -> 이를 true or false로 판단
	        log.info("뉴스 게시글 수정 {} - ID: {}", result ? "성공" : "실패", newsPostVO.getNewsId());
	        return result; //결과가 true면 성공, false면 실패로 리턴 
	    }
	    
	    /**
	     * 뉴스 게시글을 삭제(논리적 삭제)합니다.
	     * @param newsId 삭제할 뉴스 게시글 ID
	     * @return 삭제 성공 여부
	     */
	    @Override
	    @Transactional
	    public boolean deleteNews(int newsId) { //성공 삭제여부 판단해야해서 boolean 
	        log.info("뉴스 게시글 삭제 - ID: {}", newsId); //삭제된 newsId가 로그로 출력 
	        
	        boolean result = newsBoardMapper.deleteNews(newsId) > 0; //이건 논리적삭제! 실제 db에 값이 사라지는게 아니라서!
	        log.info("뉴스 게시글 삭제 {} - ID: {}", result ? "성공" : "실패", newsId); //성공 실패 여부가 보임 
	        return result; // 메서드 결과 처리 알려줌 
	    }
	    
	    @Override
	    public FileDetailVO uploadImageForEditor(MultipartFile upload) {
	        // 현재는 특별한 뉴스 관련 비즈니스 로직(예: 이미지 크기 검사, 워터마크 추가 등)이 없으므로,
	        // FileService의 메서드를 그대로 호출하여 결과를 반환합니다.
	        // 게시글이 아직 생성 전이므로 파일 그룹 번호는 null로 전달하여 새로 생성하도록 합니다.
	        log.info("NewsPostServiceImpl: CKEditor 이미지 저장 요청을 FileService로 전달");
	        return fileService.saveEditorImage(upload, null);
	    }
	    
	    @Override
	    public CommNewsPostVO getNewsById(int newsId) {
	        log.debug("뉴스 순수 조회 - ID: {}", newsId);
	        return newsBoardMapper.selectNewsById(newsId);
	    }
	    @Override
	    @Transactional
	    public boolean disconnectFileFromNews(int newsId) {
	        log.info("뉴스(ID: {})와 파일 연결 해제", newsId);
	        return newsBoardMapper.disconnectFileFromNews(newsId) > 0;
	    }
	}
