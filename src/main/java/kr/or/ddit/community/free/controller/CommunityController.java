package kr.or.ddit.community.free.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.common.log.LogEvent;
import kr.or.ddit.common.vo.code.CodeBizVO;
import kr.or.ddit.common.vo.user.UsersVO;
import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.service.ChatRoomService;
import kr.or.ddit.community.free.service.CodeBizService;
import kr.or.ddit.community.free.service.VirtualNicknameService;
import kr.or.ddit.community.free.vo.ChatMessagesVO;
import kr.or.ddit.community.free.vo.ChatRoomsVO;
import kr.or.ddit.community.free.service.FreeCommentService; // <-- import 추가
import kr.or.ddit.community.free.service.FreePostService;   // <-- import 추가
import kr.or.ddit.community.free.vo.CommFreeCommentVO;     // <-- import 추가
import kr.or.ddit.community.free.vo.CommFreePostVO;         // <-- import 추가
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/comm/free")
@RequiredArgsConstructor
//커뮤니티의 메인 컨트롤러 
public class CommunityController {

    private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;
    private final CodeBizService codeBizService;
    private final VirtualNicknameService virtualNicknameService;
    private final FreePostService freePostService;
    private final FreeCommentService freeCommentService;
    
    @LogEvent(eventType="VIEW", feature="FREE")
    @GetMapping("/{bizCodeId}")
    public String showBoardAndChatPage(
            @PathVariable String bizCodeId, 
            @RequestParam(required = false) Integer postId,  // postId 파라미터 추가
            Model model) {
        
    	 if (postId != null) {
             model.addAttribute("targetPostId", postId);
         }
    	
    	List<CodeBizVO> mainCategories = codeBizService.getAllMainCategories();
        model.addAttribute("mainCategories", mainCategories);
    	
        // ▼▼▼ 여기에 유효성 검증 로직 추가 ▼▼▼
        CodeBizVO bizInfo = codeBizService.getBizInfoByCode(bizCodeId);
        
        // 유효하지 않은 bizCodeId일 경우
        if (bizInfo == null) {
            log.warn("유효하지 않은 업종 코드 ID 접근 시도: {}", bizCodeId);
            model.addAttribute("errorMessage", "유효하지 않은 업종 코드입니다.");
            return "error/404"; // 또는 적절한 오류 페이지
        }
        // ▲▲▲ 유효성 검증 로직 끝 ▲▲▲

        model.addAttribute("bizInfo", bizInfo);

        ChatRoomsVO room = chatRoomService.findRoomByBizCode(bizCodeId);
        if (room == null) {
            ChatRoomsVO newRoom = new ChatRoomsVO();
            newRoom.setBizCodeId(bizCodeId);
            // ... (기존 로직 그대로)
            if(bizInfo != null) newRoom.setRoomName(bizInfo.getBizName() + " 정보 공유방");
            else newRoom.setRoomName(bizCodeId + " 정보 공유방");
            chatRoomService.createRoom(newRoom);
            room = newRoom;
        }

        if (room != null && room.getRoomId() > 0) {
            List<ChatMessagesVO> messageHistory = chatMessageService.getMessageHistory(room.getRoomId());
            model.addAttribute("room", room);
            model.addAttribute("messageHistory", messageHistory);
        } else {
            model.addAttribute("errorMessage", "채팅방 정보를 가져오는 데 실패했습니다.");
        }
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getPrincipal())) {
            String loginUserId = auth.getName();
            model.addAttribute("loginUserId", loginUserId);

            // 1. Authentication 객체에서 직접 권한 목록을 가져옵니다. (목적 : 닉네임조회 및 모델 추가)
            String userRole = auth.getAuthorities().stream()
                                  .findFirst()
                                  .map(grantedAuthority -> grantedAuthority.getAuthority())
                                  .orElse(""); // null 대신 빈 문자열이 더 안전합니다.

            // ✨ 이 부분이 추가되었습니다: 조회한 권한(Role) 문자열을 모델에 직접 추가
            model.addAttribute("loginUserRole", userRole);

            log.info("### 디버깅: 현재 사용자 ID [{}], 권한: [{}] ###", loginUserId, userRole);

            // 2. 닉네임 조회/생성 (기존과 동일)
            if (room != null) {
                String virtualNickname = virtualNicknameService.getOrCreateVirtualNickname(loginUserId, (long) room.getRoomId(), userRole);
                model.addAttribute("virtualNickname", virtualNickname);
            }
            
            // UsersVO도 필요하다면 함께 전달 (이 코드는 유지해도 괜찮습니다)
            Object p = auth.getPrincipal();
            if (p instanceof UsersVO u) {
                model.addAttribute("loginUser", u);
            }
        }

        return "comm/free/boardAndChat";
    }
    
 // --- ★★★★★ [수정된] 게시글 상세보기를 처리하는 메서드 ★★★★★ ---
    @LogEvent(eventType="VIEW", feature="FREE_POST")
    @GetMapping("/detail/{postId}")
    public String showPostDetail(@PathVariable int postId, Model model) {
        log.info("게시글 상세보기 요청, postId: {}", postId);
        
        
        // 1. postId로 게시글 정보 조회 (제공해주신 인터페이스의 메서드 이름으로 변경)
        CommFreePostVO post = freePostService.getPostByIdWithViewCount(postId);
        if (post == null) {
            log.warn("존재하지 않는 게시글 접근 시도: postId {}", postId);
            return "error/404";
        }

        // 2. 해당 게시글의 댓글 목록 조회
        List<CommFreeCommentVO> commentList = freeCommentService.getCommentsByPostId(postId);

        // 3. 모델에 데이터 추가
        model.addAttribute("post", post);
        model.addAttribute("commentList", commentList);

        // 4. 상세 페이지 JSP로 이동
        return "comm/free/detail"; // (상세보기 JSP 파일 경로)
    }
}