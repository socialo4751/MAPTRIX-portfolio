package kr.or.ddit.common.config.error;

import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.stream.Collectors;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    // ===================================================================================
    // 400 Bad Request
    // ===================================================================================

    /**
     * @Valid 유효성 검사 실패 시
     */
    @ExceptionHandler(value = MethodArgumentNotValidException.class, produces = "text/html")
    public String handleValidationForHtml(MethodArgumentNotValidException e, Model model) {
        log.warn("HTML - Validation error: {}", e.getMessage());
        String errorMessage = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> fieldError.getField() + ": " + fieldError.getDefaultMessage())
                .collect(Collectors.joining(", "));
        model.addAttribute("errorMessage", errorMessage);
        return "error/400";
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleValidationForJson(MethodArgumentNotValidException e) {
        log.warn("JSON - Validation error: {}", e.getMessage());
        ErrorResponse response = ErrorResponse.of(HttpStatus.BAD_REQUEST, e.getBindingResult());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    /**
     * 부적절한 인자 값 전달
     */
    @ExceptionHandler(value = IllegalArgumentException.class, produces = "text/html")
    public String handleIllegalArgumentForHtml(IllegalArgumentException e, Model model) {
        log.warn("HTML - Illegal argument: {}", e.getMessage());
        model.addAttribute("errorMessage", e.getMessage());
        return "error/400";
    }

    @ExceptionHandler(value = IllegalArgumentException.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleIllegalArgumentForJson(IllegalArgumentException e) {
        log.warn("JSON - Illegal argument: {}", e.getMessage());
        ErrorResponse response = ErrorResponse.of(HttpStatus.BAD_REQUEST, e.getMessage());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    // ===================================================================================
    // 403 Forbidden
    // ===================================================================================

    @ExceptionHandler(value = AccessDeniedException.class, produces = "text/html")
    public String handleAccessDeniedForHtml(AccessDeniedException e, Model model) {
        log.warn("HTML - Access denied: {}", e.getMessage());
        model.addAttribute("errorMessage", "요청하신 페이지에 접근할 권한이 없습니다.");
        return "error/403";
    }

    @ExceptionHandler(value = AccessDeniedException.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleAccessDeniedForJson(AccessDeniedException e) {
        log.warn("JSON - Access denied: {}", e.getMessage());
        ErrorResponse response = ErrorResponse.of(HttpStatus.FORBIDDEN, "접근 권한이 없습니다.");
        return new ResponseEntity<>(response, HttpStatus.FORBIDDEN);
    }

    // ===================================================================================
    // 404 Not Found
    // ===================================================================================

    /**
     * 존재하지 않는 URL 요청
     */
    @ExceptionHandler(value = NoHandlerFoundException.class, produces = "text/html")
    public String handleNoHandlerFoundForHtml(NoHandlerFoundException e, Model model) {
        log.warn("HTML - No handler found: {}", e.getMessage());
        model.addAttribute("errorMessage", "요청하신 페이지를 찾을 수 없습니다.");
        return "error/404";
    }

    @ExceptionHandler(value = NoHandlerFoundException.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleNoHandlerFoundForJson(NoHandlerFoundException e) {
        log.warn("JSON - No handler found: {}", e.getMessage());
        ErrorResponse response = ErrorResponse.of(HttpStatus.NOT_FOUND, "요청하신 API를 찾을 수 없습니다.");
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }
    
    // ===================================================================================
    // 500 Internal Server Error
    // ===================================================================================

    /**
     * 데이터베이스 오류
     */
    @ExceptionHandler(value = DataAccessException.class, produces = "text/html")
    public String handleDatabaseErrorForHtml(DataAccessException e, Model model) {
		log.error("HTML - Database error", e);
        model.addAttribute("errorMessage", "데이터베이스 처리 중 오류가 발생했습니다.");
        return "error/500";
    }

    @ExceptionHandler(value = DataAccessException.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleDatabaseErrorForJson(DataAccessException e) {
		log.error("JSON - Database error", e);
        ErrorResponse response = ErrorResponse.of(HttpStatus.INTERNAL_SERVER_ERROR, "데이터베이스 오류가 발생했습니다.");
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    
    /**
     * 그 외 모든 예측 못한 서버 내부 오류
     */
    @ExceptionHandler(value = Exception.class, produces = "text/html")
    public String handleAllExceptionForHtml(Exception e, Model model) {
        model.addAttribute("errorMessage", "서버 내부에 알 수 없는 오류가 발생했습니다.");
        return "error/500";
    }

    @ExceptionHandler(value = Exception.class, produces = "application/json")
    public ResponseEntity<ErrorResponse> handleAllExceptionForJson(Exception e) {
		/* log.error("JSON - Unexpected server error", e); */
        ErrorResponse response = ErrorResponse.of(HttpStatus.INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}