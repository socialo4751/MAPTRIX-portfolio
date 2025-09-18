package kr.or.ddit.cs.qna.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.cs.qna.mapper.CsQnaPostMapper;
import kr.or.ddit.cs.qna.service.CsQnaPostService;
import kr.or.ddit.cs.qna.vo.CsQnaAnswerVO;
import kr.or.ddit.cs.qna.vo.CsQnaPostVO;
import kr.or.ddit.notification.service.NotificationService;
import kr.or.ddit.notification.vo.UserNotifiedVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CsQnaPostServiceImpl implements CsQnaPostService {

	private final CsQnaPostMapper qnaMapper;
	private final NotificationService notificationService;
	/*
	 * @Autowired public CsQnaPostServiceImpl(CsQnaPostMapper qnaMapper) {
	 * this.qnaMapper = qnaMapper; }
	 */

	/**
	 * 전체 QnA 조회
	 */
	@Override
	public List<CsQnaPostVO> getQnaList() {
		return qnaMapper.selectAllQnas();
	}

	/**
	 * 페이징 처리된 QnA 목록 조회
	 */
	@Override
	public List<CsQnaPostVO> getQnaList(Map<String, Object> map) {
		return qnaMapper.selectQnasByPage(map);
	}

	/**
	 * 페이징용 전체 QnA 건수 조회
	 */
	@Override
	public int getQnaCount(Map<String, Object> map) {
		return qnaMapper.selectQnaCount(map);
	}

	/**
	 * 단일 QnA 조회
	 */
	@Override
	public CsQnaPostVO getQna(int quesId) {
		return qnaMapper.selectQnaById(quesId);
	}

	/**
	 * 신규 QnA 등록
	 */
	@Override
	public void createQna(CsQnaPostVO qna) {
		qnaMapper.insertQna(qna);
	}

	/**
	 * QnA 수정
	 */
	@Override
	public int modifyQna(CsQnaPostVO qna) {
		return qnaMapper.updateQna(qna);
	}

	/**
	 * 조회수 증가
	 */
	@Override
	public void increaseViewCount(int quesId) {
		qnaMapper.incrementViewCount(quesId);
	}

	/**
	 * 카테고리별 QnA 조회
	 */
	@Override
	public List<CsQnaPostVO> getQnaByCategory(String catCodeId) {
		return qnaMapper.selectQnaByCategory(catCodeId);
	}

	@Override
	public int getQnaCountByAnsweredYn(String answeredYn) {
		// mapper 의 parameterType="string" 이기 때문에 바로 전달
		return qnaMapper.selectQnaCountByAnsweredYn(answeredYn);
	}

	@Override
	public List<CsQnaPostVO> getQnaListByAnsweredYnPaged(Map<String, Object> params) {
		// params: answeredYn, startRow, endRow
		return qnaMapper.selectQnasByAnsweredYnPaged(params);
	}

	/**
	 * 답변용 메소드 @
	 */

	@Override
	public void removeQna(int quesId) {
		qnaMapper.markQnaAsDeleted(quesId);
	}

	@Override
	public void updateAnswer(CsQnaAnswerVO answer) {
		qnaMapper.updateAnswer(answer);
	}

	@Override
	public void deleteAnswer(int ansId) {
		qnaMapper.deleteAnswer(ansId);
	}

	@Override
	public CsQnaAnswerVO getAnswerByQuesId(int quesId) {
		return qnaMapper.selectAnswerByQuesId(quesId);
	}

	/*
	 * ===알림 로직===
	 */
	@Override
	@Transactional
	public void insertAnswer(CsQnaAnswerVO answer) {
		// 1. 관리자 답변을 DB에 저장합니다.
		qnaMapper.insertAnswer(answer);
		log.info("새로운 Q&A 답변이 등록되었습니다. quesId: {}", answer.getQuesId());

		// 2. 답변이 달린 원본 질문 정보를 조회합니다. (알림 수신자 ID 확인 목적)
		CsQnaPostVO originalQuestion = qnaMapper.selectQnaById(answer.getQuesId());

		// 3. 질문 정보가 존재하고, 관리자가 자신의 글에 답변한 경우가 아닐 때 알림을 생성합니다.
		if (originalQuestion != null && !originalQuestion.getUserId().equals(answer.getAdminId())) {

			// --- ★★★★★ [수정] 알림 생성 및 전송 로직 ★★★★★ ---

			// 4. 알림 객체(UserNotifiedVO)를 생성하고 정보를 설정합니다.
			UserNotifiedVO notification = new UserNotifiedVO();
			notification.setUserId(originalQuestion.getUserId()); // 알림 받을 사람: 질문 작성자

			String message = "회원님의 1:1 문의에 답변이 등록되었습니다.";
			notification.setMessage(message);

			// 5. [중요] 알림 클릭 시 이동할 URL을 설정합니다.
			String url = "/cs/qna/detail?quesId=" + originalQuestion.getQuesId();
			notification.setTargetUrl(url);

			// 6. 알림 서비스를 호출하여 알림을 생성하고 실시간으로 발송합니다.
			notificationService.createNotification(notification);
			log.info("Q&A 답변 알림이 생성되었습니다. 수신자 ID: {}", originalQuestion.getUserId());
		}
	}
}