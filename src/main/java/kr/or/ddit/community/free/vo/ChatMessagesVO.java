package kr.or.ddit.community.free.vo;

import java.util.Date;

import lombok.Data;

/**
 * 채팅 메시지 정보를 담기 위한 VO 클래스
 */
@Data
public class ChatMessagesVO {
    private int msgId; // 메세지일련번호
    private int roomId; // 채팅방번호
    private String senderId; // 보낸사람ID
    private String content; // 내용
    private Date sentAt; // 발송일시
    private String senderNickname;//메시지닉네임
}
