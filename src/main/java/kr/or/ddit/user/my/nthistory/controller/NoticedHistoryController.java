package kr.or.ddit.user.my.nthistory.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

// ArticlePage와 UserNotifiedVO, MyNtHistoryVO, MyNtHistoryService를 임포트합니다.
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import kr.or.ddit.user.my.nthistory.service.MyNtHistoryService;
import kr.or.ddit.user.my.nthistory.vo.MyNtHistoryVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/my/nt")
@RequiredArgsConstructor // final 필드를 위한 생성자 자동 주입
public class NoticedHistoryController {

    // 이전에 생성한 MyNtHistoryService를 주입받습니다.
    private final MyNtHistoryService myNtHistoryService;

    /**
     * 마이페이지 - 알림 내역 조회
     * @param currentPage 현재 페이지 번호
     * @param startDate 검색 시작일
     * @param endDate 검색 종료일
     * @param model View로 데이터를 전달하기 위한 객체
     * @return 뷰 이름
     */
    @GetMapping("/history")
    public String myNotificationHistory(
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "startDate", required = false) String startDate,
            @RequestParam(value = "endDate", required = false) String endDate,
            Model model) {

        // 1. 현재 로그인한 사용자 정보 조회
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName();

        // 2. 검색 및 페이징을 위한 VO 객체 생성 및 데이터 설정
        MyNtHistoryVO searchVO = new MyNtHistoryVO();
        searchVO.setCurrentPage(currentPage);
        searchVO.setStartDate(startDate);
        searchVO.setEndDate(endDate);
        searchVO.setUserId(userId);

        // 3. 서비스를 호출하여 알림 내역 조회
        ArticlePage<UserNotifiedVO> articlePage = this.myNtHistoryService.getMyNotificationHistory(searchVO);
        
        // 4. ArticlePage 객체에 페이징 HTML 생성을 위한 URL 설정
        // 이 URL을 기반으로 ArticlePage 내부에서 페이징 링크가 생성됩니다.
        articlePage.setUrl("/my/nt/history");

        // 5. Model에 데이터 추가
        model.addAttribute("articlePage", articlePage);
        model.addAttribute("startDate", startDate); // 검색어 유지를 위해 추가
        model.addAttribute("endDate", endDate);     // 검색어 유지를 위해 추가

        // 6. JSP 경로 반환
        return "my/noticedHistory/ntHistory";
    }
}