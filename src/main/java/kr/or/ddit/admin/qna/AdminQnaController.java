package kr.or.ddit.admin.qna;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.cs.qna.service.CsQnaPostService;
import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;

/**
 * @class Name : AdminQnaController.java
 * @description : 관리자 Q&A 게시판의 답변 관리(조회, 등록, 수정, 삭제)를 위한 컨트롤러 클래스입니다.
 */
@Controller
@RequestMapping("/admin/qna")
public class AdminQnaController {

    private final CsQnaPostService qnaService;
    private final FileService fileService;

    @Autowired
    public AdminQnaController(CsQnaPostService qnaService, FileService fileService) {
        this.qnaService = qnaService;
        this.fileService = fileService;
    }

    /**
     * @method Name : replyQnaForm
     * @description : Q&A 답변 페이지를 조회합니다. 특정 질문 상세 정보와 함께 미답변/답변완료 목록을 페이징하여 모델에 추가합니다.
     * @param quesId      : 상세 조회할 질문의 ID
     * @param answeredYn  : 현재 활성화된 탭(미답변 'N', 답변완료 'Y')을 구분하는 파라미터
     * @param currentPage : 현재 페이지 번호
     * @param model       : View에 데이터를 전달하기 위한 Model 객체
     * @return "admin/qna/replyQna" : Q&A 답변 페이지의 뷰 이름
     */
    @GetMapping
    public String replyQnaForm(
            @RequestParam(value="quesId",      defaultValue="0") int    quesId,
            @RequestParam(value="answeredYn",  defaultValue="N") String answeredYn,
            @RequestParam(value="currentPage", defaultValue="1") int    currentPage,
            Model model
    ) {
        // 1) 상세 QnA 조회
        CsQnaPostVO qna = quesId > 0
                ? qnaService.getQna(quesId)
                : new CsQnaPostVO();
        model.addAttribute("qna", qna);
        if (qna.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(qna.getFileGroupNo());
            model.addAttribute("files", files);
        }
        int size = 5;

        // 2) 미답변 목록 페이징 처리
        int totalUn   = qnaService.getQnaCountByAnsweredYn("N");
        int currentUn = "N".equals(answeredYn) ? currentPage : 1;
        Map<String,Object> unParam = new HashMap<>();
        unParam.put("answeredYn", "N");
        unParam.put("startRow",   (currentUn - 1) * size + 1);
        unParam.put("endRow",     currentUn * size);
        List<CsQnaPostVO> listUn = qnaService.getQnaListByAnsweredYnPaged(unParam);
        ArticlePage<CsQnaPostVO> unansweredPage =
                new ArticlePage<>(totalUn, currentUn, size, listUn, null);
        unansweredPage.setUrl(
                "/admin/qna?answeredYn=N&quesId=" + quesId
        );
        model.addAttribute("unansweredPage", unansweredPage);

        // 3) 답변완료 목록 페이징 처리
        int totalAn   = qnaService.getQnaCountByAnsweredYn("Y");
        int currentAn = "Y".equals(answeredYn) ? currentPage : 1;
        Map<String,Object> anParam = new HashMap<>();
        anParam.put("answeredYn", "Y");
        anParam.put("startRow",   (currentAn - 1) * size + 1);
        anParam.put("endRow",     currentAn * size);
        List<CsQnaPostVO> listAn = qnaService.getQnaListByAnsweredYnPaged(anParam);
        ArticlePage<CsQnaPostVO> answeredPage =
                new ArticlePage<>(totalAn, currentAn, size, listAn, null);
        answeredPage.setUrl(
                "/admin/qna?answeredYn=Y&quesId=" + quesId
        );
        model.addAttribute("answeredPage", answeredPage);

        return "admin/qna/replyQna";
    }

    /**
     * @method Name : submitAnswer
     * @description : Q&A 답변을 등록하거나 수정합니다. 답변 ID(ansId) 유무에 따라 등록/수정을 구분하여 처리합니다.
     * @param quesId        : 답변이 달릴 질문의 ID
     * @param ansId         : 수정할 답변의 ID (신규 등록 시에는 null 또는 0)
     * @param answerContent : 등록/수정할 답변 내용
     * @param adminId       : 작업을 수행하는 관리자의 ID
     * @return "redirect:/admin/qna?quesId={quesId}" : 처리 후 해당 질문의 상세 페이지로 리다이렉트
     */
    @PostMapping
    public String submitAnswer(
            @RequestParam int quesId,
            @RequestParam(required = false) Integer ansId,
            @RequestParam String answerContent,
            @AuthenticationPrincipal(expression="username") String adminId
    ) {
        CsQnaAnswerVO answer = new CsQnaAnswerVO();
        answer.setQuesId(quesId);
        answer.setContent(answerContent);
        answer.setAdminId(adminId);

        if (ansId == null || ansId == 0) {
            qnaService.insertAnswer(answer);
        } else {
            answer.setAnsId(ansId);
            qnaService.updateAnswer(answer);
        }
        
        return "redirect:/admin/qna?quesId=" + quesId;
    }

    /**
     * @method Name : deleteAnswer
     * @description : 특정 Q&A 답변을 삭제합니다.
     * @param ansId  : 삭제할 답변의 ID
     * @param quesId : 리다이렉트 시 필요한 질문의 ID
     * @return "redirect:/admin/qna?quesId={quesId}" : 처리 후 해당 질문의 상세 페이지로 리다이렉트
     */
    @GetMapping("/deleteAnswer")
    public String deleteAnswer(
            @RequestParam int ansId,
            @RequestParam int quesId
    ) {
        qnaService.deleteAnswer(ansId);
        return "redirect:/admin/qna?quesId=" + quesId;
    }
}