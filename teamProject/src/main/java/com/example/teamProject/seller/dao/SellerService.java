package com.example.teamProject.seller.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.teamProject.seller.mapper.SellerMapper;
import com.example.teamProject.seller.model.Seller;

@Service
public class SellerService {
	@Autowired
	SellerMapper sellerMapper;
	
	  //판매자 가게 리스트 불러오기
	  public HashMap<String, Object> getStoreList(HashMap<String, Object> map) {
		  HashMap<String, Object> resultMap = new HashMap<String, Object>();
			try {
				List<Seller> list = sellerMapper.selectStoreList(map);
				resultMap.put("list", list);
				resultMap.put("result", "success");
				System.out.println(resultMap);
			} catch (Exception e) {
				// TODO: handle exception
				resultMap.put("result", "fail");
				System.out.println(e.getMessage());
			}
			
			
			return resultMap;		
	  }
	  //월별 판매 리스트 불러오기
	  public List<Seller> getMonthlySalesByUser(String userId) {
		    HashMap<String, Object> paramMap = new HashMap<>();
		    paramMap.put("userId", userId); // Mapper XML에서 #{userId}와 매칭

		    try {
		        return sellerMapper.selectMonthlySalesByUser(paramMap);
		    } catch (Exception e) {
		        // 예외 처리: 로그 출력 및 빈 리스트 반환
		        System.err.println("월별 주문 통계 조회 중 오류 발생: " + e.getMessage());
		        e.printStackTrace();
		        return new ArrayList<>();
		    }
	  }
}
