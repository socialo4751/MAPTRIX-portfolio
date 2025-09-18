package kr.or.ddit.cs.qna.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;

@Mapper
public interface CsQnaPostMapper {

    /**
     * 전체 QnA 조회
     */
    List<CsQnaPostVO> selectAllQnas();

    /**
     * 페이징 처리된 QnA 목록 조회
     */
    List<CsQnaPostVO> selectQnasByPage(Map<String, Object> map);

    /**
     * 페이징용 전체 QnA 건수 조회
     */
    int selectQnaCount(Map<String, Object> map);

    /**
     * 단일 QnA 조회
     */
    CsQnaPostVO selectQnaById(@Param("quesId") int quesId);

    /**
     * 신규 QnA 등록
     */
    int insertQna(CsQnaPostVO qna);

    /**
     * QnA 수정
     */
    int updateQna(CsQnaPostVO qna);

    /**
     * 조회수 증가
     */
    void incrementViewCount(@Param("quesId") int quesId);

    /**
     * 카테고리별 QnA 조회
     */
    List<CsQnaPostVO> selectQnaByCategory(String catCodeId);

    void markQnaAsDeleted(int quesId);

    // 추가
    int selectQnaCountByAnsweredYn(@Param("answeredYn") String answeredYn);

    List<CsQnaPostVO> selectQnasByAnsweredYnPaged(Map<String, Object> params);

    void insertAnswer(CsQnaAnswerVO answer);

    void updateAnswer(CsQnaAnswerVO answer);

    void deleteAnswer(int ansId);

    CsQnaAnswerVO selectAnswerByQuesId(int quesId); // 조회용 (상세에서 답변 출력할 때 사용)

    Integer countUnanswered();

    List<Map<String, Object>> selectUnansweredTop5();
}
