package kr.or.ddit.admin.users.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.util.StringUtils;

import java.nio.charset.StandardCharsets;

import kr.or.ddit.admin.users.vo.UsersHistoryVO;
import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.user.signin.service.UserService;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@RequestMapping("/admin/users")
@Controller
public class AdminUserController {

    @Autowired
    private UserService userService;

    @Autowired
    private CodeService codeService;

    @GetMapping
    public String usersList(Model model,
                            @RequestParam(value = "searchKeyword", required = false) String searchKeyword,
                            @RequestParam(value = "searchType", required = false) String searchType,
                            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage) {

        model.addAttribute("userStatusList", codeService.getCodeDetailList("USERSTATUS"));

        Map<String, Object> paramMap = new HashMap<>();
        if (searchKeyword != null && !searchKeyword.isEmpty()) paramMap.put("searchKeyword", searchKeyword);
        if (searchType != null && !searchType.isEmpty()) paramMap.put("searchType", searchType);

        int size = 10;
        int total = userService.getUsersCount(paramMap);

        paramMap.put("startRow", (currentPage - 1) * size + 1);
        paramMap.put("endRow", currentPage * size);

        List<UsersVO> usersList = userService.getUsersList(paramMap);

        Map<String, Object> summaryParam = new HashMap<>();
        if (searchKeyword != null && !searchKeyword.isEmpty()) summaryParam.put("searchKeyword", searchKeyword);
        Map<String, Object> statusSummary = userService.getUserStatusSummary(summaryParam);
        model.addAttribute("statusSummary", statusSummary);

        // ArticlePage 객체 생성 시 searchKeyword와 searchType을 전달합니다.
        ArticlePage<UsersVO> page =
                new ArticlePage<>(total, currentPage, size, usersList, searchKeyword, searchType);

        // ▼▼▼▼▼ [수정된 부분] ▼▼▼▼▼
        // ArticlePage가 내부적으로 파라미터를 처리하므로, 기본 URL 경로만 설정해줍니다.
        page.setUrl("/admin/users");
        // ▲▲▲▲▲ [수정된 부분] ▲▲▲▲▲

        model.addAttribute("usersList", usersList);
        model.addAttribute("articlePage", page);

        return "admin/user/userList";
    }


    /**
     * [GET] 특정 회원의 상세 정보 및 상태 변경 이력을 조회하는 API
     * URL: /admin/users/api/{userId}
     *
     * @param userId 조회할 회원의 ID
     * @return 회원 정보 (UsersVO)와 상태 변경 이력 (List<UsersHistoryVO>)을 담은 JSON 응답
     */
    @GetMapping("/api/{userId:.+}") // AJAX 요청을 위한 API 엔드포인트
    @ResponseBody // JSON 형태로 응답하기 위해 사용
    public ResponseEntity<Map<String, Object>> getUserDetails(@PathVariable String userId) {
        log.info("AdminUserController - getUserDetails 호출: userId={}", userId);
        Map<String, Object> response = new HashMap<>();
        try {
            // 1. 회원 정보 조회
            UsersVO user = userService.getUserDetail(userId); // ⭐ UserService의 getUserDetail 메서드 사용

            if (user == null) {
                response.put("success", false);
                response.put("message", "회원을 찾을 수 없습니다.");
                return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
            }

            // 2. 해당 회원의 상태 변경 이력 조회
            // UsersHistoryVO는 상태 변경 이력 정보를 담는 VO
            List<UsersHistoryVO> userHistory = userService.getUserHistoryList(userId); // ⭐ getUserHistoryList 메서드 사용

            // [추가] ▼ 정지 기간 코드 목록을 조회합니다.
            List<CodeDetailVO> suspensionDays = codeService.getCodeDetailList("SUSDAYSTAG");

            response.put("success", true);
            response.put("user", user); // 클라이언트에서 'response.user'로 접근
            response.put("suspensionHistory", userHistory); // ⭐ 이름은 suspensionHistory로 유지하여 프론트엔드 변경 최소화
            response.put("suspensionDays", suspensionDays); // [추가] 조회된 목록을 응답에 포함

            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            log.error("회원 정보를 불러오는 중 오류 발생: userId={}", userId, e);
            response.put("success", false);
            response.put("message", "회원 정보를 불러오는데 실패했습니다: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * [POST] 회원의 상태를 변경 (활성화/정지)하는 API
     * URL: /admin/users/api/updateStatus
     *
     * @param payload 클라이언트에서 전송된 JSON 데이터 (userId, newStatus, suspensionReason, suspensionPeriod)
     * @return 처리 결과 (성공 여부, 메시지)를 담은 JSON 응답
     */
    @PostMapping("/api/updateStatus") // AJAX 요청을 위한 API 엔드포인트
    @ResponseBody // JSON 형태로 응답하기 위해 사용
    public ResponseEntity<Map<String, Object>> updateUserStatus(@RequestBody Map<String, Object> payload) {
        log.info("AdminUserController - updateUserStatus 호출: payload={}", payload);
        Map<String, Object> response = new HashMap<>();
        try {
            String userId = (String) payload.get("userId");
            String newStatus = (String) payload.get("newStatus"); // "Y" 또는 "N"
            String suspensionReason = (String) payload.get("suspensionReason"); // 'N'일 경우 정지 사유
            // ⭐ 새로 추가된 파라미터: suspensionPeriod (정지 기간)
            Integer suspensionPeriod = null;
            if (payload.containsKey("suspensionPeriod")) {
                Object periodObj = payload.get("suspensionPeriod");

                // [수정] ▼ 'SUS' 접두사를 제거하고 숫자로 변환
                if (periodObj instanceof String && !((String) periodObj).isEmpty()) {
                    try {
                        String periodCode = (String) periodObj; // 예: "SUS07"
                        // "SUS"를 제거하고 남은 숫자 부분만 파싱합니다.
                        suspensionPeriod = Integer.parseInt(periodCode.replaceAll("SUS", ""));
                    } catch (NumberFormatException e) {
                        log.warn("suspensionPeriod 코드에서 숫자를 파싱할 수 없습니다: {}", periodObj);
                    }
                }
            }


            // 현재 로그인한 관리자 ID 가져오기
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String changedBy = "UNKNOWN"; // 기본값
            if (authentication != null && authentication.getPrincipal() instanceof UserDetails) {
                changedBy = ((UserDetails) authentication.getPrincipal()).getUsername();
            } else if (authentication != null) {
                // UserDetails가 아닌 다른 Principal 타입일 경우
                changedBy = authentication.getName();
            }
            log.info("상태 변경 처리 관리자 ID: {}", changedBy);

            // UserService의 updateUserStatus 메서드 호출
            // 이 메서드는 Users 테이블의 enabled 업데이트, UsersHistory에 이력 삽입을 담당
            // ⭐ suspensionPeriod 파라미터 추가
            boolean isUpdated = userService.updateUserStatus(userId, newStatus, suspensionReason, changedBy, suspensionPeriod);

            if (isUpdated) {
                response.put("success", true);
                response.put("message", "회원 상태가 성공적으로 변경되었습니다.");
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("success", false);
                response.put("message", "회원 상태 변경에 실패했습니다. (내부 로직 오류 또는 회원을 찾을 수 없음)");
                return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST); // 400 Bad Request
            }

        } catch (Exception e) {
            log.error("회원 상태 변경 중 오류 발생: payload={}", payload, e);
            response.put("success", false);
            response.put("message", "회원 상태 변경 중 오류가 발생했습니다: " + e.getMessage());
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}