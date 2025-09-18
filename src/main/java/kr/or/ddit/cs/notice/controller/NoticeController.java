package kr.or.ddit.cs.notice.controller;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.util.UploadController;
import kr.or.ddit.cs.notice.service.CsNoticePostService;
import kr.or.ddit.cs.notice.vo.CsNoticePostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@EnableMethodSecurity(
        securedEnabled = true,
        prePostEnabled = true
)
@Controller
@RequestMapping("/cs/notice")
public class NoticeController {

    private final UploadController uploadController;
    private final CsNoticePostService noticeService;
    private final FileService fileService;
    private final CodeService codeService;

    @Autowired
    public NoticeController(CsNoticePostService noticeService, UploadController uploadController, FileService fileService, CodeService codeService) {
        this.noticeService = noticeService;
        this.uploadController = uploadController;
        this.fileService = fileService;
        this.codeService = codeService;
    }

    /**
     * 공지 목록
     */
    @GetMapping
    public String list(
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "catCodeId", required = false) String catCodeId,
            @RequestParam(value = "searchType", required = false, defaultValue = "SC101") String searchType,
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model
    ) {
        // 카테고리/검색 옵션 바인딩
        model.addAttribute("codeDetails", codeService.getCodeDetailList("NOTICETAG"));
        model.addAttribute("searchTags", codeService.getCodeDetailList("SEARCHTAG"));

        Map<String, Object> map = new HashMap<>();
        if (catCodeId != null && !catCodeId.isBlank()) map.put("catCodeId", catCodeId);
        map.put("searchType", searchType == null ? "SC101" : searchType.trim().toUpperCase());
        map.put("keyword", keyword == null ? "" : keyword.trim());

        int size = 20;
        int total = noticeService.getNoticeCount(map);

        map.put("startRow", (currentPage - 1) * size + 1);
        map.put("endRow", currentPage * size);

        List<CsNoticePostVO> list = noticeService.getNoticeList(map);

        // ★ 중요: ArticlePage 6-파라미터 생성자 사용 (keyword, searchType 전달)
        ArticlePage<CsNoticePostVO> page = new ArticlePage<>(total, currentPage, size, list, keyword, searchType);

        // ★ 중요: base URL에는 catCodeId만 유지 (searchType/keyword는 절대 넣지 말 것!)
        String baseUrl = "/cs/notice";
        if (catCodeId != null && !catCodeId.isBlank()) {
            baseUrl += "?catCodeId=" + URLEncoder.encode(catCodeId, StandardCharsets.UTF_8);
        }
        page.setUrl(baseUrl);

        model.addAttribute("articlePage", page);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        return "cs/notice/list";
    }

    /**
     * 상세
     */
    @GetMapping("/detail")
    public String showNoticeDetail(@RequestParam("postId") int postId, Model model) {
        noticeService.increaseViewCount(postId);

        CsNoticePostVO notice = noticeService.getNotice(postId);
        model.addAttribute("notice", notice);

        if (notice.getFileGroupNo() != null && notice.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(notice.getFileGroupNo());
            model.addAttribute("files", files);
        }
        return "cs/notice/detail";
    }

    /**
     * 등록 폼
     */
    @GetMapping("/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String showInsertForm(Model model) {
        model.addAttribute("notice", new CsNoticePostVO());
        model.addAttribute("mode", "insert");
        model.addAttribute("categoryList", codeService.getCodeDetailList("NOTICETAG"));
        return "cs/notice/insert";
    }

    /**
     * 등록
     */
    @PostMapping("/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String insertNotice(CsNoticePostVO notice, @RequestParam("attachment") MultipartFile[] attachments,
                               RedirectAttributes ra) {
        CustomUser user = (CustomUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        String username = user.getUsername();
        notice.setAdminId(username);

        long finalGroupNo = fileService.uploadFiles(
                attachments,
                "attachment",
                notice.getFileGroupNo()
        );

        if (finalGroupNo > 0) {
            notice.setFileGroupNo((int) finalGroupNo);
        }

        noticeService.createNotice(notice);

        ra.addFlashAttribute("msg", "공지사항이 등록되었습니다.");
        return "redirect:/cs/notice";
    }

    /**
     * 수정 폼
     */
    @GetMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    public String showUpdateForm(@RequestParam int postId, Model model) {
        CsNoticePostVO notice = noticeService.getNotice(postId);
        model.addAttribute("mode", "update");
        model.addAttribute("notice", notice);
        model.addAttribute("categoryList", codeService.getCodeDetailList("NOTICETAG"));
        if (notice.getFileGroupNo() != null && notice.getFileGroupNo() > 0) {
            model.addAttribute("files",
                    fileService.getFileList(notice.getFileGroupNo()));
        }
        return "cs/notice/insert";
    }

    /**
     * 수정
     */
    @PostMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    public String updateNotice(
            CsNoticePostVO notice,
            @RequestParam(value = "attachment", required = false) MultipartFile[] attachments,
            @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
            RedirectAttributes ra
    ) {
        CsNoticePostVO existing = noticeService.getNotice(notice.getPostId());
        int originalFileGroupNo = existing.getFileGroupNo() == null ? 0 : existing.getFileGroupNo();

        boolean hasNewFiles = attachments != null
                && attachments.length > 0
                && attachments[0] != null
                && !attachments[0].isEmpty();
        boolean editorGroupChanged = ckFileGroupNo > 0 && ckFileGroupNo != originalFileGroupNo;

        long finalGroupNo;
        if (hasNewFiles) {
            long base = (ckFileGroupNo > 0) ? ckFileGroupNo : 0L;
            finalGroupNo = fileService.uploadFiles(attachments, "attachment", base);
        } else if (editorGroupChanged) {
            finalGroupNo = ckFileGroupNo;
        } else {
            finalGroupNo = originalFileGroupNo;
        }

        notice.setFileGroupNo((int) finalGroupNo);

        noticeService.modifyNotice(notice);
        ra.addFlashAttribute("msg", "수정되었습니다.");

        return "redirect:/cs/notice/detail?postId=" + notice.getPostId();
    }

    @PostMapping("/delete")
    @PreAuthorize("hasRole('ADMIN')")
    public String delete(@RequestParam int postId, RedirectAttributes ra) {
        int n = noticeService.delete(postId);
        ra.addFlashAttribute("msg", n > 0 ? "삭제되었습니다." : "삭제에 실패했습니다.");
        return "redirect:/cs/notice";
    }

}
