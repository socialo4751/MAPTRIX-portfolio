package kr.or.ddit.admin.notice.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.util.UploadController;
import kr.or.ddit.cs.notice.service.CsNoticePostService;
import kr.or.ddit.cs.notice.vo.CsNoticePostVO;
import kr.or.ddit.user.signin.service.impl.CustomUser;

@Controller
@RequestMapping("/admin/notice")
@PreAuthorize("hasRole('ADMIN')")
public class AdminNoticeController {

    private static final int PAGE_SIZE = 10;

    private final CsNoticePostService noticeService;
    private final UploadController uploadController;
    private final FileService fileService;
    private final CodeService codeService;

    @Autowired
    public AdminNoticeController(CsNoticePostService noticeService,
                                 UploadController uploadController,
                                 FileService fileService,
                                 CodeService codeService) {
        this.noticeService = noticeService;
        this.uploadController = uploadController;
        this.fileService = fileService;
        this.codeService = codeService;
    }

    // ✅ 목록
    @GetMapping
    public String list(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
                       @RequestParam(value = "catCodeId", required = false) String catCodeId,
                       @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                       Model model) {

        List<CodeDetailVO> catCodes = codeService.getCodeDetailList("NOTICETAG");
        model.addAttribute("codeDetails", catCodes);

        Map<String, Object> map = new HashMap<>();
        if (catCodeId != null && !catCodeId.isEmpty()) map.put("catCodeId", catCodeId);
        if (keyword != null && !keyword.isEmpty())   map.put("keyword", keyword);

        int total = noticeService.getNoticeCount(map);

        int startRow = (currentPage - 1) * PAGE_SIZE + 1;
        int endRow   = currentPage * PAGE_SIZE;
        map.put("startRow", startRow);
        map.put("endRow", endRow);

        List<CsNoticePostVO> list = noticeService.getNoticeList(map);

        ArticlePage<CsNoticePostVO> page =
                new ArticlePage<>(total, currentPage, PAGE_SIZE, list, keyword);

        // 검색 유지 URL
        StringBuilder url = new StringBuilder("/admin/notice");
        boolean first = true;
        if (catCodeId != null && !catCodeId.isEmpty()) {
            url.append(first ? "?" : "&").append("catCodeId=").append(catCodeId);
            first = false;
        }
        if (keyword != null && !keyword.isEmpty()) {
            url.append(first ? "?" : "&").append("keyword=").append(keyword);
        }
        page.setUrl(url.toString());

        model.addAttribute("articlePage", page);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("keyword", keyword);

        return "admin/board/notice/list";
    }

    // ✅ 상세보기
    @GetMapping("/detail")
    public String showNoticeDetail(@RequestParam("postId") int postId, Model model) {
        noticeService.increaseViewCount(postId);
        CsNoticePostVO notice = noticeService.getNotice(postId);
        model.addAttribute("notice", notice);

        if (notice.getFileGroupNo() != null && notice.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(notice.getFileGroupNo());
            model.addAttribute("files", files);     // A
            model.addAttribute("fileList", files);  // B (JSP가 이 이름을 기대할 수도 있음)
        }

        return "admin/board/notice/detail";
    }

    // ✅ 등록 폼
// 등록 폼
    @GetMapping("/insert")
    public String showInsertForm(Model model) {
        model.addAttribute("notice", new CsNoticePostVO());
        model.addAttribute("mode", "insert");
        model.addAttribute("codeDetails", codeService.getCodeDetailList("NOTICETAG")); // 🔹 공통코드 그룹 ID
        return "admin/board/notice/insert";
    }

    // ✅ 등록 처리
    @PostMapping("/insert")
    @PreAuthorize("hasRole('ADMIN')")
    public String insertNotice(
            CsNoticePostVO notice,
            @RequestParam(value = "attachment", required = false) MultipartFile[] attachments,
            @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
            RedirectAttributes ra,
            org.springframework.security.core.Authentication authentication // ★ 추가
    ) {
        // ★ 로그인한 관리자 ID 주입
        String adminId;
        Object principal = authentication.getPrincipal();
        if (principal instanceof kr.or.ddit.user.signin.service.impl.CustomUser cu) {
            adminId = cu.getUsername();      // 보통 USER_ID
        } else if (principal instanceof org.springframework.security.core.userdetails.User u) {
            adminId = u.getUsername();
        } else {
            // 혹시 모를 케이스(익명/예외) 방어
            ra.addFlashAttribute("msg", "관리자 인증 정보를 확인할 수 없습니다.");
            return "redirect:/admin/notice/insert";
        }
        notice.setAdminId(adminId); // ★ 핵심 라인

        // (이하 파일그룹 결정 로직은 그대로)
        boolean hasNewFiles = attachments != null
                && attachments.length > 0
                && attachments[0] != null
                && !attachments[0].isEmpty();

        long finalGroupNo;
        if (hasNewFiles) {
            long base = (ckFileGroupNo > 0) ? ckFileGroupNo : 0L;
            finalGroupNo = fileService.uploadFiles(attachments, "attachment", base);
        } else if (ckFileGroupNo > 0) {
            finalGroupNo = ckFileGroupNo;
        } else {
            finalGroupNo = 0L;
        }
        if (finalGroupNo > 0) {
            notice.setFileGroupNo((int) finalGroupNo);
        }

        noticeService.createNotice(notice);
        ra.addFlashAttribute("msg", "공지사항이 등록되었습니다.");
        return "redirect:/admin/notice";
    }
    
    @GetMapping("/update")
    @PreAuthorize("hasRole('ADMIN')")
    public String showUpdateForm(@RequestParam("postId") int postId, Model model) {
        CsNoticePostVO notice = noticeService.getNotice(postId);
        model.addAttribute("notice", notice);
        model.addAttribute("mode", "update"); // insert.jsp에서 분기
        model.addAttribute("codeDetails", codeService.getCodeDetailList("NOTICETAG"));
        return "admin/board/notice/insert";  // ★ 등록폼과 같은 JSP 사용
    }

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
            // 첨부가 있으면: CK가 이미 새 그룹을 만들었으면 그 그룹에 합치고,
            // 아니라면 0을 줘서 완전히 새 그룹 생성(혼용 방지)
            long base = (ckFileGroupNo > 0) ? ckFileGroupNo : 0L;
            finalGroupNo = fileService.uploadFiles(attachments, "attachment", base);
        } else if (editorGroupChanged) {
            // 첨부는 없지만 CK 전용 그룹이 새로 생겼다면 그걸 최종 그룹으로 전환
            finalGroupNo = ckFileGroupNo;
        } else {
            // 파일 변경 없음 → 기존 그룹 유지
            finalGroupNo = originalFileGroupNo;
        }

        notice.setFileGroupNo((int) finalGroupNo);

        noticeService.modifyNotice(notice);
        ra.addFlashAttribute("msg", "공지사항이 수정되었습니다.");
        return "redirect:/admin/notice/detail?postId=" + notice.getPostId();
    }
}
