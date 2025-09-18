package kr.or.ddit.common.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import lombok.Data;

@Data
public class ArticlePage<T> {
    private int total;         // 전체 글 수
    private int currentPage;   // 현재 페이지 번호
    private int size;          // 한 페이지당 글 수

    private int totalPages;    // 전체 페이지 수
    private int startPage;     // 페이지 블록 시작
    private int endPage;       // 페이지 블록 끝

    private String keyword;    // 검색어
    private String searchType;
    private String url;        // 리스트 요청 URL (예: "/cs/notice/list?catCodeId=101")

    private List<T> content;   // 현재 페이지 컨텐츠
    private String pagingArea; // 페이징 HTML
    
    public ArticlePage(int total, int currentPage, int size, List<T> content, String keyword) {
        this(total, currentPage, size, content, keyword, ""); // 새로운 생성자를 호출
    }

    public ArticlePage(int total,
                       int currentPage,
                       int size,
                       List<T> content,
                       String keyword,
                       String searchType) {
        this.total       = total;
        this.currentPage = currentPage;
        this.size        = size;
        this.content     = content;
        this.keyword     = (keyword == null ? "" : keyword);
        this.searchType = (searchType == null ? "" : searchType); // [추가]
        
        System.out.println(total);
        System.out.println(currentPage);
        System.out.println(size);
        System.out.println(content);
        System.out.println(keyword);
        System.out.println(searchType);

        calculatePages();
        // pagingArea 는 setUrl(...) 호출 시에 최종 빌드됩니다.
    }
    
    

    /** URL을 세팅하고, 이때 URL이 반영된 페이징 HTML을 생성합니다. */
    public void setUrl(String url) {
        this.url = url;
        buildPagingArea();
    }

    /** totalPages, startPage, endPage 계산 */
    private void calculatePages() {
        if (total == 0) {
            totalPages = startPage = endPage = 0;
        } else {
            // 1) 전체 페이지 수 계산
            totalPages = total / size + (total % size > 0 ? 1 : 0);

            // 2) currentPage가 totalPages보다 크면 마지막 페이지로 보정
            if (currentPage > totalPages) {
                currentPage = totalPages;
            }
            if (currentPage < 1) {
                currentPage = 1;
            }

            // 3) 블록 시작/끝 페이지 계산
            startPage = ((currentPage - 1) / 5) * 5 + 1;
            endPage   = Math.min(startPage + 4, totalPages);
        }
    }


    /** Bootstrap 5 스타일의 페이징 HTML 생성 */
    private void buildPagingArea() {
        String sep = url.contains("?") ? "&" : "?";
        String kw  = URLEncoder.encode(keyword, StandardCharsets.UTF_8);
        String st  = URLEncoder.encode(searchType, StandardCharsets.UTF_8);
        
        StringBuilder sb = new StringBuilder();
        sb.append("<div class='d-flex justify-content-center'>")
                .append("<nav><ul class='pagination pagination-sm mb-0'>");

        // '맨앞'
        sb.append("<li class='page-item")
                .append(currentPage == 1 ? " disabled'>" : "'>")
                .append("<a class='page-link' href='")
                .append(url).append(sep).append("currentPage=1")
                .append("&searchType=").append(st) // [추가]
                .append("&keyword=").append(kw)
                .append("'>맨앞</a></li>");

        // '이전(한 페이지)'
        sb.append("<li class='page-item")
                .append(currentPage == 1 ? " disabled'>" : "'>")
                .append("<a class='page-link' href='")
                .append(url).append(sep)
                .append("currentPage=").append(currentPage - 1)
                .append("&searchType=").append(st) // [추가]
                .append("&keyword=").append(kw)
                .append("'>이전</a></li>");

        // 페이지 번호
        for (int p = startPage; p <= endPage; p++) {
            if (p == currentPage) {
                sb.append("<li class='page-item active' aria-current='page'>")
                        .append("<span class='page-link'>").append(p).append("</span></li>");
            } else {
                sb.append("<li class='page-item'>")
                        .append("<a class='page-link' href='")
                        .append(url).append(sep).append("currentPage=").append(p)
                        .append("&searchType=").append(st) // [추가]
                        .append("&keyword=").append(kw)
                        .append("'>").append(p).append("</a></li>");
            }
        }

        // '다음(한 페이지)'
        sb.append("<li class='page-item")
                .append(currentPage == totalPages ? " disabled'>" : "'>")
                .append("<a class='page-link' href='")
                .append(url).append(sep)
                .append("currentPage=").append(currentPage + 1)
                .append("&searchType=").append(st) // [추가]
                .append("&keyword=").append(kw)
                .append("'>다음</a></li>");

        // '맨뒤'
        sb.append("<li class='page-item")
                .append(currentPage == totalPages ? " disabled'>" : "'>")
                .append("<a class='page-link' href='")
                .append(url).append(sep).append("currentPage=").append(totalPages)
                .append("&searchType=").append(st) // [추가]
                .append("&keyword=").append(kw)
                .append("'>맨뒤</a></li>");

        sb.append("</ul></nav></div>");

        this.pagingArea = sb.toString();
    }
}
