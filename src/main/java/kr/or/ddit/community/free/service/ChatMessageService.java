package kr.or.ddit.community.free.service;


import java.util.List;

import kr.or.ddit.community.free.vo.ChatMessagesVO;

public interface ChatMessageService {
    String filterMessage(String content);                // 욕설/금칙어 필터링
    void saveMessage(ChatMessagesVO messageVO);           // 메시지 DB 저장
    List<ChatMessagesVO> getMessageHistory(int roomId);
}
