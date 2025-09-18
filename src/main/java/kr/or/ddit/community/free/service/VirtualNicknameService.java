package kr.or.ddit.community.free.service;

public interface VirtualNicknameService {
	  /**
     * 사용자의 가상 닉네임을 조회하거나 신규 생성하는 메소드
     * @param userId 실제 유저 ID
     * @param roomId 입장할 채팅방 ID
     * @return 부여된 가상 닉네임
     */
    String getOrCreateVirtualNickname(String userId, Long roomId, String userRole);
}
