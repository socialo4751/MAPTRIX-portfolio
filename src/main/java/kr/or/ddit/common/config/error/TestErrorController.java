package kr.or.ddit.common.config.error;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class TestErrorController {

    /**
     * 400 - IllegalArgumentException을 강제로 발생시키는 메서드
     * @param value 0보다 작은 값을 전달하면 예외 발생
     */
    @GetMapping("/test/400")
    public String test400Error(@RequestParam("value") int value) {
        if (value < 0) {
            // 의도적으로 부적절한 인자 예외를 발생시킴
            throw new IllegalArgumentException("Value는 0 이상이어야 합니다. 입력된 값: " + value);
        }
        return "ok"; // 정상 처리 시 "ok" 뷰 반환 (실제로는 만들 필요 없음)
    }

    /**
     * 500 - NullPointerException을 강제로 발생시키는 메서드
     */
    @GetMapping("/test/500")
    public String test500Error() {
        // 의도적으로 NullPointerException을 발생시킴
        String data = null;
        data.length(); // null 객체의 메서드를 호출하여 에러 발생

        return "ok"; // 이 코드는 실행되지 않음
    }
}