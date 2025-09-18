package kr.or.ddit.startup.design.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.startup.design.service.DesignService;
import kr.or.ddit.startup.design.vo.DesignLikedPostVO;
import kr.or.ddit.startup.design.vo.SuShowDesignVO;
import kr.or.ddit.startup.show.mapper.ShowDesignMapper;
import kr.or.ddit.startup.show.service.ShowDesignService;
import kr.or.ddit.startup.show.vo.SuShowPostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/start-up/design")
public class DesignController {

	@Autowired
    DesignService designService;
    
	@Autowired
    ObjectMapper objectMapper;
    
	@Autowired
    TokenProvider tokenProvider;
	
	@Autowired
	ShowDesignService showDesignService;

    // application.properties에서 리액트 앱 주소를 주입받습니다.
    @Value("${frontend.url}")
    private String simulatorUrl;

    // JWT 쿠키의 유효시간 (초 단위, 예: 1시간)
    private final long accessTokenValidityInSeconds = 3600;

    @Autowired
    public DesignController(DesignService designService, ObjectMapper objectMapper, TokenProvider tokenProvider) {
        this.designService = designService;
        this.objectMapper = objectMapper;
        this.tokenProvider = tokenProvider;
    }

    // 도면 저장을 위한 API 엔드포인트
    @PostMapping("/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveDesign(
            @Valid @RequestBody SuShowDesignVO suShowDesignVO,
            Authentication authentication) {
        
        Map<String, Object> response = new HashMap<>();

        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        try {
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            suShowDesignVO.setUserId(customUser.getUsersVO().getUserId());

            if (suShowDesignVO.getDesignData() != null && !(suShowDesignVO.getDesignData() instanceof String)) {
                String designDataJson = objectMapper.writeValueAsString(suShowDesignVO.getDesignData());
                suShowDesignVO.setDesignData(designDataJson);
            }

            designService.insertDesign(suShowDesignVO); // FileGroup 생성 및 Design 저장이 모두 이 안에서 처리

            response.put("success", true);
            response.put("message", "도면이 성공적으로 저장되었습니다.");
            response.put("designId", suShowDesignVO.getDesignId());
            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            log.error("도면 저장 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류로 인해 도면 저장에 실패했습니다.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
	 // DesignController.java
	 // 2D 시뮬레이터로 보내는 인증 게이트웨이 역할 (HttpOnly 쿠키 방식)
	 @GetMapping("/go-to-simulator")
	 public String goToSimulator(HttpServletResponse response) {
	     // 1. SecurityContextHolder에서 직접 인증 정보를 가져옵니다.
	     Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	
	     // 2. 사용자가 로그인 상태인지 확인합니다.
	     if (authentication == null || "anonymousUser".equals(authentication.getName())) {
	         return "redirect:/login"; // 로그인 페이지 경로
	     }
	
	     // 3. TokenProvider를 사용해 이 사용자를 위한 JWT를 생성합니다.
	     String jwt = tokenProvider.createAccessToken(authentication);
	
	     // 4. HttpOnly 쿠키 생성
	     Cookie accessTokenCookie = new Cookie("accessToken", jwt);
	     accessTokenCookie.setHttpOnly(true);      // 자바스크립트 접근 방지 (XSS 방어)
	     accessTokenCookie.setPath("/");           // 모든 경로에서 쿠키 사용
	     accessTokenCookie.setMaxAge((int) accessTokenValidityInSeconds); // 쿠키 만료 시간 설정
	     // accessTokenCookie.setSecure(true);     // HTTPS 환경에서만 쿠키 전송 (실서버 배포 시 활성화 권장)
	
	     // 5. 응답 헤더에 쿠키 추가
	     response.addCookie(accessTokenCookie);
	
	     // 6. URL에 토큰 없이 React 앱으로 리다이렉트 (경로 수정됨)
	     return "redirect:" + simulatorUrl + "/simulator";
	 }
	 
	// 마이페이지 도면 관리 페이지 요청 처리
	 @GetMapping("/myDesignPage")
	 public String myDesignPage(
	         Model model,
	         Authentication authentication,
	         @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage) {
	     
	     // 1. 로그인 정보 확인 및 유저 ID 추출
	     if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
	         return "redirect:/login"; // 로그인 안했으면 로그인 페이지로
	     }
	     CustomUser customUser = (CustomUser) authentication.getPrincipal();
	     String userId = customUser.getUsersVO().getUserId();

	     // 1. '내 프로젝트' 목록 (페이지네이션 적용)
	     ArticlePage<SuShowDesignVO> myDesignsPage = designService.getMyPageData(userId, currentPage);
	     
	     // 2. '좋아요한 게시글' 목록을 별도로 조회합니다.
	     List<DesignLikedPostVO> likedPosts = designService.getLikedPosts(userId);

	     // 3. 두 데이터를 모두 모델에 담습니다.
	     model.addAttribute("articlePage", myDesignsPage);
	     model.addAttribute("likedPosts", likedPosts); 

	     return "startup/design/myDesignPage";
	 }
	
    // 도면 수정을 위해 시뮬레이터로 이동하는 메소드
    @GetMapping("/edit")
    public String editDesign(
            HttpServletResponse response,
            @RequestParam("designId") int designId) { // 1. 수정할 designId를 파라미터로 받음

        // 2. 기존 goToSimulator와 동일하게 인증 처리 및 JWT 쿠키 생성
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || "anonymousUser".equals(authentication.getName())) {
            return "redirect:/login";
        }

        String jwt = tokenProvider.createAccessToken(authentication);

        Cookie accessTokenCookie = new Cookie("accessToken", jwt);
        accessTokenCookie.setHttpOnly(true);
      	accessTokenCookie.setPath("/");
        accessTokenCookie.setMaxAge((int) accessTokenValidityInSeconds);
        // accessTokenCookie.setSecure(true);

        response.addCookie(accessTokenCookie);

        // 3. 리다이렉트 URL에 designId를 쿼리 파라미터로 추가하여 전달
        return "redirect:" + simulatorUrl + "/simulator?designId=" + designId;
    }
    
 // ID로 디자인 데이터를 조회하는 API 엔드포인트
    @GetMapping("/{designId}")
    @ResponseBody
    public ResponseEntity<SuShowDesignVO> getDesignData(@PathVariable("designId") int designId) {
        log.info("getDesignData API 호출됨. designId: {}", designId);
        SuShowDesignVO design = designService.getDesignById(designId);

        if (design != null) {
            // 이 로그를 추가해서 서버에서 객체가 어떻게 생겼는지 확인
            try {
                String designJson = new ObjectMapper().writeValueAsString(design);
                log.info("React로 보내기 직전의 design 객체 JSON: {}", designJson);
            } catch (Exception e) {
                log.error("JSON 변환 중 에러", e);
            }
            
            log.info("DB에서 디자인 데이터 조회 성공. designName: {}", design.getDesignName());
            
            // ✨ 수정: designData가 null이 아닐 때만 로그를 찍도록 변경
            if (design.getDesignData() != null) {
                log.info("디자인 데이터 내용(일부): {}", design.getDesignData().substring(0, Math.min(100, design.getDesignData().length())));
            } else {
                log.warn("designId {}에 대한 designData 필드가 null입니다.", designId);
            }
            
            return new ResponseEntity<>(design, HttpStatus.OK);
        } else {
            log.warn("ID {}에 해당하는 디자인 데이터를 찾을 수 없음.", designId);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
    
    // 관리자의 디자인 목록 조회
    @GetMapping("/api/admin-designs")
    @ResponseBody
    public ResponseEntity<List<SuShowDesignVO>> getAdminDesigns() {
        String adminId = "admin@test.com"; // 관리자 ID를 직접 지정
        List<SuShowDesignVO> adminDesigns = designService.getDesignsByUserId(adminId);
        return new ResponseEntity<>(adminDesigns, HttpStatus.OK);
    }
    
    
    // React에서 호출할 '내 디자인 목록' 조회 API
    @GetMapping("/api/my-designs")
    @ResponseBody 
    public ResponseEntity<List<SuShowDesignVO>> getMyDesignsApi(Authentication authentication) {
        // 1. 로그인 정보 확인
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String userId = customUser.getUsersVO().getUserId();

        // ★★★ 2. 새로 만든 서비스 메소드를 호출합니다. ★★★
        List<SuShowDesignVO> myDesigns = designService.getAllMyDesigns(userId);

        // 3. 조회된 디자인 목록을 200 OK 상태와 함께 반환
        return new ResponseEntity<>(myDesigns, HttpStatus.OK);
    }

 // GET /startUp/design/main
    @GetMapping("/main")
    public String storePlannerMain(Model model) { 
        
        // 1. 기존 최신 게시글 목록 조회
        List<SuShowPostVO> latestPosts = designService.getLatestPosts();
        
        // 2.이번 달 BEST 게시물 3개 조회
        List<SuShowPostVO> bestPosts = showDesignService.getBestPostsOfMonth(null);
        
        model.addAttribute("showcaseList", latestPosts);
        model.addAttribute("bestPosts", bestPosts);
        
        return "startup/design/main";
    }
    
    // GET /startUp/design/2dTool
    @GetMapping("/2dTool")
    public String designTool2D() {
        return "startup/design/2dTool";
    }
    
    // 다른 사용자의 파일을 저장 (기존 디자인을 복제하여 새로운 사용자의 디자인으로 저장)
    @PostMapping("/clone/{designId}")
    @ResponseBody 
    public ResponseEntity<Map<String, Object>> cloneDesign(
            @PathVariable("designId") int designId,
            @RequestParam("newDesignName") String newDesignName, 
            Authentication authentication) {

        Map<String, Object> response = new HashMap<>();

        // 로그인 여부 확인
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String userId = customUser.getUsersVO().getUserId();
        
        // ★★★ 3. 서비스 호출 시 newDesignName을 전달
        int result = designService.cloneDesign(designId, userId, newDesignName);

        // 결과에 따라 성공/실패 JSON 메시지를 생성하여 반환
        if (result > 0) {
            response.put("success", true);
            response.put("message", "도면을 라이브러리에 추가했습니다.");
            return new ResponseEntity<>(response, HttpStatus.OK);
        } else {
            response.put("success", false);
            response.put("message", "디자인을 가져오는 데 실패했습니다.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
 // 도면 이름 변경을 위한 API 엔드포인트
    @PostMapping("/rename/{designId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> renameDesign(
            @PathVariable("designId") int designId,
            @RequestBody Map<String, String> requestBody,
            Authentication authentication) {

        Map<String, Object> response = new HashMap<>();

        // 1. 로그인 여부 확인
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String userId = customUser.getUsersVO().getUserId();
        String newDesignName = requestBody.get("newDesignName"); // JSON으로 받은 새 이름 추출

        // 2. 서비스 호출하여 이름 변경 실행
        try {
            // DesignService에 renameDesign 메소드를 만들어야 합니다.
            int result = designService.renameDesign(designId, userId, newDesignName);
            
            if (result > 0) {
                response.put("success", true);
                response.put("message", "도면 이름이 성공적으로 변경되었습니다.");
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("success", false);
                response.put("message", "이름을 변경할 권한이 없거나 도면을 찾을 수 없습니다.");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            log.error("도면 이름 변경 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류로 인해 이름 변경에 실패했습니다.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
 // json 파일 및 도면 캡쳐 함께 저장
    @PostMapping(value="/api/designs", consumes=MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> saveDesign(
        @RequestPart("design") SuShowDesignVO design,      // JSON
        @RequestPart("thumbnail") MultipartFile thumbFile, // 이미지
        Authentication authentication 
    ) {
    	 	
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("message", "로그인이 필요합니다."));
        }
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        design.setUserId(customUser.getUsersVO().getUserId());

        try {
            long id = designService.saveDesignWithThumbnail(design, thumbFile);
            return ResponseEntity.ok(Map.of("designId", id));
        } catch (IOException e) {
            log.error("파일 저장 중 오류 발생", e); // ✅ 로그 추가
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body(Map.of("message", "파일 저장 중 오류가 발생했습니다."));
        }
    }
    

    //json 파일 및 도면 캡쳐 함께 수정
    @PostMapping(value="/api/designs/update", consumes=MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> updateDesign(
        @RequestPart("design") SuShowDesignVO design,
        @RequestPart(value = "thumbnail", required = false) MultipartFile thumbFile, // 썸네일은 필수가 아님
        Authentication authentication
    ) {
        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                                 .body(Map.of("message", "로그인이 필요합니다."));
        }
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String currentUserId = customUser.getUsersVO().getUserId();
        
        // --- 수정 권한 확인 ---
        SuShowDesignVO originalDesign = designService.getDesignById(design.getDesignId());
        if (originalDesign == null || !originalDesign.getUserId().equals(currentUserId)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                                 .body(Map.of("message", "수정 권한이 없습니다."));
        }
        
        // --- 수정 로직 수행 ---
        design.setUserId(currentUserId); // VO에 사용자 ID 설정
        try {
            designService.updateDesignWithThumbnail(design, thumbFile);
            return ResponseEntity.ok(Map.of("designId", design.getDesignId(), "message", "성공적으로 수정되었습니다."));
        } catch (IOException e) {
            log.error("디자인 수정 중 파일 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                 .body(Map.of("message", "파일 처리 중 오류가 발생했습니다."));
        }
    }
    
    // ID로 디자인을 삭제하는 API 엔드포인트
    @PostMapping("/delete/{designId}") 
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteDesign(
            @PathVariable("designId") int designId,
            Authentication authentication) {

        Map<String, Object> response = new HashMap<>();

        if (authentication == null || !(authentication.getPrincipal() instanceof CustomUser)) {
            response.put("success", false);
            response.put("message", "로그인이 필요합니다.");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }

        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        String userId = customUser.getUsersVO().getUserId();

        try {
            int result = designService.deleteDesign(designId, userId);
            if (result > 0) {
                response.put("success", true);
                response.put("message", "도면이 삭제되었습니다.");
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else {
                response.put("success", false);
                response.put("message", "도면을 삭제할 권한이 없거나, 이미 삭제된 도면입니다.");
                return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
            }
        } catch (Exception e) {
            log.error("도면 삭제 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "서버 오류로 인해 삭제에 실패했습니다.");
            return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}