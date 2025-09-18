package kr.or.ddit.community.free.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.mapper.FileMapper;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.community.free.mapper.FreeCommentMapper;
import kr.or.ddit.community.free.mapper.FreePostMapper;
import kr.or.ddit.community.free.service.FreePostService;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FreePostServiceImpl implements FreePostService {

	private final FreePostMapper freePostMapper;
	private final FreeCommentMapper freeCommentMapper;
	private final FileService fileService;

	@Autowired
	public FreePostServiceImpl(FreePostMapper freePostMapper, FileMapper fileMapper,
			FreeCommentMapper freeCommentMapper, FileService fileService) {
		this.freePostMapper = freePostMapper;
		this.freeCommentMapper = freeCommentMapper;
		this.fileService = fileService;
	}

	/**
	 * 특정 업종의 게시글 목록을 페이징 및 검색 조건에 맞춰 조회합니다.
	 */
	@Override
	public List<CommFreePostVO> getPostsByBizCode(String bizCodeId, int currentPage, int size, String keyword) {
		log.info("getPostsByBizCode() 실행 - bizCodeId: {}, currentPage: {}, keyword: {}", bizCodeId, currentPage,
				keyword);
		Map<String, Object> map = new HashMap<>();
		map.put("bizCodeId", bizCodeId);
		map.put("keyword", keyword);
		map.put("startRow", (currentPage - 1) * size + 1);
		map.put("endRow", currentPage * size);
		return freePostMapper.selectPostsByBizCode(map);
	}

	/**
	 * 특정 업종의 전체 게시글 수를 검색 조건에 맞춰 조회합니다.
	 */
	@Override
	public int getPostCountByBizCode(String bizCodeId, String keyword) {
		log.info("getPostCountByBizCode() 실행 - bizCodeId: {}, keyword: {}", bizCodeId, keyword);
		Map<String, Object> map = new HashMap<>();
		map.put("bizCodeId", bizCodeId);
		map.put("keyword", keyword);
		return freePostMapper.countPostsByBizCode(map);
	}

	/**
	 * 특정 게시글의 상세 내용을 조회하고 조회수를 증가시킵니다.
	 */
	@Transactional
	@Override
	public CommFreePostVO getPostByIdWithViewCount(int postId) {
		log.info("getPostByIdWithViewCount() 실행 - postId: {}", postId);
		freePostMapper.incrementViewCount(postId);
		return freePostMapper.selectPostById(postId);
	}
	
	@LogEvent(eventType="CREATE", feature="FREE")
	@Transactional
	@Override
	public void createPost(CommFreePostVO postVO, MultipartFile[] attachments) {
		log.info("createPost() 실행 - postVO: {}, attachment 수: {}", postVO,
				attachments != null ? attachments.length : 0);

		if (postVO.getTitle() == null || postVO.getTitle().trim().isEmpty() || postVO.getContent() == null
				|| postVO.getContent().trim().isEmpty()) {
			log.warn("게시글 제목 또는 내용이 비어있습니다. 작성을 실패합니다. postVO: {}", postVO);
			throw new IllegalArgumentException("게시글 제목과 내용은 필수 입력 항목입니다.");
		}

		if (postVO.getBizCodeId() == null || postVO.getBizCodeId().trim().isEmpty()) {
			log.warn("bizCodeId가 없습니다: {}", postVO);
			throw new IllegalArgumentException("업종 코드(bizCodeId)는 필수입니다.");
		}

		if (postVO.getCatCodeId() == null || postVO.getCatCodeId().trim().isEmpty()) {
			postVO.setCatCodeId(postVO.getBizCodeId());
			log.info("catCodeId를 bizCodeId로 설정: {}", postVO.getBizCodeId());
		}

		if (postVO.getUserId() == null || postVO.getUserId().trim().isEmpty()) {
			log.warn("userId가 없습니다: {}", postVO);
			throw new IllegalArgumentException("사용자 ID는 필수입니다.");
		}

		long fileGroupNo = 0;

		// 첨부파일 배열 중 적어도 하나 이상 유효한 파일이 있는지 확인
		boolean hasValidFile = false;
		if (attachments != null) {
			for (MultipartFile file : attachments) {
				if (file != null && !file.isEmpty()) {
					hasValidFile = true;
					break;
				}
			}
		}

		if (hasValidFile) {
			fileGroupNo = fileService.uploadFiles(attachments, "attachment", fileGroupNo);
			log.info("첨부파일을 위해 {} FileGroupNo 사용 (create)", fileGroupNo);
		}

		postVO.setFileGroupNo((int) fileGroupNo);

		log.info("게시글 삽입 직전 - userId: {}, bizCodeId: {}, catCodeId: {}, title: {}", postVO.getUserId(),
				postVO.getBizCodeId(), postVO.getCatCodeId(), postVO.getTitle());

		freePostMapper.insertPost(postVO);
		log.info("새 게시글 삽입 성공. 생성된 postId: {}", postVO.getPostId());
	}

    @LogEvent(eventType = "UPDATE", feature = "FREE")
    @Transactional
    @Override
    public void updatePost(CommFreePostVO postVO, MultipartFile[] attachments) {
        log.info("updatePost() 실행 - postVO: {}, attachment 수: {}", postVO,
                attachments != null ? attachments.length : 0);

        // ★ 1. 수정 전 원본 게시글 정보 조회 (기존 파일 그룹 번호 확인용)
        CommFreePostVO existingPost = freePostMapper.selectPostById(postVO.getPostId());
        if (existingPost == null) {
            log.warn("수정할 게시글을 찾을 수 없습니다. postId: {}", postVO.getPostId());
            throw new IllegalArgumentException("수정할 게시글을 찾을 수 없습니다.");
        }
        if (!existingPost.getUserId().equals(postVO.getUserId())) {
            log.warn("게시글 수정 권한이 없습니다. postId: {}, 요청 userId: {}", postVO.getPostId(), postVO.getUserId());
            throw new IllegalAccessError("게시글 수정 권한이 없습니다.");
        }
        
        // ★ 2. 새로운 첨부 파일이 있는지 확인
        boolean hasNewFiles = false;
        if (attachments != null) {
            for (MultipartFile file : attachments) {
                if (file != null && !file.isEmpty()) {
                    hasNewFiles = true;
                    break;
                }
            }
        }

        if (hasNewFiles) {
            // ★ 3-1. 새 파일이 있으면, 항상 새로운 파일 그룹을 생성 (세 번째 인자로 0L 전달)
            long newFileGroupNo = fileService.uploadFiles(attachments, "attachment", 0L);
            postVO.setFileGroupNo((int) newFileGroupNo);
            log.info("새 첨부파일 저장 완료. 사용된 fileGroupNo: {}", newFileGroupNo);
        } else {
            // ★ 3-2. 새 파일이 없으면, 기존 파일 그룹 번호를 그대로 유지
            postVO.setFileGroupNo(existingPost.getFileGroupNo());
        }
        
        // ★ 기존 파일 삭제 로직(fileService.deleteFilesByGroupNo)은 모두 제거되었습니다.

        if (postVO.getCatCodeId() == null || postVO.getCatCodeId().trim().isEmpty()) {
            postVO.setCatCodeId(postVO.getBizCodeId());
        }

        int result = freePostMapper.updatePost(postVO);
        if (result == 0) {
            log.error("게시글 업데이트 실패: DB 반영 안됨. postVO: {}", postVO);
            throw new RuntimeException("게시글 수정 실패: 데이터베이스 반영 오류.");
        }
        log.info("게시글 {} 수정 성공", postVO.getPostId());
    }


    /**
     * 특정 게시글을 삭제합니다. (논리적 삭제)
     * ★정책 변경: 게시글과 댓글의 상태만 변경하고, 연결된 파일 정보는 삭제하지 않습니다.
     */
    @LogEvent(eventType = "DELETE", feature = "FREE")
    @Transactional
    @Override
    public void deletePost(int postId, String currentUserId, String userRole) throws IllegalAccessException {
        log.info("deletePost() 실행 - postId: {}, userId: {}, userRole: {}", postId, currentUserId, userRole);

        // 1) 게시글 존재 여부 확인
        CommFreePostVO existingPost = freePostMapper.selectPostById(postId);
        if (existingPost == null) {
            throw new IllegalArgumentException("삭제할 게시글을 찾을 수 없습니다.");
        }

        // 2) 권한 확인 (작성자 또는 관리자)
        boolean isAuthor = Objects.equals(existingPost.getUserId(), currentUserId);
        boolean isAdmin = userRole != null && userRole.toUpperCase().contains("ADMIN"); // ROLE_ADMIN 대응
        if (!isAuthor && !isAdmin) {
            throw new IllegalAccessException("게시글 삭제 권한이 없습니다.");
        }

        // 3) 댓글 소프트 삭제
        int deletedComments = freeCommentMapper.deleteCommentsByPostId(postId);
        log.debug("deletePost() - 소프트 삭제된 댓글 수: {}", deletedComments);

        // ★ 4) 첨부파일 삭제 로직 완전 삭제
        // if (fileGroupNo > 0) { ... } 부분 제거

        // 5) 게시글 소프트 삭제
        int updated = freePostMapper.softDeletePostById(postId);
        if (updated != 1) {
            throw new RuntimeException("게시글 삭제 실패: 데이터베이스 반영 오류.");
        }

        log.info("deletePost() 완료 - postId: {}, 댓글 {}건 소프트 삭제, 게시글 소프트 삭제 처리", postId, deletedComments);
    }
	
	@Override
    public CommFreePostVO getLatestFreePost() {
        return freePostMapper.selectLatestFreePost();
    }
}