package kr.or.ddit.attraction.flow.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.attraction.flow.service.FlowService;
import kr.or.ddit.common.config.jwt.TokenProvider;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/flow")
public class FlowLogController {

	@Autowired
    private FlowService flowService;
	
    private final TokenProvider tokenProvider;

    FlowLogController(TokenProvider tokenProvider) {
        this.tokenProvider = tokenProvider;
    }
    
    @PostMapping("/location-insert")
    public ResponseEntity<Map<String, Object>> locationInsert(@RequestBody String body, @RequestHeader("Authorization") String authHeader) {
        Map<String, Object> response = new HashMap<>();

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            
            //토큰이 유효하지 않으면 에러
            if(!tokenProvider.validate(token)) {
            	response.put("status", false);
                response.put("error", "Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            Authentication auth = tokenProvider.getAuthentication(token);
            CustomUser user = (CustomUser) auth.getPrincipal();
            String userId = user.getUsersVO().getUserId();

            boolean status = flowService.insertLocation(userId, body);

            response.put("status", status);
            return ResponseEntity.ok(response);

        } else {
            log.warn("Authorization 헤더가 없거나 올바르지 않습니다.");
            response.put("status", false);
            response.put("error", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }
    
    @PostMapping("/only-location-insert")
    public ResponseEntity<Map<String, Object>> insertOnlyLocation(@RequestBody String body, @RequestHeader("Authorization") String authHeader) {
    	log.info("GPS 상태 수신됨: {}", body);

        Map<String, Object> response = new HashMap<>();

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            
            //토큰이 유효하지 않으면 에러
            if(!tokenProvider.validate(token)) {
            	response.put("status", false);
                response.put("error", "Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            Authentication auth = tokenProvider.getAuthentication(token);
            CustomUser user = (CustomUser) auth.getPrincipal();
            String userId = user.getUsersVO().getUserId();

            log.info("GPS 상태 수신 사용자: {}", userId);

            boolean status = flowService.insertOnlyLocation(userId, body);

            response.put("status", status);
            return ResponseEntity.ok(response);

        } else {
            log.warn("Authorization 헤더가 없거나 올바르지 않습니다.");
            response.put("status", false);
            response.put("error", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }
    
    @PostMapping("/location-group-insert")
    public ResponseEntity<Map<String, Object>> flowGroupInsert(@RequestBody String body, @RequestHeader("Authorization") String authHeader) {
        log.info("GPS 상태 수신됨: {}", body);
        
        Map<String, Object> response = new HashMap<>();
        
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7); // "Bearer " 제거
            
            //토큰이 유효하지 않으면 에러
            if(!tokenProvider.validate(token)) {
            	response.put("status", false);
                response.put("error", "Unauthorized");
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
            
            // 토큰 파싱하여 사용자 정보 추출
            Authentication auth = tokenProvider.getAuthentication(token);
            CustomUser user = (CustomUser) auth.getPrincipal();
            String userId = user.getUsersVO().getUserId();
            
            log.info("GPS 상태 수신 사용자: {}", user.getUsersVO().getUserId());
            
            Long idx = flowService.locationGroupInsert(userId, body);
            
            response.put("status", true);
            response.put("polyId", idx);
            
            return ResponseEntity.ok(response);
        } else {
            log.warn("Authorization 헤더가 없거나 올바르지 않습니다.");
            response.put("status", false);
            response.put("polyId", 0);
            response.put("error", "Unauthorized");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
        
        
    }
}
