package kr.or.ddit.attraction.point.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.attraction.point.mapper.PointMapper; // ※ 신규 Mapper
import kr.or.ddit.attraction.point.service.PointService;
import kr.or.ddit.attraction.point.vo.StUserPointHistoryVO;
import lombok.extern.slf4j.Slf4j;

//(2025.08.10 장세진) 구조 리팩토링 => Stamp,Point,Flow,Apply 기능별 분리
//메소드로직과 url은 변경사항 없음.

@Slf4j
@Service
public class PointServiceImpl implements PointService {

    // ※ StampMapper 대신 Point와 관련된 쿼리만 모아둘 새로운 Mapper를 주입받습니다.
    @Autowired
    private PointMapper pointMapper;

    @Override
    public int getTotalPoint(Map<String, Object> params) {
        Integer totalPoint = pointMapper.getTotalPoint((String) params.get("userId"));
        return totalPoint != null ? totalPoint : 0;
    }

    @Override
    public List<StUserPointHistoryVO> getPointHistory(StUserPointHistoryVO pointLog) {
        return pointMapper.getPointLog(pointLog);
    }

    @Transactional
    @Override
    public int processPointClaim(Map<String, Object> params) {
        // StampServiceImpl의 processPoint 메서드 로직을 그대로 가져옴
        int pointsToAdd = (int) params.get("claimKm"); // 거리 1km당 1포인트로 가정

        // DB 저장을 위한 파라미터 설정
        params.put("pointsToAdd", pointsToAdd);
        params.put("description", "이동거리 정산");
        params.put("changeAmount", pointsToAdd);
        params.put("changeType", "WALK");
        
        log.info("포인트 정산 요청: {}", params);
        
        try {
            // 1. 사용자 포인트 업데이트
            pointMapper.updatePoint(params);
            log.info("1. 사용자 포인트 업데이트 완료.");

            // 2. 거리 정산 이력 추가
            pointMapper.insertDistanceClaim(params);
            log.info("2. 거리 정산 이력 추가 완료.");

            // 3. 포인트 변경 이력 추가 (업데이트 후 총 포인트를 조회하여 기록)
            Integer currentPoint = pointMapper.getTotalPoint((String) params.get("userId"));
            params.put("totalAfterPoint", currentPoint);
            pointMapper.insertPointHistory(params);
            log.info("3. 포인트 변경 이력 추가 완료.");
            
            log.info("--- [Transaction COMMIT] ---");
        } catch (Exception e) {
            log.error("포인트 정산 트랜잭션 실패. 롤백됩니다.", e);
            throw e; // 예외를 다시 던져 트랜잭션 롤백 유도
        }
        
        return pointsToAdd;
    }
    
    @Transactional
    @Override
    public int processPointStamp(Map<String, Object> params) {

        // DB 저장을 위한 파라미터 설정
        params.put("pointsToAdd", 1000);
        params.put("description", "스탬프정산");
        params.put("changeAmount", 1000);
        params.put("changeType", "STAMP");
        
        log.info("포인트 정산 요청: {}", params);
        
        try {
            // 1. 사용자 포인트 업데이트
            pointMapper.updatePoint(params);
            log.info("1. 사용자 포인트 업데이트 완료.");

            // 2. 포인트 변경 이력 추가 (업데이트 후 총 포인트를 조회하여 기록)
            Integer currentPoint = pointMapper.getTotalPoint((String) params.get("userId"));
            params.put("totalAfterPoint", currentPoint);
            pointMapper.insertPointHistory(params);
            log.info("2. 포인트 변경 이력 추가 완료.");
            
            log.info("--- [Transaction COMMIT] ---");
        } catch (Exception e) {
            log.error("포인트 정산 트랜잭션 실패. 롤백됩니다.", e);
            throw e; // 예외를 다시 던져 트랜잭션 롤백 유도
        }
        
        return 1000;
    }
}
