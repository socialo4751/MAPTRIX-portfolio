package kr.or.ddit.cs.qna.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.cs.qna.service.CsQnaPostService;
import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;

/**
 * @class Name : AnswerController.java
 * @description : 관리자 전용 Q&A 답변 관리를 위한 컨트롤러입니다. 답변의 등록, 수정, 삭제 기능을 처리합니다.
 */
@Controller
@RequestMapping("/cs/answer")
@PreAuthorize("hasRole('ADMIN')")
public class AnswerController {

    private final CsQnaPostService qnaService;

    @Autowired
    public AnswerController(CsQnaPostService qnaService) {
        this.qnaService = qnaService;
    }

    // 답변 등록
    @PostMapping("/insert")
    public String insertAnswer(@ModelAttribute CsQnaAnswerVO answer,
                               RedirectAttributes redirectAttributes) {
        qnaService.insertAnswer(answer);
        redirectAttributes.addFlashAttribute("msg", "답변이 등록되었습니다.");
        return "redirect:/cs/qna/detail?quesId=" + answer.getQuesId();
    }

    // 답변 수정
    @PostMapping("/update")
    public String updateAnswer(@ModelAttribute CsQnaAnswerVO answer,
                               RedirectAttributes redirectAttributes) {
        qnaService.updateAnswer(answer);
        redirectAttributes.addFlashAttribute("msg", "답변이 수정되었습니다.");
        return "redirect:/cs/qna/detail?quesId=" + answer.getQuesId();
    }

    // 답변 삭제
    @PostMapping("/delete")
    public String deleteAnswer(@RequestParam("answerId") int answerId,
                               @RequestParam("quesId") int quesId,
                               RedirectAttributes redirectAttributes) {
        qnaService.deleteAnswer(answerId);
        redirectAttributes.addFlashAttribute("msg", "답변이 삭제되었습니다.");
        return "redirect:/cs/qna/detail?quesId=" + quesId;
    }
}