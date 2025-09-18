package kr.or.ddit.cs.survey.controller;

import jakarta.servlet.http.HttpServletRequest;
import kr.or.ddit.cs.survey.service.CsSurveyService;
import kr.or.ddit.cs.survey.vo.CsSurveyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @class Name : SurveyController.java
 * @description : 사용자 대상 설문조사 기능의 컨트롤러입니다. 설문 목록 조회, 설문 참여, 결과 제출 및 완료 페이지를 담당합니다.
 */
@Controller
@RequestMapping("/cs/survey")
public class SurveyController {

    @Autowired
    private CsSurveyService service;

    /**
     * @param model     : View에 데이터를 전달하기 위한 Model 객체
     * @param principal : 현재 로그인한 사용자 정보를 확인하기 위한 Principal 객체
     * @return "cs/survey/list" : 설문조사 목록 페이지 뷰 이름
     * @method Name : listSurveys
     * @description : 진행중인 설문조사 목록을 조회합니다. 로그인 사용자의 경우 참여 여부를 함께 표시합니다.
     */
    @GetMapping
    public String listSurveys(Model model, Principal principal) {
        String userId = principal != null ? principal.getName() : null;
        List<CsSurveyVO> list;

        if (userId != null) {
            list = service.getAllSurveysWithParticipation(userId);
            model.addAttribute("loggedIn", true);
        } else {
            list = service.getAllSurveys();
            model.addAttribute("loggedIn", false);
        }
        model.addAttribute("surveyList", list);
        return "cs/survey/list";
    }

    /**
     * @param surveyId : 조회할 설문조사의 ID
     * @param model    : View에 데이터를 전달하기 위한 Model 객체
     * @return "cs/survey/survey" : 설문조사 참여 페이지 뷰 이름
     * @method Name : showSurvey
     * @description : 특정 설문조사의 문항과 선택지를 상세 조회하여 설문 참여 페이지를 표시합니다.
     */
    @GetMapping("/detail")
    public String showSurvey(@RequestParam("surveyId") int surveyId,
                             @RequestParam(value = "readonly", required = false) Boolean readonlyParam,
                             Principal principal, Model model) {
        CsSurveyVO survey = service.getSurveyWithQuestions(surveyId);
        model.addAttribute("survey", survey);

        boolean readOnly = false;
        Map<Integer, Integer> selectedMap = null;

        if (principal != null) {
            String userId = principal.getName();
            Integer responseId = service.findLatestResponseId(surveyId, userId);
            if (responseId != null) {
                readOnly = true;
                selectedMap = service.getSelectedOptionIdMap(responseId); // 질문ID -> 옵션ID
                // (선택) 제출일 표시
                model.addAttribute("submittedAt", service.getSubmittedAt(responseId));
            }
        }
        if (Boolean.TRUE.equals(readonlyParam)) readOnly = true;

        model.addAttribute("readOnly", readOnly);
        model.addAttribute("selectedMap", selectedMap);
        return "cs/survey/survey";
    }


    /**
     * @param request   : 설문 응답 파라미터를 동적으로 받기 위한 HttpServletRequest 객체
     * @param principal : 현재 로그인한 사용자의 정보를 담고 있는 Principal 객체
     * @return "redirect:/cs/survey/thx" : 처리 후 설문완료 페이지로 리다이렉트
     * @method Name : submitSurvey
     * @description : 사용자가 제출한 설문조사 응답을 저장합니다. 로그인한 사용자만 제출 가능합니다.
     */
    @PreAuthorize("isAuthenticated()")
    @PostMapping("/submit")
    public String submitSurvey(HttpServletRequest request, Principal principal) {
        if (principal == null) return "redirect:/login";
        String userId = principal.getName();

        // ★ 폼에서 온 설문ID 읽기
        int surveyId = Integer.parseInt(request.getParameter("surveyId"));

        // ★ 이미 응답했으면 읽기전용으로 우회
        Integer existing = service.findLatestResponseId(surveyId, userId);
        if (existing != null) {
            return "redirect:/cs/survey/detail?surveyId=" + surveyId + "&readonly=true";
        }

        Map<Integer, Integer> answers = new HashMap<>();
        request.getParameterMap().forEach((key, values) -> {
            if (key.startsWith("question_")) {
                int questionId = Integer.parseInt(key.substring("question_".length()));
                int optionValue = Integer.parseInt(values[0]); // (value는 optionValue)
                answers.put(questionId, optionValue);
            }
        });

        service.saveSurveyResponse(answers, userId); // (서비스에서 optionValue→optionId 매핑 중)
        return "redirect:/cs/survey/thx";
    }


    /**
     * @return "cs/survey/thx" : 설문완료 페이지 뷰 이름
     * @method Name : thankYouPage
     * @description : 설문조사 참여 완료 후 감사 페이지를 표시합니다.
     */
    @GetMapping("/thx")
    public String thankYouPage() {
        return "cs/survey/thx";
    }
}