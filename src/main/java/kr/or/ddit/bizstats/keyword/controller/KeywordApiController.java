package kr.or.ddit.bizstats.keyword.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.bizstats.keyword.dto.KeywordDto;
import kr.or.ddit.bizstats.keyword.service.impl.NaverApiService;

@Controller
@RequestMapping("/api/biz-stats/naver-keywords")
public class KeywordApiController {
    private final NaverApiService naverApiService;

    public KeywordApiController(NaverApiService naverApiService) {
        this.naverApiService = naverApiService;
    }

    // AJAX 데이터 요청 처리 (POST 요청)
    // @ResponseBody 어노테이션을 붙여 JSON 데이터를 반환하게 함
    @PostMapping
    @ResponseBody
    public ResponseEntity<?> getKeywords(@RequestParam String keyword) {
        System.out.println(">>>>> Controller가 받은 키워드: " + keyword + " <<<<<");

        try {
            List<KeywordDto> keywords = naverApiService.getRelatedKeywords(keyword);
            return ResponseEntity.ok(keywords);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("API 요청 실패: " + e.getMessage());
        }
    }

}
