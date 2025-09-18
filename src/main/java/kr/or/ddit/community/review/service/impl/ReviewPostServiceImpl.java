package kr.or.ddit.community.review.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.community.review.mapper.ReviewPostMapper;
import kr.or.ddit.community.review.service.ReviewPostService;
import kr.or.ddit.community.review.vo.CommReviewPostVO;

@Service
public class ReviewPostServiceImpl implements ReviewPostService {

    private final ReviewPostMapper postMapper;
    
    @Autowired
    private FileService fileService; // FileService 주입 필요

    @Autowired
    public ReviewPostServiceImpl(ReviewPostMapper postMapper) {
        this.postMapper = postMapper;
    }

    @LogEvent(eventType="CREATE", feature="REVIEW")
    @Override
    public boolean createPost(CommReviewPostVO postVO) {
        // 1. 유효성 검사
        if (postVO.getTitle() == null || postVO.getContent() == null) {
            return false;
        }

        // 2. 파일 저장 관련 처리 - VO에 attachedFiles가 없으므로
        //    첨부 파일 처리는 컨트롤러에서 이미 fileGroupNo 세팅되어 넘어온다고 가정
        //    별도 파일 저장 처리 없으면 아래 코드는 삭제

        // 3. 게시글 저장
        int result = postMapper.insertPost(postVO);
        return result > 0;
    }

    @Override
    public CommReviewPostVO getPost(int postId) {
        CommReviewPostVO post = postMapper.selectPostById(postId);
        if (post != null) {
            postMapper.incrementViewCount(postId);
        }
        return post;
    }

    @Override
    public List<CommReviewPostVO> getAllPosts() {
        return postMapper.selectAllPosts();
    }

    @LogEvent(eventType="UPDATE", feature="REVIEW")
    @Override
    public boolean modifyPost(CommReviewPostVO postVO) {
        if (postVO.getTitle() == null || postVO.getTitle().isEmpty() ||
            postVO.getContent() == null || postVO.getContent().isEmpty()) {
            return false;
        }
        int result = postMapper.updatePost(postVO);
        return result > 0;
    }

    @LogEvent(eventType="DELETE", feature="REVIEW")
    @Override
    public boolean removePost(int postId) {
        int result = postMapper.deletePost(postId);
        return result > 0;
    }

    @Override
    public int getReviewPostCount(Map<String, Object> map) {
        return postMapper.selectPostCount(map);
    }

    @Override
    public List<CommReviewPostVO> getReviewPostList(Map<String, Object> map) {
        return postMapper.selectPostsByPage(map);
    }
}
