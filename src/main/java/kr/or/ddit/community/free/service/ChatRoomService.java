package kr.or.ddit.community.free.service;

import kr.or.ddit.community.free.vo.ChatRoomsVO;

public interface ChatRoomService {

	ChatRoomsVO findRoomByBizCode(String bizCodeId);

	int createRoom(ChatRoomsVO newRoom);

}
