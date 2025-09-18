package kr.or.ddit.gemini.test.dto.request;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import lombok.Getter;

/**
 * Gemini API에 JSON 생성을 요청하기 위한 범용 DTO(Data Transfer Object).
 * 이 클래스는 API로 보내는 요청의 전체 구조를 정의합니다.
 * "이런 질문(prompt)에 대해, 이런 양식(schema)으로 답변해줘" 라는 '주문서' 역할을 합니다.
 */
@Getter
public class GeminiJsonRequestDto {

    /**
     * 제미나이에게 전달할 실제 질문 내용(프롬프트)을 담는 리스트입니다.
     */
    private final List<Content> contents;

    /**
     * 제미나이가 답변을 생성하는 방식을 설정하는 부분입니다.
     * "답변은 꼭 JSON으로 줘" 라던가, "답변의 구조는 이걸 따라줘" 같은 규칙을 정합니다.
     */
    private final GenerationConfig generationConfig;

    /**
     * GeminiJsonRequestDto 객체를 생성하는 생성자입니다.
     * @param prompt 사용자가 실제로 제미나이에게 할 질문 내용입니다.
     * @param schema 제미나이가 답변으로 만들어주길 바라는 JSON의 '설계도'입니다.
     */
    public GeminiJsonRequestDto(String prompt, Schema schema) {
        this.contents = Collections.singletonList(new Content(prompt));
        this.generationConfig = new GenerationConfig(schema);
    }

    // --- 내부 클래스: 요청 구조를 만들기 위한 부품들 ---

    /**
     * 질문(프롬프트)의 본문을 담는 컨테이너 클래스입니다.
     */
    @Getter
    public static class Content {
        private final List<Part> parts;
        public Content(String text) { this.parts = Collections.singletonList(new Part(text)); }
    }

    /**
     * 질문 본문의 한 조각(Part)을 나타냅니다. 현재는 텍스트만 사용합니다.
     */
    @Getter
    public static class Part {
        private final String text;
        public Part(String text) { this.text = text; }
    }

    /**
     * 답변 생성에 대한 상세 규칙을 정의하는 클래스입니다.
     */
    @Getter
    public static class GenerationConfig {
        /**
         * 답변의 형식을 'application/json'으로 고정하여, 제미나이가 반드시 JSON으로만 응답하게 만듭니다.
         */
        private final String response_mime_type = "application/json";

        /**
         * 우리가 원하는 JSON의 최종 구조(설계도)를 담는 필드입니다.
         */
        private final Schema response_schema;

        /**
         * 외부에서 전달받은 '설계도(Schema)'를 설정하는 생성자입니다.
         * @param schema ServiceImpl에서 동적으로 생성한, 우리가 원하는 JSON 구조.
         */
        public GenerationConfig(Schema schema) { this.response_schema = schema; }
    }

    /**
     * 원하는 JSON의 구조, 즉 '설계도'를 정의하는 가장 핵심적인 클래스입니다.
     * 이 클래스를 조합하여 어떤 복잡한 JSON 구조라도 만들어낼 수 있습니다.
     */
    @Getter
    public static class Schema {
        /**
         * 이 데이터의 종류를 정의합니다. (예: "STRING"은 글자, "OBJECT"는 객체, "ARRAY"는 리스트)
         * (필수)
         */
        private final String type;

        /**
         * 이 데이터가 무엇인지 제미나이가 이해하기 쉽도록 설명을 붙여줍니다. (결과 정확도 향상에 도움)
         * (선택 사항이지만 강력 추천)
         */
        private final String description;

        /**
         * 만약 type이 "OBJECT"일 경우, 이 객체가 어떤 하위 항목들을 갖는지 정의합니다.
         * (예: { "이름": "홍길동", "나이": 20 } 에서 "이름"과 "나이"에 대한 정의)
         * (type이 OBJECT일 때만 필요)
         */
        private final Map<String, Schema> properties;

        /**
         * 만약 type이 "ARRAY"일 경우, 이 리스트에 어떤 종류의 데이터들이 들어갈지 정의합니다.
         * (예: "추천 전략" 리스트에는 '글자(STRING)'들이 들어간다고 정의)
         * (type이 ARRAY일 때만 필요)
         */
        private final Schema items;

        /**
         * 만약 type이 "OBJECT"일 경우, 하위 항목들 중에서 "이것들은 반드시 포함해줘!"라고 지정하는 필수 항목 목록입니다.
         * (결과 안정성 향상에 도움)
         * (type이 OBJECT일 때 선택 사항)
         */
        private final List<String> required;

        /**

         * JSON 설계도(Schema) 객체를 만드는 생성자입니다.
         * 만들려는 JSON 구조에 따라 필요한 값만 넣고, 필요 없는 값은 null로 전달합니다.
         */
        public Schema(String type, String description, Map<String, Schema> properties, Schema items, List<String> required) {
            this.type = type;
            this.description = description;
            this.properties = properties;
            this.items = items;
            this.required = required;
        }
    }
}