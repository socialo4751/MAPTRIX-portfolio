// kr.or.ddit.startup.service.impl.CheckServiceImpl.java
package kr.or.ddit.startup.test.service.impl;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.startup.test.mapper.TestMapper;
import kr.or.ddit.startup.test.service.TestService;
import kr.or.ddit.startup.test.vo.Test1SectionsVO;
import kr.or.ddit.startup.test.vo.Test2QuestionsVO;
import kr.or.ddit.startup.test.vo.Test3OptionsVO;

@Service
public class TestServiceImpl implements TestService {

    @Autowired
    private TestMapper testMapper;

    /**
     * 테스트 페이지에 필요한 모든 질문과 각 질문에 해당하는 보기 목록을 가져오는 메소드입니다.
     * @return 질문(Key)-보기목록(Value)으로 구성된 Map
     */
    @Override
    public Map<Test2QuestionsVO, List<Test3OptionsVO>> getTestQuestionsWithOptions() {
        Map<Test2QuestionsVO, List<Test3OptionsVO>> questionMap = new LinkedHashMap<>();
        
        // 1. DB에서 모든 질문 목록을 가져옵니다.
        List<Test2QuestionsVO> questions = testMapper.getQuestions();
        
        // 2. 각 질문을 순회하며, 해당 질문에 속한 보기 목록을 DB에서 가져와 Map에 저장합니다.
        for (Test2QuestionsVO question : questions) {
            List<Test3OptionsVO> options = testMapper.getOptions(question.getQuestionId());
            questionMap.put(question, options);
        }
        
        return questionMap;
    }
    
