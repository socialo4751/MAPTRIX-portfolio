package kr.or.ddit.user.my.community.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.community.review.mapper.ReviewCommentMapper;
import kr.or.ddit.community.review.mapper.ReviewPostMapper;
import kr.or.ddit.cs.praise.mapper.OrgPraisePostMapper;
import kr.or.ddit.cs.qna.mapper.CsQnaPostMapper;
import kr.or.ddit.user.my.community.mapper.MyActivityMapper;
import kr.or.ddit.user.my.community.service.MyActivityService;
import kr.or.ddit.user.my.community.vo.MyActivityVO2;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MyActivityServiceImpl implements MyActivityService {

    private final MyActivityMapper myActivityMapper;
    private final OrgPraisePostMapper praisePostMapper;
    private final CsQnaPostMapper qnaPostMapper;
    private final ReviewPostMapper reviewPostMapper;
    private final ReviewCommentMapper reviewCommentMapper;

    @Override
    public int getMyActivityCount(String userId) {
        return myActivityMapper.selectMyActivityCount(userId);
    }

    @Override
    public List<MyActivityVO2> getMyActivityList(Map<String, Object> map) {
        return myActivityMapper.selectMyActivityList(map);
    }

    @Override
    @Transactional
    public boolean deleteActivity(String boardType, String activityType, int id) {
        int result = 0;
        if ("post".equals(activityType)) {
            switch (boardType) {
                case "칭찬게시판":
                    // OrgPraisePostMapper에는 Long 타입이므로 캐스팅 필요
                    result = praisePostMapper.markPraiseAsDeleted((long) id);
                    break;
                case "Q&A":
                    qnaPostMapper.markQnaAsDeleted(id);
                    result = 1; // 반환 타입이 void라 성공으로 간주
                    break;
                case "창업후기":
                    result = reviewPostMapper.deletePost(id);
                    break;
            }
        } else if ("comment".equals(activityType)) {
            // 현재 댓글은 창업후기 게시판에만 존재
            if ("창업후기".equals(boardType)) {
                result = reviewCommentMapper.deleteCommentsByPostId(id);
            }
        }
        return result > 0;
    }
    
    @Override
    public String getActivityContent(String boardType, String activityType, int id) {
        // 각 매퍼를 사용하여 원본 내용을 조회하는 로직 (예시)
        // 실제 구현 시에는 각 게시판의 상세 조회 서비스를 재사용하는 것이 더 좋습니다.
        // 여기서는 간단하게 매퍼에서 직접 content만 가져오는 것으로 가정합니다.
        return myActivityMapper.selectActivityContent(boardType, activityType, id);
    }
}