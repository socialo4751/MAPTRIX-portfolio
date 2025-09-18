package kr.or.ddit.admin.stats.market.geo;
import java.util.Optional;

public interface GidLookupService {
    Optional<GidIndexVO> findByGid(String gid);
}
