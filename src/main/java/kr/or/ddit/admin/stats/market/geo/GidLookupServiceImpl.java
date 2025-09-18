package kr.or.ddit.admin.stats.market.geo;
import java.util.Optional;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GidLookupServiceImpl implements GidLookupService {
    private final GidIndexMapper mapper;

    @Override
    public Optional<GidIndexVO> findByGid(String gid) {
        if (gid == null || gid.isBlank()) return Optional.empty();
        return mapper.findByGridId(gid);
    }
}
	