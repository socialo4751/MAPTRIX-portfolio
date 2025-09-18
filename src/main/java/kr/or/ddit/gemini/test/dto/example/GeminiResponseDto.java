package kr.or.ddit.gemini.test.dto.example;

import java.util.List;
import java.util.Optional;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Gemini API로부터 받은 JSON 응답을 담기 위한 DTO입니다.
 */
@Getter
@NoArgsConstructor
// [핵심 수정] 최상위 레벨에 오는 모르는 필드(예: usageMetadata)도 무시하도록 설정합니다.
@JsonIgnoreProperties(ignoreUnknown = true)
public class GeminiResponseDto {

    /**
     * API 응답의 최상위 필드인 'candidates' 리스트를 담습니다.
     */
    private List<Candidate> candidates;

    /**
     * API 응답의 'candidates' 배열 안에 있는 각 답변 후보 객체를 나타냅니다.
     */
    @Getter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Candidate {
        private Content content;
    }

    /**
     * 답변 후보(Candidate) 안에 있는 실제 내용(content) 객체를 나타냅니다.
     */
    @Getter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Content {
        private List<Part> parts;
        private String role;
    }

    /**
     * 실제 텍스트 답변이 담겨있는 부분(Part)을 나타냅니다.
     */
    @Getter
    @NoArgsConstructor
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class Part {
        private String text;
    }

    /**
     * 복잡한 응답 구조 속에서 최종 텍스트 답변을 쉽고 안전하게 꺼내기 위한 편의 메서드입니다.
     */
    public String getGeneratedText() {
        return Optional.ofNullable(this.candidates)
                .flatMap(c -> c.stream().findFirst())
                .map(Candidate::getContent)
                .flatMap(content -> Optional.ofNullable(content.getParts()))
                .flatMap(parts -> parts.stream().findFirst())
                .map(Part::getText)
                .orElse("");
    }
}
