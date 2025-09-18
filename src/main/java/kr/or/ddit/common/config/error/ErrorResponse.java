package kr.or.ddit.common.config.error;

import lombok.Getter;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindingResult;

import java.time.LocalDateTime;

@Getter
public class ErrorResponse {

    private final LocalDateTime timestamp = LocalDateTime.now();
    private final int status;
    private final String error;
    private final String message;
    
    // 생성자
    private ErrorResponse(HttpStatus status, String message) {
        this.status = status.value();
        this.error = status.getReasonPhrase();
        this.message = message;
    }

    // ✨ 정적 팩토리 메서드 (static factory method)
    // 이 부분을 추가하면 .of()를 사용할 수 있습니다.
    public static ErrorResponse of(HttpStatus status, String message) {
        return new ErrorResponse(status, message);
    }
    
    // (선택) 유효성 검사 에러를 위한 정적 팩토리 메서드
    public static ErrorResponse of(HttpStatus status, BindingResult bindingResult) {
        // 유효성 검사에서 어떤 필드가 잘못되었는지 상세 메시지를 생성
        String errorMessage = bindingResult.getFieldErrors().stream()
            .map(fieldError -> fieldError.getField() + ": " + fieldError.getDefaultMessage())
            .reduce((s1, s2) -> s1 + ", " + s2)
            .orElse("유효성 검사 실패");

        return new ErrorResponse(status, errorMessage);
    }
}