package kr.or.ddit.community.free.service.impl;

import java.util.List;
import java.util.regex.Pattern;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import kr.or.ddit.community.free.mapper.ChatMapper;
import kr.or.ddit.community.free.service.ChatMessageService;
import kr.or.ddit.community.free.vo.ChatMessagesVO;
import kr.or.ddit.community.free.vo.ChatRoomsVO;

@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMapper chatMapper;

    @Override
    public String filterMessage(String content) {
        String[] badWords = { "욕1", "욕2" };
        String filtered = content;
        for (String word : badWords) {
            // 정규식 안전 처리 + (옵션) 단어 경계
            String regex = "(?i)" + Pattern.quote(word); // 필요시 "\\b" + ... + "\\b"
            filtered = filtered.replaceAll(regex, "***");
        }
        return filtered;
    }

    @Override
    @Transactional
    public void saveMessage(ChatMessagesVO messageVO) {
        chatMapper.insertMessage(messageVO);
    }

    @Override
    public List<ChatMessagesVO> getMessageHistory(int roomId) {
        return chatMapper.selectMessagesByRoomId(roomId);
    }
}
