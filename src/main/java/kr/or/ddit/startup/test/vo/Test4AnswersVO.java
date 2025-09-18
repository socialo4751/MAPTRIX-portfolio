package kr.or.ddit.startup.test.vo;

import java.util.Date;

import lombok.Data;

/**
 * 창업 테스트 답변 정보를 담기 위한 VO 클래스
 */
@Data
public class Test4AnswersVO {
    private int answerId; // 답변 ID
    private int questionId; // 문항ID
    private int selOptionId; // 선택보기 ID
    private int sessionId; // 세션 ID
    private Date answeredAt; // 답변시각
}
