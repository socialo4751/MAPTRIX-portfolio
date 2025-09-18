package kr.or.ddit.notification.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.notification.vo.UserNotifiedVO;

@Mapper
public interface NotificationMapper {

    /**
     * 새로운 알림을 DB에 추가합니다.
     * @param notificationVO 저장할 알림 정보
     * @return 성공 시 1 반환
     */
    int insertNotification(UserNotifiedVO notificationVO);

    /**
     * 특정 사용자의 최근 알림 목록을 조회합니다.
     * @param userId 회원 ID
     * @return 알림 목록 (List)
     */
    List<UserNotifiedVO> selectNotificationsByUserId(String userId);

    /**
     * 특정 사용자의 읽지 않은 알림 개수를 조회합니다.
     * @param userId 회원 ID
     * @return 안 읽은 알림 개수
     */
    int countUnreadNotificationsByUserId(String userId);

    /**
     * 특정 사용자의 모든 알림을 '읽음' 상태로 변경합니다.
     * @param userId 회원 ID
     * @return 업데이트된 행의 수
     */
    int markAllAsReadByUserId(String userId);
    
    /**
     * 지정된 ID의 알림 하나를 읽음 상태('Y')로 변경합니다.
     * @param notifyId 읽음 처리할 알림의 ID
     * @return 업데이트된 행의 수
     */
    int markAsRead(int notifyId);
    
    // ★ 추가: 본인 소유 알림만 안전하게 읽음 처리
    int markAsReadByIdAndUser(@Param("notifyId") int notifyId,
                              @Param("userId") String userId);

}
