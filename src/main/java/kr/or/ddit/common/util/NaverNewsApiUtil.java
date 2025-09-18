package kr.or.ddit.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI; // URL 대신 URI 사용
import java.net.URISyntaxException; // URI 예외 처리용
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.json.simple.JSONArray; // JSON 파싱을 위한 import 추가
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Component;

import kr.or.ddit.community.news.vo.CommNewsPostVO;
import lombok.extern.slf4j.Slf4j; // Slf4j 어노테이션 사용 시 추가

@Slf4j // 로그 사용을 위해 추가
@Component
public class NaverNewsApiUtil {

    private final String CLIENT_ID = "4qQPKYHXBA87CUDwzxjO";
    private final String CLIENT_SECRET = "kfvSIpg27Q";
    private final String API_URL = "https://openapi.naver.com/v1/search/news.json";

    public String fetchNewsFromBigkinds(String keyword) throws IOException {
        try {
            String encodedKeyword = URLEncoder.encode(keyword, "UTF-8");
            String apiURL = API_URL + "?query=" + encodedKeyword + "&display=10&start=1&sort=sim"; // display, start, sort 파라미터는 필요에 따라 조정

            URI uri = new URI(apiURL); // URI 사용
            HttpURLConnection con = (HttpURLConnection) uri.toURL().openConnection(); // URI를 URL로 변환
            con.setRequestMethod("GET");
            // !!! 여기에 따옴표를 추가해야 합니다 !!!
            con.setRequestProperty("X-Naver-Client-Id", CLIENT_ID); // 상수로 선언된 CLIENT_ID 사용
            con.setRequestProperty("X-Naver-Client-Secret", CLIENT_SECRET); // 상수로 선언된 CLIENT_SECRET 사용

            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == HttpURLConnection.HTTP_OK) { // 200 대신 HttpURLConnection.HTTP_OK 사용 권장
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }

            StringBuilder response = new StringBuilder();
            String inputLine;
            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();

            return response.toString();
        } catch (URISyntaxException e) {
            log.error("URI 구문 오류 - 키워드: {}", keyword, e);
            throw new IOException("URI 구문 오류: " + e.getMessage(), e);
        } catch (Exception e) {
            // 더 구체적인 로그 메시지 및 스택 트레이스 출력
            log.error("Naver News API 호출 실패 - 키워드: {}", keyword, e);
            throw new IOException("API 호출 실패: " + e.getMessage(), e);
        }
    }

    // JSON 응답을 CommNewsPostVO 리스트로 파싱하는 유틸리티 메서드
    public List<CommNewsPostVO> parseNaverNewsJson(String jsonResponse) throws ParseException {
        JSONParser parser = new JSONParser();
        JSONObject jsonObject = (JSONObject) parser.parse(jsonResponse);
        JSONArray items = (JSONArray) jsonObject.get("items");

        // 전통적인 for 루프를 사용하여 타입 안전성 확보
        List<CommNewsPostVO> newsList = new ArrayList<>();
        
        for (int i = 0; i < items.size(); i++) {
            JSONObject newsItem = (JSONObject) items.get(i);
            CommNewsPostVO newsVO = new CommNewsPostVO();

            String title = (String) newsItem.get("title");
            if (title != null) {
                title = title.replaceAll("<[^>]*>", "").replace("&quot;", "\"").replace("&apos;", "'").replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">");
            }
            String description = (String) newsItem.get("description");
            if (description != null) {
                description = description.replaceAll("<[^>]*>", "").replace("&quot;", "\"").replace("&apos;", "'").replace("&amp;", "&").replace("&lt;", "<").replace("&gt;", ">");
            }
            
            newsVO.setTitle(title);
            newsVO.setContent(description);
            newsVO.setLinkUrl((String) newsItem.get("link"));
            
            String link = (String) newsItem.get("link");
            String press = "알 수 없음";
            if (link != null && link.contains("://")) {
                try {
                    URI uri = new URI(link); // URI 사용
                    String host = uri.getHost();
                    if (host != null) {
                        if (host.startsWith("news.")) {
                            host = host.substring(5);
                        }
                        int dotIndex = host.lastIndexOf(".");
                        if (dotIndex != -1) {
                            host = host.substring(0, dotIndex);
                        }
                        int lastDot = host.lastIndexOf(".");
                        if (lastDot != -1) {
                             host = host.substring(0, lastDot);
                        }
                        press = host;
                    }
                } catch (URISyntaxException e) {
                    log.error("URI 파싱 오류: {}", link, e);
                }
            }
            newsVO.setPress(press);

            // 네이버 뉴스 API의 pubDate 형식: "Thu, 24 Jul 2025 16:30:00 +0900"
            String pubDateStr = (String) newsItem.get("pubDate");
            if (pubDateStr != null) {
                SimpleDateFormat sdf = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss Z", Locale.ENGLISH);
                try {
                    Date publishedAt = sdf.parse(pubDateStr);
                    newsVO.setPublishedAt(publishedAt);
                } catch (java.text.ParseException e) {
                    log.error("pubDate 파싱 오료: {}", pubDateStr, e);
                }
            }
            
            newsVO.setViewCount(0);
            newsVO.setIsDeleted("N");
            newsVO.setFileGroupNo(0);

            newsList.add(newsVO);
        }
        
        return newsList;
    }
}