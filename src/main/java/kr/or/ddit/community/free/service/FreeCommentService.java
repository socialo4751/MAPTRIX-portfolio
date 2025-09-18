package kr.or.ddit.community.free.service;

import java.util.List;

import kr.or.ddit.community.free.vo.CommFreeCommentVO;
import kr.or.ddit.community.free.vo.CommFreePostVO;

public interface FreeCommentService {

    /**
     * 새로운 댓글을 작성하고 데이터베이스에 저장합니다.
     * @param commentVO 작성할 댓글 정보 VO
     */
    void createComment(CommFreeCommentVO commentVO);

    /**
     * 특정 게시글 ID에 속한 모든 댓글 목록을 조회합니다.
     * @param postId 댓글을 조회할 게시글 ID
     * @return 댓글 목록
     */
    List<CommFreeCommentVO> getCommentsByPostId(int postId);

    /**
     * 댓글 정보를 업데이트합니다.
     * @param commentVO 업데이트할 댓글 정보 VO (commentId, content)
     * @param currentUserId 현재 로그인한 사용자 ID (권한 확인용)
     * @throws IllegalAccessException 권한이 없을 경우 발생
     */
    void updateComment(CommFreeCommentVO commentVO, String currentUserId) throws IllegalAccessException;

    /**
     * 특정 댓글을 삭제합니다.
     * @param commentId 삭제할 댓글 ID
     * @param currentUserId 현재 로그인한 사용자 ID (권한 확인용)
     * @param userRole 현재 로그인한 사용자 역할 (관리자 권한 확인용)
     * @throws IllegalAccessException 권한이 없을 경우 발생
     */
    void deleteComment(int commentId, String currentUserId, String userRole) throws IllegalAccessException;

    /**
     * 특정 댓글 ID에 해당하는 단일 댓글 정보를 조회합니다.
     */
    CommFreeCommentVO getCommentById(int commentId);
    
 
    
}