package kr.or.ddit.community.free.service.impl;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.community.free.mapper.ChatMapper;
import kr.or.ddit.community.free.service.ChatRoomService;
import kr.or.ddit.community.free.vo.ChatRoomsVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 만들어줍니다.
public class ChatRoomServiceImpl implements ChatRoomService {
	
	private final ChatMapper chatMapper; // @Autowired 대신 생성자 주입 방식 추천

	  @Override
	    public ChatRoomsVO findRoomByBizCode(String bizCodeId) {
	        return chatMapper.selectRoomByBizCode(bizCodeId);
	}
	
	    @Override // 여기에도 @Override를 붙여주세요.
	    @Transactional
	    public int createRoom(ChatRoomsVO room) {
	        return chatMapper.insertRoom(room);
	    }
}
