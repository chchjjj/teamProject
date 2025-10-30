package com.example.teamProject.seller.dao;

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


}
