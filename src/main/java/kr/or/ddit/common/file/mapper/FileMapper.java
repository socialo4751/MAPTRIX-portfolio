package kr.or.ddit.common.file.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.common.file.vo.FileDetailVO;
import kr.or.ddit.common.file.vo.FileGroupVO;

/**
 * 파일 그룹 및 파일 상세 정보의 DB 처리를 위한 공용 매퍼 인터페이스
 */
@Mapper
public interface FileMapper {

    /**
     * 파일 그룹 정보를 DB에 저장합니다.
     * 이 메소드가 실행된 후, 파라미터로 받은 fileGroupVO 객체의 fileGroupNo 필드에
     * 새로 생성된 파일 그룹 번호가 채워집니다. (selectKey에 의해)
     *
     * @param fileGroupVO fileGroupNo를 채우기 위한 객체
     * @return INSERT 성공 시 1
     */
    public int insertFileGroup(FileGroupVO fileGroupVO);

    /**
     * 파일 상세 정보를 DB에 저장합니다.
     *
     * @param fileDetailVO 저장할 파일 상세 정보
     * @return INSERT 성공 시 1
     */
    public int insertFileDetail(FileDetailVO fileDetailVO);
    /**
     * 특정 그룹의 모든 파일 상세 조회
     */
    List<FileDetailVO> selectFileList(@Param("fileGroupNo") long fileGroupNo);

    FileDetailVO selectFileDetail(
            @Param("fileGroupNo") long fileGroupNo,
            @Param("fileSn") int fileSn
    );

    String selectOneLocate(long groupNo, int i);
    
}
