package kr.or.ddit.cs.qna.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;

public interface CsQnaPostService {

    /** (기존) 전체 QnA 조회 */
    List<CsQnaPostVO> getQnaList();

    /** (NEW) 페이징 처리된 QnA 목록 조회
     *  @param map : "catCodeId", "startRow", "endRow" 키 사용
     *  @return QnA VO 리스트
     */
    List<CsQnaPostVO> getQnaList(Map<String, Object> map);

    /** (NEW) 페이징 처리용 총 QnA 건수 조회
     *  @param map : "catCodeId" 키 사용
     *  @return 전체 QnA 건수
     */
    int getQnaCount(Map<String, Object> map);

    /** (기존) 단일 QnA 조회 */
    CsQnaPostVO getQna(int quesId);

    /** (기존) 신규 QnA 등록 */
    void createQna(CsQnaPostVO qna);

    /** (기존) QnA 수정 */
    int modifyQna(CsQnaPostVO qna);

    /** (기존) 조회수 증가 (필요 없으면 제거) */
    void increaseViewCount(int quesId);

    /** (기존) 카테고리별 QnA 조회 */
    List<CsQnaPostVO> getQnaByCategory(String catCodeId);

    void removeQna(int quesId);
    
    void insertAnswer(CsQnaAnswerVO answer);

    void updateAnswer(CsQnaAnswerVO answer);

    void deleteAnswer(int ansId);

    CsQnaAnswerVO getAnswerByQuesId(int quesId);

    // 추가: 상태별 전체 건수 조회
    int getQnaCountByAnsweredYn(String answeredYn);

    // 추가: 상태별 페이징된 리스트 조회
    List<CsQnaPostVO> getQnaListByAnsweredYnPaged(Map<String,Object> params);
}
