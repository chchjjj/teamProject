package com.example.teamProject.product.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.teamProject.main.model.Main;
import com.example.teamProject.product.model.Product;

@Mapper
public interface ProductMapper {
	
	Product proInfo(HashMap<String, Object> map);
	
	// 상위옵션
	List<Product> topOptList(HashMap<String, Object> map); 
	
	// 상위옵션+하위옵션
	List<Product> allOptList(HashMap<String, Object> map); 
	
	// 장바구니
	List<Product> cart(HashMap<String, Object> map);
	
	// 장바구니 삭제(1)
	int deleteCart(HashMap<String, Object> map);
	
	// 장바구니 삭제(2)
	int deleteCartOpt(HashMap<String, Object> map);
	
	// 장바구니 추가(장바구니 테이블)
	int insertCart(HashMap<String, Object> map);
	
	// 장바구니 추가(장바구니 옵션 테이블)
	int insertCartOpt(HashMap<String, Object> inputMap);
}
