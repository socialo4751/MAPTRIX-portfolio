package kr.or.ddit.community.free.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NicknamePoolMapper {

    /**
     * 닉네임 풀에 있는 모든 닉네임 후보 목록을 조회합니다.
     * @return 전체 닉네임 리스트
     */
    List<String> findAllNicknames();
}
