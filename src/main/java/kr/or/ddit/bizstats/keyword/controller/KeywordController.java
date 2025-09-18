package kr.or.ddit.bizstats.keyword.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper; // ObjectMapper import

import kr.or.ddit.bizstats.keyword.dto.KeywordDto;
import kr.or.ddit.bizstats.keyword.service.impl.NaverApiService;

@Controller
@RequestMapping("/biz-stats/keyword")
public class KeywordController {

    private final NaverApiService naverApiService;
    private final ObjectMapper objectMapper;

    public KeywordController(NaverApiService naverApiService, ObjectMapper objectMapper) {
        this.naverApiService = naverApiService;
        this.objectMapper = objectMapper;
    }
    
    // (1) SNS 키워드 분석 main 페이지
    // ▼▼▼▼▼ 초기 페이지 로딩 메서드 수정 ▼▼▼▼▼
    @GetMapping
    public String searchPage(Model model) {
        String defaultKeyword = "여름휴가"; // 기본으로 보여줄 키워드
        try {
            // 기본 키워드로 데이터 조회
            List<KeywordDto> keywords = naverApiService.getRelatedKeywords(defaultKeyword);
            
            // 조회된 데이터를 JSP의 JavaScript에서 사용할 수 있도록 JSON 문자열로 변환
            String jsonKeywords = objectMapper.writeValueAsString(keywords);

            // 모델에 데이터 추가
            model.addAttribute("initialKeyword", defaultKeyword);
            model.addAttribute("initialData", jsonKeywords); // JSP로 전달

        } catch (Exception e) {
            // API 호출 실패 시에는 빈 데이터를 전달
            model.addAttribute("initialKeyword", defaultKeyword);
            model.addAttribute("initialData", "[]");
        }
        return "bizstats/keyword/search";
    }
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲


}