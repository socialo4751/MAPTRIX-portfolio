package kr.or.ddit.community.free.vo;

import java.util.Date;

import lombok.Data;

/**
 * 채팅방 정보를 담기 위한 VO 클래스
 */
@Data
public class ChatRoomsVO {
    private int roomId; // 채팅방번호
    private String bizCodeId; // 업종 중분류 ID
    private String roomName; // 룸_네임
    private Date createdAt; // 생성일시
    private Integer capacity; // 수용인원
}
