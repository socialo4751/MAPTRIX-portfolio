package kr.or.ddit.attraction.point.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.attraction.point.vo.StUserPointHistoryVO;


@Mapper
public interface PointMapper {

    /**
     * 사용자의 현재 총 포인트를 조회합니다.
     * @param userId 조회할 사용자 ID
     * @return 총 포인트
     */
    Integer getTotalPoint(String userId);

    /**
     * 사용자의 포인트 변경 이력을 조회합니다.
     * @param pointLog userId가 담긴 VO
     * @return 포인트 이력 목록
     */
    List<StUserPointHistoryVO> getPointLog(StUserPointHistoryVO pointLog);

    /**
     * 사용자의 st_user_point 테이블의 포인트를 업데이트(증가/차감)합니다.
     * @param params userId, pointsToAdd가 담긴 Map
     */
    void updatePoint(Map<String, Object> params);

    /**
     * 포인트 변경 이력(st_user_point_history)을 기록합니다.
     * @param params userId, changeAmount, description 등이 담긴 Map
     */
    void insertPointHistory(Map<String, Object> params);

    /**
     * 이동거리 정산 이력(st_distance_claim)을 기록합니다.
     * @param params userId, claimKm 등이 담긴 Map
     */
    void insertDistanceClaim(Map<String, Object> params);
}
