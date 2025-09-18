package kr.or.ddit.common.file.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.common.file.mapper.FileMapper;
import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.file.vo.FileGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileService {

    // application.properties에 설정된 파일 저장 물리 경로를 주입받습니다. (예: C:/uploads)
    @Value("${file.upload-dir}")
    private String uploadDir;

    // 파일 관련 데이터베이스 작업을 위한 MyBatis 매퍼를 주입받습니다.
    @Autowired
    private FileMapper fileMapper;

    /**
     * 이 메소드는 외부에서 간단하게 호출할 수 있도록 제공되며, 내부적으로는 더 상세한 로직을 가진
     * 아래의 오버로딩된 uploadFiles 메소드를 호출합니다.
     */
    @Transactional
    public long uploadFiles(MultipartFile[] files, String fileRole) {
        // 기존 파일 그룹이 없다는 의미로, 세 번째 인자에 0L을 넘겨 새로운 그룹을 생성하도록 위임합니다.
        return this.uploadFiles(files, fileRole, 0L);
    }

    /**
     * 파일을 업로드하고 DB에 저장합니다. NoticeController의 핵심 파일 처리 로직을 담당합니다.
     * existingGroupNo가 주어지면 해당 그룹에 파일을 추가하고, 없으면 새로운 그룹을 생성합니다.
     *
     * @param files           업로드할 파일 배열
     * @param fileRole        파일 역할 (e.g., "attachment", "thumbnail")
     * @param existingGroupNo NoticeController로부터 전달받은 기존 파일 그룹 번호.
     * CKEditor 사용 시 해당 그룹 번호가, 미사용 시 0이 전달됩니다.
     * @return 최종적으로 사용된 파일 그룹 번호
     */
    @Transactional
    public long uploadFiles(MultipartFile[] files, String fileRole, long existingGroupNo) {
        // 1. 업로드된 파일이 실제로 존재하는지 확인합니다.
        boolean hasAny = false;
        if (files != null) {
            for (MultipartFile f : files) {
                if (f != null && !f.isEmpty()) {
                    hasAny = true; // 파일이 하나라도 있으면 true로 변경하고 반복 종료
                    break;
                }
            }
        }

        // 2. 업로드된 파일이 없으면, 불필요한 작업을 중단하고 기존 그룹 번호를 그대로 반환합니다.
        if (!hasAny) {
            return existingGroupNo;
        }

        // 3. 파일을 저장할 그룹 번호를 결정합니다.
        long groupNo = existingGroupNo;
        if (groupNo <= 0) {
            // 기존 그룹 번호가 유효하지 않으면(0 이하), 데이터베이스에서 새로운 파일 그룹을 생성합니다.
            FileGroupVO fg = new FileGroupVO();
            fileMapper.insertFileGroup(fg); // 이 호출 후 fg 객체에 DB 시퀀스로 생성된 fileGroupNo가 담깁니다.
            groupNo = fg.getFileGroupNo();
        }

        // 4. 각 파일을 순회하며 저장 처리합니다.
        for (MultipartFile mf : files) {
            if (mf == null || mf.isEmpty()) continue; // 비어있는 파일은 건너뜁니다.

            // 4-1. 파일을 저장할 날짜 기반 폴더 경로를 생성합니다. (예: 2025/07/23)
            String datePath = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).replace("-", File.separator);
            File uploadPath = new File(uploadDir, datePath);
            if (!uploadPath.exists()) {
                uploadPath.mkdirs(); // 폴더가 존재하지 않으면 생성합니다.
            }

            // 4-2. 저장할 파일명을 생성합니다. (UUID를 사용하여 파일명 중복 방지)
            String orig = mf.getOriginalFilename(); // 원본 파일명
            String ext = orig.substring(orig.lastIndexOf('.')); // 확장자
            String save = UUID.randomUUID().toString() + "_" + orig; // "UUID_원본파일명" 형태의 새로운 파일명

            try {
                // 4-3. 파일을 실제 물리 경로에 저장합니다.
                mf.transferTo(new File(uploadPath, save));

                // 4-4. 웹에서 접근할 수 있는 URL 경로를 생성합니다. (WebConfig 설정과 연관)
                String webPath = "/media/" + datePath.replace(File.separator, "/") + "/" + save;

                // 4-5. 데이터베이스에 저장할 파일 상세 정보를 VO 객체에 담습니다.
                FileDetailVO detail = new FileDetailVO();
                detail.setFileGroupNo(groupNo);
                detail.setFileOriginalName(orig);
                detail.setFileSaveName(save);
                detail.setFileSaveLocate(webPath);
                detail.setFileSize(mf.getSize());
                detail.setFileExt(ext);
                detail.setFileMime(mf.getContentType());
                detail.setFileRole(fileRole);

                // 4-6. 파일 상세 정보를 데이터베이스에 INSERT 합니다.
                fileMapper.insertFileDetail(detail);
            } catch (IOException e) {
                log.error("파일 저장 오류", e);
                throw new RuntimeException("파일 저장 실패", e);
            }
        }
        // 5. 모든 작업이 끝난 후, 사용된 그룹 번호를 반환합니다.
        return groupNo;
    }

    /**
     * [cite_start]특정 그룹에 속한 FileDetail 목록을 조회합니다. [cite: 5]
     */
    public List<FileDetailVO> getFileList(long fileGroupNo) {
        return fileMapper.selectFileList(fileGroupNo);
    }

    /**
     * [cite_start]CKEditor 이미지 업로드 전용 저장 메서드입니다. [cite: 5]
     *
     * [cite_start]@param file 업로드된 MultipartFile [cite: 5]
     * @param existingGroupNo 기존 파일 그룹 번호. 없으면 새로 생성합니다.
     * @return 파일 정보가 담긴 FileDetailVO 객체
     */
    @Transactional
    public FileDetailVO saveEditorImage(MultipartFile file, Long existingGroupNo) {
        // 1. 파일을 저장할 그룹 번호를 결정합니다. (uploadFiles와 로직 동일)
        long groupNo;
        if (existingGroupNo != null && existingGroupNo > 0) {
            groupNo = existingGroupNo;
        } else {
            FileGroupVO fg = new FileGroupVO();
            fileMapper.insertFileGroup(fg);
            groupNo = fg.getFileGroupNo();
        }

        // 2. 파일을 물리적으로 저장합니다. (uploadFiles와 로직 동일)
        String datePath = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).replace("-", File.separator);
        File uploadPath = new File(uploadDir, datePath);
        if (!uploadPath.exists()) uploadPath.mkdirs();

        String orig = file.getOriginalFilename();
        String ext  = orig.substring(orig.lastIndexOf('.'));
        String save = UUID.randomUUID().toString() + "_" + orig;
        try {
            file.transferTo(new File(uploadPath, save));
        } catch (IOException e) {
            throw new RuntimeException("에디터 이미지 저장 실패", e);
        }
        
        // 3. 웹에서 접근할 URL 경로를 생성합니다. (WebConfig 설정과 연관)
        String webPath = "/media/" + datePath.replace(File.separator, "/") + "/" + save;

        // 4. 데이터베이스에 저장할 파일 정보를 VO 객체에 담습니다.
        FileDetailVO detail = new FileDetailVO();
        detail.setFileGroupNo(groupNo);
        detail.setFileOriginalName(orig);
        detail.setFileSaveName(save);
        detail.setFileSaveLocate(webPath);
        detail.setFileSize(file.getSize());
        detail.setFileExt(ext);
        detail.setFileMime(file.getContentType());
        detail.setFileRole("editor"); // 에디터를 통해 업로드된 파일의 역할은 'editor'로 지정
        
        // 5. 파일 정보를 DB에 저장합니다.
        fileMapper.insertFileDetail(detail);

        // 6. 저장된 파일의 모든 정보(DB에서 생성된 fileSn 포함)가 담긴 객체를 반환합니다.
        //    이를 통해 Controller에서 불필요한 추가 DB 조회를 생략할 수 있습니다.
        return detail;
    }

}