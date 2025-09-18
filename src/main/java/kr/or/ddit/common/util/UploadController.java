package kr.or.ddit.common.util;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.server.ResponseStatusException;

import kr.or.ddit.common.file.mapper.FileMapper;
import kr.or.ddit.common.file.service.FileService;
import kr.or.ddit.common.file.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

/**
 * 프로젝트 전역에서 사용되는 파일 관련 웹 요청을 처리하는 공용 컨트롤러입니다.
 * 이 컨트롤러는 CKEditor의 '미리보기' 이미지 업로드와 전사적인 '파일 다운로드' 기능만을 담당합니다.
 * 실제 게시글과 파일을 연결하는 비즈니스 로직은 각 게시판의 Controller(예: NoticeController)에 있습니다.
 */
@Slf4j
@Controller
public class UploadController {

    @Autowired
    FileService fileService;

    @Autowired
    FileMapper fileMapper;
    /**
     * application.properties에 정의된 파일 업로드 경로를 주입받습니다.
     */
    @Value("${file.upload-dir}")
    private String uploadDir;

    /**
     * 파일 다운로드를 처리하는 공용 메소드입니다.
     *
     * @param fileName /연/월/일/파일명.jpg 형식의 파일 경로
     * @return 다운로드할 파일 데이터가 포함된 ResponseEntity
     */
    @ResponseBody
    @GetMapping("/download")
    public ResponseEntity<Resource> download(@RequestParam String fileName) {
        log.info("다운로드 요청 파일: {}", fileName);

        // 실제 파일 시스템 경로와 조합하여 리소스 객체 생성
        Resource resource = new FileSystemResource(uploadDir + File.separator + fileName);

        if (!resource.exists()) {
            log.error("파일을 찾을 수 없습니다: {}", fileName);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        // UUID가 포함된 파일 이름에서 원본 파일 이름만 추출
        String resourceName = resource.getFilename();
        String originalFileName = resourceName.substring(resourceName.indexOf("_") + 1);

        // 다운로드 시 한글 파일명이 깨지는 것을 방지하기 위한 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        try {
            String downloadName = new String(originalFileName.getBytes("UTF-8"), "ISO-8859-1");
            headers.add("Content-Disposition", "attachment; filename=" + downloadName);
        } catch (UnsupportedEncodingException e) {
            log.error("파일명 인코딩 오류: {}", e.getMessage());
        }

        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }

    /**
     * CKEditor의 '이미지 업로드' 플러그인 요청을 처리합니다.
     * FileService를 호출하여 파일을 저장하고, 저장된 파일의 URL과 그룹 번호를
     * CKEditor에 맞는 JSON 형식으로 반환하여 에디터에 이미지가 보이게 합니다.
     *
     * @param request MultipartHttpServletRequest
     * @return CKEditor가 요구하는 JSON 형식의 응답 (uploaded, url, groupNo 포함)
     */
    @ResponseBody
    @PostMapping("/image/upload")
    public Map<String, Object> imageUpload(
            @RequestParam(name="editorGroupNo", required=false) Long editorGroupNo,
            MultipartHttpServletRequest request
    ) throws IOException {
        MultipartFile uploadFile = request.getFile("upload");
        if (uploadFile == null || uploadFile.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "업로드할 파일이 없습니다.");
        }

        // [수정] FileDetailVO 객체를 직접 반환받음
        FileDetailVO savedFile = fileService.saveEditorImage(uploadFile, editorGroupNo);

        // [삭제] fileMapper.selectOneLocate(...) 로직 전체 삭제
        
        // [수정] 반환받은 객체의 정보를 사용하여 JSON 응답 생성
        return Map.of(
                "uploaded", true,
                "url", savedFile.getFileSaveLocate(),
                "groupNo", savedFile.getFileGroupNo()
        );
    }


    /**
     * 현재 날짜를 기반으로 'yyyy/MM/dd' 형식의 폴더 경로를 생성합니다.
     *
     * @return 날짜 형식의 폴더 경로 문자열
     */
    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String str = sdf.format(new Date());
        return str.replace("-", File.separator);
    }
}
