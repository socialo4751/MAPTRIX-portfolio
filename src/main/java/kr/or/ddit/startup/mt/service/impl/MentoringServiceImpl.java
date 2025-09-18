package kr.or.ddit.startup.mt.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.startup.mt.mapper.MentoringMapper;
import kr.or.ddit.startup.mt.service.MentoringService;
import kr.or.ddit.startup.mt.vo.SuMentPostVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor // final 필드를 주입받는 생성자를 만들어주는 Lombok 어노테이션
public class MentoringServiceImpl implements MentoringService {

    private final MentoringMapper mentoringMapper;
    private final FileService fileService;

    // 게시글 리스트 목록 조회
    @Override
    public List<SuMentPostVO> retrieveMentoringPostList() {
        List<SuMentPostVO> postList = mentoringMapper.selectMentoringPostList();    
        return postList;
    }
    
    // 첨부파일
    @Transactional
    @Override
    public int createMentoringPost(SuMentPostVO post) {
        // 1. 첨부파일 처리 (대표 이미지)
        MultipartFile imageFile = post.getMainImageFile();
        if (imageFile != null && !imageFile.isEmpty()) {
            long fileGroupNo = fileService.uploadFiles(new MultipartFile[]{imageFile}, "thumbnail");
            post.setFileGroupNo(fileGroupNo);
        } else {
            post.setFileGroupNo(0);
        }

        // 2. 파일 그룹 번호가 세팅된 post 객체를 DB에 저장
        int rowcnt = mentoringMapper.createMentoringPost(post);
        return rowcnt;
    }
    
    // 게시글 상세보기
    @Override
    public SuMentPostVO retrieveMentoringPost(@Param("POST_ID") long mentoringId) { // postId -> mentoringId로 변경
        SuMentPostVO post = mentoringMapper.retrieveMentoringPost(mentoringId); // mentoringId 전달      
        return post;
    }

    // 전체 게시물 수를 조회
	@Override
	public int selectTotalCount(Map<String, Object> paramMap) {
        return this.mentoringMapper.selectTotalCount(paramMap);
	}
	
	// 현재 페이지의 게시물 목록을 조회
	@Override
	public List<SuMentPostVO> selectMentoringPostList(Map<String, Object> paramMap) {
        return this.mentoringMapper.selectMentoringPostList(paramMap);
	}
	
	// detail에서 이전 / 다음 게시글 정보 조회
	@Override
	public SuMentPostVO selectPrevPost(long postId) {
	    return mentoringMapper.selectPrevPost(postId);
	}
	@Override
	public SuMentPostVO selectNextPost(long postId) {
	    return mentoringMapper.selectNextPost(postId);
	}
	
	// 조회수 1 증가
	@Override
	public void increaseViewCount(long postId) {
	    mentoringMapper.increaseViewCount(postId);
	}
	
    // 게시글 수정
    @Transactional
    @Override
    public int modifyMentoringPost(SuMentPostVO post) {  	
        // 1. 첨부파일 처리 (대표 이미지)
        MultipartFile imageFile = post.getMainImageFile();
        if (imageFile != null && !imageFile.isEmpty()) {
        	
            // 새로운 썸네일을 업로드하고 새 fileGroupNo를 받습니다.
            long newFileGroupNo = fileService.uploadFiles(new MultipartFile[]{imageFile}, "thumbnail");
            // VO에 새로운 fileGroupNo를 설정합니다.
            post.setFileGroupNo(newFileGroupNo);
        }

        // 2. 파일 그룹 번호가 세팅된 post 객체로 DB 업데이트
        int rowcnt = mentoringMapper.updateMentoringPost(post);
        return rowcnt;
    }

    // 게시글 삭제
    @Override
    public int removeMentoringPost(long postId) {
        return mentoringMapper.deleteMentoringPost(postId);
    }

}