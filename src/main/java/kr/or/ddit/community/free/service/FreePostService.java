package kr.or.ddit.community.free.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.community.free.vo.CommFreePostVO;

public interface FreePostService {

    /**
     * 특정 업종의 게시글 목록을 페이징 및 검색 조건에 맞춰 조회합니다.
     */
    List<CommFreePostVO> getPostsByBizCode(String bizCodeId, int currentPage, int size, String keyword);

    /**
     * 특정 업종의 전체 게시글 수를 검색 조건에 맞춰 조회합니다.
     */
    int getPostCountByBizCode(String bizCodeId, String keyword);

    /**
     * 새 게시글을 생성합니다. (파일 첨부 로직은 별도 처리)
     * @param postVO 게시글 데이터
     */
    void createPost(CommFreePostVO postVO, MultipartFile attachment[]);


    /**
     * 특정 게시글의 상세 내용을 조회하고 조회수를 증가시킵니다.
     */
    CommFreePostVO getPostByIdWithViewCount(int postId);

    /**
     * 기존 게시글을 수정합니다.
     * @param postVO 수정할 게시글 데이터 (postId, title, content)
     * @param currentUserId 현재 로그인한 사용자 ID (권한 확인용)
     * @throws IllegalAccessException 권한이 없을 경우 발생
     */
    void updatePost(CommFreePostVO postVO, MultipartFile attachment[]) throws IllegalAccessException;

    /**
     * 특정 게시글을 삭제합니다.
     * @param postId 삭제할 게시글 ID
     * @param currentUserId 현재 로그인한 사용자 ID (권한 확인용)
     * @param userRole 현재 로그인한 사용자 역할 (관리자 권한 확인용)
     * @throws IllegalAccessException 권한이 없을 경우 발생
     */
    void deletePost(int postId, String currentUserId,  String userRole) throws IllegalAccessException;
    
    CommFreePostVO getLatestFreePost();
}