    /**
     * 사용자가 제출한 답안을 바탕으로 점수를 계산하고, 최종 결과 유형과 해당 설명을 판별하는 핵심 메소드입니다.
     * @param submittedAnswers Controller로부터 받은 사용자의 답변 Map (Key: "q_질문ID", Value: "선택한보기ID")
     * @return 결과 유형(type), 설명(desc), 각 영역별 점수, 그리고 결과 유형에 맞는 이미지 경로(imagePath)가 담긴 Map
     */
    @Override
    public Map<String, Object> calculateAndGetResult(Map<String, String> submittedAnswers) {
        
    	// 1. 제출된 답안을 정리하고, 점수 계산에 필요한 모든 데이터를 DB에서 가져와 빠른 조회를 위한 Map들을 준비합니다.
        //    - 사용자가 선택한 보기(option)의 ID들만 추출하여 리스트로 만듭니다.
        List<Integer> optionIds = submittedAnswers.values().stream()
                                    .map(Integer::parseInt)
                                    .collect(Collectors.toList());
        
        //    - 모든 질문, 사용자가 선택한 보기의 상세 정보, 모든 섹션 정보를 DB에서 가져옵니다.
        List<Test2QuestionsVO> allQuestions = testMapper.getQuestions();
        List<Test3OptionsVO> selectedOptions = testMapper.getOptionsByIds(optionIds);
        List<Test1SectionsVO> allSections = testMapper.getSections(); // 섹션 이름과 ID 매핑을 위해 사용

        //    - 선택된 보기의 ID를 키로, 해당 보기의 점수를 값으로 하는 Map을 생성하여 점수 조회를 효율화합니다.
        Map<Integer, Integer> scoreMap = selectedOptions.stream()
                                    .collect(Collectors.toMap(Test3OptionsVO::getOptionId, Test3OptionsVO::getOptionScore));

        //    - 질문 ID를 키로, 해당 질문이 속한 섹션 ID를 값으로 하는 Map을 생성하여 질문의 섹션을 빠르게 찾습니다.
        Map<Integer, Integer> questionToSectionMap = allQuestions.stream()
                                    .collect(Collectors.toMap(Test2QuestionsVO::getQuestionId, Test2QuestionsVO::getSectionId));
        
        //    - 섹션 이름(예: "시장 분석")을 키로, 실제 DB에 저장된 해당 섹션의 ID를 값으로 하는 Map을 생성합니다.
        //      이는 결과 유형 판별 로직에서 명시적인 섹션 이름으로 실제 DB ID를 조회하는 데 사용됩니다.
        Map<String, Integer> sectionNameToIdMap = allSections.stream()
            .collect(Collectors.toMap(Test1SectionsVO::getSectionName, Test1SectionsVO::getSectionId));
        
        // 2. 사용자가 제출한 답안을 기반으로 각 섹션(영역)별 총점을 계산합니다.
        //    - 각 섹션 ID를 키로, 해당 섹션에 속한 모든 질문의 점수 합계를 값으로 저장할 Map을 초기화합니다.
        Map<Integer, Integer> sectionScores = new HashMap<>(); 
        
        //    - 제출된 모든 답변(질문 ID와 선택된 보기 ID 쌍)을 순회합니다.
        for (String questionKey : submittedAnswers.keySet()) {
            // "q_질문ID" 형태의 키에서 질문 ID를 추출합니다. (예: "q_21"에서 21 추출)
            int questionId = Integer.parseInt(questionKey.substring(2));
            // 사용자가 해당 질문에 대해 선택한 보기의 ID를 가져옵니다.
            int optionId = Integer.parseInt(submittedAnswers.get(questionKey));
            
            // 미리 준비된 Map들을 활용하여 현재 질문이 속한 섹션의 실제 DB ID와 선택된 보기의 점수를 가져옵니다.
            int sectionId = questionToSectionMap.get(questionId);
            int score = scoreMap.get(optionId);
            
            // 해당 섹션의 누적 점수에 현재 보기의 점수를 더합니다.
            // 만약 해당 섹션 ID가 Map에 없으면 새로 추가하고, 있으면 기존 점수에 더합니다.
            sectionScores.merge(sectionId, score, Integer::sum);
        }
        
        // 3. 계산된 섹션별 총점을 변수에 할당하고, 해당 점수를 바탕으로 최종 결과 유형과 설명을 판별합니다.
        //    - 각 섹션의 실제 점수를 Map에서 가져오며, 만약 해당 섹션에 대한 점수가 없을 경우 0으로 처리합니다.
        //      이때 `sectionNameToIdMap`을 사용하여 "시장 분석"과 같은 명시적 이름에 해당하는 실제 DB 섹션 ID를 조회합니다.
        int market = sectionScores.getOrDefault(sectionNameToIdMap.get("시장 분석"), 0); 
        int plan = sectionScores.getOrDefault(sectionNameToIdMap.get("계획과 자금"), 0);   
        int pr = sectionScores.getOrDefault(sectionNameToIdMap.get("홍보와 고객"), 0);      
        int mindset = sectionScores.getOrDefault(sectionNameToIdMap.get("마음가짐과 위기관리"), 0); 

        //    - 최종 결과 유형, 설명, 그리고 유형에 맞는 이미지 경로를 저장할 변수를 선언합니다.
        String resultType = "";
        String resultDesc = "";
        String imagePath = ""; // 이미지 경로 변수

        //    - 정의된 조건 규칙에 따라 각 영역의 점수를 비교하여 최종 결과 유형과 설명을 결정하고,
        //      그에 맞는 대표 이미지의 경로를 설정합니다.
        if (market >= 8 && plan >= 8 && pr >= 8 && mindset >= 8) {
            resultType = "체계적인 전략가형🧑‍💼";
            resultDesc = "이미 많은 것을 알고 준비된 당신, 성공이 눈앞에 보입니다. 창업에 필요한 지식과 계획을 균형 있게 갖춘, 매우 준비된 예비 창업가입니다. 시장을 분석하는 눈과 구체적인 자금 계획, 리스크를 관리하는 마음가짐까지 안정적입니다. 다만, 때로는 세워둔 계획이 시장의 빠른 변화를 따라가지 못할 수도 있습니다. 현장에서 발생하는 예상치 못한 변수에 유연하게 대처하는 능력까지 갖춘다면, 실패의 위험이 매우 낮은 성공적인 창업을 이끌어갈 수 있을 것입니다.";
            imagePath = "/images/startup/test/Structured_Planner_Type.png";
        } else if (market >= 8 && pr >= 8 && plan <= 3) {
            resultType = "감각적인 아이디어형💡";
            resultDesc = "사람의 마음을 끄는 매력은 충분, 이제는 숫자로 증명할 때입니다. 트렌드를 읽고 고객의 시선을 사로잡는 감각이 매우 뛰어납니다. 어떻게 홍보해야 할지, 어떤 점이 고객에게 매력적으로 보일지 본능적으로 아는 능력이 있습니다. 하지만 이 멋진 아이디어를 현실로 만들기 위한 구체적인 재무 계획이나 비용 계산이 부족해 보입니다. 당신의 감각에 꼼꼼한 재무 관리 능력을 더하거나, 숫자에 밝은 파트너와 함께한다면 누구도 따라 할 수 없는 독보적인 브랜드가 될 것입니다.";
            imagePath = "/images/startup/test/Visionary_Idea_Type.png";
        } else if (plan >= 8 && mindset >= 8 && market <= 3 && pr <= 3) {
            resultType = "행동대장 해결사형👷";
            resultDesc = "강력한 실행력과 책임감, 어떤 프로젝트든 믿고 맡길 수 있습니다. 한번 목표를 정하면 반드시 계획을 세워 실행하고, 어떤 어려움에도 흔들리지 않는 책임감을 가졌습니다. 당신은 훌륭한 프로젝트 매니저의 자질을 갖추고 있습니다. 그러나 자칫하면 시장과 고객이 원하는 것이 아닌, '내가 잘할 수 있는 것'에만 집중할 위험이 있습니다. 당신의 강력한 실행력을 '고객이 원하는 방향'으로 향하게 한다면, 시장을 장악하는 리더가 될 수 있습니다.";
            imagePath = "/images/startup/test/Stable_Manager_Type.png";
        } else if (plan >= 8 && market >= 8 && pr <= 8) {
            resultType = "안정적인 관리자형📊";
            resultDesc = "돌다리도 두들겨보는 꼼꼼함, 망하지 않는 가게를 만들 수 있습니다. 자금 계획을 세우고 비용을 관리하는 능력이 뛰어나, 가게를 위험에 빠뜨리지 않고 꾸준히 운영할 힘이 있습니다. 하지만 안정성을 너무 추구한 나머지, 고객에게 먼저 다가가거나 시장의 새로운 기회를 포착하는 데는 소극적일 수 있습니다. 당신의 뛰어난 관리 능력에 시장의 목소리를 듣는 유연함을 더한다면, 오랫동안 사랑받는 가게를 만들 수 있을 것입니다.";
            imagePath = "/images/startup/test/Executive_Fixer_Type.png";
        } else if (mindset >= 9 && ((market <= 3 ? 1 : 0) + (plan <= 3 ? 1 : 0) + (pr <= 3 ? 1 : 0)) >= 2) {
            resultType = "고독한 승부사형🧗";
            resultDesc = "꺾이지 않는 마음은 최고의 자산, 이제 실력을 더할 때입니다. 어떤 어려움과 실패에도 다시 일어설 수 있는 강한 정신력을 가졌습니다. 창업이라는 긴 여정에서 가장 중요한 자질을 이미 갖추고 계십니다. 하지만 그 마음을 뒷받침해 줄 시장 분석, 자금 계획 등 실질적인 사업 역량은 아직 채워나갈 부분이 많아 보입니다. 당신의 그 강한 의지로 사업 실무 지식을 하나씩 정복해 나간다면, 어떤 위기도 기회로 만들 수 있을 것입니다.";
            imagePath = "/images/startup/test/Independent_Competitor_Type.png";
        } else if (market >= 4 && market <= 7 && plan >= 4 && plan <= 7 && pr >= 4 && pr <= 7 && mindset >= 4 && mindset <= 7) {
            resultType = "반짝이는 원석형💎";
            resultDesc = "균형 잡힌 당신, 이제 당신을 빛내줄 한 가지를 찾아보세요. 어느 한쪽으로 크게 치우치지 않은, 균형 잡힌 역량을 가지고 있습니다. 이는 어떤 방향으로든 발전할 수 있는 큰 잠재력을 의미합니다. 하지만 때로는 뚜렷한 강점이 없어 치열한 경쟁 시장에서 당신만의 색깔을 보여주기 어려울 수 있습니다. 여러 역량 중 당신이 가장 흥미를 느끼고 잘할 수 있는 분야 하나를 집중적으로 파고들어 '전문가' 수준으로 만든다면, 당신의 가치는 몇 배로 빛나게 될 것입니다.";
            imagePath = "/images/startup/test/Promising_Talent_Type.png";
        } else {
            resultType = "열정가득 탐색가형🌱";
            resultDesc = "열정은 이미 충분, 이제 빈칸을 하나씩 채워나갈 시간입니다. 창업에 대한 꿈과 열정은 누구에게도 뒤지지 않지만, 아직은 전반적인 경험과 구체적인 준비가 더 필요한 상황으로 판단됩니다. 고객과 시장에 대한 이해가 필요하고, 사업에 필요한 자금을 어떻게 마련하고 운영할지에 대한 계획을 세워야 합니다. 조급해할 필요는 없습니다. 이 테스트의 문항들을 체크리스트 삼아 하나씩 공부하고 준비해 나간다면, 당신의 뜨거운 열정은 가장 큰 성공의 원동력이 될 것입니다.";
            imagePath = "/images/startup/test/Passionate_Explorer_Type.png";
        }
        
        // 4. 최종 결과(유형, 설명, 이미지 경로)와 각 영역별 점수를 Map에 담아 Controller로 반환합니다.
        Map<String, Object> resultMap = new HashMap<>();        
        resultMap.put("type", resultType);
        resultMap.put("desc", resultDesc);
        resultMap.put("marketScore", market);
        resultMap.put("planScore", plan);
        resultMap.put("prScore", pr);
        resultMap.put("mindsetScore", mindset);
        resultMap.put("imagePath", imagePath); // 결과 Map에 이미지 경로 추가
        
        return resultMap;
    }
}