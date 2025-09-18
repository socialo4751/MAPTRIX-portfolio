package kr.or.ddit.common.log;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.admin.stats.user.vo.LogUserEventVO;

@Mapper
public interface LogEventMapper {
    int insertLogUserEvent(LogUserEventVO vo);
}