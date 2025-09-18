package kr.or.ddit.attraction.point.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.attraction.point.vo.StUserPointHistoryVO;

public interface PointService {

    /**
     * 사용자의 현재 총 포인트를 조회합니다.
     * @param params userId가 포함된 Map
     * @return 총 포인트
     */
    int getTotalPoint(Map<String, Object> params);

    /**
     * 사용자의 포인트 변경 이력을 조회합니다.
     * @param pointLog userId가 포함된 VO
     * @return 포인트 이력 목록
     */
    List<StUserPointHistoryVO> getPointHistory(StUserPointHistoryVO pointLog);

    /**
     * 이동 거리를 포인트로 정산(적립)하는 트랜잭션 처리를 수행합니다.
     * @param params 정산에 필요한 정보(userId, claimKm 등)가 담긴 Map
     * @return 적립된 포인트
     */
    int processPointClaim(Map<String, Object> params);

	int processPointStamp(Map<String, Object> params);
}
