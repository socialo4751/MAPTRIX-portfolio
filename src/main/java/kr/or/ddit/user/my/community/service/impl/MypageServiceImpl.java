package kr.or.ddit.user.my.community.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.community.free.mapper.FreeCommentMapper;
import kr.or.ddit.community.free.mapper.FreePostMapper;
import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;
import kr.or.ddit.community.news.mapper.NewsPostMapper;
import kr.or.ddit.community.review.mapper.ReviewCommentMapper;
import kr.or.ddit.community.review.mapper.ReviewPostMapper;
import kr.or.ddit.user.my.community.mapper.MypageMapper;
import kr.or.ddit.user.my.community.service.MypageService;
import kr.or.ddit.user.my.community.vo.MyActivityVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MypageServiceImpl implements MypageService {

    private final FreePostMapper freePostMapper;
    private final MypageMapper mypageMapper;
    private final FreeCommentMapper freeCommentMapper;
    private final ReviewPostMapper reviewPostMapper;
    private final ReviewCommentMapper reviewCommentMapper;
    private final NewsPostMapper newsPostMapper;
    
    /**
     * 특정 업종의 게시글 목록을 페이징 및 검색 조건에 맞춰 조회합니다.
     */
    @Override
    public List<CommFreePostVO> getPostsByBizCode(String bizCodeId, int currentPage, int size, String keyword) {
        log.info("getPostsByBizCode() 실행 - bizCodeId: {}, currentPage: {}, keyword: {}", bizCodeId, currentPage, keyword);
        Map<String, Object> map = new HashMap<>();
        map.put("userId", bizCodeId);
        map.put("keyword", keyword);
        map.put("startRow", (currentPage - 1) * size + 1);
        map.put("endRow", currentPage * size);
        return mypageMapper.selectPostsByBizCode(map);
    }
    
    /**
     * 특정 업종의 전체 게시글 수를 검색 조건에 맞춰 조회합니다.
     */
    @Override
    public int getPostCountByBizCode(String bizCodeId, String keyword) {
        log.info("getPostCountByBizCode() 실행 - bizCodeId: {}, keyword: {}", bizCodeId, keyword);
        Map<String, Object> map = new HashMap<>();
        map.put("userId", bizCodeId);
        map.put("keyword", keyword);
        return mypageMapper.countPostsByBizCode(map);
    }

    @Override
    public Map<String, Integer> getActivitySummary(String userId) {
        Map<String, Integer> summary = new HashMap<>();
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);

        // 이 게시글 수
        int totalPosts = getPostCount(params);
        summary.put("totalPosts", totalPosts);
        
        // 이 댓글 수  
        int totalComments = getCommentCount(params);
        summary.put("totalComments", totalComments);

        // 이 활동 수
        summary.put("totalActivities", totalPosts + totalComments);

        return summary;
    }

    @Override
    public ArticlePage<MyActivityVO> getActivityList(String userId, int currentPage, int size, String activityType) {
        List<MyActivityVO> allActivities = new ArrayList<>();

        // 활동 유형에 따라 조건부 조회
        if (activityType == null || "게시글".equals(activityType)) {
            // 자유게시판 게시글
            freePostMapper.selectPostsByUserId(Map.of("userId", userId)).forEach(p -> {
                MyActivityVO activity = new MyActivityVO();
                activity.setActivityType("게시글");
                activity.setBoardType("자유게시판");
                activity.setTitle(p.getTitle());
                activity.setCreatedAt(p.getCreatedAt());

                String bizCodeId = p.getBizCodeId();
                if (bizCodeId != null && !bizCodeId.isEmpty()) {
                    activity.setUrl("/comm/free/" + bizCodeId + "?postId=" + p.getPostId());
                } else {
                    activity.setUrl("/comm/free/list?postId=" + p.getPostId());
                }
                allActivities.add(activity);
            });
            // 후기게시판 게시글
            reviewPostMapper.selectPostsByUserId(userId).forEach(p -> {
                MyActivityVO activity = new MyActivityVO();
                activity.setActivityType("게시글");
                activity.setBoardType("후기게시판");
                activity.setTitle(p.getTitle());
                activity.setCreatedAt(p.getCreatedAt());
                activity.setUrl("/comm/review/detail?postId=" + p.getPostId());
                allActivities.add(activity);
            });
        }

        if (activityType == null || "댓글".equals(activityType)) {
            // 자유게시판 댓글
            freeCommentMapper.selectCommentsByUserId(userId).forEach(c -> {
                MyActivityVO activity = new MyActivityVO();
                activity.setActivityType("댓글");
                activity.setBoardType("자유게시판");
                activity.setTitle(c.getContent());
                activity.setCreatedAt(c.getCreatedAt());
                activity.setUrl("/comm/free/detail?postId=" + c.getPostId());
                allActivities.add(activity);
            });
            // 후기게시판 댓글
            reviewCommentMapper.selectCommentsByUserId(userId).forEach(c -> {
                MyActivityVO activity = new MyActivityVO();
                activity.setActivityType("댓글");
                activity.setBoardType("후기게시판");
                activity.setTitle(c.getContent());
                activity.setCreatedAt(c.getCreatedAt());
                activity.setUrl("/comm/review/detail?postId=" + c.getPostId() + "#comment-" + c.getCommentId());
                allActivities.add(activity);
            });
        }

        // 2. 전체 활동을 최신순으로 정렬
        allActivities.sort(Comparator.comparing(MyActivityVO::getCreatedAt).reversed());
        
        // 3. 수동 페이징 처리
        int total = allActivities.size();
        int start = (currentPage - 1) * size;
        int end = Math.min(start + size, total);
        List<MyActivityVO> pagedActivities = (start > total) ? Collections.emptyList() : allActivities.subList(start, end);
        
        // rnum 설정 (화면에 보여줄 번호)
        for(int i=0; i < pagedActivities.size(); i++) {
            pagedActivities.get(i).setRnum(total - (start + i));
        }

        return new ArticlePage<>(total, currentPage, size, pagedActivities, "", "");
    }
    
    // ⭐⭐ 기존 메서드들을 Map 파라미터로 변경 ⭐⭐
    
    @Override
    public int getPostCount(Map<String, Object> params) {
        return mypageMapper.countPostsByUserId(params);
    }
    
    @Override
    public int getCommentCount(Map<String, Object> params) {
        return mypageMapper.countCommentsByUserId(params);
    }
    
    @Override
    public List<CommFreePostVO> getMyPosts(Map<String, Object> params) {
        // 페이징 파라미터 설정
        if (params.get("currentPage") != null && params.get("size") != null) {
            int currentPage = (Integer) params.get("currentPage");
            int size = (Integer) params.get("size");
            params.put("startRow", (currentPage - 1) * size + 1);
            params.put("endRow", currentPage * size);
        }
        return mypageMapper.selectPostsByUserId(params);
    }

    @Override
    public List<CommFreeCommentVO> getMyComments(Map<String, Object> params) {
        // 페이징 파라미터 설정
        if (params.get("currentPage") != null && params.get("size") != null) {
            int currentPage = (Integer) params.get("currentPage");
            int size = (Integer) params.get("size");
            params.put("startRow", (currentPage - 1) * size + 1);
            params.put("endRow", currentPage * size);
        }
        return mypageMapper.selectCommentsByUserId(params);
    }
    
    // ⭐⭐ 통합 검색을 위한 새로운 메서드들 ⭐⭐
    
    @Override
    public int getAllActivitiesCount(Map<String, Object> params) {
        return mypageMapper.countAllActivitiesByUserId(params);
    }
    
    @Override
    public List<Object> getAllActivitiesWithSearch(Map<String, Object> params) {
        // 페이징 파라미터 설정
        if (params.get("currentPage") != null && params.get("size") != null) {
            int currentPage = (Integer) params.get("currentPage");
            int size = (Integer) params.get("size");
            params.put("startRow", (currentPage - 1) * size + 1);
            params.put("endRow", currentPage * size);
        }
        
        // 통합 검색 결과 조회
        List<Map<String, Object>> rawResults = mypageMapper.selectAllActivitiesByUserId(params);
        List<Object> activities = new ArrayList<>();
        
        for (Map<String, Object> row : rawResults) {
            String activityType = (String) row.get("ACTIVITY_TYPE");
            
            if ("POST".equals(activityType)) {
                // 게시글 객체 생성
                CommFreePostVO post = new CommFreePostVO();
                post.setPostId(((Number) row.get("ID")).intValue());
                post.setUserId((String) row.get("USER_ID"));
                post.setCatCodeId((String) row.get("CAT_CODE_ID"));
                post.setTitle((String) row.get("TITLE"));
                post.setContent((String) row.get("CONTENT"));
                post.setViewCount(row.get("VIEW_COUNT") != null ? ((Number) row.get("VIEW_COUNT")).intValue() : 0);
                post.setCreatedAt((java.util.Date) row.get("CREATED_AT"));
                post.setBizName((String) row.get("BIZ_NAME"));
                activities.add(post);
                
            } else if ("COMMENT".equals(activityType)) {
                // 댓글 객체 생성
                CommFreeCommentVO comment = new CommFreeCommentVO();
                comment.setCommentId(((Number) row.get("ID")).intValue());
                comment.setPostId(row.get("POST_ID") != null ? ((Number) row.get("POST_ID")).intValue() : 0);
                comment.setPostId2(row.get("POST_ID2") != null ? ((Number) row.get("POST_ID2")).intValue() : 0);
                comment.setUserId((String) row.get("USER_ID"));
                comment.setContent((String) row.get("CONTENT"));
                comment.setCreatedAt((java.util.Date) row.get("CREATED_AT"));
                comment.setBizName((String) row.get("BIZ_NAME"));
                activities.add(comment);
            }
        }
        
        return activities;
    }
}