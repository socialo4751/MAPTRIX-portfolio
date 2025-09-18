package kr.or.ddit.community.free.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;


import org.springframework.ui.Model;
import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.service.ChatRoomService;
import kr.or.ddit.community.free.vo.ChatMessagesVO;
import kr.or.ddit.community.free.vo.ChatRoomsVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
/*
@Slf4j
@Controller
@RequestMapping("/comm/free")
@RequiredArgsConstructor
public class OpenChatRoomController {
	private final ChatRoomService chatRoomService;
    private final ChatMessageService chatMessageService;
    // 업종 정보 조회를 위해 CodeBizService도 필요할 수 있습니다.
    // private final CodeBizService codeBizService;

    @GetMapping("/{bizCodeId}/chat")
    public String openChatRoom(@PathVariable("bizCodeId") String bizCodeId, Model model) {
        log.info("======================================================");
        log.info("1. 업종별 채팅방 요청 시작. bizCodeId: {}", bizCodeId);

        // 1. bizCodeId로 채팅방 조회
        ChatRoomsVO room = chatRoomService.findRoomByBizCode(bizCodeId);
        log.info("2. DB에서 bizCodeId로 조회한 room 객체: {}", room);

        // 2. 채팅방이 없으면 새로 생성
        if (room == null) {
            log.info("3. 채팅방이 없으므로 새로 생성합니다.");
            ChatRoomsVO newRoom = new ChatRoomsVO();
            newRoom.setBizCodeId(bizCodeId);
            
            String roomName = bizCodeId + " 정보 공유방";
            newRoom.setRoomName(roomName);
            
            log.info("4. DB에 INSERT 하기 전 newRoom 객체: {}", newRoom);
            
            // ★★★ 가장 중요한 부분 ★★★
            // createRoom 실행 후 newRoom 객체에 roomId가 채워지는지 확인
            chatRoomService.createRoom(newRoom); 
            
            log.info("5. DB에 INSERT 한 후 newRoom 객체: {}", newRoom);
            
            room = newRoom; // 새로 생성된 방 정보를 사용
        }

        // 3. 해당 방의 기존 메시지 내역 조회
        // 만약 여기서 NullPointerException이 발생한다면 room 객체가 여전히 null이라는 의미입니다.
        if (room == null || room.getRoomId() == 0) {
            log.error("6. FATAL: room 객체가 null이거나 roomId가 0입니다. JSP로 전달할 수 없습니다.");
            // 에러 페이지를 보여주거나, 에러 메시지를 모델에 담아 전달할 수 있습니다.
            model.addAttribute("errorMessage", "채팅방 정보를 가져오는 데 심각한 오류가 발생했습니다.");
            return "community/openChat"; // 또는 에러 페이지
        }
        
        List<ChatMessagesVO> messageHistory = chatMessageService.getMessageHistory(room.getRoomId());
        
        log.info("6. 최종적으로 JSP에 전달될 room 객체: {}", room);
        log.info("7. 조회된 메시지 내역 개수: {}", messageHistory.size());
        log.info("======================================================");

        // 4. Model에 데이터 추가하여 View로 전달
        model.addAttribute("room", room); 
        model.addAttribute("messageHistory", messageHistory); 

        return "comm/free/boardAndChat";
    }
}
*/