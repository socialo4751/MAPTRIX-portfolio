package kr.or.ddit.gemini.test.dto.example;

import java.util.Collections;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;

// 제미나이 API에 요청을 보낼 때 사용할 DTO
@Getter
public class GeminiRequestDto {
    private final List<Content> contents;

    public GeminiRequestDto(String prompt) {
        this.contents = Collections.singletonList(new Content(prompt));
    }

    @Getter
    @AllArgsConstructor
    private static class Content {
        private final List<Part> parts;

        public Content(String prompt) {
            this.parts = Collections.singletonList(new Part(prompt));
        }
    }

    @Getter
    @AllArgsConstructor
    private static class Part {
        private final String text;
    }
}