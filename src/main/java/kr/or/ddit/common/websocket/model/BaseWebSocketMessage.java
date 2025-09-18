package kr.or.ddit.common.websocket.model;

import java.util.Date;

/**
 * @class Name : BaseWebSocketMessage.java
 * @description : 모든 웹소켓 메시지의 기반이 되는 추상 클래스.
 * 공통 속성(메시지 타입, 생성 시각 등)을 정의합니다.
 */
public abstract class BaseWebSocketMessage {

    private final String messageType;
    private final Date timestamp;

    public BaseWebSocketMessage() {
        // 클래스의 간단한 이름을 메시지 타입으로 자동 설정 (예: "ChatMessage")
        this.messageType = this.getClass().getSimpleName();
        this.timestamp = new Date();
    }

    public String getMessageType() {
        return messageType;
    }

    public Date getTimestamp() {
        return timestamp;
    }
}