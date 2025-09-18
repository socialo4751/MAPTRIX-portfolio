package kr.or.ddit.admin.survey.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.cs.survey.service.CsSurveyService;
import kr.or.ddit.cs.survey.vo.CsSurveyVO;

/**
 * @class Name : AdminSurveyController.java
 * @description : 관리자 페이지의 설문조사 관리를 위한 컨트롤러 클래스입니다. 목록 조회, 등록, 상세 조회, 상태 변경 기능을 담당합니다.
 */
@Controller
@RequestMapping("/admin/survey")
public class AdminSurveyController {

    @Autowired
    private CsSurveyService surveyService;

    /**
     * @param currentPage : 현재 페이지 번호
     * @param useYn       : 사용 여부 필터 ('Y' 또는 'N')
     * @param model       : View에 데이터를 전달하기 위한 Model 객체
     * @return "admin/survey/list" : 설문조사 목록 페이지의 뷰 이름
     * @method Name : adminSurveyList
     * @description : 설문조사 목록을 검색 조건과 함께 페이징하여 조회합니다.
     */
    @GetMapping
    public String adminSurveyList(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(value = "useYn", required = false, defaultValue = "") String useYn,
            Model model
    ) {
        int pageSize = 10;
        Map<String, Object> paramMap = new HashMap<>();

        if (keyword != null && !keyword.isEmpty()) {
            paramMap.put("keyword", keyword);
        }
        if (useYn != null && !useYn.isEmpty()) {
            paramMap.put("useYn", useYn);
        }

        int total = surveyService.countSurveys(paramMap);

        int start = (currentPage - 1) * pageSize + 1;
        int end = currentPage * pageSize;
        paramMap.put("start", start);
        paramMap.put("end", end);

        List<CsSurveyVO> surveys = surveyService.selectSurveyPage(paramMap);

        ArticlePage<CsSurveyVO> articlePage =
                new ArticlePage<>(total, currentPage, pageSize, surveys, keyword);

        StringBuilder baseUrl = new StringBuilder("/admin/survey");
        boolean hasQuery = false;
        if (!keyword.isEmpty()) {
            baseUrl.append("?keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
            hasQuery = true;
        }
        if (useYn != null && !useYn.isEmpty()) {
            baseUrl.append(hasQuery ? "&" : "?")
                    .append("useYn=").append(URLEncoder.encode(useYn, StandardCharsets.UTF_8));
        }

        articlePage.setUrl(baseUrl.toString());

        model.addAttribute("surveyList", surveys);
        model.addAttribute("articlePage", articlePage);

        return "admin/survey/list";
    }

    /**
     * @param model : View에 빈 CsSurveyVO 객체를 전달하기 위한 Model 객체
     * @return "admin/survey/insert" : 설문조사 등록 폼 페이지의 뷰 이름
     * @method Name : showInsertForm
     * @description : 설문조사 등록 폼 페이지를 표시합니다. 관리자 권한이 필요합니다.
     */
    @GetMapping("/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String showInsertForm(Model model) {
        model.addAttribute("survey", new CsSurveyVO());
        return "admin/survey/insert";
    }

    /**
     * @param survey : 폼에서 입력된 설문조사 데이터 (VO)
     * @param ra     : 리다이렉트 시 메시지를 전달하기 위한 RedirectAttributes 객체
     * @return "redirect:/admin/survey" : 설문조사 목록 페이지로 리다이렉트
     * @method Name : insertSurvey
     * @description : 작성된 설문조사와 문항들을 데이터베이스에 등록합니다. 관리자 권한이 필요합니다.
     */
    @PostMapping("/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String insertSurvey(@ModelAttribute CsSurveyVO survey, RedirectAttributes ra) {
        surveyService.insertSurveyWithQuestions(survey);
        ra.addFlashAttribute("msg", "설문이 등록되었습니다.");
        return "redirect:/admin/survey";
    }

    /**
     * @param surveyId : 조회할 설문조사의 ID
     * @return CsSurveyVO : 설문조사의 상세 정보가 담긴 VO 객체
     * @method Name : getSurveyDetails
     * @description : 특정 설문조사의 상세 정보(문항 및 선택지 포함)를 JSON 형태로 반환합니다.
     */
    @GetMapping("/detailData")
    @ResponseBody
    public CsSurveyVO getSurveyDetails(@RequestParam("surveyId") int surveyId) {
        return surveyService.selectSurveyWithQuestions(surveyId);
    }

    /**
     * @param surveyId : 상태를 변경할 설문조사의 ID
     * @param useYn    : 변경할 사용 여부 값 ('Y' 또는 'N')
     * @return "redirect:/admin/survey" : 설문조사 목록 페이지로 리다이렉트
     * @method Name : changeSurveyStatus
     * @description : 특정 설문조사의 사용 여부(useYn) 상태를 변경합니다.
     */
    @GetMapping("/changeStatus")
    public String changeSurveyStatus(@RequestParam("surveyId") int surveyId,
                                     @RequestParam("useYn") String useYn) {
        CsSurveyVO survey = new CsSurveyVO();
        survey.setSurveyId(surveyId);
        survey.setUseYn(useYn);
        surveyService.updateSurveyStatus(survey);

        return "redirect:/admin/survey";
    }

    // 1) 설문 전체 질문별 점수 분포(%)
    @ResponseBody
    @GetMapping("/{surveyId}/stats/score-pct")
    public List<Map<String, Object>> getSurveyScorePct(@PathVariable int surveyId) {
        return surveyService.getSurveyScorePct(surveyId);
    }

    // 2) 특정 질문의 점수 분포(%)
    @ResponseBody
    @GetMapping("/questions/{questionId}/stats/score-pct")
    public List<Map<String, Object>> getQuestionScorePct(@PathVariable int questionId) {
        return surveyService.getQuestionScorePct(questionId);
    }

    // 3) 설문 참여 추이(일별 응답 수)
    @ResponseBody
    @GetMapping("/{surveyId}/stats/trend")
    public List<Map<String, Object>> getParticipationTrend(@PathVariable int surveyId) {
        return surveyService.getParticipationTrend(surveyId);
    }

    // 4) 설문 총점 히스토그램
    @ResponseBody
    @GetMapping("/{surveyId}/stats/histogram")
    public List<Map<String, Object>> getTotalValueHistogram(@PathVariable int surveyId) {
        return surveyService.getTotalValueHistogram(surveyId);
    }

    @ResponseBody
    @GetMapping(value = "/{surveyId}/stats/gender", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Map<String, Object>> gender(@PathVariable int surveyId) {
        return surveyService.getSurveyGenderPct(surveyId);
    }

    @ResponseBody
    @GetMapping(value = "/{surveyId}/stats/age-bucket", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<Map<String, Object>> ageBucket(@PathVariable int surveyId) {
        return surveyService.getSurveyAgeBuckets(surveyId);
    }
}