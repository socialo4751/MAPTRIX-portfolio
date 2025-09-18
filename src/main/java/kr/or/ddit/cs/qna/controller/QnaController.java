package kr.or.ddit.cs.qna.controller;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.util.UploadController;
import kr.or.ddit.cs.qna.service.CsQnaPostService;
import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @class Name : QnaController.java
 * @description : 사용자 Q&A 게시판의 CRUD를 담당하는 컨트롤러입니다. 목록 조회, 상세 조회, 등록, 수정, 삭제 기능을 제공합니다.
 */
@EnableMethodSecurity(
        securedEnabled = true,
        prePostEnabled = true
)
@Controller
@RequestMapping("/cs/qna")
public class QnaController {

    private final UploadController uploadController;
    private final CsQnaPostService qnaService;
    private final FileService fileService;
    private final CodeService codeService;

    @Autowired
    public QnaController(CsQnaPostService qnaService, UploadController uploadController,
                         FileService fileService, CodeService codeService) {
        this.qnaService = qnaService;
        this.uploadController = uploadController;
        this.fileService = fileService;
        this.codeService = codeService;
    }

    /**
     * @param currentPage : 현재 페이지 번호
     * @param catCodeId   : 필터링할 카테고리 코드 ID
     * @param keyword     : 검색할 키워드
     * @param model       : View에 데이터를 전달하기 위한 Model 객체
     * @return "cs/qna/list" : Q&A 목록 페이지 뷰 이름
     * @method Name : list
     * @description : Q&A 게시글 목록을 조회합니다. 카테고리 필터링, 키워드 검색, 페이징을 지원합니다.
     */
    // QnaController.java (list 메서드만 교체)
    @GetMapping
    public String list(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "catCodeId", required = false) String catCodeId,
            @RequestParam(value = "searchType", defaultValue = "title_content") String searchType,
            @RequestParam(value = "keyword", defaultValue = "") String keyword,
            Model model
    ) {
        // 옵션 바인딩
        model.addAttribute("qnaTags", codeService.getCodeDetailList("QNATAG"));
        model.addAttribute("searchTags", codeService.getCodeDetailList("SEARCHTAG"));

        // 조회 파라미터
        Map<String, Object> map = new HashMap<>();
        if (catCodeId != null && !catCodeId.isEmpty()) map.put("catCodeId", catCodeId);
        map.put("searchType", searchType);
        if (!keyword.isEmpty()) map.put("keyword", keyword);

        int size = 20;
        int total = qnaService.getQnaCount(map);
        map.put("startRow", (currentPage - 1) * size + 1);
        map.put("endRow", currentPage * size);

        List<CsQnaPostVO> list = qnaService.getQnaList(map);

        // ★ ArticlePage에 keyword, searchType을 전달 (반드시!)
        ArticlePage<CsQnaPostVO> page =
                new ArticlePage<>(total, currentPage, size, list, keyword, searchType);

        // ★ base URL에는 catCodeId만 (searchType/keyword 절대 넣지 말 것)
        String baseUrl = "/cs/qna";
        if (catCodeId != null && !catCodeId.isBlank()) {
            baseUrl += "?catCodeId=" + java.net.URLEncoder.encode(
                    catCodeId, java.nio.charset.StandardCharsets.UTF_8);
        }
        page.setUrl(baseUrl);

        model.addAttribute("articlePage", page);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        model.addAttribute("qnaList", list);

        return "cs/qna/list";
    }


    /**
     * @param quesId : 조회할 질문의 ID
     * @param model  : View에 데이터를 전달하기 위한 Model 객체
     * @return "cs/qna/detail" : Q&A 상세 페이지 뷰 이름
     * @method Name : detail
     * @description : 특정 Q&A 게시글의 상세 내용을 조회합니다. 질문, 답변, 첨부파일을 포함합니다.
     */
    @GetMapping("/detail")
    public String detail(@RequestParam("quesId") int quesId,
                         Model model,
                         RedirectAttributes ra) {

        // 1) 글 조회 및 존재 여부 체크
        CsQnaPostVO qna = qnaService.getQna(quesId);
        if (qna == null) {
            ra.addFlashAttribute("error", "게시글을 찾을 수 없습니다.");
            return "redirect:/cs/qna"; // ← 리스트 주소에 맞게 수정
        }

        // 2) 비공개면: 관리자 또는 작성자만 허용
        boolean isSecret = "N".equalsIgnoreCase(qna.getPublicYn()); // ← 컬럼/게터명 맞춰 사용
        if (isSecret) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            // 로그인 여부
            boolean isLoggedIn = auth != null
                    && auth.isAuthenticated()
                    && !"anonymousUser".equals(String.valueOf(auth.getPrincipal()));
            if (!isLoggedIn) {
                ra.addFlashAttribute("error", "비공개 게시글입니다. 로그인 후 이용해주세요.");
                return "redirect:/cs/qna"; // 또는 로그인 페이지로 유도
            }

            // 관리자 여부
            boolean isAdmin = auth.getAuthorities().stream()
                    .anyMatch(a -> "ROLE_ADMIN".equals(a.getAuthority()));

            // 로그인한 사용자 식별자
            String loginUserId = extractLoginId(auth);

            // 작성자 식별자 (게터명은 프로젝트에 맞게 수정!)
            String ownerId = qna.getUserId(); // ← 예: getWriterId(), getEmail() 등으로 교체

            if (!isAdmin && (loginUserId == null || !loginUserId.equals(ownerId))) {
                ra.addFlashAttribute("error", "비공개 게시글입니다. 작성자와 관리자만 열람할 수 있습니다.");
                return "redirect:/cs/qna";
            }
        }

        // 3) 접근 허용: 원래 네 로직 그대로
        model.addAttribute("qna", qna);

        if (qna.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(qna.getFileGroupNo());
            model.addAttribute("files", files);
        }

        CsQnaAnswerVO answer = qnaService.getAnswerByQuesId(quesId);
        model.addAttribute("answer", answer);

        return "cs/qna/detail";
    }

    /**
     * SecurityContext에서 로그인 아이디(username)를 꺼내는 유틸
     */
    private String extractLoginId(Authentication auth) {
        if (auth == null) return null;
        Object p = auth.getPrincipal();
        if (p instanceof org.springframework.security.core.userdetails.UserDetails ud) {
            return ud.getUsername();
        }
        if (p instanceof String s) {
            return "anonymousUser".equals(s) ? null : s;
        }
        return null;
    }

    /**
     * @param model : View에 데이터를 전달하기 위한 Model 객체
     * @return "cs/qna/insert" : Q&A 등록/수정 폼 페이지 뷰 이름
     * @method Name : insertForm
     * @description : Q&A 게시글 등록 폼을 표시합니다.
     */
    @GetMapping("/insert")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public String insertForm(Model model) {
        model.addAttribute("mode", "insert");
        model.addAttribute("qna", new CsQnaPostVO());
        // [추가] 글 작성 시 사용할 카테고리 목록을 모델에 추가
        model.addAttribute("qnaTags", codeService.getCodeDetailList("QNATAG"));
        return "cs/qna/insert";
    }

    /**
     * @param qna         : 폼에서 전송된 Q&A 데이터 VO
     * @param attachments : 업로드된 첨부파일 배열
     * @param ra          : 리다이렉트 시 메시지를 전달하기 위한 RedirectAttributes 객체
     * @return "redirect:/cs/qna" : 처리 후 Q&A 목록 페이지로 리다이렉트
     * @method Name : insert
     * @description : 새로운 Q&A 게시글을 등록합니다.
     */
    @PostMapping("/insert")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public String insert(CsQnaPostVO qna,
                         @RequestParam("attachment") MultipartFile[] attachments,
                         RedirectAttributes ra) {
        CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        qna.setUserId(user.getUsername());

        long groupNo = fileService.uploadFiles(attachments, "attachment", qna.getFileGroupNo());
        if (groupNo > 0) qna.setFileGroupNo((int) groupNo);

        qnaService.createQna(qna);
        ra.addFlashAttribute("msg", "QnA가 등록되었습니다.");
        return "redirect:/cs/qna";
    }

    /**
     * @param quesId : 수정할 질문의 ID
     * @param model  : View에 데이터를 전달하기 위한 Model 객체
     * @return "cs/qna/insert" : Q&A 등록/수정 폼 페이지 뷰 이름
     * @method Name : updateForm
     * @description : 기존 Q&A 게시글 수정 폼을 표시합니다.
     */
    @GetMapping("/update")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public String updateForm(@RequestParam int quesId, Model model) {
        CsQnaPostVO qna = qnaService.getQna(quesId);
        model.addAttribute("mode", "update");
        model.addAttribute("qna", qna);
        if (qna.getFileGroupNo() > 0) {
            model.addAttribute("files", fileService.getFileList(qna.getFileGroupNo()));
        }
        // [추가] 글 수정 시 사용할 카테고리 목록을 모델에 추가
        model.addAttribute("qnaTags", codeService.getCodeDetailList("QNATAG"));
        return "cs/qna/insert";
    }

    /**
     * @param qna         : 폼에서 전송된 수정할 Q&A 데이터 VO
     * @param attachments : 새롭게 업로드된 첨부파일 배열
     * @param ra          : 리다이렉트 시 메시지를 전달하기 위한 RedirectAttributes 객체
     * @return "redirect:/cs/qna/detail?quesId={quesId}" : 처리 후 Q&A 상세 페이지로 리다이렉트
     * @method Name : update
     * @description : 기존 Q&A 게시글을 수정합니다.
     * ★정책 변경: 수정 시 새로운 파일이 첨부되면 신규 파일 그룹을 생성하여 연결합니다.
     */
    @PostMapping("/update")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public String update(
            CsQnaPostVO qna,
            @RequestParam("attachment") MultipartFile[] attachments,
            @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
            RedirectAttributes ra
    ) {
        // 원본 글의 기존 그룹 확인
        CsQnaPostVO existingQna = qnaService.getQna(qna.getQuesId());
        int originalFileGroupNo = existingQna.getFileGroupNo();

        boolean hasNewFiles =
                attachments != null && attachments.length > 0 && attachments[0] != null && !attachments[0].isEmpty();
        boolean editorGroupChanged = ckFileGroupNo > 0 && ckFileGroupNo != originalFileGroupNo;

        long finalGroupNo;
        if (hasNewFiles) {
            // 첨부가 있으면:
            // 1) CK가 이미 새 그룹을 만들었으면 그 그룹에 합치고
            // 2) 아니면 0을 줘서 완전히 새 그룹 생성
            long base = (ckFileGroupNo > 0) ? ckFileGroupNo : 0L;
            finalGroupNo = fileService.uploadFiles(attachments, "attachment", base);
        } else if (editorGroupChanged) {
            // 첨부는 없지만 CK 전용 그룹이 새로 생겼다면 그걸 최종 그룹으로 전환
            finalGroupNo = ckFileGroupNo;
        } else {
            // 파일 변경 없음 → 기존 그룹 유지
            finalGroupNo = originalFileGroupNo;
        }

        qna.setFileGroupNo((int) finalGroupNo);

        qnaService.modifyQna(qna);
        ra.addFlashAttribute("msg", "수정되었습니다.");
        return "redirect:/cs/qna/detail?quesId=" + qna.getQuesId();
    }

    /**
     * @param quesId      : 삭제할 질문의 ID
     * @param fileGroupNo : (추가) 삭제할 파일 그룹 번호
     * @param ra          : 리다이렉트 시 메시지를 전달하기 위한 RedirectAttributes 객체
     * @return "redirect:/cs/qna" : 처리 후 Q&A 목록 페이지로 리다이렉트
     * @method Name : delete
     * @description : Q&A 게시글을 삭제합니다. 게시글과 모든 첨부파일을 함께 삭제합니다.
     */
    @PostMapping("/delete")
    @PreAuthorize("hasAnyRole('USER','ADMIN')")
    public String delete(@RequestParam("quesId") int quesId,
                         @RequestParam(name = "fileGroupNo", defaultValue = "0") int fileGroupNo, // ★ 1. 파일 그룹 번호 받기
                         RedirectAttributes ra) {

        CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String loginUserId = user.getUsername();

        CsQnaPostVO qna = qnaService.getQna(quesId);

        boolean isAdmin = user.getAuthorities().stream()
                .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"));

        // 권한 확인 (관리자 또는 본인)
        if (!isAdmin && !loginUserId.equals(qna.getUserId())) {
            ra.addFlashAttribute("error", "삭제 권한이 없습니다.");
            return "redirect:/cs/qna/detail?quesId=" + quesId;
        }

        // ★ 3. 게시글 삭제
        qnaService.removeQna(quesId);
        ra.addFlashAttribute("msg", "삭제되었습니다.");
        return "redirect:/cs/qna";
    }

}