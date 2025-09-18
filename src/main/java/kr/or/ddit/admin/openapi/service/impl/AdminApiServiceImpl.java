package kr.or.ddit.admin.openapi.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.admin.openapi.mapper.AdminApiServiceMapper;
import kr.or.ddit.admin.openapi.service.AdminApiService;
import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;

@Service
public class AdminApiServiceImpl implements AdminApiService {

    @Autowired
    private AdminApiServiceMapper adminApiServiceMapper;

    @Override
    public ArticlePage<ApiServiceVO> getApiServicePage(Map<String, Object> map) {
        // 1. 전체 행의 수를 구한다 (검색어 포함).
        int total = adminApiServiceMapper.selectApiServiceCount(map);

        // 2. 페이징 계산을 위한 값들을 준비한다.
        int size = 10; // 한 페이지에 보여줄 행의 수
        int currentPage = Integer.parseInt(map.get("currentPage").toString());
        String keyword = (String) map.get("keyword");

        // 3. Oracle ROWNUM 쿼리를 위한 시작/끝 레코드 번호를 계산하여 map에 추가한다.
        int firstRecord = (currentPage - 1) * size + 1;
        int lastRecord = currentPage * size;
        map.put("firstRecord", firstRecord);
        map.put("lastRecord", lastRecord);
        
        // 4. 계산된 페이징 정보가 담긴 map을 이용해 목록 데이터를 조회한다.
        List<ApiServiceVO> content = adminApiServiceMapper.selectApiServiceList(map);
        
        // 5. 최종적으로 ArticlePage 객체를 생성하여 컨트롤러에 반환한다.
        return new ArticlePage<>(total, currentPage, size, content, keyword);
    }

    @Override
    public ApiServiceVO getApiServiceById(long apiId) {
        return adminApiServiceMapper.selectApiServiceById(apiId);
    }

    @Override
    public int createApiService(ApiServiceVO apiServiceVO) {
        return adminApiServiceMapper.insertApiService(apiServiceVO);
    }

    @Override
    public int updateApiService(ApiServiceVO apiServiceVO) {
        return adminApiServiceMapper.updateApiService(apiServiceVO);
    }
}