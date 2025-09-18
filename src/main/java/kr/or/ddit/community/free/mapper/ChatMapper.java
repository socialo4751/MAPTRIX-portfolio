package kr.or.ddit.community.free.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.community.free.vo.ChatMessagesVO;
import kr.or.ddit.community.free.vo.ChatRoomsVO;

@Mapper
public interface ChatMapper {

	    ChatRoomsVO selectRoomByBizCode(@Param("bizCodeId") String bizCodeId);
	    int insertMessage(ChatMessagesVO message);
	    List<ChatMessagesVO> selectMessagesByRoomId(@Param("roomId") int roomId);
	    int insertRoom(ChatRoomsVO room);
}