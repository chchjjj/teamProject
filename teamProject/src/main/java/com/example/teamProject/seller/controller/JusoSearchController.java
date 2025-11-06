package com.example.teamProject.seller.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.teamProject.seller.dao.JusoSearchService;

@RestController
@RequestMapping("/seller/api/juso")
public class JusoSearchController {

    @Autowired
    private JusoSearchService jusoSearchService;

    @GetMapping("/search")
    public ResponseEntity<String> searchAddress(
            @RequestParam("keyword") String keyword,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam(value = "countPerPage", defaultValue = "10") int countPerPage) {

        try {
            String jsonResult = jusoSearchService.searchAddress(keyword, currentPage, countPerPage);
            return new ResponseEntity<>(jsonResult, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            String errorJson = "{\"results\":{\"common\":{\"errorCode\":\"E999\",\"errorMessage\":\"서버 오류 발생\",\"totalCount\":\"0\"}}}";
            return new ResponseEntity<>(errorJson, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
