package kr.or.ddit.bizstats.keyword.service.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import kr.or.ddit.bizstats.keyword.dto.KeywordDto;

@Service
public class NaverApiService {

    // ▼▼▼▼▼▼ 여기에 발급받은 키와 ID를 입력하세요 ▼▼▼▼▼▼
    private final String apiKey = "01000000007e394270e692da752d1eb970ebaf672c19062a498cca54032a4ebf7aef51efe5";
    private final String secretKey = "AQAAAAB+OUJw5pLadS0euXDrr2cs44qo0mY8FoQ9y0czT93QKQ==";
    private final String customerId = "4085838";
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

    private final String BASE_URL = "https://api.searchad.naver.com";

    public List<KeywordDto> getRelatedKeywords(String keyword) throws Exception {
        String uri = "/keywordstool";
        String method = "GET";
        String timestamp = String.valueOf(System.currentTimeMillis());
        String signature = generateSignature(timestamp, method, uri, secretKey);

        String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8);
        String apiURL = BASE_URL + uri + "?hintKeywords=" + encodedKeyword + "&showDetail=1";

        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod(method);
        con.setRequestProperty("X-API-KEY", apiKey);
        con.setRequestProperty("X-Customer", customerId);
        con.setRequestProperty("X-Timestamp", timestamp);
        con.setRequestProperty("X-Signature", signature);

        int responseCode = con.getResponseCode();
        BufferedReader br;
        if (responseCode == 200) {
            br = new BufferedReader(new InputStreamReader(con.getInputStream()));
        } else {
            // 에러 발생 시 예외를 던져서 컨트롤러에서 처리
            throw new RuntimeException("API 응답 에러: " + responseCode);
        }

        String inputLine;
        StringBuilder response = new StringBuilder();
        while ((inputLine = br.readLine()) != null) {
            response.append(inputLine);
        }
        br.close();
        
        System.out.println("----------- Naver API 원본 응답 -----------");
        System.out.println(response.toString());
        System.out.println("-------------------------------------------");

        return parseAndMapToDto(response.toString());
    }

    private String generateSignature(String timestamp, String method, String uri, String secretKey) throws Exception {
        String message = timestamp + "." + method + "." + uri;
        SecretKeySpec signingKey = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(signingKey);
        byte[] rawHmac = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(rawHmac);
    }

    private List<KeywordDto> parseAndMapToDto(String jsonResponse) {
        List<KeywordDto> keywordList = new ArrayList<>();
        JSONObject jsonObject = new JSONObject(jsonResponse);

        if (!jsonObject.has("keywordList")) {
            return keywordList;
        }

        JSONArray jsonArray = jsonObject.getJSONArray("keywordList");

        for (int i = 0; i < jsonArray.length(); i++) {
            JSONObject item = jsonArray.getJSONObject(i);

            long pcSearchVolume = 0;
            Object pcQc = item.get("monthlyPcQcCnt");
            if (pcQc instanceof Number) {
                pcSearchVolume = ((Number) pcQc).longValue();
            }

            long mobileSearchVolume = 0;
            Object mobileQc = item.get("monthlyMobileQcCnt");
            if (mobileQc instanceof Number) {
                mobileSearchVolume = ((Number) mobileQc).longValue();
            }

            long totalVolume = pcSearchVolume + mobileSearchVolume;

            if (totalVolume > 0) {
                Map<String, String> customData = new HashMap<>();
                customData.put("pc", String.format("%,d", pcSearchVolume));
                customData.put("mobile", String.format("%,d", mobileSearchVolume));

                keywordList.add(new KeywordDto(
                        item.getString("relKeyword"),
                        totalVolume,
                        customData
                ));
            }
        }
        
        // 1. 검색량(value) 기준으로 내림차순 정렬
        keywordList.sort(Comparator.comparingLong(KeywordDto::getValue).reversed());

        // 2. 상위 20개만 선택하여 반환
        return keywordList.stream().limit(20).collect(Collectors.toList());
    }
}