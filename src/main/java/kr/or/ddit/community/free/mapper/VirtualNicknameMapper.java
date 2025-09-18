package kr.or.ddit.community.free.mapper;

import java.util.List;
import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.community.free.vo.VirtualNicknameVO;

@Mapper
public interface VirtualNicknameMapper {

    /**
     * 특정 유저가 특정 채팅방에서 사용하는 닉네임을 조회합니다.
     * @param userId 유저 ID
     * @param roomId 채팅방 ID
     * @return 존재하면 닉네임, 없으면 null
     */
    Optional<String> findNickname(@Param("userId") String userId, @Param("roomId") Long roomId);

    /**
     * 특정 채팅방에서 현재 사용 중인 모든 닉네임 목록을 조회합니다.
     * @param roomId 채팅방 ID
     * @return 사용 중인 닉네임 리스트
     */
    List<String> findUsedNicknamesInRoom(@Param("roomId") Long roomId);

    /**
     * 새로운 가상 닉네임 정보를 저장합니다.
     * @param vo 저장할 닉네임 정보 (userId, roomId, virtualNickname)
     */
    void save(VirtualNicknameVO vo);
}