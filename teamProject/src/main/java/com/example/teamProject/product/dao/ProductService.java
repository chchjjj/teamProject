package com.example.teamProject.product.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.teamProject.product.mapper.ProductMapper;
import com.example.teamProject.product.model.Product;

@Service
public class ProductService {

	@Autowired
	ProductMapper ProductMapper;
	
	// 상품 상세정보
	public HashMap<String, Object> getProInfo(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		Product info = ProductMapper.proInfo(map);
		resultMap.put("info", info);
		return resultMap;
	}
	// 상품 상위옵션
	public HashMap<String, Object> getTopOptList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.topOptList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 상품 상위+하위 옵션
	public HashMap<String, Object> getAllOptList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.allOptList(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 장바구니 리스트
	public HashMap<String, Object> getCartList(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			List<Product> list = ProductMapper.cart(map);			
			resultMap.put("list", list); 
			resultMap.put("result", "success");
		} catch (Exception e) {
			// TODO: handle exception
			resultMap.put("result", "fail");
			System.out.println(e.getMessage());
		}				
		return resultMap;
	}
	
	// 장바구니 삭제
	@Transactional
	public HashMap<String, Object> deleteCart(HashMap<String, Object> map) {
		// TODO Auto-generated method stub
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		int cnt1 = ProductMapper.deleteCartOpt(map);
		int cnt2 = ProductMapper.deleteCart(map);
		resultMap.put("result", "success");
		return resultMap;
		
	}
}
