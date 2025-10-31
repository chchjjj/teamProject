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
	  public HashMap<String, Object> getSellesChart(HashMap<String, Object> map) {
		    HashMap<String, Object> resultMap = new HashMap<>();
		    try {
		        // 입력값 콘솔 출력
		        System.out.println("입력 map: " + map);

		        // Mapper XML 호출
		        List<HashMap<String, Object>> list = sellerMapper.selectMonthlySales(map);

		        // 조회 결과 콘솔 출력
		        System.out.println("조회 결과 list: " + list);

		        resultMap.put("list", list);
		    } catch (Exception e) {
		        e.printStackTrace();
		        resultMap.put("error", "월별 매출 조회 중 오류 발생");
		    }
		    return resultMap;
		}
	  public HashMap<String, Object> getOrderList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	  }
}
