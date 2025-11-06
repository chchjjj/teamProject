package com.example.teamProject.seller.dao;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class JusoSearchService {

    @Value("${juso.api.key}")
    private String confmKey;

    @Value("${juso.api.url}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public String searchAddress(String keyword, int currentPage, int countPerPage) {
        try {
            String encodedKeyword = URLEncoder.encode(keyword, StandardCharsets.UTF_8.toString());

            URI uri = UriComponentsBuilder.fromUriString(apiUrl)
                    .queryParam("confmKey", confmKey)
                    .queryParam("currentPage", currentPage)
                    .queryParam("countPerPage", countPerPage)
                    .queryParam("keyword", encodedKeyword)
                    .queryParam("resultType", "json")
                    .build(true)
                    .toUri();

            System.out.println(">>> [JusoService DEBUG] 최종 API 요청 URL: " + uri);

            String response = restTemplate.getForObject(uri, String.class);
            return response;

        } catch (Exception e) {
            System.err.println(">>> [JusoService ERROR] 외부 API 통신 실패: " + e.getMessage());
            e.printStackTrace();
            return "{\"results\":{\"common\":{\"errorCode\":\"E999\",\"errorMessage\":\"백엔드 서비스 처리 오류\",\"totalCount\":\"0\"}}}";
        }
    }
}
