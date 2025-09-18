package kr.or.ddit.openapi.apply.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.commonmark.node.Node;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.util.ArticlePage;
import kr.or.ddit.common.vo.openapi.ApiApplicationVO;
import kr.or.ddit.common.vo.openapi.ApiServiceVO;
import kr.or.ddit.openapi.apply.mapper.OpenApiMapper;
import kr.or.ddit.openapi.apply.service.OpenApiService;
import kr.or.ddit.openapi.apply.vo.MySubscriptionVO;

@Service
public class OpenApiServiceImpl implements OpenApiService {

    @Autowired
    private OpenApiMapper openApiMapper;

    @Override
    public List<ApiServiceVO> getApiList() {
        return openApiMapper.selectApiList();
    }

    @Override
    public ApiServiceVO getApiById(long apiId) {
        ApiServiceVO vo = openApiMapper.selectApiById(apiId);
        if (vo != null && vo.getRequestParamsDesc() != null) {
            Parser parser = Parser.builder().build();
            HtmlRenderer renderer = HtmlRenderer.builder().build();
            Node document = parser.parse(vo.getRequestParamsDesc());
            String html = renderer.render(document);
            vo.setRequestParamsDesc(html);
        }
        return vo;
    }

    @Override
    public int submitApplication(ApiApplicationVO applicationVO) {
        return openApiMapper.insertApplication(applicationVO);
    }
    
    @Override
    public ArticlePage<MySubscriptionVO> findMySubscriptionList(String userId, int currentPage, int size) {
        int total = openApiMapper.countMySubscriptions(userId);
        List<MySubscriptionVO> content;
        if (total > 0) {
            Map<String, Object> params = new HashMap<>();
            params.put("userId", userId);
            params.put("startRow", (currentPage - 1) * size + 1);
            params.put("endRow", currentPage * size);
            content = openApiMapper.selectMySubscriptionList(params);
            
            Parser parser = Parser.builder().build();
            HtmlRenderer renderer = HtmlRenderer.builder().build();
            for (MySubscriptionVO vo : content) {
                if (vo.getRequestParamsDesc() != null) {
                    Node document = parser.parse(vo.getRequestParamsDesc());
                    String html = renderer.render(document);
                    vo.setRequestParamsDescHtml(html); 
                }
            }
        } else {
            content = new ArrayList<>();
        }
        return new ArticlePage<>(total, currentPage, size, content, "", "");
    }
    
    @Override
    public ArticlePage<ApiApplicationVO> findMyApplicationsByStatus(String userId, String status, int currentPage, int size) {
        Map<String, Object> countParams = new HashMap<>();
        countParams.put("userId", userId);
        countParams.put("status", status);
        int total = openApiMapper.countMyApplications(countParams);

        List<ApiApplicationVO> content;
        if (total > 0) {
            Map<String, Object> listParams = new HashMap<>();
            listParams.put("userId", userId);
            listParams.put("status", status);
            listParams.put("startRow", (currentPage - 1) * size + 1);
            listParams.put("endRow", currentPage * size);
            content = openApiMapper.selectMyApplications(listParams);
        } else {
            content = new ArrayList<>();
        }
        return new ArticlePage<>(total, currentPage, size, content, "", "");
    }

    @Override
    public boolean hasActiveApplication(String userId, long apiId) {
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("apiId", apiId);
        int count = openApiMapper.countActiveApplicationOrSubscription(params);
        return count > 0;
    }
    
    @Override
    public List<ApiApplicationVO> selectMyApplicationsExceptApproved(String userId) {
        return openApiMapper.selectPendingAndRejectedApplications(userId);
    }

	@Override
	public List<MySubscriptionVO> findMySubscriptionList(String userId) {
		return this.findMySubscriptionList(userId, 1, 10).getContent();
	}
}