package kr.or.ddit.startup.design.service.impl;

import java.io.File;
import java.io.IOException; // IOException import 추가
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects; // Objects import 추가
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.mapper.FileMapper;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.file.vo.FileGroupVO;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.startup.design.mapper.DesignMapper;
import kr.or.ddit.startup.design.service.DesignService;
import kr.or.ddit.startup.design.vo.DesignLikedPostVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.vo.SuShowPostVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class DesignServiceImpl implements DesignService {

	@Autowired
	private DesignMapper designMapper;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	private FileService fileService;

	@Value("${file.upload-dir}")
	private String uploadDir;

	// 2D 시뮬레이터에서 생성된 디자인 정보를 DB에 저장
	@LogEvent(eventType = "SAVE", feature = "DESIGN")
	@Override
	public int insertDesign(SuShowDesignVO suShowDesignVO) {
		return designMapper.insertDesign(suShowDesignVO);
	}

	// 관리자의 디자인 목록 조회
	@Override
	public List<SuShowDesignVO> getDesignsByUserId(String userId) {
		return designMapper.selectDesignsByUserId(userId);
	}

	// 마이페이지 데이터 조회 로직 구현
	@Override
	public ArticlePage<SuShowDesignVO> getMyPageData(String userId, int currentPage) {
		// 한 페이지에 보여줄 카드 수
		int size = 9;

		// 1. 해당 사용자의 전체 도면 개수 조회
		int total = designMapper.selectMyDesignsCount(userId);

		// 2. 현재 페이지에 해당하는 도면 목록을 먼저 조회합니다.
		int startRow = (currentPage - 1) * size + 1;
		int endRow = currentPage * size;
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("userId", userId);
		paramMap.put("startRow", startRow);
		paramMap.put("endRow", endRow);

		List<SuShowDesignVO> content = designMapper.selectMyDesigns(paramMap);

		// 3. 조회된 목록(content)을 포함하여 ArticlePage 객체를 생성합니다.
		// new ArticlePage<>(total, currentPage, size, content, keyword, searchType)
		ArticlePage<SuShowDesignVO> articlePage = new ArticlePage<>(total, currentPage, size, content, null, null);

		// 4. 페이징 HTML 생성을 위해 URL을 설정합니다.
		articlePage.setUrl("/start-up/design/myDesignPage");

		return articlePage;
	}

	// ID로 디자인 정보 조회 구현
	@Override
	public SuShowDesignVO getDesignById(int designId) {
		log.info("서비스 호출: ID로 디자인 정보 조회. designId: {}", designId);
		SuShowDesignVO design = designMapper.selectDesignById(designId);
		if (design != null) {
			log.info("매퍼에서 디자인 데이터 가져옴. designId: {}, designName: {}", design.getDesignId(), design.getDesignName());
		} else {
			log.warn("매퍼에서 ID {}에 해당하는 디자인 데이터가 반환되지 않음.", designId);
		}
		return design;
	}

	// 디자인에 대한 논리적 삭제만 수행합니다.
	@LogEvent(eventType = "DELETE", feature = "DESIGN")
	@Transactional
	@Override
	public int deleteDesign(int designId, String userId) {
		log.info("디자인 {}를 논리적으로 삭제합니다. (썸네일 파일은 삭제되지 않음)", designId);

		// Mapper의 deleteDesign이 designId와 userId를 조건으로
		// 논리적 삭제(UPDATE ... SET IS_DELETED = 'Y')를 수행한다고 가정합니다.
		return designMapper.deleteDesign(designId, userId);
	}

	// 좋아요한 게시글 불러오기
	@Override
	public List<DesignLikedPostVO> getLikedPosts(String userId) {
		return designMapper.selectLikedPosts(userId);
	}

	// 메인 페이지용 최신 게시글 목록 조회 구현
	@Override
	public List<SuShowPostVO> getLatestPosts() {
		return designMapper.selectLatestPosts();
	}

	// 페이징 없는 전체 '내 디자인' 목록 조회
	@Override
	public List<SuShowDesignVO> getAllMyDesigns(String userId) {
		return designMapper.selectAllMyDesigns(userId);
	}

	// 다른 사용자의 파일을 저장 (기존 디자인을 복제하여 새로운 사용자의 디자인으로 저장)
	@LogEvent(eventType = "CLONE", feature = "DESIGN")
	@Override
	@Transactional
	public int cloneDesign(int originalDesignId, String newUserId, String newDesignName) {
		// 1. 복제할 원본 디자인의 전체 정보를 불러옵니다.
		SuShowDesignVO originalDesign = designMapper.selectDesignById(originalDesignId);
		if (originalDesign == null) {
			log.warn("복제할 원본 디자인을 찾을 수 없습니다. designId: {}", originalDesignId);
			return 0; // 원본이 없으면 실패
		}

		// 2. 복제될 새로운 디자인 객체를 생성합니다.
		SuShowDesignVO clonedDesign = new SuShowDesignVO();

		// 2-1. 고정된 이름 대신 파라미터로 받은 새 이름 사용
		clonedDesign.setDesignName(newDesignName);

		// 3. 새 소유자 ID와 원본의 데이터를 설정합니다.
		clonedDesign.setUserId(newUserId);
		clonedDesign.setDesignData(originalDesign.getDesignData()); // 핵심: 도면 JSON 데이터 복사
		
		// 3-1. 이미지 복사 
		clonedDesign.setFileGroupNo(originalDesign.getFileGroupNo());

		// 4. 복제된 디자인을 DB에 새로 INSERT 합니다. (기존 insertDesign 메소드 재활용)
		return designMapper.insertDesign(clonedDesign);
	}

	@Override
	public int renameDesign(int designId, String userId, String newDesignName) {
		log.info("서비스 호출: 디자인 이름 변경. designId: {}, userId: {}, newName: {}", designId, userId, newDesignName);
		return designMapper.renameDesign(designId, userId, newDesignName);
	}

	// 이미지 파일 수정 후 이미지 반영.
	@Override
	@Transactional
	public long saveDesignWithThumbnail(SuShowDesignVO vo, MultipartFile thumb) throws IOException {
		// 1. 썸네일 파일이 있다면 FileService를 통해 업로드하고 파일 그룹 번호를 받아옵니다.
		if (thumb != null && !thumb.isEmpty()) {
			// FileService의 uploadFiles 메서드는 MultipartFile 배열을 파라미터로 받으므로,
			// 썸네일 파일 하나를 배열에 담아 전달합니다.
			MultipartFile[] files = { thumb };

			// FileService를 호출하여 파일을 업로드하고, 생성된 fileGroupNo를 반환받습니다.
			long fileGroupNo = fileService.uploadFiles(files, "thumbnail");

			// 반환받은 fileGroupNo를 디자인 VO에 설정합니다.
			vo.setFileGroupNo(fileGroupNo);
		}

		// 2. 파일 그룹 번호가 포함된(또는 썸네일이 없어 0인) 디자인 정보를 DB에 저장합니다.
		designMapper.insertDesign(vo);

		// 3. 생성된 디자인 ID를 반환합니다.
		return vo.getDesignId();
	}

	/**
	 * [새로 추가된 메서드] 디자인 정보를 수정하며, 이전 썸네일은 보존합니다.
	 */
	@LogEvent(eventType = "UPDATE", feature = "DESIGN")
	@Transactional
	@Override
	public int updateDesignWithThumbnail(SuShowDesignVO vo, MultipartFile newThumb) throws IOException {
		// 1. 새로운 썸네일 파일이 실제로 첨부되었는지 확인합니다.
		if (newThumb != null && !newThumb.isEmpty()) {
			log.info("새로운 썸네일이 있어 새 파일 그룹을 생성합니다. DesignID: {}", vo.getDesignId());
			// 1-1. 새로운 썸네일을 업로드하고 새 fileGroupNo를 받습니다.
			MultipartFile[] files = { newThumb };
			long newFileGroupNo = fileService.uploadFiles(files, "thumbnail");

			// 1-2. VO에 새로운 fileGroupNo를 설정합니다.
			vo.setFileGroupNo(newFileGroupNo);
		}

		// 2. 최종적으로 수정된 디자인 정보(이름, JSON 데이터, 파일 그룹 번호)를 DB에 업데이트합니다.
		return designMapper.updateDesign(vo);
	}

	private static String getExt(String name) {
		int idx = (name != null) ? name.lastIndexOf('.') : -1;
		return (idx > -1) ? name.substring(idx + 1) : "";
	}
}