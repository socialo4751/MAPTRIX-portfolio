package kr.or.ddit.admin.stats.market.geo;
// package: kr.or.ddit.admin.stats.market.mapper
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import kr.or.ddit.admin.stats.market.geo.GidIndexVO;

@Mapper
public interface GidIndexMapper {
    Optional<GidIndexVO> findByGridId(@Param("gid") String gid);
}
