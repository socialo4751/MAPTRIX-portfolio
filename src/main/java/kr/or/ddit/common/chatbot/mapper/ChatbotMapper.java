package kr.or.ddit.common.chatbot.mapper;

import java.util.List; // List import 추가
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import kr.or.ddit.common.vo.code.CodeAdmDongVO;
import kr.or.ddit.common.vo.code.CodeBizVO;

@Mapper
public interface ChatbotMapper {

    List<CodeAdmDongVO> findAdmCodesByName(String dongName);

    List<CodeBizVO> findBizCodesByName(String bizName);
    
    Map<String, Object> selectDongStats(Map<String, Object> params);
    
    Map<String, Object> selectOverallStats(Map<String, Object> params);
}
