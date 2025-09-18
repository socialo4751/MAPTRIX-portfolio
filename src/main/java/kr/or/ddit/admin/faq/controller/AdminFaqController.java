package kr.or.ddit.admin.faq.controller;

import kr.or.ddit.common.code.service.CodeService;
import kr.or.ddit.common.code.vo.CodeDetailVO;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.cs.faq.service.CsFaqService;
import kr.or.ddit.cs.faq.vo.CsFaqVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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

@Controller
@RequestMapping("/admin/faq")
@PreAuthorize("hasRole('ADMIN')")
public class AdminFaqController {

    private static final int PAGE_SIZE = 10;

    private final CsFaqService csFaqService;
    private final CodeService codeService;
    private final FileService fileService;

    @Autowired
    public AdminFaqController(CsFaqService csFaqService, CodeService codeService, FileService fileService) {
        this.csFaqService = csFaqService;
        this.codeService = codeService;
        this.fileService = fileService;
    }

    // 목록(검색+페이징)
    @GetMapping
    public String list(@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
                       @RequestParam(value = "catCodeId", required = false) String catCodeId,
                       @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
                       Model model) {

        // 카테고리 코드(FAQTAG)
        List<CodeDetailVO> catCodes = codeService.getCodeDetailList("FAQTAG");
        model.addAttribute("codeDetails", catCodes);

        Map<String, Object> map = new HashMap<>();
        if (catCodeId != null && !catCodeId.isEmpty()) map.put("catCodeId", catCodeId);
        if (keyword != null && !keyword.isEmpty()) map.put("keyword", keyword);

        int total = csFaqService.getFaqCount(map);

        int startRow = (currentPage - 1) * PAGE_SIZE + 1;
        int endRow = currentPage * PAGE_SIZE;
        map.put("startRow", startRow);
        map.put("endRow", endRow);

        List<CsFaqVO> list = csFaqService.getPagedFaqList(map);

        // ArticlePage 시그니처: (total, currentPage, size, content, keyword)
        ArticlePage<CsFaqVO> page = new ArticlePage<>(total, currentPage, PAGE_SIZE, list, keyword);

        // 검색유지 URL
        StringBuilder url = new StringBuilder("/admin/faq");
        boolean first = true;
        if (catCodeId != null && !catCodeId.isEmpty()) {
            url.append(first ? "?" : "&")
                    .append("catCodeId=").append(URLEncoder.encode(catCodeId, StandardCharsets.UTF_8));
            first = false;
        }
        if (keyword != null && !keyword.isEmpty()) {
            url.append(first ? "?" : "&")
                    .append("keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
        }
        page.setUrl(url.toString()); // ★ 꼭 호출

        model.addAttribute("articlePage", page);
        model.addAttribute("catCodeId", catCodeId);
        model.addAttribute("keyword", keyword);

        return "admin/faq/list";
    }

    // 상세: 파일그룹이 있으면 파일 리스트 주입
    @GetMapping("/detail")
    public String detail(@RequestParam int faqId, Model model) {
        CsFaqVO faq = csFaqService.getFaqById(faqId);
        model.addAttribute("faq", faq);

        if (faq.getFileGroupNo() != null && faq.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(faq.getFileGroupNo());
            model.addAttribute("files", files);
            model.addAttribute("fileList", files); // JSP 호환용
        }
        return "admin/faq/detail";
    }

    // 등록 폼
    @GetMapping("/insert")
    public String showInsertForm(Model model) {
        model.addAttribute("faq", new CsFaqVO());
        model.addAttribute("mode", "insert");
        model.addAttribute("codeDetails", codeService.getCodeDetailList("FAQTAG"));
        return "admin/faq/form";
    }

    // ★ 등록 처리 - 공지와 동일한 합치기 로직
    @PostMapping("/insert")
    public String insert(CsFaqVO faq,
                         @RequestParam(value = "attachment", required = false) MultipartFile[] attachments,
                         @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
                         RedirectAttributes ra, Model model) {

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
        if (finalGroupNo > 0) faq.setFileGroupNo((int) finalGroupNo);

        csFaqService.createFaq(faq);
        ra.addFlashAttribute("msg", "FAQ가 등록되었습니다.");
        return "redirect:/admin/faq";
    }

    // 수정 폼
    @GetMapping("/update")
    public String showUpdateForm(@RequestParam int faqId, Model model) {
        CsFaqVO faq = csFaqService.getFaqById(faqId);
        model.addAttribute("faq", faq);
        model.addAttribute("mode", "update");
        model.addAttribute("codeDetails", codeService.getCodeDetailList("FAQTAG"));

        if (faq.getFileGroupNo() != null && faq.getFileGroupNo() > 0) {
            List<FileDetailVO> files = fileService.getFileList(faq.getFileGroupNo());
            model.addAttribute("files", files);
            model.addAttribute("fileList", files);
        }
        return "admin/faq/form"; // 폼 재사용
    }

    // ★ 수정 처리 - 공지와 동일
    @PostMapping("/update")
    public String update(CsFaqVO faq,
                         @RequestParam(value = "attachment", required = false) MultipartFile[] attachments,
                         @RequestParam(value = "ckFileGroupNo", defaultValue = "0") long ckFileGroupNo,
                         RedirectAttributes ra) {

        CsFaqVO existing = csFaqService.getFaqById(faq.getFaqId());
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

        faq.setFileGroupNo((int) finalGroupNo);
        csFaqService.updateFaq(faq);
        ra.addFlashAttribute("msg", "FAQ가 수정되었습니다.");
        return "redirect:/admin/faq/detail?faqId=" + faq.getFaqId();
    }

    // 삭제는 소프트 삭제 (DEL_YN='Y')
    @PostMapping("/delete")
    public String delete(@RequestParam int faqId, RedirectAttributes ra) {
        int cnt = csFaqService.deleteFaq(faqId);
        ra.addFlashAttribute("msg", cnt > 0 ? "FAQ가 삭제되었습니다." : "삭제 실패");
        return "redirect:/admin/faq";
    }

}
