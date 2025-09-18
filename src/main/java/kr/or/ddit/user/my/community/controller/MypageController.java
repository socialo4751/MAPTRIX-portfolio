package kr.or.ddit.user.my.community.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.service.ChatRoomService;
import kr.or.ddit.community.free.service.CodeBizService;
import kr.or.ddit.user.my.community.service.MyActivityService;
import kr.or.ddit.user.my.community.service.MypageService;
import kr.or.ddit.user.my.community.vo.MyActivityVO2;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/post")
@RequiredArgsConstructor
public class MypageController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;
    private final CodeBizService codeBizService;

    private final MypageService mypageService;
    private final MyActivityService myActivityService;

    //커뮤니티 활동 내역 페이지
    @GetMapping("/comm")
    public String showBoardAndChatPage(
            @RequestParam(required = false) Integer postId,
            Model model) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()) {
            model.addAttribute("loginUserId", auth.getName());

            Object p = auth.getPrincipal();
            if (p instanceof UsersVO u) {
                model.addAttribute("loginUser", u);
            }
        }
        return "my/community/boardAndChat";
    }

    // 그 외 게시판 활동내역 페이지
    @GetMapping("/activity")
    public String showMyActivity(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            Model model) {

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            String userId = auth.getName();

            log.info("활동 내역 조회 시작 - userId: {}, currentPage: {}", userId, currentPage);

            int total = myActivityService.getMyActivityCount(userId);
            log.info("이 활동 수: {}", total);

            int size = 10;
            ArticlePage<MyActivityVO2> articlePage = new ArticlePage<>(total, currentPage, size, null, null);

            int startRow = (currentPage - 1) * size + 1;
            int endRow = currentPage * size;

            Map<String, Object> map = new HashMap<>();
            map.put("userId", userId);
            map.put("startRow", startRow);
            map.put("endRow", endRow);

            List<MyActivityVO2> activityList = myActivityService.getMyActivityList(map);
            log.info("조회된 활동 수: {}", activityList != null ? activityList.size() : 0);

            articlePage.setContent(activityList);

            model.addAttribute("articlePage", articlePage);
            model.addAttribute("loginUserId", userId);

            Object p = auth.getPrincipal();
            if (p instanceof UsersVO u) {
                model.addAttribute("loginUser", u);
            }

            log.info("활동 내역 조회 완료");
            return "my/community/myActivity";

        } catch (Exception e) {
            log.error("활동 내역 조회 중 오류 발생", e);
            model.addAttribute("errorMessage", "활동 내역을 불러오는 중 오류가 발생했습니다.");
            return "my/community/myActivity";
        }
    }

    /**
     * 활동 내용 조회 (모달창용)
     */
    @GetMapping("/activity/content")
    @ResponseBody
    public ResponseEntity<String> getActivityContent(
            @RequestParam(required = false) String boardType,
            @RequestParam(required = false) String activityType,
            @RequestParam(required = false) Integer id) {

        try {
            if (boardType == null || activityType == null || id == null) {
                log.error("필수 파라미터 누락 - boardType: {}, activityType: {}, id: {}", boardType, activityType, id);
                return ResponseEntity.badRequest().body("필수 파라미터가 누락되었습니다.");
            }

            String content = myActivityService.getActivityContent(boardType, activityType, id);
            return ResponseEntity.ok(content);
        } catch (Exception e) {
            log.error("활동 내용 조회 실패 - boardType: {}, activityType: {}, id: {}", boardType, activityType, id, e);
            return ResponseEntity.badRequest().body("내용을 불러올 수 없습니다.");
        }
    }

    /**
     * 활동 삭제
     */
    @DeleteMapping("/activity/{boardType}/{activityType}/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteActivity(
            @PathVariable String boardType,
            @PathVariable String activityType,
            @PathVariable int id) {

        Map<String, Object> response = new HashMap<>();

        try {
            boolean success = myActivityService.deleteActivity(boardType, activityType, id);

            if (success) {
                response.put("success", true);
                response.put("message", "삭제되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "삭제에 실패했습니다.");
            }

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("활동 삭제 실패", e);
            response.put("success", false);
            response.put("message", "삭제 중 오류가 발생했습니다.");
            return ResponseEntity.badRequest().body(response);
        }
    }
}